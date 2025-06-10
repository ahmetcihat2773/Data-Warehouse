-- Sink Database Initialization Script
-- This script creates data warehouse schema for receiving data from source

-- Create schema for data warehouse
CREATE SCHEMA IF NOT EXISTS dwh;

-- Create customers dimension table in DWH
CREATE TABLE IF NOT EXISTS dwh.dim_customers (
    customer_key SERIAL PRIMARY KEY,
    customer_id INTEGER UNIQUE NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    city VARCHAR(50),
    country VARCHAR(50),
    source_created_at TIMESTAMP,
    source_updated_at TIMESTAMP,
    dwh_created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    dwh_updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

-- Create products dimension table in DWH
CREATE TABLE IF NOT EXISTS dwh.dim_products (
    product_key SERIAL PRIMARY KEY,
    product_id INTEGER UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    category VARCHAR(50),
    stock_quantity INTEGER DEFAULT 0,
    source_created_at TIMESTAMP,
    source_updated_at TIMESTAMP,
    dwh_created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    dwh_updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

-- Create orders fact table in DWH
CREATE TABLE IF NOT EXISTS dwh.fact_orders (
    order_key SERIAL PRIMARY KEY,
    order_id INTEGER UNIQUE NOT NULL,
    customer_key INTEGER REFERENCES dwh.dim_customers(customer_key),
    order_date DATE NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    status VARCHAR(20),
    source_created_at TIMESTAMP,
    source_updated_at TIMESTAMP,
    dwh_created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    dwh_updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create staging tables for raw data ingestion
CREATE TABLE IF NOT EXISTS staging.raw_customers (
    id INTEGER,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(20),
    address TEXT,
    city VARCHAR(50),
    country VARCHAR(50),
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    ingested_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS staging.raw_products (
    id INTEGER,
    name VARCHAR(100),
    description TEXT,
    price DECIMAL(10,2),
    category VARCHAR(50),
    stock_quantity INTEGER,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    ingested_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS staging.raw_orders (
    id INTEGER,
    customer_id INTEGER,
    order_date DATE,
    total_amount DECIMAL(10,2),
    status VARCHAR(20),
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    ingested_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_dim_customers_id ON dwh.dim_customers(customer_id);
CREATE INDEX IF NOT EXISTS idx_dim_products_id ON dwh.dim_products(product_id);
CREATE INDEX IF NOT EXISTS idx_fact_orders_id ON dwh.fact_orders(order_id);
CREATE INDEX IF NOT EXISTS idx_fact_orders_customer_key ON dwh.fact_orders(customer_key);
CREATE INDEX IF NOT EXISTS idx_fact_orders_date ON dwh.fact_orders(order_date);

-- Create a function to update the dwh_updated_at timestamp
CREATE OR REPLACE FUNCTION update_dwh_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.dwh_updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers to automatically update dwh_updated_at
CREATE TRIGGER update_dim_customers_dwh_updated_at BEFORE UPDATE ON dwh.dim_customers
    FOR EACH ROW EXECUTE FUNCTION update_dwh_updated_at_column();

CREATE TRIGGER update_dim_products_dwh_updated_at BEFORE UPDATE ON dwh.dim_products
    FOR EACH ROW EXECUTE FUNCTION update_dwh_updated_at_column();

CREATE TRIGGER update_fact_orders_dwh_updated_at BEFORE UPDATE ON dwh.fact_orders
    FOR EACH ROW EXECUTE FUNCTION update_dwh_updated_at_column();

-- Create a view for reporting
CREATE VIEW dwh.v_orders_summary AS
SELECT 
    o.order_id,
    o.order_date,
    c.first_name || ' ' || c.last_name as customer_name,
    c.email,
    c.city,
    c.country,
    o.total_amount,
    o.status,
    o.dwh_created_at
FROM dwh.fact_orders o
JOIN dwh.dim_customers c ON o.customer_key = c.customer_key
WHERE c.is_active = TRUE
ORDER BY o.order_date DESC; 