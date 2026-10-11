<?php
namespace App\Controllers;

use App\Models\LibroModel;

class LibroController {
    private $db;

    public function __construct($db) {
        $this->db = $db;
    }

    public function listar() {
        $filtros = [
            'tipo' => $_GET['tipo'] ?? null,
            'origen' => $_GET['origen'] ?? null,
            'id_autor' => $_GET['id_autor'] ?? null,
            'id_categoria' => $_GET['id_categoria'] ?? null,
            'anio' => $_GET['anio'] ?? null,
            'mas_vendido' => $_GET['mas_vendido'] ?? null,
            'novedad' => $_GET['novedad'] ?? null,
            'recomendado' => $_GET['recomendado'] ?? null,
            'en_oferta' => $_GET['en_oferta'] ?? null,
            'orden' => $_GET['orden'] ?? null,
        ];

        $libroModel = new LibroModel($this->db);
        $libros = $libroModel->listar($filtros);

        if ($libros === false) {
            http_response_code(500);
            echo json_encode([
                'status' => 'error',
                'message' => 'No se pudo leer el catálogo. Revisá que la base tenga el esquema nuevo.',
            ], JSON_UNESCAPED_UNICODE);
            return;
        }

        echo json_encode([
            'status' => 'ok',
            'data' => $libros,
        ], JSON_UNESCAPED_UNICODE);
    }

    // Misma lista que el catálogo, pero solo si la sesión es de un administrador.
    public function listarAdmin() {
        $rol = $_SESSION['usuario']['rol'] ?? '';
        if ($rol !== 'Administrador') {
            http_response_code(403);
            echo json_encode([
                'status' => 'error',
                'message' => 'No tenés permiso para ver el panel de administración.',
            ], JSON_UNESCAPED_UNICODE);
            return;
        }

        $this->listar();
    }
}
