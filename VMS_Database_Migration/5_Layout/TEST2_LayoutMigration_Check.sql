--Create MergeStatus, mLayoutID, mCameraID, mServerID Columns in Gaining InsightEnt
USE InsightEnt
ALTER TABLE dbo.Layout
ADD laLayoutID int,
laServer int,
laCameraList nvarchar(4000),
LayoutStatus int;
GO

--Create MergeStatus, mLayoutID, mCameraID, mServerID Columns in Donor InsightEnt
USE ToMergeSS
ALTER TABLE dbo.Layout
ADD laLayoutID int,
laServer int,
laCameraList nvarchar(4000),
LayoutStatus int;
GO

-- Set MergeStatus column to NULL
UPDATE ToMergeSS.dbo.Layout
SET LayoutStatus = NULL
GO

-- Copy LayoutID, CameraID, ServerID to m columns
-- Check donor ServerID against existing ServerIDs In Gaining Table
USE ToMergeSS
DECLARE @count int = 1
DECLARE @maxID int 

SET @maxID = (SELECT COUNT(*) FROM ToMergeSS.dbo.Layout)

WHILE @count <= @maxID

BEGIN

DECLARE @minLayoutID nvarchar(10) = (SELECT min(LayoutID) FROM ToMergeSS.dbo.Layout WHERE LayoutStatus IS NULL)
DECLARE @laserverID nvarchar(10) = (SELECT ServerID FROM ToMergeSS.dbo.Layout WHERE LayoutID = @minLayoutID)
DECLARE @laCameraList nvarchar(4000) = (SELECT CameraList FROM ToMergeSS.dbo.Layout WHERE LayoutID = @minLayoutID)

DECLARE @sql NVARCHAR(max) = '

				IF NOT EXISTS (SELECT LayoutID FROM InsightEnt.dbo.Layout WHERE LayoutID = ' + @minLayoutID + ')
					BEGIN				

						--Not Duplicate LayoutID
						UPDATE ToMergeSS.dbo.Layout
						SET laLayoutID = ' + @minLayoutID + ',						
						laServer = ' + @laserverID + ',
						laCameraList = ''' + @laCameraList + ''',
						LayoutStatus = 1 WHERE LayoutID = ' + @minLayoutID +'
					END				

				ELSE

					-- Duplicate LayoutID
					BEGIN
						UPDATE ToMergeSS.dbo.Layout
						SET laLayoutID = ' + @minLayoutID + ',						
						laServer = ' + @laserverID + ',
						laCameraList = ''' + @laCameraList + ''',
						LayoutStatus = 2 WHERE LayoutID = ' + @minLayoutID +'
					END				
				'			

EXEC (@sql)

SET @count = @count + 1
SET @minLayoutID = ''
SET @laserverID = ''
SET @laCameraList = ''

END

GO