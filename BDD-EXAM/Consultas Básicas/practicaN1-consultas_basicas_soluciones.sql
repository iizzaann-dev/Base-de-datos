use jardineria;

-- 1. Obtener la ciudad y el telefono de las oficinas de EEUU.
select ciudad, telefono
	from oficina
	where pais='EEUU';

-- 2. Obtener el cargo, nombre, apellidos y email del jefe de la empresa
select nombre as Nombre_Empleado, 
concat(apellido1, ' ', apellido2) as Apellidos, puesto
	from empleado 
	where Codigo_Jefe is null;

select nombre, concat(apellido1, ' ', apellido2) as Apellidos, puesto
	from empleado 
	where puesto='Director General';

-- 3. Obtener el nombre, apellidos y cargo de aquellos que no sean representantes
-- de ventas.
select nombre, concat(apellido1,' ',apellido2) as apellidos, email, puesto
	from empleado
	where puesto != 'Representante Ventas';

-- 4. Obtener el numero de clientes que tiene la empresa.
select count(*) as Numero_Clientes
	from cliente;

-- 5. Obtener el nombre de los clientes españoles.
select Nombre_Cliente, pais	
	from cliente
	where pais='Spain' or pais='España';

-- 6. Obtener cuantos clientes tiene la empresa en cada pais.
select count(*) as Numero_Clientes, pais
	from cliente
	group by pais;

-- 7. Obtener cuantos clientes tiene la empresa en la ciudad de Madrid.
select count(Codigo_cliente) as Numero_Clientes, ciudad
	from cliente
	where ciudad='Madrid'
	group by ciudad;

-- 8. Obtener el codigo de empleado y el numero de clientes al que atiende cada representante de ventas.
select Codigo_Empleado_Rep_Ventas, count(*) as 'N_Clientes' 
	from Cliente
	group by Codigo_Empleado_Rep_Ventas;

-- 9. Obtener cual fue el primer y ultimo pago que hizo el cliente cuyo codigo es el 3.
select min(fecha_pago) as primerpago, max(fecha_pago) as ultimopago
	from Pago
	where Codigo_Cliente=3;	

-- 10. Obtener el codigo de cliente de aquellos clientes que hicieron pagos en 2008.
select codigo_cliente, Fecha_Pago
	from Pago
	where year(Fecha_Pago)=2008;

select codigo_cliente, Fecha_Pago from pago 
where Fecha_Pago between '2008-01-01' and '2008-12-31'; 

select codigo_cliente, Fecha_Pago from pago 
where Fecha_Pago >= '2008-01-01' and Fecha_Pago <= '2008-12-31'; 

-- 11. Obtener los distintos estados por los que puede pasar un pedido.
select distinct estado	
	from pedido;

select estado from pedido group by estado;

-- 12. Obtener el numero de pedido, codigo de cliente, fecha requerida y fecha de entrega 
-- de los pedidos que no han sido entregados a tiempo.
select codigo_pedido, codigo_cliente, fecha_esperada, fecha_entrega
	from pedido
	where fecha_entrega > fecha_esperada;

-- 13. Obtener cuantos productos existen en cada linea de pedido.
select numero_linea, count(codigo_producto) as NumerodeProductos
	from detalle_pedido
	group by numero_linea;

-- 14. Obtener un listado de los 20 codigos de productos mas pedidos ordenado 
-- por cantidad pedida.
select codigo_producto, sum(cantidad) as CantidadTotal 
	from detalle_pedido
	group by codigo_producto
	order by CantidadTotal desc
    limit 20;

-- 15. Obtener el numero de pedido, codigo de cliente, fecha requerida y fecha de entrega de 
-- los pedidos cuya fecha de entrega ha sido al menos dos dias antes de la fecha requerida. (Usar la funcion Dateadd)
select codigo_pedido, codigo_cliente, fecha_esperada, fecha_entrega
	from pedido
	where date_add(fecha_entrega, INTERVAL 2 DAY) <= fecha_esperada;

-- 16. Obtener el nombre, apellidos, oficina y cargo de aquellos que no sean representantes de ventas.
select nombre, concat(apellido1,' ', apellido2) as apellidos, codigo_oficina, puesto
	from empleado
	where puesto != 'Representante ventas';

-- 17. Obtener el numero de clientes que tiene asignado cada representante de ventas.
select Codigo_Empleado_Rep_Ventas, count(codigo_cliente) as NumeroClientes 
	from cliente
	group by Codigo_Empleado_Rep_Ventas;

-- 18. Obtener un listado con el precio total de cada pedido.
select codigo_pedido, sum(cantidad * precio_unidad) as precioTotal
	from detalle_pedido
	group by codigo_pedido;

-- 19. Obtener cuantos pedidos tiene cada cliente en cada estado.
select codigo_cliente, estado, count(codigo_pedido) as Numero_Pedidos
	from pedido
	group by codigo_cliente, estado
	order by codigo_cliente;
	
-- 20. Obtener una lista con el codigo de oficina, ciudad, region y pais de aquellas oficinas que estan en paises que cuyo nombre empiece por E.
select codigo_Oficina, ciudad, region, pais
	from oficina
	where pais like 'e%';

 -- 21. Obtener el nombre, gama, dimensiones, cantidad en stock y el precio de venta de los cinco productos mas caros.
select nombre, gama, dimensiones, cantidad_En_Stock, precio_Venta
  from producto
  order by precio_Venta desc
  LIMIT 5;

-- 22. Obtener el codigo y la facturacion de aquellos pedidos mayores de 2000 euros.
select codigo_Pedido, sum(cantidad * precio_Unidad) as facturacion
  from detalle_pedido
  group by codigo_pedido
  having sum(cantidad * precio_Unidad) > 2000;

-- 23. Obtener una lista del stock total de los productos de cada gama por proveedor.
select sum(cantidad_En_Stock) as cantidadTotalEnStock, gama, proveedor
  from Producto
  group by gama, proveedor
  order by gama;

-- 24. Obtener el numero de pedidos y codigo de cliente de aquellos pedidos cuya fecha de pedido sea igual a la de la fecha de entrega.
select count(codigo_pedido) as NumeroPedidos, codigo_cliente
  from pedido
  where fecha_pedido = fecha_entrega
  group by codigo_cliente;
