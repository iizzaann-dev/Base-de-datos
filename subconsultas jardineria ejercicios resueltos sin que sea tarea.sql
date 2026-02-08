-- RELACI�N DE EJERCICIOS DE SUBCONSULTAS
USE jardineria;
-- Subconsultas que devuelven un solo valor.
-- 1) Obtén el nombre de aquel cliente que haya efectuado
-- más pagos en Paypal

select nombre_cliente from cliente
where codigo_cliente= (select codigo_cliente
FROM pago 
WHERE forma_pago = 'Paypal' 
GROUP BY codigo_cliente
ORDER BY count(*) DESC
limit 1);

-- Operador IN (base de datos jardiner�a)
-- 2) Selecciona aquellos nombres de clientes que hayan hecho alg�n pedido en 2008.
SELECT nombre_cliente FROM cliente 
WHERE codigo_cliente IN 
(SELECT DISTINCT codigo_cliente 
from pedido where year(Fecha_Pedido)=2008);

-- 3) Selecciona aquellos empleados que trabajen en la oficina de Madrid.
SELECT * FROM empleado WHERE codigo_oficina 
NOT IN (SELECT codigo_oficina FROM oficina WHERE ciudad = 'Madrid');

-- 4) Selecciona aquellos clientes que hayan efectuado pagos con PayPal.
SELECT * FROM cliente WHERE codigo_cliente 
IN (SELECT DISTINCT codigo_cliente FROM pago WHERE forma_pago = 'PayPal');

-- 5) Selecciona aquellos clientes que hayan efectuado pagos que no sea con PayPal.
SELECT * FROM cliente WHERE codigo_cliente 
IN (SELECT codigo_cliente FROM pago WHERE forma_pago = 'PayPal');

-- 6) Selecciona aquellos empleados que sean jefes.
SELECT * FROM empleado WHERE codigo_empleado 
IN (SELECT DISTINCT codigo_jefe FROM empleado);

-- 7) Selecciona aquellos empleados que no sean jefes.
SELECT * FROM empleado WHERE codigo_empleado 
NOT IN (SELECT codigo_jefe FROM empleado WHERE codigo_jefe IS NOT NULL);
select * from Empleado where codigo_empleado not in (selet codigo_jefe from Empleado);
-- O bien:
SELECT * FROM Empleado 
WHERE Codigo_Empleado NOT IN (SELECT Coalesce(Codigo_Jefe, 0) FROM Empleado);

-- 8) Selecciona todos los empleados que sean jefes en Espa�a.
SELECT * FROM empleado WHERE codigo_empleado 
IN (SELECT codigo_jefe FROM empleado 
WHERE codigo_jefe IS NOT NULL and codigo_oficina LIKE '%ES');
-- Otra forma de hacerlo con varias subconsultas ser�a:
SELECT * FROM empleado WHERE codigo_empleado 
IN (SELECT codigo_jefe FROM empleado WHERE codigo_jefe IS NOT NULL) 
and codigo_oficina IN (SELECT codigo_oficina FROM oficina WHERE pais LIKE 'Espa_a');

-- Operador ANY o SOME 
-- 9) Selecciona aquellos clientes cuyo l�mite de cr�dito sea superior, al menos, al de algunos de los clientes. 
SELECT * FROM Cliente
WHERE Limite_Credito > SOME (SELECT Limite_Credito FROM Cliente); 

-- 10) Selecciona aquellos clientes que hayan hecho, al menos, 5 pedidos durante el a�o 2009. 
SELECT * FROM Cliente 
WHERE Codigo_Cliente = ANY (SELECT Codigo_Cliente
FROM Pedido WHERE YEAR(Fecha_Pedido)='2009' 
GROUP BY Codigo_Cliente HAVING count(*) >=5);
-- Ser�a equivalente la siguiente consulta usando el operador IN: 
SELECT * FROM Cliente WHERE Codigo_Cliente 
IN (SELECT Codigo_Cliente FROM Pedido WHERE YEAR(Fecha_Pedido)='2009' 
GROUP BY Codigo_Cliente HAVING count(*) >=5);

-- 11) Mostrar aquellos empleados que sean representantes de ventas de alg�n cliente de Madrid. 
SELECT * FROM Empleado
WHERE Codigo_Empleado = ANY (SELECT Codigo_Empleado_Rep_Ventas 
FROM Cliente WHERE Ciudad = 'Madrid');

-- 12) Mostrar aquellos clientes que tengan alg�n pedido pendiente. 
SELECT * FROM Cliente 
WHERE Codigo_Cliente = ANY (SELECT Codigo_Cliente FROM Pedido 
WHERE Estado = 'Pendiente');

-- 13) Mostrar aquellos clientes que tengan alg�n pedido rechazado desde 2006. 
SELECT * FROM Cliente 
WHERE Codigo_Cliente = ANY (SELECT Codigo_Cliente FROM Pedido 
WHERE (Estado = 'Rechazado') AND (Fecha_Pedido >= '2006-01-01')); 

-- 14) Mostrar aquellos pedidos que tengan al menos 6 productos distintos. 
SELECT * FROM Pedido WHERE Codigo_Pedido= ANY (SELECT Codigo_Pedido 
FROM Detalle_Pedido GROUP BY Codigo_Pedido HAVING COUNT(*) >= 6); 

-- OPERADOR ALL
-- 15) Mostrar aquellos clientes que tengan su l�mite de cr�dito mayor a todos
SELECT * FROM Cliente
WHERE Limite_Credito >= ALL (SELECT Limite_Credito FROM Cliente);
-- es equivalente a:
SELECT * FROM Cliente
WHERE Limite_Credito = (SELECT MAX(Limite_Credito) FROM Cliente);

-- OPERADOR EXISTS 
-- 16) Mostrar aquellos clientes cuyos representantes de ventas alguno 
-- tenga su c�digo de oficina que termine en '-ES'. 
SELECT * FROM Cliente WHERE EXISTS (
SELECT * FROM Empleado
WHERE Codigo_Oficina LIKE '%-ES' 
AND Cliente.Codigo_Empleado_Rep_Ventas=Codigo_Empleado);

-- 17) Mostrar aquellos empleados que no tengan como jefe a Carlos Soria. 
SELECT * FROM Empleado e WHERE NOT EXISTS (SELECT * FROM Empleado
WHERE Nombre = 'Carlos' AND Apellido1 = 'Soria' 
AND Codigo_Empleado=e.Codigo_Jefe);

-- 18) Mostrar aquellos productos de los que se hayan pedido m�s de 50 unidades. 
SELECT * FROM Producto WHERE EXISTS 
(SELECT * FROM Detalle_Pedido
WHERE Cantidad > 50 AND Producto.Codigo_Producto=Codigo_Producto); 

-- 19) Mostrar aquellos empleados que no son jefes. 
SELECT * FROM Empleado e WHERE NOT EXISTS 
(SELECT * FROM Empleado WHERE Codigo_Jefe=e.Codigo_Empleado);