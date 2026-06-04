-- ──────────────────────────────────────────────────────────────
--  Manual data-quality checks (run against the WAREHOUSE).
--  The Python ETL runs equivalent checks automatically after each load;
--  this file is for ad-hoc inspection with psql.
-- ──────────────────────────────────────────────────────────────

-- Row counts per table.
SELECT 'dim_date'           AS table_name, count(*) FROM dim_date
UNION ALL SELECT 'dim_time',            count(*) FROM dim_time
UNION ALL SELECT 'dim_branch',          count(*) FROM dim_branch
UNION ALL SELECT 'dim_product',         count(*) FROM dim_product
UNION ALL SELECT 'dim_payment_method',  count(*) FROM dim_payment_method
UNION ALL SELECT 'fact_sales',          count(*) FROM fact_sales
ORDER BY table_name;

-- No negative discounts and unit_price never above base price.
SELECT count(*) AS negative_discounts   FROM fact_sales WHERE discount_amount < 0;
SELECT count(*) AS unit_price_over_base  FROM fact_sales WHERE unit_price > base_price_at_sale;

-- Referential integrity (should all be zero; FKs enforce this).
SELECT count(*) AS orphan_date    FROM fact_sales f LEFT JOIN dim_date d            USING (date_key)            WHERE d.date_key            IS NULL;
SELECT count(*) AS orphan_time    FROM fact_sales f LEFT JOIN dim_time t            USING (time_key)            WHERE t.time_key            IS NULL;
SELECT count(*) AS orphan_branch  FROM fact_sales f LEFT JOIN dim_branch b          USING (branch_key)          WHERE b.branch_key          IS NULL;
SELECT count(*) AS orphan_product FROM fact_sales f LEFT JOIN dim_product p         USING (product_key)         WHERE p.product_key         IS NULL;
SELECT count(*) AS orphan_payment FROM fact_sales f LEFT JOIN dim_payment_method pm USING (payment_method_key)  WHERE pm.payment_method_key IS NULL;

-- Sample business query: revenue & discount by country and month.
SELECT
    b.country_name,
    d.year,
    d.month_name,
    sum(f.subtotal)        AS revenue,
    sum(f.discount_amount) AS discount
FROM fact_sales f
JOIN dim_branch b ON b.branch_key = f.branch_key
JOIN dim_date   d ON d.date_key   = f.date_key
GROUP BY b.country_name, d.year, d.month, d.month_name
ORDER BY b.country_name, d.year, d.month;
