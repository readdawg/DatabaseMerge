
-- Change doror table LayoutID where EXISTS in gaining table
USE ToMergeSS
DECLARE @count int = 1 --(SELECT min(LayoutID) FROM ToMergeSS.dbo.Layout)
DECLARE @maxID int
DECLARE @iLayoutID int = (SELECT max(LayoutID) FROM InsightEnt.dbo.Layout) + 1

SET @maxID = (SELECT count(LayoutID) FROM ToMergeSS.dbo.Layout)

WHILE @count <= @maxID

BEGIN

DECLARE @LayoutID nvarchar(10) = (SELECT min(LayoutID) FROM ToMergeSS.dbo.Layout WHERE LayoutStatus = 2)
--DECLARE @iLayoutID nvarchar(10) = (SELECT max(LayoutID) FROM InsightEnt.dbo.Layout)
DECLARE @cLayoutID nvarchar(10) = @iLayoutID
--DECLARE @mCameraID nvarchar(10) = (SELECT CameraID FROM ToMergeSS.dbo.Layout WHERE LayoutID = @mLayoutID)
--DECLARE @mServerID nvarchar(10) = (SELECT ServerID FROM ToMergeSS.dbo.Layout WHERE LayoutID = @mLayoutID)

DECLARE @sql NVARCHAR(max) = '

				BEGIN

					UPDATE ToMergeSS.dbo.Layout
					SET LayoutID = ' + @cLayoutID + ',
					LayoutStatus = 3 WHERE laLayoutID = ' + @LayoutID + ';							

				END				
							
				'			
EXEC (@sql)

SET @count = @count + 1
SET @iLayoutID = @iLayoutID + 1
--SET @mLayoutID = ''
--SET @mCameraID = ''
--SET @mServerID = ''

END

GO