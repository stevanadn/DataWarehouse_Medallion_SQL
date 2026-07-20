

INSERT INTO silver.crm_cust_info (cst_id, cst_key, cst_firstname, cst_lastname, cst_marital_status, cst_gndr, cst_create_date)

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




CREATE TABLE silver.crm_cust_info (
    cst_id INT,
    cst_key NVARCHAR(50),
    cst_firstname NVARCHAR(50),
    cst_lastname NVARCHAR(50),
    cst_marital_status NVARCHAR(50),
    cst_gndr NVARCHAR(50),
    cst_create_date DATE,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);

