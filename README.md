# Udacity SQL & Star Schema Project

## Project Overview

This is a **Udacity Data Engineering project** focused on building a **Star Schema** data warehouse for a bike-sharing service. The project demonstrates ETL (Extract, Transform, Load) processes using **SQL Server/Azure Synapse** to transform raw operational data into an optimized dimensional schema for analytics.

## Project Structure

```
Project_1/
├── README.md                          # This file
├── Star_schema.sql                    # Star schema definition and relationships
├── Udacity Project 1.pdf              # Project requirements and specification
├── Task_2_Star_schema.pdf             # Star schema documentation
├── Screenshots_Pics/                  # Project screenshots and diagrams
├── Task_4.1.png                       # Task 4 screenshot 1
├── Task_4.2.png                       # Task 4 screenshot 2
├── Task_5.2.png                       # Task 5 screenshot
│
├── Task_5_SQL_Scripts/                # Staging tables & data loading
│   ├── Payment.sql                    # Payment staging table
│   ├── Rider.sql                      # Rider staging table
│   ├── Station.sql                    # Station staging table
│   └── Trip.sql                       # Trip staging table
│
└── Task_6_Star_Schema_SQL_Scripts/    # Dimensional and fact tables
    ├── Schema_Date.sql                # Date dimension table
    ├── Schema_Payment.sql             # Payment fact table
    ├── Schema_Rider.sql               # Rider dimension table
    ├── Schema_Station.sql             # Station dimension table
    └── Schema_Trip.sql                # Trip fact table
```

## Database Schema

### Star Schema Architecture

The project implements a classic **Star Schema** with fact tables at the center and dimension tables radiating outward.

#### Fact Tables (Transactional Data)

**1. fact_trip**
- Primary Key: `trip_id`
- Measures: `duration_minutes`
- Foreign Keys: `rider_id`, `date_start_id`, `date_end_id`, `start_station_id`, `end_station_id`
- Stores individual trip records with surrogate date keys

**2. fact_payment**
- Primary Key: `payment_id`
- Measures: `amount`
- Foreign Keys: `rider_id`, `date_id`
- Stores payment transactions linked to riders and dates

#### Dimension Tables (Descriptive Data)

**1. dim_rider**
- Primary Key: `rider_id`
- Attributes:
  - `first_name`, `last_name` - Rider identification
  - `address` - Location information
  - `birthday`, `age_start_account` - Demographic data
  - `account_start_date`, `accound_end_date` - Account lifecycle
  - `is_member` - Membership status
  - `total_payed`, `total_duration_minutes` - Aggregated metrics

**2. dim_date**
- Primary Key: `date_id` (MD5 hash)
- Attributes:
  - `date`, `year`, `quater` (quarter), `month`, `day`, `weekday`
  - Enables time-based analysis and aggregations

**3. dim_station**
- Primary Key: `station_id`
- Attributes:
  - `station_name` - Station location details
  - Supports origin and destination analysis

## Implementation Details

### Task 5: Staging Tables

The staging layer (`Task_5_SQL_Scripts/`) loads raw CSV data from Azure Data Lake Storage into external staging tables:

- **External Data Source**: Azure Blob Storage (`abfss://projectcontainer1@projectstorageritik1.dfs.core.windows.net`)
- **File Format**: Comma-separated values (CSV)
- **Staging Tables**:
  - `staging_trip` - Raw trip data
  - `staging_payment` - Raw payment data
  - `staging_rider` - Raw rider data
  - `staging_station` - Raw station data

### Task 6: Dimensional Schema

The schema layer (`Task_6_Star_Schema_SQL_Scripts/`) transforms staging data into dimensional tables:

**Key Transformations:**
- **Type Casting**: Safe casting with `TRY_CAST()` to handle data quality issues
- **Date Hashing**: MD5 hashing of date values to create surrogate keys for efficient joins
- **Duration Calculation**: `DATEDIFF()` to compute trip duration in minutes
- **Aggregation**: Pre-calculated totals in rider dimension for analytical performance

**Example Transformation (Trip Data):**
```sql
SELECT 
    TRY_CAST(trip_id AS BIGINT) AS trip_id,
    TRY_CAST(rider_id AS BIGINT) AS rider_id,
    DATEDIFF(MINUTE, start_at, ended_at) AS duration_minutes,
    HASHBYTES('MD5', CONVERT(VARCHAR(100), start_at, 126)) AS date_start_id
FROM dbo.staging_trip;
```

## Technology Stack

| Component | Technology |
|-----------|------------|
| **Data Warehouse** | Azure Synapse Analytics / SQL Server |
| **Data Source** | Azure Data Lake Storage Gen2 (CSV files) |
| **Language** | T-SQL |
| **External Tables** | Azure Synapse External Table Format |
| **Query Engine** | SQL (Serverless Pool) |

## Running the Scripts

### Prerequisites
- Azure Synapse Analytics workspace or SQL Server instance
- Azure Data Lake Storage container with sample data
- Appropriate permissions for creating external tables

### Execution Order

1. **Task 5 - Load Staging Tables**
   ```bash
   Execute scripts in Task_5_SQL_Scripts/ in order:
   - Station.sql
   - Rider.sql
   - Trip.sql
   - Payment.sql
   ```

2. **Task 6 - Create Dimensional Schema**
   ```bash
   Execute scripts in Task_6_Star_Schema_SQL_Scripts/:
   - Schema_Date.sql
   - Schema_Rider.sql
   - Schema_Station.sql
   - Schema_Trip.sql
   - Schema_Payment.sql
   ```

### Validation

Each script includes sample queries to verify data:
```sql
SELECT TOP 10 * FROM dbo.fact_trip;
SELECT TOP 10 * FROM dbo.dim_rider;
```

## Key Features

✅ **Star Schema Design** - Optimized for analytical queries  
✅ **Surrogate Keys** - MD5 hashing for efficient date joins  
✅ **Error Handling** - `TRY_CAST()` for data quality resilience  
✅ **Scalable Architecture** - External tables for large datasets  
✅ **Time-based Analysis** - Comprehensive date dimension  
✅ **Data Aggregation** - Pre-calculated metrics for performance  

## Analysis Capabilities

With this star schema, you can answer questions like:
- **Rider Analytics**: How many trips per rider? Who are our most active members?
- **Temporal Analysis**: What are peak riding hours/seasons?
- **Station Analysis**: Which stations have highest traffic?
- **Payment Analysis**: Total revenue by period, rider, or station?
- **Duration Metrics**: Average trip duration by time period or station pair?

## Files Reference

| File | Purpose |
|------|---------|
| `Star_schema.sql` | Conceptual schema definition and ERD |
| `Task_2_Star_schema.pdf` | Star schema documentation |
| `Task_5_*` | Staging layer implementation |
| `Task_6_*` | Dimensional schema implementation |
| `Screenshots_Pics/` | Visual documentation |

## Schema Relationships

```
fact_trip ──┬─→ dim_rider
            ├─→ dim_date (start)
            ├─→ dim_date (end)
            ├─→ dim_station (start)
            └─→ dim_station (end)

fact_payment ──┬─→ dim_rider
               └─→ dim_date
```

## Project Objectives Achieved

✓ Design normalized dimensional schema from transactional data  
✓ Create staging layer from external CSV sources  
✓ Transform raw data into fact and dimension tables  
✓ Implement surrogate keys and slowly changing dimensions  
✓ Optimize schema for analytical queries  
✓ Demonstrate ETL best practices in SQL  

## Notes

- All external table references assume Azure Synapse Analytics environment
- Data validation uses `TRY_CAST()` to handle NULL and invalid values gracefully
- MD5 hashing provides consistent date surrogate keys across tables
- Scripts are idempotent with `IF NOT EXISTS` and `DROP IF EXISTS` checks

## Author
Udacity Data Engineering Student

## License
Educational Project

---


