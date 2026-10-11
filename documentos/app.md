# Cómo está armada Book-e

La app es API-driven. El navegador muestra HTML y CSS. Los datos salen de MySQL, pero el HTML nunca escribe una consulta: se los pide a la API y la API responde JSON.

## Carpetas

| Carpeta | Rol |
| --- | --- |
| `front/` | Lo que ve el usuario. `index.html` es la landing. Los estilos están en `front/dist/css/`. El JavaScript está en `front/dist/js/`. |
| `api/` | El servidor. `index.php` recibe todo lo que empieza con `/api`. `routes.php` dice qué controlador atiende cada URL. |
| `api/src/Controllers/` | Decide qué pedir y arma el JSON. No escribe SQL. |
| `api/src/Models/` | El único lugar con SQL. |
| `api/src/Utils/` | Carga el `.env` y el router. Esto no se toca para agregar una pantalla. |
| `api/config/` | Conexión (`database.php`) y el script que Docker ejecuta al crear la base (`init.sql`). |
| `documentos/` | Checklist, este archivo y la base de datos. |
| `assets/` | La foto de referencia de la landing. No la sirve el sitio. |

Docker levanta tres servicios: Apache con PHP (puerto 8080), MySQL (3306) y phpMyAdmin (8081). El `Dockerfile` prende `rewrite` y la extensión `pdo_mysql`.

## Recorrido de una petición

Ejemplo: la landing pide los libros en oferta.

1. `front/dist/js/script.js` llama a `API.request('/libros?en_oferta=1')`.
2. `front/dist/js/api.js` hace `fetch('/api/libros?en_oferta=1')`.
3. El `.htaccess` de la raíz ve que la URL empieza con `api/` y la manda a `api/index.php`.
4. `api/index.php` carga el `.env`, abre MySQL y crea el router con base `/api`.
5. `api/routes.php` tiene `$router->get('/libros', 'LibroController@listar')`.
6. `LibroController` lee los query params y se los pasa a `LibroModel`.
7. `LibroModel` arma el `SELECT` con los filtros y devuelve filas.
8. El controlador imprime `{ "status": "ok", "data": [ ... ] }`.
9. `script.js` pinta las cards. Si `status` no es `ok`, muestra el mensaje de error en la grilla.

La raíz `http://localhost:8080/` redirige a `/front/index.html`.

## Qué hace la landing con cada dato

| Pedido | Para qué |
| --- | --- |
| `GET /api/libros?mas_vendido=1` | El recuadro "Más vendido" |
| `GET /api/libros` | La grilla y el contador de artículos |
| `GET /api/libros?...` | Los filtros del lateral y el orden "Más barato" (`orden=precio`) |
| `GET /api/autores` | El desplegable "Elegir autor" |
| `GET /api/categorias` | El desplegable "Elegir categoría" |
| `GET /api/estado` | Comprobar que la API y la tabla `CLIENTES` responden |

El buscador del header filtra por título o autor en el navegador, sobre la lista que ya trajo la API. No hay un parámetro `q` en el servidor.

Los banners (colección infantil y 14% para libreros) y el carrusel de novedades son HTML fijo. No son filas de `LIBROS`.

## Cómo se agrega un endpoint

1. Crear el modelo en `api/src/Models/` con el SQL.
2. Crear el controlador en `api/src/Controllers/`. El constructor recibe `$db` y el método hace `echo json_encode(...)`.
3. Anotar la ruta en `api/routes.php`.
4. Llamarla desde `script.js` con `API.request('/ruta')`.

El autoload resuelve `App\Controllers\LibroController` a `api/src/Controllers/LibroController.php`. El nombre del archivo tiene que coincidir con la clase.

## Login y roles

`api/index.php` abre la sesión de PHP antes de responder. La cookie viaja sola porque la landing y la API están en el mismo origen (`localhost:8080`). `api.js` manda `credentials: 'same-origin'`.

| Pedido | Para qué |
| --- | --- |
| `POST /api/login` | Recibe `email` y `clave`. Si coinciden, guarda en la sesión el id, el nombre, el email y el rol. No devuelve el hash. |
| `GET /api/sesion` | Dice quién está adentro. Si no hay sesión, responde 401. |
| `POST /api/logout` | Borra la sesión. |
| `GET /api/admin/libros` | La misma lista del catálogo, pero responde 403 si el rol no es `Administrador`. |

Después del login, `login.html` manda al administrador a `admin.html` y al usuario a la tienda (`index.html`). En la barra, el lugar de “Cuenta” muestra el nombre y el rol de quien tiene la sesión abierta.

`admin.html` no muestra el panel hasta preguntar `GET /api/sesion`. Si no hay sesión, vuelve al login. Si el rol es `Usuario`, lo manda a la tienda. Aunque alguien abra el HTML a mano, la tabla de libros sale de `/api/admin/libros`, que el servidor rechaza sin el rol.

En la tienda, sin sesión, la barra dice “Cuenta” y lleva al login. Con sesión, muestra el nombre y el rol, y un botón Salir. El nombre del administrador abre el panel.

## Qué queda afuera a propósito

La ficha "Más detalles", el carrito, los favoritos, el alta del newsletter y el ABM de libros siguen pendientes. El panel de administración lista los libros, pero no los crea, edita ni borra.
