
USE reservas;

-- SETENCIA INSERT (inserta filas en una tabla)

-- Insertamos un nuevo usuario en la tabla usuarios 
INSERT INTO usuarios (id, dni, nombre, apellidos, email, ciudad, descuento,
fecha_nacimiento, fecha_alta)
VALUES (100, '12345678A', 'Antonio', 'García', 'agarcia@gmail.com', 'Málaga', 0.25, 
'1990-12-12', '2020-12-04');

-- Como se inserta una fila con todos los valores de los campos, no haría falta 
-- especificar los nombres de los campos. Aunque el orden de los valores debe 
-- coincidir con el orden que tienen los campos cuando se creó la tabla.
INSERT INTO usuarios
VALUES (200, '12345677A', 'Miguel', 'García', 'magarcia@gmail.com', 'Zaragoza',
'1990-12-12', 0.3, '2003-02-01');

-- Inserta una fila con todos los valores de los campos, excepto el campo fecha de 
-- nacimiento que no es obligatorio.
INSERT INTO usuarios (id, dni, nombre, apellidos, email, ciudad, descuento, fecha_alta)
VALUES (45, '12345679A', 'Luis', 'García', 'lgarcia@gmail.com', 'Málaga', 0.15, 
'1990-12-12');

-- Se puede insertar varias filas usando el mismo comando INSERT
INSERT INTO usuarios (id, dni, nombre, apellidos, email, ciudad, descuento, fecha_alta) 
VALUES (300, '12345678A', 'Pepe', 'Sanz', 'psanz@gmail.com', 'Málaga', 0.25, '1990-12-12'), 
(301, '98765432Z', 'Luis', 'Peréz', 'lperez@gmail.com', 'Málaga', 0.25, '1988-01-03');

-- Creamos una nueva tabla llamada otros_usuarios exactamente igual a la tabla usuarios
CREATE TABLE otros_usuarios LIKE usuarios;

-- Insertamos en la tabla otros_usuarios, que está vacía, 
-- las filas devueltas por la instrucción SELECT
INSERT INTO otros_usuarios (id, dni, nombre, apellidos, email, descuento, ciudad, fecha_alta)
SELECT id, dni, nombre, apellidos, email, descuento, ciudad, fecha_alta
FROM usuarios;

-- SENTENCIA DELETE (elimina filas de una tabla)
-- Borramos todas las filas de la tabla otros_usuarios
DELETE FROM otros_usuarios;

-- Desactivar modo seguro en actualizaciones y eliminaciones
select @@sql_safe_updates;
SET sql_safe_updates=0;

-- Elimina la pista cuyo id es 10
DELETE FROM pistas WHERE id = 10;

-- Elimina las pistas de baloncesto con código igual a 'BAL001'
DELETE FROM pistas WHERE tipo = 'baloncesto' OR codigo = 'BAL001';

-- Elimina los usuarios que se dieron de alta antes de 2014 
-- y aún no han reservado ninguna pista 
DELETE FROM usuarios 
WHERE id NOT IN (SELECT id_usuario FROM usuario_reserva) 
AND fecha_alta < '2014-01-01';

-- Borraría todas las filas de la tabla usuarios 
DELETE FROM usuarios;

-- Al usuario con id = 12 le ponemos como nombre "Felipe"
UPDATE usuarios SET nombre = 'Felipe' WHERE id = 12;

UPDATE usuarios SET nombre = 'Felipe', dni = '12365478H' WHERE id = 15;

-- Incrementa el precio en un 10% de las pistas de tenis que tengan un precio actual inferior a 20 € 
UPDATE pistas 
SET precio = precio + precio * 0.10 
WHERE precio < 20 AND tipo = 'tenis';

-- Reduce el precio de las pistas que no se han reservado todavía en un 10% 
UPDATE pistas 
SET precio = precio - precio * 0.1 
WHERE id NOT IN (SELECT id_pista FROM reservas);

