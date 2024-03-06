/*
Enunciados
1. Escribas las sentencias SQL que resuelven los enunciados siguientes teniendo
presente la siguiente estructura de datos.
Escriba su script SQL con diferente color en este documento.

Estructura:
usaremos la tabla cat tabla. Tiene las siguientes columnas:

• id - El id de un gato dado.
• name - El nombre del gato.
• breed - La raza del gato (por ejemplo, siamés, británico de pelo corto,
etc.).
• coloration - Coloración del gato (calicó, atigrado, etc.).
• age - Edad del gato.
• sex - Sexo del gato.
• fav_toy - El juguete favorito del gato.
*/
/*
Seleccione los nombres de todos los gatos machos que no tienen un juguete favorito.
*/
SELECT name, sex, fav_toy FROM cat WHERE fav_toy = NULL;

/* 
Seleccione el ID, el nombre, la raza y la coloración de todos los gatos que son
hembras, que adicionalmente les gusten los juguetes provocadores y que vo sean de
raza persa o siamesa.
*/
SELECT id, name, breed, coloration, sex, fav_toy FROM cat WHERE (sex = "F" AND fav_toy = "provocador") AND (breed <> "PERSA" OR breed <> "SIAMES");

/* 2. Con la base de datos World hacer las consultas propuestas:

Cual es el idioma con el nombre más largo hablado en el mundo. También indique
que países hablan ese idioma. El listado debe estar ordenado alfabéticamente por
nombre de país.*/

USE world;/*ESTO ESTA MAL, CORREGIR*/
SELECT * FROM countrylanguage;
SELECT * FROM country;

SELECT C.name,L.language,LENGTH(L.language) AS largo 
FROM countrylanguage L
INNER JOIN 
    country C
ON
    L.countrycode = C.code
ORDER BY largo DESC, C.name;
/*

II. Muestre un listado del año de independencia de cada país. Si aún no se ha
independizado muestre el AÑO “N/A”

*/

SELECT name,
IFNULL(IndepYear, 'N/A') AS Independency
 FROM country;

/*

III. Muestre un listado con los países “recién independizado” y “antiguamente
independizados”. Es recién independizado si su fecha de independizado es
posterior a 1899.
*/

SELECT name AS Nombre, IF(IndepYear > 1899, 'Recién independizado', IF(IndepYear < 1899, 'Antiguamente independizado', 'N/A')) AS INDEPENDENCIA
 FROM country
 WHERE IndepYear <> 'NULL';

/*
IV. Cual es el promedio de nivel d vida de los países africanos.

*/

SELECT * FROM country;
SELECT AVG(LifeExpectancy) AS Average FROM country WHERE Continent = 'Africa';

/*

V. Cuál es el país con menor nivel de vida.

*/
SELECT name AS País, LifeExpectancy AS Expectativa_de_vida FROM country WHERE LifeExpectancy <> 'NULL' ORDER BY LifeExpectancy LIMIT 1;
-- SELECT name AS País,MIN(LifeExpectancy) AS LifeExpectancy FROM country;
/*
VI. Cuál es el país con mayor nivel de vida.
*/

SELECT name AS País, LifeExpectancy AS Expectativa_de_vida FROM country WHERE LifeExpectancy <> 'NULL' ORDER BY LifeExpectancy DESC LIMIT 1;

/*

VII. Muestre un listado de los países de América y cuanta es la capacidad de repartir su
riqueza entre su densidad de población. GNP = PIB. El listado debe estar ordenado
descendentemente por capacidad de repartir riqueza, luego por nombre
ascendentemente. La capacidad de repartir riqueza debe mostrarse en separación
de miles y con dos decimales.
*/
/*ESTA RESPUESTA ESTA BIEN, PERO EL PLANTEAMIENTO DE LA PREGUNTA DEBIA SER PIB / DENSIDAD POBLACIONAL
SELECT name AS País, FORMAT(GNP,2) AS PIB 
FROM country 
WHERE Continent LIKE '%America' 
ORDER BY GNP DESC, name;
*/
SELECT * FROM country;
/* esta si esta bien planteada pq la capacidad de repartir riqueza es gnp / dp */

-- SELECT name AS País, CAST(FORMAT(((GNP)/(population/surfacearea)),2)AS ) AS CAPACIDAD_RIQUEZA /*NOTA, FORMAT DEVUELVE UNA CADENA, SE DEBE CONVERTIR SI SE QUIERE ORD*/
-- FROM country
-- WHERE Continent LIKE '%America' 
-- ORDER BY CAPACIDAD_RIQUEZA DESC, name;


SELECT name AS País, ROUND(((GNP)/(population/surfacearea)),2) AS CAPACIDAD_RIQUEZA
FROM country
WHERE Continent LIKE '%America' 
ORDER BY CAPACIDAD_RIQUEZA DESC, name;

/*
VIII. Muestre los segundos nombres de los países de Europa. El listado debe estar
ordenado alfabéticamente por este segundo nombre
*/

SELECT LocalName AS Nombre FROM country  WHERE `Continent`="Europe" ORDER BY `LocalName`;/*XD NO SE REFERIA A ESTO, SINO AL SEGUNDO NOMBRE, ES DECIR, DESPUES DEL ESPACIO*/
-- LOCATE("caracter",cadena,[posicionInicial])
-- SUBSTR(nombrecadena,quesesaca)
/*

IX. Muestre un listado de los países America y la cantidad de veces que aparece la
letra “A” en ellos. El listado debe estar ordenado por la cantidad de veces que
aparece la letra A en el nombre del país.
*/

SELECT name,
LENGTH(name) - LENGTH(REPLACE(UPPER(name),'A','')) AS Num_A
FROM country 
WHERE Continent LIKE '%America' 
ORDER BY Num_A DESC;

/*
X. Muestre un listado de todos los países con un solo nombre que terminan en “bia”.
Ordene este listado alfabéticamente por el nombre del pais. */

SELECT name 
FROM country 
WHERE name LIKE "%bia"
ORDER BY name;
