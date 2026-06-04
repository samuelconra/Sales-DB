-- Source rows for fact_sales, at the grain of one sale line item.
--
-- sale_date (TIMESTAMPTZ) is converted to a single, configurable business
-- timezone (%(tz)s) so date_key / time_key are deterministic. base_price_at_sale
-- uses the current products.base_price because the OLTP keeps no price history;
-- discount_amount is derived downstream in Python from (base_price, subtotal).
SELECT
    sd.sale_id,
    s.ticket_number,
    s.branch_id,
    sd.product_id,
    s.method::text                    AS method_name,
    sd.quantity,
    sd.unit_price,
    p.base_price                      AS base_price_at_sale,
    sd.subtotal,
    (s.sale_date AT TIME ZONE %(tz)s) AS sale_ts
FROM sale_details sd
JOIN sales    s ON s.sale_id    = sd.sale_id
JOIN products p ON p.product_id = sd.product_id
ORDER BY sd.sale_id, sd.product_id;
