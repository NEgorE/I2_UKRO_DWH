USE [service_area]
GO

--select * from [service_area].[execution_param_test] order by 1 desc

INSERT INTO [service_area].[execution_param_test]
           ([dwh_execution_param_id]
           ,[dwh_instance_id]
           ,[dwh_layer_name]
           ,[dwh_execution_param_json]
           ,[dwh_is_active_flag]
           ,[dwh_stage_table_id]
           ,[dwh_update_type]
           ,[dwh_schedule_id]
           ,[dwh_load_priority_number]
           ,[dwh_retry_count]
           ,[dwh_retry_timeout_seconds]
           ,[dwh_retrieval_retry_interval_seconds]
           ,[dwh_retrieval_attempt_count])
     VALUES
           (30000020--<dwh_execution_param_id, int,>
           ,1999--<dwh_instance_id, int,>
           ,'data_vault'--<dwh_layer_name, nvarchar(16),>
           ,'{"report_name":"link_hub_unit_hub_contract","procedure":"p_link_hub_unit_hub_contract","depend_on":"30000007,30000001,30000002,30000003,30000004"}'--<dwh_execution_param_json, nvarchar(max),>
           ,1--<dwh_is_active_flag, bit,>
           ,null--<dwh_stage_table_id, int,>
           ,'scd2'--<dwh_update_type, nvarchar(16),>
           ,1--<dwh_schedule_id, int,>
           ,1--<dwh_load_priority_number, int,>
           ,null--<dwh_retry_count, int,>
           ,null--<dwh_retry_timeout_seconds, int,>
           ,null--<dwh_retrieval_retry_interval_seconds, int,>
           ,1--<dwh_retrieval_attempt_count, int,>
		   )
		   /*,(30000015--<dwh_execution_param_id, int,>
           ,1999--<dwh_instance_id, int,>
           ,'data_vault'--<dwh_layer_name, nvarchar(16),>
           ,'{"report_name":"sat_contract_slow_wm","procedure":"p_sat_contract_slow_wm","depend_on":"30000004"}'--<dwh_execution_param_json, nvarchar(max),>
           ,1--<dwh_is_active_flag, bit,>
           ,null--<dwh_stage_table_id, int,>
           ,'scd2'--<dwh_update_type, nvarchar(16),>
           ,1--<dwh_schedule_id, int,>
           ,1--<dwh_load_priority_number, int,>
           ,null--<dwh_retry_count, int,>
           ,null--<dwh_retry_timeout_seconds, int,>
           ,null--<dwh_retrieval_retry_interval_seconds, int,>
           ,1--<dwh_retrieval_attempt_count, int,>
		   )*/
GO


