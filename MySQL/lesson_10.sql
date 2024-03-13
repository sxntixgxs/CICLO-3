/* Consultas Avanzadas

Funciones de agregación
    Opera sobre todas las filas de un grupo y da un resultado
    MAX
    MIN
    AVG
    COUNT(*) Calcula el numero de filas que tiene el resultado de la consulta - FILAS DE UNA TABLA
    COUNT(columna) Calcula el numero de valores EXCEPTO los valores nulos de esa columna - COLUMNA EXCEPTO LOS NULL
    COUNT(DISTINCT columna) - Cuantos valores distintos hay en una columna
Agrupacion de datos GROUP BY
    Agrupar valores identicos de una tabla
    Resultado: única fila resumen por cada grupo de elementos únicos formados
    Se le pueden aplicar una serie de funciones de agregación que nos permiten efectuar operaciones sobre un conjunto de resultados, pero devuelve un único valor agregado para todos ellos
    MAX, COUNT, SUM, AVG, VAR, ...
    Es decir un group by de un campo tipo Repeticiones agrupa todas las filas que tengan el mismo numero de repeticiones, y en la tabla de respuesta me entrega la operacion que yo haya asignado al total de valores agrupados
    */
-- EJ agrupación de datos

DROP SCHEMA IF EXISTS prueba_clase_10;
CREATE SCHEMA IF NOT EXISTS prueba_clase_10 DEFAULT CHARACTER SET utf8;
SHOW WARNINGS;
USE prueba_clase_10;


DROP TABLE IF EXISTS carros;
CREATE TABLE IF NOT EXISTS carros(
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Marca VARCHAR(45) NOT NULL,
    Modelo VARCHAR(45) NOT NULL,
    Kilometros INT(11) NOT NULL
)
AUTO_INCREMENT = 10;

INSERT INTO carros(Marca,Modelo,Kilometros) VALUES (
    'Renault','Clio',10
),(
    'Renault','Megane',23000
),(
    'Seat','Ibiza',9000
),(
    'Seat','Leon',20
),(
    'Opel','Corsa',999
),(
    'Renault','Clio',34000
),(
    'Seat','Ibiza',2000
),(
    'Seat','Cordoba',99999
),(
    'Renault','Clio',88888
);
SELECT * FROM carros;

-- Si hicieramos una agrupacion por Marca, tendriamos como resultado
-- todas las Marcas de carros distintos que hay en esta tabla.

SELECT Marca 
FROM carros
GROUP BY Marca;

-- Vemos que en la tabla hay 3 marcas de carro diferentes y al agruparla nos dice cuales son
-- También se puede hacer agrupación por más campos
-- Por ej, podemos ver cuantos carros diferentes hay teniendo en cuenta marca y modelo
SELECT Marca, Modelo
FROM carros
GROUP BY Marca, Modelo;

-- Se puede ordenar la operación para que se ordene de mayor a menor
SELECT Marca, COUNT(*) AS Contador
FROM carros
GROUP BY Marca ORDER BY Contador DESC;

-- Que nos sume cual es el kilometraje de TODOS los carros de esa Marca
-- Se le pasa la funcion SUM el nombre de la columna sobre la que se ha de aplicar la operacion
-- es decir a la columna Kilometros
SELECT Marca, SUM(Kilometros)
FROM carros
GROUP BY Marca;
-- También se pueden sacar máximos y minimos para saber el coche de más o menos kilómetros de cada marca
SELECT Marca, MAX(Kilometros)
FROM carros
GROUP BY Marca;

SELECT Marca,MIN(Kilometros)
FROM carros
GROUP BY Marca;

-- HAVING
/* Es una condición de agrupamiento que nos permite crear filtros sobre
    los grupos de filas que tienen los mismos valores en las columnas por las que se desea agrupar
    **es el where de group by; como la condición del group by**
*/
SELECT fabricante.nombre AVG(producto.precio)
FROM producto 
INNER JOIN fabricante ON producto.codigo_fabricante = fabricante.codigo
WHERE fabricante.nombre != 'Seagate'
GROUP BY fabricante.codigo
HAVING AVG(producto.precio)>=150

