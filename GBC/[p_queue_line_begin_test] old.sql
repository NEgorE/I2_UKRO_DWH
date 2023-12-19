USE [service_area]
GO

/****** Object:  StoredProcedure [service_area].[p_queue_line_begin_test]    Script Date: 18.10.2023 15:58:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE procedure [service_area].[p_queue_line_begin_test]
as
begin
set nocount on;

declare @dwh_load_queue_id_get int;

with sct1 as (
	select 
		*
		, ROW_NUMBER() over (order by dwh_load_queue_id) as rn
	from service_area.queue_test
	where dwh_queue_requested_status in ('start')
)
select
	@dwh_load_queue_id_get = dwh_load_queue_id
from sct1
where rn = 1
;

update service_area.queue_test 
set dwh_queue_requested_status = 'process'
, dwh_queue_from_datetime = getdate()
where dwh_load_queue_id = @dwh_load_queue_id_get--dwh_queue_requested_status in ('start')


--commit tran

end;
GO


