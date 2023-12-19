/****** Script for SelectTopNRows command from SSMS  ******/
use staging_area_NEOv1
go

declare @Q1 nvarchar(max)
declare @rn int
declare @table_name nvarchar(32)
declare @key_name nvarchar(32)

select 
	@table_name = table_name
	, @key_name = key_name
from ods_NEOv1.ods.load_order_tmp
where [order] = 1

select @table_name, @key_name

select @rn = count(1)
from staging_area.wm_table_account s0

select @rn

if @rn > 0
begin
	with cte1 as (
		select
			account_id
			, dwh_from_datetime
			, row_number() over (partition by account_id order by dwh_from_datetime) as RN
		from staging_area.wm_table_account
		where 
			1=1
			and account_id = '4ef1a117-460d-4eb8-b146-1ef8398404d9'
	)
	select 
		* 
	from cte1 
	left join cte1 as cte2 on cte1.account_id=cte2.account_id and cte1.RN = cte2.RN-1
	;
end

--SELECT COLUMN_NAME
--FROM INFORMATION_SCHEMA.COLUMNS
--WHERE TABLE_NAME = @t_name;
