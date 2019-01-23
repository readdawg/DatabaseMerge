
-- Check if ServerID was changed because it was a duplicate
USE ToMergeVMS
DECLARE @count int = 1
DECLARE @maxID int 

SET @maxID = (SELECT COUNT(*) FROM ToMergeVMS.dbo.Servers)

WHILE @count <= @maxID

BEGIN

DECLARE @newServerID nvarchar(10) = (SELECT min(ServerID) FROM ToMergeVMS.dbo.Servers WHERE ServerStatus = 3)
DECLARE @oldServerID nvarchar(10) = (SELECT min(oServerID) FROM ToMergeVMS.dbo.Servers WHERE ServerStatus = 3)

DECLARE @sql NVARCHAR(max) = '

				BEGIN

					UPDATE ToMergeVMS.dbo.Cameras
					SET ServerID = ' + @newServerID + ' WHERE ServerID = ' + @oldServerID + ';
					
					
					UPDATE ToMergeVMS.dbo.Servers
					SET ServerStatus = 4 WHERE ServerID = ' + @newServerID + ';
					

				END				
							
				'			
EXEC (@sql)

SET @count = @count + 1
SET @newServerID = ''
SET @oldServerID = ''

END

GO