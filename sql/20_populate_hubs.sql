-- HUBS
TRUNCATE TABLE student2.Hub_Customer CASCADE;
INSERT INTO student2.Hub_Customer ( customer_hash_key )
SELECT DISTINCT h_customer_id
FROM student2.superstore;


TRUNCATE TABLE student2.Hub_Location CASCADE;
INSERT INTO student2.Hub_Location ( location_hash_key )
SELECT DISTINCT h_location_id
FROM student2.superstore;


TRUNCATE TABLE student2.Hub_Product CASCADE;
INSERT INTO student2.Hub_Product ( product_hash_key )
SELECT DISTINCT h_product_id
FROM student2.superstore;


TRUNCATE TABLE student2.Hub_Shipping CASCADE;
INSERT INTO student2.Hub_Shipping ( shipping_hash_key )
SELECT DISTINCT h_shipping_id
FROM student2.superstore;
