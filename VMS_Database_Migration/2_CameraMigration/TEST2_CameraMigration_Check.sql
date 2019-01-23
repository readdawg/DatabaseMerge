
--Create CameraCount Column in Gaining InsightEnt
USE InsightEnt
ALTER TABLE dbo.Cameras
ADD CameraStatus int,
oCameraID int,
oServerID int;
GO

--Create CameraCount Column in Donor InsightEnt
USE ToMergeVMS
ALTER TABLE dbo.Cameras
ADD CameraStatus int,
oCameraID int,
oServerID int;
GO

UPDATE ToMergeVMS.dbo.Cameras
SET CameraStatus = NULL


-- Check donor ServerID against existing ServerIDs In Gaining Table
USE ToMergeVMS
DECLARE @count int = 1
DECLARE @maxID int 

SET @maxID = (SELECT COUNT(*) FROM ToMergeVMS.dbo.Cameras)

WHILE @count <= @maxID

BEGIN

DECLARE @minCamID nvarchar(10) = (SELECT min(CameraID) FROM ToMergeVMS.dbo.Cameras WHERE CameraStatus IS NULL)
DECLARE @serverID nvarchar(10) = (SELECT min(ServerID) FROM ToMergeVMS.dbo.Cameras WHERE CameraStatus IS NULL)
DECLARE @cameraID nvarchar(10) = (SELECT cameraID FROM ToMergeVMS.dbo.Cameras WHERE CameraID = @minCamID)

DECLARE @sql NVARCHAR(max) = '

				IF NOT EXISTS (SELECT CameraID FROM InsightEnt.dbo.Cameras WHERE CameraID = ' + @cameraID + ')
					BEGIN				

						--Not Duplicate CameraID
						UPDATE ToMergeVMS.dbo.Cameras
						SET oCameraID = ' + @cameraID + ',
						oServerID = ' + @serverID + ',
						CameraStatus = 1 WHERE CameraID = ' + @cameraID +'
					END				

				ELSE

					-- Duplicate CameraID
					BEGIN
						UPDATE ToMergeVMS.dbo.Cameras
						SET oCameraID = ' + @cameraID + ',
						oServerID = ' + @serverID + ',
						CameraStatus = 2 WHERE CameraID = ' + @cameraID +'
					END				
				'			

EXEC (@sql)

SET @count = @count + 1
SET @minCamID = ''
SET @cameraID = ''
SET @serverID = ''

END

GO