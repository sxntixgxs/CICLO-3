CREATE DATABASE mundo;

/* 
para ejecutar el script de una base de datos, es decir crearla ? el comando es 
mysql -h localhost - santiago -p wolrd ./world.sql
*/

USE mundo;

CREATE TABLE IF NOT EXISTS pais(
	id INT, 
    nombre VARCHAR(20),
    continente VARCHAR(50),
    poblacion INT
);

CREATE TABLE temp(
	id INTEGER,
    dato VARCHAR(20)
);

DROP TABLE temp;

ALTER TABLE pais ADD PRIMARY KEY(id);
-- comment
DESCRIBE pais;

-- insertar datos

INSERT INTO pais (id,nombre,continente,poblacion) VALUES (101,"Colombia","Sur America",50000000);

SELECT * FROM pais;

INSERT INTO pais (id,nombre,continente) VALUES (102,"Venezuela","Sur America");

INSERT INTO pais (id,nombre,continente,poblacion) VALUES (103,"Guyana",NULL,NULL);

DELETE FROM pais WHERE id=102 OR id=103;
INSERT INTO pais (id,nombre,continente,poblacion) VALUES (102,"Ecuador","Sur America","17000000");

INSERT INTO pais (id,nombre,continente,poblacion) VALUES (103,"Guatepior","Centro America",18000000);

-- cuando son varios inserts:

INSERT INTO pais (id,nombre,continente,poblacion)
VALUES (104,"Mexico","Centro America",126000000),
(105,"Estados Unidos","Norte America",331000000),
(106,"Canada","Centro America",380000000);

SELECT * FROM pais;

-- actualizar datos

/*UPDATE nombre_tabla
SET columna1 = valor1,columna2 = valor2,...
WHERE condicion;*/
-- actualizamos el campo poblacion del id 101
UPDATE pais
SET poblacion = 50887423
WHERE id = 101;

-- COPIA DE SEGURIDAD PARA TRABAJAR JE

CREATE TABLE temp AS SELECT * FROM pais;

DROP TABLE temp;

CREATE TABLE temp AS SELECT nombre,poblacion FROM pais;

-- BORRADO DE DATOS

/* Sintaxis del borrado de datos DML
	DELETE FROM nombre_tabla
    WHERE condicion;
    
    DELETE FROM nombre_tabla
    WHERE condicion
    LIMIT cantidad_registros;
*/

SELECT * FROM pais;

DELETE FROM pais WHERE id=106;

-- ELIMINAR TODOS LOS REGISTROS DE UNA TABLA 
/*
TRUNCATE ES DDL
*/
TRUNCATE TABLE temp;


-- DQL: SELECT

/* 
	SELECT nombre_campos
    FROM nombre_tablas
	WHERE condicion;
*/

-- mostrar un listado con todos los paises registrados en la tabla pais

SELECT nombre FROM pais;

-- mostrar un listado de todos los paises de la tabla pais ordenados alfabeticamente descendente

SELECT nombre FROM pais ORDER BY nombre DESC;

-- mostrar el pais con mayor poblacion

SELECT nombre,poblacion FROM pais ORDER BY poblacion DESC LIMIT 1;

-- ALIAS DE CAMPOS

SELECT nombre AS País,poblacion AS Población FROM pais ORDER BY poblacion DESC LIMIT 1;

-- ALIAS DE TABLAS

SELECT P.nombre AS País, P.población AS Poblacion FROM pais AS P ORDER BY P.población DESC LIMIT 1;

-- OPERADORES DE COMPARACION EN EL WHERE = < 
-- OPERADORES LOGICOS EN EL WHERE AND OR NOT

-- Mostrar el listado de los paises ordenados alfabeticamente con poblacion < 100M.

SELECT nombre AS Nombre,poblacion AS Población
FROM pais
WHERE poblacion < 100000000
ORDER BY nombre; 

-- Mostrar el listado de los 2 paises con menor poblacion ordenados por la poblacion desc y el nombre del pais asc;

SELECT nombre AS Nombre,poblacion AS Población
FROM pais
WHERE MIN(poblacion)
ORDER BY poblacion DESC ,nombre ASC LIMIT 2; 