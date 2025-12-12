-- hub_customer
INSERT INTO memory.tpch_tiny_dds.hub_customer (
    customer_hk,
    customer_id,
    load_date,
    source
)
SELECT DISTINCT
    lower(to_hex(sha256(cast(cast(c.custkey AS VARCHAR) AS VARBINARY)))) AS customer_hk,
    c.custkey AS customer_id,
    now() AS load_date,
    'tpch.tiny' AS source
FROM tpch.tiny.customer c;

-- hub_order
INSERT INTO memory.tpch_tiny_dds.hub_order (
    order_hk,
    order_id,
    load_date,
    source
)
SELECT
    lower(to_hex(sha256(cast(cast(o.orderkey AS VARCHAR) AS VARBINARY)))) AS order_hk,
    o.orderkey AS order_id,
    now() AS load_date,
    'tpch.tiny' AS source
FROM tpch.tiny.orders o;

-- hub_part
INSERT INTO memory.tpch_tiny_dds.hub_part (
    part_hk,
    part_id,
    load_date,
    source
)
SELECT DISTINCT
    lower(to_hex(sha256(cast(cast(p.partkey AS VARCHAR) AS VARBINARY)))) AS part_hk,
    p.partkey AS part_id,
    now() AS load_date,
    'tpch.tiny' AS source
FROM tpch.tiny.part p;

-- hub_supplier
INSERT INTO memory.tpch_tiny_dds.hub_supplier (
    supplier_hk,
    supplier_id,
    load_date,
    source
)
SELECT DISTINCT
    lower(to_hex(sha256(cast(cast(s.suppkey AS VARCHAR) AS VARBINARY)))) AS supplier_hk,
    s.suppkey AS supplier_id,
    now() AS load_date,
    'tpch.tiny' AS source
FROM tpch.tiny.supplier s;

-- hub_nation
INSERT INTO memory.tpch_tiny_dds.hub_nation (
    nation_hk,
    nation_id,
    load_date,
    source
)
SELECT DISTINCT
    lower(to_hex(sha256(cast(cast(n.nationkey AS VARCHAR) AS VARBINARY)))) AS nation_hk,
    n.nationkey AS nation_id,
    now() AS load_date,
    'tpch.tiny' AS source
FROM tpch.tiny.nation n;

-- hub_region
INSERT INTO memory.tpch_tiny_dds.hub_region (
    region_hk,
    region_id,
    load_date,
    source
)
SELECT DISTINCT
    lower(to_hex(sha256(cast(cast(r.regionkey AS VARCHAR) AS VARBINARY)))) AS region_hk,
    r.regionkey AS region_id,
    now() AS load_date,
    'tpch.tiny' AS source
FROM tpch.tiny.region r;

-- link_customer_nation
INSERT INTO memory.tpch_tiny_dds.link_customer_nation (
    customer_nation_hk,
    customer_hk,
    nation_hk,
    load_date,
    source
)
SELECT DISTINCT
    lower(to_hex(sha256(cast(concat(cast(c.custkey AS VARCHAR), cast(n.nationkey AS VARCHAR)) AS VARBINARY)))) AS customer_nation_hk,
    lower(to_hex(sha256(cast(cast(c.custkey AS VARCHAR) AS VARBINARY)))) AS customer_hk,
    lower(to_hex(sha256(cast(cast(n.nationkey AS VARCHAR) AS VARBINARY)))) AS nation_hk,
    now() AS load_date,
    'tpch.tiny' AS source
FROM tpch.tiny.customer c
JOIN tpch.tiny.nation n ON c.nationkey = n.nationkey;

-- link_order_customer
INSERT INTO memory.tpch_tiny_dds.link_order_customer (
    order_customer_hk,
    order_hk,
    customer_hk,
    load_date,
    source
)
SELECT
    lower(to_hex(sha256(cast(concat(cast(o.orderkey AS VARCHAR), cast(o.custkey AS VARCHAR)) AS VARBINARY)))) AS order_customer_hk,
    lower(to_hex(sha256(cast(cast(o.orderkey AS VARCHAR) AS VARBINARY)))) AS order_hk,
    lower(to_hex(sha256(cast(cast(o.custkey AS VARCHAR) AS VARBINARY)))) AS customer_hk,
    now() AS load_date,
    'tpch.tiny' AS source
FROM tpch.tiny.orders o;

-- link_lineitem
INSERT INTO memory.tpch_tiny_dds.link_lineitem (
    lineitem_hk,
    order_hk,
    part_hk,
    supplier_hk,
    load_date,
    source
)
SELECT
    lower(to_hex(sha256(cast(concat(cast(l.orderkey AS VARCHAR), cast(l.partkey AS VARCHAR), cast(l.suppkey AS VARCHAR)) AS VARBINARY)))) AS lineitem_hk,
    lower(to_hex(sha256(cast(cast(l.orderkey AS VARCHAR) AS VARBINARY)))) AS order_hk,
    lower(to_hex(sha256(cast(cast(l.partkey AS VARCHAR) AS VARBINARY)))) AS part_hk,
    lower(to_hex(sha256(cast(cast(l.suppkey AS VARCHAR) AS VARBINARY)))) AS supplier_hk,
    now() AS load_date,
    'tpch.tiny' AS source
FROM tpch.tiny.lineitem l;

-- link_partsupp
INSERT INTO memory.tpch_tiny_dds.link_partsupp (
    partsupp_hk,
    part_hk,
    supplier_hk,
    load_date,
    source
)
SELECT DISTINCT
    lower(to_hex(sha256(cast(concat(cast(ps.partkey AS VARCHAR), cast(ps.suppkey AS VARCHAR)) AS VARBINARY)))) AS partsupp_hk,
    lower(to_hex(sha256(cast(cast(ps.partkey AS VARCHAR) AS VARBINARY)))) AS part_hk,
    lower(to_hex(sha256(cast(cast(ps.suppkey AS VARCHAR) AS VARBINARY)))) AS supplier_hk,
    now() AS load_date,
    'tpch.tiny' AS source
FROM tpch.tiny.partsupp ps;

-- link_nation_region
INSERT INTO memory.tpch_tiny_dds.link_nation_region (
    nation_region_hk,
    nation_hk,
    region_hk,
    load_date,
    source
)
SELECT DISTINCT
    lower(to_hex(sha256(cast(concat(cast(n.nationkey AS VARCHAR), cast(r.regionkey AS VARCHAR)) AS VARBINARY)))) AS nation_region_hk,
    lower(to_hex(sha256(cast(cast(n.nationkey AS VARCHAR) AS VARBINARY)))) AS nation_hk,
    lower(to_hex(sha256(cast(cast(r.regionkey AS VARCHAR) AS VARBINARY)))) AS region_hk,
    now() AS load_date,
    'tpch.tiny' AS source
FROM tpch.tiny.nation n
JOIN tpch.tiny.region r ON n.regionkey = r.regionkey;

-- sat_customer_details
INSERT INTO memory.tpch_tiny_dds.sat_customer_details (
    customer_hk,
    name,
    address,
    phone,
    account_balance,
    market_segment,
    comment,
    effective_from,
    load_date,
    source,
    is_active
)
SELECT DISTINCT
    lower(to_hex(sha256(cast(cast(c.custkey AS VARCHAR) AS VARBINARY)))) AS customer_hk,
    c.name,
    c.address,
    c.phone,
    c.acctbal,
    c.mktsegment,
    c.comment,
    now() AS effective_from,
    now() AS load_date,
    'tpch.tiny' AS source,
    true AS is_active
FROM tpch.tiny.customer c;

-- sat_order_details
INSERT INTO memory.tpch_tiny_dds.sat_order_details (
    order_hk,
    status,
    total_price,
    order_date,
    priority,
    clerk,
    ship_priority,
    comment,
    effective_from,
    load_date,
    source,
    is_active
)
SELECT
    lower(to_hex(sha256(cast(cast(o.orderkey AS VARCHAR) AS VARBINARY)))) AS order_hk,
    o.orderstatus,
    o.totalprice,
    o.orderdate,
    o.orderpriority,
    o.clerk,
    o.shippriority,
    o.comment,
    now() AS effective_from,
    now() AS load_date,
    'tpch.tiny' AS source,
    true AS is_active
FROM tpch.tiny.orders o;

-- sat_part_details
INSERT INTO memory.tpch_tiny_dds.sat_part_details (
    part_hk,
    name,
    manufacturer,
    brand,
    type,
    size,
    container,
    retail_price,
    comment,
    effective_from,
    load_date,
    source,
    is_active
)
SELECT DISTINCT
    lower(to_hex(sha256(cast(cast(p.partkey AS VARCHAR) AS VARBINARY)))) AS part_hk,
    p.name,
    p.mfgr,
    p.brand,
    p.type,
    p.size,
    p.container,
    p.retailprice,
    p.comment,
    now() AS effective_from,
    now() AS load_date,
    'tpch.tiny' AS source,
    true AS is_active
FROM tpch.tiny.part p;

-- sat_supplier_details
INSERT INTO memory.tpch_tiny_dds.sat_supplier_details (
    supplier_hk,
    name,
    address,
    phone,
    account_balance,
    comment,
    effective_from,
    load_date,
    source,
    is_active
)
SELECT DISTINCT
    lower(to_hex(sha256(cast(cast(s.suppkey AS VARCHAR) AS VARBINARY)))) AS supplier_hk,
    s.name,
    s.address,
    s.phone,
    s.acctbal,
    s.comment,
    now() AS effective_from,
    now() AS load_date,
    'tpch.tiny' AS source,
    true AS is_active
FROM tpch.tiny.supplier s;

-- sat_nation_details
INSERT INTO memory.tpch_tiny_dds.sat_nation_details (
    nation_hk,
    name,
    comment,
    effective_from,
    load_date,
    source,
    is_active
)
SELECT DISTINCT
    lower(to_hex(sha256(cast(cast(n.nationkey AS VARCHAR) AS VARBINARY)))) AS nation_hk,
    n.name,
    n.comment,
    now() AS effective_from,
    now() AS load_date,
    'tpch.tiny' AS source,
    true AS is_active
FROM tpch.tiny.nation n;

-- sat_region_details
INSERT INTO memory.tpch_tiny_dds.sat_region_details (
    region_hk,
    name,
    comment,
    effective_from,
    load_date,
    source,
    is_active
)
SELECT DISTINCT
    lower(to_hex(sha256(cast(cast(r.regionkey AS VARCHAR) AS VARBINARY)))) AS region_hk,
    r.name,
    r.comment,
    now() AS effective_from,
    now() AS load_date,
    'tpch.tiny' AS source,
    true AS is_active
FROM tpch.tiny.region r;

-- sat_lineitem_details
INSERT INTO memory.tpch_tiny_dds.sat_lineitem_details (
    lineitem_hk,
    line_number,
    quantity,
    extended_price,
    discount,
    tax,
    return_flag,
    status,
    ship_date,
    commit_date,
    receipt_date,
    ship_instructions,
    ship_mode,
    comment,
    effective_from,
    load_date,
    source,
    is_active
)
SELECT
    lower(to_hex(sha256(cast(cast(l.orderkey AS VARCHAR) AS VARBINARY)))) AS lineitem_hk,
    l.linenumber,
    l.quantity,
    l.extendedprice,
    l.discount,
    l.tax,
    l.returnflag,
    l.linestatus,
    l.shipdate,
    l.commitdate,
    l.receiptdate,
    l.shipinstruct,
    l.shipmode,
    l.comment,
    now() AS effective_from,
    now() AS load_date,
    'tpch.tiny' AS source,
    true AS is_active
FROM tpch.tiny.lineitem l;

-- sat_partsupp_details
INSERT INTO memory.tpch_tiny_dds.sat_partsupp_details (
    partsupp_hk,
    available_quantity,
    supply_cost,
    comment,
    effective_from,
    load_date,
    source,
    is_active
)
SELECT DISTINCT
    lower(to_hex(sha256(cast(concat(cast(ps.partkey AS VARCHAR), cast(ps.suppkey AS VARCHAR)) AS VARBINARY)))) AS partsupp_hk,
    ps.availqty,
    ps.supplycost,
    ps.comment,
    now() AS effective_from,
    now() AS load_date,
    'tpch.tiny' AS source,
    true AS is_active
FROM tpch.tiny.partsupp ps;