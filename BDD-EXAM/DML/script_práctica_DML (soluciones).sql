-- PRÁCTICA Nº1.- EL LENGUAJE DML

-- Seleccionamos la base de datos jardineria.
USE jardineria;

-- 1) Inserta una nueva oficina en la ciudad de Málaga con los siguientes datos: codigo Oficina-> MAL-ES, ciudad-> Málaga, pais-> España, codigo postal-> 29002, telefono 952324567->, direccion1-> C/Salitre 7.
insert into Oficina(Codigo_Oficina, Ciudad, Pais, Codigo_Postal, Telefono, Linea_Direccion1) 
values ('MAL-ES', 'Málaga', 'España', '29002', '952324567', 'C/Salitre 7');

-- 2) Da de alta a un nuevo empleado con los siguientes datos: CodigoEmpleado-> 32, Nombre-> Daniel, Apellido1-> Alvarez, Apellido2-> Martin, Extension-> 3897, Email-> dalvarez@gardening.com, CodigoOficina-> TAL-ES, CodigoJefe-> 3, Puesto-> Representante Ventas. 
insert into Empleado values (32, 'Daniel', 'Alvarez', 'Martin', 3897, 'dalvarez@gardening.com', 'TAL-ES', 3, 'Representante Ventas');

-- 3) Da de alta a un nuevo cliente con los siguientes datos: CodigoCliente -> 39, NombreCliente-> Jardines Costa del Sol, NombreContacto-> Juan, ApellidoContacto-> Ramos, Telf-> 952678923, Fax-> 952678924, direccion1-> C/G�ngora 3, Ciudad-> M�laga, Pais-> Espa�a, CodigoPostal-> 29901 
insert into Cliente(Codigo_Cliente,Nombre_Cliente, Nombre_Contacto, Apellido_Contacto, Telefono, Fax, Linea_Direccion1, Ciudad, Pais, Codigo_Postal) 
values (39,'Jardines Costa del Sol', 'Juan', 'Ramos', '952678923',  '952678924', 'C/Góngora 3', 'Málaga', 'España', 29901);

-- 4) Crea una tabla llamada clientes_pais que almacene todos los clientes que sean de España.
create table Clientes_pais like Cliente;
insert into Clientes_pais select * from Cliente where Pais = 'España' or Pais = 'Spain';

-- 5) Eliminamos todas las filas de la tabla anterior.
delete from Clientes_pais;

-- 6) Insertamos en la tabla clientes_pais, que debe estar vacía, las filas devueltas por una consulta que devuelva los clientes que sean de Estados Unidos.
insert into Clientes_pais select * from Cliente where Pais = 'USA';

-- 7) Actualiza la tabla empleados para que el codigo del jefe del empleado Alberto Soria por 1.
update Empleado set Codigo_Jefe= 1 where Nombre = 'Alberto' and Apellido1 = 'Soria'; 
select * from Empleado where Nombre = 'Alberto' and Apellido1 = 'Soria'; 

-- 8) Actualiza la tabla clientes para que la columna Pais el valor "Spain" por "España".
update Cliente set Pais= 'España' where Pais = 'Spain'; 
select * from Cliente where Pais = 'España'; 

-- 9) Incrementa el precio de venta de los productos de la gama "Arom�ticas" un 5%.
update producto set Precio_Venta= 1.05 * Precio_Venta where Gama = 'Aromáticas'; 
select * from producto where Gama = 'Aromáticas'; 

-- 10) Da de baja a todos los empleados que trabajen en la oficina de Londres.
delete from Empleado where Codigo_Oficina ='LON-UK';

delete from Empleado 
where Codigo_Oficina = (select codigo_oficina from oficina where ciudad = 'Londres');

-- 11) Elimina la oficina de Londres.
delete from Oficina where ciudad = 'Londres';

-- 12) Elimina a aquellos clientes que no hayan realizado ningún pedido.
delete from Cliente where Codigo_Cliente 
NOT IN (select DISTINCT Codigo_Cliente from pedido);