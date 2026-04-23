use jardineria;

create table clientes_prueba (
	nombre varchar(50)
);

create table otros_clientes (
	id int primary key,
	nombre varchar (50)
);

delimiter //
create trigger trigger_ejemplo
after update on otros_clientes
for each row 
begin
	insert into clientes_prueba (nombre) values ("Manolo");
end //
delimiter ;

update otros_clientes set nombre = "Manolete";


select * from clientes_prueba;

drop table otros_clientes;