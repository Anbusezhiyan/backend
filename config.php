<?php
// Database configuration
define('DB_HOST', 'localhost');
define('DB_NAME', 'logistics_db');
define('DB_USER', 'root');
define('DB_PASS', '');

// JWT Secret
define('JWT_SECRET', 'your_secret_key_here');

// API Base URL
define('API_BASE', 'http://localhost/logistics/api');

// Python Service URL
define('PYTHON_URL', 'http://localhost:8000');

// Function to get DB connection
function getDB() {
    try {
        $pdo = new PDO('mysql:host=' . DB_HOST . ';dbname=' . DB_NAME, DB_USER, DB_PASS);
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        return $pdo;
    } catch (PDOException $e) {
        die('Database connection failed: ' . $e->getMessage());
    }
}
?>
