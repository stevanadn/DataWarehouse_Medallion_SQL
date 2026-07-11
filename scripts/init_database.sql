USE master;
GO


-- Check for existing (Duplicate Database)
IF EXISTS(SELECT 1 FROM sys.databases WHERE name = 'medallion_datawarehouse')
BEGIN
    ALTER DATABASE medallion_datawarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE medallion_datawarehouse;
END;
GO

-- Create and Activate the Database

CREATE DATABASE medallion_datawarehouse;
GO
USE medallion_datawarehouse;
GO
-- Create Schemas
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;

