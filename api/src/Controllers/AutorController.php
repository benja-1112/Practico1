<?php
namespace App\Controllers;

use App\Models\AutorModel;

class AutorController {
    private $db;

    public function __construct($db) {
        $this->db = $db;
    }

    public function listar() {
        $autorModel = new AutorModel($this->db);
        $autores = $autorModel->listar();

        if ($autores === false) {
            http_response_code(500);
            echo json_encode([
                'status' => 'error',
                'message' => 'No se pudo leer los autores. Revisá que la base tenga el esquema nuevo.',
            ], JSON_UNESCAPED_UNICODE);
            return;
        }

        echo json_encode([
            'status' => 'ok',
            'data' => $autores,
        ], JSON_UNESCAPED_UNICODE);
    }
}
