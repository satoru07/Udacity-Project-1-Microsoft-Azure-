IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name = 'SynapseDelimitedTextFormat') 
	CREATE EXTERNAL FILE FORMAT [SynapseDelimitedTextFormat] 
	WITH ( FORMAT_TYPE = DELIMITEDTEXT ,
	       FORMAT_OPTIONS (
			 FIELD_TERMINATOR = ',',
			 USE_TYPE_DEFAULT = FALSE
			))
GO

IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'projectcontainer1_projectstorageritik1_dfs_core_windows_net') 
	CREATE EXTERNAL DATA SOURCE [projectcontainer1_projectstorageritik1_dfs_core_windows_net] 
	WITH (
		LOCATION = 'abfss://projectcontainer1@projectstorageritik1.dfs.core.windows.net' 
	)
GO

CREATE EXTERNAL TABLE [dbo].[staging_trip] (
	[trip_id] nvarchar(4000),
	[rideable_type] nvarchar(4000),
	[start_at] varchar(50),
	[ended_at] varchar(50),
	[start_station_id] nvarchar(4000),
	[end_station_id] nvarchar(4000),
	[rider_id] varchar(50)
	)
	WITH (
	LOCATION = '/public.trip.txt',
	DATA_SOURCE = [projectcontainer1_projectstorageritik1_dfs_core_windows_net],
	FILE_FORMAT = [SynapseDelimitedTextFormat]
	)
GO


SELECT TOP 10 * FROM [dbo].[staging_trip]
GO
