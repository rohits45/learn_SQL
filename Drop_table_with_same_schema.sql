--This SQL will drop all the tables which is present in entered schema

declare @sql varchar(8000)
,@table varchar(1000)
,@schema_name   varchar(1000)

--Enter Schema Name from which you want to delete all tables
set @schema_name = 'Schema_Name'

--We can filter tables using where conditions
while exists(select * from sys.tables where schema_name(schema_id) = @schema_name)

begin
	select @table = name from sys.tables 
	where object_id in(select min(object_id) from sys.tables where  schema_name(schema_id)  = @schema_name)

    set @sql = 'drop table [' + @schema_name + '].' + @table
	select 'Table droped ' + @schema_name +'.'+ @table
    exec(@sql)
end