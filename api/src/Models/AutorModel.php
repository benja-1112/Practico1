<?php
namespace App\Models;

class AutorModel {
    private $db;

    public function __construct($db) {
        $this->db = $db;
    }

    // El Modelo es el ÚNICO que sabe de SQL.
    public function listar() {
        $sql = 'SELECT id_autor, nombre, nacionalidad
                FROM AUTORES
                ORDER BY nombre ASC';

        try {
            $stmt = $this->db->query($sql);
            $filas = $stmt->fetchAll(\PDO::FETCH_ASSOC);

            foreach ($filas as &$fila) {
                $fila['id_autor'] = (int) $fila['id_autor'];
                $fila['nombre'] = $this->texto($fila['nombre']);
                $fila['nacionalidad'] = $this->texto($fila['nacionalidad']);
            }

            return $filas;
        } catch (\Exception $e) {
            return false;
        }
    }

    // Si el script se cargó con el cliente en latin1, "é" queda como "Ã©".
    // Con SET NAMES utf8mb4 esto no pasa; el arreglo solo cubre ese caso.
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
