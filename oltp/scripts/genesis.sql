-- ------------------------------------------------------------
--  SALES - GENESIS SCRIPT
-- ------------------------------------------------------------

-- =====================================================
-- SCHEMAS
-- =====================================================
CREATE SCHEMA IF NOT EXISTS hans;
SET search_path TO hans;


-- =====================================================
-- ENUMS
-- =====================================================
CREATE TYPE payment_method AS ENUM (
  'CARD', 
  'CASH'
);


-- =====================================================
-- TABLES
-- =====================================================
-- ----------------------------------
-- 1. Countries
-- ----------------------------------
CREATE TABLE countries (
    country_id SERIAL PRIMARY KEY,
    key VARCHAR(10) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL UNIQUE
);

-- ----------------------------------
-- 2. States
-- ----------------------------------
CREATE TABLE states (
    state_id SERIAL PRIMARY KEY,
    key VARCHAR(10) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    country_id INT NOT NULL REFERENCES countries(country_id) ON DELETE CASCADE
);

-- ----------------------------------
-- 3. Branches
-- ----------------------------------
CREATE TABLE branches (
    branch_id SERIAL PRIMARY KEY,
    state_id INT NOT NULL REFERENCES states(state_id) ON DELETE RESTRICT,
    name VARCHAR(100) NOT NULL,
    address TEXT NOT NULL
);

-- ----------------------------------
-- 4. Categories
-- ----------------------------------
CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);

-- ----------------------------------
-- 5. Products
-- ----------------------------------
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    category_id INT NOT NULL REFERENCES categories(category_id) ON DELETE RESTRICT,
    sku VARCHAR(50) NOT NULL UNIQUE,
    barcode VARCHAR(50) UNIQUE,
    name VARCHAR(200) NOT NULL,
    base_price NUMERIC(10, 2) NOT NULL
);

CREATE INDEX idx_products_barcode ON products(barcode);

-- ----------------------------------
-- 6. Sales
-- ----------------------------------
CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    branch_id INT NOT NULL REFERENCES branches(branch_id) ON DELETE RESTRICT,
    sale_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    total_amount NUMERIC(12, 2) NOT NULL,
    method payment_method NOT NULL,
    ticket_number VARCHAR(100) UNIQUE
);

CREATE INDEX idx_sales_branch_date ON sales(branch_id, sale_date);

-- ----------------------------------
-- 7. Sale Details
-- ----------------------------------
CREATE TABLE sale_details (
    sale_id INT NOT NULL REFERENCES sales(sale_id) ON DELETE CASCADE,
    product_id INT NOT NULL REFERENCES products(product_id) ON DELETE RESTRICT,
    quantity NUMERIC(8, 3) NOT NULL CHECK (quantity > 0), 
    unit_price NUMERIC(10, 2) NOT NULL CHECK (unit_price >= 0),
    subtotal NUMERIC(12, 2) NOT NULL CHECK (subtotal >= 0),
    PRIMARY KEY (sale_id, product_id)
);
