use [ods]
go

declare @al1 nvarchar(16) = 'cte1.'
declare @al2 nvarchar(16) = 'cte2.'
declare @Q1_join_str1 nvarchar(max)
declare @Q1_join_str2 nvarchar(max)


--select 
--	 STRING_AGG(@al1 + ColumnName + '=' + @al2 + ColumnName,' and ') as join_exp
--from ods.load_order
--where OrderTable = 1


select         
	@Q1_join_str1 = STRING_AGG(@al1 + ColumnName + '=' + @al2 + ColumnName,' and ')     
	from ods.ods.load_order      
	where OrderTable = 1

	select @Q1_join_str1
	select         @Q1_join_str2 = STRING_AGG(@al1 + ColumnName,',')      from ods.ods.load_order      where OrderTable = 1
	select @Q1_join_str2





alter view ods.load_order as 
SELECT 
    t.name AS TableName,
    c.name AS ColumnName,
	ic.index_column_id AS ColumnPosition,
	DENSE_RANK() over (order by t.name) as OrderTable
FROM 
    sys.indexes i
INNER JOIN 
    sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
INNER JOIN 
    sys.tables t ON i.object_id = t.object_id
INNER JOIN 
    sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
WHERE 
	1=1
    AND i.is_primary_key = 1 
	and c.name <> 'dwh_from_datetime'
--order by 1,3
;



declare @db_system nvarchar(100)='ods'

-- КО STG
drop table if exists #KO_STG;
	select staging_table,
		staging_column,
		column_type = max(dv_column_type),
		PK_FK=max(PK_FK),
		stg_nullable= min (stg_nullable)
	into #KO_STG
	from service_area.service_area.dv_generate
	where dv_generate.dv_table like 'sat_%'
	and dv_generate.staging='staging'
	group by staging_table,	staging_column

/*Список таблиц в КО , которые обновились по аттрибутивному составву*/

drop table if exists #apdated_stg_tables
	select distinct #KO_STG.staging_table
	into #apdated_stg_tables
	from #KO_STG
	left join INFORMATION_SCHEMA.COLUMNS
	on #KO_STG.staging_table=[COLUMNS].table_name
	and #KO_STG.staging_column=[COLUMNS].column_name
	--and stg_ais_generate.column_type=UPPER([COLUMNS].DATA_TYPE)+'('+cast([COLUMNS].CHARACTER_MAXIMUM_LENGTH as nvarchar(500))+')' 
	where [COLUMNS].column_name is null 


/*Список таблиц в staging_area , которых нет в КО и их надо удалить*/

drop table if exists #for_delete_stg_tables
	select distinct [COLUMNS].table_name
	into #for_delete_stg_tables
	from #KO_STG
	right join INFORMATION_SCHEMA.COLUMNS
	on #KO_STG.staging_table=[COLUMNS].table_name
	and #KO_STG.staging_column=[COLUMNS].column_name
	where #KO_STG.staging_column is null and [COLUMNS].table_name not like 'hub_%'
	--select * from #for_delete_stg_tables

drop table if exists #dv_generate_distinct	
select staging_table
	,staging_column
	,PK_FK
	,column_type
	,column_number=ROW_NUMBER () over (partition by staging_table order by stg_nullable,PK_FK,staging_column )
	,nullable=stg_nullable
into #dv_generate_distinct
from #KO_STG
where 1=1 
--select * from #dv_generate_distinct where staging_table='acro_AccumulationRegister_ВыручкаИСебестоимостьПродаж_RecordType'
drop table if exists #cte 
select 
	staging_table
,column_list =  string_agg(cast (QUOTENAME(staging_column )as nvarchar (max)) + ' '+ column_type + case when nullable='0' then ' not null ' else '' end,',	') within group (order by column_number) 

,constraint_PK_index =  cast(
	'CONSTRAINT ' + QUOTENAME( 'PK_' + staging_table) + ' PRIMARY KEY CLUSTERED 
	(' +
	string_agg( case when PK_FK = 'PK'  and staging_column not like 'dwh_%'
	then
	QUOTENAME(staging_column)+ ' ASC'
	else null
	end ,',') within group (order by column_number)  +
	', [dwh_from_datetime] ASC	) ,	'  as nvarchar(max))

into #cte
from #dv_generate_distinct
where 1=1 
--and staging_table like 'wm_%'
group by staging_table
--select * from #cte

drop table if exists #tbl_gen_stg_table;
select  
stg_table_name = @db_system+'.[ods].' + quotename(staging_table) ,
stg_table_drop = 
	'begin try
	  drop table if exists ' + @db_system +'.[ods].' +  quotename(staging_table) + ';
	end try
	begin catch
	  select error_message() as errormessage;
	end catch
	',
stg_table_code = 
	'
	begin try
	create table '+@db_system+'.[ods].' + quotename(staging_table) + '
	(
	' + column_list + ' ,
	' + constraint_PK_index + ' 
	);
	end try
	begin catch
	  select error_message() as errormessage;
	end catch

	'
into #tbl_gen_stg_table
from #cte
where 1=1 
--and staging_table in (select staging_table from #apdated_stg_tables)    // Добавить если нужно не полное пересоздание stg таблиц, а лишь тех, которые не соответствуют КО
and column_list is not null and constraint_PK_index is not null
--select * from #tbl_gen_stg_table
------------------------------------------------------------------------------------------------------------------------------------------------------------

declare @stg_table_name nvarchar(1000), @stg_table_drop nvarchar(max), @stg_table_code nvarchar(max)
declare @cnt_error int;
set @cnt_error = 0;

declare my_cur CURSOR FOR
  select  stg_table_name, stg_table_drop, stg_table_code
  from #tbl_gen_stg_table

open my_cur
fetch next from my_cur into @stg_table_name,@stg_table_drop, @stg_table_code

while @@FETCH_STATUS = 0
begin
   --print @stg_table_name
   --print @stg_table_drop
   --print @stg_table_code
   begin try
   print @stg_table_name
	 exec sp_executesql @stg_table_drop
	 exec sp_executesql @stg_table_code
   end try
   begin catch
	select error_message() as errormessage;
	set @cnt_error = @cnt_error + 1;
	print @stg_table_name
    --print @stg_table_drop
    --print @stg_table_code
	select @stg_table_name,@stg_table_code
   end catch
  fetch next from my_cur into @stg_table_name, @stg_table_drop, @stg_table_code
end

close my_cur
deallocate my_cur

print concat('Кол-во ошибок: ', @cnt_error)

