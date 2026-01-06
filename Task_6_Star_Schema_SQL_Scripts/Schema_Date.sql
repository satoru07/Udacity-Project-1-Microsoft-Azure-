-- Use the same file format as used for creating the External Tables during the LOAD step.
IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name = 'SynapseDelimitedTextFormat') 
    CREATE EXTERNAL FILE FORMAT [SynapseDelimitedTextFormat] 
    WITH ( FORMAT_TYPE = DELIMITEDTEXT ,
           FORMAT_OPTIONS (
             FIELD_TERMINATOR = ',',
             USE_TYPE_DEFAULT = FALSE
            ))
GO

-- Use the same data source as used for creating the External Tables during the LOAD step.
-- Storage path where the result set will persist
IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'projectcontainer1_projectstorageritik1_dfs_core_windows_net') 
	CREATE EXTERNAL DATA SOURCE [projectcontainer1_projectstorageritik1_dfs_core_windows_net] 
	WITH (
		LOCATION = 'abfss://projectcontainer1@projectstorageritik1.dfs.core.windows.net' 
	)
GO


CREATE EXTERNAL TABLE dbo.dim_date
WITH (
    LOCATION     = 'Schema_date',
    DATA_SOURCE = [projectcontainer1_projectstorageritik1_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
)  
AS
SELECT 
hashbytes('md5',CONVERT(VARCHAR(100),[date],126)) as [date_id], 
[date], 
YEAR([date]) as [year],  
DATEPART(QUARTER, [date]) AS [quarter],
MONTH([date]) as [month], 
DAY([date]) as [day], 
DATEPART(WEEKDAY,[date]) as [weekday]
FROM [dbo].[staging_payment]
GO

SELECT TOP 100 * FROM dbo.dim_date
GO