USE [service_area]
GO

/****** Object:  StoredProcedure [service_area].[p_queue_get_line_data_vault_test]    Script Date: 20.10.2023 12:57:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE procedure [service_area].[p_queue_get_line_data_vault_test]
as
begin
set nocount on;

declare @start_ql int;

with cte1 as (
select
	qt.dwh_execution_param_id
	, dwh_queue_requested_status
from [service_area].[queue_test] qt
inner join
(select dwh_execution_param_id,max(dwh_queue_inserted_datetime) as  dt from [service_area].[queue_test] group by dwh_execution_param_id)
	dqdt on dqdt.dwh_execution_param_id=qt.dwh_execution_param_id and dqdt.dt = qt.dwh_queue_inserted_datetime
)
select 
	--@start_ql = 
	qt.dwh_load_queue_id,
	qt.dwh_execution_param_id,
	JSON_VALUE(qt.dwh_queue_param_json, '$.depend_on') as dep,--dwh_queue_param_json{"report_name":"sat_contract_buh3","procedure":"p_sat_contract_buh3","depend_on":"30000002"}
	cte1.dwh_queue_requested_status,
	ROW_NUMBER() over (order by qt.dwh_queue_inserted_datetime) as RN
into #cte2
from [service_area].[queue_test] qt
left join cte1 on  cte1.dwh_execution_param_id = JSON_VALUE(qt.dwh_queue_param_json, '$.depend_on')
where 
	qt.dwh_queue_requested_status = 'wait'
	and coalesce(cte1.dwh_queue_requested_status,'success') = 'success'
;
select 
	@start_ql = dwh_load_queue_id
from #cte2 where RN = 1
;


update  [service_area].[queue_test]
set dwh_queue_requested_status = 'start'
where dwh_load_queue_id = @start_ql

end;
GO


