	SELECT 
		s.name,
		t.name,
		p.partition_number,
		p.rows,
		ps.name pfName
	FROM 
		sys.tables t
	INNER JOIN      
		sys.indexes i ON t.OBJECT_ID = i.object_id
	INNER JOIN 
		sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id
	LEFT OUTER JOIN 
		sys.schemas s ON t.schema_id = s.schema_id

	LEFT JOIN sys.partition_schemes ps on i.data_space_id = ps.data_space_id

	WHERE 
		t.NAME NOT LIKE 'dt%' 
		AND t.is_ms_shipped = 0
		AND i.OBJECT_ID > 255 
		and s.Name = 'Stage'
		AND EXISTS (SELECT 1 FROM sys.columns where name = 'ImportFileLogId' and columns.object_id = t.object_id) 
		AND EXISTS (SELECT 1 FROM sys.columns where name = 'SourceRowNum' and columns.object_id = t.object_id )
		AND EXISTS (SELECT 1 FROM sys.indexes where name = 'pk_stage_' + t.name)
		AND  ps.Name IS NULL
	ORDER BY 
		s.name,
		t.name
