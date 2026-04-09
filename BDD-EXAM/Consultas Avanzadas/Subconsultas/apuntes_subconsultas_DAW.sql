-- 1. Introducción (Conceptos básicos)
-- Las subconsultas son consultas anidadas dentro de otra sentencia SQL 
-- (SELECT, INSERT, UPDATE o DELETE).

-- Ejercicio 1: Obtener todas las pistas cuyo precio sea superior al 
-- precio medio de todas las pistas.

SELECT * FROM pistas 
WHERE precio > (SELECT AVG(precio) FROM pistas);

-- Ejercicio 2: Listar los usuarios que viven en la misma ciudad que el usuario 
-- con ID 1.

SELECT * FROM usuarios 
WHERE ciudad = (SELECT ciudad FROM usuarios WHERE id = 1);

-- Ejercicio 3: Mostrar los polideportivos situados en la misma ciudad 
-- donde se encuentra el polideportivo 'San José'.

SELECT * FROM polideportivos 
WHERE ciudad = (SELECT ciudad FROM polideportivos WHERE nombre = 'San José');

-- 2. Subconsultas de resultado único
-- Estas subconsultas devuelven una sola fila y una sola columna. 
-- Se usan con operadores de comparación estándar (=, <, >, <=, >=, !=).

-- Ejercicio 1: Obtener el código, tipo y precio de la pista más cara.

SELECT codigo, tipo, precio FROM pistas 
WHERE precio = (SELECT MAX(precio) FROM pistas);

-- Ejercicio 2: Mostrar los datos del usuario que realizó la primera reserva 
-- registrada (la de ID más bajo).

SELECT * FROM usuarios 
WHERE id = (SELECT id_usuario FROM usuario_reserva ORDER BY id_reserva ASC LIMIT 1);

-- Ejercicio 3: Listar las pistas del mismo tipo que la pista con código 'MUVF2634'.

SELECT * FROM pistas 
WHERE tipo = (SELECT tipo FROM pistas WHERE codigo = 'MUVF2634');

-- 3. Subconsultas de lista de valores
-- 3.1 El operador IN con subconsulta
-- Se usa cuando la subconsulta devuelve una columna pero varias filas.

-- Ejercicio 1: Listar los nombres y apellidos de los usuarios 
-- que han realizado alguna reserva.

SELECT * FROM usuarios 
WHERE id IN (SELECT DISTINCT id_usuario FROM usuario_reserva);

-- Ejercicio 2: Mostrar los polideportivos que tienen pistas de tipo 'tenis'.

SELECT * FROM polideportivos
WHERE id IN (SELECT id_polideportivo FROM pistas WHERE tipo = 'tenis');

-- Ejercicio 3: Obtener los datos de las pistas que han estado 
-- cerradas alguna vez (que aparecen en pistas_cerradas).

SELECT * FROM pistas 
WHERE id IN (SELECT id_pista FROM pistas_cerradas);

-- 3.2 La comparación modificada (ANY, ALL)
-- 3.2.1 El test ANY
-- Devuelve verdadero si la comparación es cierta para al menos uno 
-- de los valores de la lista.

-- Ejercicio 1: Buscar pistas que sean más baratas 
-- que alguna de las pistas del polideportivo con ID 1.

SELECT * FROM pistas 
WHERE precio < ANY (SELECT precio FROM pistas WHERE id_polideportivo = 1);

-- Ejercicio 2: Listar usuarios cuyo ID sea mayor que alguno de 
-- los IDs de usuarios de la ciudad de 'Huesca'.

SELECT * FROM usuarios 
WHERE id > ANY (SELECT id FROM usuarios WHERE ciudad = 'Huesca');

-- Ejercicio 3: Seleccionar reservas cuya fecha de uso sea posterior a alguna de las fechas de revisión programadas en pistas_abiertas.

SELECT * FROM reservas 
WHERE fecha_uso > ANY (SELECT proxima_revision FROM pistas_abiertas);

-- 3.2.2 El test ALL
-- Devuelve verdadero si la comparación es cierta para todos los valores de la lista.

-- Ejercicio 1: Obtener la pista cuyo precio sea mayor o igual 
-- que todas las demás pistas (otra forma de sacar el máximo).

SELECT * FROM pistas 
WHERE precio >= ALL (SELECT DISTINCT precio FROM pistas);

-- Ejercicio 2: Listar polideportivos cuyo ID sea menor que 
-- todos los IDs de polideportivos en 'Teruel'.

SELECT * FROM polideportivos
WHERE id < ALL (SELECT id FROM polideportivos WHERE ciudad = 'Teruel');

-- Ejercicio 3: Encontrar pistas que sean más caras que todas las pistas de tipo 'ping-pong'.

SELECT * FROM pistas 
WHERE precio > ALL (SELECT DISTINCT precio FROM pistas WHERE tipo = 'ping-pong');

-- 4. Subconsultas con cualquier número de columnas (EXISTS)
-- El operador EXISTS solo comprueba si la subconsulta devuelve alguna fila, 
-- sin importar el contenido de las columnas.

-- Ejercicio 1: Mostrar los usuarios que han asistido como invitados a alguna reserva
-- (tabla usuario_usuario).

SELECT * FROM usuarios u
WHERE EXISTS (SELECT 1 FROM usuario_usuario uu WHERE uu.id_amigo = u.id);

-- Ejercicio 2: Seleccionar las pistas que actualmente están abiertas
-- (existen en la tabla pistas_abiertas).

SELECT * FROM pistas p
WHERE EXISTS (SELECT 1 FROM pistas_abiertas pa WHERE pa.id_pista = p.id);

-- Ejercicio 3: Listar los polideportivos que tienen 
-- al menos una pista cuyo precio por hora sea superior a 10€.

SELECT *
FROM polideportivos po
WHERE EXISTS (
    SELECT 1
    FROM pistas pi
    WHERE pi.id_polideportivo = po.id
    AND pi.precio > 10
);
-- Ejercicio 4: Muestra el dni, nombre, apellidos, email y 
-- ciudad de los usuarios que nunca han hecho una reserva

SELECT u.dni, u.nombre, u.apellidos, u.email, u.ciudad
FROM usuarios u
WHERE NOT EXISTS (
    SELECT 1
    FROM usuario_reserva ur
    WHERE ur.id_usuario = u.id
);