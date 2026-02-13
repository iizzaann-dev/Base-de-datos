drop database if exists academia_idiomas;
create database academia_idiomas CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
use academia_idiomas;

-- PARTE A – DISEÑO FÍSICO DE BASES DE DATOS (6 puntos) 

-- 1. Tabla alumnos (2 puntos)

create table alumnos(
	id_alumno int auto_increment primary key,
	dni char(9) not null unique,
    nombre varchar (30) not null,
    apellidos varchar (50) not null,
    fecha_nacimiento date,
    email varchar (50)
);
alter table alumnos modify column email varchar (50) unique;

-- 2. Tabla cursos (2 puntos)

create table cursos (
	id_curso int primary key ,
    idioma varchar (30) not null,
    nivel enum ("Básico", "Intermedio", "Avanzado") not null
    -- precio_mesnual decimal(2, 2) check(precio_mensual > 0 and precio_mensual < 3000)
);

ALTER TABLE cursos DROP column id_curso;
alter table cursos modify column id_curso char (4) primary key;

-- 3. Tabla matrículas (2 puntos)

create table matriculas (
	id_matricula int primary key unique,
    id_alumno int,
    foreign key (id_alumno) references alumnos (id_alumno) ON DELETE CASCADE
    ON UPDATE CASCADE,
    id_curso int,
    foreign key (id_curso) references cursos (id_curso) ON DELETE CASCADE
    ON UPDATE CASCADE,
    fecha_matricula date not null
);

ALTER TABLE matriculas ADD CONSTRAINT fk_id_curso FOREIGN KEY (id_curso) REFERENCES cursos (id_curso);


-- PARTE B – GESTIÓN DE USUARIOS Y ROLES (4 puntos) 

-- 1.
create user "academia_app"@"%host" identified by "TempPass!123";

-- 2
create role "rol_lectura";
grant select on academia_idiomas.* to "rol_lectura";

-- 3
create role "rol_gestion";
grant insert, update on academia_idiomas.* to "rol_gestion";

-- 4
grant rol_lectura to "academia_app"@"%host";
grant rol_gestion to "academia_app"@"%host";
set default role "rol_lectura" to "academia_app"@"%host";

-- 5
show grants for academia_app;



