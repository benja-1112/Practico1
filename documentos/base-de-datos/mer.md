# Modelo entidad-relación

Ocho entidades. El pedido junta un cliente con uno o varios libros. Autor y categoría clasifican títulos. Un libro se vende muchas veces: no es una unidad única. El rol clasifica a quien inicia sesión.

No hay editorial. La landing no muestra ni filtra por editorial: el título se entiende con autor y categoría. Agregarla ahora sería una tabla que ninguna pantalla lee.

`USUARIOS` no es lo mismo que `CLIENTES`. El usuario entra al sitio. El cliente es quien figura en una venta. Una venta puede existir sin cuenta, y una cuenta puede existir sin compras.

```mermaid
erDiagram
    ROLES ||--o{ USUARIOS : asigna
    AUTORES ||--o{ LIBROS : escribe
    CATEGORIAS ||--o{ LIBROS : clasifica
    CLIENTES ||--o{ PEDIDOS : realiza
    PEDIDOS ||--|{ DETALLE_PEDIDO : contiene
    LIBROS ||--o{ DETALLE_PEDIDO : incluye

    ROLES {
        int id_rol PK
        varchar nombre
    }

    USUARIOS {
        int id_usuario PK
        int id_rol FK
        varchar nombre_completo
        varchar email
        varchar clave_hash
    }

    AUTORES {
        int id_autor PK
        varchar nombre
        varchar nacionalidad
    }

    CATEGORIAS {
        int id_categoria PK
        varchar nombre
    }

    LIBROS {
        int id_libro PK
        int id_autor FK
        int id_categoria FK
        varchar titulo
        int anio
        decimal precio
        varchar tipo
        varchar origen
        varchar imagen
        tinyint rating
        tinyint mas_vendido
        tinyint novedad
        tinyint recomendado
        tinyint en_oferta
    }

    CLIENTES {
        int id_cliente PK
        varchar nombre_completo
        varchar email
        varchar telefono
    }

    PEDIDOS {
        int id_pedido PK
        int id_cliente FK
        date fecha_pedido
        decimal monto_total
    }

    DETALLE_PEDIDO {
        int id_detalle PK
        int id_pedido FK
        int id_libro FK
        int cantidad
        decimal precio_unitario
    }
```

## Cardinalidades

| Relación | Lectura |
| --- | --- |
| Rol → usuario | Un rol tiene cero o muchos usuarios. Cada usuario tiene un solo rol. |
| Autor → libro | Un autor tiene cero o muchos libros. Cada libro tiene un autor. Onetti está cargado con cero. |
| Categoría → libro | Una categoría tiene cero o muchos libros. Cada libro tiene una categoría. |
| Cliente → pedido | Un cliente puede no haber comprado o haber comprado varios. Cada pedido es de un cliente. |
| Pedido → detalle | Un pedido tiene uno o muchos renglones. Cada renglón pertenece a un solo pedido. |
| Libro → detalle | Un libro puede no haberse vendido o aparecer en muchos pedidos. Cada renglón es de un solo libro. |

Pedido y libro son muchos a muchos. `DETALLE_PEDIDO` es la entidad intermedia: existe porque hay que guardar `cantidad` y `precio_unitario`, que no son de ninguna de las dos puntas solas.

## Atributos opcionales

Pueden quedar vacíos: `nacionalidad`, `anio`, `precio`, `imagen`, `telefono`. En el script, los que usamos en `NULL` a propósito son `nacionalidad` (Quino), `anio` y `precio` (Mafalda) y `telefono` (Ana y Pedro).

`email` es único. Dentro de un mismo pedido, `id_libro` no se repite.
