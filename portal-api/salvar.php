<?php

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");


if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    exit;
}

$json = file_get_contents('php://input');
$dadosRecebidos = json_decode($json, true);

if ($dadosRecebidos) {
    $arquivo = 'dados.json';
    
    $lista = [];
    if (file_exists($arquivo)) {
        $conteudo = file_get_contents($arquivo);
        $lista = json_decode($conteudo, true) ?? [];
    }

    $lista[] = $dadosRecebidos;

    file_put_contents($arquivo, json_encode($lista, JSON_PRETTY_PRINT));

    echo json_encode(["mensagem" => "Sucesso! Salvo no servidor de API."]);
} else {
    http_response_code(400);
    echo json_encode(["mensagem" => "Erro: Dados inválidos."]);
}
?>