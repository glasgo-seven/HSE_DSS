-- HUBS
DROP TABLE IF EXISTS student2.Hub_Customer CASCADE;
CREATE TABLE IF NOT EXISTS student2.Hub_Customer (
    hub_customer_key    SERIAL PRIMARY KEY,
    customer_hash_key   VARCHAR(64) NOT NULL,
    load_date           TIMESTAMP DEFAULT NOW(),
    source              VARCHAR(100) DEFAULT 'student2.superstore (SampleSuperstore_processed.csv)'
);

DROP TABLE IF EXISTS student2.Hub_Location CASCADE;
CREATE TABLE IF NOT EXISTS student2.Hub_Location (
    hub_location_key    SERIAL PRIMARY KEY,
    location_hash_key   VARCHAR(64) NOT NULL,
    load_date           TIMESTAMP DEFAULT NOW(),
    source              VARCHAR(100) DEFAULT 'student2.superstore (SampleSuperstore_processed.csv)'
);

DROP TABLE IF EXISTS student2.Hub_Product CASCADE;
CREATE TABLE IF NOT EXISTS student2.Hub_Product (
    hub_product_key     SERIAL PRIMARY KEY,
    product_hash_key    VARCHAR(64) NOT NULL,
    load_date           TIMESTAMP DEFAULT NOW(),
    source              VARCHAR(100) DEFAULT 'student2.superstore (SampleSuperstore_processed.csv)'
);

DROP TABLE IF EXISTS student2.Hub_Shipping CASCADE;
CREATE TABLE IF NOT EXISTS student2.Hub_Shipping (
    hub_shipping_key    SERIAL PRIMARY KEY,
    shipping_hash_key   VARCHAR(64) NOT NULL,
    load_date           TIMESTAMP DEFAULT NOW(),
    source              VARCHAR(100) DEFAULT 'student2.superstore (SampleSuperstore_processed.csv)'
);
