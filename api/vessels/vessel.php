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

// Get vessel ID from URL
$url_parts = explode('/', $_SERVER['REQUEST_URI']);
$vessel_id = end($url_parts);

if (!is_numeric($vessel_id)) {
    http_response_code(400);
    echo json_encode(['error' => 'Invalid vessel ID']);
    exit;
}

$db = getDB();
$method = $_SERVER['REQUEST_METHOD'];

switch ($method) {
    case 'GET':
        // Get specific vessel
        $stmt = $db->prepare('SELECT id, name, capacity, eta, predicted_delay FROM vessels WHERE id = ?');
        $stmt->execute([$vessel_id]);
        $vessel = $stmt->fetch(PDO::FETCH_ASSOC);

        if (!$vessel) {
            http_response_code(404);
            echo json_encode(['error' => 'Vessel not found']);
            exit;
        }

        echo json_encode($vessel);
        break;

    case 'PUT':
        // Update vessel
        $data = json_decode(file_get_contents('php://input'), true);
        if (!$data) {
            http_response_code(400);
            echo json_encode(['error' => 'Invalid input']);
            exit;
        }

        // Check if vessel exists
        $stmt = $db->prepare('SELECT id FROM vessels WHERE id = ?');
        $stmt->execute([$vessel_id]);
        if (!$stmt->fetch()) {
            http_response_code(404);
            echo json_encode(['error' => 'Vessel not found']);
            exit;
        }

        // Build update query
        $update_fields = [];
        $params = [];

        if (isset($data['name'])) {
            $update_fields[] = 'name = ?';
            $params[] = $data['name'];
        }

        if (isset($data['capacity']) && is_numeric($data['capacity']) && $data['capacity'] > 0) {
            $update_fields[] = 'capacity = ?';
            $params[] = $data['capacity'];
        }

        if (isset($data['eta'])) {
            $update_fields[] = 'eta = ?';
            $params[] = $data['eta'];
        }

        if (empty($update_fields)) {
            http_response_code(400);
            echo json_encode(['error' => 'No valid fields to update']);
            exit;
        }

        $params[] = $vessel_id;
        $query = 'UPDATE vessels SET ' . implode(', ', $update_fields) . ' WHERE id = ?';
        $stmt = $db->prepare($query);
        $stmt->execute($params);

        echo json_encode(['success' => true, 'message' => 'Vessel updated successfully']);
        break;

    case 'DELETE':
        // Delete vessel
        $stmt = $db->prepare('DELETE FROM vessels WHERE id = ?');
        $stmt->execute([$vessel_id]);

        if ($stmt->rowCount() === 0) {
            http_response_code(404);
            echo json_encode(['error' => 'Vessel not found']);
            exit;
        }

        echo json_encode(['success' => true, 'message' => 'Vessel deleted successfully']);
        break;

    default:
        http_response_code(405);
        echo json_encode(['error' => 'Method not allowed']);
}
?>
