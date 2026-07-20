CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
    -- TRUNCATING silver.crm_cust_info
    TRUNCATE TABLE silver.crm_cust_info;
    -- INSERTING TO silver.crm_cust_info
    INSERT INTO silver.crm_cust_info (
            cst_id, 
            cst_key, 
            cst_firstname, 
            cst_lastname, 
            cst_marital_status, 
            cst_gndr, 
            cst_create_date
        )
    SELECT 
        cst_id,
        cst_key,
        TRIM(cst_firstname) AS cst_firstname,
        TRIM(cst_lastname) AS cst_lastname,
            CASE 
                    WHEN UPPER(cst_marital_status) = 'M' THEN 'Married'
                    WHEN UPPER(cst_marital_status) = 'S' THEN 'Single'
                ELSE 'n/a'
            END cst_marital_status,
            CASE 
                    WHEN UPPER(cst_gndr) = 'M' THEN 'Male'
                    WHEN UPPER(cst_gndr) = 'F' THEN 'Female'
                ELSE 'n/a'
            END cst_gndr,
        cst_create_date
        FROM
        (SELECT *,
            ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS rank
            FROM bronze.crm_cust_info)t
    WHERE t.rank = 1 AND t.cst_id IS NOT NULL;


    -- TRUNCATING silver.crm_prd_info
    TRUNCATE TABLE silver.crm_prd_info;
    -- INSERTING TO silver.crm_prd_info
    INSERT INTO silver.crm_prd_info (
        prd_id,
        cat_id,
        prd_key,
        prd_cost,
        prd_line,
        prd_start_dt,
        prd_end_dt
    )

    SELECT prd_id,
        REPLACE(SUBSTRING(prd_key,1,5),'-','_') AS cat_id,
        SUBSTRING(prd_key,7,len(prd_key)) AS prd_key,
        ISNULL(prd_cost,0) AS prd_cost,
        CASE 
            WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
            WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
            WHEN UPPER(TRIM(prd_line)) = 'S' Then 'Other Sales'
            WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
            ELSE 'n/a'
        END AS prd_line,
        prd_start_dt,
        DATEADD(day,-1,LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt)) AS prd_end_dt
    FROM bronze.crm_prd_info;


    -- TRUNCATING silver.crm_sales_details
    TRUNCATE TABLE silver.crm_sales_details;
    -- INSERTING INTO silver.crm_sales_details
    INSERT INTO silver.crm_sales_details(
        sls_ord,
        sls_prd_key,
        sls_cust_id,
        sls_order_dt,
        sls_ship_dt,
        sls_due_dt,
        sls_sales,
        sls_quantity,
        sls_price
    )
    SELECT 
        sls_ord,
        sls_prd_key,
        sls_cust_id,
        CASE 
            WHEN sls_order_dt = 0 OR len(sls_order_dt) != 8 THEN NULL
            ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
        END AS sls_order_dt,
        CASE 
            WHEN sls_ship_dt = 0 OR len(sls_ship_dt) != 8 THEN NULL
            ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
        END AS sls_ship_dt,
        CASE 
            WHEN sls_due_dt = 0 OR len(sls_due_dt) != 8 THEN NULL
            ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
        END AS sls_due_dt,
        CASE 
            WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
                THEN sls_quantity * ABS(sls_price)
            ELSE sls_sales
        END AS sls_sales,
        sls_quantity,
        CASE
            WHEN sls_price <= 0 THEN ABS(sls_price)
            WHEN sls_price IS NULL THEN ABS(sls_sales) / NULLIF(sls_quantity,0)
            ELSE sls_price
        END AS sls_price
    FROM bronze.crm_sales_details;


    -- TRUNCATING silver.erp_cust_az12
    TRUNCATE TABLE silver.erp_cust_az12;
    -- INSERTING TO silver.erp_cust_az12
    INSERT INTO silver.erp_cust_az12 (cid,bdate,gen)
    SELECT 
        CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid,4,len(cid))
            ELSE cid
        END cid,
        CASE WHEN bdate > GETDATE() THEN NULL 
            ELSE bdate
        END bdate,
        CASE WHEN UPPER(gen) LIKE 'F%' THEN 'Female'
            WHEN UPPER(gen) LIKE 'M%' THEN 'Male'
            ELSE 'n/a'
        END gen
    FROM bronze.erp_cust_az12;

    -- TRUNCATING silver.erp_loc_a101
    TRUNCATE TABLE silver.erp_loc_a101;
    -- INSERTING INTO silver.erp_loc_a101
    INSERT INTO silver.erp_loc_a101(cid,cntry)
    SELECT DISTINCT
        REPLACE(cid,'-','') AS cid,
        CASE 
            WHEN TRIM(REPLACE(REPLACE(cntry, CHAR(13), ''), CHAR(10), '')) LIKE 'US%' THEN 'United States'
            WHEN TRIM(REPLACE(REPLACE(cntry, CHAR(13), ''), CHAR(10), '')) LIKE 'DE%' THEN 'Germany'
            WHEN TRIM(REPLACE(REPLACE(cntry, CHAR(13), ''), CHAR(10), '')) = '' 
                OR cntry IS NULL THEN 'n/a'
            ELSE TRIM(REPLACE(REPLACE(cntry, CHAR(13), ''), CHAR(10), ''))
        END AS cntry
    FROM bronze.erp_loc_a101;

    -- TRUNCATING silver.erp_px_cat_g1v2
    TRUNCATE TABLE silver.erp_px_cat_g1v2;
    -- INSERTING INTO silver.erp_px_cat_g1v2
    INSERT INTO silver.erp_px_cat_g1v2 (id,cat,subcat,maintanance)
    SELECT 
        id,
        cat,
        subcat,
        maintanance 
    FROM bronze.erp_px_cat_g1v2 
END

