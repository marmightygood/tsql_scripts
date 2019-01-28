
/*****************************************

This script will generate a script that
drops all non-clustered indexes and 
constraints from a table to prepare it for 
a clustered columnstore index. Wholly 
useless for any version of SQL other than
2014

*****************************************/



DECLARE @SCHEMA_NAME SYSNAME = '<schema_name,varchar,dbo>';
DECLARE @NAME SYSNAME = '<table_name,varchar,my_table>)';
DECLARE @PartitionScheme = '<partition_scheme,varchar,PS_PartitionScheme>'
DECLARE @PartitioningColumns =  '<partition_columns,varchar,Id>'
DECLARE @Code NVARCHAR(MAX) = ''

SELECT @Code += '
' + COALESCE('ALTER TABLE ' + OBJECT_SCHEMA_NAME(parent_object_id) + '.' + OBJECT_NAME(parent_object_id) + ' DROP CONSTRAINT ' + name, '') FROM sys.key_constraints WHERE OBJECT_NAME(parent_object_id) = @NAME;

SELECT @Code += '
' + COALESCE('ALTER TABLE ' + OBJECT_SCHEMA_NAME(parent_object_id) + '.' + OBJECT_NAME(parent_object_id) + ' DROP CONSTRAINT ' + name, '') FROM sys.foreign_keys WHERE OBJECT_NAME(parent_object_id) = @NAME;

SELECT @Code += '
' + COALESCE('DROP INDEX ' + name + ' ON ' + OBJECT_SCHEMA_NAME(object_id) + '.' + OBJECT_NAME(object_id), '')  FROM sys.indexes WHERE OBJECT_NAME(object_id) = @NAME;


--If the columnstore needs to be partitioned, this line will be required:
SELECT @Code += '
' + COALESCE('CREATE CLUSTERED INDEX CI_' + @SCHEMA_NAME + '_' + @NAME + ' ON ' + @SCHEMA_NAME + '.' + @NAME + '(TradingDateKey) ON('+@PartitionScheme+'('+@PartitioningColumns+');', '')


SELECT @Code += '
' + COALESCE('CREATE CLUSTERED COLUMNSTORE INDEX CI_' + @SCHEMA_NAME + '_' + @NAME + ' ON ' + @SCHEMA_NAME + '.' + @NAME + ' WITH (DROP_Existing=ON) ON ' + @PartitionScheme + '(' + @PartitioningColumns + ')', '')

PRINT @Code
