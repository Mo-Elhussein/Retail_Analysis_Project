CREATE SCHEMA retail;
-- Customer Dimension
CREATE TABLE retail.dim_customers (
   customer_id INT PRIMARY KEY,
   customer_name VARCHAR(100),
   email VARCHAR(100),
   region VARCHAR(50),
   signup_date DATE
);
-- Product Dimension
CREATE TABLE retail.dim_products (
   product_id INT PRIMARY KEY,
   product_name VARCHAR(100),
   category VARCHAR(50),
   price DECIMAL(10,2)
);
-- Store Dimension
CREATE TABLE retail.dim_stores (
   store_id INT PRIMARY KEY,
   store_name VARCHAR(100),
   location VARCHAR(100),
   manager_name VARCHAR(100)
);
-- Time Dimension
CREATE TABLE retail.dim_time (
   date_id DATE PRIMARY KEY,
   year INT,
   quarter INT,
   month INT,
   day INT,
   day_of_week VARCHAR(20)
);

CREATE TABLE retail.dim_employees (
   employee_id INT PRIMARY KEY,
   employee_name TEXT,
   department TEXT,
   employment_type TEXT,
   hire_date DATE,
   store_id INT  
);

-- Fact Sales
CREATE TABLE retail.fact_sales (
   sale_id INT PRIMARY KEY,
   customer_id INT REFERENCES retail.dim_customers(customer_id),
   product_id INT REFERENCES retail.dim_products(product_id),
   store_id INT REFERENCES retail.dim_stores(store_id),
   sale_date DATE REFERENCES retail.dim_time(date_id),
   quantity_sold INT,
   total_amount DECIMAL(10,2)
);
-- Fact Inventory
CREATE TABLE retail.fact_inventory (
   inventory_id INT PRIMARY KEY,
   product_id INT REFERENCES retail.dim_products(product_id),
   store_id INT REFERENCES retail.dim_stores(store_id),
   stock_date DATE REFERENCES retail.dim_time(date_id),
   stock_level INT
);

INSERT INTO retail.dim_customers
SELECT
    seq.id,
    'Customer_' || seq.id AS customer_name,
    'customer' || seq.id || '@example.com' AS email,
    CASE
        WHEN seq.id % 4 = 0 THEN 'North'
        WHEN seq.id % 4 = 1 THEN 'South'
        WHEN seq.id % 4 = 2 THEN 'East'
        ELSE 'West'
    END AS region,
    DATEADD(day, -FLOOR(RANDOM() * 3650)::INT, CURRENT_DATE) AS signup_date
FROM (
    SELECT (a.n * 100) + (b.n * 10) + c.n + 1 AS id
    FROM
        (SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
         UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) a,
        (SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
         UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) b,
        (SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
         UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) c
) AS seq
WHERE seq.id <= 1000;

INSERT INTO retail.dim_products
SELECT
    seq.id AS id,
    'Product_' || seq.id AS product_name,
    CASE
        WHEN seq.id % 3 = 0 THEN 'Electronics'
        WHEN seq.id % 3 = 1 THEN 'Clothing'
        ELSE 'Home & Kitchen'
    END AS category,
    ROUND(RANDOM() * 500 + 5, 2) AS price
FROM (
    SELECT (a.n * 100) + (b.n * 10) + c.n + 1 AS id
    FROM
        (SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
         UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) a,
        (SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
         UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) b,
        (SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
         UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) c
) AS seq
WHERE seq.id <= 500;

INSERT INTO retail.dim_stores
SELECT
    seq.id AS id,
    'Store_' || seq.id AS store_name,
    CASE
        WHEN seq.id % 4 = 0 THEN 'New York'
        WHEN seq.id % 4 = 1 THEN 'Los Angeles'
        WHEN seq.id % 4 = 2 THEN 'Chicago'
        ELSE 'Houston'
    END AS city,
    'Address_' || seq.id AS address
FROM (
    SELECT (a.n * 10) + b.n + 1 AS id
    FROM
        (SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
         UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) a,
        (SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
         UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) b
) AS seq
WHERE seq.id <= 100;

INSERT INTO retail.fact_sales
SELECT
    seq.id AS id,
    FLOOR(RANDOM() * 100000) + 1 AS customer_id,
    FLOOR(RANDOM() * 500) + 1 AS product_id,
    FLOOR(RANDOM() * 100) + 1 AS store_id,
    DATEADD(day, -FLOOR(RANDOM() * 1825)::INT, CURRENT_DATE) AS sale_date,
    FLOOR(RANDOM() * 100) + 1 AS quantity_sold,
    ROUND((FLOOR(RANDOM() * 100) + 1) * (FLOOR(RANDOM() * 100) + 5), 2) AS total_amount
FROM (
    SELECT (a.n * 100) + (b.n * 10) + c.n + 1 AS id
    FROM
        (SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
         UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) a,
        (SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
         UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) b,
        (SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
         UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) c
) AS seq
WHERE seq.id <= 1000;


INSERT INTO retail.fact_inventory
SELECT
    seq.id AS id,
    FLOOR(RANDOM() * 500) + 1 AS product_id,
    FLOOR(RANDOM() * 100) + 1 AS store_id,
    DATEADD(day, -FLOOR(RANDOM() * 1825)::INT, CURRENT_DATE) AS stock_date,
    FLOOR(RANDOM() * 100) + 1 AS stock_level
FROM (
    SELECT (a.n * 100) + (b.n * 10) + c.n + 1 AS id
    FROM
        (SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
         UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) a,
        (SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
         UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) b,
        (SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
         UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) c
) AS seq
WHERE seq.id <= 1000;


INSERT INTO retail.dim_time (date_id, year, quarter, month, day, day_of_week)
SELECT
    DATEADD(day, -seq.id, CURRENT_DATE) AS date_id,
    EXTRACT(YEAR FROM DATEADD(day, -seq.id, CURRENT_DATE)) AS year,
    EXTRACT(QUARTER FROM DATEADD(day, -seq.id, CURRENT_DATE)) AS quarter,
    EXTRACT(MONTH FROM DATEADD(day, -seq.id, CURRENT_DATE)) AS month,
    EXTRACT(DAY FROM DATEADD(day, -seq.id, CURRENT_DATE)) AS day,
    TO_CHAR(DATEADD(day, -seq.id, CURRENT_DATE), 'Day') AS day_of_week
FROM (
    SELECT (a.n * 1000) + (b.n * 100) + (c.n * 10) + d.n + 1 AS id
    FROM
        (SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
         UNION ALL SELECT 5) a,  -- max 6 × 1000 = 6000
        (SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
         UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) b,
        (SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
         UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) c,
        (SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
         UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) d
) AS seq
WHERE seq.id <= 5000;



INSERT INTO retail.dim_employees (
    employee_id,
    employee_name,
    department,
    employment_type,
    hire_date,
    store_id
)
SELECT
    seq.id AS employee_id,
    'Employee_' || seq.id AS employee_name,
    CASE
        WHEN seq.id % 3 = 0 THEN 'HR'
        WHEN seq.id % 3 = 1 THEN 'Sales'
        ELSE 'Operations'
    END AS department,
    CASE
        WHEN seq.id % 2 = 0 THEN 'Full-time'
        ELSE 'Part-time'
    END AS employment_type,
    DATEADD(day, -FLOOR(RANDOM() * 3650)::INT, CURRENT_DATE) AS hire_date,
    (seq.id % 5) + 1 AS store_id
FROM (
    SELECT (a.n * 100) + (b.n * 10) + c.n + 1 AS id
    FROM
        (SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
         UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) a,
        (SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
         UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) b,
        (SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
         UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) c
) AS seq
WHERE seq.id <= 1000;

























