# AI-Enabled Logistics Optimizer for Cost-Optimal Vessel Scheduling and Port–Plant Linkage in a Steel Supply Chain

## Overview

This system is designed as an AI-Enabled Logistics Optimizer using PHP as the primary backend, MySQL for data persistence, and Python for AI and optimization services. Communication between PHP and Python is via REST APIs using JSON over HTTP.

## 1. User Roles & User Flow

### User Roles

- **Admin**: Full system access, including user management, system configuration, audit logs, and approval of optimization plans.
- **Logistics Planner**: Access to vessel scheduling, data upload, running optimizations, and viewing plans.
- **Operations Manager**: Read-only access to plans, reports, and approval workflows for operational changes.

### End-to-End User Flow

1. **Login**: User authenticates via JWT-based login.
2. **Data Input**: Logistics Planner uploads vessel and stock data via Excel or manual entry.
3. **AI Prediction**: System calls Python service to predict delays.
4. **Optimization Run**: Python optimization engine calculates cost-optimal schedules.
5. **Review & Approval**: Operations Manager reviews plans; Admin approves.
6. **Execution**: Approved plans are stored and can trigger SAP sync (simulated).

### API Call Sequence

- **Authentication Phase**: PHP handles login (User Login API).
- **Data Phase**: PHP Domain APIs for Vessel, Port, Plant, etc.stocks
- **AI Phase**: PHP calls Python /predict-delay.
- **Optimization Phase**: PHP calls Python /run-optimization.
- **Storage Phase**: PHP stores results in MySQL.

### Mapping of User Actions to APIs

- **Login**: POST /api/auth/login
- **Upload Vessel Data**: POST /api/vessels/upload
- **Predict Delays**: POST /api/ai/predict-delay (internal call)
- **Run Optimization**: POST /api/optimization/run
- **Fetch Plan**: GET /api/plans/{id}
- **Approve Plan**: PUT /api/plans/{id}/approve

## 2. Common Backend Features (PHP)

All APIs use JWT for authentication. Passwords are hashed using bcrypt. RBAC is enforced via middleware.

### User Registration API

- **Endpoint**: /api/auth/register
- **Method**: POST
- **Request JSON**:
```json
{
  "username": "john_doe",
  "email": "john@example.com",
  "password": "securePass123",
  "role": "logistics_planner"
}
```
- **Response JSON** (Success):
```json
{
  "success": true,
  "message": "User registered successfully",
  "user_id": 123
}
```
- **Error Responses**:
  - 400: {"error": "Invalid email format"}
  - 409: {"error": "Username already exists"}
  - 500: {"error": "Internal server error"}

### User Login API

- **Endpoint**: /api/auth/login
- **Method**: POST
- **Request JSON**:
```json
{
  "username": "john_doe",
  "password": "securePass123"
}
```
- **Response JSON** (Success):
```json
{
  "success": true,
  "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
  "role": "logistics_planner",
  "expires_in": 3600
}
```
- **Error Responses**:
  - 401: {"error": "Invalid credentials"}
  - 500: {"error": "Internal server error"}

### Forgot Password API

- **Endpoint**: /api/auth/forgot-password
- **Method**: POST
- **Request JSON**:
```json
{
  "email": "john@example.com"
}
```
- **Response JSON** (Success):
```json
{
  "success": true,
  "message": "Reset link sent to email"
}
```
- **Error Responses**:
  - 400: {"error": "Email not found"}
  - 500: {"error": "Internal server error"}

### Reset Password API

- **Endpoint**: /api/auth/reset-password
- **Method**: POST
- **Request JSON**:
```json
{
  "token": "reset_token_here",
  "new_password": "newSecurePass123"
}
```
- **Response JSON** (Success):
```json
{
  "success": true,
  "message": "Password reset successfully"
}
```
- **Error Responses**:
  - 400: {"error": "Invalid or expired token"}
  - 500: {"error": "Internal server error"}

### JWT Token Validation

Middleware checks token on protected routes. Decodes JWT to get user ID and role for RBAC.

### Role-Based Access Control (RBAC)

- Admin: All permissions
- Logistics Planner: Read/Write on vessels, ports, plants, plans
- Operations Manager: Read on plans, Approve actions

## 3. Domain APIs (PHP)

All domain APIs include validation (e.g., required fields, data types). MySQL interactions use prepared statements.

### Vessel Management API

- **Endpoint**: /api/vessels
- **Method**: GET
- **Response JSON**:
```json
[
  {
    "id": 1,
    "name": "Vessel A",
    "capacity": 50000,
    "eta": "2023-10-01"
  }
]
```

- **Create Vessel**: POST /api/vessels
- **Request JSON**:
```json
{
  "name": "Vessel B",
  "capacity": 60000,
  "eta": "2023-10-05"
}
```

- **Update/Delete**: PUT/DELETE /api/vessels/{id}

Validation: Capacity > 0, ETA in future.

MySQL: INSERT INTO vessels (name, capacity, eta) VALUES (?, ?, ?)

### Port Management API

Similar structure: GET/POST/PUT/DELETE for ports (id, name, capacity, location)

### Plant Management API

GET/POST/PUT/DELETE for plants (id, name, demand, location)

### Rail Cost Management API

GET/POST/PUT/DELETE for rail costs (from_port, to_plant, cost_per_ton)

### Stock & Capacity Management API

GET/POST/PUT/DELETE for stocks (plant_id, product, quantity, aging_days)

### Excel Upload API

- **Endpoint**: /api/upload/excel
- **Method**: POST
- **Request**: Multipart form with Excel file
- **Response**: {"success": true, "message": "Data uploaded", "records": 100}

Parses Excel, validates, inserts into MySQL.

### SAP Data Sync API (Simulated)

- **Endpoint**: /api/sync/sap
- **Method**: POST
- **Request JSON**: {"sync_type": "stock"}
- **Response**: {"success": true, "synced_records": 50}

Simulates API call to SAP, updates local DB.

## 4. PHP → Python Integration

PHP uses cURL for HTTP calls to Python service (e.g., http://localhost:8000).

### Request/Response Flow

1. PHP prepares JSON payload.
2. cURL POST to Python endpoint.
3. Handle response JSON or errors.

### Timeout & Error Handling

- Timeout: 30 seconds.
- Retries: Up to 3 times on failure.

### Retry Strategy

Exponential backoff: 1s, 2s, 4s.

### Example: PHP Calling AI Delay Prediction

```php
$url = 'http://localhost:8000/predict-delay';
$data = json_encode(['vessel_id' => 1, 'current_delay' => 2]);
$ch = curl_init($url);
curl_setopt($ch, CURLOPT_POST, true);
curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type: application/json']);
curl_setopt($ch, CURLOPT_TIMEOUT, 30);
$response = curl_exec($ch);
if (curl_error($ch)) {
    // Retry logic
}
$result = json_decode($response, true);
// Persist to MySQL: UPDATE vessels SET predicted_delay = ? WHERE id = ?
```

### Example: PHP Calling Optimization API

Similar, POST to /run-optimization, store results in plans table.

## 5. Python AI Services

Using FastAPI, running on port 8000.

### /predict-delay

- **Method**: POST
- **Input JSON**:
```json
{
  "vessel_id": 1,
  "features": [2.0, 1000.0, 5.0]  // delay_days, distance, weather_factor
}
```
- **Output JSON**:
```json
{
  "predicted_delay": 3.98
}
```
- **Logic**: Dummy XGBoost model (replaceable). Returns random prediction between 1-5 days.

### /run-optimization

- **Method**: POST
- **Input JSON**:
```json
{
  "vessels": [...],
  "ports": [...],
  "plants": [...],
  "costs": {...}
}
```
- **Output JSON**:
```json
{
  "optimal_schedule": [
    {
      "vessel_id": 1,
      "vessel_name": "MV Ocean Pride",
      "port_id": 1,
      "port_name": "Paradip",
      "plant_id": 1,
      "plant_name": "Plant A"
    }
  ],
  "total_cost": 150000,
  "status": "success",
  "message": "Optimization completed successfully"
}
```
- **Logic**: Simplified optimization algorithm (Pyomo commented out to avoid Pydantic conflicts). Assigns vessels to ports/plants with cost calculation.

## 6. Optimization Engine Details

### Objective Function

Minimize: Ocean Freight + Port Handling + Rail Freight + Demurrage

### Cost Components

- Ocean Freight: Distance * rate_per_ton
- Port Handling: Handling fee + Storage cost * days
- Rail Freight: Distance * rail_rate
- Demurrage: Delay days * demurrage_rate (influenced by AI prediction)

### Constraints

- Port capacity <= max_capacity
- Plant demand <= stock + incoming
- Rail rake availability
- Max port calls per vessel: 2 (Haldia second)
- Sequential discharge: Haldia after first port
- Vessel ETA + stock aging <= max_aging

### AI Impact

Predicted delay reduces uncertainty in demurrage calculation, lowering costs.

## 7. Postman Collection

Import the `postman_collection.json` file into Postman. It includes:

- **Login**: Authenticate and get JWT token
- **Get Vessels**: Retrieve vessel list with sample output
- **Create Vessel**: Add new vessel with sample request/response
- **Run Optimization**: Execute optimization and store plan

Sample outputs are included in each request. Use the CSV files as sample data for Excel upload testing.

### Sample Excel Files

- `sample_vessel_data.csv`: Vessel information (Name, Capacity, ETA, Delay, Distance, Weather Factor)
- `sample_stock_data.csv`: Plant stock and demand data

Open these CSV files in Excel for testing the upload functionality. Convert to .xlsx if needed.

## 8. Database Setup

### Quick Setup

Run the complete database setup script:

```bash
mysql -u root -p < setup_database.sql
```

This will create the database, tables, indexes, and insert comprehensive sample data.

### Database Schema

#### Tables

- **users**: id (PK), username (UNIQUE), email, password_hash, role, reset_token, reset_token_expires, created_at
- **vessels**: id (PK), name, capacity, eta, predicted_delay
- **ports**: id (PK), name, capacity, location
- **plants**: id (PK), name, demand, location
- **rail_costs**: id (PK), from_port_id (FK), to_plant_id (FK), cost_per_ton
- **stocks**: id (PK), plant_id (FK), product, quantity, aging_days
- **plans**: id (PK), user_id (FK), schedule_json, total_cost, status, created_at
- **audit_logs**: id (PK), user_id (FK), action, details, timestamp

#### Relationships

- rail_costs.from_port_id → ports.id
- rail_costs.to_plant_id → plants.id
- stocks.plant_id → plants.id
- plans.user_id → users.id
- audit_logs.user_id → users.id

#### Sample Data Included

- **3 Users**: admin, logistics_planner, operations_manager (passwords: admin123, planner123, manager123)
- **4 Ports**: Paradip, Haldia, Visakhapatnam, Chennai
- **5 Plants**: Rourkela, Bokaro, Jamshedpur, Durgapur, Burnpur
- **5 Vessels**: With realistic capacities and ETAs
- **Rail Costs**: Complete matrix from all ports to all plants
- **Stock Data**: Current inventory at each plant
- **Sample Plans**: Approved and pending optimization scenarios
- **Audit Logs**: System activity tracking

### Manual Database Creation

If you prefer to create the database manually:

```sql
-- Run the commands from database_schema.sql first
-- Then run the INSERT statements from setup_database.sql
```

### Database Configuration

Update `config.php` with your database credentials:

```php
define('DB_HOST', 'localhost');
define('DB_NAME', 'logistics_db');
define('DB_USER', 'root');
define('DB_PASS', 'your_password');
```

## 9. Expected Solution Mapping

- **System-Driven**: APIs automate data flow, no manual Excel.
- **PHP + Python Separation**: PHP handles business logic/DB, Python isolates AI/optimization for scalability.
- **AI Reduces Costs**: Accurate delay prediction minimizes demurrage.
- **Optimization Minimizes Total Cost**: Mathematical model finds optimal schedules.
- **What-if Analysis**: Allows scenario testing for decision support.

## 10. Enterprise-Grade Features

- **Secure Password Hashing**: bcrypt with salt.
- **Input Validation**: Sanitize all inputs, use regex for formats.
- **Audit Logging**: Log all API calls to audit table.
- **Error Handling**: Try-catch, return structured errors.
- **API Versioning**: /api/v1/ prefix.
- **Scalability**: Stateless APIs, horizontal scaling.
- **Future AI Replacement**: Modular Python service allows easy model swaps.
