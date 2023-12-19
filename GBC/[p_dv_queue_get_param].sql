USE [service_area]
GO

/****** Object:  StoredProcedure [service_area].[p_dv_queue_get_param]    Script Date: 30.10.2023 15:00:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--drop procedure [service_area].[p_dv_queue_get_param]



CREATE procedure [service_area].[p_dv_queue_get_param] (
  @dwh_load_queue_id int
, @dwh_report_name nvarchar(250) output
, @dwh_layer_param_json nvarchar(max) output
, @dwh_retry_count int output
, @dwh_retry_timeout_seconds int output
, @dwh_retrieval_retry_interval_seconds int output
, @dwh_instance_url nvarchar(250) output
, @dwh_exectuion_param_id int output
, @dwh_request_id nvarchar(100) output
, @dwh_instance_id int output
)
as
begin
set nocount on;

select

  @dwh_report_name = q.dwh_report_name
, @dwh_retry_count = dwh_retry_count
, @dwh_retry_timeout_seconds = dwh_retry_timeout_seconds  
, @dwh_retrieval_retry_interval_seconds = dwh_retrieval_retry_interval_seconds
, @dwh_instance_url = dwh_instance_url
, @dwh_exectuion_param_id = q.dwh_execution_param_id
, @dwh_layer_param_json = q.dwh_queue_param_json
, @dwh_request_id = q.dwh_request_id
, @dwh_instance_id = q.dwh_instance_id
from service_area.v_queue q
where dwh_load_queue_id = @dwh_load_queue_id


end;
GO


