use jardineria;

-- Ejercicios de subconsulta

-- 1) Obtener el nombre del producto más caro. Realizar el ejercicio como una subconsulta y luego como una consulta simple para que dicha consulta sea más eficiente.
select nombre from producto where precio_venta = (select max(precio_venta) from producto);

-- 2) Obtener el nombre del producto del que más unidades se hayan vendido en un mismo pedido.
select nombre from producto where codigo_producto = (select codigo_producto from detalle_pedido where cantidad = (select max(cantidad) from detalle_pedido));

-- 3) Obtener el nombre de los clientes que hayan hecho pedidos en 2008.
select nombre_cliente from cliente where codigo_cliente in (select codigo_cliente from pedido where fecha_pedido between '2008-01-01' and '2008-12-31' );

-- 4) Obtener los clientes que han pedido más de 200 unidades de cualquier producto.
select nombre_cliente from cliente where codigo_cliente in (select codigo_cliente from pedido where codigo_pedido in (select codigo_pedido from detalle_pedido where cantidad > 200));

-- 5) Obtener los clientes que residen en ciudades donde no hay oficinas.
select * from cliente where ciudad not in (select ciudad from oficina);

-- 6) Obtener el nombre, los apellidos y el email de los empleados a cargo de Alberto Soria.
select nombre, apellido1, apellido2, email from empleado where codigo_jefe = (select codigo_empleado from empleado where nombre = 'Alberto' and apellido1 = 'Soria');

-- 7) Obtener el nombre de los clientes a los que no se les ha entregado a tiempo algún pedido.
select nombre_cliente from cliente where codigo_cliente in (select codigo_cliente from pedido where fecha_entrega > fecha_esperada);

-- 8) 
select nombre_cliente, telefono from cliente where codigo_cliente in (select codigo_cliente from pago where year(fecha_pago) = '2007') order by nombre_cliente;

-- 9) Obtener la gama, el proveedor y la cantidad de aquellos productos cuyo estado sea pendiente
select gama, proveedor, sum(cantidad) cantidad from producto pr inner join detalle_pedido dp on pr.codigo_producto = dp.codigo_producto 
where dp.codigo_pedido in (select codigo_pedido from pedido where estado = 'pendiente') group by gama, proveedor
order by gama, proveedor;