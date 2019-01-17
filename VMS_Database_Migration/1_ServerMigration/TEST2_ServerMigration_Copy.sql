
-- Copy server info from donor database to gaining database

USE ToMergeVMS

INSERT INTO InsightEnt.dbo.Servers
SELECT * FROM ToMergeVMS.dbo.Servers WHERE ServerStatus = 1 OR ServerStatus = 3;