
--Create CameraCount Column in Gaining InsightEnt
USE InsightEnt
ALTER TABLE dbo.Servers
ADD ServerStatus int,
oServerID int;
GO

--Create CameraCount Column in Donor InsightEnt
USE ToMergeVMS
ALTER TABLE dbo.Servers
ADD ServerStatus int,
oServerID int;
GO

UPDATE ToMergeVMS.dbo.Servers
SET ServerStatus = NULL


-- Check donor ServerID against existing ServerIDs In Gaining Table
USE ToMergeVMS
DECLARE @count int = 1
DECLARE @maxID int 

SET @maxID = (SELECT COUNT(*) FROM ToMergeVMS.dbo.Servers)

WHILE @count <= @maxID

BEGIN

DECLARE @minID int = (SELECT min(ServerID) FROM ToMergeVMS.dbo.Servers WHERE ServerStatus IS NULL)
DECLARE @serverID nvarchar(10) = (SELECT ServerID FROM ToMergeVMS.dbo.Servers WHERE ServerID = @minID)
DECLARE @minCamID nvarchar(10) = @minID

DECLARE @sql NVARCHAR(max) = '

				IF NOT EXISTS (SELECT ServerID FROM InsightEnt.dbo.Servers WHERE ServerID = ' + @serverID + ')
					BEGIN				

						UPDATE ToMergeVMS.dbo.Servers
						SET oServerID = ' + @ServerID + ',
						ServerStatus = 1 WHERE ServerID = ' + @serverID +'
					END				

				ELSE

					BEGIN
						UPDATE ToMergeVMS.dbo.Servers
						SET oServerID = ' + @ServerID + ',
						ServerStatus = 2 WHERE ServerID = ' + @serverID +'
					END				
				'			

EXEC (@sql)

SET @count = @count + 1
SET @minID = ''
SET @serverID = ''
--SET @qCount = ''

END

GO