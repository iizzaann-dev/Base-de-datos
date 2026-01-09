#Creamos una cuenta
create user 'miguel'@'localhost' identified by '1234';
#Creamos la cuenta si no existe
create user if not exists 'miguel'@'localhost' identified by '1234';

#Borramos una cuenta
drop user 'miguel'@'localhost';
drop user if exists 'miguel'@'localhost';

#Consultar las cuentas de usuarios creadas en el servidor
select user, host from mysql.user;

