-- Creacion de la base de datos:
CREATE DATABASE IF NOT EXISTS gestor_proyectos;
USE gestor_proyectos;

-- Tabla de roles
CREATE TABLE roles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) UNIQUE NOT NULL
);

-- Tabla de usuarios
CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    esta_bloqueado BOOLEAN DEFAULT FALSE,
    rol_id INT,
    creado_en DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (rol_id) REFERENCES roles(id)
);

-- Tabla de proyectos
CREATE TABLE proyectos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(100) NOT NULL,
    descripcion TEXT,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    creado_por INT,
    FOREIGN KEY (creado_por) REFERENCES usuarios(id)
);

-- Tabla de relación usuarios-proyectos (usuarios asignados)
CREATE TABLE usuarios_proyectos (
    usuario_id INT,
    proyecto_id INT,
    PRIMARY KEY (usuario_id, proyecto_id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    FOREIGN KEY (proyecto_id) REFERENCES proyectos(id)
);

-- Tabla de tareas
CREATE TABLE tareas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(100) NOT NULL,
    descripcion TEXT,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    estado ENUM('pendiente', 'en_progreso', 'completada') DEFAULT 'pendiente',
    prioridad TINYINT CHECK (prioridad BETWEEN 1 AND 5),
    proyecto_id INT,
    asignado_a INT,
    creado_por INT,
    FOREIGN KEY (proyecto_id) REFERENCES proyectos(id) ON DELETE CASCADE,
    FOREIGN KEY (asignado_a) REFERENCES usuarios(id),
    FOREIGN KEY (creado_por) REFERENCES usuarios(id)
);

-- Datos de ejemplo:
-- Insertar roles
INSERT INTO roles (nombre) VALUES ('admin'), ('usuario');

-- Insertar usuarios (contraseña: 123456 en bcrypt)
INSERT INTO usuarios (nombre, correo, password, esta_bloqueado, rol_id) VALUES
('Admin General', 'admin@demo.com', '$2b$10$O.OE9c4U4p45vEu98LDn7.ZeiI5T6m1QyWSnaPD67VX3t1fC99lYq', FALSE, 1),
('Carlos Pérez', 'carlos@demo.com', '$2b$10$eEj3xo4XxlJtXqNps0QKOeMie8e6BrV6pBeZhUOcDWhRgPaJ9ib9m', FALSE, 2),
('Ana Torres', 'ana@demo.com', '$2b$10$eEj3xo4XxlJtXqNps0QKOeMie8e6BrV6pBeZhUOcDWhRgPaJ9ib9m', FALSE, 2),
('Luis Gómez', 'luis@demo.com', '$2b$10$eEj3xo4XxlJtXqNps0QKOeMie8e6BrV6pBeZhUOcDWhRgPaJ9ib9m', TRUE, 2);

-- Insertar proyectos
INSERT INTO proyectos (titulo, descripcion, fecha_inicio, fecha_fin, creado_por) VALUES
('Proyecto Web', 'Sistema web para ventas online', '2024-06-01', '2024-08-01', 1),
('App Móvil', 'Aplicación para pedidos de comida', '2024-07-01', '2024-09-01', 2);

-- Asignar usuarios a proyectos
INSERT INTO usuarios_proyectos (usuario_id, proyecto_id) VALUES
(2, 1),
(3, 1),
(4, 2);

-- Insertar tareas
INSERT INTO tareas (titulo, descripcion, fecha_inicio, fecha_fin, estado, prioridad, proyecto_id, asignado_a, creado_por) VALUES
('Diseño UI', 'Diseñar prototipos para interfaz', '2024-06-02', '2024-06-10', 'pendiente', 3, 1, 3, 1),
('API Login', 'Crear endpoints de autenticación', '2024-06-03', '2024-06-08', 'en_progreso', 4, 1, 2, 1),
('Modelo de datos', 'Estructurar base de datos', '2024-06-05', '2024-06-12', 'completada', 2, 1, 2, 1),
('Notificaciones Push', 'Implementar push en Flutter', '2024-07-05', '2024-07-20', 'pendiente', 5, 2, 4, 2);
