--This SQL will Create Views on all the tables which is present in entered schema

declare @sql varchar(8000)
,@sql_delete varchar(8000)
,@table varchar(1000)
,@schema_name   varchar(1000)
,@id int
,@max int

--Enter Schema name in which you want to create views
set @schema_name = 'Schema_Name'

--We can filter tables using where conditions
select name 
,ROW_NUMBER() OVER (ORDER BY name) as name_id
into ##name_table
from sys.tables where schema_name(schema_id) = @schema_name

set @max = (select count(*) from ##name_table)
set @id = 1

while @max>=@id

begin
	select @table = name from ##name_table where name_id = @id

    set @sql = 'create view '+ @schema_name + '.vw_' + @table + ' as select * from '+ @schema_name + '.' + @table

	exec(@sql)
	select 'view created ' + @schema_name + '.vw_' + @table
	set @id = @id + 1
end

drop table ##name_table