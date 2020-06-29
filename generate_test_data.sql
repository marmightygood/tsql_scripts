DROP PROCEDURE #INSERTESTDATA;
GO

/*

Procedure generates a single row of test data for a table and inserts it.

Run like this: EXEC #INSERTESTDATA 'dbo.Customer'

*/
CREATE PROCEDURE #INSERTESTDATA @FullTableName NVARCHAR(MAX)
AS
BEGIN
	DECLARE @TableName SYSNAME,
		@SchemaName SYSNAME,
		@LoremIpsum NVARCHAR(MAX),
		@Columns NVARCHAR(2000) = '',
		@Values NVARCHAR(MAX) = '',
		@Statement NVARCHAR(MAX);

	SET @SchemaName = LEFT(@FullTableName, CHARINDEX('.', @FullTableName) - 1)
	SET @TableName = SUBSTRING(@FullTableName, CHARINDEX('.', @FullTableName) + 1, 9999)

	IF OBJECT_ID(@SchemaName + '.' + @TableName) IS NULL
	BEGIN
		RAISERROR (
				'Target table does not exist',
				16,
				1
				)

		RETURN
	END

	SET @LoremIpsum = 
		'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent ut dui maximus, gravida massa vitae, imperdiet nunc. Curabitur vel augue gravida, ultricies urna nec, congue nulla. Nunc mollis lacinia sollicitudin. Fusce condimentum, elit eget sollicitudin rutrum, eros sem posuere orci, ac ullamcorper leo lacus id lorem. Suspendisse magna nisl, cursus sollicitudin ante ac, vehicula imperdiet mi. Fusce gravida et lectus eu porta. Nam tincidunt urna at lorem viverra pellentesque ac at est. Sed nec metus in tellus cursus tincidunt. Pellentesque placerat placerat justo, vulputate placerat velit euismod in. Maecenas viverra enim at fermentum luctus. Integer vel maximus orci, eu pellentesque magna. Nam quis tristique neque. Quisque feugiat augue nulla, et tristique urna dignissim vel. Praesent interdum sem ac purus fringilla, sit amet vulputate quam vestibulum.

	Curabitur aliquet dui massa, eget finibus risus bibendum ut. Vestibulum ac sapien leo. Donec ut est a dolor tincidunt faucibus. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Aliquam tincidunt a neque sit amet sagittis. Mauris lectus ligula, fermentum at faucibus eget, maximus nec metus. Integer orci felis, vulputate sit amet porta id, dignissim non metus. Morbi aliquet semper bibendum. Maecenas at erat neque. Morbi metus arcu, congue quis dolor quis, venenatis pharetra odio. Sed vitae ligula erat. Nullam elit velit, gravida vitae tristique vel, dapibus et nunc. Vivamus ac odio a lorem sollicitudin consequat eu et ipsum. Duis ex sem, vehicula laoreet mauris id, elementum blandit ex. Integer sed convallis ex. In facilisis massa id sem euismod, nec commodo odio tincidunt.
	Duis at volutpat nulla. Duis in ligula id nunc malesuada fermentum. Proin imperdiet congue quam, at sagittis mauris. Fusce convallis nisl id volutpat sollicitudin. Proin vulputate laoreet ligula, sed venenatis est dictum quis. Phasellus tincidunt nulla auctor scelerisque aliquam. Etiam id convallis purus.
	Vivamus pulvinar neque vitae dui viverra, id convallis dolor hendrerit. Aliquam erat volutpat. In eu facilisis ex. Donec a sapien ut tortor fringilla tristique. Duis consectetur a nisl id dictum. Etiam nunc tortor, mattis in metus eu, auctor tempus dui. Fusce tristique, odio sit amet consectetur aliquet, magna magna ullamcorper tellus, at posuere tellus mauris eu massa. Integer finibus interdum magna, sit amet tincidunt ligula euismod in.
	Integer tristique dapibus lobortis. Fusce tempor tortor in rhoncus feugiat. Donec lorem nunc, consectetur ac lobortis at, efficitur vel ligula. Vestibulum lobortis nisl nunc, a efficitur libero tristique at. Integer luctus sem quis enim maximus, in venenatis libero iaculis. In id fringilla lacus. In hac habitasse platea dictumst. Curabitur id dolor luctus, malesuada velit eget, laoreet quam. Vivamus consectetur, libero a pharetra varius, nisi mauris porttitor lorem, eget placerat tortor purus id odio. Nunc aliquet tortor non ipsum tincidunt, sed laoreet diam mattis. Mauris suscipit, eros a rhoncus consectetur, nulla sem tempus libero, nec tempor lorem velit non felis. Fusce suscipit nisl nulla, vel porttitor mi rutrum quis. Phasellus id felis eu nibh ultricies congue in sit amet nunc. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Duis quis felis tortor.
	Suspendisse rhoncus laoreet ex, in rutrum nulla facilisis sed. Nam quis massa laoreet, luctus justo eu, pulvinar lectus. Pellentesque quis laoreet mi, lobortis interdum mauris. Integer scelerisque hendrerit rhoncus. Donec id ipsum justo. Maecenas id tortor in sapien faucibus dictum vel vel magna. Sed augue nibh, dignissim sit amet euismod in, semper quis nisi. Morbi ornare sollicitudin dolor. Phasellus velit enim, mollis eget auctor eu, laoreet eget mauris. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec a efficitur massa. Nunc semper sem quis dolor varius, a congue diam pretium. Nam sed purus ipsum. Nunc et vestibulum nisi. Donec tempus vehicula augue eu sagittis. Mauris eu felis ante.
	Suspendisse potenti. Suspendisse potenti. Pellentesque at justo tempor, auctor mauris in, efficitur libero. Sed aliquam rutrum ex, aliquam mollis leo feugiat ac. Nunc ullamcorper accumsan neque, rutrum congue dui sodales in. Pellentesque cursus dolor eget urna lobortis, sed commodo arcu pretium. Duis aliquet pellentesque nisi, ut semper nunc sollicitudin et. Integer consectetur tortor quis nunc tincidunt, nec tincidunt nunc cursus. Curabitur faucibus finibus nisl, nec hendrerit purus luctus sit amet. Mauris id accumsan metus. Proin ullamcorper, metus sit amet auctor commodo, metus urna eleifend ex, non pellentesque enim urna eget ipsum. Etiam sapien sapien, facilisis quis eros at, posuere tincidunt ipsum.
	Nulla facilisi. Nullam eros lacus, sollicitudin nec molestie nec, consequat quis ante. Nullam eget erat tortor. Vivamus ac sodales massa. In blandit tortor in mauris mattis tincidunt. Fusce ac tellus placerat, aliquam elit at, pellentesque nibh. Suspendisse viverra sed odio non tempus. Vivamus pellentesque vehicula porttitor. Suspendisse potenti.
	Sed vitae lectus sit amet arcu faucibus faucibus et eget neque. Curabitur quis elementum turpis, a tincidunt tellus. Sed venenatis fermentum nisl et vestibulum. Nulla facilisi. Fusce ornare dui eu leo facilisis rutrum. Sed quis ante vulputate, imperdiet eros id, egestas felis. Cras vel sem ut enim pharetra fringilla id vel elit. Fusce volutpat risus ut accumsan euismod. Curabitur ac dui a magna fermentum congue at fringilla augue. Sed non sapien at est elementum ullamcorper eu eget justo. Curabitur ullamcorper leo id justo commodo mattis a quis erat.
	Fusce ut mollis quam. Fusce eu eros a nulla tempor ullamcorper eu sit amet erat. Donec vitae nulla arcu. Curabitur vitae dignissim nulla, sed sollicitudin ipsum. Phasellus ut leo lorem. Quisque efficitur nibh nec leo fermentum, ac pretium velit ornare. Nunc ultricies enim vitae ipsum lobortis, sed varius turpis scelerisque. Sed pellentesque venenatis elit, vitae volutpat nibh mattis maximus. Suspendisse volutpat neque dolor, nec finibus turpis consequat ullamcorper. Maecenas interdum aliquam magna sed lobortis.
	Phasellus consequat convallis condimentum. Cras sed gravida neque. Maecenas blandit ante eget ipsum viverra porta. Phasellus enim dolor, auctor semper velit et, tristique suscipit elit. Integer vulputate semper nisi nec pulvinar. Maecenas semper, odio eu malesuada egestas, nulla metus porta orci, in euismod eros metus sed enim. Etiam a luctus nunc.
	Sed vulputate urna diam, eget semper augue tincidunt et. Quisque auctor lobortis eros, suscipit semper felis malesuada eget. Duis vel pellentesque velit. Nam iaculis, felis sed dapibus hendrerit, orci risus aliquet nunc.'

	SELECT @Columns = name + N',' + @Columns
	FROM sys.columns
	WHERE OBJECT_ID = OBJECT_ID(@SchemaName + '.' + @TableName)
		AND generated_always_type = 0
		AND is_identity = 0
	ORDER BY columns.column_id ASC

	SELECT @Values = CASE 
			WHEN types.name IN (
					'VARCHAR',
					'NVARCHAR'
					)
				THEN '''' + CAST(SUBSTRING(@LoremIpsum, CAST(RAND(columns.column_id) * columns.max_length / 4 AS INT), CAST(RAND(columns.column_id) * columns.max_length / 2 AS INT)) AS VARCHAR(MAX)) + ''''
			WHEN types.name = 'INTEGER'
				THEN CAST(CAST(RAND(columns.column_id) * 1000 AS INT) AS VARCHAR(MAX))
			WHEN types.name = 'NUMERIC'
				THEN CAST(CAST(RAND(columns.column_id) * 1000 AS NUMERIC) AS VARCHAR(MAX))
			WHEN types.name = 'DECIMAL'
				THEN CAST(CAST(RAND(columns.column_id) * 1000 AS DECIMAL(5, 2)) AS VARCHAR(MAX))
			WHEN types.name = 'money'
				THEN CAST(CAST(RAND(columns.column_id) * 1000 AS DECIMAL(5, 2)) AS VARCHAR(MAX))
			WHEN types.name = 'UNIQUEIDENTIFIER'
				THEN '''' + CAST(NEWID() AS VARCHAR(1024)) + ''''
			WHEN Types.name IN (
					'DATE',
					'DATETIME',
					'DATETIME2'
					)
				THEN '''' + FORMAT(GETDATE(), 'yyyy-MM-dd hh:mm') + ''''
			ELSE ''''''
			END + N',' + @Values
	FROM sys.columns
	INNER JOIN sys.types
		ON columns.user_type_id = types.user_type_id
	WHERE OBJECT_ID = OBJECT_ID(@SchemaName + '.' + @TableName)
		AND generated_always_type = 0
		AND is_identity = 0
	ORDER BY columns.column_id ASC

	SET @Statement = '
	INSERT INTO  ' + QUOTENAME(@SchemaName) + '. ' + QUOTENAME(@TableName) + ' (
	' + LEFT(@Columns, LEN(@Columns) - 1) + '
	)
	VALUES (
	' + LEFT(@Values, LEN(@Values) - 1) + '
	)';

	SELECT CAST(@Statement AS XML)

	PRINT @Statement

	EXEC SP_EXECUTESQL @Statement
END
GO

