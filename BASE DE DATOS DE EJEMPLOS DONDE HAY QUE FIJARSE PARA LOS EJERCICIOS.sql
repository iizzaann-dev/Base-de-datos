CREATE TABLE ejemplos_alter;
USE ejemplos_alter;

CREATE TABLE usuario (
	id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR (25),
    rol ENUM ('Estudiante', 'Profesor') NOT NULL
);

DESCRIBE usuario; 

ALTER TABLE usuario MODIFY nombre VARCHAR (50) NOT NULL;
ALTER TABLE usuario CHANGE nombre nombre_de_usuario VARCHAR (50) NOT NULL;

INSERT INTO usuario (nombre) VALUES ('Antonio');
INSERT INTO usuario (nombre) VALUES ('Maria');

SELECT * FROM usuario;

ALTER TABLE usuario ALTER rol SET DEFAULT 'Profesor';
ALTER TABLE Usuario ALTER rol DROP DEFAULT; 
ALTER TABLE usuario DROP fecha_nacimiento; 

ALTER TABLE usuario ADD fecha_nacimiento DATE NOT NULL;
ALTER TABLE usuario ADD apellido1 VARCHAR(50) AFTER nombre;
ALTER TABLE usuario ADD apellido2 VARCHAR(50) AFTER apellido1;

ALTER TABLE usuario (nombre, fecha_nacimiento) VALUES ('Antonio', '1990-01-01');
ALTER TABLE usuario (nombre, fecha_nacimiento) VALUES ('María José', '1980-05-01');

SELECT * FROM usuario;

DESCRIBE usuario;
SHOW TABLES; 
