
/*****************************************

This script will generate another script 
that drops all non-clustered indexes and 
constraints from a table to prepare it for 
a clustered columnstore index. Wholly 
useless for any version of SQL other than
2014

*****************************************/



DECLARE @SCHEMA_NAME SYSNAME = '$(schema_name)';
DECLARE @NAME SYSNAME = '$(table_name)';
DECLARE @Code NVARCHAR(MAX) = ''

SELECT @Code += '
' + COALESCE('ALTER TABLE ' + OBJECT_SCHEMA_NAME(parent_object_id) + '.' + OBJECT_NAME(parent_object_id) + ' DROP CONSTRAINT ' + name, '') FROM sys.key_constraints WHERE OBJECT_NAME(parent_object_id) = @NAME;

SELECT @Code += '
' + COALESCE('ALTER TABLE ' + OBJECT_SCHEMA_NAME(parent_object_id) + '.' + OBJECT_NAME(parent_object_id) + ' DROP CONSTRAINT ' + name, '') FROM sys.foreign_keys WHERE OBJECT_NAME(parent_object_id) = @NAME;

SELECT @Code += '
' + COALESCE('DROP INDEX ' + name + ' ON ' + OBJECT_SCHEMA_NAME(object_id) + '.' + OBJECT_NAME(object_id), '')  FROM sys.indexes WHERE OBJECT_NAME(object_id) = @NAME;

/*
If the columnstore needs to be partitioned, this line will be required:
SELECT @Code += '
' + COALESCE('CREATE CLUSTERED INDEX CI_' + @SCHEMA_NAME + '_' + @NAME + ' ON ' + @SCHEMA_NAME + '.' + @NAME + '(TradingDateKey) ON $(partition_scheme) ($(partition_columns));', '')
*/

SELECT @Code += '
' + COALESCE('CREATE CLUSTERED COLUMNSTORE INDEX CI_' + @SCHEMA_NAME + '_' + @NAME + ' ON ' + @SCHEMA_NAME + '.' + @NAME + ' WITH (DROP_Existing=ON) --ON $(partition_scheme)($(partition_columns)) ', '')

PRINT @Code
