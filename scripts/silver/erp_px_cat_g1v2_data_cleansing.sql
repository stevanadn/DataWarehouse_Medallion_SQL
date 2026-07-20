INSERT INTO silver.erp_px_cat_g1v2 (id,cat,subcat,maintanance)

SELECT id,cat,subcat,maintanance FROM bronze.erp_px_cat_g1v2 

CREATE TABLE silver.erp_px_cat_g1v2 (
    id NVARCHAR(50),
    cat NVARCHAR(50),
    subcat NVARCHAR(50),
    maintanance NVARCHAR(50),
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);

