<?php
namespace App\Models;

class UsuarioModel {
    private $db;

    public function __construct($db) {
        $this->db = $db;
    }

    // El Modelo es el ÚNICO que sabe de SQL.
    public function buscarPorEmail($email) {
        $sql = 'SELECT u.id_usuario, u.nombre_completo, u.email, u.clave_hash, r.nombre AS rol
                FROM USUARIOS u
                INNER JOIN ROLES r ON r.id_rol = u.id_rol
                WHERE u.email = :email
                LIMIT 1';

        try {
            $stmt = $this->db->prepare($sql);
            $stmt->execute([':email' => $email]);
            $fila = $stmt->fetch(\PDO::FETCH_ASSOC);
            if (!$fila) {
                return null;
            }
            $fila['id_usuario'] = (int) $fila['id_usuario'];
            $fila['nombre_completo'] = $this->texto($fila['nombre_completo']);
            $fila['rol'] = $this->texto($fila['rol']);
            return $fila;
        } catch (\Exception $e) {
            return false;
        }
    }

    private function texto($valor) {
        if (!is_string($valor) || !preg_match('/Ã|Â/u', $valor)) {
            return $valor;
        }
        $reparado = iconv('UTF-8', 'ISO-8859-1//IGNORE', $valor);
        if ($reparado === false || !preg_match('//u', $reparado)) {
            return $valor;
        }
        return $reparado;
    }
}
