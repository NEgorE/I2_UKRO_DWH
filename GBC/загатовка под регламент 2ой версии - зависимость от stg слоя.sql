USE [service_area]
GO

with cte0  as (
select * from service_area.table_dependence
where 
	--procedure_name = 'p_hub_contract_acro'
	target_table_name = 'hub_contract'
	and active_flag = 1
)
, cte1 as (
select 
	dwh_execution_param_id
	, dwh_layer_name
	, dwh_execution_param_json as dwh_queue_param_json
	, JSON_VALUE(dwh_execution_param_json, '$.report_name') as dwh_target
	, JSON_VALUE(dwh_execution_param_json, '$.procedure') as dwh_proc_reload_target
from service_area.execution_param ep
where ep.dwh_layer_name = 'data_vault'
	and ep.dwh_is_active_flag = 1
	and ep.dwh_schedule_id = 1--@dwh_schedule_id
	and dwh_execution_param_id not in (select dwh_execution_param_id from [service_area].[queue] where dwh_queue_requested_status in ('wait','start','process','pause') and dwh_layer_name = 'data_vault')
)
select * from cte1
;