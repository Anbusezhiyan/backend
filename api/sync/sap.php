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

$data = json_decode(file_get_contents('php://input'), true);
$sync_type = $data['sync_type'] ?? 'all';

$db = getDB();

// Simulate SAP data sync (in production, this would connect to actual SAP system)
$synced_records = 0;

try {
    if ($sync_type === 'stock' || $sync_type === 'all') {
        // Simulate syncing stock data from SAP
        // In production: Connect to SAP API and fetch stock data

        // Mock data sync - update existing stocks or add new ones
        $mock_stocks = [
            ['plant_name' => 'Plant A', 'product' => 'Iron Ore', 'quantity' => 28000, 'aging_days' => 6],
            ['plant_name' => 'Plant B', 'product' => 'Coal', 'quantity' => 19000, 'aging_days' => 4],
        ];

        foreach ($mock_stocks as $stock) {
            // Get plant ID
            $stmt = $db->prepare('SELECT id FROM plants WHERE name = ?');
            $stmt->execute([$stock['plant_name']]);
            $plant = $stmt->fetch(PDO::FETCH_ASSOC);

            if ($plant) {
                // Update or insert stock
                $stmt = $db->prepare('
                    INSERT INTO stocks (plant_id, product, quantity, aging_days)
                    VALUES (?, ?, ?, ?)
                    ON DUPLICATE KEY UPDATE
                    quantity = VALUES(quantity), aging_days = VALUES(aging_days)
                ');
                $stmt->execute([$plant['id'], $stock['product'], $stock['quantity'], $stock['aging_days']]);
                $synced_records++;
            }
        }
    }

    if ($sync_type === 'orders' || $sync_type === 'all') {
        // Simulate syncing order/demand data from SAP
        // In production: Fetch order data from SAP

        $mock_demands = [
            ['plant_name' => 'Plant A', 'demand' => 32000],
            ['plant_name' => 'Plant B', 'demand' => 27000],
        ];

        foreach ($mock_demands as $demand) {
            $stmt = $db->prepare('UPDATE plants SET demand = ? WHERE name = ?');
            $stmt->execute([$demand['demand'], $demand['plant_name']]);
            $synced_records++;
        }
    }

    echo json_encode([
        'success' => true,
        'message' => 'SAP data sync completed successfully',
        'sync_type' => $sync_type,
        'synced_records' => $synced_records
    ]);

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        'error' => 'SAP sync failed',
        'details' => $e->getMessage()
    ]);
}
?>
