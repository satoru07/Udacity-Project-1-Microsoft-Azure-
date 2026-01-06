-- Drop old external table if exists
IF OBJECT_ID('dbo.staging_rider', 'U') IS NOT NULL
    DROP EXTERNAL TABLE dbo.staging_rider;
GO

-- External table with all NVARCHAR columns (raw load)
CREATE EXTERNAL TABLE [dbo].[staging_rider] (
    [rider_id] NVARCHAR(100),
    [first] NVARCHAR(4000),
    [last] NVARCHAR(4000),
    [address] NVARCHAR(4000),
    [birthday] NVARCHAR(100),
    [account_start_date] NVARCHAR(100),
    [account_end_date] NVARCHAR(100),
    [is_member] NVARCHAR(10)
)
WITH (
    LOCATION = 'public.rider.txt',
    DATA_SOURCE = [projectcontainer1_projectstorageritik1_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormat]
);
GO

-- Now query with type casting
SELECT TOP 10
    TRY_CAST(rider_id AS BIGINT) AS rider_id,
    first,
    last,
    address,
    TRY_CAST(birthday AS DATETIME2(0)) AS birthday,
    TRY_CAST(account_start_date AS DATETIME2(0)) AS account_start_date,
    TRY_CAST(account_end_date AS DATETIME2(0)) AS account_end_date,
    TRY_CAST(is_member AS BIT) AS is_member
FROM dbo.staging_rider
WHERE rider_id <> 'rider_id';   -- skips header row if present
GO
