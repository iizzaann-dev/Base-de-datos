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
    -- foreign key (DNI_profesor) REFERENCES profesores(DNI),
    constraint dni_profesor_fk foreign key(DNI_profesor) references profesores(DNI)
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
    on delete cascade on update cascade
);	

-- Creamos la tabla matriculaciones
create table matriculaciones (
	n_exp_alumno varchar(10) references alumnos(n_exp),
    Codigo_modulo varchar(10),
    primary key (n_exp_alumno, codigo_modulo),
	foreign key (n_exp_alumno) references alumnos(n_exp)
	on delete cascade on update cascade
);
    
-- Elimina la clave foranea de la tabla modulo
alter table modulo drop foreign key dni_profesor_fk;

-- Elimina la clave primaria de la tabla modulo
alter table modulo drop primary key;

-- Modificar el tipo de dato de la columna Codigo de la tabla modulo
alter table modulo modify Codigo int(4) zerofill;

-- Vuelve a crear la primary key en la tabla modulo
alter table modulo add primary key (Codigo);

-- Vuelve a crear la primarey key  DNI_profesor en la tabla modulo
alter table modulo add constraint dni_profesor_fk foreign key (DNI_profesor) references profesores(DNI);

-- Modificamos la columna Codigo_modulo (FK) a INT (4) ZEROFILL para que coincida con el tipo de datos que tiene la columna codigo en la tabla modulo
alter table matriculaciones modify Codigo_modulo int (4) zerofill;

-- Crea la foreign key Codigo_modulo en la tabla matriculaciones
alter table matriculaciones add constraint Codigo_modulo_fk foreign key (Codigo_modulo) references modulo (Codigo);


-- Insertar filas en la tabla profesores
insert into profesores (DNI, Nombre, Direccion, Telefono) values ('17896123Z','Antonio Muñoz', 'Av, Carlos Haya', '951455688'),
('33496123A','Luis Salas', 'Av, Playamar', '951455000');

-- Muestro las filas de las tablas profesores
select * from profesores;

-- Inserta dos filas en la tabla modulo
insert into modulo (Codigo, Nombre, Curso, DNI_profesor) values
('485', 'Programación', '1ºDAW', '17896123Z'),
('484', 'Base de datos', '1ºDAW', '33496123A');

-- Muestra las filas de la tabla modulos
select * from modulo; 

insert into alumnos (n_exp, Nombre, Apellidos, Fecha_Nac, N_exp_delegado, Grupo) values
('E325', 'Fernando', 'Gutierrez Hernandez', '2007-10-23', 'E325', '1ºDAW'),
('E326', 'Luis', 'Fernandez Ortiz', '2007-02-10', 'E325', '1ºDAW');

-- Muestra las filas de la tabla alumnos
select * from alumnos;

-- Insertamos 
insert into matriculaciones (N_exp_alumno, Codigo_modulo) values
('E325', 485),
('E326', 484);

-- Muestra filas de la tabla matriculaciones
select * from matriculaciones;

-- Elimina las filas de la tabla matriculacoiones
delete from alumnos where n_exp = 'E326'; 



-- Eliminar clave foránea dni_profesor de la tabla módulos
-- alter table modulo drop foreign key dni_profesor_fk;

-- Modificar el tipo de dato de la columna Codigo de la tabla modulo
-- alter table modulo add constraint dni_profesor_fk foreign key (DNI_profesor) references profesores(DNI);

