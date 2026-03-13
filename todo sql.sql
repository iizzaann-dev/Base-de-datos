/* =====================================================
   SCRIPT COMPLETO SQL
   DDL + DML + DCL + TCL + JOINS + VIEWS + INDEX
   ===================================================== */

/* =========================
   1. DDL - CREAR BASE DATOS
   ========================= */

CREATE DATABASE empresa;

USE empresa;


/* =========================
   2. CREAR TABLAS
   ========================= */

CREATE TABLE departamentos (
    id INT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE empleados (
    id INT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    edad INT,
    salario DECIMAL(10,2),
    departamento_id INT,
    fecha_ingreso DATE,
    email VARCHAR(100) UNIQUE,
    FOREIGN KEY (departamento_id) REFERENCES departamentos(id)
);

CREATE TABLE proyectos (
    id INT PRIMARY KEY,
    nombre VARCHAR(50),
    presupuesto DECIMAL(10,2)
);

CREATE TABLE empleados_proyectos (
    empleado_id INT,
    proyecto_id INT,
    horas INT,
    PRIMARY KEY (empleado_id, proyecto_id),
    FOREIGN KEY (empleado_id) REFERENCES empleados(id),
    FOREIGN KEY (proyecto_id) REFERENCES proyectos(id)
);


/* =========================
   3. ALTER TABLE
   ========================= */

ALTER TABLE empleados
ADD telefono VARCHAR(20);

ALTER TABLE empleados
ADD direccion VARCHAR(100);


/* =========================
   4. INSERT (DML)
   ========================= */

INSERT INTO departamentos VALUES
(1,'IT'),
(2,'Ventas'),
(3,'Marketing');

INSERT INTO empleados VALUES
(1,'Juan',30,3000,1,'2022-01-10','juan@email.com','600111111','Madrid'),
(2,'Ana',25,2500,2,'2023-02-12','ana@email.com','600222222','Barcelona'),
(3,'Luis',35,4000,1,'2021-03-15','luis@email.com','600333333','Valencia'),
(4,'Maria',28,2800,3,'2022-06-20','maria@email.com','600444444','Sevilla');

INSERT INTO proyectos VALUES
(1,'Sistema ERP',100000),
(2,'Web corporativa',20000),
(3,'App móvil',50000);

INSERT INTO empleados_proyectos VALUES
(1,1,120),
(1,2,40),
(2,2,100),
(3,1,200),
(4,3,150);


/* =========================
   5. SELECT BÁSICO
   ========================= */

SELECT * FROM empleados;

SELECT nombre, salario
FROM empleados;


/* =========================
   6. WHERE
   ========================= */

SELECT *
FROM empleados
WHERE salario > 2800;

SELECT *
FROM empleados
WHERE edad > 25 AND salario > 2500;

SELECT *
FROM empleados
WHERE nombre LIKE 'M%';


/* =========================
   7. ORDER BY
   ========================= */

SELECT *
FROM empleados
ORDER BY salario DESC;


/* =========================
   8. FUNCIONES AGREGADAS
   ========================= */

SELECT COUNT(*) AS total_empleados
FROM empleados;

SELECT AVG(salario) AS salario_promedio
FROM empleados;

SELECT MAX(salario) AS salario_max
FROM empleados;

SELECT MIN(salario) AS salario_min
FROM empleados;


/* =========================
   9. GROUP BY
   ========================= */

SELECT departamento_id, COUNT(*) AS empleados
FROM empleados
GROUP BY departamento_id;

SELECT departamento_id, AVG(salario)
FROM empleados
GROUP BY departamento_id
HAVING AVG(salario) > 2800;


/* =========================
   10. JOINS
   ========================= */

SELECT e.nombre, d.nombre AS departamento
FROM empleados e
INNER JOIN departamentos d
ON e.departamento_id = d.id;

SELECT e.nombre, d.nombre
FROM empleados e
LEFT JOIN departamentos d
ON e.departamento_id = d.id;

SELECT e.nombre, p.nombre
FROM empleados e
JOIN empleados_proyectos ep
ON e.id = ep.empleado_id
JOIN proyectos p
ON ep.proyecto_id = p.id;


/* =========================
   11. SUBQUERIES
   ========================= */

SELECT nombre, salario
FROM empleados
WHERE salario >
(
SELECT AVG(salario)
FROM empleados
);


/* =========================
   12. UPDATE
   ========================= */

UPDATE empleados
SET salario = salario + 500
WHERE departamento_id = 1;

UPDATE empleados
SET direccion = 'Madrid'
WHERE id = 1;


/* =========================
   13. DELETE
   ========================= */

DELETE FROM empleados
WHERE id = 4;


/* =========================
   14. VIEWS
   ========================= */

CREATE VIEW vista_salarios_altos AS
SELECT nombre, salario
FROM empleados
WHERE salario > 3000;

SELECT *
FROM vista_salarios_altos;


/* =========================
   15. INDEX
   ========================= */

CREATE INDEX idx_nombre_empleado
ON empleados(nombre);

CREATE INDEX idx_salario
ON empleados(salario);


/* =========================
   16. TCL - TRANSACCIONES
   ========================= */

START TRANSACTION;

UPDATE empleados
SET salario = salario + 100;

SAVEPOINT punto1;

UPDATE empleados
SET salario = salario + 200
WHERE id = 2;

ROLLBACK TO punto1;

COMMIT;


/* =========================
   17. DCL - PERMISOS
   ========================= */

GRANT SELECT, INSERT
ON empleados
TO usuario1;

REVOKE INSERT
ON empleados
FROM usuario1;


/* =========================
   18. TRUNCATE
   ========================= */

TRUNCATE TABLE empleados_proyectos;


/* =========================
   19. DROP
   ========================= */

-- DROP TABLE empleados;
-- DROP TABLE departamentos;
-- DROP DATABASE empresa;
-- TRUNCATE es un comando de SQL que elimina todos los registros de una tabla rápidamente, pero mantiene la estructura de la tabla

/* =========================
   FIN DEL SCRIPT
   ========================= */