-- SESION 3 GESTION DE DATOS CON SQL

-- CREAR TABLAS TEMPORALES

/*
CREATE TABLE nueva_tabla
AS
SELECT columna1,columna2,...
FROM tabla_origen
WHERE condicion;

*/

-- PARA EL EJEMPLO 5 DE AYER
-- MOSTRAR LOS 5 PAISES DE EUROPA CON MENOR EXPECTATIVA DE VIDA. MOSTRAR EL LISTADO DESCENDENTEMENTE POR LA EXPECTATIVA DE VIDA Y EL NOMBRE DEL PAÍS.
CREATE TABLE exp_vida
SELECT C.name, C.LifeExpectancy
FROM world.country AS C
WHERE C.Continent = "Europe" AND C.LifeExpectancy IS NOT NULL
ORDER BY C.LifeExpectancy
LIMIT 5;

SELECT * FROM exp_vida;
SELECT * FROM exp_vida ORDER BY LifeExpectancy DESC, name;



-- EJERCICIO
-- CREAR UNA TABLA TEMPORAL LLAMADA EMPLEADOS_DEPARTAMENTOS_X LA CUAL CONTENDRA
-- LA INFORMACION DE LOS EMPLEADOS (NOMBRE Y SALARIO) DE LA TABLA EMPLEADOS.
-- ESTOS EMPLEADOS TRABAJAN EN EL DEPARTAMENTO X Y GANAN MAS DE 1.200.000

CREATE TABLE empleados_departamentos_x
SELECT E.Nombre, E.Salario
FROM empleados AS E
WHERE E.departamento = "X" AND E.Salario>=1200000;

-- Ejercicio 2
/* Crear una nueva tabla llamada tempPais que contenga las columnas 'nombre' y 'poblacion', seleccionando los registros
	de la tabla 'country' donde la población sea igual o inferior a 100.000.000. La tabla se encuentra 
    en la base de datos world
*/
USE world;
CREATE TABLE tempPais
SELECT C.name AS Name, C.population AS Population
FROM country as C
WHERE population <=100000000;

/* CREATE TABLE tempPais AS
		SELECT C.name as Nombre, C.Population as Population
        FROM country AS C
		WHERE population <=100000000;
*/
SELECT * FROM tempPais;

DROP TABLE tempPais;


-- RELACIONES ENTRE TABLAS
-- RELACION DE UNO A MUCHOS

CREATE SCHEMA biblioteca;
DROP SCHEMA biblioteca;
USE biblioteca;

-- crear tabla libro

CREATE TABLE Libro(
	id INT PRIMARY KEY,
    titulo VARCHAR(100),
    autor VARCHAR(100)
);

-- CREAR TABLA PRESTAMOS

CREATE TABLE Prestamo(
	id INT PRIMARY KEY,
    id_libro INT,
    fecha_prestamo DATE,
    fecha_devolucion DATE,
    FOREIGN KEY(id_libro) REFERENCES Libro(id)
);

-- RELACION DE MUCHOS A MUCHOS
-- Estudiante e Inscripción (N:M)

CREATE TABLE Estudiante(
	id INT PRIMARY KEY,
    nombre VARCHAR(100)
);

CREATE TABLE Curso(
	id INT PRIMARY KEY,
    Nombre VARCHAR(100),
    descripcion TEXT
);

CREATE TABLE Inscripcion(
	id_estudiante INT,
    id_curso INT,
    fecha_inscripcion DATE,
    PRIMARY KEY (id_estudiante, id_curso),
    FOREIGN KEY (id_estudiante) REFERENCES Estudiante(id),
    FOREIGN KEY (id_curso) REFERENCES Curso(id)
);
-- --- --- --- --- --- --- --- --- ejercicio, nos muestran la tabla relacional, hacer el script
CREATE TABLE pais(
	id INT PRIMARY KEY,
    nombre VARCHAR(20),
    continente VARCHAR(50),
    poblacion INT
);

CREATE TABLE ciudad(
	id INT PRIMARY KEY,
    nombre VARCHAR(20),
    id_pais INT,
    FOREIGN KEY (id_pais) REFERENCES pais(id)
);

-- --- --- --- --- --- --- --- --- ejercicio, nos muestran la tabla relacional, hacer el script

CREATE TABLE pais(
	id INT PRIMARY KEY,
    nombre VARCHAR(20),
    continente VARCHAR(50),
    poblacion INT
);

CREATE TABLE idioma(
	id INT PRIMARY KEY,
    idioma VARCHAR(50)
);

CREATE TABLE pais_has_idioma(
	id_pais INT,
    id_idioma INT,
    PRIMARY KEY (id_pais,id_idioma),
    FOREIGN KEY (id_pais) REFERENCES pais(id),
    FOREIGN KEY (id_idioma) REFERENCES idioma(id)
);


-- REVISION DE ESTRUCTURAS DE UNA TABLA

-- COMANDO DESCRIBE O desc

-- COMANDO SHOW COLUMNS FROM
USE mundo;
SHOW COLUMNS FROM temp;

-- COMANDO: SHOW CREATE TABLE -> nos muestra cómo se creó la tabla

USE biblioteca;
SHOW CREATE TABLE inscripcion;

-- COMANDO: SHOW TABLE STATUS -> INFORMACIÓN GENERAL DE LA TABLA
SHOW TABLE STATUS LIKE "inscripcion";

-- COMANDO: INFORMACTION_SCHEMA.TABLE Y INFORMATION_SCHEMA.COLUMNS
SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'inscripcion';

SELECT * FROM information_schema.tables WHERE table_schema = 'biblioteca';

-- FUNCIONES Y COMANDOS EN CAMPOS MYSQL

-- 1. CONCAT: CONCATENA DOS O MAS CADENAS DE TEXTO.
USE world;

SELECT CONCAT(name," ",region) AS Ubicacion FROM country LIMIT 5;

-- 2. UPPER: CONVIERTE UNA CADENA A MAYUSCULAS.

SELECT UPPER(CONCAT(name," ",region)) AS Ubicacion FROM country LIMIT 5;
 
-- 3. LOWER: CONVIERTE UNA CADENA A MINUSCULAS.

SELECT LOWER(CONCAT(name," ",region)) AS Ubicacion FROM country LIMIT 5;

-- 4. LENGTH: DEVUELVE LA LONGITUD DE UNA CADENA.

SELECT LOWER(CONCAT(name," ",region)) AS Ubicacion, LENGTH(CONCAT(name," ",region)) AS LARGO FROM country LIMIT 5;

-- MUESTRE UN LISTADO CON LOS 3 PAISES CON EL NOMBRE MAS LARGO.
-- ORDENADOS DEL MAS LARGO AL MENOR

SELECT LENGTH(name) FROM country ORDER BY name DESC LIMIT 5;

-- 7. TRIM: QUITA LOS ESPACIOS AL PRINCIPIO Y AL FINAL(EXISTE EL RTRIM() A LA DERECHA, LTRIM() A LA IZUQIERDA)

