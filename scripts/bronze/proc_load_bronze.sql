CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME;
    BEGIN TRY
        SET @start_time = GETDATE();

        PRINT '================================================';
        PRINT 'STARTING BRONZE LAYER DATA LOADING';
        PRINT '================================================';
        PRINT '';

        PRINT '------------------------------------------------';
        PRINT 'SECTION 1: CRM DATA SOURCE';
        PRINT '------------------------------------------------';
        PRINT '';

        -- Table 1: crm_cust_info
        PRINT '>> Truncating Table: bronze.crm_cust_info';
        TRUNCATE TABLE bronze.crm_cust_info;
        PRINT '';

        PRINT '>> Inserting Data: bronze.crm_cust_info';
        BULK INSERT bronze.crm_cust_info
        FROM '/datasets/source_crm/cust_info.csv'
        WITH (
            FIRSTROW = 2, 
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        PRINT '';

        -- Table 2: crm_prd_info
        PRINT '>> Truncating Table: bronze.crm_prd_info';
        TRUNCATE TABLE bronze.crm_prd_info;
        PRINT '';

        PRINT '>> Inserting Data: bronze.crm_prd_info';
        BULK INSERT bronze.crm_prd_info
        FROM '/datasets/source_crm/prd_info.csv'
        WITH (
            FIRSTROW = 2, 
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        PRINT '';

        -- Table 3: crm_sales_details
        PRINT '>> Truncating Table: bronze.crm_sales_details';
        TRUNCATE TABLE bronze.crm_sales_details;
        PRINT '';

        PRINT '>> Inserting Data: bronze.crm_sales_details';
        BULK INSERT bronze.crm_sales_details 
        FROM '/datasets/source_crm/sales_details.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        PRINT '';

        PRINT '------------------------------------------------';
        PRINT 'SECTION 2: ERP DATA SOURCE';
        PRINT '------------------------------------------------';
        PRINT '';

        -- Table 4: erp_px_cat_g1v2
        PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2';
        TRUNCATE TABLE bronze.erp_px_cat_g1v2;
        PRINT '';

        PRINT '>> Inserting Data: bronze.erp_px_cat_g1v2';
        BULK INSERT bronze.erp_px_cat_g1v2
        FROM '/datasets/source_erp/PX_CAT_G1V2.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        PRINT '';

        -- Table 5: erp_cust_az12
        PRINT '>> Truncating Table: bronze.erp_cust_az12';
        TRUNCATE TABLE bronze.erp_cust_az12;
        PRINT '';

        PRINT '>> Inserting Data: bronze.erp_cust_az12';
        BULK INSERT bronze.erp_cust_az12
        FROM '/datasets/source_erp/cust_az12.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        PRINT '';

        -- Table 6: erp_loc_a101
        PRINT '>> Truncating Table: bronze.erp_loc_a101';
        TRUNCATE TABLE bronze.erp_loc_a101;
        PRINT '';

        PRINT '>> Inserting Data: bronze.erp_loc_a101';
        BULK INSERT bronze.erp_loc_a101
        FROM '/datasets/source_erp/loc_a101.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        PRINT '';

        SET @end_time = GETDATE();

        PRINT '================================================';
        PRINT 'LOAD COMPLETED SUCCESSFULLY!';
        PRINT 'TOTAL DURATION: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR(50)) + ' seconds.';
        PRINT '================================================';

    END TRY
    
    BEGIN CATCH
        PRINT '';
        PRINT '================================================';
        PRINT 'ERROR OCCURRED DURING LOAD!';
        PRINT 'ERROR MESSAGE : ' + ERROR_MESSAGE();
        PRINT '================================================';
    END CATCH
END;
GO

EXEC bronze.load_bronze;