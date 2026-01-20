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

$db = getDB();

// Check if file was uploaded
if (!isset($_FILES['file']) || !isset($_POST['type'])) {
    http_response_code(400);
    echo json_encode(['error' => 'File and type required']);
    exit;
}

$type = $_POST['type'];
$allowed_types = ['vessels', 'stocks'];

if (!in_array($type, $allowed_types)) {
    http_response_code(400);
    echo json_encode(['error' => 'Invalid type. Must be vessels or stocks']);
    exit;
}

$file = $_FILES['file'];
$file_extension = pathinfo($file['name'], PATHINFO_EXTENSION);

if (!in_array(strtolower($file_extension), ['csv', 'xlsx', 'xls'])) {
    http_response_code(400);
    echo json_encode(['error' => 'Invalid file format. Must be CSV, XLSX, or XLS']);
    exit;
}

// For demo purposes, handle CSV parsing
$content = file_get_contents($file['tmp_name']);
$lines = explode("\n", trim($content));
$header = str_getcsv(array_shift($lines));

$records_processed = 0;
$errors = [];

foreach ($lines as $line) {
    if (empty(trim($line))) continue;

    $data = str_getcsv($line);

    if ($type === 'vessels') {
        // Expected CSV format: Vessel Name,Capacity (MT),ETA,Current Delay (Days),Distance (NM),Weather Factor
        if (count($data) < 3) {
            $errors[] = "Invalid vessel data format";
            continue;
        }

        $name = trim($data[0]);
        $capacity = (int)$data[1];
        $eta = trim($data[2]);

        if (empty($name) || $capacity <= 0 || empty($eta)) {
            $errors[] = "Invalid vessel data: $name";
            continue;
        }

        try {
            $stmt = $db->prepare('INSERT INTO vessels (name, capacity, eta) VALUES (?, ?, ?)');
            $stmt->execute([$name, $capacity, $eta]);
            $records_processed++;
        } catch (Exception $e) {
            $errors[] = "Failed to insert vessel $name: " . $e->getMessage();
        }
    } elseif ($type === 'stocks') {
        // Expected CSV format: Plant Name,Product,Quantity (MT),Aging Days,Demand (MT)
        if (count($data) < 5) {
            $errors[] = "Invalid stock data format";
            continue;
        }

        $plant_name = trim($data[0]);
        $product = trim($data[1]);
        $quantity = (int)$data[2];
        $aging_days = (int)$data[3];
        $demand = (int)$data[4];

        // Get plant ID
        $stmt = $db->prepare('SELECT id FROM plants WHERE name = ?');
        $stmt->execute([$plant_name]);
        $plant = $stmt->fetch(PDO::FETCH_ASSOC);

        if (!$plant) {
            $errors[] = "Plant not found: $plant_name";
            continue;
        }

        try {
            $stmt = $db->prepare('INSERT INTO stocks (plant_id, product, quantity, aging_days) VALUES (?, ?, ?, ?)');
            $stmt->execute([$plant['id'], $product, $quantity, $aging_days]);
            $records_processed++;
        } catch (Exception $e) {
            $errors[] = "Failed to insert stock for $plant_name: " . $e->getMessage();
        }
    }
}

$response = [
    'success' => true,
    'message' => 'Data uploaded successfully',
    'records_processed' => $records_processed
];

if (!empty($errors)) {
    $response['warnings'] = $errors;
}

echo json_encode($response);
?>
