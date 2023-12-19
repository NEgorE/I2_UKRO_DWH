USE ods_NEOv1
GO

/****** Object:  StoredProcedure [service_area].[p_queue_exectuion_log_begin]    Script Date: 08.12.2023 15:25:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE procedure ods.p_get_table_count 
(
	@rn_max int output
)
as

declare @Q1 nvarchar(max)
declare @target_db nvarchar(16) = 'ods_NEOv1'
declare @target_sch nvarchar(16) = 'ods'


select @Q1 = N'select @rn_max = max([order])
from ' + @target_db +'.' + @target_sch + '.load_order_tmp'

exec sp_executesql 
	@Q1, 
	N'@rn_max int output', 
	@rn_max OUTPUT;