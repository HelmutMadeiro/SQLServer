
-------------------------------------------------------------- |
-- Antes de execultar essa procedure, por favor leia o README  |
-- Before performing a procedure, please read the README       |
-------------------------------------------------------------- |

CREATE  PROCEDURE [dbo].[BACKUP_DIFF_ALL]
AS                
SET LANGUAGE 'Portuguese'
DECLARE @NAME       VARCHAR (50)  
DECLARE @PATH       VARCHAR (256) 
DECLARE @LOCAL      VARCHAR (MAX)     
DECLARE @DATA       VARCHAR (20)  
DECLARE @HORA       CHAR    (6)   
DECLARE @DIA        CHAR    (10)  

SET @DATA = CONVERT(VARCHAR(20),GETDATE(),112) -- Data atual       
SET @HORA = REPLACE (CONVERT(VARCHAR(8),GETDATE(),108),':','') -- Hora Atual        
SET @PATH = 'E:\BackupDB\Backup_Diff\'
SET @DIA  = CONVERT(VARCHAR(3),DATENAME(WEEKDAY,@DATA),103) -- dia da semana

DECLARE DB_CURSOR CURSOR FOR        
SELECT name       
FROM master.dbo.sysdatabases       
WHERE name  NOT IN ('master','msdb','tempdb','Model')           
-- WHERE name  IN ('DB01','DB02','DB03','DB04')     
OPEN DB_CURSOR         
FETCH NEXT FROM DB_CURSOR INTO @NAME         
     
WHILE @@FETCH_STATUS = 0         
BEGIN       
    
	SET @LOCAL = @PATH +@NAME+'\' + @NAME +'_DIFF_'+RTRIM(UPPER(@DIA))+'.bak'        
	
	BACKUP DATABASE @NAME      
	TO DISK = @LOCAL                    
	WITH name = @NAME,DIFFERENTIAL,NOFORMAT,NOINIT,SKIP,NOREWIND,NOUNLOAD

FETCH NEXT FROM DB_CURSOR INTO @NAME         
END         
     
CLOSE DB_CURSOR         
DEALLOCATE DB_CURSOR 
GO


