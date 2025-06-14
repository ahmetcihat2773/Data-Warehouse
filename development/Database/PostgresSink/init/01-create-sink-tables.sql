-- Sink database initialization script
-- This script will be run when the PostgreSQL sink container starts

-- Create the target tables that will receive data from Kafka Connect
-- These should match the source table structure

-- Create users table (target for CDC data)
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create orders table (target for CDC data)
CREATE TABLE IF NOT EXISTS orders (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2),
    status VARCHAR(20) DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for better performance on sink side
CREATE INDEX IF NOT EXISTS idx_users_username ON users(username);
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_orders_user_id ON orders(user_id);
CREATE INDEX IF NOT EXISTS idx_orders_status ON orders(status);
CREATE INDEX IF NOT EXISTS idx_orders_date ON orders(order_date);

-- Create a trigger to update the updated_at column for sink tables
CREATE OR REPLACE FUNCTION update_sink_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply the trigger to sink tables
CREATE TRIGGER update_sink_users_updated_at 
    BEFORE UPDATE ON users 
    FOR EACH ROW EXECUTE FUNCTION update_sink_updated_at_column();

CREATE TRIGGER update_sink_orders_updated_at 
    BEFORE UPDATE ON orders 
    FOR EACH ROW EXECUTE FUNCTION update_sink_updated_at_column();

-- Create a table to track data lineage and CDC metadata
CREATE TABLE IF NOT EXISTS cdc_metadata (
    id SERIAL PRIMARY KEY,
    table_name VARCHAR(100) NOT NULL,
    operation VARCHAR(10) NOT NULL, -- INSERT, UPDATE, DELETE
    source_timestamp TIMESTAMP,
    sink_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    record_id INTEGER,
    metadata JSONB
);

-- Create index for metadata table
CREATE INDEX IF NOT EXISTS idx_cdc_metadata_table ON cdc_metadata(table_name);
CREATE INDEX IF NOT EXISTS idx_cdc_metadata_timestamp ON cdc_metadata(sink_timestamp);

-- Grant necessary permissions (if needed for specific users)
-- GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO sink_user;
-- GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO sink_user; 