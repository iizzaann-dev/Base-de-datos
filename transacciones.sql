use jardineria;

-- Ejercicio n1 de transacciones

-- Iniciamos la transacción
START TRANSACTION;

-- 1. Insertamos el cliente (Operación Crítica)
INSERT INTO cliente (codigo_cliente, nombre_cliente, nombre_contacto, apellido_contacto, telefono, fax, 
linea_direccion1, ciudad, codigo_empleado_rep_ventas, limite_credito)
VALUES (50, 'Jardines S.A.', 'Juan', 'Pérez', '600112233', '600112234', 'Calle Falsa 123', 'Madrid', 11, 5000);

-- Creamos el primer punto de control: El cliente ya está "seguro" en la transacción
SAVEPOINT cliente_registrado;

-- 2. Insertamos un pago inicial
INSERT INTO pago (codigo_cliente, forma_pago, id_transaccion, fecha_pago, total)
VALUES (50, 'PayPal', 'PAY-999', CURDATE(), 100.00);

-- Creamos el segundo punto de control: El pago también está "seguro"
SAVEPOINT pago_registrado;

-- 3. Intentamos añadir un producto de regalo (un detalle de pedido)-- Supongamos que intentamos regalar un producto que NO existe (error de FK)-- o que simplemente queremos probar si falla.
INSERT INTO detalle_pedido (codigo_pedido, codigo_producto, cantidad, precio_unidad, numero_linea)
VALUES (999, 'PRODUCTO_INEXISTENTE', 1, 0.00, 1);

-- Si la inserción anterior falla o decidimos no dar el regalo:-- VOLVEMOS AL PUNTO DEL PAGO, descartando solo el intento del regalo.
ROLLBACK TO SAVEPOINT pago_registrado;

-- Finalmente, confirmamos el cliente y el pago
COMMIT;


-- Ejercicio n2 de transacciones
DELIMITER //
CREATE PROCEDURE insertar_pedido_seguro(
    IN p_codigo_cliente INT,
    IN p_codigo_pedido INT,
    IN p_codigo_producto VARCHAR(15),
    IN p_cantidad INT,
    IN p_precio_unidad DECIMAL(15,2)
)
BEGIN
    DECLARE v_limite_credito DECIMAL(15,2);
    DECLARE v_total_pedido DECIMAL(15,2);
    -- MANEJADOR DE ERRORES TÉCNICOS
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Error técnico: Transacción anulada.' AS Estado;
    END;
    START TRANSACTION;
    -- Obtener límite de crédito para validación de negocio
    SELECT limite_credito INTO v_limite_credito 
    FROM cliente WHERE codigo_cliente = p_codigo_cliente;
    SET v_total_pedido = p_cantidad * p_precio_unidad;
    IF v_total_pedido > v_limite_credito THEN
        --
-- Validación de negocio fallida
        SELECT 'Límite de crédito excedido. Cancelando...' AS Estado;
        ROLLBACK;
    ELSE
-- Operación 1: Insertar cabecera
        INSERT INTO pedido (codigo_pedido, fecha_pedido, fecha_esperada, estado, codigo_cliente)
        VALUES (p_codigo_pedido, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 7 DAY), 'Pendiente', 
p_codigo_cliente);

-- Operación 2: Insertar detalle
        INSERT INTO detalle_pedido (codigo_pedido, codigo_producto, cantidad, precio_unidad, numero_linea)
        VALUES (p_codigo_pedido, p_codigo_producto, p_cantidad, p_precio_unidad, 1);
        COMMIT;
        SELECT 'Pedido registrado con éxito' AS Estado;
    END IF;
END //
DELIMITER ;


CALL insertar_pedido_seguro(1, 129, 11679, 5, 50);

CALL insertar_pedido_seguro(2, 102, 'PROD002', 10, 20);	


--  



	
    
