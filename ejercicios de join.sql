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
select  c.* from cliente c inner join pedido p on c.codigo_cliente = p.codigo_cliente where year(p.fecha_pedido) = 2009 group by c.codigo_cliente having count(p.codigo_pedido) >= 5;

-- 11) Mostrar aquellos empleados que sean representantes de ventas de algún cliente de Madrid. 
select distinct e.* from empleado e inner join oficina o on e.codigo_oficina = o.codigo_oficina inner join cliente c on e.codigo_empleado = c.codigo_empleado_rep_ventas
 where o.ciudad = "Madrid" and e.puesto = "Representante de Ventas";
 
 -- o
 select distinct e.* from empleado e inner join cliente c on e.codigo_empleado = c.codigo_empleado_rep_ventas
where e.puesto = "Representante Ventas" and c.ciudad = "Madrid";

-- 12) Mostrar aquellos clientes que tengan algún pedido pendiente.
select c.* from cliente c inner join pedido p on c.codigo_cliente = p.codigo_cliente where estado = "pendiente";

-- 13) Mostrar aquellos clientes que tengan algún pedido rechazado desde 2006. 
select c.* from cliente c inner join pedido p on c.codigo_cliente = p.codigo_cliente where year(p.fecha_pedido) = 2006 and (p.estado is null or trim(lower(p.estado)) != lower("Entregado")); 

-- 14) Mostrar aquellos pedidos que tengan al menos 6 productos distintos. 
select p.codigo_pedido from pedido p inner join detalle_pedido dp on p.codigo_pedido = dp.codigo_pedido group by p.codigo_pedido having count(distinct dp.codigo_producto) >= 6;

-- 15) Mostrar aquellos clientes cuyos representantes de ventas alguno tenga su oficina en España. 
select distinct c.* from cliente c inner join empleado e on c.codigo_empleado_rep_ventas = e.codigo_empleado inner join oficina o on e.codigo_oficina = o.codigo_oficina where o.pais = 'españa';

-- 16) Mostrar aquellos empleados que no tengan como jefe a Carlos Soria. 
select e.* from empleado e inner join empleado jefe on e.codigo_jefe = jefe.codigo_empleado where not (jefe.nombre = 'carlos' and jefe.apellido1 = 'soria');

-- 17) Mostrar aquellos productos de los que se hayan pedido más de 50 unidades. 
select pr.codigo_producto, pr.nombre from producto pr inner join detalle_pedido dp on pr.codigo_producto = dp.codigo_producto group by pr.codigo_producto, pr.nombre having sum(dp.cantidad) > 50;

-- 18) Mostrar aquellos empleados que no son jefes. 
select e.* from empleado e left join empleado sub on e.codigo_empleado = sub.codigo_jefe where sub.codigo_empleado is null;

-- 19) Muestra aquellos productos cuyo precio de venta sea mayor que el de la media.
select p.* from producto p inner join (select avg(precio_venta) as media_precio from producto) m where p.precio_venta > m.media_precio;

