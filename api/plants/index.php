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

$db = getDB();
$method = $_SERVER['REQUEST_METHOD'];

switch ($method) {
    case 'GET':
        $stmt = $db->query('SELECT id, name, demand, location FROM plants');
        $plants = $stmt->fetchAll(PDO::FETCH_ASSOC);
        echo json_encode($plants);
        break;

    case 'POST':
        $data = json_decode(file_get_contents('php://input'), true);
        if (!$data || !isset($data['name']) || !isset($data['demand']) || !isset($data['location'])) {
            http_response_code(400);
            echo json_encode(['error' => 'Invalid input']);
            exit;
        }
        $stmt = $db->prepare('INSERT INTO plants (name, demand, location) VALUES (?, ?, ?)');
        $stmt->execute([$data['name'], $data['demand'], $data['location']]);
        echo json_encode(['success' => true, 'id' => $db->lastInsertId()]);
        break;

    default:
        http_response_code(405);
        echo json_encode(['error' => 'Method not allowed']);
}
?>
