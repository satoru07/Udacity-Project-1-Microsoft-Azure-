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

CREATE EXTERNAL TABLE dbo.dim_station
WITH (
    LOCATION     = 'Schema_station',
    DATA_SOURCE = [projectcontainer1_projectstorageritik1_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
)  
AS
SELECT [station_id], [name], latitude, longitude
FROM [dbo].[staging_station]
GO

SELECT TOP 100 * FROM dbo.dim_station
GO
