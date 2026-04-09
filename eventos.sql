select @@event_scheduler;
use employees;
show events;

show events from employees;

use employees;
create table empleados_numero (fecha datetime, numEmpleados int);

delimiter %
create event  numero_empleados on schedule every 4 second starts now()
ends current_timestamp() + interval 1 minute do
begin
	declare numEmp int default 0;
    select count(*) from employees into numEmp;
    insert into empleados_numero values (now(), numEmp);
end%


select * from empleados_numero;

create event numero_empleados_2 on schedule every 4 second starts now()
ends current_timestamp + interval 1 minute do
insert into empleados_numero select now(), count(*)  from employees;

drop event numero_empleados;

alter event numero_empleados disable;

create table historico_accesos (
	user varchar (50),
    host varchar (50),
    time int
);

create event historico_accesos_minuto 
on schedule every 1 second starts now() ends current_timestamp + interval 1 minute on completion preserve do 
insert into historico_accesos select user, host, time from information_schema.processlist;
    
select * from historico_accesos;

show events from employees;

create table employees_copia like employees;
create event copia_tabla_employees on schedule at "2026-02-03 10:03" on completion preserve do insert into employees_copia select * from employees;

ALTER EVENT copia_tabla_employees
ON SCHEDULE AT '2026-03-27 17:59:20'
ON COMPLETION PRESERVE
DO
  INSERT INTO employees_copia
  SELECT * FROM employees;
  
show events from employees;