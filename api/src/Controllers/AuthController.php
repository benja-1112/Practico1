<?php
namespace App\Controllers;

use App\Models\UsuarioModel;

class AuthController {
    private $db;

    public function __construct($db) {
        $this->db = $db;
    }

    public function login() {
        $cuerpo = json_decode(file_get_contents('php://input'), true);
        if (!is_array($cuerpo)) {
            $cuerpo = [];
        }

        $email = trim((string) ($cuerpo['email'] ?? ''));
        $clave = (string) ($cuerpo['clave'] ?? '');

        if ($email === '' || $clave === '') {
            http_response_code(400);
            echo json_encode([
                'status' => 'error',
                'message' => 'Completá el email y la clave.',
            ], JSON_UNESCAPED_UNICODE);
            return;
        }

        $usuarioModel = new UsuarioModel($this->db);
        $usuario = $usuarioModel->buscarPorEmail($email);

        if ($usuario === false) {
            http_response_code(500);
            echo json_encode([
                'status' => 'error',
                'message' => 'No se pudo leer los usuarios. Revisá que la base tenga las tablas ROLES y USUARIOS.',
            ], JSON_UNESCAPED_UNICODE);
            return;
        }

        $claveOk = $usuario && password_verify($clave, $usuario['clave_hash']);
        if (!$claveOk) {
            http_response_code(401);
            echo json_encode([
                'status' => 'error',
                'message' => 'Email o clave incorrectos.',
            ], JSON_UNESCAPED_UNICODE);
            return;
        }

        session_regenerate_id(true);
        $_SESSION['usuario'] = $this->publico($usuario);

        echo json_encode([
            'status' => 'ok',
            'data' => $_SESSION['usuario'],
        ], JSON_UNESCAPED_UNICODE);
    }

    public function ver() {
        if (empty($_SESSION['usuario'])) {
            http_response_code(401);
            echo json_encode([
                'status' => 'error',
                'message' => 'No hay una sesión abierta.',
            ], JSON_UNESCAPED_UNICODE);
            return;
        }

        echo json_encode([
            'status' => 'ok',
            'data' => $_SESSION['usuario'],
        ], JSON_UNESCAPED_UNICODE);
    }

    public function logout() {
        $_SESSION = [];
        if (ini_get('session.use_cookies')) {
            $params = session_get_cookie_params();
            setcookie(session_name(), '', time() - 42000, $params['path'], $params['domain'], $params['secure'], $params['httponly']);
        }
        session_destroy();

        echo json_encode([
            'status' => 'ok',
            'message' => 'Sesión cerrada.',
        ], JSON_UNESCAPED_UNICODE);
    }

    private function publico(array $usuario) {
        return [
            'id_usuario' => $usuario['id_usuario'],
            'nombre_completo' => $usuario['nombre_completo'],
            'email' => $usuario['email'],
            'rol' => $usuario['rol'],
        ];
    }
}
