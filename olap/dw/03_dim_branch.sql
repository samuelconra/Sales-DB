CREATE TABLE IF NOT EXISTS dim_branch (
    branch_key SERIAL PRIMARY KEY,
    branch_id INT NOT NULL,
    branch_name VARCHAR(100) NOT NULL,
    address TEXT NOT NULL,
    state_code VARCHAR(10) NOT NULL,
    state_name VARCHAR(100) NOT NULL,
    country_code VARCHAR(10) NOT NULL,
    country_name VARCHAR(100) NOT NULL
);
