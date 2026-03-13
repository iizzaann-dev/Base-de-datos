-- ==========================================
-- SCRIPT COMPLETO DEMOSTRATIVO ALTER TABLE
-- MySQL 8+
-- ==========================================

DROP DATABASE IF EXISTS alter_demo;
CREATE DATABASE alter_demo;
USE alter_demo;

-- ==========================================
-- TABLAS BASE
-- ==========================================

CREATE TABLE clientes (
    id INT,
    nombre VARCHAR(100),
    email VARCHAR(100),
    edad INT,
    fecha_registro DATE
);

CREATE TABLE productos (
    id INT,
    nombre VARCHAR(100),
    precio DECIMAL(10,2)
);

CREATE TABLE pedidos (
    id INT PRIMARY KEY,
    cliente_id INT,
    producto_id INT,
    cantidad INT,
    precio DECIMAL(10,2),
    fecha DATE,
    
    CONSTRAINT fk_cliente
    FOREIGN KEY (cliente_id)
    REFERENCES clientes(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- ==========================================
-- 1. AGREGAR COLUMNAS
-- ==========================================

ALTER TABLE clientes
ADD COLUMN telefono VARCHAR(20),
ADD COLUMN direccion VARCHAR(255),
ADD COLUMN activo BOOLEAN FIRST,
ADD COLUMN salario DECIMAL(10,2) AFTER nombre;

-- ==========================================
-- 2. MODIFICAR COLUMNAS
-- ==========================================

ALTER TABLE clientes
MODIFY COLUMN salario DECIMAL(12,2) NOT NULL,
MODIFY COLUMN nombre VARCHAR(150) NOT NULL;

-- Cambiar nombre de columna
ALTER TABLE clientes
CHANGE COLUMN nombre nombre_completo VARCHAR(200);

-- ==========================================
-- 3. ELIMINAR COLUMNA
-- ==========================================

ALTER TABLE clientes
DROP COLUMN edad;

-- ==========================================
-- 4. CLAVES PRIMARIAS
-- ==========================================

ALTER TABLE clientes
MODIFY COLUMN id INT NOT NULL,
ADD PRIMARY KEY (id);

ALTER TABLE productos
MODIFY COLUMN id INT NOT NULL,
ADD PRIMARY KEY (id);

-- ==========================================
-- 5. AUTO_INCREMENT
-- ==========================================

ALTER TABLE clientes
MODIFY COLUMN id INT NOT NULL AUTO_INCREMENT,
AUTO_INCREMENT = 1000;

-- ==========================================
-- 6. ÍNDICES
-- ==========================================

ALTER TABLE clientes
ADD INDEX idx_nombre (nombre_completo),
ADD UNIQUE INDEX idx_email (email);

ALTER TABLE pedidos
ADD INDEX idx_cliente_producto (cliente_id, producto_id);

-- FULLTEXT
ALTER TABLE productos
ADD FULLTEXT INDEX idx_nombre_producto (nombre);

-- ==========================================
-- 7. CLAVES FORÁNEAS
-- ==========================================

ALTER TABLE pedidos
ADD CONSTRAINT fk_cliente
FOREIGN KEY (cliente_id)
REFERENCES clientes(id)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE pedidos
ADD CONSTRAINT fk_producto
FOREIGN KEY (producto_id)
REFERENCES productos(id);

-- ==========================================
-- 8. CHECK CONSTRAINT (MySQL 8+)
-- ==========================================

ALTER TABLE clientes
ADD CONSTRAINT chk_salario CHECK (salario >= 0);

-- ==========================================
-- 9. COLUMNAS GENERADAS
-- ==========================================

ALTER TABLE pedidos
ADD COLUMN total DECIMAL(10,2)
GENERATED ALWAYS AS (cantidad * precio) STORED;

-- ==========================================
-- 10. DEFAULT
-- ==========================================

ALTER TABLE clientes
MODIFY COLUMN activo BOOLEAN DEFAULT TRUE;

-- Quitar DEFAULT
ALTER TABLE clientes
ALTER activo DROP DEFAULT;

-- ==========================================
-- 11. NOT NULL / NULL
-- ==========================================

ALTER TABLE productos
MODIFY COLUMN nombre VARCHAR(100) NOT NULL;

ALTER TABLE productos
MODIFY COLUMN precio DECIMAL(10,2) NULL;

-- ==========================================
-- 12. COMENTARIOS
-- ==========================================

ALTER TABLE clientes
MODIFY COLUMN nombre_completo VARCHAR(200)
COMMENT 'Nombre completo del cliente';

ALTER TABLE clientes
COMMENT = 'Tabla principal de clientes';

-- ==========================================
-- 13. ENGINE
-- ==========================================

ALTER TABLE clientes ENGINE=InnoDB;

-- ==========================================
-- 14. CHARACTER SET Y COLLATE
-- ==========================================

ALTER TABLE clientes
CONVERT TO CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

-- ==========================================
-- 15. PARTICIONES
-- ==========================================

CREATE TABLE ventas_particionadas (
    id INT NOT NULL,
    fecha DATE,
    total DECIMAL(10,2)
)
PARTITION BY RANGE (YEAR(fecha)) (
    PARTITION p0 VALUES LESS THAN (2023),
    PARTITION p1 VALUES LESS THAN (2024),
    PARTITION p2 VALUES LESS THAN MAXVALUE
);

-- Agregar partición
ALTER TABLE ventas_particionadas
ADD PARTITION (
    PARTITION p3 VALUES LESS THAN (2026)
);

-- Eliminar partición
ALTER TABLE ventas_particionadas
DROP PARTITION p0;

-- ==========================================
-- 16. ELIMINAR CONSTRAINTS
-- ==========================================

ALTER TABLE pedidos
DROP FOREIGN KEY fk_producto;

ALTER TABLE clientes
DROP CHECK chk_salario;

ALTER TABLE clientes
DROP INDEX idx_nombre;

-- ==========================================
-- 17. RENOMBRAR TABLA
-- ==========================================

ALTER TABLE productos
RENAME TO articulos;

-- ==========================================
-- 18. OPERACIONES MÚLTIPLES
-- ==========================================

ALTER TABLE pedidos
ADD COLUMN estado VARCHAR(50) DEFAULT 'pendiente',
DROP COLUMN fecha,
MODIFY COLUMN cantidad INT NOT NULL;

-- ==========================================
-- 19. OPCIONES AVANZADAS
-- ==========================================

ALTER TABLE clientes
ALGORITHM=INPLACE,
LOCK=NONE,
ADD COLUMN departamento VARCHAR(100);

-- ==========================================
-- FIN DEL SCRIPT
-- ==========================================


alter table  pedidos change cliente_id id_cliente int;
alter table  pedidos modify precio int;


-- Unsigned es un int sin simbolo