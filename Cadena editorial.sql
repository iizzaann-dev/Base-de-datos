drop database if exists cadena_editorial ;

create database cadena_editorial;

use cadena_editorial;

create table sucursales(
	codigo varchar (10) primary key,
    domicilio varchar (40),
    telefono char (15)
);

create table periodistas(
	NIF_periodistas char (9) primary key,
    nombre varchar (30), 
    apellidos varchar (50),
    telefono char (15),
    especialidad varchar(20)
);

create table revistas(
	n_registro char(40) primary key,
    titulo varchar (50),
    periodicidad varchar (50), 
    tipo varchar(30)
);

create table empleados(
	NIF_empleados char (9) primary key,
    nombre varchar (30) not null,
    apellido varchar (50) not null,
    telefono char (15),
    codigo varchar (10),
    foreign key (codigo) references sucursales(codigo)
);

create table publican (
	codigo varchar(10), 
    n_registro char (40),
    primary key (codigo, n_registro),
    foreign key (codigo) references sucursales(codigo),
    foreign key (n_registro) references revistas(n_registro)
    );
    
create table escriben (
	n_registro char (40),
    NIF_periodistas char (9),
    primary key (n_registro, NIF_periodistas),
    foreign key (n_registro) references revistas(n_registro),
    foreign key (NIF_periodistas) references periodistas(NIF_periodistas)
);

create table ejemplares (
	n_registro char (40),
    fecha date not null,
    n_paginas int (100),
    n_ejemplares int(50),
    primary key (n_registro, fecha),
	foreign key (n_registro) references revistas(n_registro)
);

create table secciones (
	titulo varchar (40),
    n_registro char(40),
    extension varchar (30),
    primary key (titulo, n_registro),
    foreign key (n_registro) references revistas(n_registro)
);
