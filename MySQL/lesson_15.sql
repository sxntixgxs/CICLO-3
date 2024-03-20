-- INSTRUCCION LIke

USE world;
SELECT name
FROM country 
WHERE name LIke "%CIA";
 -- comodin __ representa un unico caracter
 SELECT *
 FROM country
 WHERE NAME LIE "F___nce";

 SELECT *
 FROM country
 WHERE NAME LIKE "_%san%_"; -- que en la mitad del nombre tenga san 

 SELECT * FROM country
 WHERE name LIKE "%a%" AND name LIKE "%e%" AND name LIKE "%i%" AND name LIKE "%o%" AND name LIKE "%u%";
 
 -- hallar paises con nombres compuestos

SELECT * FROM country 
WHERE TRIM(name) LIkE "% %"; -- name LIke "_% %_"


-- listar los paises que no contengan usa en su nombre

SELECT * FROM country
WHERE name NOT LIKE "%usa%";


-- listar todos los paises donde el continente sea America

SELECT * FROM country 
WHERE continent LIKE "%America";
-- advices
    -- usar idx
CREATE TABLE Libros(
    id INT AUTO_INCREMENT,
    titulo VARCHAR(100),
    autor VARCHAR(100),
    anio INT,
    PRIMARY KEY(id)
);

SELECT * FROM Libros WHERE Autor = "Gabriel Garcìa Marquez";

CREATE INDEX idx_autor ON Libros(Autor);

SELECT * FROM Libros WHERE Anio > 2000 AND Autor IN ('Autor1','Autor2','Autor3');

CREATE INDEX idx_anio_autor ON Libros(Anio,Autor); -- indice compuesto para indexar dos campos en uno

    --evitar subconsultas innecesarias
SELECT nombre
FROM Usuarios
WHERE id_usuario IN (
    SELECT id_usuario
    FROM Compras
); -- no es muy eficiente, es mejor usar un join

SELECT DISTINCT U.nombre
FROM usuarios AS U
JOIN Compras AS C ON U.id_usuario = C.id_usuario;

-- Caching de consultas en MySQL
    -- no lo usamos pq es con software exerno pero en este caso no los tenemos
    -- es como almacenar o tener lista una consulta que se hace mucho

    -- consulta para obtener las ultimas noticias
    -- SELECT * FROM Noticias ORDER BY fecha_publ DESC LIMIT 10;
    -- -- softwares usados para esto:
    --     -- NoSQL Redis o Memcached
    -- -- pseudocodigo en Python con uso de cache
    -- noticias_cacheadas = obtener_de_cache("ultimas noticias");
    -- if noticias_cacheadas is None:
    --     noticias = ejecutar_consulta_sql("SELECT * FROM Noticias ORDER BY fecha_publicacion DESC LIMIT 10;")
    --     guardar_en_cache("ultimas_noticias",noticias,tiempo_expiracion_db)
    -- else:
    --     noticias = noticias_cacheadas

-- usar particiones PARTITION

CREATE SCHEMA prueba_clase;
DROP TABLE employees;
CREATE TABLE employees(
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    firstname VARCHAR(25),
    lastname VARCHAR(25),
    store_id INT NOT NULL,
    departament_id INT NOT NULL
)
PARTITION BY RANGE(id) (
    PARTITION p0 VALUES LESS THAN (5),
        PARTITION p1 VALUES LESS THAN (10),
        PARTITION p2 VALUES LESS THAN (15),
        PARTITION p3 VALUES LESS THAN MAXVALUE
);
INSERT INTO employees VALUES
    (NULL, 'Bob', 'Taylor', 3, 2), (NULL, 'Frank', 'Williams', 1, 2),
    (NULL, 'Ellen', 'Johnson', 3, 4), (NULL, 'Jim', 'Smith', 2, 4),
    (NULL, 'Mary', 'Jones', 1, 1), (NULL, 'Linda', 'Black', 2, 3),
    (NULL, 'Ed', 'Jones', 2, 1), (NULL, 'June', 'Wilson', 3, 1),
    (NULL, 'Andy', 'Smith', 1, 3), (NULL, 'Lou', 'Waters', 2, 4),
    (NULL, 'Jill', 'Stone', 1, 4), (NULL, 'Roger', 'White', 3, 2),
    (NULL, 'Howard', 'Andrews', 1, 2), (NULL, 'Fred', 'Goldberg', 3, 3),
    (NULL, 'Barbara', 'Brown', 2, 3), (NULL, 'Alice', 'Rogers', 2, 2),
    (NULL, 'Mark', 'Morgan', 3, 3), (NULL, 'Karen', 'Cole', 3, 2);

SELECT *
FROM employees
PARTITION (p1);


SELECT * 
FROM employees
PARTITION (p0,p2)
WHERE lastname LIKE "S%";

SELECT id, CONCAT(firstname, ' ', lastname) AS name
FROM employees 
PARTITION (p0)
ORDER BY lastname;



-- Transacciones: operaciones que se consideran o tratan como una sola. Si falla, se deshace.
START TRANSACTION;
INSERT INTO employees VALUES
    (NULL, 'Yulieth','Taylor',3,2);

COMMIT;

CREATE TABLE orden(
    id INT PRIMARY KEY,
    estado VARCHAR(50)
);

CREATE TABLE factura(
    id INT PRIMARY KEY,
    id_orden INT,
    cantidad INT,
    FOREIGN KEY (id_orden) REFERENCES orden(id)
);

START TRANSACTION;
INSERT INTO orden VALUES (
    100,"completado"
);
INSERT INTO factura VALUES(
    1,101,3
);
COMMIT; -- ejecuta la transaccion

SELECT * FROM orden;

ROLLBACK; -- revierte los cambios realizados durante la transaccion

-- fin de la clase, ahora ej entonces pasamos a practice_15.sql