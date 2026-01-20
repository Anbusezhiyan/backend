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
        $stmt = $db->query('SELECT id, name, capacity, location FROM ports');
        $ports = $stmt->fetchAll(PDO::FETCH_ASSOC);
        echo json_encode($ports);
        break;

    case 'POST':
        $data = json_decode(file_get_contents('php://input'), true);
        if (!$data || !isset($data['name']) || !isset($data['capacity']) || !isset($data['location'])) {
            http_response_code(400);
            echo json_encode(['error' => 'Invalid input']);
            exit;
        }
        $stmt = $db->prepare('INSERT INTO ports (name, capacity, location) VALUES (?, ?, ?)');
        $stmt->execute([$data['name'], $data['capacity'], $data['location']]);
        echo json_encode(['success' => true, 'id' => $db->lastInsertId()]);
        break;

    default:
        http_response_code(405);
        echo json_encode(['error' => 'Method not allowed']);
}
?>
