-- Nota: Los ejercicios se realizarán sobre la base de datos jardinería.
USE jardineria;

-- 1) Obtener el nombre del producto más caro. Realizar el ejercicio como una
-- subconsulta y luego como una consulta simple para que dicha consulta sea más eficiente.

SELECT nombre FROM producto 
WHERE precio_venta = (SELECT MAX(precio_venta) FROM producto);

SELECT nombre FROM producto 
ORDER BY precio_venta DESC
LIMIT 1;

-- 2) Obtener el nombre del producto del que más unidades se hayan vendido en un mismo pedido.
SELECT nombre FROM producto WHERE codigo_producto = (SELECT codigo_producto
FROM detalle_pedido ORDER BY cantidad DESC LIMIT 1);

-- 3) Obtener el nombre de los clientes que hayan hecho pedidos en 2008.
SELECT DISTINCT c.nombre_cliente FROM cliente c 
WHERE c.codigo_cliente IN (SELECT p.codigo_cliente FROM pedido p WHERE YEAR(p.fecha_pedido) = '2008');

-- 4) Obtener los clientes que han pedido más de 200 unidades de cualquier producto.
SELECT * FROM cliente WHERE codigo_cliente IN (SELECT codigo_cliente FROM pedido 
WHERE codigo_pedido IN (SELECT codigo_pedido FROM detalle_pedido WHERE cantidad > 200));

-- 5) Obtener los clientes que residen en ciudades donde no hay oficinas.
SELECT * FROM cliente WHERE ciudad NOT IN (SELECT ciudad FROM oficina);

-- 6) Obtener el nombre, los apellidos y el email de los empleados a cargo de Alberto Soria.
SELECT nombre, apellido1, apellido2, email 
FROM empleado 
WHERE codigo_jefe = (SELECT codigo_empleado FROM empleado WHERE nombre = "Alberto" AND apellido1="Soria");

-- 7) Obtener el nombre de los clientes a los que no se les ha entregado 
-- a tiempo algún pedido.
SELECT nombre_cliente FROM cliente 
WHERE codigo_cliente IN (SELECT codigo_cliente FROM pedido 
WHERE fecha_entrega > fecha_esperada);

-- 8) Obtener el nombre y teléfono de los clientes que hicieron algún pago en
-- 2007, ordenados alfabéticamente por nombre.

SELECT nombre_cliente, telefono FROM cliente 
WHERE codigo_cliente IN (SELECT codigo_cliente FROM pago WHERE YEAR(fecha_pago)='2007')
ORDER BY nombre_cliente;

-- 9) Obtener la gama, el proveedor y la cantidad de aquellos productos cuyo estado
-- sea pendiente

SELECT gama, proveedor, SUM(cantidad) cantidad FROM producto pr 
INNER JOIN detalle_pedido dp ON pr.codigo_producto = dp.codigo_producto
WHERE dp.codigo_pedido IN (SELECT codigo_pedido FROM pedido WHERE estado= 'pendiente')
GROUP BY gama, proveedor
ORDER BY gama, proveedor;


