-- Logistics Database Schema

CREATE DATABASE IF NOT EXISTS logistics_db;
USE logistics_db;

-- Users table
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

-- Indexes
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_vessels_eta ON vessels(eta);
CREATE INDEX idx_plans_status ON plans(status);
CREATE INDEX idx_plans_created_at ON plans(created_at);

-- Sample data
INSERT INTO users (username, email, password_hash, role) VALUES
('admin', 'admin@example.com', '$2y$10$hashedpassword', 'admin'),
('planner', 'planner@example.com', '$2y$10$hashedpassword', 'logistics_planner'),
('manager', 'manager@example.com', '$2y$10$hashedpassword', 'operations_manager');

INSERT INTO ports (name, capacity, location) VALUES
('Paradip', 50000, 'Odisha'),
('Haldia', 40000, 'West Bengal');

INSERT INTO plants (name, demand, location) VALUES
('Plant A', 30000, 'Rourkela'),
('Plant B', 25000, 'Bokaro');
