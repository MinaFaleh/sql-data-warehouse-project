-- =============================================================================
-- Procedure: bronze.load_bronze
-- Purpose  : Loads raw source data (CRM + ERP CSV files) into the Bronze
--            layer tables using a full load pattern (TRUNCATE + BULK INSERT).
-- Usage    : EXEC bronze.load_bronze;
-- Notes    : - File paths must be accessible by the SQL Server service account.
--            - Wrapped in TRY/CATCH so failures are reported clearly instead
--              of failing silently.
--            - Prints duration per table and for the whole batch load.
-- =============================================================================
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
    -- Timing variables: per-table (@start_time/@end_time) and whole-batch
    -- (@batch_start_time/@batch_end_time)
    DECLARE @start_time DATETIME, @end_time DATETIME,
            @batch_start_time DATETIME, @batch_end_time DATETIME;

    BEGIN TRY
        SET @batch_start_time = GETDATE();

        PRINT '==========================================';
        PRINT 'Loading Bronze Layer';
        PRINT '==========================================';

        -- ---------------------------------------------------------------
        -- CRM Source Tables
        -- ---------------------------------------------------------------
        PRINT '------------------------------------------';
        PRINT 'Loading CRM Tables';
        PRINT '------------------------------------------';

        -- Customer Info
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.crm_cust_info';
        TRUNCATE TABLE bronze.crm_cust_info;

        PRINT '>> Inserting Data Into: bronze.crm_cust_info';
        BULK INSERT bronze.crm_cust_info
        FROM 'M:\Junior\data\data wherhouse prolect\datasets\source_crm\cust_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' second(s)';
        PRINT '**********************************************************';

        -- Product Info
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.crm_prd_info';
        TRUNCATE TABLE bronze.crm_prd_info;

        PRINT '>> Inserting Data Into: bronze.crm_prd_info';
        BULK INSERT bronze.crm_prd_info
        FROM 'M:\Junior\data\data wherhouse prolect\datasets\source_crm\prd_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' second(s)';
        PRINT '**********************************************************';

        -- Sales Details
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.crm_sales_details';
        TRUNCATE TABLE bronze.crm_sales_details;

        PRINT '>> Inserting Data Into: bronze.crm_sales_details';
        BULK INSERT bronze.crm_sales_details
        FROM 'M:\Junior\data\data wherhouse prolect\datasets\source_crm\sales_details.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' second(s)';
        PRINT '**********************************************************';

        -- ---------------------------------------------------------------
        -- ERP Source Tables
        -- ---------------------------------------------------------------
        PRINT '------------------------------------------';
        PRINT 'Loading ERP Tables';
        PRINT '------------------------------------------';

        -- Location Data
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.erp_loc_a101';
        TRUNCATE TABLE bronze.erp_loc_a101;

        PRINT '>> Inserting Data Into: bronze.erp_loc_a101';
        BULK INSERT bronze.erp_loc_a101
        FROM 'M:\Junior\data\data wherhouse prolect\datasets\source_erp\loc_a101.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' second(s)';
        PRINT '**********************************************************';

        -- Customer Data
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.erp_cust_az12';
        TRUNCATE TABLE bronze.erp_cust_az12;

        PRINT '>> Inserting Data Into: bronze.erp_cust_az12';
        BULK INSERT bronze.erp_cust_az12
        FROM 'M:\Junior\data\data wherhouse prolect\datasets\source_erp\cust_az12.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' second(s)';
        PRINT '**********************************************************';

        -- Product Category Data
        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2';
        TRUNCATE TABLE bronze.erp_px_cat_g1v2;

        PRINT '>> Inserting Data Into: bronze.erp_px_cat_g1v2';
        BULK INSERT bronze.erp_px_cat_g1v2
        FROM 'M:\Junior\data\data wherhouse prolect\datasets\source_erp\px_cat_g1v2.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' second(s)';
        PRINT '**********************************************************';

        -- ---------------------------------------------------------------
        -- Batch summary
        -- ---------------------------------------------------------------
        SET @batch_end_time = GETDATE();
        PRINT '==========================================';
        PRINT 'Loading Bronze Layer is Completed';
        PRINT '   Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' second(s)';
        PRINT '==========================================';

    END TRY
    BEGIN CATCH
        -- Catches issues like invalid file paths, format mismatches,
        -- locked tables, permission errors, etc.
        PRINT '==========================================';
        PRINT 'ERROR OCCURRED DURING LOADING BRONZE LAYER';
        PRINT 'Error Message : ' + ERROR_MESSAGE();
        PRINT 'Error Number  : ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error State   : ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '==========================================';
    END CATCH
END
GO

-- Execute the procedure to run the load
EXEC bronze.load_bronze;
