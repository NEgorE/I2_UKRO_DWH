WITH XMLNAMESPACES 
('http://www.w3.org/2005/Atom' AS d)
SELECT top 100
	dwh_load_data_id,
	dwh_load_queue_id,
	dwh_data_string,
	case 
			when dwh_data_format = 'XML'
			then replace(cast(dwh_data_string as XML).value('(/d:feed/d:entry/d:category/@term)[1]','varchar(500)'),'StandardODATA.','')
			else 'xxx'
	end as lol1,
	case 
			when dwh_data_format = 'XML'
			then replace(cast(dwh_data_string as XML).value('(/d:feed/d:entry/d:id)[1]','varchar(500)'),'StandardODATA.','')
			else 'xxx'
	end as lol2
FROM [incoming_area].[incoming_area].[data_string] (nolock)
where 
	1=1
	--and dwh_data_format = 'XML'
	--and dwh_load_data_id = 1791027
	--and dwh_load_queue_id = 4639884--*/
	--and 
	/*	case 
			when dwh_data_format = 'XML'
			then replace(cast(dwh_data_string as XML).value('(/d:feed/d:entry/d:category/@term)[1]','varchar(500)'),'StandardODATA.','')
			else 'xxx'
		end = 'Catalog_Контрагенты_ИсторияКПП'
	 */
order by dwh_load_queue_id desc


--select * from  [incoming_area].[incoming_area].[data_string] (nolock)
--where dwh_load_data_id = 1909177 and dwh_load_queue_id = 4879249

/*dwh_load_data_id	dwh_load_queue_id
1909177	4879249   AccountingRegister_Хозрасчетный*/

--1909445	4879512 Catalog_Контрагенты

--1914666	4890315 Catalog_ДоговорыКонтрагентов


/*with cte1 as (
SELECT 
	cast(dwh_data_string as XML) as XML_STR
FROM [incoming_area].[incoming_area].[data_string] (nolock)
where 
	1=1
	--and dwh_data_format = 'XML'
	and dwh_load_data_id = 1791027
	and dwh_load_queue_id = 4629910
) 
select 
	--XML_STR.value('/feed[1]/@xmlns', 'varchar(255)')
	--XML_STR.query('/feed[1]/entry[1]/id[1]')
	XML_STR.value(, 'varchar(50)')
from cte1

*/

/*

dwh_load_data_id	dwh_load_queue_id
1591662	4199924
dwh_data_string
vehicle_terminal_id|vehicle_id|device_id|effective_date|expiration_date|author_id|create_time|last_success|last_fail|model|service_organization_name|phone_number|rnis_connection|imei 

select top 1 *, cast(dwh_data_string as XML) as XML_ST 
from [incoming_area].[incoming_area].[data_string] (nolock)
where 
	1=1
	--and dwh_data_format = 'XML'
order by dwh_load_queue_id desc*/