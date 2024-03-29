-- importar world

CREATE DATABASE world;

USE world;

SELECT * FROM country;

SELECT * FROM city;

SELECT * FROM countrylanguage;

-- MOSTRAR .:. EL PAIS CON MAYOR POBLACION

SELECT Name,Population FROM country ORDER BY Population DESC LIMIT 1;

-- MOSTRAR LAS CIUDADES CON POBLAICON MENOR A 1 MILLON DE HABITANTES.
-- EL LISTADO DEBE ESTAR ORDENADO POR POBLACION DE MENOR A MAYOR Y SI HAY DOS CIUDADES
-- CON LA MISMA POBLACION MOSTRARLAS EN ORDEN ALFABETICO


SELECT Name,Population FROM city WHERE Population < 1000000 ORDER BY Name;

-- MOSTRAR LOS 3 PAISES CON MAYOR POBLACION DE SURAMERICA

SELECT Name,Population FROM country ORDER BY Population DESC LIMIT 3;

-- MOSTRAR LOS IDIOMAS NO OFICIALES HABLADOS EN COLOMBIA. LOS IDIOMAS DEBE ESTAR ORDENADOS POR EL PORCENTAJE
-- DE HABLA. EL CODIGO DE COLOMBIA ES COL

SELECT Language,Percentage,IsOfficial FROM countrylanguage WHERE CountryCode = "COL" AND IsOfficial="F" ORDER BY Percentage;

-- MOSTRAR LOS 5 PAISES DE EUROPA CON MENOR EXPECTATIVA DE VIDA DE EUROPA

SELECT Name,LifeExpectancy,Continent 
FROM country 
WHERE LifeExpectancy IS NOT NULL AND Continent="Europe" ORDER BY LifeExpectancy LIMIT 5;
