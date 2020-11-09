
-------------------------------------------------------------- |
-- Antes de execultar essa procedure, por favor leia o README  |
-- Before performing a procedure, please read the README       |
-------------------------------------------------------------- |

CREATE  PROCEDURE  BACKUP_FULL_ALL                                
AS                                
                                
DECLARE @NAME       VARCHAR(50)                      
DECLARE @PATH       VARCHAR(256) 
DECLARE @LOCAL      VARCHAR(MAX) 
                      
SET @PATH = 'E:\BackupDB\Backup_Full\'      
                      
DECLARE DB_CURSOR CURSOR FOR                        
SELECT name                       
FROM master.dbo.sysdatabases                       
WHERE name  NOT IN ('master','msdb','tempdb','Model')           
-- WHERE name  IN ('DB01','DB02','DB03','DB04') 
    
OPEN DB_CURSOR                         
FETCH NEXT FROM DB_CURSOR INTO @NAME                         
                      
WHILE @@FETCH_STATUS = 0                         
                      
BEGIN                       
	SET @LOCAL = @PATH +@NAME+'\' + @NAME+'.bak'                        
                      
	BACKUP DATABASE @NAME                      
	TO DISK = @LOCAL                      
	WITH NAME = @NAME,INIT                         
                       
	FETCH NEXT FROM DB_CURSOR INTO @NAME                         
END                         
                      
CLOSE DB_CURSOR                         
DEALLOCATE DB_CURSOR 