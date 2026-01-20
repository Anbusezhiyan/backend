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
$method = $_SERVER['REQUEST_METHOD'];

switch ($method) {
    case 'GET':
        // Check if an ID parameter is provided in the URL
        $url_parts = explode('/', trim($_SERVER['REQUEST_URI'], '/'));
        $plan_id = end($url_parts);

        // If the last part is numeric and not 'index.php', treat it as plan ID
        if (is_numeric($plan_id) && $plan_id != 'index.php') {
            // Get specific plan details
            $query = 'SELECT p.id, p.user_id, p.schedule_json, p.total_cost, p.status, p.created_at, u.username as created_by FROM plans p JOIN users u ON p.user_id = u.id WHERE p.id = ?';

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

            echo json_encode($plan);
        } else {
            // Get all plans (with role-based filtering)
            $query = 'SELECT p.id, p.user_id, p.schedule_json, p.total_cost, p.status, p.created_at, u.username as created_by FROM plans p JOIN users u ON p.user_id = u.id';

            // Operations Manager can only see approved plans, others see all
            if ($user['role'] === 'operations_manager') {
                $query .= ' WHERE p.status = "approved"';
            }

            $query .= ' ORDER BY p.created_at DESC';

            $stmt = $db->query($query);
            $plans = $stmt->fetchAll(PDO::FETCH_ASSOC);
            echo json_encode($plans);
        }
        break;

    default:
        http_response_code(405);
        echo json_encode(['error' => 'Method not allowed']);
}
?>
