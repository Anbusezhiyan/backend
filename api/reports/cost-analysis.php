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

$plan_id = $_GET['plan_id'] ?? null;
$period = $_GET['period'] ?? 'monthly';

$db = getDB();

if ($plan_id && is_numeric($plan_id)) {
    // Get cost analysis for specific plan
    $query = 'SELECT p.id, p.total_cost, p.schedule_json, p.status, u.username as created_by FROM plans p JOIN users u ON p.user_id = u.id WHERE p.id = ?';

    // Operations Manager can only see approved plans
    if ($user['role'] === 'operations_manager') {
        $query .= ' AND p.status = "approved"';
    }

    $stmt = $db->prepare($query);
    $stmt->execute([$plan_id]);
    $plan = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$plan) {
        http_response_code(404);
        echo json_encode(['error' => 'Plan not found or access denied']);
        exit;
    }

    // Calculate cost breakdown (simplified for demo)
    $total_cost = (float)$plan['total_cost'];
    $ocean_freight = $total_cost * 0.4;  // 40% ocean freight
    $port_handling = $total_cost * 0.25; // 25% port handling
    $rail_freight = $total_cost * 0.2;   // 20% rail freight
    $demurrage = $total_cost * 0.15;     // 15% demurrage

    echo json_encode([
        'plan_id' => (int)$plan['id'],
        'plan_status' => $plan['status'],
        'created_by' => $plan['created_by'],
        'period' => $period,
        'ocean_freight' => round($ocean_freight, 2),
        'port_handling' => round($port_handling, 2),
        'rail_freight' => round($rail_freight, 2),
        'demurrage' => round($demurrage, 2),
        'total_cost' => round($total_cost, 2)
    ]);
} else {
    // Get cost analysis for all accessible plans
    $query = 'SELECT p.id, p.total_cost, p.status, p.created_at, u.username as created_by FROM plans p JOIN users u ON p.user_id = u.id';

    // Operations Manager can only see approved plans
    if ($user['role'] === 'operations_manager') {
        $query .= ' WHERE p.status = "approved"';
    }

    $query .= ' ORDER BY p.created_at DESC';

    $stmt = $db->query($query);
    $plans = $stmt->fetchAll(PDO::FETCH_ASSOC);

    $cost_analyses = [];
    $total_overall_cost = 0;

    foreach ($plans as $plan) {
        $total_cost = (float)$plan['total_cost'];
        $ocean_freight = $total_cost * 0.4;
        $port_handling = $total_cost * 0.25;
        $rail_freight = $total_cost * 0.2;
        $demurrage = $total_cost * 0.15;

        $cost_analyses[] = [
            'plan_id' => (int)$plan['id'],
            'plan_status' => $plan['status'],
            'created_by' => $plan['created_by'],
            'created_at' => $plan['created_at'],
            'period' => $period,
            'ocean_freight' => round($ocean_freight, 2),
            'port_handling' => round($port_handling, 2),
            'rail_freight' => round($rail_freight, 2),
            'demurrage' => round($demurrage, 2),
            'total_cost' => round($total_cost, 2)
        ];

        $total_overall_cost += $total_cost;
    }

    echo json_encode([
        'period' => $period,
        'total_plans' => count($cost_analyses),
        'total_overall_cost' => round($total_overall_cost, 2),
        'plans' => $cost_analyses
    ]);
}
?>
