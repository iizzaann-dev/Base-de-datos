drop database if exists  plataforma_proyectos;
create database  plataforma_proyectos CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
use  plataforma_proyectos;

-- PARTE A – DISEÑO FÍSICO DE BASES DE DATOS (6 puntos) 

-- 1. Tabla desarrolladores (2 puntos)
create table desarrolladores (
    id_desarrollador int auto_increment primary key,			-- La empresa le asigna uno, al ser del 10 digitos como max, no se podra llenar con 9999999999, ninguna empresa tiene tantos trabajadores
    nombre_usuario varchar (50) not null unique,
    email_usuario varchar(50) not null unique, 
    fecha_registro date not null, 
    nivel_experiencia enum ("Junior", "Mid", "Senior") not null
);

-- 2. Tabla proyectos (2 puntos) 
create table proyectos (
	id_proyecto int auto_increment primary key,
    nombre_proyecto varchar (30) not null,
    descripcion varchar (30),
    fecha_inicio date not null,
    fecha_fin date,
    estado enum ("Planificado", "En desarrollo", "Finalizado") not null
    );
    
create table asignaciones (
	id_asignacion int auto_increment primary key,
    id_proyecto int,
	id_desarrollador int,
	unique (id_desarrollador, id_proyecto),
    foreign key (id_proyecto) references proyectos (id_proyecto),
    foreign key (id_desarrollador) references desarrolladores (id_desarrollador),
    rol varchar (30) not null,
    fecha_asignacion date not null
);

-- PARTE B – GESTIÓN DE USUARIOS Y ROLES (4 puntos) 

-- 1.
create user "proyectos_app"@"localhost" identified by "DevPass$2026";

-- 2
create role "rol_lectura";
grant select on plataforma_proyectos.* to "rol_lectura";

-- 3
create role "rol_edicion";
grant insert, update on plataforma_proyectos.* to "rol_edicion";

-- 4
grant "rol_lectura" to "proyectos_app"@"localhost";
grant "rol_edicion" to "proyectos_app"@"localhost";
set default role "rol_lectura" to "proyectos_app"@"localhost";

-- 5
drop user if exists "proyectos_app"@"localhost";
drop role if exists "rol_lectura", "rol_edicion";


INSERT INTO desarrolladores (nombre_usuario, email_usuario, fecha_registro, nivel_experiencia)
VALUES
('juan_dev', 'juan@example.com', '2024-01-10', 'Junior'),
('maria_code', 'maria@example.com', '2024-02-15', 'Mid'),
('carlos_prog', 'carlos@example.com', '2024-03-20', 'Senior');


INSERT INTO proyectos (nombre_proyecto, descripcion, fecha_inicio, fecha_fin, estado)
VALUES
('Sistema Ventas', 'App de ventas', '2024-01-01', NULL, 'En desarrollo'),
('Web Empresa', 'Página corporativa', '2024-02-01', '2024-06-01', 'Planificado'),
('App Móvil', 'Aplicación Android', '2024-03-01', NULL, 'En desarrollo');


INSERT INTO asignaciones (id_proyecto, id_desarrollador, rol, fecha_asignacion)
VALUES
(1, 1, 'Backend', '2024-01-15'),
(1, 2, 'Frontend', '2024-01-20'),
(2, 3, 'Fullstack', '2024-02-10');

-- Si falla esta bien
INSERT INTO asignaciones (id_proyecto, id_desarrollador, rol, fecha_asignacion)
VALUES (1, 1, 'Tester', '2024-01-25');

SELECT * FROM desarrolladores;
SELECT * FROM proyectos;

SELECT a.id_asignacion, d.nombre_usuario, p.nombre_proyecto, a.rol
FROM asignaciones a
JOIN desarrolladores d ON a.id_desarrollador = d.id_desarrollador
JOIN proyectos p ON a.id_proyecto = p.id_proyecto;
