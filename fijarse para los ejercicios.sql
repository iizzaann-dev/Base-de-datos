-- Elimina la base de datos 'proveedores' si ya existe, para evitar errores al volver a crearla
DROP DATABASE IF EXISTS proveedores;

-- Crea una nueva base de datos llamada 'proveedores' con el conjunto de caracteres UTF8MB4 
-- (que permite almacenar emojis y todos los caracteres Unicode)
CREATE DATABASE proveedores CHARSET utf8mb4;

-- Selecciona la base de datos 'proveedores' para trabajar en ella
USE proveedores;

-- Crea la tabla 'categoria', que almacenará los diferentes tipos o grupos de piezas
CREATE TABLE categoria (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,  -- Identificador único autoincremental y clave primaria
    nombre VARCHAR(100) NOT NULL                 -- Nombre de la categoría (obligatorio)
);

-- Crea la tabla 'pieza', que contiene información de las piezas y su relación con una categoría
CREATE TABLE pieza (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,  -- Identificador único autoincremental y clave primaria
    nombre VARCHAR(100) NOT NULL,                -- Nombre de la pieza (obligatorio)
    color VARCHAR(50) NOT NULL,                  -- Color de la pieza (obligatorio)
    precio DECIMAL(7,2) NOT NULL,                -- Precio de la pieza, con 7 dígitos en total y 2 decimales
    id_categoria INT UNSIGNED,                   -- Clave foránea que referencia a 'categoria(id)'
    
    -- Se establece la relación con la tabla 'categoria'
    FOREIGN KEY (id_categoria) REFERENCES categoria(id)
        ON DELETE SET NULL   -- Si se elimina una categoría, las piezas asociadas tendrán id_categoria = NULL
        ON UPDATE SET NULL   -- Si se cambia el id de la categoría, las piezas afectadas también quedarán con id_categoria = NULL
);

-- Inserta registros de ejemplo en la tabla 'categoria'
INSERT INTO categoria VALUES (1, 'Categoria A');
INSERT INTO categoria VALUES (2, 'Categoria B');
INSERT INTO categoria VALUES (3, 'Categoria C');

-- Inserta registros de ejemplo en la tabla 'pieza', asociando cada pieza a una categoría mediante 'id_categoria'
INSERT INTO pieza VALUES (1, 'Pieza 1', 'Blanco', 25.90, 1);
INSERT INTO pieza VALUES (2, 'Pieza 2', 'Verde', 25.90, 1);
INSERT INTO pieza VALUES (3, 'Pieza 3', 'Rojo', 25.90, 2);
INSERT INTO pieza VALUES (4, 'Pieza 4', 'Azul', 25.90, 2);

-- Muestra todos los registros almacenados en la tabla 'categoria'
SELECT * FROM categoria;

-- Muestra todos los registros almacenados en la tabla 'pieza'
SELECT * FROM pieza;

-- Elimina la categoría con id = 1
-- Debido a la restricción ON DELETE SET NULL, las piezas que pertenecían a esta categoría
-- mantendrán su registro, pero su campo 'id_categoria' pasará a ser NULL
DELETE FROM categoria WHERE id = 1;
