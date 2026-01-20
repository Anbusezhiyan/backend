# AI-Enabled Logistics Optimizer - API Documentation

## Overview

This API documentation provides comprehensive details about the AI-Enabled Logistics Optimizer system, including user roles, features, flows, and complete API specifications.

## User Roles & Features

### 1. Admin
**Role Permissions**: Full system access

**Key Features**:
- User management (create, update, delete users)
- System configuration and settings
- Audit log access and monitoring
- Approve/reject optimization plans
- View all plans and reports
- Access to all APIs and data
- System maintenance and backup

**Typical Workflow**:
1. Login to system
2. Review user management
3. Monitor system audit logs
4. Approve pending optimization plans
5. Review system performance reports

### 2. Logistics Planner
**Role Permissions**: Planning and execution access

**Key Features**:
- Vessel, port, and plant data management
- Excel data upload (vessels, stocks, costs)
- Run optimization scenarios
- View and manage optimization plans
- What-if analysis and scenario planning
- Access to historical plans and reports
- SAP data sync initiation

**Typical Workflow**:
1. Login to system
2. Upload vessel and stock data via Excel
3. Review and update port/plant configurations
4. Run AI delay predictions
5. Execute optimization runs
6. Review and submit plans for approval

### 3. Operations Manager
**Role Permissions**: Read-only with approval rights

**Key Features**:
- View optimization plans and schedules
- Approve operational changes
- Access to reports and analytics
- Monitor plan execution status
- View cost breakdowns and KPIs
- Access to approved plans only

**Typical Workflow**:
1. Login to system
2. Review pending optimization plans
3. Analyze cost savings and schedule impacts
4. Approve or request modifications
5. Monitor approved plan execution

## End-to-End User Flows

### Complete Business Flow

```
User Login → Data Upload → AI Prediction → Optimization → Review → Approval → Execution
```

#### Detailed Flow Steps:

1. **Authentication**
   - User logs in with credentials
   - JWT token generated and validated
   - Role-based access established

2. **Data Preparation**
   - Logistics Planner uploads vessel data (Excel/CSV)
   - Uploads stock and capacity data
   - Updates port and plant configurations
   - Reviews rail cost matrices

3. **AI Processing**
   - System calls Python service for delay prediction
   - AI analyzes historical data and current conditions
   - Predicted delays stored in database

4. **Optimization Execution**
   - PHP fetches all relevant data
   - Calls Python optimization service
   - Pyomo solver finds optimal solution
   - Results stored as optimization plan

5. **Review & Approval**
   - Operations Manager reviews plan details
   - Analyzes cost breakdowns and constraints
   - Approves or requests modifications
   - Admin provides final approval

6. **Execution & Monitoring**
   - Approved plans become operational
   - SAP sync initiated (simulated)
   - Plan execution tracked
   - Reports generated for analysis

## API Reference

### Authentication APIs

#### POST /api/auth/register
**Description**: Register new user account

**Access**: Public (no auth required)

**Request Body**:
```json
{
  "username": "string (3-50 chars)",
  "email": "string (valid email)",
  "password": "string (min 6 chars)",
  "role": "admin|logistics_planner|operations_manager"
}
```

**Success Response (200)**:
```json
{
  "success": true,
  "message": "User registered successfully",
  "user_id": 123
}
```

**Error Responses**:
- 400: Invalid input data
- 409: Username or email already exists
- 500: Server error

#### POST /api/auth/login
**Description**: Authenticate user and generate JWT token

**Access**: All users

**Request Body**:
```json
{
  "username": "string",
  "password": "string"
}
```

**Success Response (200)**:
```json
{
  "success": true,
  "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
  "role": "admin|logistics_planner|operations_manager",
  "expires_in": 3600
}
```

**Error Responses**:
- 400: Invalid request format
- 401: Invalid credentials
- 500: Server error

#### GET /api/auth/profile
**Description**: Get current user profile information

**Access**: All authenticated users

**Headers**: Authorization: Bearer {token}

**Success Response (200)**:
```json
{
  "id": 1,
  "username": "john_doe",
  "email": "john@example.com",
  "role": "logistics_planner",
  "created_at": "2023-01-01 00:00:00"
}
```

**Error Responses**:
- 401: Unauthorized
- 404: User not found

#### POST /api/auth/forgot-password
**Description**: Request password reset link

**Access**: Public

**Request Body**:
```json
{
  "email": "user@example.com"
}
```

**Success Response (200)**:
```json
{
  "success": true,
  "message": "If the email exists, a reset link has been sent",
  "reset_token": "token_here"  // Demo only - remove in production
}
```

**Error Responses**:
- 400: Invalid email format

#### POST /api/auth/reset-password
**Description**: Reset password using reset token

**Access**: Public

**Request Body**:
```json
{
  "token": "reset_token_from_email",
  "new_password": "new_secure_password"
}
```

**Success Response (200)**:
```json
{
  "success": true,
  "message": "Password reset successfully"
}
```

**Error Responses**:
- 400: Invalid token or password too short
- 500: Reset failed

### User Management APIs

#### GET /api/users/index.php
**Description**: List all users in the system

**Access**: Admin only

**Success Response (200)**:
```json
[
  {
    "id": 1,
    "username": "admin",
    "email": "admin@example.com",
    "role": "admin",
    "created_at": "2023-01-01 00:00:00"
  },
  {
    "id": 2,
    "username": "planner",
    "email": "planner@example.com",
    "role": "logistics_planner",
    "created_at": "2023-01-02 00:00:00"
  }
]
```

#### POST /api/users/index.php
**Description**: Create new user account

**Access**: Admin only

**Request Body**:
```json
{
  "username": "new_user",
  "email": "new@example.com",
  "password": "securePass123",
  "role": "logistics_planner"
}
```

**Success Response (200)**:
```json
{
  "success": true,
  "message": "User created successfully",
  "user_id": 3
}
```

#### GET /api/users/user.php/{id}
**Description**: Get details of specific user

**Access**: Admin only

**Success Response (200)**:
```json
{
  "id": 2,
  "username": "planner",
  "email": "planner@example.com",
  "role": "logistics_planner",
  "created_at": "2023-01-02 00:00:00"
}
```

#### PUT /api/users/user.php/{id}
**Description**: Update user details

**Access**: Admin only

**Request Body** (partial update supported):
```json
{
  "email": "newemail@example.com",
  "role": "operations_manager"
}
```

**Success Response (200)**:
```json
{
  "success": true,
  "message": "User updated successfully"
}
```

#### DELETE /api/users/user.php/{id}
**Description**: Delete user account

**Access**: Admin only

**Success Response (200)**:
```json
{
  "success": true,
  "message": "User deleted successfully"
}
```

### Vessel Management APIs

#### GET /api/vessels/index.php
**Description**: Retrieve all vessels

**Access**: Admin, Logistics Planner

**Headers**: Authorization: Bearer {token}

**Success Response (200)**:
```json
[
  {
    "id": 1,
    "name": "Vessel A",
    "capacity": 50000,
    "eta": "2023-10-01",
    "predicted_delay": 2.5
  }
]
```

#### POST /api/vessels/index.php
**Description**: Create new vessel

**Access**: Admin, Logistics Planner

**Headers**: Authorization: Bearer {token}

**Request Body**:
```json
{
  "name": "Vessel B",
  "capacity": 60000,
  "eta": "2023-10-05"
}
```

**Success Response (200)**:
```json
{
  "success": true,
  "id": 2
}
```

#### GET /api/vessels/vessel.php/{id}
**Description**: Get specific vessel details

**Access**: Admin, Logistics Planner

**Success Response (200)**:
```json
{
  "id": 1,
  "name": "Vessel A",
  "capacity": 50000,
  "eta": "2023-10-01",
  "predicted_delay": 2.5
}
```

#### PUT /api/vessels/vessel.php/{id}
**Description**: Update vessel information

**Access**: Admin, Logistics Planner

**Request Body** (partial update supported):
```json
{
  "capacity": 55000,
  "eta": "2023-10-02"
}
```

**Success Response (200)**:
```json
{
  "success": true,
  "message": "Vessel updated successfully"
}
```

#### DELETE /api/vessels/vessel.php/{id}
**Description**: Delete vessel

**Access**: Admin, Logistics Planner

**Success Response (200)**:
```json
{
  "success": true,
  "message": "Vessel deleted successfully"
}
```

### Port Management APIs

#### GET /api/ports/index.php
**Description**: Retrieve all ports

**Access**: Admin, Logistics Planner

**Success Response (200)**:
```json
[
  {
    "id": 1,
    "name": "Paradip",
    "capacity": 50000,
    "location": "Odisha"
  }
]
```

#### POST /api/ports/index.php
**Description**: Create new port

**Access**: Admin, Logistics Planner

**Request Body**:
```json
{
  "name": "Haldia",
  "capacity": 40000,
  "location": "West Bengal"
}
```

#### GET /api/ports/port.php/{id}
**Description**: Get specific port details

**Access**: Admin, Logistics Planner

**Success Response (200)**:
```json
{
  "id": 1,
  "name": "Paradip",
  "capacity": 50000,
  "location": "Odisha"
}
```

#### PUT /api/ports/port.php/{id}
**Description**: Update port information

**Access**: Admin, Logistics Planner

**Request Body** (partial update supported):
```json
{
  "capacity": 55000,
  "location": "Odisha, India"
}
```

**Success Response (200)**:
```json
{
  "success": true,
  "message": "Port updated successfully"
}
```

#### DELETE /api/ports/port.php/{id}
**Description**: Delete port

**Access**: Admin, Logistics Planner

**Success Response (200)**:
```json
{
  "success": true,
  "message": "Port deleted successfully"
}
```

### Plant Management APIs

#### GET /api/plants/index.php
**Description**: Retrieve all plants

**Access**: Admin, Logistics Planner

**Success Response (200)**:
```json
[
  {
    "id": 1,
    "name": "Plant A",
    "demand": 30000,
    "location": "Rourkela"
  }
]
```

#### POST /api/plants/index.php
**Description**: Create new plant

**Access**: Admin, Logistics Planner

**Request Body**:
```json
{
  "name": "Plant B",
  "demand": 25000,
  "location": "Bokaro"
}
```

#### GET /api/plants/plant.php/{id}
**Description**: Get specific plant details

**Access**: Admin, Logistics Planner

**Success Response (200)**:
```json
{
  "id": 1,
  "name": "Plant A",
  "demand": 30000,
  "location": "Rourkela"
}
```

#### PUT /api/plants/plant.php/{id}
**Description**: Update plant information

**Access**: Admin, Logistics Planner

**Request Body** (partial update supported):
```json
{
  "demand": 32000,
  "location": "Rourkela, Odisha"
}
```

**Success Response (200)**:
```json
{
  "success": true,
  "message": "Plant updated successfully"
}
```

#### DELETE /api/plants/plant.php/{id}
**Description**: Delete plant

**Access**: Admin, Logistics Planner

**Success Response (200)**:
```json
{
  "success": true,
  "message": "Plant deleted successfully"
}
```

### SAP Integration APIs

#### POST /api/sync/sap
**Description**: Synchronize data with SAP system

**Access**: Admin, Logistics Planner

**Request Body**:
```json
{
  "sync_type": "stock|orders|all"
}
```

**Success Response (200)**:
```json
{
  "success": true,
  "message": "SAP data sync completed successfully",
  "sync_type": "stock",
  "synced_records": 25
}
```

### Data Upload APIs

#### POST /api/upload/excel
**Description**: Upload Excel/CSV data for vessels or stocks

**Access**: Admin, Logistics Planner

**Content-Type**: multipart/form-data

**Form Data**:
- file: Excel/CSV file
- type: "vessels" or "stocks"

**Success Response (200)**:
```json
{
  "success": true,
  "message": "Data uploaded successfully",
  "records_processed": 100
}
```

### Optimization APIs

#### POST /api/optimization/run.php
**Description**: Execute optimization run

**Access**: Admin, Logistics Planner

**Success Response (200)**:
```json
{
  "success": true,
  "plan_id": 1,
  "message": "Optimization completed"
}
```

#### GET /api/plans/index.php
**Description**: Retrieve all optimization plans

**Access**: All users (role-based visibility)

**Success Response (200)**:
```json
[
  {
    "id": 1,
    "user_id": 2,
    "schedule_json": "{\"vessel_1\": {\"port\": \"Paradip\", \"plant\": \"Plant A\"}}",
    "total_cost": 150000.00,
    "status": "pending",
    "created_at": "2023-10-01 10:00:00",
    "created_by": "planner"
  }
]
```

#### GET /api/plans/index.php/{id}
**Description**: Retrieve specific optimization plan details

**Access**: All users (role-based visibility)

**URL Parameter**: {id} - Plan ID (numeric)

**Success Response (200)**:
```json
{
  "id": 1,
  "user_id": 2,
  "schedule_json": "{\"vessel_1\": {\"port\": \"Paradip\", \"plant\": \"Plant A\"}}",
  "total_cost": 150000.00,
  "status": "pending",
  "created_at": "2023-10-01 10:00:00",
  "created_by": "planner"
}
```

#### PUT /api/plans/{id}/approve
**Description**: Approve optimization plan

**Access**: Admin, Operations Manager

**Success Response (200)**:
```json
{
  "success": true,
  "message": "Plan approved successfully"
}
```

### Analytics & Reporting APIs

#### GET /api/reports/cost-analysis
**Description**: Get cost breakdown analysis for plans

**Access**: All users (role-based visibility)

**Query Parameters**:
- plan_id: integer (optional - if provided, returns analysis for specific plan)
- period: "monthly"|"quarterly"|"yearly" (default: "monthly")

**Success Response - Specific Plan (200)**:
```json
{
  "plan_id": 1,
  "plan_status": "approved",
  "created_by": "planner",
  "period": "monthly",
  "ocean_freight": 60000.00,
  "port_handling": 37500.00,
  "rail_freight": 30000.00,
  "demurrage": 22500.00,
  "total_cost": 150000.00
}
```

**Success Response - All Plans (200)**:
```json
{
  "period": "monthly",
  "total_plans": 3,
  "total_overall_cost": 420000.00,
  "plans": [
    {
      "plan_id": 1,
      "plan_status": "approved",
      "created_by": "planner",
      "created_at": "2023-10-01 10:00:00",
      "period": "monthly",
      "ocean_freight": 60000.00,
      "port_handling": 37500.00,
      "rail_freight": 30000.00,
      "demurrage": 22500.00,
      "total_cost": 150000.00
    }
  ]
}
```

#### GET /api/reports/kpi
**Description**: Get key performance indicators

**Access**: All users

**Success Response (200)**:
```json
{
  "cost_savings": 15.5,
  "on_time_delivery": 92.3,
  "utilization_rate": 87.1,
  "demurrage_reduction": 23.7
}
```

## Role-Based Access Matrix

| API Endpoint | Admin | Logistics Planner | Operations Manager |
|-------------|-------|-------------------|-------------------|
| /api/auth/* | ✅ | ✅ | ✅ |
| /api/users/* | ✅ | ❌ | ❌ |
| /api/vessels/* | ✅ | ✅ | ❌ |
| /api/ports/* | ✅ | ✅ | ❌ |
| /api/plants/* | ✅ | ✅ | ❌ |
| /api/upload/* | ✅ | ✅ | ❌ |
| /api/optimization/run | ✅ | ✅ | ❌ |
| /api/plans (GET) | ✅ | ✅ | ✅ |
| /api/plans/*/approve | ✅ | ❌ | ✅ |
| /api/reports/* | ✅ | ✅ | ✅ |

## Error Handling

All APIs return consistent error responses:

```json
{
  "error": "Error description",
  "code": "ERROR_CODE"
}
```

**Common Error Codes**:
- INVALID_CREDENTIALS: Authentication failed
- FORBIDDEN: Insufficient permissions
- VALIDATION_ERROR: Invalid input data
- NOT_FOUND: Resource not found
- SERVER_ERROR: Internal server error

## Rate Limiting

- Authentication APIs: 10 requests/minute
- Data APIs: 100 requests/minute
- Optimization APIs: 5 requests/hour

## API Versioning

All endpoints support versioning via URL path:
- Current: /api/v1/
- Future versions: /api/v2/

## Testing with Postman

1. Import `postman_collection.json`
2. Set environment variables:
   - base_url: http://localhost/logistics/api
   - token: (auto-populated after login)
3. Execute requests in order: Login → Data Upload → Optimization

## Sample Data Files

- `sample_vessel_data.csv`: Vessel information for upload testing
- `sample_stock_data.csv`: Plant stock data for upload testing

Convert CSV files to Excel format for upload API testing.
