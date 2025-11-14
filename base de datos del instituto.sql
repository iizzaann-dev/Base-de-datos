-- Borra la base de datos si existe

DROP DATABASE IF EXISTS instituto;

-- Crea la base de datos instituto
CREATE DATABASE instituto;

-- Selecciono la base de datos instituto

USE instituto;

-- Crea la tabla profesores
create table profesores (
	DNI char(9) primary key,
    Nombre VARCHAR(40) not null,
    Direccion varchar(50) not null,
	Telefono varchar(15) not null
);

-- Crea la tabla modulo
create table modulo (
	Codigo varchar(10) primary key,
    Nombre varchar(40) not null,
    Curso varchar(10) not null,
    DNI_profesor char(9),
    foreign key (DNI_profesor) REFERENCES profesores(DNI)
);    

-- Crea la tabla alumnos
create table alumnos (
	n_exp varchar(10) primary key,
    Nombre varchar(40) not null,
    Apellidos varchar(50) not null,
    Fecha_Nac date not null,
    N_exp_delegado varchar(10),
    Grupo varchar(10),
    foreign key (N_exp_delegado) references alumnos(n_exp)
);	

-- Creamos la tabla matriculaciones
create table matriculaciones (
	n_exp varchar(10) references alumnos(n_exp),
    Codigo_modulo varchar(10) references modulo(Codigo),
    primary key (n_exp, codigo_modulo)
    -- foreign key (n_exp) references alumnos (n_exp),
    -- foreign key (codigo_modulo) references modulo (codigo)
);
    
    
Show tables; 

describe profesores;
describe modulo;
describe alumnos;
describe matriculaciones;


-- Insertar filas en la tabla profesores
insert into profesores (DNI, Nombre, Direccion, Telefono) values ('27896123Z','Antonio Muñoz', 'Av, Carlos Haya', '951455688');
insert into profesores (DNI, Nombre, Direccion, Telefono) values ('33490868E','Luis Salas', 'Av, Playamar', '951455000');

-- Modificar el tipo de dato de la columna Codigo de la tabla modulo
alter column modulos modify codigo int primary key;
-- Insertar filas en la tabla modulos
insert into modulos (DNI, Nombre, Direccion, Telefono) values ('0484','Base de Datos', 'Av, Carlos Haya', '951455688');