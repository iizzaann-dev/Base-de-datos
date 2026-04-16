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