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

