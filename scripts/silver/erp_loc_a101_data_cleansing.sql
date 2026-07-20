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
FROM bronze.erp_loc_a101

