-- SATELLITES
DROP TABLE IF EXISTS student2.Sat_Customer_Details CASCADE;
CREATE TABLE student2.Sat_Customer_Details (
    hub_customer_key    INT REFERENCES student2.Hub_Customer(hub_customer_key) PRIMARY KEY,
    load_date           TIMESTAMP DEFAULT NOW(),
    segment             VARCHAR(50),
    state               VARCHAR(50),
    city                VARCHAR(100),
    postal_code         VARCHAR(20),
    is_active           BOOLEAN DEFAULT TRUE
);

DROP TABLE IF EXISTS student2.Sat_Location_Details CASCADE;
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

DROP TABLE IF EXISTS student2.Sat_Product_Details CASCADE;
CREATE TABLE student2.Sat_Product_Details (
    hub_product_key     INT REFERENCES student2.Hub_Product(hub_product_key) PRIMARY KEY,
    load_date           TIMESTAMP DEFAULT NOW(),
    category            VARCHAR(100),
    sub_category        VARCHAR(100),
    is_active           BOOLEAN DEFAULT TRUE
);

DROP TABLE IF EXISTS student2.Sat_Shipping_Details CASCADE;
CREATE TABLE student2.Sat_Shipping_Details (
    hub_shipping_key    INT REFERENCES student2.Hub_Shipping(hub_shipping_key) PRIMARY KEY,
    load_date           TIMESTAMP DEFAULT NOW(),
    ship_mode           VARCHAR(50),
    is_active           BOOLEAN DEFAULT TRUE
);

DROP TABLE IF EXISTS student2.Sat_Order_Facts CASCADE;
CREATE TABLE student2.Sat_Order_Facts (
    link_order_key      INT REFERENCES student2.Link_Order(link_order_key) PRIMARY KEY,
    load_date           TIMESTAMP DEFAULT NOW(),
    sales               DECIMAL(15, 2),
    quantity            INT,
    discount            DECIMAL(5, 2),
    profit              DECIMAL(15, 2)
);
