-- 1. Obtener la ciudad y el teléfono de las oficinas de EEUU.
SELECT region , telefono FROM cliente 
WHERE pais = 'USA' 
AND telefono;

-- 2. Obtener el cargo, nombre, apellidos e email del jefe de la empresa.
 SELECT puesto, nombre , apellido1, apellido2 FROM empleado;
SELECT email, puesto, nombre, apellido1, apellido2 FROM empleado
WHERE puesto = 'Director General';

-- 3.Obtener el nombre, apellidos y cargo de aquellos que no sean representantes de ventas.
SELECT nombre, apellido1, apellido2 ,puesto FROM empleado
WHERE puesto != 'Representante Ventas';

-- 4. Obtener el número de clientes que tiene la empresa.
SELECT COUNT(*)codigo_cliente 
FROM cliente;

-- 5.Obtener el nombre de los clientes españoles.
SELECT nombre_cliente FROM cliente
WHERE pais = 'Spain';

-- 6. Obtener cuántos clientes tiene la empresa en cada país.
SELECT COUNT(*) codigo_cliente, pais FROM cliente
GROUP BY pais;

-- ¿Cuantos clientes hay en Madrid y cuantos clientes hay en Miami?
SELECT count(Codigo_cliente) as Numero_Clientes, ciudad 
from cliente
WHERE ciudad = 'Madrid' OR ciudad = 'Miami'
GROUP BY ciudad;

-- 7. Obtener cuántos clientes tiene la empresa en la ciudad de Madrid.
SELECT COUNT(*)codigo_cliente FROM cliente
WHERE region = 'Madrid';

-- 8.Obtener el código de empleado y el número de clientes al que atiende cada representante de ventas.
SELECT COUNT(*) codigo_cliente, codigo_empleado_rep_ventas  FROM cliente
group by codigo_empleado_rep_ventas ; 

-- 9.Obtener cuál fue el primer y último pago que hizo el cliente cuyo código es el número 3.
SELECT codigo_cliente, limite_credito FROM cliente
where codigo_cliente = '3'
ORDER BY limite_credito LIMIT 1;

-- 10.Obtener el código de cliente de aquellos clientes que hicieron pagos en 2008.
SELECT codigo_cliente,fecha_pago FROM pago
WHERE fecha_pago BETWEEN '2008-01-01' AND '2008-12-31' ORDER BY fecha_pago;

-- 11.Obtener el código de cliente de aquellos clientes que hicieron pagos en 2008.
SELECT DISTINCT estado
FROM pedido;

-- 12 Obtener el número de pedido, código de cliente, fecha requerida y fecha de entrega de los pedidos que no han sido entregados a tiempo.
SELECT codigo_pedido, codigo_cliente, fecha_esperada, fecha_entrega
FROM pedido
WHERE fecha_entrega > fecha_esperada;

-- 13. Obtener cuántos productos existen en cada línea de pedido.
SELECT gama, COUNT(*) AS total_productos
FROM producto
GROUP BY gama;

-- 14. Obtener un listado de los 20 códigos de productos más pedidos ordenado por cantidad pedida.
SELECT codigo_producto, SUM(cantidad) AS total_pedida
FROM detalle_pedido
GROUP BY codigo_producto
ORDER BY total_pedida DESC
LIMIT 20;


-- 15. Obtener el número de pedido, código de cliente, fecha requerida y fecha de entrega de los pedidos cuya fecha de entrega ha sido al menos dos días antes
-- de la fecha requerida. (Usar la función addDate)
SELECT codigo_pedido, codigo_cliente, fecha_esperada, fecha_entrega
FROM pedido
WHERE ADDDATE(fecha_esperada, INTERVAL -2 DAY) <= fecha_entrega;

-- 16. Obtener el nombre, apellidos, oficina y cargo de aquellos que no sean
-- representantes de ventas.
SELECT e.nombre, e.apellido1, e.apellido2, o.ciudad AS oficina, e.puesto
FROM empleado e
JOIN oficina o ON e.codigo_oficina = o.codigo_oficina
WHERE e.puesto <> 'Representante Ventas';

-- 17. Obtener el número de clientes que tiene asignado cada representante de
-- ventas.
SELECT codigo_empleado_rep_ventas, COUNT(*) AS total_clientes
FROM cliente
GROUP BY codigo_empleado_rep_ventas;

-- 18. Obtener un listado con el precio total de cada pedido.
SELECT codigo_pedido, SUM(cantidad * precio_unidad) AS total_pedido
FROM detalle_pedido
GROUP BY codigo_pedido;

-- 19. Obtener cuántos pedidos tiene cada cliente en cada estado.
SELECT codigo_cliente, estado, COUNT(*) AS total_pedidos
FROM pedido
GROUP BY codigo_cliente, estado;

-- 20. Obtener una lista con el código de oficina, ciudad, región y país de aquellas oficinas que estén en países que cuyo nombre empiece por “E”.
SELECT codigo_oficina, ciudad, region, pais
FROM oficina
WHERE pais LIKE 'E%';

-- 21. Obtener el nombre, gama, dimensiones, cantidad en stock y el precio de venta de los cinco productos más caros.
SELECT nombre, gama, dimensiones, cantidad_en_stock, precio_venta
FROM producto
ORDER BY precio_venta DESC
LIMIT 5;

-- 22. Obtener el código y la facturación de aquellos pedidos mayores de 2000 euros.
SELECT codigo_pedido, SUM(cantidad * precio_unidad) AS facturacion
FROM detalle_pedido
GROUP BY codigo_pedido
HAVING facturacion > 2000;

-- 23. Obtener una lista de los productos mostrando el stock total, la gama y el proveedor.
SELECT nombre, cantidad_en_stock, gama, proveedor
FROM producto;

-- 24. Obtener el número de pedidos y código de cliente de aquellos pedidos cuya fecha de pedido sea igual a la de la fecha de entrega.
SELECT codigo_pedido, codigo_cliente
FROM pedido
WHERE fecha_pedido = fecha_entrega;



