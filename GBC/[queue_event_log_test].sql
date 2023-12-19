USE [service_area]
GO

/****** Object:  Table [service_area].[queue_event_log]    Script Date: 26.10.2023 12:07:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [service_area].[queue_event_log_test](
	[dwh_event_id] [int] IDENTITY(1,1) NOT NULL,
	[dwh_event_datetime] [datetime] NULL,
	[dwh_load_queue_id] [int] NULL,
	[dwh_queue_execution_log_id] [bigint] NULL,
	[dwh_object_name] [nvarchar](128) NULL,
	[dwh_event_type] [nvarchar](128) NULL,
	[dwh_event_code] [nvarchar](128) NULL,
	[dwh_event_message] [nvarchar](max) NULL,
	[dwh_event_comment] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


