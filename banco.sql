-- Active: 1708043093342@@127.0.0.1@3306
CREATE DATABASE Banco 
    DEFAULT CHARACTER SET = 'utf8mb4';
USE Banco;

CREATE TABLE IF NOT EXISTS BANCO(
    id_banco integer primary key,
    nombre varchar(45) not null,
    direccion varchar(100) not null
);

CREATE TABLE IF NOT EXISTS SUCURSAL_BANCO(
    id_suc integer,
    direccion varchar(100) not null,
    id_banco integer,
    primary key (id_banco,id_suc),
    foreign KEY (id_banco) references BANCO(id_banco)
);

CREATE TABLE IF NOT EXISTS PRESTAMO(
    id_prestamo integer primary key,
    cantidad integer unsigned not null,
    tipo varchar(45) not null,
    id_suc integer,
    id_banco integer,
    foreign key (id_banco, id_suc) references SUCURSAL_BANCO(id_banco, id_suc)
);
SHOW INDEX FROM SUCURSAL_BANCO;

CREATE TABLE IF NOT EXISTS CUENTA(
    num_cuenta integer primary key,
    saldo decimal not null,
    tipo varchar(45) not null,
    id_banco integer,
    id_suc integer,
    foreign key(id_banco,id_suc) references SUCURSAL_BANCO(id_banco,id_suc)
);

CREATE TABLE IF NOT EXISTS CLIENTE(
    dni integer primary key,
    nombre varchar(45) not null,
    direccion varchar(100) not null,
    telefono varchar(16) not null
)

CREATE TABLE P_C(
    id_prestamo integer,
    dni integer,
    primary key(id_prestamo,dni),
    foreign key(dni) references CLIENTE(dni),
    foreign key(id_prestamo) references PRESTAMO(id_prestamo)
);

CREATE TABLE C_C(
    dni integer,
    num_cuenta integer,
    primary key(dni,num_cuenta),
    foreign key(dni) references CLIENTE(dni),
    foreign key(num_cuenta) references CUENTA(num_cuenta)
);
