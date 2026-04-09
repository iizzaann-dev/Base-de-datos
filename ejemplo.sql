/**********************************************************
*              EXAMEN BD TEMA 4 y 5 DAW (MODELO A)
**********************************************************/

USE jardineria;

/* PARTE A – CONSULTAS */

-- 1) Muestra el nombre y el precio de venta de los productos cuyo precio sea mayor a 50.
SELECT nombre, precio_venta
FROM producto
WHERE precio_venta > 50;

-- 2) Muestra el nombre de los clientes que tengan límite de crédito superior a 20000. Ordena la consulta por nombre_cliente
SELECT nombre_cliente
FROM cliente
WHERE limite_credito > 20000
ORDER BY nombre_cliente;

-- 3) Muestra el número de pedidos realizados en cada estado.
SELECT estado, COUNT(*) AS numero_pedidos
FROM pedido
GROUP BY estado;

-- 4) Muestra el nombre del cliente y la ciudad de su representante de ventas.
SELECT c.nombre_cliente, o.ciudad
FROM cliente c
JOIN empleado e ON c.codigo_empleado_rep_ventas = e.codigo_empleado
JOIN oficina o ON e.codigo_oficina = o.codigo_oficina;

-- 5) Muestra los nombres de los clientes que han realizado algún pago superior a 5000.
SELECT DISTINCT c.nombre_cliente
FROM cliente c
JOIN pago p ON c.codigo_cliente = p.codigo_cliente
WHERE p.total > 5000;

/* PARTE B – DML */

-- 1) Inserta un nuevo pago para el cliente 10 por importe de 1500
-- con fecha actual y forma de pago "Transferencia".
INSERT INTO pago (codigo_cliente, forma_pago, id_transaccion, fecha_pago, total)
VALUES (10, 'Transferencia', "transaccion", CURDATE(), 1500);

-- 2) Reduce en un 5% el precio de los productos cuyo precio sea mayor de 100.
UPDATE producto
SET precio_venta = precio_venta * 0.95
WHERE precio_venta > 100;

-- 3) Elimina aquellos clientes que no hayan hecho ningún pedido en el año 2008
DELETE FROM cliente
WHERE codigo_cliente NOT IN (
    SELECT codigo_cliente
    FROM pedido
    WHERE YEAR(fecha_pedido) = 2008
);
