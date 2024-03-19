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

-- Calcula el número total de productos que hay en la tabla productos.

SELECT COUNT(*) AS NumeroProductos
FROM producto;

-- 2. Calcula el número total de fabricantes que hay en la tabla fabricante.

SELECT COUNT(*) AS NumeroFabricantes
FROM fabricante;

-- 3. Calcula el número de valores distintos de identificador de fabricante aparecen en la
-- tabla productos.

SELECT COUNT(DISTINCT id_fabricante) AS NumFabricantes
FROM producto
;

-- 4. Calcula la media del precio de todos los productos.

SELECT FORMAT(AVG(precio),2) AS MediaPrecioProductos
FROM producto;
-- 5. Muestra el precio máximo, precio mínimo, precio medio y el número total de productos que
-- tiene el fabricante Crucial.

SELECT MAX(P.precio), MIN(P.precio), AVG(P.precio)
FROM producto AS P
INNER JOIN fabricante AS F ON P.id_fabricante = F.id
WHERE F.nombre = "Crucial"
GROUP BY P.id_fabricante
;

SELECT * FROM producto;
SELECT * FROM fabricante;

-- 6. Muestra el número total de productos que tiene cada uno de los fabricantes. El listado
-- también debe incluir los fabricantes que no tienen ningún producto. El resultado mostrará
-- dos columnas, una con el nombre del fabricante y otra con el número de productos que tiene.
-- Ordene el resultado descendentemente por el número de productos.


SELECT F.nombre, COUNT(P.id_fabricante) AS NumProductos
FROM fabricante AS F
LEFT JOIN producto AS P ON F.id = P.id_fabricante
GROUP BY F.id
ORDER BY NumProductos DESC;



-- 7. Muestra el precio máximo, precio mínimo y precio medio de los productos de cada uno de los
-- fabricantes. El resultado mostrará el nombre del fabricante junto con los datos que se
-- solicitan.

SELECT F.nombre, MAX(P.precio), MIN(P.precio), AVG(P.precio)
FROM producto AS P
INNER JOIN fabricante AS F ON P.id_fabricante = F.id
GROUP BY P.id_fabricante
;

-- 8. Muestra el precio máximo, precio mínimo, precio medio y el número total de productos de
-- los fabricantes que tienen un precio medio superior a 200€. No es necesario mostrar el
-- nombre del fabricante, con el identificador del fabricante es suficiente.

SELECT F.nombre, MAX(P.precio), MIN(P.precio), AVG(P.precio) AS PrecioPromedio
FROM producto AS P
INNER JOIN fabricante AS F ON P.id_fabricante = F.id
GROUP BY P.id_fabricante
HAVING PrecioPromedio > 200
;


-- 9. Muestra el nombre de cada fabricante, junto con el precio máximo, precio mínimo, precio
-- medio y el número total de productos de los fabricantes que tienen un precio medio superior
-- a 200€. Es necesario mostrar el nombre del fabricante.

SELECT F.nombre, MAX(P.precio), MIN(P.precio), AVG(P.precio) AS PrecioPromedio
FROM producto AS P
INNER JOIN fabricante AS F ON P.id_fabricante = F.id
GROUP BY P.id_fabricante
HAVING PrecioPromedio > 200
;


-- 10. Calcula el número de productos que tienen un precio mayor o igual a 180€.
SELECT * FROM producto;
SELECT COUNT(id) AS NumProductosMayor180 FROM producto WHERE precio >= 180;

-- 11. Calcula el número de productos que tiene cada fabricante con un precio mayor o igual a
-- 180€.
SELECT * FROM fabricante;
SELECT F.nombre AS NombreFabricante, COUNT(F.id) AS NumProdxFabMayor180
FROM fabricante AS F
INNER JOIN producto AS P ON F.id = P.id_fabricante
WHERE precio >= 180
GROUP BY F.id;