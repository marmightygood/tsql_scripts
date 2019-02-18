--Measure the size of the tables and partitions in a schema
SELECT 
	s.name SchemaName,
	t.name TableName,
	i.name IndexName,
	p.partition_number PartitionNumber,
	p.rows PartitionRowCount,
	ps.name PartitionSchemeName
FROM 
	sys.tables t
	LEFT JOIN sys.indexes i 
		ON t.OBJECT_ID = i.object_id
		--AND i.name =   'pk_'+ s.name+ '_' + t.name
	INNER JOIN sys.partitions p 
		ON i.object_id = p.OBJECT_ID
		AND i.index_id = p.index_id
	LEFT JOIN sys.schemas s 
		ON t.schema_id = s.schema_id
	LEFT JOIN sys.partition_schemes ps 
		ON i.data_space_id = ps.data_space_id
WHERE 
	t.NAME NOT LIKE 'dt%'
	AND t.is_ms_shipped = 0
	AND i.OBJECT_ID > 255
ORDER BY 
	s.name,
	t.name
