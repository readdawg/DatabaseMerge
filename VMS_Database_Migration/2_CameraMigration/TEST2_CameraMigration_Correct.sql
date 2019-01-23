
-- Change doror table FileID where EXISTS in gaining table
USE ToMergeVMS
DECLARE @count int = (SELECT min(FileID) FROM ToMergeVMS.dbo.VideoFiles)
DECLARE @maxID int
DECLARE @iFileID int = (SELECT max(FILEID) FROM InsightEnt.dbo.VideoFiles)

SET @maxID = (SELECT max(FileID) FROM ToMergeVMS.dbo.VideoFiles)

WHILE @count <= @maxID

BEGIN

DECLARE @FileID nvarchar(10) = (SELECT min(FileID) FROM ToMergeVMS.dbo.VideoFiles WHERE MergeStatus = 1)
--DECLARE @iFileID nvarchar(10) = (SELECT max(FILEID) FROM InsightEnt.dbo.VideoFiles)
DECLARE @cFileID nvarchar(10) = @iFileID
--DECLARE @mCameraID nvarchar(10) = (SELECT CameraID FROM ToMergeVMS.dbo.VideoFiles WHERE FileID = @mFileID)
--DECLARE @mServerID nvarchar(10) = (SELECT ServerID FROM ToMergeVMS.dbo.VideoFiles WHERE FileID = @mFileID)

DECLARE @sql NVARCHAR(max) = '

				BEGIN

					UPDATE ToMergeVMS.dbo.VideoFiles
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