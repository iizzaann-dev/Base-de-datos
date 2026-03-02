use employees;

set @nombre = "pepe";
set @edad = 12;

select @nombre;
select @edad;

use employees;
set @salarioMinimo = 1000;
select distinct * from employees where salary > @salarioMinimo;

-- 2) Guarda el valor de una consulta en una variable 
use employees;
select count(*) into @numEmpleado from employees where department_id = 5;
select @numEmpleado;

-- 3) Podemos guardar uno o varios valores, teniendo en cuenta que cada variable se corresponde en el mismo orden con el select asciado. 
-- El numero de columnas obtenidas en el select se deben de corresponder con el mismo numero de variables
-- Si el select tiene 5 columnas necesitamos 4 variables en la clausula into 
use employees;
select max(salary), min(salary) into @maximo, @minimo from employees;
select @maximo as "Salario Máximo", @minimo as "Salario Mínimo";

-- 4) Podemos asginar valores a varias variables en la misma línea
use employees;
set @dep_no = "100", @dept_name = "Departamento de prueba";
insert into departments (department_id, department_name) values (@dept_no, @dept_name);

-- 5) Podemos generar "nuevas" variables en base a valores de otras variables por medio de expresiones
set @dept_no = "100", @dept_name = "Departamento de prueba";
set @cadenaCompleta = concat(@dept_no, " >  ", @dept_name);
select @cadenaCompleta;

DELIMITER $$
create procedure employees.department_getList()
begin
select department_id, department_name from departments;
end$$
DELIMITER ;


call employees.department_getList();

show procedure status;


alter procedure employees.department_getList comment "Obtiene un listado de todos los departamentos";
show procedure status  where Db = "employees";

drop procedure employees.department_getList;


delimiter \\
create definer  = "root"@"localhost" procedure department_getCount ()
comment "Obtiene el numero de departamentos"
begin
	declare numDepts int default 0;
    select count(*) into numDepts from departments; 
    select numDepts;
end\\
delimiter ;
call department_getCount();


delimiter $$
create procedure employees.get_employees_salary_greater (in salario_min int)
begin 
	select * from employees.employees where salary > salario_min;
end$$
delimiter ;

call employees.get_employees_salary_greater(10000);


delimiter //
create procedure employees.obtener_salario (in param_id_empleado int, out param_salario decimal(8,2))
begin
	select salary into param_salario
    from employees.employees where employee_id = param_id_empleado;
end //
delimiter ;

call employees.obtener_salario(100, @salario);
select @salario;

delimiter ºº
create procedure aumentar_salario(inout p_salario decimal(10,2))
begin
	set p_salario = p_salario * 1.10;
end ºº
delimiter ;

delimiter //
create procedure valor (inout valor varchar(10))
begin
	if (valor < 0)
    valor = "El número introducido es negativo";
    else
    valor = "El número introducido es posit
    }
end//
delimiter ;