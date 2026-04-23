-- EXAMEN BD TEMA 6.- PROGRAMACIÓN DE BASES DE DATOS
use jardineria;
-- 1º CURSO DAW

-- 1) PROCEDIMIENTOS Y FUNCIONES

-- Crea un procedimiento almacenado llamado resumenPagos. Se debe mostrar la cantidad total de pagos que se realizaron en un año determinado agrupados por la forma de pago. Por tanto, los campos a mostrar serán: Año, FormaPago, CantidadTotal.
-- Los datos se mostrarán ordenados ascendentemente por el campo FormaPago.
-- El procedimiento deberá recibir como parámetro el año sobre el que se desea realizar el resumen.

delimiter //

create procedure resumenPagos(anyo int)
begin
	select fecha_pago as Año, forma_pago as FormaPago, sum(CantidadTotal) as CantidadTotal from pago where fecha_pago = anyo group by fecha_pago, fecha_pago order by forma_pago asc;
end //

delimiter ;

-- 2) TRIGGERS

-- Crea un trigger llamado alarma_pedidos_pendientes. Dicho trigger almacenará en una tabla, llamada pedidos_pendientes, aquellos pedidos que estén pendientes de ser entregados.
-- La tabla debe contener los siguientes campos: codigoPedido, FechaPedido, FechaEsperada, Estado, Comentarios, CodigoCliente.
 
 create table pedidos_pendientes (
	codigoPedido int, 
    fechaPedido date not null,
    fechaEsperada date not null,
    estado varchar (50),
    comentarios varchar(100),
    codigoCliente int 
 );
 
  
 delimiter //
 create trigger alarma_pedidos_pendientes
 after insert on pedido 
 for each row
 begin
	if new.estado = "Pendiente" then
	insert into pedidos_pendientes (codigoPedido, fechaPedido, fechaEsperada, estado, comentarios, codigoCliente) 
    values (new.codigo_Pedido, new.fecha_Pedido, new.fecha_Esperada, new.estado, new.comentarios, new.codigo_Cliente);
    end if;
 end //
 delimiter ;
  
 
 -- 3) EVENTOS O VISTAS
 
-- Crea una vista llamada empleadosOficina que muestre solo los empleados que trabajen en España. 
-- La vista debe contener los siguientes campos: CodigoEmpleado, Nombre, Apellido1, Apellido2, CodigoOficina, Ciudad, Pais, Telefono. 
-- Configura la vista para que cuando ésta se actualice siga cumpliendo las condiciones que se incluyeron en su definición.
-- Intenta insertar un empleado nuevo que trabaje en España utilizando dicha vista. ¿Es esta vista actualizable? Razona la respuesta. 

create view empleadosOficina as
select e.codigo_empleado as CodigoEmpleado, e.nombre as Nombre, e.apellido1 as Apellido1, e.apellido2 as Apellido2, e.codigo_oficina as CodigoOficina, o.ciudad as Ciudad, o.pais as Pais, o.telefono as Telefono
from empleado e inner join oficina o on e.codigo_oficina = o.codigo_oficina where o.pais = "España" with check option;

insert into empleadosOficina (CodigoEmpleado, Nombre, Apellido1, Apellido2, CodigoOficina, Ciudad, Pais, Telefono) values (42, "Amancio", "Ortega", "Ruiz", 3211, "Madrid", 29 , "España", "111111111");

-- No es actualizable debido a que al usar un join, nos da error porque no podemos modificar más de una tabla


 
 
 
 