USE [service_area]
GO

/****** Object:  StoredProcedure [service_area].[p_dv_queue_process_test]    Script Date: 26.10.2023 19:41:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







--drop procedure [service_area].[p_dv_queue_process_test]
CREATE procedure [service_area].[p_dv_queue_process_test](
  @dwh_load_queue_id int
)
as
begin
set nocount on;

with cte1 as (
select 
	*
from [service_area].[queue_test]
where 
	dwh_load_queue_id = @dwh_load_queue_id 
)

select 
	dwh_load_queue_id
	, JSON_VALUE(dwh_queue_param_json, '$.procedure') as dwh_dv_proc_exec
into #cte3
from cte1
;

DECLARE @dwh_dv_proc_exec nvarchar(1000);

select 
	@dwh_load_queue_id = dwh_load_queue_id
	, @dwh_dv_proc_exec = 'data_vault.data_vault.'+dwh_dv_proc_exec
from #cte3;

begin try
	exec @dwh_dv_proc_exec;
end try
begin catch 
		DECLARE @error_message NVARCHAR(MAX),
				@error_severity INT,
				@error_state INT;
		SELECT @error_message = ERROR_MESSAGE() ,
			   @error_severity = ERROR_SEVERITY(),
               @error_state = ERROR_STATE();
		RAISERROR(@error_message, @error_severity, @error_state);

		update [service_area].[queue_execution_log_test]
		set
			dwh_layer_status = 'failure'
			, dwh_layer_error_message_text = @error_message
			, dwh_layer_execution_to_datetime = getdate()
		where dwh_load_queue_id = @dwh_load_queue_id and dwh_layer_status='process'
		;

end catch
end;
GO


