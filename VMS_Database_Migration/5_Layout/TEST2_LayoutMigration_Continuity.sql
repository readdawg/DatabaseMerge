
-- Check if ServerID was changed because it was a duplicate
USE ToMergeSS
DECLARE @count int = 1
DECLARE @maxID int

SET @maxID = (SELECT count(LayoutID) FROM ToMergeSS.dbo.Layout)

WHILE @count <= @maxID

BEGIN

DECLARE @LayoutID nvarchar(10) = (SELECT min(LayoutID) FROM ToMergeSS.dbo.Layout WHERE LayoutStatus = 3 OR LayoutStatus = 1)

DECLARE @newServerID nvarchar(10) = (SELECT min(ServerID) FROM ToMergeSS.dbo.Servers WHERE ServerStatus = 1)
DECLARE @oldServerID nvarchar(10) = (SELECT min(oServerID) FROM ToMergeSS.dbo.Servers WHERE ServerStatus = 1)

DECLARE @newCameraID nvarchar(10) = (SELECT min(CameraID) FROM ToMergeSS.dbo.Cameras WHERE CameraStatus = 5)
DECLARE @oldCameraID nvarchar(10) = (SELECT min(oCameraID) FROM ToMergeSS.dbo.Cameras WHERE CameraStatus = 5)

--DECLARE @oldCameraList nvarchar(4000) = (SELECT laCameraList FROM ToMergeSS.dbo.Layout WHERE LayoutStatus = 2)

DECLARE @sql NVARCHAR(max) = '

				BEGIN

					UPDATE ToMergeSS.dbo.Layout
					SET ServerID = ' + @newServerID + ' WHERE ServerID = ' + @oldServerID + ';	

					UPDATE ToMergeSS.dbo.Layout
					SET CameraList = REPLACE(CameraList, ''' + @oldCameraID + ''', ''' + @newCameraID + '''),
					LayoutStatus = 4 WHERE LayoutID = ' + @LayoutID +';

					UPDATE ToMergeSS.dbo.Servers
					SET ServerStatus = 7 WHERE ServerID = ' + @newServerID + ';

					UPDATE ToMergeSS.dbo.Cameras
					SET CameraStatus = 6 WHERE CameraID = ' + @newCameraID + ';					

				END				
							
				'			
EXEC (@sql)

SET @count = @count + 1
SET @newServerID = ''
SET @oldServerID = ''
SET @newCameraID = ''
SET @oldCameraID = ''


END

GO