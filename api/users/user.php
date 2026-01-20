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

// Get user ID from URL
$url_parts = explode('/', $_SERVER['REQUEST_URI']);
$user_id = end($url_parts);

if (!is_numeric($user_id)) {
    http_response_code(400);
    echo json_encode(['error' => 'Invalid user ID']);
    exit;
}

$db = getDB();
$method = $_SERVER['REQUEST_METHOD'];

switch ($method) {
    case 'GET':
        // Get specific user
        $stmt = $db->prepare('SELECT id, username, email, role, created_at FROM users WHERE id = ?');
        $stmt->execute([$user_id]);
        $user_data = $stmt->fetch(PDO::FETCH_ASSOC);

        if (!$user_data) {
            http_response_code(404);
            echo json_encode(['error' => 'User not found']);
            exit;
        }

        echo json_encode($user_data);
        break;

    case 'PUT':
        // Update user
        $data = json_decode(file_get_contents('php://input'), true);
        if (!$data) {
            http_response_code(400);
            echo json_encode(['error' => 'Invalid input']);
            exit;
        }

        // Check if user exists
        $stmt = $db->prepare('SELECT id FROM users WHERE id = ?');
        $stmt->execute([$user_id]);
        if (!$stmt->fetch()) {
            http_response_code(404);
            echo json_encode(['error' => 'User not found']);
            exit;
        }

        // Build update query dynamically
        $update_fields = [];
        $params = [];

        if (isset($data['username'])) {
            // Check if username is taken by another user
            $stmt = $db->prepare('SELECT id FROM users WHERE username = ? AND id != ?');
            $stmt->execute([$data['username'], $user_id]);
            if ($stmt->fetch()) {
                http_response_code(409);
                echo json_encode(['error' => 'Username already exists']);
                exit;
            }
            $update_fields[] = 'username = ?';
            $params[] = $data['username'];
        }

        if (isset($data['email'])) {
            // Check if email is taken by another user
            $stmt = $db->prepare('SELECT id FROM users WHERE email = ? AND id != ?');
            $stmt->execute([$data['email'], $user_id]);
            if ($stmt->fetch()) {
                http_response_code(409);
                echo json_encode(['error' => 'Email already exists']);
                exit;
            }
            $update_fields[] = 'email = ?';
            $params[] = $data['email'];
        }

        if (isset($data['role'])) {
            $valid_roles = ['admin', 'logistics_planner', 'operations_manager'];
            if (!in_array($data['role'], $valid_roles)) {
                http_response_code(400);
                echo json_encode(['error' => 'Invalid role']);
                exit;
            }
            $update_fields[] = 'role = ?';
            $params[] = $data['role'];
        }

        if (isset($data['password'])) {
            $hashed_password = password_hash($data['password'], PASSWORD_DEFAULT);
            $update_fields[] = 'password_hash = ?';
            $params[] = $hashed_password;
        }

        if (empty($update_fields)) {
            http_response_code(400);
            echo json_encode(['error' => 'No valid fields to update']);
            exit;
        }

        $params[] = $user_id;
        $query = 'UPDATE users SET ' . implode(', ', $update_fields) . ' WHERE id = ?';
        $stmt = $db->prepare($query);
        $stmt->execute($params);

        echo json_encode(['success' => true, 'message' => 'User updated successfully']);
        break;

    case 'DELETE':
        // Delete user (soft delete by setting inactive flag, or hard delete)
        // For safety, let's use soft delete - add an 'active' column to schema
        $stmt = $db->prepare('DELETE FROM users WHERE id = ?');
        $stmt->execute([$user_id]);

        if ($stmt->rowCount() === 0) {
            http_response_code(404);
            echo json_encode(['error' => 'User not found']);
            exit;
        }

        echo json_encode(['success' => true, 'message' => 'User deleted successfully']);
        break;

    default:
        http_response_code(405);
        echo json_encode(['error' => 'Method not allowed']);
}
?>
