use employees;
delimiter %%
CREATE DEFINER=`root`@`localhost` PROCEDURE `employee_add`(numEmp int, nombre varchar(20), apellidos varchar(25), email varchar(100))
BEGIN
    DECLARE error boolean default false;
    DECLARE CONTINUE HANDLER FOR SQLSTATE '23000' SET error=true; 
       
    INSERT INTO employees(employee_id, first_name, last_name, email, hire_date, job_id, salary)
    VALUES (numEmp,nombre,apellidos,email,'1999-01-01', 13, 3000);
    
    IF (error) THEN
	SELECT -1,'Clave primaria duplicada';
    ELSE
        SELECT 0,'Fila añadida';
    END IF;

END%%
delimiter ;

drop procedure if exists employee_add;
call employee_add (90, "Antonio", "Fernandez", "anotnio@gmail.com");


-- Sobre la base de datos employees realiza un script que inserte un registro en la tabla departments. 
-- El script deberá capturar el error en el caso en que se intente añadir un registro con una clave primaria que ya existe en la tabla.
delimiter %%
create procedure nuevo_empleado (department_id int, department_name varchar (30), location_id int)
begin 

	DECLARE error boolean default false;
    DECLARE CONTINUE HANDLER FOR SQLSTATE '23000' SET error=true; 
    
    insert into departments (department_id, department_name, location_id ) values (department_id, department_name, location_id);
    
    if (error) then
	select -1,'Clave primaria duplicada';
    else
        select 0,'Fila añadida';
    end if;
end%%
delimiter ;

call nuevo_empleado (19, "Antonio", 1400);
