CREATE TABLE IF NOT EXISTS fact_sales (
    date_key INT NOT NULL REFERENCES dim_date(date_key),
    time_key INT NOT NULL REFERENCES dim_time(time_key),
    branch_key INT NOT NULL REFERENCES dim_branch(branch_key),
    product_key INT NOT NULL REFERENCES dim_product(product_key),
    payment_method_key INT NOT NULL REFERENCES dim_payment_method(payment_method_key),
    sale_id INT NOT NULL,
    ticket_number VARCHAR(100),
    quantity NUMERIC(8, 3) NOT NULL,
    unit_price NUMERIC(10, 2) NOT NULL,
    base_price_at_sale NUMERIC(10, 2) NOT NULL,
    subtotal NUMERIC(12, 2) NOT NULL,
    discount_amount NUMERIC(12, 2) NOT NULL,
    PRIMARY KEY (date_key, time_key, branch_key, product_key, payment_method_key)
);
