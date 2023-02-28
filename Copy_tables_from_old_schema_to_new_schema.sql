--This SQL will Create tables in new schema using tables from old schema

declare @sql varchar(8000)
,@sql_delete varchar(8000)
,@table varchar(1000)
,@New_schema_name   varchar(1000)
,@old_schema_name   varchar(1000)
,@id int
,@max int

--Enter Old schema name from which you want to copy tables
set @old_schema_name = 'Old_Schema'

--Enter New schema name in which you want to add tables
set @New_schema_name = 'New_Schema'

--We can filter tables using where conditions
select name 
,ROW_NUMBER() OVER (ORDER BY name) as name_id
into ##name_table
from sys.tables where schema_name(schema_id) = @old_schema_name and name <> 'Staging_table_config'

set @max = (select count(*) - 1 from ##name_table)
set @id = 1

while @max>=@id

begin
	select @table = name from ##name_table where name_id = @id 

    set @sql = 
	'create Table '+ @New_schema_name + '.' + @table +  
	' WITH
	(
		DISTRIBUTION = ROUND_ROBIN,
		HEAP
	)
	as 
	select * from '+ @old_schema_name + '.' + @table 

	exec(@sql)
	select 'Table created ' + @New_schema_name + '.' + @table 
	set @id = @id + 1
end

drop table ##name_table