USE [service_area]
GO

/****** Object:  StoredProcedure [service_area].[p_queue_get_task_count_test]    Script Date: 30.10.2023 10:48:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--DROP PROCEDURE [service_area].[p_queue_get_task_count_test]



CREATE procedure [service_area].[p_queue_get_task_count_test] ( 
  @dwh_queue_task_count int output
)
as
begin

/*
считаем количество записей в очереди
*/
SELECT @dwh_queue_task_count = count(1)
  FROM service_area.queue
  where dwh_queue_requested_status = 'wait'
  and dwh_layer_name = 'data_vault'

end;
GO


