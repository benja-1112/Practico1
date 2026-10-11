# Checklist del proyecto Book-e

Biblioteca virtual (tienda de títulos) en Docker: el front pide JSON a la API y la API usa MVC (ruta, controlador, modelo). La base es MySQL.

La referencia visual es `assets/landing.png`.

## Cómo levantar el proyecto

1. Copiar los ejemplos de entorno si todavía no existen:
   - `.env.example` → `.env` (nombre de los contenedores)
   - `api/.env.example` → `api/.env` (conexión a MySQL)
2. Si la base ya se había creado con otro esquema, hay que borrarla. `init.sql` solo corre la primera vez que existe el volumen:

```bash
docker compose down -v
docker compose up --build
```

3. Abrir la landing en `http://localhost:8080` (redirige a `/front/index.html`).
4. La API responde en `http://localhost:8080/api/estado`, `/api/autores`, `/api/categorias` y `/api/libros`.
5. El login está en `http://localhost:8080/front/login.html`.

Cuentas de práctica:

| Rol | Email | Clave |
| --- | --- | --- |
| Administrador | admin@booke.com | Admin123 |
| Usuario | usuario@booke.com | Usuario123 |

Si el volumen de MySQL se creó antes del práctico 2, `init.sql` no vuelve a correr. En ese caso se aplica la migración, sin borrar el catálogo:

```bash
cmd /c "docker exec -i booke_db mysql --default-character-set=utf8mb4 -uusuario -ppassword mi_base_de_datos < documentos\base-de-datos\migracion-practico2.sql"
```
6. phpMyAdmin queda en `http://localhost:8081`.

Los puertos son los del esqueleto (8080, 3306 y 8081). Si otro proyecto Docker los está usando, hay que apagarlo antes.

## Hecho

- [x] Docker: PHP/Apache, MySQL 8 y phpMyAdmin
- [x] Front separado de la API. El HTML no arma SQL: pasa por `front/dist/js/api.js`
- [x] API en MVC (`routes.php`, controladores, modelos)
- [x] `GET /api/estado` (la API responde y cuenta clientes)
- [x] Documentación de la base: explicación, MER, pasaje a tablas y `esquema.sql`
- [x] Catálogo: `GET /api/autores`, `GET /api/categorias` y `GET /api/libros` (con filtros)
- [x] Landing Book-e: más vendido, grilla y filtros salen de la API
- [x] Roles y usuarios en la base, con el MER, el pasaje a tablas y el glosario
- [x] Login. El administrador entra al panel y el usuario a la tienda, con su nombre y rol en la barra
- [x] `GET /api/admin/libros` responde 403 si la sesión no es de administrador

## Pendiente

- [ ] Ficha de un libro ("Más detalles")
- [ ] Carrito
- [ ] Favoritos (el corazón de la card y el del header)
- [ ] Newsletter del footer (el formulario todavía no guarda el mail)
- [ ] ABM de autores, categorías, libros, clientes, pedidos y detalle

## Dónde está cada cosa

| Qué | Dónde |
| --- | --- |
| Landing | `front/index.html` |
| Login | `front/login.html` |
| Panel de administración | `front/admin.html` |
| Tienda con la sesión | `front/index.html` (nombre y rol en la barra) |
| Glosario | `documentos/base-de-datos/glosario.md` |
| Estilos | `front/dist/css/style.css` y `mobile.css` |
| Llamadas a la API | `front/dist/js/api.js` y `script.js` |
| Rutas | `api/routes.php` |
| SQL que usa Docker | `api/config/init.sql` |
| Explicación de la base | `documentos/base-de-datos/` |
| Cómo está armada la app | `documentos/app.md` |
| Referencia visual | `assets/landing.png` |
