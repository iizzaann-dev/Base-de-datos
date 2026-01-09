
drop database if exists empresa_de_transporte;

create database empresa_de_transporte;

use empresa_de_transporte;

create table camioneros (
	DNI char (9) primary key,
    nombre varchar (30),
    apellidos varchar(50),
    direccion varchar (50),
    salario int (5),
    poblacion varchar (30)
);

create table camiones (
	matricula varchar (7) primary key,
    modelo varchar (20),
    tipo varchar (20),
    potencia varchar (20)
);

create table provincias (
	codigo_provincia varchar (10) primary key,
    descripcion varchar (50),
    destinatario varchar (50),
    direccion varchar (40)
);

create table paquetes (
	codigo_paquetes varchar(10) primary key,
    descripcion varchar (50),
    destinatario varchar (50),
    direccion varchar (40),
    DNI char (9),
    codigo_provincia varchar (10),
    foreign key (DNI) references camioneros (DNI),
    foreign key (codigo_provincia) references provincias (codigo_provincia)
);

create table conduce (
	DNI char (9) not null,
    matricula char(7),
    fecha date not null,
    primary key(DNI, matricula, fecha),
    foreign key (DNI) references camioneros (DNI),
    foreign key (matricula) references camiones(matricula)
);