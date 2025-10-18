-- LINKS
TRUNCATE TABLE student2.Link_Customer_Location CASCADE;
ALTER SEQUENCE student2.link_customer_location_link_customer_location_key_seq RESTART WITH 1;
INSERT INTO student2.Link_Customer_Location (
    hub_customer_key,
    hub_location_key
)
SELECT DISTINCT
	hc.hub_customer_key,
	hl.hub_location_key
FROM
	student2.superstore s
JOIN
	student2.hub_customer hc on s.h_customer_id = hc.customer_hash_key
JOIN
	student2.hub_location hl on s.h_location_id = hl.location_hash_key
WHERE NOT EXISTS (
    SELECT 1
    FROM student2.Link_Customer_Location lcl
    WHERE lcl.hub_customer_key = hc.hub_customer_key
      AND lcl.hub_location_key = hl.hub_location_key
);


TRUNCATE TABLE student2.Link_Order CASCADE;
ALTER SEQUENCE student2.Link_Order_link_order_key_seq RESTART WITH 1;
INSERT INTO student2.Link_Order (
    hub_customer_key,
    hub_location_key,
    hub_product_key,
    hub_shipping_key
)
SELECT DISTINCT
	hc.hub_customer_key,
	hl.hub_location_key,
	hp.hub_product_key,
	hs.hub_shipping_key
FROM
	student2.superstore s
JOIN
	student2.hub_customer hc on s.h_customer_id = hc.customer_hash_key
JOIN
	student2.hub_location hl on s.h_location_id = hl.location_hash_key
JOIN
	student2.hub_product hp on s.h_product_id = hp.product_hash_key
JOIN
	student2.hub_shipping hs on s.h_shipping_id = hs.shipping_hash_key
WHERE NOT EXISTS (
    SELECT 1
    FROM student2.Link_Order lo
    WHERE lo.hub_customer_key = hc.hub_customer_key
      AND lo.hub_location_key = hl.hub_location_key
      AND lo.hub_product_key  = hp.hub_product_key
      AND lo.hub_shipping_key = hs.hub_shipping_key
);
