-- ========================================================
-- SCRIPT DE CREACIÓN: BOOK-E, BIBLIOTECA VIRTUAL
-- Mismo contenido que documentos/base-de-datos/esquema.sql
-- Docker lo ejecuta solo la primera vez que crea el volumen.
-- ========================================================

SET NAMES utf8mb4;

-- 1. CREACIÓN DE TABLAS (DDL)

CREATE TABLE AUTORES (
    id_autor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    nacionalidad VARCHAR(50) -- NULL en Quino, para practicar IS NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE CATEGORIAS (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE LIBROS (
    id_libro INT AUTO_INCREMENT PRIMARY KEY,
    id_autor INT,
    id_categoria INT,
    titulo VARCHAR(150) NOT NULL,
    anio INT, -- NULL si no tenemos el año (Mafalda)
    precio DECIMAL(10, 2), -- NULL si todavía no tiene precio de lista
    tipo VARCHAR(20), -- 'Libro' o 'Comic'
    origen VARCHAR(20), -- 'Nacional' o 'Extranjero'
    imagen VARCHAR(255), -- URL de la tapa; NULL si no hay archivo
    rating TINYINT NOT NULL DEFAULT 0, -- Estrellas, de 0 a 5
    mas_vendido TINYINT(1) NOT NULL DEFAULT 0, -- 1 = recuadro de la landing
    novedad TINYINT(1) NOT NULL DEFAULT 0,
    recomendado TINYINT(1) NOT NULL DEFAULT 0,
    en_oferta TINYINT(1) NOT NULL DEFAULT 0, -- 1 = filtro Sale
    FOREIGN KEY (id_autor) REFERENCES AUTORES(id_autor),
    FOREIGN KEY (id_categoria) REFERENCES CATEGORIAS(id_categoria)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE ROLES (
    id_rol INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(30) NOT NULL UNIQUE -- 'Administrador' o 'Usuario'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE USUARIOS (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    id_rol INT NOT NULL,
    nombre_completo VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    clave_hash VARCHAR(255) NOT NULL, -- password_hash de PHP, nunca la clave en texto plano
    FOREIGN KEY (id_rol) REFERENCES ROLES(id_rol)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE CLIENTES (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre_completo VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    telefono VARCHAR(20) -- Algunos no tendrán teléfono para probar IS NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE PEDIDOS (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT,
    fecha_pedido DATE,
    monto_total DECIMAL(10, 2), -- Suma del detalle. Puede no coincidir con el precio de un solo libro
    FOREIGN KEY (id_cliente) REFERENCES CLIENTES(id_cliente)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE DETALLE_PEDIDO (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT,
    id_libro INT,
    cantidad INT NOT NULL DEFAULT 1,
    precio_unitario DECIMAL(10, 2), -- Lo que se cobró en esa venta, no el precio actual
    UNIQUE (id_pedido, id_libro), -- El mismo título no se repite dentro de un pedido
    FOREIGN KEY (id_pedido) REFERENCES PEDIDOS(id_pedido),
    FOREIGN KEY (id_libro) REFERENCES LIBROS(id_libro)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ========================================================
-- 2. POBLACIÓN DE DATOS (DML - INSERTS)
-- ========================================================

-- Onetti queda sin libros para probar LEFT JOIN.
-- Quino queda con nacionalidad NULL.
INSERT INTO AUTORES (nombre, nacionalidad) VALUES
('Lewis Carroll', 'Reino Unido'),
('Antoine de Saint-Exupéry', 'Francia'),
('Stephen King', 'Estados Unidos'),
('J.K. Rowling', 'Reino Unido'),
('L. Frank Baum', 'Estados Unidos'),
('Ana Frank', 'Alemania'),
('J.R.R. Tolkien', 'Reino Unido'),
('William Shakespeare', 'Reino Unido'),
('Carlo Collodi', 'Italia'),
('Quino', NULL),
('Juan Carlos Onetti', 'Uruguay'),
('Miguel de Cervantes', 'España'),
('Jane Austen', 'Reino Unido'),
('George Orwell', 'Reino Unido'),
('Gabriel García Márquez', 'Colombia'),
('Jorge Luis Borges', 'Argentina'),
('Julio Cortázar', 'Argentina'),
('Mario Benedetti', 'Uruguay'),
('Horacio Quiroga', 'Uruguay'),
('Roald Dahl', 'Reino Unido'),
('Bram Stoker', 'Irlanda'),
('Mary Shelley', 'Reino Unido'),
('Oscar Wilde', 'Irlanda'),
('Isabel Allende', 'Chile'),
('Agatha Christie', 'Reino Unido'),
('Arthur Conan Doyle', 'Reino Unido'),
('Julio Verne', 'Francia'),
('Mark Twain', 'Estados Unidos'),
('Franz Kafka', 'Chequia'),
('Fiódor Dostoievski', 'Rusia'),
('Charles Dickens', 'Reino Unido'),
('Edgar Allan Poe', 'Estados Unidos'),
('H. G. Wells', 'Reino Unido'),
('Eduardo Galeano', 'Uruguay'),
('Laura Esquivel', 'México'),
('Michael Ende', 'Alemania'),
('Rudyard Kipling', 'Reino Unido'),
('J. M. Barrie', 'Reino Unido'),
('C. S. Lewis', 'Reino Unido');

INSERT INTO CATEGORIAS (nombre) VALUES
('Infantil'),
('Terror'),
('Fantasía'),
('Biografía'),
('Clásico'),
('Cómic');

-- Alicia es el único más vendido. Mafalda no tiene año ni precio.
INSERT INTO LIBROS (id_autor, id_categoria, titulo, anio, precio, tipo, origen, imagen, rating, mas_vendido, novedad, recomendado, en_oferta) VALUES
(1, 1, 'Alicia en el país de las maravillas', 1865, 490.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/id/1123322-L.jpg', 5, 1, 0, 1, 0),
(2, 1, 'El Principito', 1943, 380.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/isbn/9780156012195-L.jpg', 5, 0, 0, 1, 0),
(3, 2, 'It', 1986, 690.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/id/8569284-L.jpg', 4, 0, 0, 0, 1),
(4, 3, 'Harry Potter', 1997, 720.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/id/15155833-L.jpg', 5, 0, 0, 1, 0),
(5, 1, 'El mago de Oz', 1900, 410.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/id/552443-L.jpg', 4, 0, 0, 0, 0),
(3, 2, 'El instituto', 2019, 650.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/id/10712767-L.jpg', 4, 0, 1, 0, 0),
(6, 4, 'El diario de Ana Frank', 1947, 520.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/id/13526331-L.jpg', 5, 0, 0, 1, 0),
(7, 3, 'El señor de los anillos', 1954, 890.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/id/14627060-L.jpg', 5, 0, 0, 1, 0),
(8, 5, 'Hamlet', 1603, 340.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/id/8281954-L.jpg', 4, 0, 0, 0, 0),
(9, 1, 'Pinocho', 1883, 360.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/id/11365679-L.jpg', 4, 0, 0, 0, 1),
(10, 6, 'Mafalda', NULL, NULL, 'Comic', 'Nacional', 'https://covers.openlibrary.org/b/id/12716890-L.jpg', 0, 0, 1, 0, 0);

-- Hasta 27 títulos. Onetti sigue sin libros.
INSERT INTO LIBROS (id_autor, id_categoria, titulo, anio, precio, tipo, origen, imagen, rating, mas_vendido, novedad, recomendado, en_oferta) VALUES
(12, 5, 'Don Quijote de la Mancha', 1605, 450.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/isbn/9780142437230-L.jpg', 5, 0, 0, 1, 0),
(13, 5, 'Orgullo y prejuicio', 1813, 420.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/isbn/9780141439518-L.jpg', 5, 0, 0, 1, 0),
(14, 5, '1984', 1949, 390.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/isbn/9780451524935-L.jpg', 5, 0, 1, 0, 0),
(14, 5, 'Rebelión en la granja', 1945, 310.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/isbn/9780451526342-L.jpg', 4, 0, 0, 0, 1),
(15, 5, 'Cien años de soledad', 1967, 560.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/isbn/9780307474728-L.jpg', 5, 0, 0, 1, 0),
(15, 5, 'El amor en los tiempos del cólera', 1985, 540.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/isbn/9780307389732-L.jpg', 4, 0, 0, 0, 0),
(16, 5, 'Ficciones', 1944, 480.00, 'Libro', 'Nacional', 'https://covers.openlibrary.org/b/isbn/9780802130303-L.jpg', 5, 0, 0, 1, 0),
(17, 5, 'Rayuela', 1963, 510.00, 'Libro', 'Nacional', 'https://covers.openlibrary.org/b/isbn/9788437604572-L.jpg', 4, 0, 0, 0, 0),
(18, 5, 'La tregua', 1960, 370.00, 'Libro', 'Nacional', 'https://covers.openlibrary.org/b/id/7377234-L.jpg', 4, 0, 1, 0, 0),
(19, 1, 'Cuentos de la selva', 1918, 290.00, 'Libro', 'Nacional', 'https://covers.openlibrary.org/b/id/4902905-L.jpg', 4, 0, 0, 0, 0),
(20, 1, 'Matilda', 1988, 340.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/isbn/9780142410370-L.jpg', 5, 0, 0, 0, 1),
(20, 1, 'Charlie y la fábrica de chocolate', 1964, 330.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/isbn/9780142410318-L.jpg', 4, 0, 0, 1, 0),
(21, 2, 'Drácula', 1897, 410.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/isbn/9780141439846-L.jpg', 4, 0, 0, 0, 0),
(22, 2, 'Frankenstein', 1818, 400.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/isbn/9780141439471-L.jpg', 4, 0, 1, 0, 0),
(23, 5, 'El retrato de Dorian Gray', 1890, 360.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/isbn/9780141439570-L.jpg', 4, 0, 0, 0, 0),
(24, 5, 'La casa de los espíritus', 1982, 520.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/isbn/9780525433477-L.jpg', 5, 0, 0, 1, 0);

-- 54 títulos en total: 6 páginas de 9. Onetti sigue sin libros.
INSERT INTO LIBROS (id_autor, id_categoria, titulo, anio, precio, tipo, origen, imagen, rating, mas_vendido, novedad, recomendado, en_oferta) VALUES
(7, 3, 'El hobbit', 1937, 540.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/id/14627509-L.jpg', 5, 0, 0, 1, 0),
(4, 3, 'Harry Potter y la cámara secreta', 1998, 710.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/id/15158664-L.jpg', 5, 0, 1, 0, 0),
(3, 2, 'El resplandor', 1977, 620.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/id/12376585-L.jpg', 4, 0, 0, 0, 1),
(8, 5, 'Romeo y Julieta', 1597, 320.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/id/8257991-L.jpg', 4, 0, 0, 0, 0),
(8, 5, 'Macbeth', 1606, 300.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/id/872432-L.jpg', 4, 0, 0, 0, 0),
(16, 5, 'El Aleph', 1949, 460.00, 'Libro', 'Nacional', 'https://covers.openlibrary.org/b/id/14408958-L.jpg', 5, 0, 0, 1, 0),
(18, 5, 'Gracias por el fuego', 1965, 390.00, 'Libro', 'Nacional', 'https://covers.openlibrary.org/b/id/7993875-L.jpg', 4, 0, 0, 0, 0),
(15, 5, 'El coronel no tiene quien le escriba', 1961, 350.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/id/10096705-L.jpg', 4, 0, 0, 0, 0),
(24, 5, 'De amor y de sombra', 1984, 490.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/id/4176665-L.jpg', 4, 0, 0, 0, 0),
(20, 1, 'Las brujas', 1983, 320.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/id/12374442-L.jpg', 4, 0, 0, 0, 1),
(25, 5, 'Asesinato en el Orient Express', 1934, 430.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/id/11100465-L.jpg', 5, 0, 0, 1, 0),
(25, 5, 'Diez negritos', 1939, 410.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/id/11172296-L.jpg', 4, 0, 1, 0, 0),
(26, 5, 'Estudio en escarlata', 1887, 380.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/id/13405534-L.jpg', 4, 0, 0, 0, 0),
(27, 5, 'Veinte mil leguas de viaje submarino', 1870, 440.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/id/6573517-L.jpg', 4, 0, 0, 1, 0),
(27, 5, 'La vuelta al mundo en 80 días', 1873, 360.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/id/11531296-L.jpg', 4, 0, 0, 0, 0),
(28, 1, 'Las aventuras de Tom Sawyer', 1876, 340.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/id/12043351-L.jpg', 4, 0, 0, 0, 0),
(29, 5, 'La metamorfosis', 1915, 280.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/id/6889547-L.jpg', 4, 0, 0, 0, 0),
(30, 5, 'Crimen y castigo', 1866, 520.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/id/13116014-L.jpg', 5, 0, 0, 1, 0),
(31, 5, 'Oliver Twist', 1838, 370.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/id/13300802-L.jpg', 4, 0, 0, 0, 0),
(32, 2, 'Narraciones extraordinarias', 1845, 330.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/id/11851436-L.jpg', 4, 0, 0, 0, 0),
(33, 3, 'La guerra de los mundos', 1898, 390.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/id/36314-L.jpg', 4, 0, 1, 0, 0),
(34, 5, 'Las venas abiertas de América Latina', 1971, 480.00, 'Libro', 'Nacional', 'https://covers.openlibrary.org/b/id/5416334-L.jpg', 4, 0, 0, 0, 0),
(35, 5, 'Como agua para chocolate', 1989, 420.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/id/8372632-L.jpg', 4, 0, 0, 1, 0),
(36, 1, 'Momo', 1973, 360.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/id/8574580-L.jpg', 5, 0, 0, 0, 0),
(37, 1, 'El libro de la selva', 1894, 310.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/id/3344204-L.jpg', 4, 0, 0, 0, 1),
(38, 1, 'Peter Pan', 1911, 300.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/id/8237052-L.jpg', 4, 0, 0, 0, 0),
(39, 3, 'Las crónicas de Narnia', 1950, 560.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/id/8441376-L.jpg', 5, 0, 1, 0, 0);

-- Ana López y Pedro Gómez no tienen teléfono.
INSERT INTO CLIENTES (nombre_completo, email, telefono) VALUES
('Martín Silva', 'martin.silva@email.com', '099123456'),
('Ana López', 'ana.lopez@email.com', NULL),
('Carlos Rodríguez', 'carlos.r@email.com', '098765432'),
('Laura Martínez', 'laura.m@email.com', '091555666'),
('Pedro Gómez', 'pedro.gomez@email.com', NULL);

-- Carlos (3) y Pedro (5) no compran: quedan clientes sin pedidos.
INSERT INTO PEDIDOS (id_cliente, fecha_pedido, monto_total) VALUES
(1, '2024-03-12', 740.00), -- Martín: Principito + Pinocho
(4, '2024-05-02', 650.00); -- Laura: It, con descuento sobre el precio de lista

-- Un pedido con dos libros y otro con uno. It se cobró a 650, no a 690.
INSERT INTO DETALLE_PEDIDO (id_pedido, id_libro, cantidad, precio_unitario) VALUES
(1, 2, 1, 380.00),
(1, 10, 1, 360.00),
(2, 3, 1, 650.00);

-- Cuentas del práctico 2. Las claves en claro son Admin123 y Usuario123.
-- En la tabla solo queda el hash de password_hash().
INSERT INTO ROLES (nombre) VALUES
('Administrador'),
('Usuario');

INSERT INTO USUARIOS (id_rol, nombre_completo, email, clave_hash) VALUES
(1, 'Sofía Acosta', 'admin@booke.com', '$2y$10$YdUYJ5GbasE5zbICpwjbpevktk5wps/MPqDON3mQJkaRpRq6necE.'),
(2, 'Martín Silva', 'usuario@booke.com', '$2y$10$NF/nI.YFRDbStDr8.CdRweI8zGCdMoqfK1U6VcNevb/vXdzo4hc7m');
