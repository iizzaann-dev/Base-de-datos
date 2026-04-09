-- Ejercicios del DML

-- Creamos una base de datos 
CREATE DATABASE prueba_DML;

-- Seleccionamos la base de datos
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

-- Insertamos una fila en la tabla usuarios usando todas las columnas
INSERT INTO usuarios (id, dni, nombre, apellidos, email, ciudad, descuento,
fecha_nacimiento, fecha_alta)
VALUES (101, '12345678A', 'Antonio', 'García', 'agarcia@gmail.com', 'Málaga', 
0.25, '1990-12-12', '2020-12-04');

-- Insertamos 2 filas omitiendo la columna fecha_nacimiento
INSERT INTO usuarios (id, dni, nombre, apellidos, email, ciudad, descuento, fecha_alta)
VALUES (300, '12345678A', 'Pepe', 'Sanz', 'psanz@gmail.com', 'Málaga', 0.25, '1990-12-12'),
(301, '98765432Z', 'Luis', 'Perez', 'lperez@gmail.com', 'Málaga', 0.25, '1988-01-03');

-- Mostramos las filas de la tabla usuarios
SELECT * FROM usuarios;

-- Creamos una nueva tabla llamada otros_usuarios exactamente igual a la tabla usuarios
CREATE TABLE otros_usuarios LIKE usuarios;

-- Insertamos en la tabla otros_usuarios, que está vacía, las filas devueltas por la instrucción SELECT
INSERT INTO otros_usuarios (id, dni, nombre, apellidos, email, descuento, ciudad, fecha_alta)
SELECT id, dni, nombre, apellidos, email, descuento, ciudad, fecha_alta
FROM usuarios;

-- Mostramos las filas de la tabla otros_usuarios
SELECT * FROM otros_usuarios;

-- Cambiamos la ciudad al usuario con id = 101 a Madrid
UPDATE usuarios SET ciudad='Madrid' WHERE id=101;

-- Cambios la ciudad a Madrid al usuario cuyo nombre y apellidos sea Pepe Sanz
UPDATE usuarios SET ciudad= 'Madrid' WHERE nombre='Pepe' AND apellidos='Sanz';

-- Actualizamos la ciudad de todos los usuarios a Málaga
UPDATE usuarios SET ciudad='Málaga';

-- Eliminamos al usuario cuyo nombre es Pepe
DELETE FROM usuarios WHERE nombre = 'Pepe';

-- Borramos todas las filas de la tabla otros_usuarios
DELETE FROM otros_usuarios;