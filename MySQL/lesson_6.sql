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
ORDER BY Poblacion DESC, Continente, Ciudades_Continentes DESC LIMIT 5;

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

SELECT DISTINCT CL.language AS Lenguajes_Santander
FROM countrylanguage AS CL
JOIN city AS CT ON CL.countrycode = CT.countrycode
WHERE CL.isofficial = "F" AND CT.district = "Santander" 
ORDER BY Lenguajes_Santander;

/*
5. Países sin lenguaje oficial:
• Encontrar los países que no tienen idioma oficial registrado.
*/

    SELECT DISTINCT C.name
    FROM country AS C
    RIGHT JOIN countrylanguage AS CL ON C.code = CL.countrycode
    WHERE CL.isofficial <> "T";
/*ESTA MAL!*/

    SELECT DISTINCT C.name 
    FROM country AS C
    LEFT JOIN countrylanguage AS CL ON C.code = CL.countrycode
    WHERE CL.countrycode NOT IN (
        SELECT DISTINCT CL2.countrycode
        FROM countrylanguage AS CL2
        WHERE C.code = CL2.countrycode AND isofficial = "T"
    );
/*
7. Ciudades habla hispanas de Asia:
• Mostrar la ciudades de Asia y su país, ordenadas por la cantidad de habitantes, que
tienen como idioma español.
*/
    SELECT CT.name, CT.population
    FROM city AS CT
    RIGHT JOIN country AS C ON CT.countrycode = C.code
    WHERE C.continent = "Asia";

/* PUNTO II
    SCRIPT CREACION TIENDA: */
DROP DATABASE IF EXISTS tienda;
CREATE DATABASE tienda CHARACTER SET utf8mb4;
USE tienda;
CREATE TABLE fabricante (
id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
nombre VARCHAR(100) NOT NULL
);
CREATE TABLE producto (
id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
nombre VARCHAR(100) NOT NULL,
precio DOUBLE NOT NULL,
id_fabricante INT UNSIGNED NOT NULL,
FOREIGN KEY (id_fabricante) REFERENCES fabricante(id)
);
INSERT INTO fabricante VALUES(1, 'Asus');
INSERT INTO fabricante VALUES(2, 'Lenovo');
INSERT INTO fabricante VALUES(3, 'Hewlett-Packard');
INSERT INTO fabricante VALUES(4, 'Samsung');
INSERT INTO fabricante VALUES(5, 'Seagate');
INSERT INTO fabricante VALUES(6, 'Crucial');
INSERT INTO fabricante VALUES(7, 'Gigabyte');
INSERT INTO fabricante VALUES(8, 'Huawei');
INSERT INTO fabricante VALUES(9, 'Xiaomi');
INSERT INTO producto VALUES(1, 'Disco duro SATA3 1TB', 86.99, 5);
INSERT INTO producto VALUES(2, 'Memoria RAM DDR4 8GB', 120, 6);
INSERT INTO producto VALUES(3, 'Disco SSD 1 TB', 150.99, 4);
INSERT INTO producto VALUES(4, 'GeForce GTX 1050Ti', 185, 7);
INSERT INTO producto VALUES(5, 'GeForce GTX 1080 Xtreme', 755, 6);
INSERT INTO producto VALUES(6, 'Monitor 24 LED Full HD', 202, 1);
INSERT INTO producto VALUES(7, 'Monitor 27 LED Full HD', 245.99, 1);
INSERT INTO producto VALUES(8, 'Portátil Yoga 520', 559, 2);
INSERT INTO producto VALUES(9, 'Portátil Ideapd 320', 444, 2);
INSERT INTO producto VALUES(10, 'Impresora HP Deskjet 3720', 59.99, 3);
INSERT INTO producto VALUES(11, 'Impresora HP Laserjet Pro M26nw', 180, 3);

/*

Devuelve una lista con el nombre del producto, precio y nombre de fabricante de todos los
productos de la base de datos.
*/
SELECT * FROM producto;
SELECT * FROM fabricante;


SELECT P.nombre, P.precio, F.nombre AS nombre_fabricante
FROM producto AS P
JOIN fabricante AS F ON P.id_fabricante = F.id; 

-- ??????? 

/*
2. Devuelve una lista con el nombre del producto, precio y nombre de fabricante de todos los
productos de la base de datos. Ordene el resultado por el nombre del fabricante, por orden
alfabético.*/

SELECT P.nombre AS Nombre_Producto, P.precio AS Precio_Producto, F.nombre AS Nombre_fabricante
FROM producto AS P
RIGHT JOIN fabricante AS F ON P.id_fabricante = F.id
ORDER BY F.nombre; 

/*
3. Devuelve una lista con el identificador del producto, nombre del producto, identificador del
fabricante y nombre del fabricante, de todos los productos de la base de datos.*/

SELECT P.id AS ID_Producto,P.nombre AS Nombre_Producto,F.id AS ID_Fabricante , F.nombre AS Nombre_fabricante
FROM producto AS P
JOIN fabricante AS F ON P.id_fabricante = F.id; 
/*
4. Devuelve el nombre del producto, su precio y el nombre de su fabricante, del producto más
barato.*/


    SELECT P.nombre AS Nombre_Producto, P.precio AS Precio_Producto, F.nombre AS Nombre_Fabricante
    FROM producto AS P
    JOIN fabricante AS F ON P.id_fabricante = F.id
    WHERE P.precio = (
        SELECT MIN(P.precio)
        FROM producto AS P
    );

/*
5. Devuelve el nombre del producto, su precio y el nombre de su fabricante, del producto más
caro.*/

SELECT P.nombre AS Nombre_Producto, P.precio AS Precio_Producto, F.nombre AS Nombre_Fabricante
    FROM producto AS P
    JOIN fabricante AS F ON P.id_fabricante = F.id
    WHERE P.precio = (
        SELECT MAX(P.precio)
        FROM producto AS P
    );

/*
6. Devuelve una lista de todos los productos del fabricante Lenovo.*/

SELECT P.nombre AS Lenovo_Products
FROM producto AS P
JOIN fabricante AS F ON P.id_fabricante = F.id
WHERE F.nombre = "Lenovo";

/*
7. Devuelve una lista de todos los productos del fabricante Crucial que tengan un precio mayor
que 200€.*/

SELECT P.nombre AS Product, F.nombre AS Fabricante, P.precio AS Price
FROM producto AS P
JOIN fabricante AS F ON P.id_fabricante = F.id
WHERE F.nombre = "Crucial" AND P.precio > 200;

/*
8. Devuelve un listado con todos los productos de los fabricantes Asus, Hewlett-Packardy
Seagate. Sin utilizar el operador IN.
*/

SELECT * FROM fabricante;
SELECT * FROM producto;

SELECT P.nombre AS Nombre_Producto, F.nombre AS Fabricante
FROM producto AS P
JOIN fabricante AS F ON P.id_fabricante = F.id
WHERE F.nombre = "Asus" OR F.nombre = "Hewlett-Packard" OR F.nombre = "Seagate";


/*
9. Devuelve un listado con todos los productos de los fabricantes Asus, Hewlett-Packardy
Seagate. Utilizando el operador IN.*/


SELECT P.nombre AS Nombre_Producto, F.nombre AS Fabricante
FROM producto AS P
JOIN fabricante AS F ON P.id_fabricante = F.id
WHERE F.nombre IN ("Asus", "Hewlett-Packard", "Seagate");


/*
10. Devuelve un listado con el nombre y el precio de todos los productos de los fabricantes cuyo
nombre termine por la vocal e.*/

SELECT * FROM producto;
SELECT * FROM fabricante;
SELECT P.nombre, P.precio, F.nombre
FROM producto AS P
JOIN fabricante AS F ON P.id_fabricante = F.id
WHERE F.nombre LIKE "%e";

/*
11. Devuelve un listado con el nombre y el precio de todos los productos cuyo nombre de
fabricante contenga el carácter w en su nombre.*/

SELECT P.nombre, P.precio, F.nombre
FROM producto AS P
JOIN fabricante AS F ON P.id_fabricante = F.id
WHERE F.nombre LIKE "%w%";

/*
12. Devuelve un listado con el nombre de producto, precio y nombre de fabricante, de todos los
productos que tengan un precio mayor o igual a 180€. Ordene el resultado en primer lugar
por el precio (en orden descendente) y en segundo lugar por el nombre (en orden ascendente)*/

SELECT P.nombre AS Producto, P.precio AS Precio, F.nombre AS Fabricante
FROM producto AS P
JOIN fabricante AS F ON P.id_fabricante = F.id
WHERE P.precio >= 180
ORDER BY Precio DESC, Producto;


/*
13. Devuelve un listado con el identificador y el nombre de fabricante, solamente de aquellos
fabricantes que tienen productos asociados en la base de datos.*/

SELECT * FROM fabricante;
SELECT * FROM producto;
SELECT DISTINCT F.id AS Identificador, F.nombre AS Nombre
FROM fabricante AS F
INNER JOIN producto AS P ON F.id = P.id_fabricante;

/*
14. Devuelve un listado de todos los fabricantes que existen en la base de datos, junto con los
productos que tiene cada uno de ellos. El listado deberá mostrar también aquellos fabricantes
que no tienen productos asociados.*/
USE tienda;
SELECT F.nombre AS Fabricante, IFNULL(P.nombre, "Sin Registros") AS Producto
FROM fabricante AS F
LEFT JOIN producto AS P ON F.id = P.id_fabricante;


/*
15. Devuelve un listado donde sólo aparezcan aquellos fabricantes que no tienen ningún
producto asociado.*/
SELECT * FROM fabricante;
SELECT * FROM producto;

SELECT F.nombre AS Fabricante
FROM fabricante AS F
LEFT JOIN producto AS P ON F.id = P.id_fabricante
WHERE F.id NOT IN (
    SELECT id_fabricante
    FROM producto
) ;

/*
16. ¿Pueden existir productos que no estén relacionados con un fabricante? Justifique su
respuesta.
No, porque la tabla está diseñada para que esa relacion sea através de una llave foranea por lo que no puede ser null*/

/*
17. Devuelve todos los productos del fabricante Lenovo. (Sin utilizar INNER JOIN).*/
USE tienda;
SELECT * FROM producto;
SELECT * FROM fabricante;

SELECT P.nombre
FROM producto AS P
WHERE P.id_fabricante IN (
    SELECT id
    FROM fabricante
    WHERE nombre = "Lenovo"
);
/*
18. Devuelve todos los datos de los productos que tienen el mismo precio que el producto más
caro del fabricante Lenovo. (Sin utilizar INNER JOIN).*/
USE tienda;
SELECT * FROM fabricante;
SELECT * FROM producto;

    
    SELECT *
    FROM producto
    WHERE precio = (SELECT MAX(C1.precio) AS MayPr
    FROM (
        SELECT *
        FROM producto AS P
        WHERE P.id_fabricante IN (
            SELECT id
            FROM fabricante
            WHERE nombre = "Lenovo"
            )) AS C1);


/*
19. Lista el nombre del producto más caro del fabricante Lenovo.*/

SELECT P.*
FROM producto AS P
WHERE P.precio = (SELECT MAX(C1.precio) AS MayPr
    FROM (
        SELECT *
        FROM producto AS P
        WHERE P.id_fabricante IN (
            SELECT id
            FROM fabricante
            WHERE nombre = "Lenovo"
            )) AS C1);
/*
20. Lista el nombre del producto más barato del fabricante Hewlett-Packard.*/

SELECT P.*
FROM producto AS P
WHERE P.precio = (SELECT MIN(C1.precio) AS MayPr
    FROM (
        SELECT *
        FROM producto AS P
        WHERE P.id_fabricante IN (
            SELECT id
            FROM fabricante
            WHERE nombre = "Hewlett-Packard"
            )) AS C1);

/*
21. Devuelve todos los productos de la base de datos que tienen un precio mayor o igual al
producto más caro del fabricante Lenovo.*/

    SELECT *
    FROM producto
    WHERE precio >= (SELECT MAX(C1.precio) AS MayPr
    FROM (
        SELECT *
        FROM producto AS P
        WHERE P.id_fabricante IN (
            SELECT id
            FROM fabricante
            WHERE nombre = "Lenovo"
            )) AS C1);


/*
22. Lista todos los productos del fabricante Asus que tienen un precio superior al precio medio
de todos sus productos.
*/

    SELECT *
    FROM producto
    WHERE precio >= (SELECT AVG(C1.precio) AS MayPr
    FROM (
        SELECT *
        FROM producto AS P
        WHERE P.id_fabricante IN (
            SELECT id
            FROM fabricante
            WHERE nombre = "Asus"
            )) AS C1);
        
    SELECT P.*
    FROM producto AS P
    JOIN fabricante AS F ON P.id_fabricante = F.id
    WHERE F.nombre = "Asus";
