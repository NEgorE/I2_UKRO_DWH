USE [service_area]
GO

/****** Object:  StoredProcedure [service_area].[p_queue_line_begin_test]    Script Date: 23.10.2023 16:11:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE procedure [service_area].[p_queue_line_begin_test](
  @dwh_load_queue_id int
, @dwh_queue_from_datetime datetime =  null
)
as
begin
set nocount on;

if @dwh_queue_from_datetime is null

select @dwh_queue_from_datetime = getdate()

update service_area.queue_test
set dwh_queue_requested_status = 'process'
, dwh_queue_from_datetime = @dwh_queue_from_datetime
where dwh_load_queue_id = @dwh_load_queue_id
and dwh_queue_requested_status in ('start')


end;
GO


