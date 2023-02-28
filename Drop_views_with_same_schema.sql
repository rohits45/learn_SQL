--This SQL will drop all the views which is present in entered schema

declare @sql varchar(8000)
,@view varchar(1000)
,@schema_name   varchar(1000)

--Enter Schema Name from which you want to delete all views
set @schema_name = 'Schema_Name'

--We can filter views using where conditions
while exists(select * from sys.views where schema_name(schema_id) = @schema_name)

begin
	select @view = 
	name from sys.views 
	where object_id in(select min(object_id) from sys.views where  schema_name(schema_id)  = @schema_name)

    set @sql = 'drop view [' + @schema_name + '].' + @view
	select 'view droped ' + @schema_name +'.'+ @view
    exec(@sql)
end