-- Creamos una base de datos --
DROP DATABASE IF EXISTS proveedores;
CREATE DATABASE proveedores CHARSET utf8mb4;
USE proveedores;

CREATE TABLE categoria (
	id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	nombre VARCHAR (100) NOT NULL
);

CREATE TABLE pieza (
	id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR (100) NOT NULL,
    color VARCHAR (50) NOT NULL,
    precio DECIMAL (7 ,2) NOT NULL CHECK (precio > 0),
    id_categoria INT UNSIGNED NOT NULL,
    FOREIGN KEY (id_categoria) REFERENCES categoria (id)
    );