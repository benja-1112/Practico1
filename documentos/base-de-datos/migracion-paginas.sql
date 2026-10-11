-- Suma autores y títulos para llegar a 54 libros: 6 páginas de 9.
-- No toca los títulos ya cargados. Onetti sigue sin libros.

INSERT INTO AUTORES (nombre, nacionalidad)
SELECT 'Agatha Christie', 'Reino Unido' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM AUTORES WHERE nombre = 'Agatha Christie');
INSERT INTO AUTORES (nombre, nacionalidad)
SELECT 'Arthur Conan Doyle', 'Reino Unido' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM AUTORES WHERE nombre = 'Arthur Conan Doyle');
INSERT INTO AUTORES (nombre, nacionalidad)
SELECT 'Julio Verne', 'Francia' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM AUTORES WHERE nombre = 'Julio Verne');
INSERT INTO AUTORES (nombre, nacionalidad)
SELECT 'Mark Twain', 'Estados Unidos' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM AUTORES WHERE nombre = 'Mark Twain');
INSERT INTO AUTORES (nombre, nacionalidad)
SELECT 'Franz Kafka', 'Chequia' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM AUTORES WHERE nombre = 'Franz Kafka');
INSERT INTO AUTORES (nombre, nacionalidad)
SELECT 'Fiódor Dostoievski', 'Rusia' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM AUTORES WHERE nombre = 'Fiódor Dostoievski');
INSERT INTO AUTORES (nombre, nacionalidad)
SELECT 'Charles Dickens', 'Reino Unido' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM AUTORES WHERE nombre = 'Charles Dickens');
INSERT INTO AUTORES (nombre, nacionalidad)
SELECT 'Edgar Allan Poe', 'Estados Unidos' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM AUTORES WHERE nombre = 'Edgar Allan Poe');
INSERT INTO AUTORES (nombre, nacionalidad)
SELECT 'H. G. Wells', 'Reino Unido' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM AUTORES WHERE nombre = 'H. G. Wells');
INSERT INTO AUTORES (nombre, nacionalidad)
SELECT 'Eduardo Galeano', 'Uruguay' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM AUTORES WHERE nombre = 'Eduardo Galeano');
INSERT INTO AUTORES (nombre, nacionalidad)
SELECT 'Laura Esquivel', 'México' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM AUTORES WHERE nombre = 'Laura Esquivel');
INSERT INTO AUTORES (nombre, nacionalidad)
SELECT 'Michael Ende', 'Alemania' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM AUTORES WHERE nombre = 'Michael Ende');
INSERT INTO AUTORES (nombre, nacionalidad)
SELECT 'Rudyard Kipling', 'Reino Unido' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM AUTORES WHERE nombre = 'Rudyard Kipling');
INSERT INTO AUTORES (nombre, nacionalidad)
SELECT 'J. M. Barrie', 'Reino Unido' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM AUTORES WHERE nombre = 'J. M. Barrie');
INSERT INTO AUTORES (nombre, nacionalidad)
SELECT 'C. S. Lewis', 'Reino Unido' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM AUTORES WHERE nombre = 'C. S. Lewis');

INSERT INTO LIBROS (id_autor, id_categoria, titulo, anio, precio, tipo, origen, imagen, rating, mas_vendido, novedad, recomendado, en_oferta)
SELECT a.id_autor, c.id_categoria, 'El hobbit', 1937, 540.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/id/14627509-L.jpg', 5, 0, 0, 1, 0
FROM AUTORES a JOIN CATEGORIAS c ON c.nombre = 'Fantasía'
WHERE a.nombre = 'J.R.R. Tolkien' AND NOT EXISTS (SELECT 1 FROM LIBROS WHERE titulo = 'El hobbit');

INSERT INTO LIBROS (id_autor, id_categoria, titulo, anio, precio, tipo, origen, imagen, rating, mas_vendido, novedad, recomendado, en_oferta)
SELECT a.id_autor, c.id_categoria, 'Harry Potter y la cámara secreta', 1998, 710.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/id/15158664-L.jpg', 5, 0, 1, 0, 0
FROM AUTORES a JOIN CATEGORIAS c ON c.nombre = 'Fantasía'
WHERE a.nombre = 'J.K. Rowling' AND NOT EXISTS (SELECT 1 FROM LIBROS WHERE titulo = 'Harry Potter y la cámara secreta');

INSERT INTO LIBROS (id_autor, id_categoria, titulo, anio, precio, tipo, origen, imagen, rating, mas_vendido, novedad, recomendado, en_oferta)
SELECT a.id_autor, c.id_categoria, 'El resplandor', 1977, 620.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/id/12376585-L.jpg', 4, 0, 0, 0, 1
FROM AUTORES a JOIN CATEGORIAS c ON c.nombre = 'Terror'
WHERE a.nombre = 'Stephen King' AND NOT EXISTS (SELECT 1 FROM LIBROS WHERE titulo = 'El resplandor');

INSERT INTO LIBROS (id_autor, id_categoria, titulo, anio, precio, tipo, origen, imagen, rating, mas_vendido, novedad, recomendado, en_oferta)
SELECT a.id_autor, c.id_categoria, 'Romeo y Julieta', 1597, 320.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/id/8257991-L.jpg', 4, 0, 0, 0, 0
FROM AUTORES a JOIN CATEGORIAS c ON c.nombre = 'Clásico'
WHERE a.nombre = 'William Shakespeare' AND NOT EXISTS (SELECT 1 FROM LIBROS WHERE titulo = 'Romeo y Julieta');

INSERT INTO LIBROS (id_autor, id_categoria, titulo, anio, precio, tipo, origen, imagen, rating, mas_vendido, novedad, recomendado, en_oferta)
SELECT a.id_autor, c.id_categoria, 'Macbeth', 1606, 300.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/id/872432-L.jpg', 4, 0, 0, 0, 0
FROM AUTORES a JOIN CATEGORIAS c ON c.nombre = 'Clásico'
WHERE a.nombre = 'William Shakespeare' AND NOT EXISTS (SELECT 1 FROM LIBROS WHERE titulo = 'Macbeth');

INSERT INTO LIBROS (id_autor, id_categoria, titulo, anio, precio, tipo, origen, imagen, rating, mas_vendido, novedad, recomendado, en_oferta)
SELECT a.id_autor, c.id_categoria, 'El Aleph', 1949, 460.00, 'Libro', 'Nacional', 'https://covers.openlibrary.org/b/id/14408958-L.jpg', 5, 0, 0, 1, 0
FROM AUTORES a JOIN CATEGORIAS c ON c.nombre = 'Clásico'
WHERE a.nombre = 'Jorge Luis Borges' AND NOT EXISTS (SELECT 1 FROM LIBROS WHERE titulo = 'El Aleph');

INSERT INTO LIBROS (id_autor, id_categoria, titulo, anio, precio, tipo, origen, imagen, rating, mas_vendido, novedad, recomendado, en_oferta)
SELECT a.id_autor, c.id_categoria, 'Gracias por el fuego', 1965, 390.00, 'Libro', 'Nacional', 'https://covers.openlibrary.org/b/id/7993875-L.jpg', 4, 0, 0, 0, 0
FROM AUTORES a JOIN CATEGORIAS c ON c.nombre = 'Clásico'
WHERE a.nombre = 'Mario Benedetti' AND NOT EXISTS (SELECT 1 FROM LIBROS WHERE titulo = 'Gracias por el fuego');

INSERT INTO LIBROS (id_autor, id_categoria, titulo, anio, precio, tipo, origen, imagen, rating, mas_vendido, novedad, recomendado, en_oferta)
SELECT a.id_autor, c.id_categoria, 'El coronel no tiene quien le escriba', 1961, 350.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/id/10096705-L.jpg', 4, 0, 0, 0, 0
FROM AUTORES a JOIN CATEGORIAS c ON c.nombre = 'Clásico'
WHERE a.nombre = 'Gabriel García Márquez' AND NOT EXISTS (SELECT 1 FROM LIBROS WHERE titulo = 'El coronel no tiene quien le escriba');

INSERT INTO LIBROS (id_autor, id_categoria, titulo, anio, precio, tipo, origen, imagen, rating, mas_vendido, novedad, recomendado, en_oferta)
SELECT a.id_autor, c.id_categoria, 'De amor y de sombra', 1984, 490.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/id/4176665-L.jpg', 4, 0, 0, 0, 0
FROM AUTORES a JOIN CATEGORIAS c ON c.nombre = 'Clásico'
WHERE a.nombre = 'Isabel Allende' AND NOT EXISTS (SELECT 1 FROM LIBROS WHERE titulo = 'De amor y de sombra');

INSERT INTO LIBROS (id_autor, id_categoria, titulo, anio, precio, tipo, origen, imagen, rating, mas_vendido, novedad, recomendado, en_oferta)
SELECT a.id_autor, c.id_categoria, 'Las brujas', 1983, 320.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/id/12374442-L.jpg', 4, 0, 0, 0, 1
FROM AUTORES a JOIN CATEGORIAS c ON c.nombre = 'Infantil'
WHERE a.nombre = 'Roald Dahl' AND NOT EXISTS (SELECT 1 FROM LIBROS WHERE titulo = 'Las brujas');

INSERT INTO LIBROS (id_autor, id_categoria, titulo, anio, precio, tipo, origen, imagen, rating, mas_vendido, novedad, recomendado, en_oferta)
SELECT a.id_autor, c.id_categoria, 'Asesinato en el Orient Express', 1934, 430.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/id/11100465-L.jpg', 5, 0, 0, 1, 0
FROM AUTORES a JOIN CATEGORIAS c ON c.nombre = 'Clásico'
WHERE a.nombre = 'Agatha Christie' AND NOT EXISTS (SELECT 1 FROM LIBROS WHERE titulo = 'Asesinato en el Orient Express');

INSERT INTO LIBROS (id_autor, id_categoria, titulo, anio, precio, tipo, origen, imagen, rating, mas_vendido, novedad, recomendado, en_oferta)
SELECT a.id_autor, c.id_categoria, 'Diez negritos', 1939, 410.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/id/11172296-L.jpg', 4, 0, 1, 0, 0
FROM AUTORES a JOIN CATEGORIAS c ON c.nombre = 'Clásico'
WHERE a.nombre = 'Agatha Christie' AND NOT EXISTS (SELECT 1 FROM LIBROS WHERE titulo = 'Diez negritos');

INSERT INTO LIBROS (id_autor, id_categoria, titulo, anio, precio, tipo, origen, imagen, rating, mas_vendido, novedad, recomendado, en_oferta)
SELECT a.id_autor, c.id_categoria, 'Estudio en escarlata', 1887, 380.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/id/13405534-L.jpg', 4, 0, 0, 0, 0
FROM AUTORES a JOIN CATEGORIAS c ON c.nombre = 'Clásico'
WHERE a.nombre = 'Arthur Conan Doyle' AND NOT EXISTS (SELECT 1 FROM LIBROS WHERE titulo = 'Estudio en escarlata');

INSERT INTO LIBROS (id_autor, id_categoria, titulo, anio, precio, tipo, origen, imagen, rating, mas_vendido, novedad, recomendado, en_oferta)
SELECT a.id_autor, c.id_categoria, 'Veinte mil leguas de viaje submarino', 1870, 440.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/id/6573517-L.jpg', 4, 0, 0, 1, 0
FROM AUTORES a JOIN CATEGORIAS c ON c.nombre = 'Clásico'
WHERE a.nombre = 'Julio Verne' AND NOT EXISTS (SELECT 1 FROM LIBROS WHERE titulo = 'Veinte mil leguas de viaje submarino');

INSERT INTO LIBROS (id_autor, id_categoria, titulo, anio, precio, tipo, origen, imagen, rating, mas_vendido, novedad, recomendado, en_oferta)
SELECT a.id_autor, c.id_categoria, 'La vuelta al mundo en 80 días', 1873, 360.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/id/11531296-L.jpg', 4, 0, 0, 0, 0
FROM AUTORES a JOIN CATEGORIAS c ON c.nombre = 'Clásico'
WHERE a.nombre = 'Julio Verne' AND NOT EXISTS (SELECT 1 FROM LIBROS WHERE titulo = 'La vuelta al mundo en 80 días');

INSERT INTO LIBROS (id_autor, id_categoria, titulo, anio, precio, tipo, origen, imagen, rating, mas_vendido, novedad, recomendado, en_oferta)
SELECT a.id_autor, c.id_categoria, 'Las aventuras de Tom Sawyer', 1876, 340.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/id/12043351-L.jpg', 4, 0, 0, 0, 0
FROM AUTORES a JOIN CATEGORIAS c ON c.nombre = 'Infantil'
WHERE a.nombre = 'Mark Twain' AND NOT EXISTS (SELECT 1 FROM LIBROS WHERE titulo = 'Las aventuras de Tom Sawyer');

INSERT INTO LIBROS (id_autor, id_categoria, titulo, anio, precio, tipo, origen, imagen, rating, mas_vendido, novedad, recomendado, en_oferta)
SELECT a.id_autor, c.id_categoria, 'La metamorfosis', 1915, 280.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/id/6889547-L.jpg', 4, 0, 0, 0, 0
FROM AUTORES a JOIN CATEGORIAS c ON c.nombre = 'Clásico'
WHERE a.nombre = 'Franz Kafka' AND NOT EXISTS (SELECT 1 FROM LIBROS WHERE titulo = 'La metamorfosis');

INSERT INTO LIBROS (id_autor, id_categoria, titulo, anio, precio, tipo, origen, imagen, rating, mas_vendido, novedad, recomendado, en_oferta)
SELECT a.id_autor, c.id_categoria, 'Crimen y castigo', 1866, 520.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/id/13116014-L.jpg', 5, 0, 0, 1, 0
FROM AUTORES a JOIN CATEGORIAS c ON c.nombre = 'Clásico'
WHERE a.nombre = 'Fiódor Dostoievski' AND NOT EXISTS (SELECT 1 FROM LIBROS WHERE titulo = 'Crimen y castigo');

INSERT INTO LIBROS (id_autor, id_categoria, titulo, anio, precio, tipo, origen, imagen, rating, mas_vendido, novedad, recomendado, en_oferta)
SELECT a.id_autor, c.id_categoria, 'Oliver Twist', 1838, 370.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/id/13300802-L.jpg', 4, 0, 0, 0, 0
FROM AUTORES a JOIN CATEGORIAS c ON c.nombre = 'Clásico'
WHERE a.nombre = 'Charles Dickens' AND NOT EXISTS (SELECT 1 FROM LIBROS WHERE titulo = 'Oliver Twist');

INSERT INTO LIBROS (id_autor, id_categoria, titulo, anio, precio, tipo, origen, imagen, rating, mas_vendido, novedad, recomendado, en_oferta)
SELECT a.id_autor, c.id_categoria, 'Narraciones extraordinarias', 1845, 330.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/id/11851436-L.jpg', 4, 0, 0, 0, 0
FROM AUTORES a JOIN CATEGORIAS c ON c.nombre = 'Terror'
WHERE a.nombre = 'Edgar Allan Poe' AND NOT EXISTS (SELECT 1 FROM LIBROS WHERE titulo = 'Narraciones extraordinarias');

INSERT INTO LIBROS (id_autor, id_categoria, titulo, anio, precio, tipo, origen, imagen, rating, mas_vendido, novedad, recomendado, en_oferta)
SELECT a.id_autor, c.id_categoria, 'La guerra de los mundos', 1898, 390.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/id/36314-L.jpg', 4, 0, 1, 0, 0
FROM AUTORES a JOIN CATEGORIAS c ON c.nombre = 'Fantasía'
WHERE a.nombre = 'H. G. Wells' AND NOT EXISTS (SELECT 1 FROM LIBROS WHERE titulo = 'La guerra de los mundos');

INSERT INTO LIBROS (id_autor, id_categoria, titulo, anio, precio, tipo, origen, imagen, rating, mas_vendido, novedad, recomendado, en_oferta)
SELECT a.id_autor, c.id_categoria, 'Las venas abiertas de América Latina', 1971, 480.00, 'Libro', 'Nacional', 'https://covers.openlibrary.org/b/id/5416334-L.jpg', 4, 0, 0, 0, 0
FROM AUTORES a JOIN CATEGORIAS c ON c.nombre = 'Clásico'
WHERE a.nombre = 'Eduardo Galeano' AND NOT EXISTS (SELECT 1 FROM LIBROS WHERE titulo = 'Las venas abiertas de América Latina');

INSERT INTO LIBROS (id_autor, id_categoria, titulo, anio, precio, tipo, origen, imagen, rating, mas_vendido, novedad, recomendado, en_oferta)
SELECT a.id_autor, c.id_categoria, 'Como agua para chocolate', 1989, 420.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/id/8372632-L.jpg', 4, 0, 0, 1, 0
FROM AUTORES a JOIN CATEGORIAS c ON c.nombre = 'Clásico'
WHERE a.nombre = 'Laura Esquivel' AND NOT EXISTS (SELECT 1 FROM LIBROS WHERE titulo = 'Como agua para chocolate');

INSERT INTO LIBROS (id_autor, id_categoria, titulo, anio, precio, tipo, origen, imagen, rating, mas_vendido, novedad, recomendado, en_oferta)
SELECT a.id_autor, c.id_categoria, 'Momo', 1973, 360.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/id/8574580-L.jpg', 5, 0, 0, 0, 0
FROM AUTORES a JOIN CATEGORIAS c ON c.nombre = 'Infantil'
WHERE a.nombre = 'Michael Ende' AND NOT EXISTS (SELECT 1 FROM LIBROS WHERE titulo = 'Momo');

INSERT INTO LIBROS (id_autor, id_categoria, titulo, anio, precio, tipo, origen, imagen, rating, mas_vendido, novedad, recomendado, en_oferta)
SELECT a.id_autor, c.id_categoria, 'El libro de la selva', 1894, 310.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/id/3344204-L.jpg', 4, 0, 0, 0, 1
FROM AUTORES a JOIN CATEGORIAS c ON c.nombre = 'Infantil'
WHERE a.nombre = 'Rudyard Kipling' AND NOT EXISTS (SELECT 1 FROM LIBROS WHERE titulo = 'El libro de la selva');

INSERT INTO LIBROS (id_autor, id_categoria, titulo, anio, precio, tipo, origen, imagen, rating, mas_vendido, novedad, recomendado, en_oferta)
SELECT a.id_autor, c.id_categoria, 'Peter Pan', 1911, 300.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/id/8237052-L.jpg', 4, 0, 0, 0, 0
FROM AUTORES a JOIN CATEGORIAS c ON c.nombre = 'Infantil'
WHERE a.nombre = 'J. M. Barrie' AND NOT EXISTS (SELECT 1 FROM LIBROS WHERE titulo = 'Peter Pan');

INSERT INTO LIBROS (id_autor, id_categoria, titulo, anio, precio, tipo, origen, imagen, rating, mas_vendido, novedad, recomendado, en_oferta)
SELECT a.id_autor, c.id_categoria, 'Las crónicas de Narnia', 1950, 560.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/id/8441376-L.jpg', 5, 0, 1, 0, 0
FROM AUTORES a JOIN CATEGORIAS c ON c.nombre = 'Fantasía'
WHERE a.nombre = 'C. S. Lewis' AND NOT EXISTS (SELECT 1 FROM LIBROS WHERE titulo = 'Las crónicas de Narnia');
