delimiter $$
create procedure es_positivo_o_negativo (in val int) 
begin
	declare respuesta text;
    if val = 0 then set respuesta = "El cero no es ni positivo ni negativo";
    elseif val > 0 then set respuesta = "El número es positivo";
    elseif val < 0 then set respuesta = "El número es negativo";
    end if;
    select respuesta;
end$$
delimiter ; 

delimiter $$
create procedure notas (in val int, out respuesta varchar (40)) 
begin 
    if val < 0 or val > 10 then set respuesta = "El valor no es una nota válida";
    else
		case val
			when 10 then set respuesta = "Sobresaliente";
			when 9 then set respuesta = "Sobresaliente";
			when 8 then set respuesta = "Notable";
			when 7 then set respuesta = "Notable";
			when 6 then set respuesta = "Bien";
			when 5 then set respuesta = "Suficiente";
			else set respuesta = "Insuficiente";
		end case;
    end if;
end$$
delimiter ;

call notas (11, @respuesta);
select @respuesta;

delimiter $$
create procedure ejemplo_while (inout val int)
	begin
		declare i int default 1;
        while i <=5 do 
        set val = val + 1; 
        set i = i + 1;
        end while;
	end$$
delimiter ;

set @num = 5;
call ejemplo_while(@num);
select @num;


delimiter $$ 
create procedure ejemplo_repeat (inout val int)
	begin
		declare i int default 1;
		repeat 
			set val = val + 1;
			set i = i + 1;
			until i > 5
		end repeat;
	end$$
delimiter ;

delimiter $$
create function ejemplo_funcion () returns varchar(20) deterministic
begin 
	return "Ejemplo de función";
end$$
delimiter ;
select ejemplo_funcion();

delimiter $$
create function mayorDe3 (valor1 int, valor2 int, valor3 int) returns int deterministic
begin 
	declare max1 int;    
    if valor1 < valor2 then set max1 = valor2;
    else set max1 = valor1;
    end if;
    if max1 < valor3 then set max1 = valor3;
    end if;
    return max1;
end$$
delimiter ;
drop function mayorDe3;
select mayorDe3(3, 1, 2);


use employees;
-- Crea una funcion que devuelva el nombre de un empleado a partir de su id de empleado
delimiter &&
create function nombreEmpleado (idEmpleado int) returns varchar (20) deterministic
begin
	declare contenido varchar (20);
	select first_name from employees where idEmpleado = employee_id into contenido;
    return contenido;
end&&
delimiter ;
drop function nombreEmpleado;
select nombreEmpleado(100);

select distinct *, nombreEmpleado(manager_id) from employees.employees;


