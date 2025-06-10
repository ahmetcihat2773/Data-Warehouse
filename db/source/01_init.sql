-- Source Database Initialization Script
-- This script creates sample tables and data for demonstration

-- Create a sample customers table
CREATE TABLE IF NOT EXISTS customers (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    city VARCHAR(50),
    country VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create a sample orders table
CREATE TABLE IF NOT EXISTS orders (
    id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(id),
    order_date DATE NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create a sample products table
CREATE TABLE IF NOT EXISTS products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    category VARCHAR(50),
    stock_quantity INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample data into customers
INSERT INTO customers (first_name, last_name, email, phone, address, city, country) VALUES
('Ahmet', 'Yılmaz', 'ahmet.yilmaz@example.com', '+90 555 123 4567', 'Atatürk Cad. No:123', 'İstanbul', 'Türkiye'),
('Ayşe', 'Demir', 'ayse.demir@example.com', '+90 555 987 6543', 'İnönü Sok. No:45', 'Ankara', 'Türkiye'),
('Mehmet', 'Kaya', 'mehmet.kaya@example.com', '+90 555 456 7890', 'Cumhuriyet Meydan No:67', 'İzmir', 'Türkiye'),
('Fatma', 'Özkan', 'fatma.ozkan@example.com', '+90 555 321 0987', 'Barbaros Blv. No:89', 'Bursa', 'Türkiye');

-- Insert sample data into products
INSERT INTO products (name, description, price, category, stock_quantity) VALUES
('Laptop', 'High performance laptop', 15000.00, 'Electronics', 50),
('Mouse', 'Wireless optical mouse', 150.00, 'Electronics', 200),
('Keyboard', 'Mechanical keyboard', 500.00, 'Electronics', 75),
('Monitor', '27 inch 4K monitor', 3000.00, 'Electronics', 30),
('Chair', 'Ergonomic office chair', 2500.00, 'Furniture', 25);

-- Insert sample data into orders
INSERT INTO orders (customer_id, order_date, total_amount, status) VALUES
(1, '2024-01-15', 15150.00, 'completed'),
(2, '2024-01-16', 3500.00, 'completed'),
(3, '2024-01-17', 650.00, 'pending'),
(4, '2024-01-18', 2500.00, 'shipped'),
(1, '2024-01-19', 3000.00, 'pending');

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_customers_email ON customers(email);
CREATE INDEX IF NOT EXISTS idx_orders_customer_id ON orders(customer_id);
CREATE INDEX IF NOT EXISTS idx_orders_order_date ON orders(order_date);
CREATE INDEX IF NOT EXISTS idx_products_category ON products(category);

-- Create a function to update the updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers to automatically update updated_at
CREATE TRIGGER update_customers_updated_at BEFORE UPDATE ON customers
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_orders_updated_at BEFORE UPDATE ON orders
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_products_updated_at BEFORE UPDATE ON products
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column(); 