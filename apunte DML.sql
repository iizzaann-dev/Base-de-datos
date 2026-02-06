
use reservas;

-- Insertamos un nuevo usuario en la tabla usuarios
insert into usuarios (id, dni, nombre, apellidos, email, ciudad, descuento, fecha_nacimiento, fecha_alta) 
values ('100', '12345678A', 'Antonio', 'Garcia', 'agarcia@gmail.com', 'Málaga', 0.25, '1990-12-12', '2020-12-04');


create table otros_usuarios like usuarios;

insert into otros_usuarios (id, dni, nombre, apellidos, email, descuento, ciudad, fecha_alta) select id, dni, nombre, apellidos, email, descuento, ciudad, fecha_alta from usuarios;


delete from otros_usuarios;

-- Incrementa el precio en un 10% de las pistas de tenis que tengan un precio actual inferior a 20€
update pistas set precio = precio + (precio * 0.10) where precio < 20 and tipo = 'tenis';

-- Reduce el precio de las pistas que no se ham reservado todavia en un 10%
update pistas set precio = precio - precio * 10 where id not in (select id_pista from reservas);