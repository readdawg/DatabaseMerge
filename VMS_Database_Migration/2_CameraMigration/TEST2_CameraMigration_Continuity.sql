
-- Change doror table ServerID where EXISTS in gaining table
USE ToMergeVMS
DECLARE @count int = 1
DECLARE @maxID int 

SET @maxID = (SELECT COUNT(*) FROM ToMergeVMS.dbo.Cameras)

WHILE @count <= @maxID

BEGIN

DECLARE @minServerID int = (SELECT min(oServerID) FROM ToMergeVMS.dbo.Servers WHERE ServerStatus =2)
DECLARE @serverID nvarchar(10) = (SELECT ServerID FROM ToMergeVMS.dbo.Servers WHERE ServerStatus =2)
--DECLARE @minCamID nvarchar(10) = @minID
--DECLARE @serverStatus nvarchar(1) = '0'
--DECLARE @newServerID int = @minID - 1

DECLARE @sql NVARCHAR(max) = '
				
					BEGIN
					   	
						UPDATE ToMergeVMS.dbo.Cameras
						SET ServerID = ' + @ServerID + ' WHERE ServerID = ' + @MinServerID +',
						ToMergeVMS.dbo.Servers.ServerStatus = 3 WHERE ServerID = ' + @serverID +'
						GO

					END					
				'			

EXECUTE (@sql)

SET @count = @count + 1
SET @minID = ''
SET @serverID = ''
SET @newServerID = ''

END

GO