CREATE SCHEMA prueba;
USE prueba;

-- CREACION DE LA TABLA VEHÍCULO

CREATE TABLE vehiculo(
    vhc_id INT PRIMARY KEY,
    marca VARCHAR(50) NOT NULL,
    modelo VARCHAR(50) NOT NULL,
    matricula VARCHAR(10) NOT NULL,
    anio_fabricacion INT NOT NULL
);

-- CREACION DE LA TABLA EMPLEADO

CREATE TABLE empleado(    
    e_id INT PRIMARY KEY,
    apellidos VARCHAR(50) NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    vhc_id INT,
    FOREIGN KEY(vhc_id) REFERENCES vehiculo(vhc_id)
);

-- INSERCION DE DATOS EN LA TABLA VEHICULO
INSERT INTO vehiculo(vhc_id,marca,modelo,matricula,anio_fabricacion) VALUES
(1,"VW",'Caddy','C 0000 YZ',2016),
(2,'Opel','Astra','C 0001 YZ',2010),
(3,'BMW','X6','C 0002 YZ', 2017),
(4,'Porsche','Boxster','C 0003 YZ',2018);

-- INSERCION DE DATOS EN LA TABLA EMPLEADO 
INSERT INTO empleado(e_id,apellidos,nombre,vhc_id)VALUES
(1,'García Hurtado','Macarena',3),
(2,'Ocaña Martínez','Francisco',1),
(3,'Gutiérrez Doblado','Elena',1),
(4,'Hernández Soria','Manuela',2),
(5,'Oliva Cansino','Andrea',NULL);

-- EJEMPLO LEFT JOIN

-- MUESTRE TODOS LOS EMPLEADOS CON SUS VEHICULOS.

USE prueba;
SELECT * FROM empleado
LEFT JOIN vehiculo ON empleado.vhc_id = vehiculo.vhc_id;

-- MUESTRE TODOS LOS EMPLEADOS QUE TIENEN UN VEHICULO ASIGNADO Y LA INFORMACIÓN DEL VEHICULO

SELECT * FROM empleado
LEFT JOIN vehiculo V ON empleado.vhc_id = V.vhc_id
WHERE V.vhc_id IS NOT NULL;

-- EJEMPLOS RIGHT JOIN
-- MUESTRE TODOS LOS EMPLEADOS CON LOS VEHICULOS QUE TENGAN ASIGNADOS.
-- SI HAY ALGUN VEHICULO QUE NO HAYA SIDO ASIGNADO TAMBIEN MOSTRARLPO

SELECT * 
FROM empleado E
RIGHT JOIN vehiculo V ON E.vhc_id = V.vhc_id;

-- FULL JOIN
-- COMBINACION ENTRE LEFT Y RIGHT JOIN

-- CUAL ES EL CONJUNTO COMPLETO DE EMPLEADOS Y VEHICULOS, INCLUYENDO AQUELLOS EMPLEADOS SIN VEHICULO ASIGNADO
-- Y AQUELLOS VEHICULOS  SIN UN EMPLEADO ASOCIADO

-- SIMULACION DE FULL JOIN CON LEFT JOIN Y RIGHT JOIN COMBINADOS CON UNION

SELECT E.*, V.*
FROM empleado E
LEFT JOIN vehiculo V ON E.vch_id = V.vch_id

UNION

SELECT E.*, V.*
FROM empleado E
RIGHT JOIN vehiculo V ON E.vch_id = V.vch_id;
-- HAY ALGUN ERROR ????
-- WHERE E.vch_id IS NULL;
-- PARA EVITAR DUPLICADOS, SE PUEDE EXCLUIR LAS FILAS QUE YA APARECIERON EN EL LEFT JOIN

/*

SUBCONSULTAS
* ANIDADAS
    Para filtrar resultados basados en una condicion evaluada porla subconsulta
    Mostrar una lista de países cuaya poblacion es mayor que el promedio de población de todos los países en la base de datos
    */
    USE world;
    SELECT name, population
    FROM country 
    WHERE population > (SELECT AVG(population) FROM country);
/* 
    SUBCONSULTA EN LA CLAUSULA FROM
    PARA CREAR UN CONJUNTO DE RESULTADOS TEMPORAL QUE LUEGO PUEDE SER TRATADO COMO UNA TABLA EN LA CONSULTA PRINCIPAL
    EJEMPLO: ESTA CONSULTA CALCULARÁ EL PROMEDIO DE POBLACION DE TODAS LAS CIUDADES QUE PERTENECEN AL PAÍS DE VENEZUELA (C0D:"VEN")
    */

    USE world;
    SELECT AVG(population)
    FROM (SELECT population
            FROM city
            WHERE countrycode = "VEN") AS CiudadesPais;

/*

    SUBCONSULTA EN LA CLAUSULA SELECT
    PARA PROPORCIONAR DATOS ADICIONALES EN LAS COLUMNAS DE LOS RESULTADOS
    Proporcionar una lista de países de americ ajunto con el número total de ciudades que tiene cada uno. El listado debe estar ordenado por el número de ciudades del país de forma descendiente.
*/

    USE world;
    SELECT name,(SELECT COUNT(*)
                    FROM city AS C
                    WHERE C.countrycode = P.code) AS NumeroCiudades
    FROM country P
    WHERE P.continent = "North America" OR P.continent = "South America"
    ORDER BY NumeroCiudades DESC;


/*

    SUBCONSULTA CORRELACIONADA
    SE REFIERE A ELEMENTOS DE LA CONSULTA EXTERIOR PARA COMPLETAR SU OPERACION Y SE EJECUTA UNA VEZ POR CADA FILA PROCESADA POR LA CONSULTA EXTERIOR
    . EJEMPLO: MOSTRAR UN LISTADO CON TODAS LAS CIUDADES DE TODA AMERICA CUYA POBLACION ES MAYOR QUE EL PROMEDIO DE LAS CIUDADES EN SU MISMO PAIS
*/

    USE world;
    SELECT C1.name, C1.population
    FROM city AS C1
    INNER JOIN country AS P ON C1.countrycode = P.code
    WHERE (P.continent = "North America" OR P.continent = "South America") AND
            C1.population > (SELECT AVG(C2.population)
                                FROM city AS C2
                                WHERE C2.countrycode = C1.countrycode);

/*
*/


-- EJERCICIOS CLASE:

/* USANDO LA DB world
    1. Listar nombres de países y sus respectivas ciudades:
     • Mostrar todas las ciudades de Colombia.
*/

USE world;

SELECT * FROM city;
SELECT * FROM country;

SELECT CT.name AS Ciudades_Colombia
FROM city AS CT
RIGHT JOIN country AS C ON CT.countrycode = C.code
WHERE C.name = "Colombia";
/*
2. Continentes y sus poblaciones:
    • Mostrar la 5 ciudades más pobladas de América, Europa, Asia y África. Ordenar el
    informe por Continente, luego descendentemente por ciudades
*/
SELECT * FROM city;
SELECT * FROM country;

SELECT CT.name AS Ciudades_Continentes, C.continent AS Continente, CT.Population AS Poblacion
FROM city AS CT
RIGHT JOIN country AS C ON CT.countrycode = C.code
WHERE C.continent <> "Oceania"
ORDER BY Poblacion DESC, Continente, Ciudades_Continentes DESC LIMIT 5 ;

/*
3. Idiomas oficiales:
• Mostrar todos los países de África y sus idiomas oficiales. Ordenar el listado
alfabéticamente por el nombre del idioma.
*/

SELECT * FROM countrylanguage;
SELECT * FROM country;

SELECT C.name AS Country_Name, CL.language AS Language
FROM country AS C
RIGHT JOIN countrylanguage AS CL ON C.code = CL.countrycode
WHERE C.continent = "Africa" AND CL.isofficial = "T"
ORDER BY CL.language;

/*
4. Capitales e idiomas:
• Listar todos los idiomas no oficiales hablados en Santander Colombia.
*/

SELECT * FROM city;
SELECT * FROM country;
SELECT * FROM countrylanguage;

SELECT CL.language AS Lenguajes_Santander
FROM countrylanguage AS CL
RIGHT JOIN city AS CT ON CL.countrycode = CT.countrycode
WHERE CL.isofficial = "F" AND CT.district = "Santander" 
ORDER BY Lenguajes_Santander;

/*
5. Países sin lenguaje oficial:
• Encontrar los países que no tienen idioma oficial registrado.
7. Ciudades habla hispanas de Asia:
• Mostrar la ciudades de Asia y su país, ordenadas por la cantidad de habitantes, que
tienen como idioma español.
/*