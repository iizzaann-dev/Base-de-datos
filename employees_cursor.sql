delimiter %%

CREATE DEFINER=`root`@`localhost` PROCEDURE `cursorTest`()
BEGIN
-- Variables donde almacenar lo que nos traemos desde el SELECT
  DECLARE v_emp_no int;
  DECLARE v_first_name varchar(20);
  DECLARE v_last_name varchar(25);
  DECLARE v_email varchar(100);
-- Variable para controlar el fin del bucle
  DECLARE fin BOOL DEFAULT FALSE;

-- El SELECT que vamos a ejecutar
  DECLARE employees_cursor CURSOR FOR
    SELECT emp_no, first_name, last_name, gender, birth_date FROM employees.employees ORDER BY emp_no LIMIT 20;

-- Condición de salida
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin=TRUE;

  OPEN employees_cursor;
  get_employees: LOOP
    FETCH employees_cursor INTO v_emp_no, v_first_name, v_last_name, v_email;
    IF fin = true THEN
       LEAVE get_employees;
    END IF;

	SELECT v_emp_no, v_first_name, v_last_name, v_email;

  END LOOP get_employees;

  CLOSE employees_cursor;
END
delimiter ;
-- Sobre la base de datos employees, realiza un cursor que recorra las filas devueltas por una instrucción SELECT que muestra el nº de empleados que trabaja en cada departamento.
-- Por tanto, el cursor  mostrará dos variables que almacenarán el código de departamento y el nº de empleados que trabaja en dicho departamento. 


delimiter %%
CREATE PROCEDURE `tarea_cursor`()
begin
	-- Variables donde almacenamos el id del departamento y el nº de empleados
	declare id_departamentos int;
	declare cantidad_trabajadores int;
	declare fin boolean default false;

	declare cursor_tarea cursor for select department_id, count(*) cantidad_trabajadores from employees group by department_id;

	declare continue handler for not found set fin = true;
	open cursor_tarea;
	bucle: loop
		fetch cursor_tarea into id_departamentos, cantidad_trabajadores; 
			if fin = true then leave bucle; 
			end if; 
		select id_departamentos, cantidad_trabajadores;
	end loop bucle;
	close cursor_tarea;
end

delimiter ;

call tarea_cursor();