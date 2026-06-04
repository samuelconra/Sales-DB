CREATE TABLE IF NOT EXISTS dim_product (
    product_key SERIAL PRIMARY KEY,
    product_id INT NOT NULL,
    sku VARCHAR(50) NOT NULL,
    barcode VARCHAR(50),
    product_name VARCHAR(200) NOT NULL,
    current_base_price NUMERIC(10, 2) NOT NULL,
    category_name VARCHAR(100) NOT NULL,
    category_description TEXT
);
