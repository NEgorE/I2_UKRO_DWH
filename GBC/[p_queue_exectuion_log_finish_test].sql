USE [service_area]
GO

/****** Object:  StoredProcedure [service_area].[p_queue_exectuion_log_finish_test]    Script Date: 26.10.2023 12:43:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--drop procedure [service_area].[p_queue_exectuion_log_finish_test]

CREATE procedure [service_area].[p_queue_exectuion_log_finish_test](
  @dwh_load_queue_id int
, @dwh_layer_step nvarchar(100) = null
, @dwh_layer_execution_to_datetime datetimeoffset = null
, @dwh_layer_status nvarchar(50) = null
, @dwh_queue_execution_log_id bigint 
, @dwh_layer_error_message_text nvarchar(max) = null
, @dwh_layer_row_count int = null


)

as
begin
set nocount on;

update service_area.queue_execution_log_test
set 
dwh_layer_execution_to_datetime = @dwh_layer_execution_to_datetime
, dwh_layer_status = @dwh_layer_status
, dwh_layer_row_count = @dwh_layer_row_count
, dwh_layer_error_message_text = @dwh_layer_error_message_text
where dwh_load_queue_id = @dwh_load_queue_id
and dwh_layer_step = @dwh_layer_step
and dwh_queue_execution_log_id = @dwh_queue_execution_log_id


end


GO


