USE [service_area]
GO

/****** Object:  StoredProcedure [service_area].[p_queue_insert_data_vault]    Script Date: 11.11.2023 13:05:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--drop procedure [service_area].[p_queue_insert_data_vault]


CREATE procedure [service_area].[p_queue_insert_data_vault] (
    @dwh_schedule_id int = 1
    , @dwh_job_extraction_id uniqueidentifier = null
    , @dwh_job_serverexecution_id int = null
)
as
begin
set nocount on;
drop table if exists #tmp_ep_dv;

select ep.*
into #tmp_ep_dv
from service_area.execution_param ep
where ep.dwh_layer_name = 'data_vault'
	and ep.dwh_is_active_flag = 1
	and ep.dwh_schedule_id = @dwh_schedule_id
	and dwh_execution_param_id not in (select dwh_execution_param_id from [service_area].[queue] where dwh_queue_requested_status in ('wait','start','process','pause') and dwh_layer_name = 'data_vault')
;

insert into service_area.[queue] 
(dwh_execution_param_id, dwh_layer_name, dwh_queue_param_json, dwh_queue_inserted_datetime, dwh_queue_requested_status, dwh_queue_priority_number)
select 
dwh_execution_param_id
, dwh_layer_name
, dwh_execution_param_json as dwh_queue_param_json
, dwh_queue_inserted_datetime = getdate()
, dwh_queue_requested_status = 'wait'
, dwh_queue_priority_number = 1
from #tmp_ep_dv 
;
end;
GO


