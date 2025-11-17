-- Eliminamos la base de datos si existe
drop database if exists tiendaMoviles;

-- Creamos la base de datos
create database tiendaMoviles;

-- Selecciono la base de datos tiendaMoviles
use tiendaMoviles;

-- Creamos la tabla empleados
create table empleados (
	DNI_empleados char (9) primary key,
    nombre_empleados varchar (40) not null,
    apellidos_empleados varchar (50) not null,
    fecha_alta date not null,
    cuenta_ban char (40) not null
);

-- Creamos la tabla clientes
create table clientes (
	DNI_clientes char(9) primary key,
    nombre_clientes varchar(40) not null, 
    apellidos_clientes varchar(50) not null,
    tarjeta_cred varchar(20) not null
);

-- Creamos la tabla ventas
create table ventas (
	cod_venta varchar (20) primary key,
    fecha date not null,
    DNI_emp char(9) not null,
    foreign key (DNI_emp) references empleados(DNI_empleados),
    DNI_cliente char(9) not null,
    foreign key (DNI_cliente) references clientes (DNI_cleintes)
);

create table moviles (
	cod_movil int primary key,
    fabricante varchar (50) not null, 
    marca varchar (50),
    modelo varchar (30), 
    precio_coste decimal (6 ,2),
    precio_venta decimal (6,2)
);

create table moviles_ventas (
	cod_movil varchar(20) not null,
    cod_venta varchar(20) not null, 
    color varchar (10) not null,
    primary key(cod_movil, cod_venta),
    foreign key (cod_movil) references moviles (cod_movil),
    foreign key (cod_venta) references ventas (cod_ventas)
);