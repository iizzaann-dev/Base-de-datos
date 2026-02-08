use jardineria;

-- 1) Selecciona aquellos clientes que hayan hecho algún pedido a partir de 2008.
select c.* from cliente c inner join pedido p on c.codigo_cliente = p.codigo_cliente where year(p.fecha_pedido) >= 2008;

-- 2) Selecciona aquellos clientes que hayan hecho pedidos que contengan algún producto con una cantidad  menor a 10 unidades.
select c.* from cliente c inner join pedido p on c.codigo_cliente = p.codigo_cliente inner join detalle_pedido d on p.codigo_pedido = d.codigo_pedido where cantidad < 10;

-- 3) Selecciona aquellos empleados que trabajen en la oficina de Madrid. 
select e.* from empleado e inner join oficina o on e.codigo_oficina = o.codigo_oficina where ciudad = "Madrid";

-- 4) Selecciona aquellos clientes que hayan efectuado pagos con PayPal.
select c.* from cliente c inner join pago p on c.codigo_cliente = p.codigo_cliente where forma_pago = "PayPal";

-- 5) Selecciona aquellos clientes que hayan efectuado pagos que no sea con PayPal.
select c.* from cliente c inner join pago p on c.codigo_cliente = p.codigo_cliente where forma_pago != "PayPal";

-- 6) Selecciona aquellos empleados que sean jefes. 
select distinct e.* from empleado e inner join empleado e2 on e.codigo_empleado = e2.codigo_jefe;

-- 7) Selecciona aquellos empleados que no sean jefes. 
select e.* from empleado e left join empleado e2 on e.codigo_empleado = e2.codigo_jefe where e2. codigo_jefe is null;

-- 8) Selecciona todos los empleados que sean jefes en España.
select distinct e.* from empleado e inner join empleado e2 on e.codigo_empleado = e2.codigo_jefe inner join oficina o 
on e2.codigo_oficina = o.codigo_oficina where pais = "España";

-- 9) Selecciona aquellos clientes cuyo límite de crédito sea superior, al menos, al de algunos de los clientes de su mismo país. 
select distinct c.* from cliente c inner join cliente c2 on c.limite_credito > c2.limite_credito and c.pais = c2.pais;

-- 10) Selecciona aquellos clientes que hayan hecho, al menos, 5 pedidos durante el año 2009.
select distinct c.* from cliente 

