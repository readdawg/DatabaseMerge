
-- Change doror table LogID where EXISTS in gaining table
USE ToMergeVMS
DECLARE @count int = (SELECT min(LogID) FROM ToMergeVMS.dbo.VideoFilesLog)
DECLARE @maxID int
DECLARE @iLogID int = (SELECT max(LogID) FROM InsightEnt.dbo.VideoFilesLog) + 1

SET @maxID = (SELECT max(FileID) FROM ToMergeVMS.dbo.VideoFilesLog)

WHILE @count <= @maxID

BEGIN

DECLARE @LogID nvarchar(10) = (SELECT min(LogID) FROM ToMergeVMS.dbo.VideoFilesLog WHERE LogMergeStatus = 1)
DECLARE @cLogID nvarchar(10) = @iLogID

DECLARE @sql NVARCHAR(max) = '

				BEGIN

					UPDATE ToMergeVMS.dbo.VideoFilesLog
					SET LogID = ' + @cLogID + ',
					LogMergeStatus = 2 WHERE lLogID = ' + @LogID + ';							

				END				
							
				'			
EXEC (@sql)

SET @count = @count + 1
SET @iLogID = @iLogID + 1

END

GO