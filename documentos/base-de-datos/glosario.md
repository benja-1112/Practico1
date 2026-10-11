# Glosario de datos

El modelo de la carpeta de Base de Datos del Drive no está en este proyecto. Este archivo usa la estructura habitual del glosario para poder pasarlo al documento del docente sin cambiar el significado de cada campo:

| Campo | Descripción | Tipo | Tamaño | Clave | Nulo | Dominio o ejemplo |
| --- | --- | --- | --- | --- | --- | --- |

Tipo y tamaño son los de MySQL en [esquema.sql](esquema.sql). "Nulo" dice si el campo puede quedar vacío.

## ROLES

Quién puede entrar y a qué pantalla va después del login.

| Campo | Descripción | Tipo | Tamaño | Clave | Nulo | Dominio o ejemplo |
| --- | --- | --- | --- | --- | --- | --- |
| id_rol | Identificador del rol | INT | — | PK | No | 1 |
| nombre | Nombre del permiso | VARCHAR | 30 | Única | No | Administrador, Usuario |

## USUARIOS

Cuenta de acceso. No es la persona de una venta: eso está en CLIENTES.

| Campo | Descripción | Tipo | Tamaño | Clave | Nulo | Dominio o ejemplo |
| --- | --- | --- | --- | --- | --- | --- |
| id_usuario | Identificador de la cuenta | INT | — | PK | No | 1 |
| id_rol | Rol que tiene esta cuenta | INT | — | FK → ROLES.id_rol | No | 1 |
| nombre_completo | Nombre que se muestra en el panel | VARCHAR | 100 | — | No | Sofía Acosta |
| email | Correo con el que entra. No se repite | VARCHAR | 100 | Única | No | admin@booke.com |
| clave_hash | Clave transformada con password_hash(). Nunca se guarda en claro | VARCHAR | 255 | — | No | $2y$10$... |

## AUTORES

Persona que escribió uno o varios títulos.

| Campo | Descripción | Tipo | Tamaño | Clave | Nulo | Dominio o ejemplo |
| --- | --- | --- | --- | --- | --- | --- |
| id_autor | Identificador del autor | INT | — | PK | No | 1 |
| nombre | Nombre con el que se lo busca | VARCHAR | 100 | — | No | Lewis Carroll |
| nacionalidad | País de origen. Puede faltar | VARCHAR | 50 | — | Sí | Reino Unido, NULL |

## CATEGORIAS

Género del título. No incluye los filtros comerciales de la landing (oferta, novedad, origen).

| Campo | Descripción | Tipo | Tamaño | Clave | Nulo | Dominio o ejemplo |
| --- | --- | --- | --- | --- | --- | --- |
| id_categoria | Identificador del género | INT | — | PK | No | 1 |
| nombre | Nombre del género | VARCHAR | 50 | — | No | Infantil, Terror, Cómic |

## LIBROS

Título a la venta. Una fila es un libro, no un ejemplar único.

| Campo | Descripción | Tipo | Tamaño | Clave | Nulo | Dominio o ejemplo |
| --- | --- | --- | --- | --- | --- | --- |
| id_libro | Identificador del título | INT | — | PK | No | 1 |
| id_autor | Quién lo escribió | INT | — | FK → AUTORES.id_autor | Sí | 1 |
| id_categoria | Género | INT | — | FK → CATEGORIAS.id_categoria | Sí | 1 |
| titulo | Nombre que se ve en la card | VARCHAR | 150 | — | No | El Principito |
| anio | Año de publicación | INT | — | — | Sí | 1943, NULL |
| precio | Precio de lista | DECIMAL | 10,2 | — | Sí | 380.00, NULL |
| tipo | Formato del lateral | VARCHAR | 20 | — | Sí | Libro, Comic |
| origen | Procedencia del lateral | VARCHAR | 20 | — | Sí | Nacional, Extranjero |
| imagen | URL de la tapa | VARCHAR | 255 | — | Sí | https://... |
| rating | Estrellas del más vendido | TINYINT | — | — | No | 0 a 5 |
| mas_vendido | 1 si sale en el recuadro de la portada | TINYINT | 1 | — | No | 0 o 1 |
| novedad | 1 si entra en el filtro Novedades | TINYINT | 1 | — | No | 0 o 1 |
| recomendado | 1 si entra en Recomendados | TINYINT | 1 | — | No | 0 o 1 |
| en_oferta | 1 si entra en Ofertas | TINYINT | 1 | — | No | 0 o 1 |

## CLIENTES

Persona que puede figurar en una venta. No inicia sesión con esta tabla.

| Campo | Descripción | Tipo | Tamaño | Clave | Nulo | Dominio o ejemplo |
| --- | --- | --- | --- | --- | --- | --- |
| id_cliente | Identificador del cliente | INT | — | PK | No | 1 |
| nombre_completo | Nombre de la persona | VARCHAR | 100 | — | No | Ana López |
| email | Correo. No se repite | VARCHAR | 100 | Única | Sí | ana.lopez@email.com |
| telefono | Teléfono. Puede faltar para practicar IS NULL | VARCHAR | 20 | — | Sí | 099123456, NULL |

## PEDIDOS

Una compra de un cliente, con fecha y total.

| Campo | Descripción | Tipo | Tamaño | Clave | Nulo | Dominio o ejemplo |
| --- | --- | --- | --- | --- | --- | --- |
| id_pedido | Identificador de la compra | INT | — | PK | No | 1 |
| id_cliente | Quién compró | INT | — | FK → CLIENTES.id_cliente | Sí | 1 |
| fecha_pedido | Día de la compra | DATE | — | — | Sí | 2024-03-12 |
| monto_total | Suma del detalle. Puede no coincidir con el precio de un solo libro | DECIMAL | 10,2 | — | Sí | 740.00 |

## DETALLE_PEDIDO

Un título dentro de un pedido. Es la tabla del muchos a muchos.

| Campo | Descripción | Tipo | Tamaño | Clave | Nulo | Dominio o ejemplo |
| --- | --- | --- | --- | --- | --- | --- |
| id_detalle | Identificador del renglón | INT | — | PK | No | 1 |
| id_pedido | Pedido al que pertenece | INT | — | FK → PEDIDOS.id_pedido | Sí | 1 |
| id_libro | Título incluido | INT | — | FK → LIBROS.id_libro | Sí | 2 |
| cantidad | Copias de ese título en el pedido | INT | — | — | No | 1 |
| precio_unitario | Precio cobrado en esa venta, no el precio actual del libro | DECIMAL | 10,2 | — | Sí | 650.00 |

La pareja (`id_pedido`, `id_libro`) es única: el mismo título no se carga dos veces en el mismo pedido.
