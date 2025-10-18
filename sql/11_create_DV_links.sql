-- LINKS
DROP TABLE IF EXISTS student2.Link_Customer_Location CASCADE;
CREATE TABLE student2.Link_Customer_Location (
    link_customer_location_key  SERIAL PRIMARY KEY,
    hub_customer_key            INT REFERENCES student2.Hub_Customer(hub_customer_key),
    hub_location_key            INT REFERENCES student2.Hub_Location(hub_location_key),
    load_date                   TIMESTAMP DEFAULT NOW(),
    source                      VARCHAR(100) DEFAULT 'student2.superstore (SampleSuperstore_processed.csv)'
);

DROP TABLE IF EXISTS student2.Link_Order CASCADE;
CREATE TABLE student2.Link_Order (
    link_order_key              SERIAL PRIMARY KEY,
    hub_customer_key            INT REFERENCES student2.Hub_Customer(hub_customer_key),
    hub_location_key            INT REFERENCES student2.Hub_Location(hub_location_key),
    hub_product_key             INT REFERENCES student2.Hub_Product(hub_product_key),
    hub_shipping_key            INT REFERENCES student2.Hub_Shipping(hub_shipping_key),
    load_date                   TIMESTAMP DEFAULT NOW(),
    source                      VARCHAR(100) DEFAULT 'student2.superstore (SampleSuperstore_processed.csv)'
);
