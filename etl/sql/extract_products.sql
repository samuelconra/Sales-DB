-- Source rows for dim_product: flatten product -> category.
-- current_base_price uses the live products.base_price (OLTP keeps no price history).
SELECT
    p.product_id,
    p.sku,
    p.barcode,
    p.name          AS product_name,
    p.base_price    AS current_base_price,
    cat.name        AS category_name,
    cat.description AS category_description
FROM products p
JOIN categories cat ON cat.category_id = p.category_id
ORDER BY p.product_id;
