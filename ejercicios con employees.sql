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