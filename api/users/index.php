<?php
require_once '../../config.php';
require_once '../jwt.php';

header('Content-Type: application/json');

$user = getUserFromToken();
if (!$user || $user['role'] !== 'admin') {
    http_response_code(403);
    echo json_encode(['error' => 'Admin access required']);
    exit;
}

$db = getDB();
$method = $_SERVER['REQUEST_METHOD'];

switch ($method) {
    case 'GET':
        // List all users
        $stmt = $db->query('SELECT id, username, email, role, created_at FROM users');
        $users = $stmt->fetchAll(PDO::FETCH_ASSOC);
        echo json_encode($users);
        break;

    case 'POST':
        // Create new user
        $data = json_decode(file_get_contents('php://input'), true);
        if (!$data || !isset($data['username']) || !isset($data['email']) || !isset($data['password']) || !isset($data['role'])) {
            http_response_code(400);
            echo json_encode(['error' => 'Missing required fields']);
            exit;
        }

        // Validate role
        $valid_roles = ['admin', 'logistics_planner', 'operations_manager'];
        if (!in_array($data['role'], $valid_roles)) {
            http_response_code(400);
            echo json_encode(['error' => 'Invalid role']);
            exit;
        }

        // Check if username/email exists
        $stmt = $db->prepare('SELECT id FROM users WHERE username = ? OR email = ?');
        $stmt->execute([$data['username'], $data['email']]);
        if ($stmt->fetch()) {
            http_response_code(409);
            echo json_encode(['error' => 'Username or email already exists']);
            exit;
        }

        // Hash password
        $hashed_password = password_hash($data['password'], PASSWORD_DEFAULT);

        // Insert user
        $stmt = $db->prepare('INSERT INTO users (username, email, password_hash, role) VALUES (?, ?, ?, ?)');
        $stmt->execute([$data['username'], $data['email'], $hashed_password, $data['role']]);

        echo json_encode([
            'success' => true,
            'message' => 'User created successfully',
            'user_id' => $db->lastInsertId()
        ]);
        break;

    default:
        http_response_code(405);
        echo json_encode(['error' => 'Method not allowed']);
}
?>
