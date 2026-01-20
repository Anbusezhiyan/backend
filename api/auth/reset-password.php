<?php
require_once '../../config.php';

header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['error' => 'Method not allowed']);
    exit;
}

$data = json_decode(file_get_contents('php://input'), true);
if (!$data || !isset($data['token']) || !isset($data['new_password'])) {
    http_response_code(400);
    echo json_encode(['error' => 'Token and new password are required']);
    exit;
}

$token = trim($data['token']);
$new_password = $data['new_password'];

if (strlen($new_password) < 6) {
    http_response_code(400);
    echo json_encode(['error' => 'Password must be at least 6 characters']);
    exit;
}

$db = getDB();

// Verify token and check expiration
$stmt = $db->prepare('SELECT id FROM users WHERE reset_token = ? AND reset_token_expires > NOW()');
$stmt->execute([$token]);
$user = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$user) {
    http_response_code(400);
    echo json_encode(['error' => 'Invalid or expired reset token']);
    exit;
}

// Hash new password
$hashed_password = password_hash($new_password, PASSWORD_DEFAULT);

// Update password and clear reset token
$stmt = $db->prepare('UPDATE users SET password_hash = ?, reset_token = NULL, reset_token_expires = NULL WHERE id = ?');
$result = $stmt->execute([$hashed_password, $user['id']]);

if ($result) {
    echo json_encode([
        'success' => true,
        'message' => 'Password reset successfully'
    ]);
} else {
    http_response_code(500);
    echo json_encode(['error' => 'Password reset failed']);
}
?>
