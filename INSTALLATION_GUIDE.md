# AI-Enabled Logistics Optimizer - Installation Guide

## 🚀 Quick Start Setup

Follow these steps to get the AI-Enabled Logistics Optimizer running on your system.

### Prerequisites

- **XAMPP** (PHP 8.0+, Apache, MySQL)
- **Python 3.8+** with pip
- **Git** (optional, for cloning)

### Step 1: Database Setup

1. Start XAMPP and ensure MySQL is running
2. Open phpMyAdmin or MySQL command line
3. Run the database setup script:

```bashstocks
# Navigate to your project directory
cd c:/xampp/htdocs/logistics

# Run the complete setup script
mysql -u root -p < setup_database.sql
```

**Expected Output:**
```
Database setup completed successfully!
total_users: 3
total_vessels: 5
total_ports: 4
total_plants: 5
total_plans: 3
```

### Step 2: PHP Backend Configuration

1. Update `config.php` if needed:

```php
define('DB_HOST', 'localhost');
define('DB_NAME', 'logistics_db');
define('DB_USER', 'root');
define('DB_PASS', '');  // Your MySQL password
```

2. Ensure Apache is running in XAMPP
3. Test PHP backend: `http://localhost/logistics/api/auth/login`

### Step 3: Python AI Service Setup

1. Navigate to Python service directory:

```bash
cd python
```

2. Install dependencies:

```bash
pip install -r requirements.txt
```

3. Start the Python service:

```bash
python app.py
```

**Expected Output:**
```
INFO:     Started server process [12345]
INFO:     Waiting for application startup.
INFO:     Application startup complete.
INFO:     Uvicorn running on http://0.0.0.0:8000
```

### Step 4: Testing the System

1. **Import Postman Collection:**
   - Open Postman
   - Import `postman_collection.json`
   - Set base_url variable to `http://localhost/logistics/api`

2. **Test Login:**
   - Use "Login" request
   - Username: `admin`
   - Password: `admin123`

3. **Test APIs:**
   - Try "Get Vessels" after login
   - Try "Run Optimization"
   - Check other endpoints

## 📊 Default Test Accounts

| Username | Password | Role |
|----------|----------|------|
| admin | admin123 | Administrator |
| planner | planner123 | Logistics Planner |
| manager | manager123 | Operations Manager |

## 🔧 Troubleshooting

### Database Connection Issues

```php
// Check config.php settings
define('DB_HOST', 'localhost');
define('DB_NAME', 'logistics_db');
define('DB_USER', 'root');
define('DB_PASS', 'your_mysql_password');
```

### Python Service Issues

```bash
# Check Python version
python --version  # Should be 3.8+

# Install missing dependencies
pip install fastapi uvicorn pydantic pyomo

# Check if port 8000 is available
netstat -ano | findstr :8000
```

### API Testing Issues

1. **403 Forbidden**: Check JWT token in Authorization header
2. **404 Not Found**: Verify endpoint URL
3. **500 Server Error**: Check PHP error logs in XAMPP

### Common Issues

- **MySQL Connection Failed**: Ensure MySQL is running in XAMPP
- **Python Service Won't Start**: Check if port 8000 is in use
- **CORS Errors**: Configure Apache for cross-origin requests

## 📁 Project Structure

```
logistics/
├── api/                    # PHP API endpoints
│   ├── auth/              # Authentication APIs
│   ├── users/             # User management
│   ├── vessels/           # Vessel CRUD
│   ├── ports/             # Port CRUD
│   ├── plants/            # Plant CRUD
│   ├── plans/             # Plan management
│   ├── reports/           # Analytics & reporting
│   ├── upload/            # File upload
│   └── sync/              # SAP integration
├── python/                # AI & Optimization service
│   ├── app.py            # FastAPI application
│   └── requirements.txt  # Python dependencies
├── config.php            # Database configuration
├── setup_database.sql    # Complete DB setup
├── database_schema.sql   # Schema only
├── postman_collection.json  # API testing collection
├── sample_vessel_data.csv   # Test data
├── sample_stock_data.csv    # Test data
├── API_DOCUMENTATION.md     # Complete API docs
├── README.md               # Project overview
└── INSTALLATION_GUIDE.md   # This file
```

## 🎯 System Verification

Run these tests to verify everything works:

### 1. Database Check
```sql
USE logistics_db;
SELECT COUNT(*) as users FROM users;
SELECT COUNT(*) as vessels FROM vessels;
SELECT COUNT(*) as ports FROM ports;
SELECT COUNT(*) as plants FROM plants;
```

### 2. PHP Backend Test
```bash
curl -X GET http://localhost/logistics/api/auth/login
# Should return method not allowed (405)
```

### 3. Python Service Test
```bash
curl -X GET http://localhost:8000/docs
# Should open FastAPI documentation
```

### 4. Full System Test
1. Login via Postman
2. Get JWT token
3. Call vessel list API
4. Run optimization
5. Check plan approval

## 📞 Support

If you encounter issues:

1. Check the troubleshooting section above
2. Verify all prerequisites are installed
3. Ensure services are running (Apache, MySQL, Python)
4. Check logs in XAMPP control panel
5. Test individual components before full integration

## 🚀 Production Deployment

For production deployment:

1. Use proper web server (Apache/Nginx)
2. Configure SSL/TLS certificates
3. Set up database user with limited privileges
4. Configure firewall and security
5. Set up monitoring and logging
6. Implement backup strategies
7. Configure load balancing for scalability

---

**Installation completed! Your AI-Enabled Logistics Optimizer is now ready for testing and development.** 🎉
