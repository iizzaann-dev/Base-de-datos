-- EXAMEN BD SIMULACRO SOBRE EL TEMA 6: PROGRAMACIÓN DE BASES DE DATOS
use jardineria;

-- Ejercicio 1: Cursores
-- Enunciado: Crea un procedimiento almacenado llamado listar_clientes_por_region que reciba como parámetro el nombre de una región (o ciudad). 
-- El procedimiento debe utilizar un cursor para recorrer todos los clientes de esa zona y mostrar un mensaje por cada uno con el formato:
-- "Cliente: [nombre_cliente] - Contacto: [nombre_contacto] [apellido_contacto]".

delimiter //
create procedure listar_clientes_por_region (in pr_region varchar(100))
begin
		DECLARE fin INT DEFAULT FALSE;
		DECLARE c_nombre_cliente VARCHAR(100);
		DECLARE c_nombre_contacto VARCHAR(100);
		DECLARE c_apellido_contacto VARCHAR(100);
        
        declare cursor_clientes cursor for select  nombre_cliente, nombre_contacto, apellido_contacto
        FROM cliente
        WHERE ciudad = pr_region OR region = pr_region;
		declare continue handler for not found set fin = true;
        
        open cursor_clientes;
		bucle : loop
        fetch cursor_clientes into c_nombre_cliente, c_nombre_contacto, c_apellido_contacto;
        
         if fin then
            leave bucle;
        end if;
        
        select concat("Cliente: ", c_nombre_cliente, "Contacto: ", c_nombre_contacto, c_apellido_contacto) as mensaje;

		end loop;
		close cursor_clientes;
end //
delimiter ;



-- Ejercicio 2: Triggers (Disparadores)
-- Enunciado: Para llevar un control de seguridad, crea una tabla llamada auditoria_pagos. Después, crea un trigger llamado pago_insert que, 
-- cada vez que se inserte un nuevo registro en la tabla pago, guarde de forma automática en la tabla de auditoría el ID del cliente, la fecha del pago, 
-- el total y la fecha/hora exacta en la que se realizó la inserción en el sistema.

create table auditoria_pagos(
	id_auditoria int auto_increment primary key,
    id_cliente int,
    fecha_pago date,
    total decimal(10,2),
    fecha_registro datetime
);

delimiter //
create trigger  insert_pago
after insert on pago
for each row
begin
	insert into auditoria_pagos (codigo_cliente, fecha_pago, total, fecha_registro) values (new.codigo_cliente, new.fecha_pago, new.total, now()); 
end //
delimiter ;



-- Ejercicio 3: Eventos
-- Enunciado: La empresa quiere un sistema de limpieza automática. Crea un evento en MySQL llamado limpiar_auditoria_vieja que se ejecute una vez al mes, 
-- empezando a partir de mañana. Este evento debe borrar todos los registros de la tabla auditoria_pagos (creada en el ejercicio anterior) que tengan más de 6 meses de antigüedad.


delimiter //
create event limpiar_auditoria_vieja 
on schedule every 1 month starts current_date + interval 1 day do
begin
	declare fecha_limite datetime;
    
    set fecha_limite = now() - interval 6 month;
    
	delete from auditoria_pagos where fecha_registro < fecha_limite;
end //
delimiter ;
