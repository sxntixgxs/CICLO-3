-- Operacion de Combinacion de Tablas JOINS

USE world;
SELECT C.code, C.name, D.id, D.name, D.countrycode
FROM country AS C, city AS D
-- id = 1 inner join
USE world;
-- Ciudades de Colombia
SELECT P.name, C.name
FROM country AS P
JOIN city AS C ON P.code = C.countrycode
WHERE P.name = "Colombia";

-- id = 2 left join
SELECT name FROM country;

SELECT L.language, P.name
FROM countrylanguage AS L
LEFT JOIN country AS P on L.countrycode = P.code;

-- id = 3 rigth join
DESCRIBE countrylanguage;
INSERT INTO countrylanguage (countrycode, language, isofficial, percentage) VALUES ("ZZZ","Marciano","T",100);

SELECT P.name, C.name
FROM city AS C
RIGHT JOIN country AS P on C.countrycode = P.code
WHERE P.name = "Colombia";


