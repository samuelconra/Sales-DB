-- Source rows for dim_payment_method: every value defined by the ENUM type,
-- so the dimension is complete even if a method has no sales yet.
SELECT unnest(enum_range(NULL::payment_method))::text AS method_name;
