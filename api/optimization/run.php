<?php
require_once '../../config.php';
require_once '../jwt.php';

header('Content-Type: application/json');

$user = getUserFromToken();
if (!$user || !in_array($user['role'], ['admin', 'logistics_planner'])) {
    http_response_code(403);
    echo json_encode(['error' => 'Forbidden']);
    exit;
}

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['error' => 'Method not allowed']);
    exit;
}

// Fetch data from DB
$db = getDB();
$vessels = $db->query('SELECT * FROM vessels')->fetchAll(PDO::FETCH_ASSOC);
$ports = $db->query('SELECT * FROM ports')->fetchAll(PDO::FETCH_ASSOC);
$plants = $db->query('SELECT * FROM plants')->fetchAll(PDO::FETCH_ASSOC);
$costs = $db->query('SELECT * FROM rail_costs')->fetchAll(PDO::FETCH_ASSOC);

$data = json_encode([
    'vessels' => $vessels,
    'ports' => $ports,
    'plants' => $plants,
    'costs' => $costs
]);

// Call Python service
$ch = curl_init(PYTHON_URL . '/run-optimization');
curl_setopt($ch, CURLOPT_POST, true);
curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type: application/json']);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_TIMEOUT, 30);

$response = curl_exec($ch);
$httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
curl_close($ch);

if ($httpCode !== 200) {
    http_response_code(500);
    echo json_encode(['error' => 'Optimization service failed']);
    exit;
}

$result = json_decode($response, true);

// Store in DB
$stmt = $db->prepare('INSERT INTO plans (user_id, schedule_json, total_cost, status) VALUES (?, ?, ?, ?)');
$stmt->execute([$user['user_id'], json_encode($result['optimal_schedule']), $result['total_cost'], 'pending']);

echo json_encode(['success' => true, 'plan_id' => $db->lastInsertId()]);
?>
