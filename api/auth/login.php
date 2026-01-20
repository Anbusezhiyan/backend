<?php
require_once '../../config.php';
require_once '../jwt.php'; // Assuming we have a JWT helper

header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['error' => 'Method not allowed']);
    exit;
}

$data = json_decode(file_get_contents('php://input'), true);
if (!$data || !isset($data['username']) || !isset($data['password'])) {
    http_response_code(400);
    echo json_encode(['error' => 'Invalid input']);
    exit;
}

$db = getDB();
$stmt = $db->prepare('SELECT id, password_hash, role FROM users WHERE username = ?');
$stmt->execute([$data['username']]);
$user = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$user || !password_verify($data['password'], $user['password_hash'])) {
    http_response_code(401);
    echo json_encode(['error' => 'Invalid credentials']);
    exit;
}

// Generate JWT
$token = generateJWT($user['id'], $user['role']);

echo json_encode([
    'success' => true,
    'token' => $token,
    'role' => $user['role'],
    'expires_in' => 3600
]);
?>
