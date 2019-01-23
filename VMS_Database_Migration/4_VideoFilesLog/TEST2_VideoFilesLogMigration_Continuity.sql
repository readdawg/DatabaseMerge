
-- Check if ServerID or CameraID was changed because it was a duplicate
USE ToMergeVMS
DECLARE @count int = 1
DECLARE @maxID int 

SET @maxID = (SELECT COUNT(*) FROM ToMergeVMS.dbo.Servers)

WHILE @count <= @maxID

BEGIN

DECLARE @newServerID nvarchar(10) = (SELECT min(ServerID) FROM ToMergeVMS.dbo.Servers WHERE ServerStatus = 5)
DECLARE @oldServerID nvarchar(10) = (SELECT min(oServerID) FROM ToMergeVMS.dbo.Servers WHERE ServerStatus = 5)
DECLARE @newCameraID nvarchar(10) = (SELECT min(CameraID) FROM ToMergeVMS.dbo.Cameras WHERE CameraStatus = 4)
DECLARE @oldCameraID nvarchar(10) = (SELECT min(oCameraID) FROM ToMergeVMS.dbo.Cameras WHERE CameraStatus = 4)

DECLARE @sql NVARCHAR(max) = '

				BEGIN

					UPDATE ToMergeVMS.dbo.VideoFilesLog
					SET oServerID = ' + @newServerID + ' WHERE oServerID = ' + @oldServerID + ';					
					
					UPDATE ToMergeVMS.dbo.Servers
					SET ServerStatus = 6 WHERE ServerID = ' + @newServerID + ';

					
					UPDATE ToMergeVMS.dbo.VideoFilesLog
					SET oCameraID = ' + @newCameraID + ' WHERE oCameraID = ' + @oldCameraID + ';					
					
					UPDATE ToMergeVMS.dbo.Cameras
					SET CameraStatus = 6 WHERE CameraID = ' + @newCameraID + ';

				END				
							
				'			
EXEC (@sql)

SET @count = @count + 1
SET @newServerID = ''
SET @oldServerID = ''

END

GO