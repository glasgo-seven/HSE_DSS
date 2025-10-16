CREATE SCHEMA IF NOT EXISTS student2;

DROP TABLE IF EXISTS student2.superstore;
CREATE TABLE IF NOT EXISTS student2.superstore (
    ship_mode text,
    segment text,
    country text,
    city text,
    state text,
    postal_code text,
    region text,
    category text,
    sub_category text,
    sales numeric(18,4),
    quantity integer,
    discount numeric(9,4),
    profit numeric(18,4),
    H_CUSTOMER_ID text,
    H_LOCATION_ID text,
    H_PRODUCT_ID text,
    H_SHIPPING_ID text,
    load_dts timestamp without time zone default now(),
    record_source text default 'SampleSuperstore_processed.csv'
);

CREATE OR REPLACE FUNCTION md5(t text)
RETURNS char(32)
LANGUAGE sql
IMMUTABLE
AS $$
    SELECT md5(coalesce(t,''))::char(32);
$$;
