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

// Get plant ID from URL
$url_parts = explode('/', $_SERVER['REQUEST_URI']);
$plant_id = end($url_parts);

if (!is_numeric($plant_id)) {
    http_response_code(400);
    echo json_encode(['error' => 'Invalid plant ID']);
    exit;
}

$db = getDB();
$method = $_SERVER['REQUEST_METHOD'];

switch ($method) {
    case 'GET':
        $stmt = $db->prepare('SELECT id, name, demand, location FROM plants WHERE id = ?');
        $stmt->execute([$plant_id]);
        $plant = $stmt->fetch(PDO::FETCH_ASSOC);

        if (!$plant) {
            http_response_code(404);
            echo json_encode(['error' => 'Plant not found']);
            exit;
        }

        echo json_encode($plant);
        break;

    case 'PUT':
        $data = json_decode(file_get_contents('php://input'), true);
        if (!$data) {
            http_response_code(400);
            echo json_encode(['error' => 'Invalid input']);
            exit;
        }

        $stmt = $db->prepare('SELECT id FROM plants WHERE id = ?');
        $stmt->execute([$plant_id]);
        if (!$stmt->fetch()) {
            http_response_code(404);
            echo json_encode(['error' => 'Plant not found']);
            exit;
        }

        $update_fields = [];
        $params = [];

        if (isset($data['name'])) {
            $update_fields[] = 'name = ?';
            $params[] = $data['name'];
        }

        if (isset($data['demand']) && is_numeric($data['demand']) && $data['demand'] >= 0) {
            $update_fields[] = 'demand = ?';
            $params[] = $data['demand'];
        }

        if (isset($data['location'])) {
            $update_fields[] = 'location = ?';
            $params[] = $data['location'];
        }

        if (empty($update_fields)) {
            http_response_code(400);
            echo json_encode(['error' => 'No valid fields to update']);
            exit;
        }

        $params[] = $plant_id;
        $query = 'UPDATE plants SET ' . implode(', ', $update_fields) . ' WHERE id = ?';
        $stmt = $db->prepare($query);
        $stmt->execute($params);

        echo json_encode(['success' => true, 'message' => 'Plant updated successfully']);
        break;

    case 'DELETE':
        $stmt = $db->prepare('DELETE FROM plants WHERE id = ?');
        $stmt->execute([$plant_id]);

        if ($stmt->rowCount() === 0) {
            http_response_code(404);
            echo json_encode(['error' => 'Plant not found']);
            exit;
        }

        echo json_encode(['success' => true, 'message' => 'Plant deleted successfully']);
        break;

    default:
        http_response_code(405);
        echo json_encode(['error' => 'Method not allowed']);
}
?>
