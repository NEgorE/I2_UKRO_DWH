USE [service_area]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [service_area].[queue_execution_log_test](
	[dwh_queue_execution_log_id] [bigint] IDENTITY(1,1) NOT NULL,
	[dwh_load_queue_id] [int] NULL,
	[dwh_execution_param_id] [int] NULL,
	[dwh_layer_step] [nvarchar](100) NULL,
	[dwh_object_name] [nvarchar](128) NULL,
	[dwh_layer_status] [nvarchar](100) NULL,
	[dwh_layer_execution_from_datetime] [datetimeoffset](0) NULL,
	[dwh_layer_execution_to_datetime] [datetimeoffset](0) NULL,
	[dwh_layer_row_count] [int] NULL,
	[dwh_layer_error_message_text] [nvarchar](max) NULL,
	[dwh_thread_number] [int] NULL,
	[dwh_extraction_id] [uniqueidentifier] NOT NULL,
	[dwh_serverexecution_id] [int] NULL
) 
GO

