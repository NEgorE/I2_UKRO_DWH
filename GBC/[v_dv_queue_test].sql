USE [service_area]
GO

CREATE view [service_area].[v_dv_queue_test]
as
/*для задания нового запроса в incoming*/
select q.dwh_load_queue_id
, q.dwh_execution_param_id
, q.dwh_layer_name
, p.dwh_instance_id
, ins_sys.dwh_system_name
, q.dwh_queue_priority_number
, dwh_execution_param_last_loaded_number   --последний загруженный
		= case when q.dwh_queue_requested_status in ('success', 'failure')
						  then  row_number()  over (partition by q.dwh_execution_param_id,  q.dwh_layer_name, iif(q.dwh_queue_requested_status in ('success', 'failure'), 1, 0)
						              order by 
									  --JSON_VALUE(q.dwh_queue_param_json, '$.begin_datetime') desc, 
									  dwh_queue_from_datetime desc )  


			  -- when q.dwh_queue_requested_status in ('pause') then 0
			   else -1
		  end
, dwh_execution_param_min_wait_number --самый ранний в очереди
		= case 
       			when  q.dwh_queue_requested_status in ('wait')  
						then row_number() over (partition by q.dwh_execution_param_id, q.dwh_layer_name, iif(q.dwh_queue_requested_status = 'wait', 1, 0) 
						         -- , JSON_VALUE(q.dwh_queue_param_json, '$.begin_datetime'), JSON_VALUE(q.dwh_queue_param_json, '$.end_datetime')
											  order by dwh_queue_inserted_datetime  )  
			   else -1
		  end

, dwh_report_name = JSON_VALUE(q.dwh_queue_param_json, '$.report_name')
, dwh_request_period_from_datetime = JSON_VALUE(q.dwh_queue_param_json, '$.begin_datetime') 
, dwh_request_period_to_datetime = JSON_VALUE(q.dwh_queue_param_json, '$.end_datetime') 
, dwh_request_id = JSON_VALUE(q.dwh_queue_param_json, '$.request_id') 
, dwh_attempt_number = cast(JSON_VALUE(q.dwh_queue_param_json, '$.attempt_number') as int)
, p.dwh_schedule_id
, p.dwh_load_priority_number
, q.dwh_queue_inserted_datetime
, q.dwh_queue_from_datetime
, q.dwh_queue_to_datetime
, q.dwh_queue_requested_status
, dwh_source_system_name = ins_sys.dwh_system_name
, dwh_instance_name
, q.dwh_thread_number
, q.dwh_queue_param_json
, dwh_instance_url
, dwh_retry_timeout_seconds
, dwh_retry_count
, dwh_retrieval_retry_interval_seconds
, dwh_job_extraction_id
, dwh_job_serverexecution_id
, dwh_job_extraction_id_process
, dwh_job_serverexecution_id_process
, dwh_queue_cancel_status_comment
from service_area.queue_test q
 join service_area.execution_param_test p on q.dwh_execution_param_id = p.dwh_execution_param_id
 join service_area.instance_systems ins_sys on p.dwh_instance_id = ins_sys.dwh_instance_id

GO


