CREATE VIEW gold.dim_products AS
SELECT 
    ROW_NUMBER() OVER(ORDER BY pi.prd_start_dt, pi.prd_key) AS product_key,
    pi.prd_id AS product_id,
    pi.prd_key AS product_number,
    pi.cat_id AS category_id,
    pcg.cat AS category,
    pcg.subcat AS subcategory,
    pcg.maintanance,
    pi.prd_line,
    pi.prd_cost AS cost,
    pi.prd_start_dt AS start_date
FROM silver.crm_prd_info pi 
LEFT JOIN silver.erp_px_cat_g1v2 pcg 
    ON pi.cat_id = pcg.id



