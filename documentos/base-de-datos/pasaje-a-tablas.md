# Pasaje a tablas

Del MER salen ocho tablas. Hay una sola tabla intermedia, porque la única relación de muchos a muchos es pedido–libro.

## Reglas que se aplicaron

1. Cada entidad fuerte pasa a una tabla con su clave primaria entera y autoincremental.
2. Los atributos pasan a columnas, con el mismo nombre y el mismo dominio.
3. Una relación 1:N se resuelve con la clave de la entidad "1" como clave foránea en la tabla de la entidad "N".
4. Una relación N:M se resuelve con una tabla nueva. Esa tabla lleva las dos claves foráneas y los atributos de la relación (`cantidad`, `precio_unitario`).
5. Los atributos opcionales del MER admiten `NULL`. `email` lleva restricción `UNIQUE`.
6. En `DETALLE_PEDIDO`, la pareja (`id_pedido`, `id_libro`) es `UNIQUE`. El mismo título entra una sola vez por pedido; las copias van en `cantidad`.

La regla "un pedido tiene al menos un renglón" es del MER (1 a 1..N). El motor no la obliga: la cumplen los `INSERT` del script.

## ROLES

Sale de la entidad Rol. No recibe claves de nadie: es el lado "1" de usuario.

| Columna | Origen | Restricción |
| --- | --- | --- |
| `id_rol` | identificador | PK, `AUTO_INCREMENT` |
| `nombre` | atributo | `NOT NULL`, `UNIQUE`. Vale `Administrador` o `Usuario` |

## USUARIOS

Sale de la entidad Usuario. La relación "asigna" (rol 1 — usuario N) deja `id_rol` acá. La clave no se guarda en texto plano: `clave_hash` es el resultado de `password_hash()`.

| Columna | Origen | Restricción |
| --- | --- | --- |
| `id_usuario` | identificador | PK, `AUTO_INCREMENT` |
| `id_rol` | FK de "asigna" | `NOT NULL`, FK → `ROLES.id_rol` |
| `nombre_completo` | atributo | `NOT NULL` |
| `email` | atributo | `NOT NULL`, `UNIQUE` |
| `clave_hash` | atributo | `NOT NULL` |

## AUTORES

Sale de la entidad Autor. No recibe claves de nadie: es el lado "1" de la única relación en la que participa.

| Columna | Origen | Restricción |
| --- | --- | --- |
| `id_autor` | identificador | PK, `AUTO_INCREMENT` |
| `nombre` | atributo | `NOT NULL` |
| `nacionalidad` | atributo | opcional |

## CATEGORIAS

Sale de la entidad Categoría. Tampoco lleva claves foráneas.

| Columna | Origen | Restricción |
| --- | --- | --- |
| `id_categoria` | identificador | PK, `AUTO_INCREMENT` |
| `nombre` | atributo | `NOT NULL` |

## LIBROS

Sale de la entidad Libro. Recibe dos claves foráneas, una por cada relación 1:N.

| Columna | Origen | Restricción |
| --- | --- | --- |
| `id_libro` | identificador | PK, `AUTO_INCREMENT` |
| `id_autor` | FK de "escribe" | FK → `AUTORES.id_autor` |
| `id_categoria` | FK de "clasifica" | FK → `CATEGORIAS.id_categoria` |
| `titulo` | atributo | `NOT NULL` |
| `anio` | atributo | opcional |
| `precio` | atributo | `DECIMAL(10,2)`, opcional |
| `tipo` | atributo | `Libro` o `Comic` |
| `origen` | atributo | `Nacional` o `Extranjero` |
| `imagen` | atributo | URL, opcional |
| `rating` | atributo | `NOT NULL`, default `0` |
| `mas_vendido` | atributo | `NOT NULL`, default `0` |
| `novedad` | atributo | `NOT NULL`, default `0` |
| `recomendado` | atributo | `NOT NULL`, default `0` |
| `en_oferta` | atributo | `NOT NULL`, default `0` |

El lateral de la landing no es una tabla. `tipo` alimenta "Libros" y "Comics". `origen` alimenta "Nacional" y "Extranjero". Los cuatro flags alimentan "Más vendidos", "Novedades", "Recomendados" y "Sale". El año del desplegable es `anio`. El autor del desplegable es la tabla `AUTORES`.

## CLIENTES

Sale de la entidad Cliente. No lleva claves foráneas.

| Columna | Origen | Restricción |
| --- | --- | --- |
| `id_cliente` | identificador | PK, `AUTO_INCREMENT` |
| `nombre_completo` | atributo | `NOT NULL` |
| `email` | atributo | `UNIQUE` |
| `telefono` | atributo | opcional |

## PEDIDOS

Sale de la entidad Pedido. La relación "realiza" (cliente 1 — pedido N) deja `id_cliente` acá.

| Columna | Origen | Restricción |
| --- | --- | --- |
| `id_pedido` | identificador | PK, `AUTO_INCREMENT` |
| `id_cliente` | FK de "realiza" | FK → `CLIENTES.id_cliente` |
| `fecha_pedido` | atributo | opcional |
| `monto_total` | atributo | `DECIMAL(10,2)`, opcional |

## DETALLE_PEDIDO

Sale de la relación N:M entre Pedido y Libro, más los atributos de esa relación. No alcanza con colgar una clave en una de las dos tablas: las dos puntas son "muchos".

| Columna | Origen | Restricción |
| --- | --- | --- |
| `id_detalle` | identificador | PK, `AUTO_INCREMENT` |
| `id_pedido` | FK de "contiene" | FK → `PEDIDOS.id_pedido` |
| `id_libro` | FK de "incluye" | FK → `LIBROS.id_libro` |
| `cantidad` | atributo de la relación | `NOT NULL`, default `1` |
| `precio_unitario` | atributo de la relación | `DECIMAL(10,2)`, opcional |

`UNIQUE (id_pedido, id_libro)` evita dos renglones del mismo título en el mismo pedido.

## Resultado

```text
ROLES (id_rol, nombre)
    nombre UNIQUE

USUARIOS (id_usuario, id_rol, nombre_completo, email, clave_hash)
    id_rol → ROLES.id_rol
    email UNIQUE

AUTORES (id_autor, nombre, nacionalidad)

CATEGORIAS (id_categoria, nombre)

LIBROS (id_libro, id_autor, id_categoria, titulo, anio, precio, tipo, origen,
        imagen, rating, mas_vendido, novedad, recomendado, en_oferta)
    id_autor     → AUTORES.id_autor
    id_categoria → CATEGORIAS.id_categoria

CLIENTES (id_cliente, nombre_completo, email, telefono)
    email UNIQUE

PEDIDOS (id_pedido, id_cliente, fecha_pedido, monto_total)
    id_cliente → CLIENTES.id_cliente

DETALLE_PEDIDO (id_detalle, id_pedido, id_libro, cantidad, precio_unitario)
    id_pedido → PEDIDOS.id_pedido
    id_libro  → LIBROS.id_libro
    UNIQUE (id_pedido, id_libro)
```

El `CREATE TABLE` equivalente, con los `INSERT` de práctica, está en [esquema.sql](esquema.sql).
