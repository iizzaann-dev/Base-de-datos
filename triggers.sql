create database prueba; 
use prueba; 
create table account (
	acc_num int, 
    amount decimal (10,2)
);

create trigger ins_sum before insert on account for each row set @sum = @sum + new.amount;

set @sum = 0; 
insert into account values (137, 14.95), (138, 192.33), (139, 50.00);

show triggers;
show triggers where "Definer" like "root%";

create table usuarios (
	id int auto_increment primary key,
    nombre varchar (100)
);

create table logs_usuarios (
	id int auto_increment primary key,
	mensaje varchar (255),
    fecha datetime
);


delimiter //
create trigger tras_insertar_usuario
after insert on usuarios
for each row 
begin 
	insert into logs_usuarios (mensaje, fecha) values (concat("¡Nuevo usuario creado!", new.nombre), now());
end//
delimiter ;
drop trigger tras_insertar_usuario;

insert into usuarios(nombre) values ("Alejandro");


create table productos (
	id int auto_increment primary key,
    nombre varchar(100),
    stock int
);

delimiter //
	create trigger validar_stock_negativo before update on productos for each row 
		begin	
			if new.stock < 0 then set new.stock = 0;
			end if;
		end//
delimiter ;

drop trigger validar_stock_negativo;
insert into productos (nombre, stock) values ("Laptop", 10);

update productos set stock = -5 where nombre = "Laptop";

select * from productos;


delimiter //
create trigger cada_update before update on productos for each row 
	begin
		if new.stock < 0 then signal sqlstate "45000" set message_text = "Se introdujo un stock negativo. Actualización cancelada";
        end if;
	end//
delimiter ;


-- Creamos una base de datos nueva
create database if not exists empresa_db; 
use empresa_db;

-- Creamos la tabla empleados
create table if not exists empleado (
	id int auto_increment primary key,
    nombre varchar (100),
    dni char(9)
);

-- Funciones utiles
select char_length("Esto es SQL");
select upper("Esto es SQL");
select lower ("Esto es SQL");
select right ("Esto es SQL", 4);
select left ("Esto es SQL", 4);


delimiter //
create trigger comprobar_dni_update before update on empleado for each row
	begin 
		if new.dni not regexp "^[0-9]{8}[a-zA-Z]$" then
        signal sqlstate "45000"
        set message_text = "El DNI ingresado es invalido";
		end if;
	end //
delimiter ;

delimiter //
create trigger comprobar_dni_insert before insert on empleado for each row
	begin
		if new.dni not regexp "^[0-9]{8}[a-zA-Z]$" then 
        signal sqlstate "45000"
        set message_text = "El DNI ingresado invalido";
		end if;
	end //
delimiter ;
        
        
insert into empleado (dni) values ("1245678A");
update empleado set dni = "8654321A" where dni = "87654321A";
