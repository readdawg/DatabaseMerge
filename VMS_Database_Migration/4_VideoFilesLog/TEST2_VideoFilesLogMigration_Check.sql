--Create MergeStatus, mFileID, mCameraID, mServerID Columns in Gaining InsightEnt
USE InsightEnt
ALTER TABLE dbo.VideoFilesLog
ADD LogMergeStatus int,
lLogID int,
lFileID int,
lCameraID int,
lServerID int;
GO

--Create MergeStatus, mFileID, mCameraID, mServerID Columns in Donor InsightEnt
USE ToMergeVMS
ALTER TABLE dbo.VideoFilesLog
ADD LogMergeStatus int,
lLogID int,
lFileID int,
lCameraID int,
lServerID int;
GO

-- Set MergeStatus column to NULL
UPDATE ToMergeVMS.dbo.VideoFilesLog
SET LogMergeStatus = NULL
GO

-- Copy FileID, CameraID, ServerID to m columns
USE ToMergeVMS
DECLARE @count int = (SELECT min(LogID) FROM ToMergeVMS.dbo.VideoFilesLog)
DECLARE @maxID int 

SET @maxID = (SELECT max(LogID) FROM ToMergeVMS.dbo.VideoFilesLog)

WHILE @count <= @maxID

BEGIN

DECLARE @lLogID nvarchar(10) = (SELECT min(LogID) FROM ToMergeVMS.dbo.VideoFilesLog WHERE LogMergeStatus IS NULL)
DECLARE @lCameraID nvarchar(10) = (SELECT oCameraID FROM ToMergeVMS.dbo.VideoFilesLog WHERE LogID = @lLogID)
DECLARE @lServerID nvarchar(10) = (SELECT oServerID FROM ToMergeVMS.dbo.VideoFilesLog WHERE LogID = @lLogID)
DECLARE @lFileID nvarchar(10) = (SELECT FileID FROM ToMergeVMS.dbo.VideoFilesLog WHERE LogID = @lLogID)

DECLARE @sql NVARCHAR(max) = '

				BEGIN

					UPDATE ToMergeVMS.dbo.VideoFilesLog
					SET lLogID = ' + @lLogID + ',
					lFileID = ' + @lFileID+ ',
					lServerID = ' + @lServerID + ',
					lCameraID = ' + @lCameraID + ' WHERE LogID = ' + @lLogID + ';

					UPDATE ToMergeVMS.dbo.VideoFilesLog
					SET LogMergeStatus = 1 WHERE LogID = ' + @lLogID + ';		

				END				
							
				'			
EXEC (@sql)

SET @count = @count + 1
SET @lLogID = ''
SET @lFileID = ''
SET @lCameraID = ''
SET @lServerID = ''

END

GO