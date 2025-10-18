-- SATELLITES
TRUNCATE TABLE student2.Sat_Customer_Details CASCADE;
INSERT INTO student2.Sat_Customer_Details (
    hub_customer_key,
    segment,
    state,
    city,
    postal_code
)
SELECT DISTINCT
    hc.hub_customer_key,
    s.segment,
    s.state,
    s.city,
    s.postal_code
FROM student2.superstore s
JOIN
    student2.hub_customer hc on s.h_customer_id = hc.customer_hash_key
;


TRUNCATE TABLE student2.Sat_Location_Details CASCADE;
INSERT INTO student2.Sat_Location_Details (
    hub_location_key,
    country,
    state,
    city,
    postal_code,
    region
)
SELECT DISTINCT
    hl.hub_location_key,
    s.country,
    s.state,
    s.city,
    s.postal_code,
    s.region
FROM student2.superstore s
JOIN
    student2.hub_location hl on s.h_location_id = hl.location_hash_key
;


TRUNCATE TABLE student2.Sat_Product_Details CASCADE;
INSERT INTO student2.Sat_Product_Details (
    hub_product_key,
    category,
    sub_category
)
SELECT DISTINCT
    hp.hub_product_key,
    s.category,
    s.sub_category
FROM student2.superstore s
JOIN
    student2.hub_product hp on s.h_product_id = hp.product_hash_key
;


TRUNCATE TABLE student2.Sat_Shipping_Details CASCADE;
INSERT INTO student2.Sat_Shipping_Details (
    hub_shipping_key,
    ship_mode
)
SELECT DISTINCT
    hp.hub_shipping_key,
    s.ship_mode
FROM student2.superstore s
JOIN
    student2.hub_shipping hp on s.h_shipping_id = hp.shipping_hash_key
;


TRUNCATE TABLE student2.Sat_Order_Facts CASCADE;
INSERT INTO student2.Sat_Order_Facts (
    link_order_key,
    sales,
    quantity,
    discount,
    profit
)
SELECT DISTINCT ON (lo.link_order_key)
    lo.link_order_key,
    s.sales,
    s.quantity,
    s.discount,
    s.profit
FROM student2.superstore s
JOIN
    student2.hub_customer hc on s.h_customer_id = hc.customer_hash_key
JOIN
    student2.hub_location hl on s.h_location_id = hl.location_hash_key
JOIN
    student2.hub_product hp on s.h_product_id = hp.product_hash_key
JOIN
    student2.hub_shipping hs on s.h_shipping_id = hs.shipping_hash_key
JOIN
    student2.Link_Order lo
    ON  lo.hub_customer_key = hc.hub_customer_key AND
        lo.hub_location_key = hl.hub_location_key AND
        lo.hub_product_key  = hp.hub_product_key  AND
        lo.hub_shipping_key = hs.hub_shipping_key
WHERE NOT EXISTS (
    SELECT 1
    FROM student2.Sat_Order_Facts sof
    WHERE sof.link_order_key = lo.link_order_key
)
ORDER BY lo.link_order_key DESC;
