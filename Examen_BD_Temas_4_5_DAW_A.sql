/**********************************************************
*              EXAMEN BD TEMA 4 y 5 DAW (MODELO A)
**********************************************************/

-- Todos los ejercicios se realizarán sobre la base de datos jardinería
use jardineria;
/* PARTE A – CONSULTAS */

-- 1) Muestra el nombre y el precio de venta de los productos cuyo precio sea mayor a 50.
select nombre, precio_venta from producto where precio_venta > 50;

-- 2) Muestra el nombre de los clientes que tengan límite de crédito superior a 20000. Ordena la consulta por nombre_cliente
select nombre_cliente from cliente where limite_credito > 20000 order by nombre_cliente;

-- 3) Muestra el número de pedidos realizados en cada estado.
select estado, count(*) as numero_pedidos from pedido group by estado;

-- 4) Muestra el nombre del cliente y la ciudad de su representante de ventas.
select c.nombre_cliente, o.ciudad from cliente c inner join empleado e on  c.codigo_empleado_rep_ventas = e.codigo_empleado inner join oficina o on e.codigo_oficina = o.codigo_oficina;

-- 5) Muestra los nombres de los clientes que han realizado algún pago superior a 5000.
-- Usamos *
select distinct c.nombre_cliente from cliente c inner join pago p on c.codigo_cliente where p.total > 5000;

-- Usamos la funcion que devuelve la fecha actual  curdate()

/* PARTE B – DML */

-- 1) Inserta un nuevo pago para el cliente 10 por importe de 1500
-- con fecha actual y forma de pago "Transferencia".
insert into pago (codigo_cliente, forma_pago, id_transaccion, fecha_pago, total) values (10, "Transferencia", "Transacción1", curdate(), 1500); 


-- 2) Reduce en un 5% el precio de los productos cuyo precio sea mayor de 100.
update producto set precio_venta = precio_venta * 0.95 where precio_venta > 100;

-- 3) Elimina aquellos clientes que no hayan hecho ningún pedido en el año 2008
delete from cliente where codigo_cliente not in (select codigo_cliente from pedido where year(fecha_pedido) = 2008); 


