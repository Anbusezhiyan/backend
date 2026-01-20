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

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    http_response_code(405);
    echo json_encode(['error' => 'Method not allowed']);
    exit;
}

$db = getDB();

// Calculate KPIs (simplified mock data - in production, calculate from real data)
$plans_count = $db->query('SELECT COUNT(*) as count FROM plans WHERE status = "approved"')->fetch()['count'];
$users_count = $db->query('SELECT COUNT(*) as count FROM users')->fetch()['count'];
$vessels_count = $db->query('SELECT COUNT(*) as count FROM vessels')->fetch()['count'];

// Mock KPI calculations
$cost_savings = 15.5; // Percentage cost savings
$on_time_delivery = 92.3; // Percentage
$utilization_rate = 87.1; // Percentage
$demurrage_reduction = 23.7; // Percentage

echo json_encode([
    'total_plans' => (int)$plans_count,
    'total_users' => (int)$users_count,
    'total_vessels' => (int)$vessels_count,
    'cost_savings_percentage' => $cost_savings,
    'on_time_delivery_percentage' => $on_time_delivery,
    'utilization_rate_percentage' => $utilization_rate,
    'demurrage_reduction_percentage' => $demurrage_reduction,
    'generated_at' => date('Y-m-d H:i:s')
]);
?>
