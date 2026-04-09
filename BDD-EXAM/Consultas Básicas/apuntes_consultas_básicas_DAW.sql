USE reservas;
-- Muestra los nombres de los usuarios
SELECT nombre
FROM usuarios
ORDER BY nombre;

-- Muestra los nombres de los usuarios sin repeticiones
SELECT DISTINCT nombre
FROM usuarios
ORDER BY nombre;

-- Muestra los apellidos y nombre de los usuarios ordenados
-- por ambos campos, de forma descendente por apellidos y
-- ascendente por nombre
SELECT DISTINCT apellidos, nombre
FROM usuarios
ORDER BY apellidos DESC, nombre;

-- Muestra toda la información de todos los usuarios 
SELECT * FROM usuarios;

-- Muestra el nombre y dirección de los polideportivos de Zaragoza 
SELECT nombre, direccion, ciudad 
FROM polideportivos 
WHERE ciudad = 'Zaragoza';

-- Usando un alias para los campos nombre y apellidos 
SELECT nombre "nom", apellidos "apell"
FROM usuarios 
ORDER BY nombre ASC;

-- Usando la función CONCAT para concatenar los apellidos y el nombre 
-- en una sola columna
SELECT CONCAT(apellidos, ', ', nombre) "Apellidos y nombre"
FROM usuarios 
ORDER BY apellidos, nombre;

-- Muestra los usuarios cuyo descuento sea distinto a 0.1
SELECT * FROM usuarios 
WHERE ROUND(descuento, 2) != 0.1;

-- Muestra todos los usuarios que no sean de Zaragoza
SELECT *
FROM usuarios
WHERE ciudad != 'Zaragoza';

SELECT *
FROM usuarios
WHERE NOT ciudad = 'Zaragoza';

-- Muestra todos los usuarios que sean de Zaragoza y Soria
SELECT *
FROM usuarios
WHERE ciudad = 'Zaragoza' OR ciudad = 'Soria';

-- Muestra los usuarios que sean de Zaragoza y Soria y además, hayan nacido a partir del año 2013
SELECT *
FROM usuarios
WHERE (ciudad = 'Zaragoza' OR ciudad = 'Soria') AND fecha_nacimiento >= '2013-01-01';

-- Nombre de los polideportivos que están en una ciudad
-- cuyo nombre empieza por Z y tiene 8 caracteres
SELECT nombre, ciudad
FROM polideportivos
WHERE ciudad LIKE 'Z_______';

-- Muestra los usuarios cuyo nombre empiece por B y termine en A.
SELECT *
FROM usuarios
WHERE nombre LIKE 'B%a'; 

-- Muestra los usuarios cuyo nombre tenga 6 caracteres.
SELECT *
FROM usuarios
WHERE nombre LIKE '______'; 

-- Nombre y extensión de los polideportivos de 
-- Zaragoza, Huesca y Teruel
SELECT nombre, extension, ciudad
FROM polideportivos 
WHERE ciudad IN ('Zaragoza', 'Huesca', 'Teruel');

SELECT nombre, extension, ciudad
FROM polideportivos 
WHERE ciudad = 'Zaragoza' OR ciudad = 'Huesca' OR ciudad='Teruel';

-- Muestra los usuarios que no vivan ni en Huesca ni en Teruel usando el operador IN.
SELECT *
FROM usuarios
WHERE ciudad NOT IN ('Huesca', 'Teruel');  

-- Muestra los usuarios cuya fecha de nacimiento esté comprendida entre el día 1 de enero de 2013 y el
-- día 31 de diciembre de 2014
SELECT *
FROM usuarios
WHERE fecha_nacimiento BETWEEN '2013-01-01' AND '2014-12-31'
ORDER BY fecha_nacimiento;

SELECT *
FROM usuarios
WHERE fecha_nacimiento >= '2013-01-01' AND fecha_nacimiento <= '2014-12-31';

-- Mostramos las 10 primeras filas de la tabla usuarios ordenadas por apellidos y nombre
SELECT *
FROM usuarios
ORDER BY apellidos, nombre
LIMIT 10;

-- Muéstrame el último usuario de la tabla ordenada por apellidos y nombre
SELECT *
FROM usuarios
ORDER BY apellidos DESC, nombre DESC
LIMIT 1;

--  FUNCIONES AGREGADAS O DE RESUMEN

-- 1) FUNCIÓN COUNT()
-- Número de pistas  
SELECT COUNT(*) "Nº pistas"
FROM pistas; 

 -- Número de polideportivos en Zaragoza 
SELECT COUNT(*) 
FROM polideportivos 
WHERE ciudad = 'Zaragoza';

-- 2) FUNCIÓN SUM()
-- Cuánto dinero costaría alquilar todas las pistas del polideportivo cuyo id es 23 
SELECT SUM(precio) 
FROM pistas 
WHERE id_polideportivo = 23;

-- Cuánto vale la pista más barata 
SELECT MIN(precio) 
FROM pistas; 

-- Cuánto vale la pista más cara 
SELECT MAX(precio) 
FROM pistas; 

-- Cuál es el precio medio de las pistas 
SELECT AVG(precio) 
FROM pistas; 


-- FUNCIONES ESCALARES

-- Convierte una cadena de caracteres en mayúsculas
SELECT UPPER('SQL es un lenguaje de consulta estructurado'); 

SELECT UPPER(nombre) "Nombre"
FROM usuarios;

-- Convierte una cadena de caracteres en minúsculas
SELECT LOWER('SQL es un lenguaje de consulta estructurado');

-- Devuelve la longitud de una cadena de caracteres
SELECT LENGTH('SQL es un lenguaje de consulta estructurado'); 

-- Une cadena de caracteres
SELECT CONCAT('Buenos', ' días'); 

SELECT CONCAT(apellidos, ', ', nombre) "Apellidos y nombre"
FROM usuarios;

-- Elimina espacios en blanco al principio y al final de la cadena de caracteres
SELECT TRIM('     ¡Curso de SQL!     '); 

-- Reemplaza un caracter por otro dentro de una cadena
SELECT REPLACE('ABC ABC ABC', 'AB', 'C'); 

-- Invierte una cadena de caracteres
SELECT REVERSE('AGALAM'); 

-- Devuelve la fecha y hora actual
SELECT SYSDATE(); 
SELECT NOW();

-- Redondea el número a dos decimales 
SELECT ROUND(235.415, 2); 

-- Muestra los usuarios que hayan nacido en el 2013 ordenados por fecha de nacimiento 
-- Opción 1: Usando DATE_ADD
SELECT * FROM usuarios 
WHERE fecha_nacimiento >= '2013-01-01' AND fecha_nacimiento < DATE_ADD('2013-01-01', INTERVAL 1 YEAR) 
ORDER BY fecha_nacimiento;

-- Opción 2: Forma simplificada
SELECT * FROM usuarios 
WHERE fecha_nacimiento >= '2013-01-01' AND fecha_nacimiento < '2013-01-01' + INTERVAL 1 YEAR
ORDER BY fecha_nacimiento;

-- Muestra el resultado de sumar 12 meses o 365 días a la fecha indicada 
SELECT DATE_ADD('2013-01-01', INTERVAL 12 MONTH);
SELECT '2013-01-01' + INTERVAL 12 MONTH;
SELECT '2013-01-01' + INTERVAL 365 DAY;

-- Muestra la diferencia en días entre las dos fechas indicadas
SELECT DATEDIFF('2022-02-23', '2022-01-01');

SELECT DATEDIFF('2022-01-01', '2022-02-23');
SELECT '2013-01-01' - INTERVAL 12 MONTH;

-- CONSULTAS DE RESUMEN USANDO GROUP BY
-- ¿ Cuántos polideportivos hay en cada ciudad?

SELECT ciudad, COUNT(*) N_polideportivos
FROM polideportivos
GROUP BY ciudad
ORDER BY ciudad;

-- ¿Cuántos usuarios hay en cada ciudad?
SELECT ciudad, COUNT(*) AS N_usuarios
FROM usuarios
GROUP BY ciudad
ORDER BY ciudad;

-- ¿Cuántos polideportivos hay en cada ciudad, solamente de aquellas
-- ciudades donde hay más de 10?
-- Si usamos la cláusula WHERE para especificar una condición al 
-- agrupamiento nos dará un error. Por tanto, habrá que utilizar la 
-- cláusula HAVING.
SELECT ciudad, COUNT(*) AS N_polideportivos
FROM polideportivos
WHERE COUNT(*) > 10
GROUP BY ciudad
ORDER BY ciudad;

-- Usamos la cláusula HAVING. 
SELECT ciudad, COUNT(*) AS N_polideportivos
FROM polideportivos
GROUP BY ciudad
HAVING COUNT(*) > 10
ORDER BY ciudad;

-- ¿Cuántas pistas de cada deporte hay?
SELECT tipo, COUNT(*) AS N_pistas
FROM pistas
GROUP BY tipo
ORDER BY tipo;

-- ¿Cuántas pistas de cada deporte hay, 
-- pero solo muéstrame los deportes con más de 50 pistas?
SELECT tipo, COUNT(*) AS N_pistas
FROM pistas
GROUP BY tipo
HAVING COUNT(*) > 50
ORDER BY tipo;

-- Quiero saber el precio promedio de cada tipo de pista
SELECT tipo, ROUND(AVG(precio),2) AS precio_promedio 
FROM pistas
GROUP BY tipo
ORDER BY tipo;

-- Quiero saber los tipos de pistas que tienen un precio medio mayor a 9 €
SELECT tipo, ROUND(AVG(precio),2) AS precio_promedio 
FROM pistas
GROUP BY tipo
HAVING AVG(precio) > 9
ORDER BY tipo;

-- ¿Cuál es la pista más barata y muéstrame su tipo?
SELECT tipo, MIN(precio) precio_minimo
FROM pistas
GROUP BY tipo
ORDER BY MIN(precio) 
LIMIT 1;

-- ¿Cuál es la pista más cara y muéstrame su tipo?
SELECT tipo, MAX(precio) precio_maximo
FROM pistas
GROUP BY tipo
ORDER BY MAX(precio) DESC
LIMIT 1;


-- CONSULTAS MULTITABLAS

-- Mostramos la información de las pistas con sus reservas
SELECT pistas.id 'pistas_id', codigo, tipo, reservas.id 'reservas_id',
fecha_reserva, fecha_uso
FROM pistas, reservas
WHERE pistas.id = reservas.id_pista
ORDER BY pistas.id;

-- Muéstrame toda la información de los usuarios (dni, nombre, apellidos, 
-- ciudad, fecha_nacimiento, id_reserva, asiste) que hicieron alguna reserva
-- Ordenar la consulta por apellidos y nombre

-- Realiza un producto cartesiano. Comparando cada fila de la tabla usuarios con todas
-- las filas de la tabla usuario_reserva. Por tanto, el nº de filas que devuelve la consulta será:
-- Nº filas (usuarios) x Nº filas (usuarios_reserva) = 102 x 268 = 27336 
SELECT id, dni, nombre, apellidos, ciudad, fecha_nacimiento, id_reserva, asiste, id_usuario
FROM usuarios, usuario_reserva; 

-- Hay que incluir una condición en la cláusula WHERE para que solo muestre las reservas
-- verdaderas que realizaron cada usuario 
SELECT id, dni, nombre, apellidos, ciudad, fecha_nacimiento, id_reserva, asiste, id_usuario
FROM usuarios, usuario_reserva 
WHERE usuarios.id = usuario_reserva.id_usuario
ORDER BY apellidos, nombre;

-- Mostrar toda la información de los polideportivos junto con las pistas 
-- que tienen cada uno de ellos
SELECT polideportivos.* , pistas.*
FROM polideportivos INNER JOIN pistas
ON polideportivos.id = pistas.id_polideportivo
 
