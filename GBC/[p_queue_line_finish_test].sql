USE [service_area]
GO

/****** Object:  StoredProcedure [service_area].[p_queue_line_finish]    Script Date: 23.10.2023 15:48:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [service_area].[p_queue_line_finish_test] (
  @dwh_load_queue_id int
, @dwh_queue_requested_status nvarchar(100)
)
as
begin

set nocount on;


	update service_area.queue_test
	set dwh_queue_requested_status = @dwh_queue_requested_status
	, dwh_queue_to_datetime = getdate()
	where dwh_load_queue_id = @dwh_load_queue_id

end;
GO


