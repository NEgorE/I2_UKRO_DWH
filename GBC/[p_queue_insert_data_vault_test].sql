¸USE [service_area]
GO

/****** Object:  StoredProcedure [service_area].[p_queue_insert_data_vault_test]    Script Date: 18.10.2023 15:46:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE procedure [service_area].[p_queue_insert_data_vault_test] (
  @dwh_schedule_id int = 1
)
as
begin
set nocount on;
drop table if exists #tmp_ep_dv;

select ep.*
into #tmp_ep_dv
from service_area.execution_param_test ep
where ep.dwh_layer_name = 'data_vault'
	and ep.dwh_is_active_flag = 1
	and ep.dwh_schedule_id = @dwh_schedule_id
	and dwh_execution_param_id not in (select dwh_execution_param_id from [service_area].[queue_test] where dwh_queue_requested_status in ('wait','start','process','pause'))
;

insert into service_area.[queue_test] 
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


