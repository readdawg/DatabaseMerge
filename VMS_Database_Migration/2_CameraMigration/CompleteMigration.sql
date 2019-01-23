
--Create CameraCount Column in Gaining InsightEnt
USE InsightEnt
ALTER TABLE dbo.Cameras
ADD CameraStatus int,
oCameraID int,
oServerID int;
GO

--Create CameraCount Column in Donor InsightEnt
USE ToMergeSS
ALTER TABLE dbo.Cameras
ADD CameraStatus int,
oCameraID int,
oServerID int;
GO

UPDATE ToMergeSS.dbo.Cameras
SET CameraStatus = NULL


-- Check donor ServerID against existing ServerIDs In Gaining Table
USE ToMergeSS
DECLARE @count int = 1
DECLARE @maxID int 

SET @maxID = (SELECT COUNT(*) FROM ToMergeSS.dbo.Cameras)

WHILE @count <= @maxID

BEGIN

DECLARE @minCamID nvarchar(10) = (SELECT min(CameraID) FROM ToMergeSS.dbo.Cameras WHERE CameraStatus IS NULL)
DECLARE @serverID nvarchar(10) = (SELECT ServerID FROM ToMergeSS.dbo.Cameras WHERE CameraID = @minCamID)
DECLARE @cameraID nvarchar(10) = (SELECT cameraID FROM ToMergeSS.dbo.Cameras WHERE CameraID = @minCamID)

DECLARE @sql NVARCHAR(max) = '

				IF NOT EXISTS (SELECT CameraID FROM InsightEnt.dbo.Cameras WHERE CameraID = ' + @cameraID + ')
					BEGIN				

						--Not Duplicate CameraID
						UPDATE ToMergeSS.dbo.Cameras
						SET oCameraID = ' + @cameraID + ',
						oServerID = ' + @serverID + ',
						CameraStatus = 1 WHERE CameraID = ' + @cameraID +'
					END				

				ELSE

					-- Duplicate CameraID
					BEGIN
						UPDATE ToMergeSS.dbo.Cameras
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




-- Change doror table FileID where EXISTS in gaining table
USE ToMergeSS
DECLARE @count int = (SELECT min(FileID) FROM ToMergeSS.dbo.VideoFiles)
DECLARE @maxID int
DECLARE @iFileID int = (SELECT max(FILEID) FROM InsightEnt.dbo.VideoFiles)

SET @maxID = (SELECT max(FileID) FROM ToMergeSS.dbo.VideoFiles)

WHILE @count <= @maxID

BEGIN

DECLARE @FileID nvarchar(10) = (SELECT min(FileID) FROM ToMergeSS.dbo.VideoFiles WHERE MergeStatus = 1)
--DECLARE @iFileID nvarchar(10) = (SELECT max(FILEID) FROM InsightEnt.dbo.VideoFiles)
DECLARE @cFileID nvarchar(10) = @iFileID
--DECLARE @mCameraID nvarchar(10) = (SELECT CameraID FROM ToMergeSS.dbo.VideoFiles WHERE FileID = @mFileID)
--DECLARE @mServerID nvarchar(10) = (SELECT ServerID FROM ToMergeSS.dbo.VideoFiles WHERE FileID = @mFileID)

DECLARE @sql NVARCHAR(max) = '

				BEGIN

					UPDATE ToMergeSS.dbo.VideoFiles
					SET FileID = ' + @cFileID + ',
					MergeStatus = 2 WHERE mFileID = ' + @FileID + ';							

				END				
							
				'			
EXEC (@sql)

SET @count = @count + 1
SET @iFileID = @iFileID + 1
--SET @mFileID = ''
--SET @mCameraID = ''
--SET @mServerID = ''

END

GO




-- Check if ServerID was changed because it was a duplicate
USE ToMergeSS
DECLARE @count int = 1
DECLARE @maxID int 

SET @maxID = (SELECT COUNT(*) FROM ToMergeSS.dbo.Servers)

WHILE @count <= @maxID

BEGIN

DECLARE @newServerID nvarchar(10) = (SELECT min(ServerID) FROM ToMergeSS.dbo.Servers WHERE ServerStatus = 3)
DECLARE @oldServerID nvarchar(10) = (SELECT min(oServerID) FROM ToMergeSS.dbo.Servers WHERE ServerStatus = 3)

DECLARE @sql NVARCHAR(max) = '

				BEGIN

					UPDATE ToMergeSS.dbo.Cameras
					SET ServerID = ' + @newServerID + ' WHERE ServerID = ' + @oldServerID + ';
					
					
					UPDATE ToMergeSS.dbo.Servers
					SET ServerStatus = 4 WHERE ServerID = ' + @newServerID + ';
					

				END				
							
				'			
EXEC (@sql)

SET @count = @count + 1
SET @newServerID = ''
SET @oldServerID = ''

END

GO



