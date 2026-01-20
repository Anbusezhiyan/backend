<?php
require_once '../../config.php';
require_once '../jwt.php';

header('Content-Type: application/json');

$user = getUserFromToken();
if (!$user) {
    http_response_code(401);
    echo json_encode(['error' => 'Unauthorized']);
    exit;
}

$db = getDB();

$stmt = $db->prepare('SELECT id, username, email, role, created_at FROM users WHERE id = ?');
$stmt->execute([$user['user_id']]);
$user_data = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$user_data) {
    http_response_code(404);
    echo json_encode(['error' => 'User not found']);
    exit;
}

echo json_encode($user_data);
?>
