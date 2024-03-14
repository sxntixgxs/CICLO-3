-- Procedimientos Almacenados / funciones
/* Recetas predefinidas que se guardan en el servidor de la base de datos
    Contiene una serie d ecomandos e instrucciones SQL que se guardan bajo un nombre
    En vez de escribir y ejecutar todos esos comandos SQL cada vez, simplemente se ejecuta o llama a este procedimiento por su nombre.
    EFICIENCIA, SEGURIDAD, OPTIMIZACION

    Ventajas:
        Modularidad: Modulariza el proceso de la base de datos, facilita organización y permite organizar y reautilizar partes del codigo sin afectarlo por completo

        Mayor rendimiento
        Seguridad*/


--    Estructura Basica:
CREATE PROCEDURE nombre_procedimiento ([parametros])
BEGIN 
    -- Declaraciones SQL y lógica del procedimiento
END;
-- Cuáles son los parámetros de entrada y salida
-- IN se pasa al procedimiento y no puede ser modificado dentro del procedimiento
-- OUT el procedimiento puede cambiar el valor del parámetro y el cambio se refleja fuera del procedimiento
-- INOUT el valor puede ser pasado al procedimiento y tambien modificado dentro del mismo

-- EJ Parametros de entrada

CREATE PROCEDURE CalcularTotal(IN precio DECIMAL(10,2), IN cantidad INT, OUT total DECIMAL(10,2))
BEGIN
    SET total = precio * cantidad;
END;

SET @total = 0;
CALL CalcularTotal(10,5,@total);
SELECT @total;

-- SCRIPT sobre el que se va a trabajar

CREATE DATABASE base_ejemplo;
USE base_ejemplo;

CREATE TABLE productos(
    id INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(20) NOT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'disponible',
    precio FLOAT NOT NULL DEFAULT 0.0,
    PRIMARY KEY(id)    
);

INSERT INTO productos (nombre, estado, precio) VALUES
('Producto1', 'disponible', 10.99),
('Producto2', 'disponible', 20.49),
('Producto3', 'agotado', 5.99),
('Producto4', 'disponible', 15.29),
('Producto5', 'disponible', 12.99),
('Producto6', 'agotado', 8.99),
('Producto7', 'disponible', 18.79),
('Producto8', 'agotado', 6.49),
('Producto9', 'disponible', 22.99),
('Producto10', 'disponible', 14.99),
('Producto11', 'disponible', 11.99),
('Producto12', 'agotado', 9.99),
('Producto13', 'disponible', 17.99),
('Producto14', 'disponible', 19.99),
('Producto15', 'disponible', 16.99),
('Producto16', 'agotado', 7.99),
('Producto17', 'disponible', 21.99),
('Producto18', 'disponible', 24.99),
('Producto19', 'disponible', 13.99),
('Producto20', 'agotado', 8.49);

-- Proceimiento con parámetros IN
-- Obtener productos basados en su estado (por ejemplo, 'disponible' o 'agotado')

-- 1. DEFINIR EL PROCEDIMIENTO
DELIMITER $$
CREATE PROCEDURE obtenerProductosPorEstado(IN nombre_estado VARCHAR(255))
BEGIN 
    SELECT * FROM productos WHERE estado = nombre_estado;
END$$

CALL obtenerProductosPorEstado('DisPoNible');

-- Procedimiento con parametros OUT
-- Contar el número de productos según su estado y devolver este número.

-- 1. Definir el procedimiento
DELIMITER $$
CREATE PROCEDURE contarProductosPorEstado(IN nombre_estado VARCHAR(255), OUT numero INT)
BEGIN 
    SELECT COUNT(id) INTO numero FROM productos WHERE estado = nombre_estado; --into le asigna el valor al parametro numero 
END $$
DELIMITER ;

-- 2. Ejecutar el procedimiento
SET @cantidad_disponibles = 0;
CALL contarProductosPorEstado('disponible',@cantidad_disponibles);
SELECT @cantidad_disponibles AS ProductosDisponibles;

-- Procedimientos con Parámetros INOUT
-- Actualizar el total de beneficios cuando se vende un producto.

-- 1. Definir el procedimiento
DELIMITER $$ 
CREATE PROCEDURE venderProducto(INOUT beneficio INT(255), IN id_producto INT)
BEGIN 
    DECLARE precio_producto FLOAT;
    SELECT precio INTO precio_producto FROM productos WHERE id = id_producto;
    SET beneficio = beneficio + precio_producto;
END$$
DELIMITER ;

-- 2- Ejecutar el procedimiento
SET @beneficio_acumulado = 0;
CALL venderProducto(@beneficio_acumulado,1); --Venta del producto 1
CALL venderProducto(@beneficio_acumulado,2);
SELECT @beneficio_acumulado AS BeneficioTotal;

-- Eliminación de un procedimiento
DROP PROCEDURE nombre;

-- Ejemplo
-- Crear un procedimiento almacenado que, dado el nombre de un país, liste todas sus ciudades
USE world;
CREATE PROCEDURE ciudades_del_pais(IN nombrePais VARCHAR(100))
BEGIN 
    SELECT CT.name AS NombreCiudades
    FROM city AS CT
    INNER JOIN country AS C ON CT.countrycode = C.code
    WHERE C.name = nombrePais;
END;
DROP PROCEDURE ciudades_del_pais;

CALL ciudades_del_pais('Argentina');
CALL ciudades_del_pais('Spain');

-- Ejemplo 2
-- Crear un procedimiento almacenado para contar el numero de ciudades en un pais especifico
CREATE PROCEDURE contar_ciudades(IN nombre_pais VARCHAR(100), OUT pr INT)
BEGIN 
    SELECT COUNT(CT.id) INTO pr
    FROM city AS CT
    INNER JOIN country AS C ON CT.countrycode = C.code
    WHERE C.name = nombre_pais;
END;
DROP PROCEDURE contar_ciudades;
SET @city_num = 0;
CALL contar_ciudades('Spain',@city_num);
SELECT @city_num AS NumeroCiudades;

-- Ejemplo 3
-- Crear un procedimiento almacenado que calcule la poblacion total de ciertos paises que hablen en español como idioma oficial
-- Cada uno de estos paises se pasan por parametro
-- Esperado:
    -- poblacionTotal('Colombia')
    -- poblacionTotal('Francia')
    -- poblacionTotal('Peru')
    -- Total = 70.000.000
SELECT * FROM country WHERE code = "COL";
SELECT * FROM countrylanguage WHERE countrycode = "COL";
DELIMITER $$
CREATE PROCEDURE poblacion_total(IN nombre_pais VARCHAR(255), INOUT acumulado INT)
BEGIN 
    DECLARE currently_population INT;
    SELECT C.population INTO currently_population
    FROM country AS C
    INNER JOIN countrylanguage AS CL ON C.code = CL.countrycode
    WHERE CL.language = "Spanish" AND CL.IsOfficial = "T" AND C.name = nombre_pais;
    SET acumulado = IF(acumulado + currently_population IS NULL,acumulado + 0,acumulado + currently_population);
END$$
DELIMITER ;
DROP PROCEDURE poblacion_total;
SET @contador_poblacion = 0;
CALL poblacion_total('Colombia',@contador_poblacion);
CALL poblacion_total('Francia',@contador_poblacion);
CALL poblacion_total('Peru',@contador_poblacion);
SELECT FORMAT(@contador_poblacion,2) AS TotalPoblacion;

