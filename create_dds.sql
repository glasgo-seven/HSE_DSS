-- Create memory.tpch_tiny_dds schema
DROP SCHEMA IF EXISTS memory.tpch_tiny_dds CASCADE;
CREATE SCHEMA memory.tpch_tiny_dds;

-- Hubs

-- hub_customer
DROP TABLE IF EXISTS memory.tpch_tiny_dds.hub_customer;
CREATE TABLE memory.tpch_tiny_dds.hub_customer (
    customer_hk VARCHAR,
    customer_id INTEGER NOT NULL,
    load_date TIMESTAMP NOT NULL,
    source VARCHAR NOT NULL
);

-- hub_order
DROP TABLE IF EXISTS memory.tpch_tiny_dds.hub_order;
CREATE TABLE memory.tpch_tiny_dds.hub_order (
    order_hk VARCHAR,
    order_id INTEGER NOT NULL,
    load_date TIMESTAMP NOT NULL,
    source VARCHAR NOT NULL
);

-- hub_part
DROP TABLE IF EXISTS memory.tpch_tiny_dds.hub_part;
CREATE TABLE memory.tpch_tiny_dds.hub_part (
    part_hk VARCHAR,
    part_id INTEGER NOT NULL,
    load_date TIMESTAMP NOT NULL,
    source VARCHAR NOT NULL
);

-- hub_supplier
DROP TABLE IF EXISTS memory.tpch_tiny_dds.hub_supplier;
CREATE TABLE memory.tpch_tiny_dds.hub_supplier (
    supplier_hk VARCHAR,
    supplier_id INTEGER NOT NULL,
    load_date TIMESTAMP NOT NULL,
    source VARCHAR NOT NULL
);

-- hub_nation
DROP TABLE IF EXISTS memory.tpch_tiny_dds.hub_nation;
CREATE TABLE memory.tpch_tiny_dds.hub_nation (
    nation_hk VARCHAR,
    nation_id INTEGER NOT NULL,
    load_date TIMESTAMP NOT NULL,
    source VARCHAR NOT NULL
);

-- hub_region
DROP TABLE IF EXISTS memory.tpch_tiny_dds.hub_region;
CREATE TABLE memory.tpch_tiny_dds.hub_region (
    region_hk VARCHAR,
    region_id INTEGER NOT NULL,
    load_date TIMESTAMP NOT NULL,
    source VARCHAR NOT NULL
);

-- Links

-- link_customer_nation
DROP TABLE IF EXISTS memory.tpch_tiny_dds.link_customer_nation;
CREATE TABLE memory.tpch_tiny_dds.link_customer_nation (
    customer_nation_hk VARCHAR,
    customer_hk VARCHAR NOT NULL,
    nation_hk VARCHAR NOT NULL,
    load_date TIMESTAMP NOT NULL,
    source VARCHAR NOT NULL
);

-- link_order_customer
DROP TABLE IF EXISTS memory.tpch_tiny_dds.link_order_customer;
CREATE TABLE memory.tpch_tiny_dds.link_order_customer (
    order_customer_hk VARCHAR,
    order_hk VARCHAR NOT NULL,
    customer_hk VARCHAR NOT NULL,
    load_date TIMESTAMP NOT NULL,
    source VARCHAR NOT NULL
);

-- link_lineitem
DROP TABLE IF EXISTS memory.tpch_tiny_dds.link_lineitem;
CREATE TABLE memory.tpch_tiny_dds.link_lineitem (
    lineitem_hk VARCHAR,
    order_hk VARCHAR NOT NULL,
    part_hk VARCHAR NOT NULL,
    supplier_hk VARCHAR NOT NULL,
    load_date TIMESTAMP NOT NULL,
    source VARCHAR NOT NULL
);

-- link_partsupp
DROP TABLE IF EXISTS memory.tpch_tiny_dds.link_partsupp;
CREATE TABLE memory.tpch_tiny_dds.link_partsupp (
    partsupp_hk VARCHAR,
    part_hk VARCHAR NOT NULL,
    supplier_hk VARCHAR NOT NULL,
    load_date TIMESTAMP NOT NULL,
    source VARCHAR NOT NULL
);

-- link_nation_region
DROP TABLE IF EXISTS memory.tpch_tiny_dds.link_nation_region;
CREATE TABLE memory.tpch_tiny_dds.link_nation_region (
    nation_region_hk VARCHAR,
    nation_hk VARCHAR NOT NULL,
    region_hk VARCHAR NOT NULL,
    load_date TIMESTAMP NOT NULL,
    source VARCHAR NOT NULL
);

-- Satellites

-- sat_customer_details
DROP TABLE IF EXISTS memory.tpch_tiny_dds.sat_customer_details;
CREATE TABLE memory.tpch_tiny_dds.sat_customer_details (
    customer_hk VARCHAR NOT NULL,
    name VARCHAR NOT NULL,
    address VARCHAR NOT NULL,
    phone VARCHAR NOT NULL,
    account_balance DOUBLE NOT NULL,
    market_segment VARCHAR NOT NULL,
    comment VARCHAR NOT NULL,
    effective_from TIMESTAMP NOT NULL,
    load_date TIMESTAMP NOT NULL,
    source VARCHAR NOT NULL,
    is_active BOOLEAN DEFAULT TRUE
);

-- sat_order_details
DROP TABLE IF EXISTS memory.tpch_tiny_dds.sat_order_details;
CREATE TABLE memory.tpch_tiny_dds.sat_order_details (
    order_hk VARCHAR NOT NULL,
    status VARCHAR NOT NULL,
    total_price DOUBLE NOT NULL,
    order_date DATE NOT NULL,
    priority VARCHAR NOT NULL,
    clerk VARCHAR NOT NULL,
    ship_priority INTEGER NOT NULL,
    comment VARCHAR NOT NULL,
    effective_from TIMESTAMP NOT NULL,
    load_date TIMESTAMP NOT NULL,
    source VARCHAR NOT NULL,
    is_active BOOLEAN DEFAULT TRUE
);

-- sat_part_details
DROP TABLE IF EXISTS memory.tpch_tiny_dds.sat_part_details;
CREATE TABLE memory.tpch_tiny_dds.sat_part_details (
    part_hk VARCHAR NOT NULL,
    name VARCHAR NOT NULL,
    manufacturer VARCHAR NOT NULL,
    brand VARCHAR NOT NULL,
    type VARCHAR NOT NULL,
    size INTEGER NOT NULL,
    container VARCHAR NOT NULL,
    retail_price DOUBLE NOT NULL,
    comment VARCHAR NOT NULL,
    effective_from TIMESTAMP NOT NULL,
    load_date TIMESTAMP NOT NULL,
    source VARCHAR NOT NULL,
    is_active BOOLEAN DEFAULT TRUE
);

-- sat_supplier_details
DROP TABLE IF EXISTS memory.tpch_tiny_dds.sat_supplier_details;
CREATE TABLE memory.tpch_tiny_dds.sat_supplier_details (
    supplier_hk VARCHAR NOT NULL,
    name VARCHAR NOT NULL,
    address VARCHAR NOT NULL,
    phone VARCHAR NOT NULL,
    account_balance DOUBLE NOT NULL,
    comment VARCHAR NOT NULL,
    effective_from TIMESTAMP NOT NULL,
    load_date TIMESTAMP NOT NULL,
    source VARCHAR NOT NULL,
    is_active BOOLEAN DEFAULT TRUE
);

-- sat_nation_details
DROP TABLE IF EXISTS memory.tpch_tiny_dds.sat_nation_details;
CREATE TABLE memory.tpch_tiny_dds.sat_nation_details (
    nation_hk VARCHAR NOT NULL,
    name VARCHAR NOT NULL,
    comment VARCHAR NOT NULL,
    effective_from TIMESTAMP NOT NULL,
    load_date TIMESTAMP NOT NULL,
    source VARCHAR NOT NULL,
    is_active BOOLEAN DEFAULT TRUE
);

-- sat_region_details
DROP TABLE IF EXISTS memory.tpch_tiny_dds.sat_region_details;
CREATE TABLE memory.tpch_tiny_dds.sat_region_details (
    region_hk VARCHAR NOT NULL,
    name VARCHAR NOT NULL,
    comment VARCHAR NOT NULL,
    effective_from TIMESTAMP NOT NULL,
    load_date TIMESTAMP NOT NULL,
    source VARCHAR NOT NULL,
    is_active BOOLEAN DEFAULT TRUE
);

-- sat_lineitem_details
DROP TABLE IF EXISTS memory.tpch_tiny_dds.sat_lineitem_details;
CREATE TABLE memory.tpch_tiny_dds.sat_lineitem_details (
    lineitem_hk VARCHAR NOT NULL,
    line_number INTEGER NOT NULL,
    quantity DOUBLE NOT NULL,
    extended_price DOUBLE NOT NULL,
    discount DOUBLE NOT NULL,
    tax DOUBLE NOT NULL,
    return_flag VARCHAR NOT NULL,
    status VARCHAR NOT NULL,
    ship_date DATE NOT NULL,
    commit_date DATE NOT NULL,
    receipt_date DATE NOT NULL,
    ship_instructions VARCHAR NOT NULL,
    ship_mode VARCHAR NOT NULL,
    comment VARCHAR NOT NULL,
    effective_from TIMESTAMP NOT NULL,
    load_date TIMESTAMP NOT NULL,
    source VARCHAR NOT NULL,
    is_active BOOLEAN DEFAULT TRUE
);

-- sat_partsupp_details
DROP TABLE IF EXISTS memory.tpch_tiny_dds.sat_partsupp_details;
CREATE TABLE memory.tpch_tiny_dds.sat_partsupp_details (
    partsupp_hk VARCHAR NOT NULL,
    available_quantity INTEGER NOT NULL,
    supply_cost DOUBLE NOT NULL,
    comment VARCHAR NOT NULL,
    effective_from TIMESTAMP NOT NULL,
    load_date TIMESTAMP NOT NULL,
    source VARCHAR NOT NULL,
    is_active BOOLEAN DEFAULT TRUE
);

DROP TABLE IF EXISTS memory.tpch_tiny_dds.temp_target_date;
CREATE TABLE memory.tpch_tiny_dds.temp_target_date AS
SELECT date '2024-01-01' AS date_value;