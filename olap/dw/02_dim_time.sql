CREATE TABLE IF NOT EXISTS dim_time (
    time_key INT PRIMARY KEY, -- Formato HHMMSS
    hour INT NOT NULL,
    minute INT NOT NULL,
    second INT NOT NULL,
    time_of_day VARCHAR(20) NOT NULL
);
