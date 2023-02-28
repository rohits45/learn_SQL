--This SQL will Change the schema of table from old schema to new schema

declare @sql varchar(8000)
,@table varchar(1000)
,@oldschema varchar(1000)
,@newschema   varchar(1000)

--Enter Old schema name from which you want to move tables
set @oldschema = 'Old_Schema'

--Enter New schema name in which you want to add tables
set @newschema = 'New_Schema'

--We can filter tables using where conditions
while exists(select * from sys.tables where schema_name(schema_id) = @oldschema)

begin
	select @table = name from sys.tables 
	where object_id in(select min(object_id) from sys.tables where  schema_name(schema_id)  = @oldschema)

    set @sql = 'alter schema ' + @newschema + ' transfer [' + @oldschema + '].' + @table
	select 'Schema changed ' +  + @oldschema +  +' to '+ @newschema + ' for ' + @table
    exec(@sql)
end