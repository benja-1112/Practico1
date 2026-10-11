<?php
namespace App\Models;

class LibroModel {
    private $db;

    public function __construct($db) {
        $this->db = $db;
    }

    // El Modelo es el ÚNICO que sabe de SQL.
    public function listar(array $filtros) {
        $sql = 'SELECT l.id_libro, l.titulo, l.anio, l.precio, l.tipo, l.origen,
                       l.imagen, l.rating, l.mas_vendido, l.novedad, l.recomendado, l.en_oferta,
                       a.id_autor, a.nombre AS nombre_autor,
                       c.id_categoria, c.nombre AS nombre_categoria
                FROM LIBROS l
                INNER JOIN AUTORES a ON a.id_autor = l.id_autor
                INNER JOIN CATEGORIAS c ON c.id_categoria = l.id_categoria
                WHERE 1 = 1';
        $params = [];

        $tipos = ['Libro', 'Comic'];
        if (!empty($filtros['tipo']) && in_array($filtros['tipo'], $tipos, true)) {
            $sql .= ' AND l.tipo = :tipo';
            $params[':tipo'] = $filtros['tipo'];
        }

        $origenes = ['Nacional', 'Extranjero'];
        if (!empty($filtros['origen']) && in_array($filtros['origen'], $origenes, true)) {
            $sql .= ' AND l.origen = :origen';
            $params[':origen'] = $filtros['origen'];
        }

        if (!empty($filtros['id_autor']) && ctype_digit((string) $filtros['id_autor'])) {
            $sql .= ' AND l.id_autor = :id_autor';
            $params[':id_autor'] = (int) $filtros['id_autor'];
        }

        if (!empty($filtros['id_categoria']) && ctype_digit((string) $filtros['id_categoria'])) {
            $sql .= ' AND l.id_categoria = :id_categoria';
            $params[':id_categoria'] = (int) $filtros['id_categoria'];
        }

        if (!empty($filtros['anio']) && ctype_digit((string) $filtros['anio'])) {
            $sql .= ' AND l.anio = :anio';
            $params[':anio'] = (int) $filtros['anio'];
        }

        foreach (['mas_vendido', 'novedad', 'recomendado', 'en_oferta'] as $flag) {
            if (($filtros[$flag] ?? '') === '1') {
                $sql .= ' AND l.' . $flag . ' = 1';
            }
        }

        if (($filtros['orden'] ?? '') === 'precio') {
            $sql .= ' ORDER BY l.precio IS NULL, l.precio ASC, l.id_libro ASC';
        } else {
            $sql .= ' ORDER BY l.id_libro ASC';
        }

        try {
            $stmt = $this->db->prepare($sql);
            $stmt->execute($params);
            $filas = $stmt->fetchAll(\PDO::FETCH_ASSOC);

            foreach ($filas as &$fila) {
                $fila['id_libro'] = (int) $fila['id_libro'];
                $fila['id_autor'] = (int) $fila['id_autor'];
                $fila['id_categoria'] = (int) $fila['id_categoria'];
                $fila['titulo'] = $this->texto($fila['titulo']);
                $fila['tipo'] = $this->texto($fila['tipo']);
                $fila['origen'] = $this->texto($fila['origen']);
                $fila['nombre_autor'] = $this->texto($fila['nombre_autor']);
                $fila['nombre_categoria'] = $this->texto($fila['nombre_categoria']);
                $fila['anio'] = $fila['anio'] !== null ? (int) $fila['anio'] : null;
                $fila['precio'] = $fila['precio'] !== null ? (float) $fila['precio'] : null;
                $fila['rating'] = (int) $fila['rating'];
                $fila['mas_vendido'] = (int) $fila['mas_vendido'];
                $fila['novedad'] = (int) $fila['novedad'];
                $fila['recomendado'] = (int) $fila['recomendado'];
                $fila['en_oferta'] = (int) $fila['en_oferta'];
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
