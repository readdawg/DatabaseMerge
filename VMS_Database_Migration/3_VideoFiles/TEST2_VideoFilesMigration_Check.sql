--Create MergeStatus, mFileID, mCameraID, mServerID Columns in Gaining InsightEnt
USE InsightEnt
ALTER TABLE dbo.VideoFiles
ADD MergeStatus int,
mFileID int,
mCameraID int,
mServerID int;
GO

--Create MergeStatus, mFileID, mCameraID, mServerID Columns in Donor InsightEnt
USE ToMergeVMS
ALTER TABLE dbo.VideoFiles
ADD MergeStatus int,
mFileID int,
mCameraID int,
mServerID int;
GO

-- Set MergeStatus column to NULL
UPDATE ToMergeVMS.dbo.VideoFiles
SET MergeStatus = NULL
GO

-- Copy FileID, CameraID, ServerID to m columns
USE ToMergeVMS
DECLARE @count int = (SELECT min(FileID) FROM ToMergeVMS.dbo.VideoFiles)
DECLARE @maxID int 

SET @maxID = (SELECT max(FileID) FROM ToMergeVMS.dbo.VideoFiles)

WHILE @count <= @maxID

BEGIN

DECLARE @mFileID nvarchar(10) = (SELECT min(FileID) FROM ToMergeVMS.dbo.VideoFiles WHERE MergeStatus IS NULL)
DECLARE @mCameraID nvarchar(10) = (SELECT CameraID FROM ToMergeVMS.dbo.VideoFiles WHERE FileID = @mFileID)
DECLARE @mServerID nvarchar(10) = (SELECT ServerID FROM ToMergeVMS.dbo.VideoFiles WHERE FileID = @mFileID)

DECLARE @sql NVARCHAR(max) = '

				BEGIN

					UPDATE ToMergeVMS.dbo.VideoFiles
					SET mFileID = ' + @mFileID+ ',
					mServerID = ' + @mServerID + ',
					mCameraID = ' + @mCameraID + ' WHERE FileID = ' + @mFileID + ';

					UPDATE ToMergeVMS.dbo.VideoFiles
					SET MergeStatus = 1 WHERE FileID = ' + @mFileID + ';		

				END				
							
				'			
EXEC (@sql)

SET @count = @count + 1
SET @mFileID = ''
SET @mCameraID = ''
SET @mServerID = ''

END

GO