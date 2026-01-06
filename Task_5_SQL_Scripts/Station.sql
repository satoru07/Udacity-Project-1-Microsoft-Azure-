IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name = 'SynapseDelimitedTextFormat') 
    CREATE EXTERNAL FILE FORMAT [SynapseDelimitedTextFormat] 
    WITH ( FORMAT_TYPE = DELIMITEDTEXT ,
           FORMAT_OPTIONS (
             FIELD_TERMINATOR = ',',

		-- skip header row
             FIRST_ROW = 1,   
             USE_TYPE_DEFAULT = FALSE
            ))
GO

IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'projectcontainer1_projectstorageritik1_dfs_core_windows_net') 
    CREATE EXTERNAL DATA SOURCE [projectcontainer1_projectstorageritik1_dfs_core_windows_net] 
    WITH (
        LOCATION = 'abfss://projectcontainer1@projectstorageritik1.dfs.core.windows.net' 
    )
GO

-- Drop and recreate external table with same name
IF OBJECT_ID('dbo.staging_station', 'U') IS NOT NULL
    DROP EXTERNAL TABLE dbo.staging_station;
GO

CREATE EXTERNAL TABLE [dbo].[staging_station] (
    [station_id] NVARCHAR(100),
    [name] NVARCHAR(4000),
    [latitude] NVARCHAR(100),
    [longitude] NVARCHAR(100)
)
WITH (
    LOCATION = '/public.station.txt',
    DATA_SOURCE = [projectcontainer1_projectstorageritik1_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
);
GO

-- change in query with casting for safty
SELECT TOP 10
    TRY_CAST(station_id AS BIGINT) AS station_id,
    name,
    TRY_CAST(latitude AS FLOAT) AS latitude,
    TRY_CAST(longitude AS FLOAT) AS longitude
FROM dbo.staging_station;
GO
