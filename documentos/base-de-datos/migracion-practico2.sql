-- Práctico 2. Se aplica sobre una base que ya tenía el catálogo del práctico 1.
-- init.sql no vuelve a correr si el volumen de MySQL ya existe.

CREATE TABLE IF NOT EXISTS ROLES (
    id_rol INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(30) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS USUARIOS (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    id_rol INT NOT NULL,
    nombre_completo VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    clave_hash VARCHAR(255) NOT NULL,
    FOREIGN KEY (id_rol) REFERENCES ROLES(id_rol)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO ROLES (nombre)
SELECT 'Administrador' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM ROLES WHERE nombre = 'Administrador');

INSERT INTO ROLES (nombre)
SELECT 'Usuario' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM ROLES WHERE nombre = 'Usuario');

INSERT INTO USUARIOS (id_rol, nombre_completo, email, clave_hash)
SELECT r.id_rol, 'Sofía Acosta', 'admin@booke.com', '$2y$10$YdUYJ5GbasE5zbICpwjbpevktk5wps/MPqDON3mQJkaRpRq6necE.'
FROM ROLES r
WHERE r.nombre = 'Administrador'
  AND NOT EXISTS (SELECT 1 FROM USUARIOS WHERE email = 'admin@booke.com');

INSERT INTO USUARIOS (id_rol, nombre_completo, email, clave_hash)
SELECT r.id_rol, 'Martín Silva', 'usuario@booke.com', '$2y$10$NF/nI.YFRDbStDr8.CdRweI8zGCdMoqfK1U6VcNevb/vXdzo4hc7m'
FROM ROLES r
WHERE r.nombre = 'Usuario'
  AND NOT EXISTS (SELECT 1 FROM USUARIOS WHERE email = 'usuario@booke.com');
