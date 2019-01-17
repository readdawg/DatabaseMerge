
-- Change doror table ServerID where EXISTS in gaining table
USE ToMergeVMS
DECLARE @count int = 1
DECLARE @maxID int 

SET @maxID = (SELECT COUNT(*) FROM ToMergeVMS.dbo.Servers)

WHILE @count <= @maxID

BEGIN

DECLARE @minID nvarchar(10) = (SELECT min(ServerID) FROM InsightEnt.dbo.Servers)
--DECLARE @oserverID nvarchar(10) = (SELECT oServerID FROM ToMergeVMS.dbo.Servers)
DECLARE @minServerID nvarchar(10) = (SELECT MIN(oServerID) FROM ToMergeVMS.dbo.Servers WHERE ServerStatus = 2)
DECLARE @serverStatus nvarchar(1) = '2'
DECLARE @nServerID int = @minID - 1
DECLARE @newServerID nvarchar(10) = @nServerID

DECLARE @sql NVARCHAR(max) = '

				IF ' + @serverStatus + ' = (SELECT ServerStatus FROM ToMergeVMS.dbo.Servers WHERE oServerID = ' + @minServerID + ') 
					BEGIN
					   	
						UPDATE ToMergeVMS.dbo.Servers
						SET ServerID = ' + @newServerID + ',
						ServerStatus = 3 WHERE ServerID = ' + @minServerID +'
						
					END					
				'			

EXEC (@sql)

SET @count = @count + 1
SET @minID = ''
--SET @oserverID = ''
SET @newServerID = ''

END

GO