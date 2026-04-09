USE jardineria;

-- 1) Selecciona aquellos clientes que hayan hecho algún pedido a partir de 2008.

SELECT DISTINCT Cliente.* FROM Cliente INNER JOIN Pedido ON
Cliente.Codigo_Cliente=Pedido.Codigo_Cliente  
WHERE YEAR(Fecha_Pedido) >= 2008;

-- 2) Selecciona aquellos clientes que hayan hecho pedidos que 
-- contengan algún producto con una cantidad menor a 10 unidades.
SELECT DISTINCT cliente.* FROM Cliente 
INNER JOIN (Pedido INNER JOIN Detalle_Pedido ON
Pedido.Codigo_Pedido= Detalle_Pedido.Codigo_Pedido) 
ON Cliente.Codigo_Cliente=Pedido.Codigo_Cliente
WHERE Cantidad < 10;

-- 3) Selecciona aquellos empleados que trabajen en la oficina de Madrid.
SELECT Empleado.* FROM Empleado INNER JOIN Oficina ON
Empleado.Codigo_Oficina=Oficina.Codigo_Oficina  
WHERE Ciudad= 'Madrid';

-- 4) Selecciona aquellos clientes que hayan efectuado pagos con PayPal.
SELECT DISTINCT Cliente.*, Pago.forma_pago 
FROM Cliente INNER JOIN Pago ON
Cliente.Codigo_Cliente=Pago.Codigo_Cliente 
WHERE Forma_Pago='PayPal';

-- 5) Selecciona aquellos clientes que hayan efectuado pagos que no sea con PayPal.
SELECT DISTINCT Cliente.* FROM Cliente INNER JOIN Pago ON
Cliente.Codigo_Cliente=Pago.Codigo_Cliente WHERE Forma_Pago != 'PayPal';

-- 6) Selecciona aquellos empleados que sean jefes.
SELECT DISTINCT jefe.* FROM Empleado AS Jefe INNER JOIN Empleado ON
Jefe.Codigo_Empleado= Empleado.Codigo_Jefe;

SELECT * FROM empleado WHERE codigo_Empleado 
IN (SELECT codigo_Jefe FROM empleado);

-- 7) Selecciona aquellos empleados que no sean jefes.
SELECT e.* FROM empleado e LEFT JOIN empleado e2
ON e.codigo_empleado = e2.codigo_jefe
WHERE e2.codigo_jefe IS NULL;

SELECT * FROM Empleado
EXCEPT
SELECT DISTINCT Empleado.* FROM Empleado 
INNER JOIN Empleado jefe ON
Empleado.Codigo_Empleado= jefe.Codigo_Jefe;

SELECT * FROM empleado WHERE codigo_Empleado 
NOT IN (SELECT codigo_Jefe FROM empleado 
WHERE codigo_Jefe IS NOT NULL);

-- 8) Selecciona todos los empleados que sean jefes en España.
SELECT DISTINCT e.* FROM empleado e INNER JOIN empleado em
ON e.codigo_empleado= em.codigo_jefe INNER JOIN oficina o
ON o.codigo_oficina= e.codigo_oficina
WHERE o.pais= 'España';

-- 9) Selecciona aquellos clientes cuyo límite de crédito sea superior, 
-- al menos, al de algunos de los clientes de su mismo país.
SELECT DISTINCT c1.* FROM cliente c1 INNER JOIN cliente c2
ON c1.pais= c2.pais
WHERE c1.Limite_Credito > c2.Limite_Credito;

SELECT DISTINCT Cliente.* FROM Cliente 
INNER JOIN Cliente c
ON Cliente.Limite_Credito > c.Limite_Credito 
WHERE Cliente.Pais = c.Pais;

-- 10) Selecciona aquellos clientes que hayan hecho, 
-- al menos, 5 pedidos durante el año 2009.

SELECT c.* FROM cliente c 
INNER JOIN pedido p 
ON c.codigo_cliente=p.codigo_cliente
WHERE YEAR(p.fecha_pedido)= 2009
GROUP BY codigo_cliente
HAVING count(p.codigo_pedido) >= 5; 

-- 11) Mostrar aquellos empleados 
-- que sean representantes de ventas de algún cliente de Madrid.
SELECT DISTINCT Empleado.* FROM Empleado 
INNER JOIN Cliente ON Empleado.Codigo_Empleado =
Cliente.Codigo_Empleado_Rep_Ventas 
WHERE Cliente.Ciudad = 'Madrid';

-- 12) Mostrar aquellos clientes que tengan algún pedido pendiente.
SELECT DISTINCT c.*, p.* FROM cliente c 
INNER JOIN pedido p 
ON c.codigo_cliente= p.codigo_cliente
WHERE p.estado='Pendiente';

-- 13) Mostrar aquellos clientes que tengan algún pedido rechazado desde 2006.
SELECT c.* FROM cliente c INNER JOIN pedido p 
ON c.codigo_cliente=p.codigo_cliente
WHERE YEAR(p.fecha_pedido) >= 2006 AND (p.estado= 'Rechazado');

-- 14) Mostrar aquellos pedidos que tengan al menos 6 productos distintos.
SELECT p.* FROM pedido p INNER JOIN detalle_pedido dp 
ON p.codigo_pedido= dp.codigo_pedido
GROUP BY dp.codigo_pedido
HAVING count(DISTINCT dp.codigo_producto) >= 6;

-- 15) Mostrar aquellos clientes cuyos representantes de ventas 
-- alguno tenga su oficina en España.

SELECT DISTINCT c.* FROM cliente c INNER JOIN empleado e 
ON c.codigo_empleado_rep_ventas= e.codigo_empleado 
INNER JOIN oficina o ON e.codigo_oficina= o.codigo_oficina
WHERE o.pais='España';

-- 16) Mostrar aquellos empleados que no tengan como jefe a Carlos Soria.
SELECT e.*, j.* FROM empleado e LEFT JOIN empleado j 
ON e.codigo_jefe= j.codigo_empleado
WHERE NOT (j.nombre = 'Carlos' AND j.apellido1='Soria')
OR j.codigo_empleado IS NULL;

SELECT * FROM Empleado WHERE codigo_jefe IN (
SELECT codigo_Empleado FROM empleado 
WHERE NOT (Nombre = 'Carlos' AND Apellido1 = 'Soria')) OR codigo_jefe IS NULL; 

-- 17) Mostrar aquellos productos de los que se hayan pedido más de 50 unidades.

SELECT DISTINCT p.* FROM producto p INNER JOIN detalle_pedido dp
ON p.codigo_producto=dp.codigo_producto
WHERE dp.cantidad > 50;

-- 18) Muestra aquellos productos cuyo precio de venta 
-- sea mayor que el de la media.

SELECT * FROM Producto INNER JOIN 
(SELECT AVG(Precio_Venta) AS PrecioVentaMedio FROM
Producto) Media 
ON Producto.Precio_Venta > Media.PrecioVentaMedio;

SELECT * FROM Producto 
WHERE Precio_Venta > (SELECT AVG(Precio_Venta) FROM Producto);