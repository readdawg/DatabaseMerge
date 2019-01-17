
-- Change doror table ServerID where EXISTS in gaining table
USE VMSDatabase
DECLARE @count int = 1
DECLARE @maxID int 

SET @maxID = (SELECT COUNT(*) FROM VMSDatabase.dbo.Servers)

WHILE @count <= @maxID

BEGIN

DECLARE @minID int = (SELECT min(ServerID) FROM InsightEnt)
DECLARE @serverID nvarchar(10) = (SELECT ServerID FROM VMSDatabase.dbo.Servers)
DECLARE @minCamID nvarchar(10) = @minID
DECLARE @serverStatus nvarchar(1) = '0'
DECLARE @newServerID int = @minID - 1

DECLARE @sql NVARCHAR(max) = '

				IF @serverStatus == (SELECT ServerStatus FROM InsightEnt.dbo.Servers WHERE ServerID = ' + @serverID + ') 
					BEGIN
					   	
						UPDATE VMSDatabase.dbo.Servers
						SET ServerID = ' + @newServerID + ' WHERE oServerID = ' + @serverID +',
						ServerStatus = 1 WHERE ServerID = ' + @serverID +'
						GO

						UPDATE VMSDatabse.dbo.Servers
						SET ServerStatus = 3 WHERE ServerId = ' + @ServerID + '
					END					
				'			

EXECUTE (@sql)

SET @count = @count + 1
SET @minID = ''
SET @serverID = ''
SET @newServerID = ''

END

GO