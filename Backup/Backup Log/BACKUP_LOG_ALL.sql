
-------------------------------------------------------------- |
-- Antes de execultar essa procedure, por favor leia o README  |
-- Before performing a procedure, please read the README       |
-------------------------------------------------------------- |

CREATE PROCEDURE [dbo].[BACKUP_LOG_ALL]          
AS          
          
DECLARE @NAME       VARCHAR(50) 
DECLARE @PATH       VARCHAR(256) 
DECLARE @FILENAME   VARCHAR(256) 
DECLARE @FILEDATE   VARCHAR(20) 
DECLARE @LOCAL      VARCHAR(MAX)
DECLARE @DATA       VARCHAR(20)
DECLARE @COMANDO    VARCHAR (8000)            
DECLARE @HORA       CHAR (6)           
DECLARE @DIA        VARCHAR(3)

SET LANGUAGE 'Portuguese'
SET @DATA = CONVERT(VARCHAR(20),GETDATE(),112)  
SET @HORA = REPLACE (CONVERT(VARCHAR(8),GETDATE(),108),':','')  
SET @PATH = 'E:\BackupDB\Backup_Log\'
SET @DIA  = CONVERT(VARCHAR(3),DATENAME(WEEKDAY,@DATA),103) 

DECLARE DB_CURSOR CURSOR FOR  
SELECT name 
FROM master.dbo.sysdatabases 
WHERE name  NOT IN ('master','msdb','tempdb','Model')           
-- WHERE name  IN ('DB01','DB02','DB03','DB04') 

OPEN DB_CURSOR   
FETCH NEXT FROM DB_CURSOR INTO @NAME   

WHILE @@FETCH_STATUS = 0   
BEGIN 
	SET @LOCAL = @PATH +@NAME+'\' + @NAME +'_LOG_'+RTRIM(UPPER(@DIA))+'_'+@HORA+'.bak'  
              
	BACKUP LOG @NAME
	TO DISK = @LOCAL              
	WITH name = @NAME,INIT
FETCH NEXT FROM DB_CURSOR INTO @NAME   
END   
 
CLOSE DB_CURSOR   
DEALLOCATE DB_CURSOR
GO


