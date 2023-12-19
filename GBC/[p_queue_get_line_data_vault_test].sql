USE [service_area]
GO

/****** Object:  StoredProcedure [service_area].[p_queue_get_line_data_vault_test]    Script Date: 27.10.2023 15:57:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





--drop procedure [service_area].[p_queue_get_line_data_vault_test]

CREATE procedure [service_area].[p_queue_get_line_data_vault_test]
(
@dwh_thread_number int
, @dwh_job_extraction_id_process uniqueidentifier
, @dwh_job_serverexecution_id_process int 
, @dwh_load_queue_id int output 
, @dwh_source_system_name nvarchar(16) output
, @dwh_layer_name nvarchar(16) output
)
as
begin
set nocount on;
SET XACT_ABORT ON;
BEGIN TRANSACTION;
with cte1 as (
select
	qt.dwh_execution_param_id
	, dwh_queue_requested_status
from [service_area].[queue] qt
inner join
(select dwh_execution_param_id,max(dwh_queue_inserted_datetime) as  dt from [service_area].[queue] where dwh_layer_name = 'data_vault' group by dwh_execution_param_id)
	dqdt on dqdt.dwh_execution_param_id=qt.dwh_execution_param_id and dqdt.dt = qt.dwh_queue_inserted_datetime and qt.dwh_layer_name = 'data_vault'
)
,cte2 as 
(
select
	qt.dwh_load_queue_id,
	qt.dwh_execution_param_id,
	value as dep,
	qt.dwh_queue_inserted_datetime,
	ins.dwh_system_name,
	qt.dwh_layer_name
from [service_area].[queue] qt
	cross apply STRING_SPLIT(JSON_VALUE(qt.dwh_queue_param_json, '$.depend_on'), ',')
	join service_area.execution_param ep on qt.dwh_execution_param_id = ep.dwh_execution_param_id and ep.dwh_layer_name = 'data_vault' and qt.dwh_layer_name = 'data_vault'
	left join service_area.instance_systems ins on ep.dwh_instance_id = ins.dwh_instance_id
where 
	dwh_queue_requested_status = 'wait'
)
,cte3 as (
select distinct
	qt.dwh_load_queue_id,
	--qt.dep,
	CASE WHEN qt.dep is null or qt.dep=''  then 'success' else cte1.dwh_queue_requested_status end as dep_status,
	dwh_system_name,
	dwh_layer_name
from cte2 qt
left join cte1 on  cte1.dwh_execution_param_id = qt.dep
)
,cte4 as (select 
	ct.dwh_load_queue_id
	, STRING_AGG(ct.dep_status,'|')  as aggr_status_dep/*
	, ct.dwh_system_name
	, ct.dwh_layer_name*/
from cte3 ct
group by ct.dwh_load_queue_id/*, ct.dwh_system_name, ct.dwh_layer_name*/
having STRING_AGG(dep_status,'|')= 'success'
)
--эту часть вставим в UNION
, cte_next_available_task as (
select
	ct.dwh_load_queue_id
	, qt.dwh_execution_param_id
	, isnull(ep.dwh_stage_table_id, 0) AS dwh_stage_table_id
	, isnull(ep.dwh_instance_id, 0) AS dwh_instance_id
    , qt.dwh_layer_name
	, isnull(qt.dwh_queue_priority_number, 1) AS dwh_queue_priority_number
    , qt.dwh_queue_inserted_datetime
    , qt.dwh_queue_requested_status
    , qt.dwh_thread_number
    , qt.dwh_job_extraction_id_process
    , qt.dwh_job_serverexecution_id_process
    , ins.dwh_system_name AS dwh_source_system_name
    , ROW_NUMBER() OVER (PARTITION BY qt.dwh_layer_name, isnull(ep.dwh_stage_table_id, 0) ORDER BY isnull(dwh_queue_priority_number, 1) DESC, qt.dwh_queue_inserted_datetime, qt.dwh_execution_param_id) AS rn
from cte4 ct
left join [service_area].[queue] qt on qt.dwh_load_queue_id = ct.dwh_load_queue_id
left join service_area.execution_param ep on qt.dwh_execution_param_id = ep.dwh_execution_param_id
left JOIN service_area.instance_systems AS ins ON ep.dwh_instance_id = ins.dwh_instance_id
),
cte_next_available_task_short
    AS     (SELECT *
            FROM   cte_next_available_task
            WHERE  rn = 1)
,next_available_task AS     (
SELECT   TOP 1 *
            FROM     cte_next_available_task_short AS nt
            WHERE    1 = 1
            ORDER BY dwh_queue_priority_number DESC, dwh_queue_inserted_datetime
)

update service_area.queue 
set dwh_queue_requested_status = 'start'
, dwh_thread_number = @dwh_thread_number
, dwh_job_extraction_id_process  = @dwh_job_extraction_id_process
, dwh_job_serverexecution_id_process = @dwh_job_serverexecution_id_process
, @dwh_load_queue_id = nt.dwh_load_queue_id
, @dwh_layer_name = nt.dwh_layer_name
, @dwh_source_system_name = dwh_source_system_name
from next_available_task nt 
join service_area.queue q on nt.dwh_load_queue_id = q.dwh_load_queue_id

COMMIT TRANSACTION;
end;
GO


