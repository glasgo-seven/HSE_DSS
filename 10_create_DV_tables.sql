-- DROP TABLE IF EXISTS student2.H_CUSTOMER;
-- CREATE TABLE IF NOT EXISTS student2.H_CUSTOMER (
--     H_CUSTOMER_ID SERIAL PRIMARY KEY,
--     H_CUSTOMER_HASH varchar(32) NOT NULL,
--     load_date timestamp DEFAULT now(),
--     source text DEFAULT 'SampleSuperstore_processed.csv'
-- );

-- HUBS
DROP TABLE IF EXISTS student2.Hub_Customer;
CREATE TABLE IF NOT EXISTS student2.Hub_Customer (
    hub_customer_key    SERIAL PRIMARY KEY,
    customer_hash_key   VARCHAR(64) NOT NULL UNIQUE,
    load_date           TIMESTAMP DEFAULT NOW(),
    source              VARCHAR(50) DEFAULT 'SampleSuperstore_processed.csv'
);

DROP TABLE IF EXISTS student2.Hub_Location;
CREATE TABLE IF NOT EXISTS student2.Hub_Location (
    hub_location_key    SERIAL PRIMARY KEY,
    location_hash_key   VARCHAR(64) NOT NULL UNIQUE,
    load_date           TIMESTAMP DEFAULT NOW(),
    source              VARCHAR(50) DEFAULT 'SampleSuperstore_processed.csv'
);

DROP TABLE IF EXISTS student2.Hub_Product;
CREATE TABLE IF NOT EXISTS student2.Hub_Product (
    hub_product_key     SERIAL PRIMARY KEY,
    product_hash_key    VARCHAR(64) NOT NULL UNIQUE,
    load_date           TIMESTAMP DEFAULT NOW(),
    source              VARCHAR(50) DEFAULT 'SampleSuperstore_processed.csv'
);

DROP TABLE IF EXISTS student2.Hub_Shipping;
CREATE TABLE IF NOT EXISTS student2.Hub_Shipping (
    hub_shipping_key    SERIAL PRIMARY KEY,
    shipping_hash_key   VARCHAR(64) NOT NULL UNIQUE,
    load_date           TIMESTAMP DEFAULT NOW(),
    source              VARCHAR(50) DEFAULT 'SampleSuperstore_processed.csv'
);


-- LINKS
DROP TABLE IF EXISTS student2.Link_Customer_Location;
CREATE TABLE student2.Link_Customer_Location (
    link_customer_location_key  SERIAL PRIMARY KEY,
    hub_customer_key            INT REFERENCES student2.Hub_Customer(hub_customer_key),
    hub_location_key            INT REFERENCES student2.Hub_Location(hub_location_key),
    load_date                   TIMESTAMP DEFAULT NOW(),
    source                      VARCHAR(50) DEFAULT 'SampleSuperstore_processed.csv'
);

DROP TABLE IF EXISTS student2.Link_Order;
CREATE TABLE student2.Link_Order (
    link_order_key              SERIAL PRIMARY KEY,
    hub_customer_key            INT REFERENCES student2.Hub_Customer(hub_customer_key),
    hub_location_key            INT REFERENCES student2.Hub_Location(hub_location_key),
    hub_product_key             INT REFERENCES student2.Hub_Product(hub_product_key),
    hub_shipping_key            INT REFERENCES student2.Hub_Shipping(hub_shipping_key),
    load_date                   TIMESTAMP DEFAULT NOW(),
    source                      VARCHAR(50) DEFAULT 'SampleSuperstore_processed.csv'
);


-- SATELLITES
DROP TABLE IF EXISTS student2.Sat_Customer_Details;
CREATE TABLE student2.Sat_Customer_Details (
    hub_customer_key    INT REFERENCES student2.Hub_Customer(hub_customer_key) PRIMARY KEY,
    load_date           TIMESTAMP DEFAULT NOW(),
    segment             VARCHAR(50),
    state               VARCHAR(50),
    city                VARCHAR(100),
    postal_code         VARCHAR(20),
    is_active           BOOLEAN DEFAULT TRUE
);

DROP TABLE IF EXISTS student2.Sat_Location_Details;
CREATE TABLE student2.Sat_Location_Details (
    hub_location_key    INT REFERENCES student2.Hub_Location(hub_location_key) PRIMARY KEY,
    load_date           TIMESTAMP DEFAULT NOW(),
    country             VARCHAR(100),
    city                VARCHAR(100),
    state               VARCHAR(50),
    postal_code         VARCHAR(20),
    region              VARCHAR(50),
    is_active           BOOLEAN DEFAULT TRUE
);

DROP TABLE IF EXISTS student2.Sat_Product_Details;
CREATE TABLE student2.Sat_Product_Details (
    hub_product_key     INT REFERENCES student2.Hub_Product(hub_product_key) PRIMARY KEY,
    load_date           TIMESTAMP DEFAULT NOW(),
    category            VARCHAR(100),
    sub_category        VARCHAR(100),
    is_active           BOOLEAN DEFAULT TRUE
);

DROP TABLE IF EXISTS student2.Sat_Shipping_Details;
CREATE TABLE student2.Sat_Shipping_Details (
    hub_shipping_key    INT REFERENCES student2.Hub_Shipping(hub_shipping_key) PRIMARY KEY,
    load_date           TIMESTAMP DEFAULT NOW(),
    ship_mode           VARCHAR(50),
    is_active           BOOLEAN DEFAULT TRUE
);

DROP TABLE IF EXISTS student2.Sat_Order_Facts;
CREATE TABLE student2.Sat_Order_Facts (
    link_order_key      INT REFERENCES student2.Link_Order(link_order_key) PRIMARY KEY,
    load_date           TIMESTAMP DEFAULT NOW(),
    sales               DECIMAL(15, 2),
    quantity            INT,
    discount            DECIMAL(5, 2),
    profit              DECIMAL(15, 2)
);
