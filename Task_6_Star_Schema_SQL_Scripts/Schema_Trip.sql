-- Drop fact_trip if it already exists
IF OBJECT_ID('dbo.fact_trip', 'U') IS NOT NULL
    DROP EXTERNAL TABLE dbo.fact_trip;
GO

-- Create fact_trip with safe casting
CREATE EXTERNAL TABLE dbo.fact_trip
WITH (
    LOCATION     = 'Schema_Trip',
    DATA_SOURCE = [projectcontainer1_projectstorageritik1_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
)  
AS
SELECT 
    TRY_CAST(trip_id AS BIGINT) AS trip_id,
    TRY_CAST(rider_id AS BIGINT) AS rider_id,
    TRY_CAST(start_station_id AS BIGINT) AS start_station_id,
    TRY_CAST(end_station_id AS BIGINT) AS end_station_id,

    -- duration in minutes (only if both dates are valid)
    DATEDIFF(
        MINUTE, 
        TRY_CAST(start_at AS DATETIME2), 
        TRY_CAST(ended_at AS DATETIME2)
    ) AS duration_minutes,

    -- hashed surrogate keys for start & end dates
    HASHBYTES(
        'MD5',
        CONVERT(VARCHAR(100), TRY_CAST(start_at AS DATETIME2), 126)
    ) AS date_start_id,

    HASHBYTES(
        'MD5',
        CONVERT(VARCHAR(100), TRY_CAST(ended_at AS DATETIME2), 126)
    ) AS date_end_id

FROM dbo.staging_trip;
GO

-- Check sample
SELECT TOP 10 * FROM dbo.fact_trip;
GO
