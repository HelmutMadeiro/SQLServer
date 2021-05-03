SELECT
    'select * into dbTablebancoBackup.dbo.'+t.NAME+' from dbbanco.dbo.'+t.NAME AS BkpEntidade
	,'drop table dbbanco.dbo.'+t.NAME as DropEntidades
	,s.name as [Schema]
    ,t.NAME AS Entidade
    ,p.rows AS Registros
    ,(SUM(a.total_pages) * 8) AS EspacoTotalKB
    ,(SUM(a.total_pages) * 8)/1024 AS EspacoTotalMB
    ,((SUM(a.total_pages) * 8)/1024)/1024 AS EspacoTotalGB
    ,SUM(a.used_pages) * 8 AS EspacoUsadoKB
    ,(SUM(a.used_pages) * 8)/1024 AS EspacoUsadoMB
    ,((SUM(a.used_pages) * 8)/1024)/1024 AS EspacoUsadoGB
    ,(SUM(a.total_pages) - SUM(a.used_pages)) * 8 AS EspacoNaoUsadoKB
  
    ,t.create_date
	,t.modify_date
FROM sys.tables t
INNER JOIN sys.indexes			i ON t.OBJECT_ID = i.object_id
INNER JOIN sys.partitions		p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id
INNER JOIN sys.allocation_units a ON p.partition_id = a.container_id
LEFT OUTER JOIN sys.schemas		s ON t.schema_id = s.schema_id
WHERE 
t.NAME NOT LIKE 'dt%' AND 
t.is_ms_shipped = 0 AND 
i.OBJECT_ID > 255 and 
year (t.modify_date) ='2020' -- ano de modificacao
GROUP BY t.Name, s.Name, p.Rows ,create_date ,modify_date
ORDER BY Registros DESC

