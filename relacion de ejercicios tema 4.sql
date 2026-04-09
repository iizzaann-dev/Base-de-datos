-- RELACIÓN DE EJERCICIOS SOBRE PROCEDIMIENTOS Y FUNCIONES 

-- 1) Realiza un procedimiento que muestre el texto “hola mundo” sobre la base de datos MySQL. 
delimiter //
create procedure hola_mundo() begin select 'hola mundo' as mensaje; end //
delimiter ;
call hola_mundo();

-- 2) Crea un procedimiento que muestre la versión de MySQL. 
delimiter //
create procedure version_mysql() begin select version() as version_mysql; end //
delimiter ;
call version_mysql();

-- 3) Crea un procedimiento que muestre el año actual.
delimiter //
create procedure anio_actual() begin select year(curdate()) as anio; end //
delimiter ;
call anio_actual();

-- 4) Crea una función, llamado incrementa_en_uno, que incremente en uno un número entero que le pasemos a la función. 
delimiter //
create function incrementa_en_uno(numero int) returns int deterministic begin return numero + 1; end //
delimiter ;
select incrementa_en_uno(5);

-- 5) Crea una función que reciba como parámetro un número y devuelva TRUE si el número es impar FALSE si el número es par. 
delimiter //
create function es_impar(numero int) returns boolean deterministic begin return numero mod 2 <> 0; end //
delimiter ;
select es_impar(5);
select es_impar(4);


-- RELACIÓN DE EJERCICIOS SOBRE TRIGGERS 

-- 1) haz que no se pueda añadir un nuevo departamento si el nombre tiene menos de 5 caracteres
delimiter //
create trigger validar_nombre_departamento before insert on departments for each row begin if char_length(new.name) < 5 then signal sqlstate '45000' set message_text = 'el nombre del departamento debe tener al menos 5 caracteres'; end if; end //
delimiter ;

-- 2) asignar automáticamente como manager al empleado más antiguo que no sea manager de otro departamento
delimiter //
create trigger asignar_manager_departamento before insert on departments for each row begin declare empleado_id int; select e.id into empleado_id from employees e where e.id not in (select manager_id from departments where manager_id is not null) order by e.fecha_contratacion asc limit 1; set new.manager_id = empleado_id; end //
delimiter ;

-- 3) crear tabla registro y usuario con triggers de auditoría

create table registro ( id int auto_increment primary key, usuario varchar(100), tabla varchar(100), operacion varchar(10), fecha_hora datetime );

create user 'gestiona_triggers'@'%' identified by 'password';
grant trigger, select, insert, update, delete on *.* to 'gestiona_triggers'@'%';
flush privileges;

-- trigger para insert en departments
delimiter //
create trigger registro_departments_insert after insert on departments for each row begin insert into registro(usuario, tabla, operacion, fecha_hora) values (current_user(), 'departments', 'insert', now()); end //
delimiter ;

-- trigger para update en departments
delimiter //
create trigger registro_departments_update after update on departments for each row begin insert into registro(usuario, tabla, operacion, fecha_hora) values (current_user(), 'departments', 'update', now()); end //
delimiter ;

-- trigger para delete en departments
delimiter //
create trigger registro_departments_delete after delete on departments for each row begin insert into registro(usuario, tabla, operacion, fecha_hora) values (current_user(), 'departments', 'delete', now()); end //
delimiter ;

-- impedir salarios fuera del rango permitido
delimiter //
create trigger validar_salario_insert before insert on employees for each row begin if new.salary < 30000 or new.salary > 300000 then signal sqlstate '45000' set message_text = 'salario fuera de rango permitido'; end if; end //
delimiter ;

delimiter //
create trigger validar_salario_update before update on employees for each row begin if new.salary < 30000 or new.salary > 300000 then signal sqlstate '45000' set message_text = 'salario fuera de rango permitido'; end if; end //
delimiter ;

-- 4) crear tabla contador y mantener conteo automático

create table contador ( id int auto_increment primary key, tipo varchar(100), valor int );

insert into contador (id, tipo, valor) values (1, 'numEmpleados', 0);
insert into contador (id, tipo, valor) values (2, 'numDepartamentos', 0);

-- actualizar contador de empleados
delimiter //
create trigger contador_empleados_insert after insert on employees for each row begin update contador set valor = valor + 1 where tipo = 'numEmpleados'; end //
delimiter ;

delimiter //
create trigger contador_empleados_delete after delete on employees for each row begin update contador set valor = valor - 1 where tipo = 'numEmpleados'; end //
delimiter ;

-- actualizar contador de departamentos
delimiter //
create trigger contador_departamentos_insert after insert on departments for each row begin update contador set valor = valor + 1 where tipo = 'numDepartamentos'; end //
delimiter ;

delimiter //
create trigger contador_departamentos_delete after delete on departments for each row begin update contador set valor = valor - 1 where tipo = 'numDepartamentos'; end //
delimiter ;


-- RELACIÓN DE EJERCICIOS SOBRE EVENTOS 

-- 1) registrar cada 1 minuto durante 10 minutos los usuarios conectados a la bd employees

create table historico_usuarios_hora ( usuario varchar(100), equipo varchar(100), fecha_hora datetime );

set global event_scheduler = on;

delimiter //
create event registrar_usuarios on schedule every 1 minute starts now() ends now() + interval 10 minute do begin insert into historico_usuarios_hora (usuario, equipo, fecha_hora) select user, host, now() from information_schema.processlist where db = 'employees'; end //
delimiter ;

-- 2) guardar copia de departments el 30 de enero de 2021 a las 23:15

create table dept_copia like departments;

delimiter //
create event copia_departments on schedule at '2021-01-30 23:15:00' do begin insert into dept_copia select * from departments; end //
delimiter ;

-- 3) tabla que guarda número de empleados cada 4 días

create table empleados_numero_mensual ( fecha datetime, total_empleados int );

delimiter //
create event contar_empleados on schedule every 4 day starts now() do begin insert into empleados_numero_mensual (fecha, total_empleados) select now(), count(*) from employees; end //
delimiter ;

-- 4) actualizar salarios de managers un 10% cada 1 de enero durante 5 años

delimiter //
create event actualizar_salarios_managers on schedule every 1 year starts '2026-01-01 00:00:00' ends '2031-01-01 00:00:00' do begin update employees e join departments d on e.id = d.manager_id set e.salary = e.salary * 1.10; end //
delimiter ;


-- RELACIÓN DE EJERCICIOS SOBRE VISTAS 

-- 1) vista con empleados con salario superior a 85000

create view empleados_salario_alto as select first_name, last_name from employees where salary > 85000;

create user 'usuario_vista1'@'%' identified by 'password';
grant select on empleados_salario_alto to 'usuario_vista1'@'%';

-- 2) vista con datos de titles de empleados actuales

create view vista_titles_actuales as select t.* from titles t where t.to_date = '9999-01-01';

create or replace view vista_titles_actuales as select t.* from titles t where t.to_date = '9999-01-01' with check option;

create user 'usuario_vista2'@'%' identified by 'password';
grant select, update, delete on vista_titles_actuales to 'usuario_vista2'@'%';

-- 3) vista de empleados que pertenecen al 'staff'

create view empleados_staff as select e.* from employees e join titles t on e.emp_no = t.emp_no where t.title = 'staff' and t.to_date = '9999-01-01';

create view empleados_staff_departamento as select e.first_name, e.last_name, d.dept_name from empleados_staff e join dept_emp de on e.emp_no = de.emp_no join departments d on de.dept_no = d.dept_no where de.to_date = '9999-01-01';

-- 4) vista de empleados nacidos entre 1950 y 1955 con permisos del usuario

create or replace sql security invoker view empleados_1950_1955 as select * from employees where birth_date between '1950-01-01' and '1955-12-31';

create user 'usuario_vista3'@'%' identified by 'password';
grant select, insert, update, delete on employees to 'usuario_vista3'@'%';
grant select, insert, update, delete on empleados_1950_1955 to 'usuario_vista3'@'%';