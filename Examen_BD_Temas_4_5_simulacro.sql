/**********************************************************
*             EXAMEN BD TEMA 4 y 5 (SIMULACRO)
**********************************************************

-- Todos los ejercicios se realizarán sobre la base de datos jardinería 

/* PARTE A – Tema 4.- REALIZACIÓN DE CONSULTAS */

use jardineria;
-- 1) Selecciona a aquellos empleados que sean directores de oficinas cuyos códigos terminen en "USA"
select nombre, apellido1 from empleado where puesto = "Director Oficina" and codigo_oficina like "%-USA";

-- 2) Selecciona a aquellos clientes que residan en España. Ordena la consulta por el nombre del cliente ascendentemente.
select * from cliente where pais = "España" or pais = "spain" order by nombre_contacto asc; 

-- 3) Muestra la media de la cantidad en stock de cada gama de productos. Ordena la consulta por la media de la cantidad en stock descendentemente.
select avg(cantidad_en_stock), gama from producto group by gama order by avg(cantidad_en_stock) desc; 

-- 4) Selecciona aquellos empleados que tengan como jefe a Ruben López.
select nombre, apellido1 from empleado where codigo_jefe = (select codigo_empleado from empleado where nombre = "Ruben" and apellido1 = "López");

-- 5) Muestra los códigos de los clientes cuyas cantidades pagadas en cada una de sus transacciones estén por encima de la media.
select codigo_cliente from pago where total > (select avg(total) from pago);

/* PARTE B – Tema 5.- TRATAMIENTO DE DATOS (DML) */

-- 1) Inserta un nuevo cliente (usa datos ficticios).
-- Inserta solo los datos que sean obligatorios
insert into cliente (codigo_cliente, nombre_cliente, telefono, fax, linea_direccion1, ciudad) values (200, "Antonio", 123456789, "123456789", "Avenida las Américas", "Madrid");

-- 2) Incrementa en un 10% el precio de venta de los productos cuyo precio esté por debajo de 20
update producto set precio_venta = precio_venta * 1.10 where precio_venta < 20;

-- 3) Elimina los clientes que sean de Madrid y Barcelona
delete from cliente where ciudad in ("Madrid", "Barcelona");
delete from cliente where ciudad = "Madrid" or ciudad = "Barcelona";