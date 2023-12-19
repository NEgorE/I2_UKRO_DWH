USE [service_area]
GO
select 
	*
from service_area.execution_param ep
where ep.dwh_layer_name = 'data_vault'


select * from service_area.execution_param

exec [service_area].[p_queue_insert_data_vault_test];
exec [service_area].[p_queue_insert_data_vault];
select * from [service_area].[queue_test];
truncate table [service_area].[queue_test]
drop procedure  [service_area].[p_queue_insert_data_vault_test]

exec [service_area].[p_queue_get_line_data_vault_test];
select * from service_area.[queue_test] order by  dwh_load_queue_id desc;
update service_area.[queue_test]
update service_area.[queue]--_test]
	set dwh_queue_requested_status = 'wait'
	,dwh_queue_cancel_status_comment = null
	,dwh_queue_from_datetime = null
	,dwh_thread_number = null
	,dwh_job_extraction_id_process = null
	,dwh_job_serverexecution_id_process = null
where dwh_layer_name = 'data_vault'
where dwh_load_queue_id = 1
delete from service_area.[queue_test] where dwh_load_queue_id not in  (99,100,116)
drop procedure  [service_area].[p_queue_get_line_data_vault_test]

exec [service_area].[p_queue_line_begin_test];
select * from service_area.[queue_test] order by  dwh_load_queue_id desc;
drop procedure [service_area].[p_queue_line_begin_test]

exec [service_area].[p_dv_queue_process_test];
select * from service_area.[queue_test] order by  dwh_load_queue_id desc;
drop procedure [service_area].[p_dv_queue_process_test]



select * from [service_area].[queue_test]
order by --dwh_queue_from_datetime desc, 
dwh_load_queue_id desc

select * from [service_area].queue
where dwh_layer_name = 'data_vault'
order by --dwh_queue_from_datetime desc, 
dwh_load_queue_id desc
--exec [service_area].[p_dv_queue_process_test] 55


select *
from service_area.v_queue q
where dwh_load_queue_id = 3420397


select * from [service_area].[queue_execution_log_test] order by 1 desc

select TOP 1000 * from [service_area].[queue_execution_log]
where 
	1=1
	--AND dwh_layer_step='data_vault'
	AND dwh_layer_step='staging_area'
	--and dwh_load_queue_id = 4639884
order by 1 desc

/*select * from service_area.service_area.queue_event_log_test

select dwh_load_queue_id, count(dwh_queue_execution_log_id) from [service_area].[queue_execution_log_test] group by dwh_load_queue_id order by 2 desc


drop table service_area.queue_event_log_test

[Execute SQL Task] Error: Executing the query "exec parsing_area.p_dv_queue_process_test ?, outpu..." failed with the following error: "Parameter names cannot be a mixture of ordinal and named types.". Possible failure reasons: Problems with the query, "ResultSet" property not set correctly, parameters not set correctly, or connection not established correctly.
[Execute SQL Task] Error: Executing the query "exec service_area.p_dv_queue_get_param ?, ? output..." failed with the following error: "Invalid object name 'service_area.v_dv_queue'.". Possible failure reasons: Problems with the query, "ResultSet" property not set correctly, parameters not set correctly, or connection not established correctly.

[Execute SQL Task] Error: Executing the query "exec service_area.p_queue_line_finish ?, 'success'" failed with the following error: "Error converting data type varchar to int.". Possible failure reasons: Problems with the query, "ResultSet" property not set correctly, parameters not set correctly, or connection not established correctly.

[Execute SQL Task] Error: Executing the query "exec service_area.p_queue_line_finish ?, ?, 'succe..." failed with the following error: "Parameter names cannot be a mixture of ordinal and named types.". Possible failure reasons: Problems with the query, "ResultSet" property not set correctly, parameters not set correctly, or connection not established correctly.

*/