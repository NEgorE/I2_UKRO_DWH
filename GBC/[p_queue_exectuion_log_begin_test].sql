USE [service_area]
GO

/****** Object:  StoredProcedure [service_area].[p_queue_exectuion_log_begin_test]    Script Date: 26.10.2023 19:52:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--drop procedure [service_area].[p_queue_exectuion_log_begin_test]
CREATE procedure [service_area].[p_queue_exectuion_log_begin_test]
(
  @dwh_load_queue_id int
, @dwh_execution_param_id int
, @dwh_layer_step nvarchar(100) = null
, @dwh_layer_execution_from_datetime datetimeoffset = null
, @dwh_thread_number int = null
, @dwh_extraction_id uniqueidentifier = null
, @dwh_serverexectuion_id int = null
, @dwh_object_name nvarchar(128) = null
, @dwh_queue_execution_log_id bigint output
)

as
begin
set nocount on;

INSERT INTO [service_area].[queue_execution_log_test]
           ([dwh_load_queue_id]
           ,[dwh_execution_param_id]
           ,[dwh_layer_step]         
           ,[dwh_layer_status]
           ,[dwh_layer_execution_from_datetime]
           ,[dwh_thread_number]
           ,[dwh_extraction_id]
           ,[dwh_serverexecution_id]
		   ,[dwh_object_name])

select 

dwh_load_queue_id = @dwh_load_queue_id
,dwh_execution_param_id = @dwh_execution_param_id
,dwh_layer_step = @dwh_layer_step
,dwh_layer_status = 'process'
,dwh_layer_execution_from_datetime = getdate()
--,dwh_layer_execution_to_datetime
--,dwh_layer_row_count
--,dwh_layer_error_message_text
,dwh_thread_number = @dwh_thread_number
,dwh_extraction_id = @dwh_extraction_id
,dwh_serverexecution_id = @dwh_serverexectuion_id
,dwh_object_name = @dwh_object_name
set @dwh_queue_execution_log_id = SCOPE_IDENTITY()


end
GO


