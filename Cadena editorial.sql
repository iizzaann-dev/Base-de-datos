drop database if exists cadena_editorial ;

create database cadena_editorial;

use cadena_editorial;

create table Sucursales(
	codigo varchar (10) primary key,
    domicilio varchar (40),
    telefono char (15)
);

create table periodistas(
	NIE char (9) primary key,
    nombre varchar (30), 
    apellidos varchar (50),
    telefono char (15),
    especialidad varchar(20)
);

create table revistas(
	n_registro char(30) primary key,
    titulo varchar (50),
    periodicidad varchar (50), 
    tipo varchar(30)
);

create table empleados(
	NIF char (9) primary key,
    nombre varchar (30),
    apellido varchar 
);