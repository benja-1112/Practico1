# Base de datos de Book-e

MySQL 8. El script que crea y llena las tablas está en [esquema.sql](esquema.sql). Docker usa la misma copia en `api/config/init.sql` y la corre una sola vez, cuando el volumen de datos todavía no existe.

Hay ocho tablas. Tres describen el catálogo (autores, categorías y libros), tres describen la venta (clientes, pedidos y el detalle de cada pedido) y dos describen quién puede entrar (roles y usuarios).

Book-e vende títulos. Un mismo libro puede entrar en muchos pedidos, y un pedido puede llevar varios libros. Por eso existe `DETALLE_PEDIDO`. No es un préstamo de biblioteca: no hay fecha de devolución ni ejemplar único.

## ROLES

Cada fila es un permiso de entrada. Hoy hay dos: `Administrador` y `Usuario`. El login no compara un texto suelto en `USUARIOS`: lee el nombre del rol por la clave foránea.

## USUARIOS

Cada fila es una cuenta. `email` no se repite. `clave_hash` no es la clave que la persona escribe: es el hash que arma PHP con `password_hash()`. En el script de práctica entran Sofía Acosta (`admin@booke.com`, clave `Admin123`, rol Administrador) y Martín Silva (`usuario@booke.com`, clave `Usuario123`, rol Usuario).

Esta tabla no reemplaza a `CLIENTES`. Sofía no tiene pedidos. Martín Silva cliente y Martín Silva usuario coinciden en el nombre, pero son filas de tablas distintas.

## AUTORES

Cada fila es quien escribió el libro. `nacionalidad` puede quedar vacía.

Juan Carlos Onetti está cargado y no tiene ningún libro. Un `LEFT JOIN` desde `AUTORES` lo muestra igual, con los datos del libro en `NULL`. Quino tiene `nacionalidad` en `NULL` y sí tiene un libro (Mafalda).

## CATEGORIAS

El género del título: Infantil, Terror, Fantasía, Biografía, Clásico, Cómic. No confundir con el lateral de la landing. "Sale", "Novedades", "Más vendidos", "Recomendados", "Nacional" y "Extranjero" no son categorías: son columnas de `LIBROS`.

## LIBROS

Cada fila es un título a la venta. Pertenece a un autor (`id_autor`) y a una categoría (`id_categoria`).

| Columna | Para qué está |
| --- | --- |
| `titulo` | El nombre que se ve en la card |
| `anio` | Año de publicación. Puede ser `NULL` (Mafalda) |
| `precio` | Precio de lista. Puede ser `NULL` (Mafalda). La landing no lo imprime en la card; lo usa el orden "Más barato" |
| `tipo` | `Libro` o `Comic`. Es el filtro "Libros" / "Comics" del lateral |
| `origen` | `Nacional` o `Extranjero` |
| `imagen` | URL de la tapa. Si es `NULL`, la card muestra un recuadro vacío |
| `rating` | Estrellas de 1 a 5. La landing las usa en "Más vendido" |
| `mas_vendido` | `1` si entra en el recuadro de la portada (`GET /libros?mas_vendido=1`). En el script solo Alicia |
| `novedad` | `1` si entra en el filtro Novedades |
| `recomendado` | `1` si entra en el filtro Recomendados |
| `en_oferta` | `1` si entra en el filtro Sale |

## CLIENTES

Persona que puede comprar. `email` no se repite. `telefono` puede ser `NULL`: Ana López y Pedro Gómez están cargados así para practicar `IS NULL`.

## PEDIDOS

La compra de un cliente, con fecha y monto. El monto es la suma del detalle (el pedido de Martín no coincide con el precio de un solo libro, porque lleva dos).

Un cliente puede no haber comprado o haber comprado varias veces. En el script, Carlos y Pedro no tienen pedidos.

## DETALLE_PEDIDO

La tabla intermedia de pedido–libro. Cada fila es un título dentro de un pedido: cantidad y el precio que se cobró en ese momento (`precio_unitario`), que puede diferir del `precio` actual del libro.

La pareja (`id_pedido`, `id_libro`) es única: el mismo título no se repite dentro del mismo pedido; si quieren dos copias, va en `cantidad`.

## Casos que el script deja listos para practicar

- Onetti no tiene libros: un `LEFT JOIN` desde `AUTORES` lo muestra igual.
- Quino tiene `nacionalidad` en `NULL`. Mafalda tiene `anio` y `precio` en `NULL`.
- Ana López y Pedro Gómez tienen `telefono` en `NULL`.
- Hay títulos sin ningún pedido: Alicia, Harry Potter, El mago de Oz, El instituto, El diario de Ana Frank, El señor de los anillos, Hamlet y Mafalda.
- El pedido de Martín lleva dos libros (El Principito y Pinocho). El de Laura lleva uno solo (It).
- Alicia es la única fila con `mas_vendido = 1`.

## Cómo lo lee la API

El modelo es el único que escribe SQL.

- `GET /autores` lee `AUTORES` ordenadas por nombre. Onetti aparece aunque no tenga libros.
- `GET /categorias` lee `CATEGORIAS` ordenadas por nombre.
- `GET /libros` hace `INNER JOIN` con `AUTORES` y `CATEGORIAS`. Acepta `tipo`, `origen`, `id_autor`, `id_categoria`, `anio`, `mas_vendido`, `novedad`, `recomendado`, `en_oferta` y `orden`.
- `orden=precio` ordena de menor a mayor. Los precios `NULL` van al final. Sin ese parámetro, el orden es el `id_libro`.
