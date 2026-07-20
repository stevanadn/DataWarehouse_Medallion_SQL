
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
FROM bronze.erp_cust_az12
