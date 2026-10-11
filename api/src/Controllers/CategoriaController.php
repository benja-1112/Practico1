<?php
namespace App\Controllers;

use App\Models\CategoriaModel;

class CategoriaController {
    private $db;

    public function __construct($db) {
        $this->db = $db;
    }

    public function listar() {
        $categoriaModel = new CategoriaModel($this->db);
        $categorias = $categoriaModel->listar();

        if ($categorias === false) {
            http_response_code(500);
            echo json_encode([
                'status' => 'error',
                'message' => 'No se pudo leer las categorías. Revisá que la base tenga el esquema nuevo.',
            ], JSON_UNESCAPED_UNICODE);
            return;
        }

        echo json_encode([
            'status' => 'ok',
            'data' => $categorias,
        ], JSON_UNESCAPED_UNICODE);
    }
}
