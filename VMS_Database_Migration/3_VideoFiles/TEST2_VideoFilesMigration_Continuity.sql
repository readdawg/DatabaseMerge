
-- Check if ServerID or CameraID was changed because it was a duplicate
USE ToMergeVMS
DECLARE @count int = 1
DECLARE @maxID int 

SET @maxID = (SELECT COUNT(*) FROM ToMergeVMS.dbo.Servers)

WHILE @count <= @maxID

BEGIN

DECLARE @newServerID nvarchar(10) = (SELECT min(ServerID) FROM ToMergeVMS.dbo.Servers WHERE ServerStatus = 4)
DECLARE @oldServerID nvarchar(10) = (SELECT min(oServerID) FROM ToMergeVMS.dbo.Servers WHERE ServerStatus = 4)
DECLARE @newCameraID nvarchar(10) = (SELECT min(CameraID) FROM ToMergeVMS.dbo.Cameras WHERE CameraStatus = 3)
DECLARE @oldCameraID nvarchar(10) = (SELECT min(oCameraID) FROM ToMergeVMS.dbo.Cameras WHERE CameraStatus = 3)

DECLARE @sql NVARCHAR(max) = '

				BEGIN

					UPDATE ToMergeVMS.dbo.VideoFiles
					SET ServerID = ' + @newServerID + ' WHERE ServerID = ' + @oldServerID + ';
					
					
					UPDATE ToMergeVMS.dbo.Servers
					SET ServerStatus = 5 WHERE ServerID = ' + @newServerID + ';
					
					UPDATE ToMergeVMS.dbo.VideoFiles
					SET CameraID = ' + @newCameraID + ' WHERE CameraID = ' + @oldCameraID + ';
					
					
					UPDATE ToMergeVMS.dbo.Cameras
					SET CameraStatus = 5 WHERE CameraID = ' + @newCameraID + ';

				END				
							
				'			
EXEC (@sql)

SET @count = @count + 1
SET @newServerID = ''
SET @oldServerID = ''

END

GO