-- Drop dim_rider if exists
IF OBJECT_ID('dbo.dim_rider', 'U') IS NOT NULL
    DROP EXTERNAL TABLE dbo.dim_rider;
GO

-- Create cleaned dim_rider
CREATE EXTERNAL TABLE dbo.dim_rider
WITH (
    LOCATION     = 'schema_rider',
    DATA_SOURCE = [projectcontainer1_projectstorageritik1_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
)  
AS
SELECT 
    TRY_CAST(r.rider_id AS BIGINT) AS rider_id,
    r.[address],
    r.[first],
    r.[last],
    TRY_CAST(r.birthday AS DATE) AS birthday,
    DATEDIFF(
        YEAR, 
        TRY_CAST(r.birthday AS DATE), 
        TRY_CAST(r.account_start_date AS DATE)
    ) AS age_start_account,
    TRY_CAST(r.account_start_date AS DATE) AS account_start_date,
    TRY_CAST(r.account_end_date AS DATE) AS account_end_date,
    TRY_CAST(r.is_member AS BIT) AS is_member,
    SUM(TRY_CAST(p.amount AS FLOAT)) AS total_payed,
    SUM(
        DATEDIFF(
            MINUTE, 
            TRY_CAST(t.start_at AS DATETIME2), 
            TRY_CAST(t.ended_at AS DATETIME2)
        )
    ) AS total_duration
FROM dbo.staging_rider r
JOIN dbo.staging_payment p 
    ON TRY_CAST(r.rider_id AS BIGINT) = TRY_CAST(p.rider_id AS BIGINT)
JOIN dbo.staging_trip t 
    ON TRY_CAST(r.rider_id AS BIGINT) = TRY_CAST(t.rider_id AS BIGINT)
GROUP BY 
    TRY_CAST(r.rider_id AS BIGINT),
    r.[address],
    r.[first],
    r.[last],
    r.birthday,
    r.account_start_date,
    r.account_end_date,
    r.is_member;
GO

-- Query sample
SELECT TOP 10 * FROM dbo.dim_rider;
GO
