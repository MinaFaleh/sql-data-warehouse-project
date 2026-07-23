-- =============================================================================
-- Script: DDL for Bronze Layer Tables
-- Purpose: (Re)creates all Bronze layer tables that hold raw data loaded
--          directly from the CRM and ERP source CSV files.
-- Note   : Each table is dropped first if it already exists, so this script
--          can be re-run safely (e.g. before each bronze.load_bronze run).
-- =============================================================================

-- -----------------------------------------------------------------------------
-- CRM Source Tables
-- -----------------------------------------------------------------------------

-- Customer master data from CRM
IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_cust_info;
GO

CREATE TABLE bronze.crm_cust_info (
    cst_id               INT,
    cst_key              NVARCHAR(50),
    cst_firstname        NVARCHAR(50),
    cst_lastname         NVARCHAR(50),
    cst_marital_status  NVARCHAR(50),   
    cst_gndr             NVARCHAR(50),
    cst_create_date      DATE
);
GO

-- Product master data from CRM
IF OBJECT_ID('bronze.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_prd_info;
GO

CREATE TABLE bronze.crm_prd_info (
    prd_id       INT,
    prd_key      NVARCHAR(50),
    prd_nm       NVARCHAR(50),
    prd_cost     INT,
    prd_line     NVARCHAR(50),
    prd_start_dt DATETIME,
    prd_end_dt   DATETIME
);
GO

-- Sales transaction details from CRM
-- NOTE: order/ship/due dates are INT here because the source CSV stores
--       them as raw numeric date keys (e.g. 20250115); they'll be converted
--       to proper DATE types during the Silver layer transformation.
IF OBJECT_ID('bronze.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE bronze.crm_sales_details;
GO

CREATE TABLE bronze.crm_sales_details (
    sls_ord_num  NVARCHAR(50),
    sls_prd_key  NVARCHAR(50),
    sls_cust_id  INT,
    sls_order_dt INT,
    sls_ship_dt  INT,
    sls_due_dt   INT,
    sls_sales    INT,
    sls_quantity INT,
    sls_price    INT
);
GO

-- -----------------------------------------------------------------------------
-- ERP Source Tables
-- -----------------------------------------------------------------------------

-- Customer location data from ERP
IF OBJECT_ID('bronze.erp_loc_a101', 'U') IS NOT NULL
    DROP TABLE bronze.erp_loc_a101;
GO

CREATE TABLE bronze.erp_loc_a101 (
    cid   NVARCHAR(50),
    cntry NVARCHAR(50)
);
GO

-- Customer demographic data from ERP
IF OBJECT_ID('bronze.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE bronze.erp_cust_az12;
GO

CREATE TABLE bronze.erp_cust_az12 (
    cid   NVARCHAR(50),
    bdate DATE,
    gen   NVARCHAR(50)
);
GO

-- Product category/maintenance data from ERP
IF OBJECT_ID('bronze.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE bronze.erp_px_cat_g1v2;
GO

CREATE TABLE bronze.erp_px_cat_g1v2 (
    id          NVARCHAR(50),
    cat         NVARCHAR(50),
    subcat      NVARCHAR(50),
    maintenance NVARCHAR(50)
);
GO
