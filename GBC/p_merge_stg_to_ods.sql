--drop procedure staging_area.p_merge_stg_to_ods
use staging_area--_NEOv1
go 


--CREATE procedure staging_area.p_merge_stg_to_ods
--(
--	@n_table int
--	, @dwh_queue_execution_log_id bigint
--	, @row_merged int output
--)
--as 
--begin
declare @Q1 nvarchar(max)
declare @table_name nvarchar(128)
declare @key_name nvarchar(128)
DECLARE @result INT;
declare @source_sch nvarchar(16) = 'staging_area'
declare @target_db nvarchar(16) = 'ods'
declare @target_sch nvarchar(16) = 'ods'
declare @Q1_fields_delim nvarchar(16)
declare @Q1_fields_str1 nvarchar(max)
declare @Q1_fields_str2 nvarchar(max)
declare @Q1_fields_str3 nvarchar(max)
declare @Q1_join_str0 nvarchar(max)
declare @Q1_join_str1 nvarchar(max)
declare @Q1_join_str2 nvarchar(max)

declare @n_table int = 0
declare @row_merged int


--begin try

select @Q1 = N'select distinct
	@table_name = TableName
from ' + @target_db +'.' + @target_sch + '.load_order
where OrderTable = '+ cast(@n_table+1 as nvarchar(max))

exec sp_executesql 
	@Q1, 
	N'@table_name nvarchar(128) OUTPUT, @key_name nvarchar(128) OUTPUT', 
	@table_name OUTPUT, @key_name OUTPUT;

select @table_name

select @Q1 = N'select @result=count(1) from ' + @source_sch + '.' + @table_name+ ' s0'

exec sp_executesql @Q1, N'@result INT OUTPUT', @result OUTPUT;

select @result

--if @result > 0
--begin
	select @Q1_fields_delim = ','
	select @Q1 = N'SELECT @Q1_fields_str1 = STRING_AGG(COLUMN_NAME,' + quotename(@Q1_fields_delim,'''') + ') 
	FROM INFORMATION_SCHEMA.COLUMNS s1
	join ' + @target_db + '.' + @target_sch + '.load_order s2 on s1.TABLE_NAME=s2.TableName and s1.COLUMN_NAME<>s2.ColumnName
	WHERE 
		1=1
		and s1.TABLE_NAME = ' + quotename(@table_name,'''') + '
		and s1.COLUMN_NAME not like '+ quotename('dwh_%_datetime','''')

	exec sp_executesql 
	@Q1, 
	N'@Q1_fields_str1 nvarchar(max) OUTPUT', 
	@Q1_fields_str1 OUTPUT;

	select @Q1_fields_str1

	select @Q1_fields_delim = ',Source.'
	select @Q1 = N'SELECT @Q1_fields_str2 = '+ quotename('Source.','''') + ' + STRING_AGG(COLUMN_NAME,' + quotename(@Q1_fields_delim,'''') + ') 
	FROM INFORMATION_SCHEMA.COLUMNS s1
	join ' + @target_db + '.' + @target_sch + '.load_order s2 on s1.TABLE_NAME=s2.TableName and s1.COLUMN_NAME<>s2.ColumnName
	WHERE 
		1=1
		and s1.TABLE_NAME = ' + quotename(@table_name,'''') + '
		and s1.COLUMN_NAME not like '+ quotename('dwh_%_datetime','''')

	exec sp_executesql 
	@Q1, 
	N'@Q1_fields_str2 nvarchar(max) OUTPUT', 
	@Q1_fields_str2 OUTPUT;

	select @Q1_fields_str2

	select @Q1_fields_str3 = replace(@Q1_fields_str2,'Source.','cte1.')

	select @Q1_fields_str3

	select @Q1 = N'select 
					 @Q1_join_str0 = STRING_AGG(ColumnName,'  + quotename(',','''') +  ')
				from ' + @target_db +'.' + @target_sch + '.load_order
				where OrderTable = '+ cast(@n_table+1 as nvarchar(max))

	select @Q1

	exec sp_executesql 
	@Q1, 
	N'@Q1_join_str0 nvarchar(max) OUTPUT', 
	@Q1_join_str0 OUTPUT;

	select @Q1_join_str0

	declare @al1 nvarchar(16) = 'cte1.'
	declare @al2 nvarchar(16) = 'cte2.'

	select @Q1 = N'select 
					 @Q1_join_str1 = STRING_AGG(@al1 + ColumnName + ' + quotename('=','''') + ' + @al2 + ColumnName,'  + quotename(' and ','''') +  ')
				from ' + @target_db +'.' + @target_sch + '.load_order
				where OrderTable = '+ cast(@n_table+1 as nvarchar(max))

	select @Q1

	exec sp_executesql 
	@Q1, 
	N'@al1 nvarchar(16), @al2 nvarchar(16), @Q1_join_str1 nvarchar(max) OUTPUT', 
	@al1, @al2, @Q1_join_str1 OUTPUT;

	select @Q1_join_str1 as Q1_join_str1

	select @Q1 = N'select 
					 @Q1_join_str2 = STRING_AGG(@al1 + ColumnName,'  + quotename(',','''') +  ')
				from ' + @target_db +'.' + @target_sch + '.load_order
				where OrderTable = '+ cast(@n_table+1 as nvarchar(max))

	select @Q1

	exec sp_executesql 
	@Q1, 
	N'@al1 nvarchar(16), @Q1_join_str2 nvarchar(max) OUTPUT', 
	@al1, @Q1_join_str2 OUTPUT;
	
	select @Q1_join_str2 as Q1_join_str2

	select @Q1 = N'
	drop table if exists #TMP_FOR_MERGE;
	with cte1 as (
		select
			' + @Q1_join_str0 + '
			, dwh_from_datetime
			, dwh_to_datetime
			,' + @Q1_fields_str1 + '
			, row_number() over (partition by ' + @Q1_join_str0 + ' order by dwh_from_datetime) as RN
		from ' + @source_sch + '.' + @table_name + '
	)
	select 
		' + @Q1_join_str2 + '
		, cte1.dwh_from_datetime
		, coalesce(DATEADD(SECOND, -1, cte2.dwh_from_datetime),' + quotename('2099-01-01 00:00:00.0000000 +00:00','''') + ') as dwh_to_datetime
		, ' + @Q1_fields_str3 + '
	into #TMP_FOR_MERGE
	from cte1 
	left join cte1 as cte2 on ' + @Q1_join_str1 + ' 
	and cte1.RN = cte2.RN-1
	'

	--MERGE INTO ' + @target_db + '.' + @target_sch + '.' + @table_name + ' AS Target
	--USING #TMP_FOR_MERGE AS Source
	--ON Target.' + @key_name + ' = Source.' + @key_name + ' and Target.dwh_from_datetime = Source.dwh_from_datetime

	--WHEN MATCHED THEN
	--	UPDATE SET Target.dwh_to_datetime = Source.dwh_to_datetime 
	 
	--WHEN NOT MATCHED BY TARGET THEN
	--	INSERT 
	--		(
	--		' + @key_name + '
	--		, dwh_from_datetime
	--		, dwh_to_datetime
	--		, ' + @Q1_fields_str1 + '
	--		) 
	--	VALUES 
	--		(
	--		Source.' + @key_name + '
	--		, Source.dwh_from_datetime
	--		, Source.dwh_to_datetime
	--		, ' + @Q1_fields_str2 + '
	--		) 
	--	;
	--select @row_merged = @@ROWCOUNT;
	--';

	select @Q1 as merge_str;

--	exec sp_executesql 
--	@Q1, 
--	N'@row_merged int OUTPUT', 
--	@row_merged OUTPUT;

--end

--end try

--begin catch 
--	DECLARE @error_message NVARCHAR(MAX),
--			@error_severity INT,
--			@error_state INT;
--	SELECT @error_message = ERROR_MESSAGE() ,
--		   @error_severity = ERROR_SEVERITY(),
--              @error_state = ERROR_STATE();
--	RAISERROR(@error_message, @error_severity, @error_state);

--	update [service_area].[service_area].[queue_execution_log]
--	set
--		dwh_layer_status = 'failure'
--		, dwh_layer_error_message_text = @error_message
--		, dwh_layer_execution_to_datetime = getdate()
--	where 
--	dwh_queue_execution_log_id = @dwh_queue_execution_log_id 
--	and dwh_layer_status='process'
--	;

--end catch

--end