-- Ejercicios del DML

-- Creamos una base de datos
CREATE DATABASE prueba_DML;

USE prueba_DML;

-- Creamos una tabla llamada usuarios
CREATE TABLE usuarios (
id int PRIMARY KEY,
dni CHAR(9),
nombre VARCHAR(20),
apellidos VARCHAR(20),
email VARCHAR(20),
ciudad VARCHAR(20),
fecha_nacimiento DATE,
descuento numeric(3,2),
fecha_alta DATE);

-- Insertamos una fila en la tabla usuarios
INSERT INTO usuarios (id, dni, nombre, apellidos, email, ciudad, descuento,
fecha_nacimiento, fecha_alta)
VALUES (101, '12345678A', 'Antonio', 'Garc�a', 'agarcia@gmail.com', 'M�laga', 
0.25, '1990-12-12', '2020-12-04');

-- Insertamos otras dos filas pero omitimos la columna, fecha_nacimiento
INSERT INTO usuarios (id, dni, nombre, apellidos, email, ciudad, descuento,
fecha_alta)
VALUES (300, '12345678A', 'Pepe', 'Sanz', 'psanz@gmail.com', 'M�laga', 0.25, '1990-12-12'),
(301, '98765432Z', 'Luis', 'Per�z', 'lperez@gmail.com', 'M�laga', 0.25, '1988-01-03');

-- Mostramos las filas de la tabla usuarios
SELECT * FROM usuarios;

-- Creamos una tabla llamada otros_usuarios exactamente igual a la tabla usuarios
create table otros_usuarios like usuarios;

-- Insertamos en la tabla otros_usuarios, que está vacia, las filas devueltas por la instruccion select
SELECT id, dni, nombre, apellidos, email, descuento, fecha_alta INTO otros_usuarios
FROM usuarios;


SELECT * FROM otros_usuarios;

-- Borramos la tabla otros_usuarios
DROP TABLE otros_usuarios;

SELECT * INTO otros_usuarios
FROM usuarios;

SELECT * FROM otros_usuarios;

-- Insertamos en la tabla otros_usuarios, que est� vac�a, las filas devueltas por la instrucci�n SELECT
INSERT INTO otros_usuarios (id, dni, nombre, apellidos, email, descuento, fecha_alta)
SELECT id, dni, nombre, apellidos, email, descuento, fecha_alta
FROM usuarios;

SELECT * FROM usuarios;

-- Cambiamos la ciudad al usuario con id = 100 a madrid
UPDATE usuarios SET ciudad='Madrid' WHERE id=100;

-- Cambiamos la ciudad al usuario cuyo nombre y apellidos sean Pepe Sanz
UPDATE usuarios SET ciudad= 'Madrid' WHERE nombre='Pepe' AND apellidos='Sanz';

-- Actualizamos la ciudad de todos los usuarios a Malaga
UPDATE usuarios SET ciudad='M�laga';

DELETE FROM usuarios WHERE nombre = 'Pepe';

