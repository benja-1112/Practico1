-- Suma autores y títulos para llegar a 27 libros (3 páginas de 9).
-- No toca los 11 títulos del práctico 1 ni a Onetti, que sigue sin libros.

INSERT INTO AUTORES (nombre, nacionalidad)
SELECT 'Miguel de Cervantes', 'España' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM AUTORES WHERE nombre = 'Miguel de Cervantes');
INSERT INTO AUTORES (nombre, nacionalidad)
SELECT 'Jane Austen', 'Reino Unido' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM AUTORES WHERE nombre = 'Jane Austen');
INSERT INTO AUTORES (nombre, nacionalidad)
SELECT 'George Orwell', 'Reino Unido' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM AUTORES WHERE nombre = 'George Orwell');
INSERT INTO AUTORES (nombre, nacionalidad)
SELECT 'Gabriel García Márquez', 'Colombia' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM AUTORES WHERE nombre = 'Gabriel García Márquez');
INSERT INTO AUTORES (nombre, nacionalidad)
SELECT 'Jorge Luis Borges', 'Argentina' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM AUTORES WHERE nombre = 'Jorge Luis Borges');
INSERT INTO AUTORES (nombre, nacionalidad)
SELECT 'Julio Cortázar', 'Argentina' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM AUTORES WHERE nombre = 'Julio Cortázar');
INSERT INTO AUTORES (nombre, nacionalidad)
SELECT 'Mario Benedetti', 'Uruguay' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM AUTORES WHERE nombre = 'Mario Benedetti');
INSERT INTO AUTORES (nombre, nacionalidad)
SELECT 'Horacio Quiroga', 'Uruguay' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM AUTORES WHERE nombre = 'Horacio Quiroga');
INSERT INTO AUTORES (nombre, nacionalidad)
SELECT 'Roald Dahl', 'Reino Unido' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM AUTORES WHERE nombre = 'Roald Dahl');
INSERT INTO AUTORES (nombre, nacionalidad)
SELECT 'Bram Stoker', 'Irlanda' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM AUTORES WHERE nombre = 'Bram Stoker');
INSERT INTO AUTORES (nombre, nacionalidad)
SELECT 'Mary Shelley', 'Reino Unido' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM AUTORES WHERE nombre = 'Mary Shelley');
INSERT INTO AUTORES (nombre, nacionalidad)
SELECT 'Oscar Wilde', 'Irlanda' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM AUTORES WHERE nombre = 'Oscar Wilde');
INSERT INTO AUTORES (nombre, nacionalidad)
SELECT 'Isabel Allende', 'Chile' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM AUTORES WHERE nombre = 'Isabel Allende');

INSERT INTO LIBROS (id_autor, id_categoria, titulo, anio, precio, tipo, origen, imagen, rating, mas_vendido, novedad, recomendado, en_oferta)
SELECT a.id_autor, c.id_categoria, 'Don Quijote de la Mancha', 1605, 450.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/isbn/9780142437230-L.jpg', 5, 0, 0, 1, 0
FROM AUTORES a JOIN CATEGORIAS c ON c.nombre = 'Clásico'
WHERE a.nombre = 'Miguel de Cervantes' AND NOT EXISTS (SELECT 1 FROM LIBROS WHERE titulo = 'Don Quijote de la Mancha');

INSERT INTO LIBROS (id_autor, id_categoria, titulo, anio, precio, tipo, origen, imagen, rating, mas_vendido, novedad, recomendado, en_oferta)
SELECT a.id_autor, c.id_categoria, 'Orgullo y prejuicio', 1813, 420.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/isbn/9780141439518-L.jpg', 5, 0, 0, 1, 0
FROM AUTORES a JOIN CATEGORIAS c ON c.nombre = 'Clásico'
WHERE a.nombre = 'Jane Austen' AND NOT EXISTS (SELECT 1 FROM LIBROS WHERE titulo = 'Orgullo y prejuicio');

INSERT INTO LIBROS (id_autor, id_categoria, titulo, anio, precio, tipo, origen, imagen, rating, mas_vendido, novedad, recomendado, en_oferta)
SELECT a.id_autor, c.id_categoria, '1984', 1949, 390.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/isbn/9780451524935-L.jpg', 5, 0, 1, 0, 0
FROM AUTORES a JOIN CATEGORIAS c ON c.nombre = 'Clásico'
WHERE a.nombre = 'George Orwell' AND NOT EXISTS (SELECT 1 FROM LIBROS WHERE titulo = '1984');

INSERT INTO LIBROS (id_autor, id_categoria, titulo, anio, precio, tipo, origen, imagen, rating, mas_vendido, novedad, recomendado, en_oferta)
SELECT a.id_autor, c.id_categoria, 'Rebelión en la granja', 1945, 310.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/isbn/9780451526342-L.jpg', 4, 0, 0, 0, 1
FROM AUTORES a JOIN CATEGORIAS c ON c.nombre = 'Clásico'
WHERE a.nombre = 'George Orwell' AND NOT EXISTS (SELECT 1 FROM LIBROS WHERE titulo = 'Rebelión en la granja');

INSERT INTO LIBROS (id_autor, id_categoria, titulo, anio, precio, tipo, origen, imagen, rating, mas_vendido, novedad, recomendado, en_oferta)
SELECT a.id_autor, c.id_categoria, 'Cien años de soledad', 1967, 560.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/isbn/9780307474728-L.jpg', 5, 0, 0, 1, 0
FROM AUTORES a JOIN CATEGORIAS c ON c.nombre = 'Clásico'
WHERE a.nombre = 'Gabriel García Márquez' AND NOT EXISTS (SELECT 1 FROM LIBROS WHERE titulo = 'Cien años de soledad');

INSERT INTO LIBROS (id_autor, id_categoria, titulo, anio, precio, tipo, origen, imagen, rating, mas_vendido, novedad, recomendado, en_oferta)
SELECT a.id_autor, c.id_categoria, 'El amor en los tiempos del cólera', 1985, 540.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/isbn/9780307389732-L.jpg', 4, 0, 0, 0, 0
FROM AUTORES a JOIN CATEGORIAS c ON c.nombre = 'Clásico'
WHERE a.nombre = 'Gabriel García Márquez' AND NOT EXISTS (SELECT 1 FROM LIBROS WHERE titulo = 'El amor en los tiempos del cólera');

INSERT INTO LIBROS (id_autor, id_categoria, titulo, anio, precio, tipo, origen, imagen, rating, mas_vendido, novedad, recomendado, en_oferta)
SELECT a.id_autor, c.id_categoria, 'Ficciones', 1944, 480.00, 'Libro', 'Nacional', 'https://covers.openlibrary.org/b/isbn/9780802130303-L.jpg', 5, 0, 0, 1, 0
FROM AUTORES a JOIN CATEGORIAS c ON c.nombre = 'Clásico'
WHERE a.nombre = 'Jorge Luis Borges' AND NOT EXISTS (SELECT 1 FROM LIBROS WHERE titulo = 'Ficciones');

INSERT INTO LIBROS (id_autor, id_categoria, titulo, anio, precio, tipo, origen, imagen, rating, mas_vendido, novedad, recomendado, en_oferta)
SELECT a.id_autor, c.id_categoria, 'Rayuela', 1963, 510.00, 'Libro', 'Nacional', 'https://covers.openlibrary.org/b/isbn/9788437604572-L.jpg', 4, 0, 0, 0, 0
FROM AUTORES a JOIN CATEGORIAS c ON c.nombre = 'Clásico'
WHERE a.nombre = 'Julio Cortázar' AND NOT EXISTS (SELECT 1 FROM LIBROS WHERE titulo = 'Rayuela');

INSERT INTO LIBROS (id_autor, id_categoria, titulo, anio, precio, tipo, origen, imagen, rating, mas_vendido, novedad, recomendado, en_oferta)
SELECT a.id_autor, c.id_categoria, 'La tregua', 1960, 370.00, 'Libro', 'Nacional', 'https://covers.openlibrary.org/b/id/7377234-L.jpg', 4, 0, 1, 0, 0
FROM AUTORES a JOIN CATEGORIAS c ON c.nombre = 'Clásico'
WHERE a.nombre = 'Mario Benedetti' AND NOT EXISTS (SELECT 1 FROM LIBROS WHERE titulo = 'La tregua');

INSERT INTO LIBROS (id_autor, id_categoria, titulo, anio, precio, tipo, origen, imagen, rating, mas_vendido, novedad, recomendado, en_oferta)
SELECT a.id_autor, c.id_categoria, 'Cuentos de la selva', 1918, 290.00, 'Libro', 'Nacional', 'https://covers.openlibrary.org/b/id/4902905-L.jpg', 4, 0, 0, 0, 0
FROM AUTORES a JOIN CATEGORIAS c ON c.nombre = 'Infantil'
WHERE a.nombre = 'Horacio Quiroga' AND NOT EXISTS (SELECT 1 FROM LIBROS WHERE titulo = 'Cuentos de la selva');

INSERT INTO LIBROS (id_autor, id_categoria, titulo, anio, precio, tipo, origen, imagen, rating, mas_vendido, novedad, recomendado, en_oferta)
SELECT a.id_autor, c.id_categoria, 'Matilda', 1988, 340.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/isbn/9780142410370-L.jpg', 5, 0, 0, 0, 1
FROM AUTORES a JOIN CATEGORIAS c ON c.nombre = 'Infantil'
WHERE a.nombre = 'Roald Dahl' AND NOT EXISTS (SELECT 1 FROM LIBROS WHERE titulo = 'Matilda');

INSERT INTO LIBROS (id_autor, id_categoria, titulo, anio, precio, tipo, origen, imagen, rating, mas_vendido, novedad, recomendado, en_oferta)
SELECT a.id_autor, c.id_categoria, 'Charlie y la fábrica de chocolate', 1964, 330.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/isbn/9780142410318-L.jpg', 4, 0, 0, 1, 0
FROM AUTORES a JOIN CATEGORIAS c ON c.nombre = 'Infantil'
WHERE a.nombre = 'Roald Dahl' AND NOT EXISTS (SELECT 1 FROM LIBROS WHERE titulo = 'Charlie y la fábrica de chocolate');

INSERT INTO LIBROS (id_autor, id_categoria, titulo, anio, precio, tipo, origen, imagen, rating, mas_vendido, novedad, recomendado, en_oferta)
SELECT a.id_autor, c.id_categoria, 'Drácula', 1897, 410.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/isbn/9780141439846-L.jpg', 4, 0, 0, 0, 0
FROM AUTORES a JOIN CATEGORIAS c ON c.nombre = 'Terror'
WHERE a.nombre = 'Bram Stoker' AND NOT EXISTS (SELECT 1 FROM LIBROS WHERE titulo = 'Drácula');

INSERT INTO LIBROS (id_autor, id_categoria, titulo, anio, precio, tipo, origen, imagen, rating, mas_vendido, novedad, recomendado, en_oferta)
SELECT a.id_autor, c.id_categoria, 'Frankenstein', 1818, 400.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/isbn/9780141439471-L.jpg', 4, 0, 1, 0, 0
FROM AUTORES a JOIN CATEGORIAS c ON c.nombre = 'Terror'
WHERE a.nombre = 'Mary Shelley' AND NOT EXISTS (SELECT 1 FROM LIBROS WHERE titulo = 'Frankenstein');

INSERT INTO LIBROS (id_autor, id_categoria, titulo, anio, precio, tipo, origen, imagen, rating, mas_vendido, novedad, recomendado, en_oferta)
SELECT a.id_autor, c.id_categoria, 'El retrato de Dorian Gray', 1890, 360.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/isbn/9780141439570-L.jpg', 4, 0, 0, 0, 0
FROM AUTORES a JOIN CATEGORIAS c ON c.nombre = 'Clásico'
WHERE a.nombre = 'Oscar Wilde' AND NOT EXISTS (SELECT 1 FROM LIBROS WHERE titulo = 'El retrato de Dorian Gray');

INSERT INTO LIBROS (id_autor, id_categoria, titulo, anio, precio, tipo, origen, imagen, rating, mas_vendido, novedad, recomendado, en_oferta)
SELECT a.id_autor, c.id_categoria, 'La casa de los espíritus', 1982, 520.00, 'Libro', 'Extranjero', 'https://covers.openlibrary.org/b/isbn/9780525433477-L.jpg', 5, 0, 0, 1, 0
FROM AUTORES a JOIN CATEGORIAS c ON c.nombre = 'Clásico'
WHERE a.nombre = 'Isabel Allende' AND NOT EXISTS (SELECT 1 FROM LIBROS WHERE titulo = 'La casa de los espíritus');
