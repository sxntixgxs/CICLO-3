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
-- estudiar GROUP BY y ORDER BY
-- EJERCICIOS Consultas SQL
-- Devuelve un listado con los nombres de los fabricantes que tienen 2 o más productos.

-- se usa join

SELECT * FROM fabricante;
SELECT * FROM producto;

SELECT F.nombre
FROM fabricante AS F
WHERE F.id IN (
    SELECT P.id_fabricante
    FROM producto AS P
    GROUP BY id_fabricante
    HAVING COUNT(P.nombre) >= 2
);

/*
2. Devuelve un listado con los nombres de los fabricantes y el número de productos que
tiene cada uno con un precio superior o igual a 220 €. No es necesario mostrar el nombre
de los fabricantes que no tienen productos que cumplan la condición.
*/
SELECT * FROM fabricante;
SELECT * FROM producto;


SELECT F.nombre, COUNT(*) AS NumeroProductos
FROM fabricante AS F
INNER JOIN producto AS P ON F.id = P.id_fabricante
WHERE P.precio >= 220
GROUP BY F.nombre ORDER BY NumeroProductos DESC;


/* 3. Devuelve un listado con los nombres de los fabricantes y el número de productos que
tiene cada uno con un precio superior o igual a 220 €. El listado debe mostrar el nombre
de todos los fabricantes, es decir, si hay algún fabricante que no tiene productos con un
precio superior o igual a 220€ deberá aparecer en el listado con un valor igual a 0 en el
número de productos. */
SELECT * FROM fabricante;
SELECT * FROM producto;

SELECT F.nombre AS NombreFabricante, SUM(CASE WHEN P.precio >= 220 THEN 1 ELSE 0 END) AS NumProductos
FROM fabricante AS F
LEFT JOIN producto AS P ON F.id = P.id_fabricante
GROUP BY F.nombre
ORDER BY NumProductos DESC;

/* 4. Devuelve un listado con los nombres de los fabricantes donde la suma del precio de todos
sus productos es superior a 1000 €.*/
SELECT * FROM producto;
SELECT * FROM fabricante;
SELECT F.nombre
FROM fabricante AS F
INNER JOIN producto AS P ON F.id = P.id_fabricante
GROUP BY F.nombre
HAVING SUM(P.precio) > 1000;

/* 5. Devuelve un listado con el nombre del producto más caro que tiene cada fabricante. El
resultado debe tener tres columnas: nombre del producto, precio y nombre del fabricante.
El resultado tiene que estar ordenado alfabéticamente de menor a mayor por el nombre
del fabricante. */
SELECT * FROM producto;
SELECT * FROM fabricante;

SELECT MasCaros.Fabricante, MasCaros.MasCaro, P.nombre
FROM (SELECT F.nombre AS Fabricante, MAX(P.precio) AS MasCaro
        FROM fabricante AS F
        INNER JOIN producto AS P ON F.id = P.id_fabricante
        GROUP BY F.nombre) AS MasCaros, 
    producto AS P
WHERE P.precio = MasCaros.MasCaro;

/* 6. Devuelve el producto más caro que existe en la tabla producto sin hacer uso de MAX, ORDER
BY ni LIMIT. */

SELECT P.nombre, P.precio
FROM producto AS P
WHERE NOT EXISTS (
    SELECT 1 -- el SELECT 1 se usa con el fin de no consumir recursos devolviendo ningun campo de la consulta, su único proposito es evaluar el where ESTO ES EFICIENTE Y SE USA
    FROM producto AS P2
    WHERE P2.precio > P.precio
);

/* 7. Devuelve el producto más barato que existe en la tabla producto sin hacer uso
de MIN, ORDER BY ni LIMIT. */

SELECT P.nombre, P.precio
FROM producto AS P
WHERE NOT EXISTS (
    SELECT 1
    FROM producto AS P2
    WHERE P2.precio < P.precio
);

/* 8. Devuelve los nombres de los fabricantes que tienen productos asociados.
(Utilizando ALL o ANY). */

-- https://www.w3schools.com/sql/sql_any_all.asp
-- ALL / ANY se usan para hacer una comparacion en este caso, el id del fabricante es igual a CUALQUIER valor de la subconsulta, en los casos donde sea cierto es TRUE;

SELECT F.nombre
FROM fabricante AS F
WHERE F.id = ANY (
    SELECT id_fabricante
    FROM producto
);

/*
    9.Devuelve los nombres de los fabricantes que no tienen productos asociados.
    (Utilizando ALL o ANY).*/

SELECT F.nombre
FROM fabricante AS F
WHERE F.id <> ALL (
    SELECT id_fabricante
    FROM producto
);

/*
10. Devuelve los nombres de los fabricantes que tienen productos asociados.
(Utilizando IN o NOT IN).*/

SELECT F.nombre
FROM fabricante AS F
WHERE F.id IN (
    SELECT id_fabricante
    FROM producto
);

/*
11. Devuelve los nombres de los fabricantes que no tienen productos asociados.
(Utilizando IN o NOT IN).*/

SELECT F.nombre
FROM fabricante AS F
WHERE F.id NOT IN (
    SELECT id_fabricante
    FROM producto
);

/*
12. Devuelve los nombres de los fabricantes que tienen productos asociados.
(Utilizando EXISTS o NOT EXISTS). */
-- https://www.w3schools.com/mysql/mysql_exists.asp
USE tienda;
SELECT F.nombre
FROM fabricante AS F
WHERE EXISTS (
    SELECT 1
    FROM producto AS P
    WHERE F.id = P.id_fabricante
);

SELECT * FROM fabricante;
/*
13. Devuelve los nombres de los fabricantes que no tienen productos asociados.
(Utilizando EXISTS o NOT EXISTS).*/

SELECT F.nombre
FROM fabricante AS F
WHERE NOT EXISTS (
    SELECT 1
    FROM producto AS P
    WHERE F.id = P.id_fabricante
);

-- ========================================
-- PARTE II
DROP DATABASE IF EXISTS ventas;
CREATE DATABASE ventas CHARACTER SET utf8mb4;
USE ventas;
CREATE TABLE cliente (
id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
nombre VARCHAR(100) NOT NULL,
apellido1 VARCHAR(100) NOT NULL,
apellido2 VARCHAR(100),
ciudad VARCHAR(100),
categoría INT UNSIGNED
);
CREATE TABLE comercial (
id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
nombre VARCHAR(100) NOT NULL,
apellido1 VARCHAR(100) NOT NULL,
apellido2 VARCHAR(100),
comisión FLOAT
);
CREATE TABLE pedido (
id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
total DOUBLE NOT NULL,
fecha DATE,
id_cliente INT UNSIGNED NOT NULL,
id_comercial INT UNSIGNED NOT NULL,
FOREIGN KEY (id_cliente) REFERENCES cliente(id),
FOREIGN KEY (id_comercial) REFERENCES comercial(id)
);
INSERT INTO cliente VALUES(1, 'Aarón', 'Rivero', 'Gómez', 'Almería', 100);
INSERT INTO cliente VALUES(2, 'Adela', 'Salas', 'Díaz', 'Granada', 200);
INSERT INTO cliente VALUES(3, 'Adolfo', 'Rubio', 'Flores', 'Sevilla', NULL);
INSERT INTO cliente VALUES(4, 'Adrián', 'Suárez', NULL, 'Jaén', 300);
INSERT INTO cliente VALUES(5, 'Marcos', 'Loyola', 'Méndez', 'Almería', 200);
INSERT INTO cliente VALUES(6, 'María', 'Santana', 'Moreno', 'Cádiz', 100);
INSERT INTO cliente VALUES(7, 'Pilar', 'Ruiz', NULL, 'Sevilla', 300);
INSERT INTO cliente VALUES(8, 'Pepe', 'Ruiz', 'Santana', 'Huelva', 200);

INSERT INTO cliente VALUES(9, 'Guillermo', 'López', 'Gómez', 'Granada', 225);
INSERT INTO cliente VALUES(10, 'Daniel', 'Santana', 'Loyola', 'Sevilla', 125);
INSERT INTO comercial VALUES(1, 'Daniel', 'Sáez', 'Vega', 0.15);
INSERT INTO comercial VALUES(2, 'Juan', 'Gómez', 'López', 0.13);
INSERT INTO comercial VALUES(3, 'Diego','Flores', 'Salas', 0.11);
INSERT INTO comercial VALUES(4, 'Marta','Herrera', 'Gil', 0.14);
INSERT INTO comercial VALUES(5, 'Antonio','Carretero', 'Ortega', 0.12);
INSERT INTO comercial VALUES(6, 'Manuel','Domínguez', 'Hernández', 0.13);
INSERT INTO comercial VALUES(7, 'Antonio','Vega', 'Hernández', 0.11);
INSERT INTO comercial VALUES(8, 'Alfredo','Ruiz', 'Flores', 0.05);
INSERT INTO pedido VALUES(1, 150.5, '2017-10-05', 5, 2);
INSERT INTO pedido VALUES(2, 270.65, '2016-09-10', 1, 5);
INSERT INTO pedido VALUES(3, 65.26, '2017-10-05', 2, 1);
INSERT INTO pedido VALUES(4, 110.5, '2016-08-17', 8, 3);
INSERT INTO pedido VALUES(5, 948.5, '2017-09-10', 5, 2);
INSERT INTO pedido VALUES(6, 2400.6, '2016-07-27', 7, 1);
INSERT INTO pedido VALUES(7, 5760, '2015-09-10', 2, 1);
INSERT INTO pedido VALUES(8, 1983.43, '2017-10-10', 4, 6);
INSERT INTO pedido VALUES(9, 2480.4, '2016-10-10', 8, 3);
INSERT INTO pedido VALUES(10, 250.45, '2015-06-27', 8, 2);
INSERT INTO pedido VALUES(11, 75.29, '2016-08-17', 3, 7);
INSERT INTO pedido VALUES(12, 3045.6, '2017-04-25', 2, 1);
INSERT INTO pedido VALUES(13, 545.75, '2019-01-25', 6, 1);
INSERT INTO pedido VALUES(14, 145.82, '2017-02-02', 6, 1);
INSERT INTO pedido VALUES(15, 370.85, '2019-03-11', 1, 5);
INSERT INTO pedido VALUES(16, 2389.23, '2019-03-11', 1, 5);

-- Consultas
/*1.Devuelve un listado con el identificador, nombre y los apellidos de todos los clientes que
han realizado algún pedido. El listado debe estar ordenado alfabéticamente y se deben
eliminar los elementos repetidos.*/

SELECT * FROM cliente;
SELECT * FROM comercial;
SELECT * FROM pedido;

SELECT C.id, C.nombre, C.apellido1, C.apellido2
FROM pedido AS P
INNER JOIN cliente AS C ON P.id_cliente = C.id
GROUP BY C.id
ORDER BY C.nombre;

/*
2. Devuelve un listado que muestre todos los pedidos que ha realizado cada cliente. El
resultado debe mostrar todos los datos de los pedidos y del cliente. El listado debe
mostrar los datos de los clientes ordenados alfabéticamente.*/

SELECT C.nombre AS NombreCliente, C.apellido1 AS ApellidoCL, P.id AS ID_Pedido, P.total, P.fecha
FROM pedido AS P
INNER JOIN cliente AS C ON P.id_cliente = C.id
ORDER BY C.nombre;

/*
3. Devuelve un listado que muestre todos los pedidos en los que ha participado un
comercial. El resultado debe mostrar todos los datos de los pedidos y de los comerciales.
El listado debe mostrar los datos de los comerciales ordenados alfabéticamente.*/

SELECT C.nombre AS NombreCliente, C.apellido1 AS ApellidoCL, P.id AS ID_Pedido, P.total, P.fecha
FROM pedido AS P
INNER JOIN comercial AS C ON P.id_comercial = C.id
ORDER BY C.nombre;

/*
4. Devuelve un listado que muestre todos los clientes, con todos los pedidos que han
realizado y con los datos de los comerciales asociados a cada pedido. */

SELECT C.nombre AS CL_nombre, C.apellido1 AS CL_apellido, P.id, V.nombre AS V_nombre, V.apellido1 AS V_apellido
FROM pedido AS P
INNER JOIN comercial AS V ON P.id_comercial = V.id
INNER JOIN cliente AS C ON P.id_cliente = C.id;
/*
5. Devuelve un listado de todos los clientes que realizaron un pedido durante el año 2017,
cuya cantidad esté entre 300 € y 1000 €.
*/

SELECT * FROM pedido;
SELECT * FROM cliente;

SELECT P.id_cliente, C.nombre, C.apellido1
FROM pedido AS P
INNER JOIN cliente AS C ON P.id_cliente = C.id
WHERE 300 <= P.total <= 1000 AND P.fecha LIKE '2017%'
GROUP BY id_cliente
ORDER BY C.nombre
;


/*
6. Devuelve el nombre y los apellidos de todos los comerciales que ha participado en algún
pedido realizado por María Santana Moreno.
*/

SELECT * FROM comercial;

SELECT V.nombre AS Nombre, V.apellido1 AS Apellido_1, V.apellido2 AS Apellido_2
FROM pedido AS P
INNER JOIN comercial AS V ON P.id_comercial = V.id
WHERE P.id_cliente IN(
    SELECT id
    FROM cliente
    WHERE nombre = "María" AND apellido1 = "Santana" AND apellido2 = "Moreno"
)
GROUP BY V.nombre, V.apellido1, V.apellido2
;

/*
7. Devuelve el nombre de todos los clientes que han realizado algún pedido con el
comercial Daniel Sáez Vega.*/



SELECT CL.nombre AS Nombre, CL.apellido1 AS Apellido_1, CL.apellido2 AS Apellido_2
FROM pedido AS P
INNER JOIN cliente AS CL ON P.id_cliente = CL.id
WHERE P.id_comercial IN(
    SELECT id
    FROM comercial
    WHERE nombre = "Daniel" AND apellido1 = "Sáez" AND apellido2 = "Vega"
)
GROUP BY CL.nombre, CL.apellido1, CL.apellido2
;


/*

8. Devuelve un listado con todos los clientes junto con los datos de los pedidos que han
realizado. Este listado también debe incluir los clientes que no han realizado ningún
pedido. El listado debe estar ordenado alfabéticamente por el primer apellido, segundo
apellido y nombre de los clientes.
9. Devuelve un listado con todos los comerciales junto con los datos de los pedidos que
han realizado. Este listado también debe incluir los comerciales que no han realizado
ningún pedido. El listado debe estar ordenado alfabéticamente por el primer apellido,
segundo apellido y nombre de los comerciales.
10. Devuelve un listado que solamente muestre los clientes que no han realizado ningún
pedido.
11. Devuelve un listado que solamente muestre los comerciales que no han realizado ningún
pedido.
12. Devuelve un listado con los clientes que no han realizado ningún pedido y de los
comerciales que no han participado en ningún pedido. Ordene el listado alfabéticamente
por los apellidos y el nombre. En en listado deberá diferenciar de algún modo los clientes
y los comerciales.
13. ¿Se podrían realizar las consultas anteriores con NATURAL LEFT JOIN o NATURAL RIGHT JOIN?
Justifique su respuesta.
14. Calcula cuál es el máximo valor de los pedidos realizados durante el mismo día para cada
uno de los clientes. Es decir, el mismo cliente puede haber realizado varios pedidos de
diferentes cantidades el mismo día. Se pide que se calcule cuál es el pedido de máximo
valor para cada uno de los días en los que un cliente ha realizado un pedido. Muestra el
identificador del cliente, nombre, apellidos, la fecha y el valor de la cantidad.
15. Calcula cuál es el máximo valor de los pedidos realizados durante el mismo día para cada
uno de los clientes, teniendo en cuenta que sólo queremos mostrar aquellos pedidos que
superen la cantidad de 2000 €.
16. Calcula el máximo valor de los pedidos realizados para cada uno de los comerciales
durante la fecha 2016-08-17. Muestra el identificador del comercial, nombre, apellidos y
total.
17. Devuelve un listado con el identificador de cliente, nombre y apellidos y el número total de
pedidos que ha realizado cada uno de clientes. Tenga en cuenta que pueden existir
clientes que no han realizado ningún pedido. Estos clientes también deben aparecer en el
listado indicando que el número de pedidos realizados es 0.
18. Devuelve un listado con el identificador de cliente, nombre y apellidos y el número total de
pedidos que ha realizado cada uno de clientes durante el año 2017.
19. Devuelve un listado que muestre el identificador de cliente, nombre, primer apellido y el
valor de la máxima cantidad del pedido realizado por cada uno de los clientes. El
resultado debe mostrar aquellos clientes que no han realizado ningún pedido indicando
que la máxima cantidad de sus pedidos realizados es 0. Puede hacer uso de la
función IFNULL.

20. Devuelve cuál ha sido el pedido de máximo valor que se ha realizado cada año.
21. Devuelve el número total de pedidos que se han realizado cada año.
22. Devuelve los datos del cliente que realizó el pedido más caro en el año 2019. (Sin
utilizar INNER JOIN)
23. Devuelve la fecha y la cantidad del pedido de menor valor realizado por el cliente Pepe
Ruiz Santana.
24. Devuelve un listado con los datos de los clientes y los pedidos, de todos los clientes que
han realizado un pedido durante el año 2017 con un valor mayor o igual al valor medio de
los pedidos realizados durante ese mismo año.
25. Devuelve el pedido más caro que existe en la tabla pedido si hacer uso de MAX, ORDER
BY ni LIMIT.
26. Devuelve un listado de los clientes que no han realizado ningún pedido.
(Utilizando ANY o ALL).
27. Devuelve un listado de los comerciales que no han realizado ningún pedido.
(Utilizando ANY o ALL).
28. Devuelve un listado de los clientes que no han realizado ningún pedido.
(Utilizando IN o NOT IN).
29. Devuelve un listado de los comerciales que no han realizado ningún pedido.
(Utilizando IN o NOT IN).
30. Devuelve un listado de los clientes que no han realizado ningún pedido.
(Utilizando EXISTS o NOT EXISTS).
31. Devuelve un listado de los comerciales que no han realizado ningún pedido.
(Utilizando EXISTS o NOT EXISTS). */
