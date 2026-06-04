CREATE TABLE IF NOT EXISTS dim_payment_method (
    payment_method_key SERIAL PRIMARY KEY,
    method_name VARCHAR(50) NOT NULL
);
