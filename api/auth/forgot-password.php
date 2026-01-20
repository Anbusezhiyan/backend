<?php
require_once '../../config.php';

header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['error' => 'Method not allowed']);
    exit;
}

$data = json_decode(file_get_contents('php://input'), true);
if (!$data || !isset($data['email'])) {
    http_response_code(400);
    echo json_encode(['error' => 'Email is required']);
    exit;
}

$email = trim($data['email']);
if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    http_response_code(400);
    echo json_encode(['error' => 'Invalid email format']);
    exit;
}

$db = getDB();

// Check if user exists
$stmt = $db->prepare('SELECT id, username FROM users WHERE email = ?');
$stmt->execute([$email]);
$user = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$user) {
    // Don't reveal if email exists for security
    echo json_encode([
        'success' => true,
        'message' => 'If the email exists, a reset link has been sent'
    ]);
    exit;
}

// Generate reset token
$reset_token = bin2hex(random_bytes(32));
$expires_at = date('Y-m-d H:i:s', strtotime('+1 hour'));

// Store reset token (in production, you'd have a password_resets table)
$stmt = $db->prepare('UPDATE users SET reset_token = ?, reset_token_expires = DATE_ADD(NOW(), INTERVAL 10 MINUTE) WHERE id = ?');
$stmt->execute([$reset_token, $user['id']]);

// In production, send email here
// For demo purposes, return the token
echo json_encode([
    'success' => true,
    'message' => 'Password reset link sent to email',
    'reset_token' => $reset_token  // Remove this in production
]);
?>
