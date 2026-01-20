<?php
require_once(__DIR__ . '/../config.php');

function base64UrlEncode($data) {
    return str_replace(['+', '/', '='], ['-', '_', ''], base64_encode($data));
}

function base64UrlDecode($data) {
    return base64_decode(str_replace(['-', '_'], ['+', '/'], $data));
}

function generateJWT($userId, $role) {
    $header = json_encode(['typ' => 'JWT', 'alg' => 'HS256']);
    $payload = json_encode([
        'user_id' => $userId,
        'role' => $role,
        'iat' => time(),
        'exp' => time() + 3600
    ]);

    $headerEncoded = base64UrlEncode($header);
    $payloadEncoded = base64UrlEncode($payload);

    $signature = hash_hmac('sha256', $headerEncoded . "." . $payloadEncoded, JWT_SECRET, true);
    $signatureEncoded = base64UrlEncode($signature);

    return $headerEncoded . "." . $payloadEncoded . "." . $signatureEncoded;
}

function validateJWT($token) {
    $parts = explode('.', $token);
    if (count($parts) !== 3) return false;

    $header = base64UrlDecode($parts[0]);
    $payload = base64UrlDecode($parts[1]);
    $signature = $parts[2];

    $expectedSignature = base64UrlEncode(hash_hmac('sha256', $parts[0] . "." . $parts[1], JWT_SECRET, true));

    if ($signature !== $expectedSignature) return false;

    $payloadData = json_decode($payload, true);
    if ($payloadData['exp'] < time()) return false;

    return $payloadData;
}

function getUserFromToken() {
    $headers = getallheaders();
    if (!isset($headers['Authorization'])) return false;

    $authHeader = $headers['Authorization'];
    if (strpos($authHeader, 'Bearer ') !== 0) return false;

    $token = substr($authHeader, 7);
    return validateJWT($token);
}
?>
