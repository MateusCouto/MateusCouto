   -- FKS / PK de uma Tabela ( Relacionamento )
   SELECT
        'FK_Chave' = FK1.name,
        'Tabela_ChaveEstrangeira' = [tables_FK].name,
        'Referencia' = '--------------->',
        'PK_Chave' = PK.name,
        'Tabela_ChavePrimaria' = [tables_PK].name
    FROM
        sys.foreign_key_columns FK 
		INNER JOIN sys.all_columns FK1 ON FK.parent_object_id = FK1.object_id AND  FK.parent_column_id = FK1.column_id
        INNER JOIN sys.all_columns PK ON FK.referenced_object_id = PK.object_id AND  FK.referenced_column_id = PK.column_id
        INNER JOIN sys.tables [tables_FK] ON FK.parent_object_id = [tables_FK].object_id
		INNER JOIN sys.tables [tables_PK] ON FK.referenced_object_id = [tables_PK].object_id
    WHERE
        --[tables_FK].name in ('Table_Name', 'Table_Name02')
        [tables_PK].name = 'MPlaceProduto'



	-- Buscar Colunas / Tabelas Relacionamento
	SELECT 
		a.name as coluna,
		b.name as tabela
	FROM 
		sys.columns as a
		INNER JOIN sys.tables as b ON b.object_id = a.object_id  
	WHERE 
		b.name NOT LIKE('%tmp%')
		--And a.name LIKE('%Wages%') 
		--And b.name LIKE '%Employ%'
		And a.name LIKE '%IdPagamentoTipo%'
		--And b.name LIKE '%Email%'
	ORDER BY tabela


	-- Busca onde o comando usado Pode ser Procedure, View, SELECT
	SELECT * FROM sys.syscomments a WHERE a.text LIKE 'Produto'
