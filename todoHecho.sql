CREATE OR REPLACE PROCEDURE resumenPagos(anio INT)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT 
        EXTRACT(YEAR FROM fecha_pago) AS Año,
        forma_pago AS FormaPago,
        COUNT(*) AS CantidadTotal
    FROM pagos
    WHERE EXTRACT(YEAR FROM fecha_pago) = anio
    GROUP BY Año, forma_pago
    ORDER BY forma_pago ASC;
END;
$$;

CREATE TABLE pedidos_pendientes (
    codigoPedido INT,
    fechaPedido DATE,
    fechaEsperada DATE,
    estado VARCHAR(50),
    comentarios TEXT,
    codigoCliente INT
);

CREATE OR REPLACE FUNCTION fn_alarma_pedidos_pendientes()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF NEW.estado = 'Pendiente' THEN
        INSERT INTO pedidos_pendientes
        VALUES (
            NEW.codigo_pedido,
            NEW.fecha_pedido,
            NEW.fecha_esperada,
            NEW.estado,
            NEW.comentarios,
            NEW.codigo_cliente
        );
    END IF;

    RETURN NEW;
END;
$$;

CREATE TRIGGER alarma_pedidos_pendientes
AFTER INSERT OR UPDATE ON pedidos
FOR EACH ROW
EXECUTE FUNCTION fn_alarma_pedidos_pendientes();


CREATE OR REPLACE VIEW empleadosOficina AS
SELECT 
    e.codigo_empleado AS CodigoEmpleado,
    e.nombre AS Nombre,
    e.apellido1 AS Apellido1,
    e.apellido2 AS Apellido2,
    e.codigo_oficina AS CodigoOficina,
    o.ciudad AS Ciudad,
    o.pais AS Pais,
    o.telefono AS Telefono
FROM empleados e
JOIN oficinas o ON e.codigo_oficina = o.codigo_oficina
WHERE o.pais = 'España'
WITH CHECK OPTION;

/*1) PROCEDIMIENTO resumenPagos
CREATE OR REPLACE PROCEDURE resumenPagos(anio INT)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT 
        EXTRACT(YEAR FROM fecha_pago) AS Año,
        forma_pago AS FormaPago,
        COUNT(*) AS CantidadTotal
    FROM pagos
    WHERE EXTRACT(YEAR FROM fecha_pago) = anio
    GROUP BY Año, forma_pago
    ORDER BY forma_pago ASC;
END;
$$;

📌 Nota técnica:

Uso EXTRACT(YEAR FROM fecha_pago) para filtrar por año
COUNT(*) cuenta número de pagos
Agrupación por año + forma de pago (aunque el año es constante, es correcto semánticamente)
2) TRIGGER alarma_pedidos_pendientes
Tabla destino
CREATE TABLE pedidos_pendientes (
    codigoPedido INT,
    fechaPedido DATE,
    fechaEsperada DATE,
    estado VARCHAR(50),
    comentarios TEXT,
    codigoCliente INT
);
Función del trigger
CREATE OR REPLACE FUNCTION fn_alarma_pedidos_pendientes()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF NEW.estado = 'Pendiente' THEN
        INSERT INTO pedidos_pendientes
        VALUES (
            NEW.codigo_pedido,
            NEW.fecha_pedido,
            NEW.fecha_esperada,
            NEW.estado,
            NEW.comentarios,
            NEW.codigo_cliente
        );
    END IF;

    RETURN NEW;
END;
$$;
Trigger
CREATE TRIGGER alarma_pedidos_pendientes
AFTER INSERT OR UPDATE ON pedidos
FOR EACH ROW
EXECUTE FUNCTION fn_alarma_pedidos_pendientes();

📌 Decisión importante:

Uso AFTER INSERT OR UPDATE → captura nuevos pedidos y cambios de estado
Condición dentro de la función (mejor práctica)
3) VISTA empleadosOficina
CREATE OR REPLACE VIEW empleadosOficina AS
SELECT 
    e.codigo_empleado AS CodigoEmpleado,
    e.nombre AS Nombre,
    e.apellido1 AS Apellido1,
    e.apellido2 AS Apellido2,
    e.codigo_oficina AS CodigoOficina,
    o.ciudad AS Ciudad,
    o.pais AS Pais,
    o.telefono AS Telefono
FROM empleados e
JOIN oficinas o ON e.codigo_oficina = o.codigo_oficina
WHERE o.pais = 'España'
WITH CHECK OPTION;
🔹 ¿Es actualizable la vista?

👉 Respuesta corta:
❌ No completamente actualizable

👉 Motivo técnico:

La vista usa un JOIN
PostgreSQL solo permite actualizar vistas simples (una sola tabla sin ambigüedad)
Aquí hay dos tablas → empleados y oficinas

👉 Qué pasa al insertar:

INSERT INTO empleadosOficina (...)

➡️ Fallará o no será directamente posible porque:

No se puede determinar automáticamente en qué tabla insertar todos los campos
Campos como ciudad, pais, telefono pertenecen a oficinas
🔹 ¿Para qué sirve el WITH CHECK OPTION?

Garantiza que:

Cualquier UPDATE/INSERT (si fuera posible) mantenga la condición pais = 'España'
✔️ Resumen claro (para examen)
Procedimiento: agrupa pagos por año y forma de pago
Trigger: guarda pedidos con estado "Pendiente" en otra tabla
Vista: muestra empleados en España pero no es actualizable por usar JOIN

Si quieres, puedo adaptarlo exactamente a tu script (nombres reales de columnas) para que no falle al ejecutar.
*/