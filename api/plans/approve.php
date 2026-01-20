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

if ($_SERVER['REQUEST_METHOD'] !== 'PUT') {
    http_response_code(405);
    echo json_encode(['error' => 'Method not allowed']);
    exit;
}

// Get plan ID from URL
$url_parts = explode('/', $_SERVER['REQUEST_URI']);
$plan_id = end($url_parts);

if (!is_numeric($plan_id)) {
    http_response_code(400);
    echo json_encode(['error' => 'Invalid plan ID']);
    exit;
}

$db = getDB();

// Check if user has permission to approve (Admin or Operations Manager)
if (!in_array($user['role'], ['admin', 'operations_manager'])) {
    http_response_code(403);
    echo json_encode(['error' => 'Insufficient permissions to approve plans']);
    exit;
}

// Check if plan exists and is pending
$stmt = $db->prepare('SELECT id, status FROM plans WHERE id = ?');
$stmt->execute([$plan_id]);
$plan = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$plan) {
    http_response_code(404);
    echo json_encode(['error' => 'Plan not found']);
    exit;
}

if ($plan['status'] !== 'pending') {
    http_response_code(400);
    echo json_encode(['error' => 'Plan is not in pending status']);
    exit;
}

// Approve the plan
$stmt = $db->prepare('UPDATE plans SET status = "approved" WHERE id = ?');
$result = $stmt->execute([$plan_id]);

if ($result) {
    echo json_encode([
        'success' => true,
        'message' => 'Plan approved successfully'
    ]);
} else {
    http_response_code(500);
    echo json_encode(['error' => 'Failed to approve plan']);
}
?>
