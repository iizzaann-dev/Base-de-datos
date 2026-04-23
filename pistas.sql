DELIMITER //

CREATE PROCEDURE listar_clientes_por_region(IN p_region VARCHAR(100))
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_nombre_cliente VARCHAR(100);
    DECLARE v_nombre_contacto VARCHAR(100);
    DECLARE v_apellido_contacto VARCHAR(100);

    -- Cursor
    DECLARE cur_clientes CURSOR FOR
        SELECT nombre_cliente, nombre_contacto, apellido_contacto
        FROM cliente
        WHERE ciudad = p_region OR region = p_region;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur_clientes;

    bucle: LOOP
        FETCH cur_clientes INTO v_nombre_cliente, v_nombre_contacto, v_apellido_contacto;

        IF done THEN
            LEAVE bucle;
        END IF;

        SELECT CONCAT(
            'Cliente: ', v_nombre_cliente,
            ' - Contacto: ', v_nombre_contacto, ' ', v_apellido_contacto
        ) AS mensaje;

    END LOOP;

    CLOSE cur_clientes;
END //

DELIMITER ;




CREATE TABLE auditoria_pagos (
    id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT,
    fecha_pago DATE,
    total DECIMAL(10,2),
    fecha_registro DATETIME
);

DELIMITER //

CREATE TRIGGER pago_insert
AFTER INSERT ON pago
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_pagos (id_cliente, fecha_pago, total, fecha_registro)
    VALUES (NEW.id_cliente, NEW.fecha_pago, NEW.total, NOW());
END //

DELIMITER ;



-- Activar el scheduler (si no está activo)
SET GLOBAL event_scheduler = ON;

DELIMITER //

CREATE EVENT limpiar_auditoria_vieja
ON SCHEDULE
    EVERY 1 MONTH
    STARTS CURRENT_DATE + INTERVAL 1 DAY
DO
BEGIN
    DELETE FROM auditoria_pagos
    WHERE fecha_registro < NOW() - INTERVAL 6 MONTH;
END //

DELIMITER ;































-- =====================================================
-- ELIMINAR Y CREAR BASE DE DATOS
-- =====================================================

DROP DATABASE IF EXISTS instituto_demo; -- Borra la BD si ya existe
CREATE DATABASE instituto_demo;         -- Crea la BD
USE instituto_demo;                     -- Selecciona la BD

-- =====================================================
-- 1. TABLAS
-- =====================================================

-- Tabla de alumnos
CREATE TABLE alumnos (
    id_alumno INT PRIMARY KEY AUTO_INCREMENT, -- Identificador único
    nombre VARCHAR(100) NOT NULL,             -- Nombre del alumno
    email VARCHAR(100) UNIQUE,                -- Email único
    saldo DECIMAL(10,2) DEFAULT 0.00          -- Dinero disponible
);

-- Tabla de cursos
CREATE TABLE cursos (
    id_curso INT PRIMARY KEY AUTO_INCREMENT, -- ID del curso
    nombre_curso VARCHAR(100) NOT NULL,      -- Nombre del curso
    precio DECIMAL(10,2) NOT NULL,           -- Precio del curso
    plazas INT NOT NULL                      -- Plazas disponibles
);

-- Tabla de matrículas (relación alumno-curso)
CREATE TABLE matriculas (
    id_matricula INT PRIMARY KEY AUTO_INCREMENT,
    id_alumno INT NOT NULL,
    id_curso INT NOT NULL,
    fecha_matricula DATETIME DEFAULT CURRENT_TIMESTAMP, -- Fecha automática
    FOREIGN KEY (id_alumno) REFERENCES alumnos(id_alumno), -- Relación con alumnos
    FOREIGN KEY (id_curso) REFERENCES cursos(id_curso)     -- Relación con cursos
);

-- Tabla de pagos realizados por alumnos
CREATE TABLE pagos (
    id_pago INT PRIMARY KEY AUTO_INCREMENT,
    id_alumno INT NOT NULL,
    cantidad DECIMAL(10,2) NOT NULL,          -- Cantidad pagada
    fecha_pago DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_alumno) REFERENCES alumnos(id_alumno)
);

-- Tabla de auditoría (registro de acciones)
CREATE TABLE auditoria_alumnos (
    id_auditoria INT PRIMARY KEY AUTO_INCREMENT,
    accion VARCHAR(50),                       -- Tipo de acción (INSERT, UPDATE...)
    id_alumno INT,
    nombre VARCHAR(100),
    fecha_accion DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Tabla para registrar eventos automáticos
CREATE TABLE log_eventos (
    id_log INT PRIMARY KEY AUTO_INCREMENT,
    descripcion VARCHAR(200),
    fecha_log DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 2. DATOS INICIALES
-- =====================================================

-- Insertar alumnos de prueba
INSERT INTO alumnos (nombre, email, saldo) VALUES
('Ana López', 'ana@mail.com', 500.00),
('Luis Pérez', 'luis@mail.com', 300.00),
('Marta Ruiz', 'marta@mail.com', 150.00);

-- Insertar cursos de prueba
INSERT INTO cursos (nombre_curso, precio, plazas) VALUES
('MySQL Básico', 100.00, 3),
('MySQL Avanzado', 200.00, 2),
('Administración BD', 150.00, 1);

-- =====================================================
-- 3. VISTA
-- =====================================================

-- Vista que muestra información combinada de matrículas
CREATE OR REPLACE VIEW vista_matriculas AS
SELECT
    m.id_matricula,
    a.nombre AS alumno,       -- Nombre del alumno
    c.nombre_curso AS curso,  -- Nombre del curso
    c.precio,
    m.fecha_matricula
FROM matriculas m
JOIN alumnos a ON m.id_alumno = a.id_alumno
JOIN cursos c ON m.id_curso = c.id_curso;

-- =====================================================
-- 4. TRIGGERS
-- =====================================================

DELIMITER $$

-- Trigger que se ejecuta después de insertar un alumno
-- Sirve para guardar un registro en la auditoría
CREATE TRIGGER trg_alumnos_after_insert
AFTER INSERT ON alumnos
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_alumnos (accion, id_alumno, nombre)
    VALUES ('INSERT', NEW.id_alumno, NEW.nombre);
END$$

-- Trigger que se ejecuta antes de actualizar un alumno
-- Evita que el saldo sea negativo
CREATE TRIGGER trg_alumnos_before_update
BEFORE UPDATE ON alumnos
FOR EACH ROW
BEGIN
    IF NEW.saldo < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El saldo no puede ser negativo';
    END IF;
END$$

DELIMITER ;

-- =====================================================
-- 5. FUNCIÓN
-- =====================================================

DELIMITER $$

-- Función que devuelve el saldo de un alumno
CREATE FUNCTION fn_saldo_alumno(p_id_alumno INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE v_saldo DECIMAL(10,2);

    SELECT saldo
    INTO v_saldo
    FROM alumnos
    WHERE id_alumno = p_id_alumno;

    RETURN IFNULL(v_saldo, 0.00); -- Devuelve 0 si no existe// No hemos dado el IFNULL
END$$

DELIMITER ;

-- =====================================================
-- 6. PROCEDIMIENTO CON TRANSACCIÓN
-- =====================================================

DELIMITER $$

-- Procedimiento para matricular un alumno
-- Usa transacciones para asegurar consistencia
CREATE PROCEDURE sp_matricular_alumno(
    IN p_id_alumno INT,
    IN p_id_curso INT
)
BEGIN
    DECLARE v_precio DECIMAL(10,2);
    DECLARE v_saldo DECIMAL(10,2);
    DECLARE v_plazas INT;

    -- Manejo de errores: si falla algo, rollback
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Error técnico. Transacción cancelada.' AS resultado;
    END;

    START TRANSACTION; -- Inicia transacción

    -- Obtener precio y plazas del curso
    SELECT precio, plazas
    INTO v_precio, v_plazas
    FROM cursos
    WHERE id_curso = p_id_curso
    FOR UPDATE;

    -- Obtener saldo del alumno
    SELECT saldo
    INTO v_saldo
    FROM alumnos
    WHERE id_alumno = p_id_alumno
    FOR UPDATE;

    -- Validaciones
    IF v_plazas <= 0 THEN
        ROLLBACK;
        SELECT 'No hay plazas disponibles' AS resultado;

    ELSEIF v_saldo < v_precio THEN
        ROLLBACK;
        SELECT 'Saldo insuficiente' AS resultado;

    ELSE
        -- Insertar matrícula
        INSERT INTO matriculas (id_alumno, id_curso)
        VALUES (p_id_alumno, p_id_curso);

        -- Descontar saldo
        UPDATE alumnos
        SET saldo = saldo - v_precio
        WHERE id_alumno = p_id_alumno;

        -- Reducir plazas
        UPDATE cursos
        SET plazas = plazas - 1
        WHERE id_curso = p_id_curso;

        COMMIT; -- Confirmar cambios
        SELECT 'Matrícula realizada correctamente' AS resultado;
    END IF;
END$$

DELIMITER ;

-- =====================================================
-- 7. PROCEDIMIENTO CON SAVEPOINT
-- =====================================================

DELIMITER $$

-- Procedimiento para registrar un pago
CREATE PROCEDURE sp_pago_con_savepoint(
    IN p_id_alumno INT,
    IN p_cantidad DECIMAL(10,2)
)
BEGIN
    -- Manejo de errores
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Error general. Operación cancelada.' AS resultado;
    END;

    START TRANSACTION;

    -- Insertar pago
    INSERT INTO pagos (id_alumno, cantidad)
    VALUES (p_id_alumno, p_cantidad);

    SAVEPOINT pago_realizado; -- Punto de guardado

    -- Sumar saldo al alumno
    UPDATE alumnos
    SET saldo = saldo + p_cantidad
    WHERE id_alumno = p_id_alumno;

    COMMIT;
    SELECT 'Pago registrado correctamente' AS resultado;
END$$

DELIMITER ;

-- =====================================================
-- 8. EVENTO
-- =====================================================

DELIMITER $$

-- Evento automático que se ejecuta cada minuto
CREATE EVENT IF NOT EXISTS ev_log_minuto
ON SCHEDULE EVERY 1 MINUTE
DO
BEGIN
    INSERT INTO log_eventos (descripcion)
    VALUES ('Evento automático ejecutado');
END$$

DELIMITER ;

-- =====================================================
-- 9. PRUEBAS
-- =====================================================

-- Ver alumnos
SELECT * FROM alumnos;

-- Ver cursos
SELECT * FROM cursos;

-- Probar función
SELECT fn_saldo_alumno(1) AS saldo_ana;

-- Probar matrícula
CALL sp_matricular_alumno(1, 1);

-- Ver resultados
SELECT * FROM vista_matriculas;
SELECT * FROM alumnos;
SELECT * FROM cursos;

-- Probar pago
CALL sp_pago_con_savepoint(2, 50.00);

-- Ver pagos
SELECT * FROM pagos;

-- Ver saldo actualizado
SELECT * FROM alumnos;

-- Ver auditoría
SELECT * FROM auditoria_alumnos;

-- Ver logs del evento
SELECT * FROM log_eventos;

/*
-- DECIMAL(M,D)
-- M = total cifras
-- D = decimales
-- Exacto
-- Perfecto para dinero
NEW.id_alumno → el id del alumno que se acaba de insertar
NEW.nombre → el nombre que se acaba de insertar
🧾 Traducción simple

NEW.campo =
👉 “el valor que va a tener ese campo después de la operación”
*/