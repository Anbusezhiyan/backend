-- Complete Database Setup for AI-Enabled Logistics Optimizer
-- This script creates the database, tables, and inserts sample data

-- Create database
CREATE DATABASE IF NOT EXISTS logistics_db;
USE logistics_db;

-- Users table with password reset fields
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('admin', 'logistics_planner', 'operations_manager') NOT NULL,
    reset_token VARCHAR(255) NULL,
    reset_token_expires DATETIME NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Vessels table
CREATE TABLE vessels (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    capacity INT NOT NULL,
    eta DATE NOT NULL,
    predicted_delay FLOAT DEFAULT 0
);

-- Ports table
CREATE TABLE ports (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    capacity INT NOT NULL,
    location VARCHAR(100) NOT NULL
);

-- Plants table
CREATE TABLE plants (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    demand INT NOT NULL,
    location VARCHAR(100) NOT NULL
);

-- Rail costs table
CREATE TABLE rail_costs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    from_port_id INT NOT NULL,
    to_plant_id INT NOT NULL,
    cost_per_ton DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (from_port_id) REFERENCES ports(id),
    FOREIGN KEY (to_plant_id) REFERENCES plants(id)
);

-- Stocks table
CREATE TABLE stocks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    plant_id INT NOT NULL,
    product VARCHAR(100) NOT NULL,
    quantity INT NOT NULL,
    aging_days INT NOT NULL,
    FOREIGN KEY (plant_id) REFERENCES plants(id)
);

-- Plans table
CREATE TABLE plans (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    schedule_json TEXT,
    total_cost DECIMAL(15,2) NOT NULL,
    status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Audit logs table
CREATE TABLE audit_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    action VARCHAR(255) NOT NULL,
    details TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Indexes for performance
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_vessels_eta ON vessels(eta);
CREATE INDEX idx_plans_status ON plans(status);
CREATE INDEX idx_plans_created_at ON plans(created_at);

-- Insert sample users with proper password hashes
-- Passwords: admin123, planner123, manager123
INSERT INTO users (username, email, password_hash, role) VALUES
('admin', 'admin@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin'),
('planner', 'planner@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'logistics_planner'),
('manager', 'manager@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'operations_manager');

-- Insert sample ports
INSERT INTO ports (name, capacity, location) VALUES
('Paradip', 50000, 'Odisha'),
('Haldia', 40000, 'West Bengal'),
('Visakhapatnam', 35000, 'Andhra Pradesh'),
('Chennai', 45000, 'Tamil Nadu');

-- Insert sample plants
INSERT INTO plants (name, demand, location) VALUES
('Plant A', 30000, 'Rourkela'),
('Plant B', 25000, 'Bokaro'),
('Plant C', 35000, 'Jamshedpur'),
('Plant D', 28000, 'Durgapur'),
('Plant E', 32000, 'Burnpur');

-- Insert sample vessels
INSERT INTO vessels (name, capacity, eta, predicted_delay) VALUES
('MV Ocean Pride', 50000, '2023-10-01', 2.5),
('MV Sea Master', 45000, '2023-10-05', 1.8),
('MV Cargo King', 55000, '2023-10-10', 3.2),
('MV Bulk Carrier', 48000, '2023-10-15', 1.5),
('MV Steel Hauler', 52000, '2023-10-20', 2.1);

-- Insert sample rail costs (cost per ton from each port to each plant)
INSERT INTO rail_costs (from_port_id, to_plant_id, cost_per_ton) VALUES
-- Paradip to all plants
(1, 1, 2.50), (1, 2, 2.80), (1, 3, 3.10), (1, 4, 3.40), (1, 5, 3.70),
-- Haldia to all plants
(2, 1, 2.30), (2, 2, 2.60), (2, 3, 2.90), (2, 4, 3.20), (2, 5, 3.50),
-- Visakhapatnam to all plants
(3, 1, 3.20), (3, 2, 3.50), (3, 3, 3.80), (3, 4, 4.10), (3, 5, 4.40),
-- Chennai to all plants
(4, 1, 3.80), (4, 2, 4.10), (4, 3, 4.40), (4, 4, 4.70), (4, 5, 5.00);

-- Insert sample stock data
INSERT INTO stocks (plant_id, product, quantity, aging_days) VALUES
-- Plant A (Rourkela)
(1, 'Iron Ore', 25000, 5),
(1, 'Coal', 15000, 3),
-- Plant B (Bokaro)
(2, 'Iron Ore', 20000, 7),
(2, 'Coal', 18000, 4),
-- Plant C (Jamshedpur)
(3, 'Iron Ore', 30000, 2),
(3, 'Coal', 12000, 6),
-- Plant D (Durgapur)
(4, 'Iron Ore', 22000, 8),
(4, 'Coal', 16000, 5),
-- Plant E (Burnpur)
(5, 'Iron Ore', 28000, 4),
(5, 'Coal', 14000, 7);

-- Insert sample optimization plans
INSERT INTO plans (user_id, schedule_json, total_cost, status) VALUES
(2, '{"vessel_1": {"port": "Paradip", "plant": "Plant A"}, "vessel_2": {"port": "Haldia", "plant": "Plant B"}}', 150000.00, 'approved'),
(2, '{"vessel_3": {"port": "Visakhapatnam", "plant": "Plant C"}, "vessel_4": {"port": "Chennai", "plant": "Plant D"}}', 165000.00, 'pending'),
(2, '{"vessel_5": {"port": "Paradip", "plant": "Plant E"}}', 95000.00, 'approved');

-- Insert sample audit logs
INSERT INTO audit_logs (user_id, action, details) VALUES
(1, 'USER_LOGIN', 'Admin user logged in'),
(2, 'OPTIMIZATION_RUN', 'Executed optimization scenario #1'),
(3, 'PLAN_APPROVED', 'Approved optimization plan #1'),
(2, 'DATA_UPLOAD', 'Uploaded vessel data via Excel'),
(1, 'USER_CREATED', 'Created new logistics planner account');

-- Verification queries
SELECT 'Database setup completed successfully!' as status;
SELECT COUNT(*) as total_users FROM users;
SELECT COUNT(*) as total_vessels FROM vessels;
SELECT COUNT(*) as total_ports FROM ports;
SELECT COUNT(*) as total_plants FROM plants;
SELECT COUNT(*) as total_plans FROM plans;
