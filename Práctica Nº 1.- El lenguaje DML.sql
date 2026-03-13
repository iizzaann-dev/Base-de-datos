use jardineria;

-- 1) Inserta una nueva oficina en la ciudad de Málaga con los siguientes datos: código Oficina-> MAL-ES, ciudad-> Málaga, pais-> España, código postal-> 29002, teléfono 952324567->, dirección1-> C/Salitre 7.
insert into oficina (codigo_oficina, ciudad, pais, codigo_postal, telefono, linea_direccion1) values ("MAL-ES", "Málaga", "España", "29002", "952324567", "C/Salitre 7");

-- 2) Da de alta a un nuevo empleado con los siguientes datos: CodigoEmpleado-> 32, Nombre-> Daniel, Apellido1-> Álvarez, Apellido2-> Martín, 
-- Extensión-> 3897, Email-> dalvarez@gardening.com, CodigoOficina-> TAL-ES, CodigoJefe-> 3, Puesto-> Representante Ventas. 
insert into empleado (codigo_empleado, nombre, apellido1, apellido2, extension, email, codigo_oficina, codigo_jefe, puesto) values
("32", "Daniel", "Álvarez", "Martín", "3897", "dalvarez@gardening.com", "TAL-ES", "3", "Representante Ventas");

-- 3) Da de alta a un nuevo cliente con los siguientes datos: CodigoCliente -> 39, NombreCliente-> Jardines Costa del Sol, NombreContacto-> Juan, ApellidoContacto-> Ramos, Telf-> 952678923, 
-- Fax-> 952678924, direccion1-> C/Góngora 3, Ciudad-> Málaga, Pais-> España, CodigoPostal-> 29901 
insert into cliente (codigo_cliente, nombre_cliente, nombre_contacto, apellido_contacto, telefono, fax, linea_direccion1, ciudad, pais, codigo_postal)
values ("39", "Jardines Costa del Sol", "Juan", "Ramos", "952678923", "952678924", "C/Góngora 3", "Málaga", "España", "29901");

-- 4) Crea una tabla llamada clientes_pais que almacene todos los clientes que sean de España.
create table clientes_pais as select * from cliente where pais = "España";

-- 5) Eliminamos todas las filas de la tabla anterior.
delete from clientes_pais;

-- 6) insertamos en la tabla clientes_pais las filas devueltas por una consulta que devuelva los clientes que sean de estados unidos.
insert into clientes_pais select * from cliente where pais="usa";

-- 7) actualiza la tabla empleados para que el código del jefe del empleado alberto soria sea 1.
update empleado set codigo_jefe=1 where nombre="alberto" and apellido1="soria";

-- 8) actualiza la tabla clientes para que en la columna pais el valor "spain" sea sustituido por "españa".
update cliente set pais="españa" where pais="spain";

-- 9) incrementa el precio de venta de los productos de la gama "aromáticas" un 5%.
update producto set precio_venta=precio_venta*1.05 where gama="aromáticas";

-- 10) da de baja a todos los empleados que trabajen en la oficina de londres.
delete from empleado where codigo_oficina=(select codigo_oficina from oficina where ciudad="londres"); -- mal

-- 11) elimina la oficina de londres.
delete from oficina where ciudad="londres"; -- mal

-- 12) elimina aquellos clientes que no hayan realizado ningún pedido.
delete from cliente where codigo_cliente not in (select codigo_cliente from pedido);