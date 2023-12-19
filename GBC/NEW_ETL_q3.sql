use [service_area]
go 

SELECT TOP (1000) *
  FROM [service_area].[queue_execution_log]
  order by 1 desc


use  [ods_NEOv1]
go

select * from ods_NEOv1.ods.wm_table_account
order by 7,1

select * from ods_NEOv1.[ods].[wm_table_client]
order by 7,1


/*
use staging_area_NEOv1
go 
exec staging_area.p_merge_stg_to_ods 0, 439674
*/
/*
use staging_area_NEOv1
go 
exec staging_area.p_merge_stg_to_ods 2 ,1000
*/

/*
delete from ods_NEOv1.ods.wm_table_account



delete from ods_NEOv1.[ods].[wm_table_client]
*/

