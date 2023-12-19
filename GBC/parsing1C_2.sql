use [staging_area]
go

select * from [staging_area].[buh3_AccountingRegister_Хозрасчетный_BalanceAndTurnovers]


select top 100 * from [staging_area].[buh3_AccountingRegister_Хозрасчетный_RecordType]
where 
	1=1
	and Recorder_Type ='StandardODATA.Document_КорректировкаДолга'
	and Организация_Key = '7e5864bb-17b9-11e8-ba5c-005056010342'
	and Recorder = 'f52c096b-7950-11ee-a537-00155d025b78'
	--and AccountDr_Key = 'b054c370-17aa-11e8-ba5c-005056010342'
	--and AccountCr_Key = 'b054c370-17aa-11e8-ba5c-005056010342'
order by 1