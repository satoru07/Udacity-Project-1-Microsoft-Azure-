
IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name = 'SynapseDelimitedTextFormatWithHeader') 
    CREATE EXTERNAL FILE FORMAT [SynapseDelimitedTextFormatWithHeader] 
    WITH (
        FORMAT_TYPE = DELIMITEDTEXT,
        FORMAT_OPTIONS (
            FIELD_TERMINATOR = ',',
		--  Skip header row
            FIRST_ROW = 2,    
            USE_TYPE_DEFAULT = FALSE
        )
    );
GO

-- External data source (only create if it doesn’t already exist)
IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'projectcontainer1_projectstorageritik1_dfs_core_windows_net') 
    CREATE EXTERNAL DATA SOURCE [projectcontainer1_projectstorageritik1_dfs_core_windows_net] 
    WITH (
        LOCATION = 'abfss://projectcontainer1@projectstorageritik1.dfs.core.windows.net'
    );
GO

-- Drop existing external table if it exists
IF OBJECT_ID('dbo.staging_payment', 'U') IS NOT NULL
    DROP EXTERNAL TABLE dbo.staging_payment;
GO

-- Create external table mapped to the file (header skipped)
CREATE EXTERNAL TABLE [dbo].[staging_payment] (
    [payment_id] BIGINT,
    [date] DATETIME2,
    [amount] MONEY,
    [rider_id] BIGINT
)
WITH (
    LOCATION = '/public.payment.txt',
    DATA_SOURCE = [projectcontainer1_projectstorageritik1_dfs_core_windows_net],
    FILE_FORMAT = [SynapseDelimitedTextFormatWithHeader]
);
GO

--  Test query
SELECT TOP 10 * FROM dbo.staging_payment;
GO
