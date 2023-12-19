/****** Script for SelectTopNRows command from SSMS  ******/
use [staging_area_NEOv1]
go

select 
	*
	from [ods_NEOv1].[ods].[load_order_tmp]
	w

SELECT
      *
  FROM [staging_area].[wm_table_account]
where 
	1=1
	and [account_id] = '4ef1a117-460d-4eb8-b146-1ef8398404d9'
order by 1

insert into ods_NEOv1.[ods].[wm_table_account]
SELECT
      *
  FROM [staging_area].[wm_table_account]
where 
	1=1
	and [account_id] = '4ef1a117-460d-4eb8-b146-1ef8398404d9'
	and dwh_from_datetime = '2023-12-03 06:53:01'

SELECT
      [account_id],
	  count(1)
  FROM [staging_area].[wm_table_account]
  group by [account_id]
order by 2 desc

SELECT TOP (1000) [dwh_from_datetime]
      ,[dwh_to_datetime]
      ,[dwh_deleted_flag]
      ,[dwh_active_flag]
      ,[dwh_instance_id]
      ,[dwh_hash_key]
      ,[account_id]
      ,[dtype]
      ,[login]
      ,[password]
      ,[create_time]
      ,[change_time]
      ,[finish_time]
      ,[client_id]
      ,[last_name]
      ,[first_name]
      ,[middle_name]
      ,[gcm_instance_id]
      ,[notification_subscription]
      ,[root]
      ,[instance_id]
      ,[source]
      ,[system]
      ,[phone_number]
      ,[email]
      ,[file_info_id]
      ,[report_queue_size]
      ,[report_auto_download]
      ,[change_password]
      ,[account_status_id]
      ,[status_account_status_id]
      ,[status_account_id]
      ,[status_author_id]
      ,[status_type]
      ,[status_time]
      ,[status_note]
      ,[dwh_is_physical_deleted_flag]
      ,[dwh_is_logical_deleted_flag]
  FROM [staging_area_NEOv1].[staging_area].[wm_table_account]