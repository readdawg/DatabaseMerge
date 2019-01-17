-- CHECK

--Create CameraCount Column in Gaining InsightEnt
USE InsightEnt
ALTER TABLE dbo.Servers
ADD ServerStatus int,
oServerID int;
GO

--Create CameraCount Column in Donor InsightEnt
USE ToMergeVMS
ALTER TABLE dbo.Servers
ADD ServerStatus int,
oServerID int;
GO

UPDATE ToMergeVMS.dbo.Servers
SET ServerStatus = NULL


-- Check donor ServerID against existing ServerIDs In Gaining Table
USE ToMergeVMS
DECLARE @count int = 1
DECLARE @maxID int 

SET @maxID = (SELECT COUNT(*) FROM ToMergeVMS.dbo.Servers)

WHILE @count <= @maxID

BEGIN

DECLARE @minID int = (SELECT min(ServerID) FROM ToMergeVMS.dbo.Servers WHERE ServerStatus IS NULL)
DECLARE @serverID nvarchar(10) = (SELECT ServerID FROM ToMergeVMS.dbo.Servers WHERE ServerID = @minID)
DECLARE @minCamID nvarchar(10) = @minID

DECLARE @sql NVARCHAR(max) = '

				IF NOT EXISTS (SELECT ServerID FROM InsightEnt.dbo.Servers WHERE ServerID = ' + @serverID + ')
					BEGIN				

						UPDATE ToMergeVMS.dbo.Servers
						SET oServerID = ' + @ServerID + ',
						ServerStatus = 1 WHERE ServerID = ' + @serverID +'
					END				

				ELSE

					BEGIN
						UPDATE ToMergeVMS.dbo.Servers
						SET oServerID = ' + @ServerID + ',
						ServerStatus = 2 WHERE ServerID = ' + @serverID +'
					END				
				'			

EXEC (@sql)

SET @count = @count + 1
SET @minID = ''
SET @serverID = ''
--SET @qCount = ''

END

GO

--CORRECT

-- Change doror table ServerID where EXISTS in gaining table
USE ToMergeVMS
DECLARE @count int = 1
DECLARE @maxID int 

SET @maxID = (SELECT COUNT(*) FROM ToMergeVMS.dbo.Servers)

WHILE @count <= @maxID

BEGIN

DECLARE @minID nvarchar(10) = (SELECT min(ServerID) FROM InsightEnt.dbo.Servers)
--DECLARE @oserverID nvarchar(10) = (SELECT oServerID FROM ToMergeVMS.dbo.Servers)
DECLARE @minServerID nvarchar(10) = (SELECT MIN(oServerID) FROM ToMergeVMS.dbo.Servers WHERE ServerStatus = 2)
DECLARE @serverStatus nvarchar(1) = '2'
DECLARE @nServerID int = @minID - 1
DECLARE @newServerID nvarchar(10) = @nServerID

DECLARE @sql NVARCHAR(max) = '

				IF ' + @serverStatus + ' = (SELECT ServerStatus FROM ToMergeVMS.dbo.Servers WHERE oServerID = ' + @minServerID + ') 
					BEGIN
					   	
						UPDATE ToMergeVMS.dbo.Servers
						SET ServerID = ' + @newServerID + ',
						ServerStatus = 3 WHERE ServerID = ' + @minServerID +'
						
					END					
				'			

EXEC (@sql)

SET @count = @count + 1
SET @minID = ''
--SET @oserverID = ''
SET @newServerID = ''

END

GO

--COPY

-- Copy server info from donor database to gaining database

USE ToMergeVMS

INSERT INTO InsightEnt.dbo.Servers
SELECT * FROM ToMergeVMS.dbo.Servers WHERE ServerStatus = 1 OR ServerStatus = 3;