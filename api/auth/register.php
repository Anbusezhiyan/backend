<?php
require_once '../../config.php';

header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['error' => 'Method not allowed']);
    exit;
}

$data = json_decode(file_get_contents('php://input'), true);
if (!$data || !isset($data['username']) || !isset($data['email']) || !isset($data['password']) || !isset($data['role'])) {
    http_response_code(400);
    echo json_encode(['error' => 'Missing required fields: username, email, password, role']);
    exit;
}

// Validate input
$username = trim($data['username']);
$email = trim($data['email']);
$password = $data['password'];
$role = $data['role'];

if (strlen($username) < 3 || strlen($username) > 50) {
    http_response_code(400);
    echo json_encode(['error' => 'Username must be 3-50 characters']);
    exit;
}

if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    http_response_code(400);
    echo json_encode(['error' => 'Invalid email format']);
    exit;
}

if (strlen($password) < 6) {
    http_response_code(400);
    echo json_encode(['error' => 'Password must be at least 6 characters']);
    exit;
}

$valid_roles = ['admin', 'logistics_planner', 'operations_manager'];
if (!in_array($role, $valid_roles)) {
    http_response_code(400);
    echo json_encode(['error' => 'Invalid role']);
    exit;
}

$db = getDB();

// Check if username or email already exists
$stmt = $db->prepare('SELECT id FROM users WHERE username = ? OR email = ?');
$stmt->execute([$username, $email]);
if ($stmt->fetch()) {
    http_response_code(409);
    echo json_encode(['error' => 'Username or email already exists']);
    exit;
}

// Hash password
$hashed_password = password_hash($password, PASSWORD_DEFAULT);

// Insert user
$stmt = $db->prepare('INSERT INTO users (username, email, password_hash, role) VALUES (?, ?, ?, ?)');
$result = $stmt->execute([$username, $email, $hashed_password, $role]);

if ($result) {
    echo json_encode([
        'success' => true,
        'message' => 'User registered successfully',
        'user_id' => $db->lastInsertId()
    ]);
} else {
    http_response_code(500);
    echo json_encode(['error' => 'Registration failed']);
}
?>
