--faltó el tema de funciones, entonces arrancamos desde acá


--función calculo del total con IVA
--- crea una funcion TotalConIVA que calcula el total del articulo incluyrendo IVA


DELIMITER $$
CREATE FUNCTION ...



CREATE FUNC/TION CelciusFarenheit ...
RETURNS ...

-- Total Con descuento
-- Se requiere calcular el valor total a pagar en una tienda, para ello se genera la función CalcularTotalConDescuento a continuacion
-- Se da la siguiente estructura y la consulta que usa la funcion

USE tienda;

DELIMITER $$

CREATE FUNCTION calculardescuento(valor DECIMAL(10,2), porcentaje_desc DECIMAL(10,2))
    RETURNS DECIMAL(10,2)
    DETERMINISTIC
    BEGIN
    IF porcentaje_desc > 100 THEN
        RETURN valor; 
    ELSEIF porcentaje_desc > 0 THEN
        RETURN valor * (porcentaje_desc / 100);
    ELSE 
        RETURN 0;
    END IF;
    END$$


DELIMITER ;

DROP FUNCTION calculardescuento;

SET @porcentaje_desk = 90;
SELECT nombre, precio, calculardescuento(precio,@porcentaje_desk) as Descuento, (precio - calculardescuento(precio,@porcentaje_desk)) AS PrecioFinal
FROM producto;
-- funcion para calcular promedios
-- Se requiere calcular el promedio de ventas de un vendedor, para ello mostraremos como crear la tabla y usar la función de calculo de promedios.
CREATE TABLE ventas(
    id INT AUTO_INCREMENT,
    vendedor_id INT,
    monto_venta DECIMAL(10,2),
    PRIMARY KEY (id)
);

DELIMITER $$
CREATE FUNCTION PromedioVentas(id_vendedor INT)
    RETURNS DECIMAL(10,2)
    DETERMINISTIC
    BEGIN 
        DECLARE promedio DECIMAL(10,2);
        
        IF EXISTS (SELECT 1 FROM ventas WHERE vendedor_id = id_vendedor) THEN
            SELECT AVG(total_ventas) INTO promedio
            FROM (SELECT COUNT(id) as total_ventas FROM ventas WHERE vendedor_id = id_vendedor GROUP BY id) as subquery;
            
            RETURN promedio;
        ELSE 
            RETURN 0;
        END IF;
    END$$
DELIMITER ;




SELECT PromedioVentas(4) AS promedioVentasVendedor;

-- FUNCION CALCULAR EL DESCUENTO DEPENDIENDO DE LA CCATEGORIA DEL CLIENTE
CREATE TABLE ordenes(
    id INT AUTO_INCREMENT,
    cliente_id INT,
    precio DECIMAL(10,2),
    categoria_cliente VARCHAR(10),
    PRIMARY KEY(id)
);

DELIMITER $$

CREATE FUNCTION calcular_descto_por_categoria(id_cl INT, precio DECIMAL(10,2))
    RETURNS DECIMAL(10,2) -- returns al inicair que se declara
    DETERMINISTIC
    BEGIN 
        DECLARE dscto DECIMAL(10,2);
        DECLARE cat_cl VARCHAR(10);

        SELECT categoria_cliente INTO cat_cl
        FROM ordenes 
        WHERE id_cl = cliente_id;
    CASE cat_cl
        WHEN 'A' THEN
            SET dscto = precio-(precio*(0.1/100));
        WHEN 'B' THEN
            SET dscto = precio-(precio*(0.15/100));
        WHEN 'C' THEN
            SET dscto = precio-(precio*(0.2/100));
        ELSE 
            SET dscto = 0;
    END CASE;
    RETURN dscto; -- ojo es return dentro de la funcion
    END$$
DELIMITER ;

DROP FUNCTION calcular_descto_por_categoria;


-- Funciones deterministicas VS no deterministicas

-- Deterministicas
    -- Siempre devuelven el mismo resultado para los mismos valores de entrada;
    -- Predecibles y consistentes lo que las hace ideales para operaciones que requieren salida fija y precisa;
-- No deterministica
    -- Una funcion que por ejemplo no tiene parametro de entrada pero cada vez que la ejecute el valor va a ser diferente porque está relacionado con la DATETIME, por ejemplo.

-- Manejo de erorres y excepciones en funciones
-- Sentencia SIGNAL en MySQL se usa para generar errores personalizadaos dentro de procedimientos almacenados, funciones etc

-- Crear un procedimiento almacenado que lance un SIGNAL cuando se intente agregar un registro que ya edxiste en la tabla producytos y cuya estructura es...
DELIMITER //
CREATE PROCEDURE InsertarProducto(IN p_nombre VARCHAR(255), IN p_precio DECIMAL(10,2))
BEGIN
    -- verificar si el producto existe
    IF EXISTS (SELECT * FROM productos WHERE nombre = p_nombre) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "El producto ya existe";
    ELSE 
        -- insertar el nuevo producto si no existe
        INSERT INTO productos(nombre,precio)VALUES(p_nombre,p_precio);
    END IF;
END//

DELIMITER ;

-- mismo ejercicio pero con funcion

CREATE FUNCTION InsertarProducto (IN p_nombre VARCHAR(255), IN p_precio DECIMAL(10,2))
RETURNS BOOLEAN
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE producto_existente BOOLEAN;
    -- verificar si el producto ya existe
    SELECT EXISTS(SELECT 1 FROM productos WHERE nombre=p_nombre)INTO producto_existente;
    -- SI el producto ya existe, generar un error
    IF producto_existente THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "El producto ya existe";
    ELSE 
        -- insertar el nuevo producto si no existe
        INSERT INTO productos(nombre,precoi)VALUES(p_nombre,p_precio);
    END IF;

    -- devuelve verdadero si la insercion fue exitos
    RETURN NOT producto_existente;
END //

-- manejo de erorres otro ej
-- crear tu propia excepción
CREATE SCHEMA prueba_clase_14;
USE prueba_clase_14;

DELIMITER $$
CREATE FUNCTION calcularDescuento(dividendo DOUBLE, divisor DOUBLE)
RETURNS DOUBLE
DETERMINISTIC
BEGIN 
    IF divisor = 0 THEN
        SIGNAL SQLSTATE '40500' SET MESSAGE_TEXT = "Error, división por 0 no permitida"; --el numero se puede desde que sea mayor a 10K --
    END IF;
    RETURN dividiendo / divisor;
END$$
DELIMITER ;
DROP FUNCTION calcularDescuento;

SELECT calcularDescuento(6,0) AS Resultado;



-- =========================================================
-- SEGURIDAD Y PERMISOS
-- protege los datos contra accesos no autorizados, sino que también ayuda a mantener la integridad y el rendimiento óptimo de la base de datos.

-- 2 usuarios predeterminados 
    -- root: superusuario tiene acceso total a todas las bases de datos y tablas
    -- anonimo: por defecto, MySQL incluye un usuario anónimo, accesible sin nombre de usuario ni contraseña. Generalmente, tiene permisos limitados y se recomienda eliminarlo por razones de seguridad.

SELECT user, host FROM mysql.user;

-- como dar permiso a un usuario para realizar operaciones basicas

CREATE USER 'userEjemplo'@localHost IDENTIFIED BY 'contraseñaSegura';
DROP USER 'userEjemplo'@localHost;
GRANT SELECT,INSERT ON prueba_clase_14.* to 'userEjemplo'@localHost;

SHOW GRANTS FOR 'userEjemplo'@localHost;

REVOKE SELECT ON prueba_clase_14.* FROM 'userEjemplo'@localHost;

GRANT USAGE ON prueba_clase_14.* TO 'userEjemplo'@localHost;
ALTER USER 'userEjemplo'@localHost WITH MAX_QUERIES_PER_HOUR 100;

-- Eliminación de Usuarios Anónimos
    -- Representan una significativa vulnerabilidad en la DB

SELECT USER, HOST
FROM mysql.user
WHERE user = '';

DROP USER ''@localHost;

USE mysql;
SHOW TABLES;
-- Otras practicas para aumentar la seguridad
    -- Contraseñas fuertes y únicas

        ALTER USER 'userEjemplo'@localHost IDENTIFIED BY 'c0ntr4señaS3gur4';

    -- Restricción de accesos Limitar los privilegios a solo lo necesario
        REVOKE ALL PRIVILEGES ON *.* FROM 'userEjemplo'@localHost;
        GRANT SELECT ON prueba.* TO 'userEjemplo'@localHost;
    -- Actualizaciones Regulares
    -- Auditorías de Seguridad


-- Asignación de Privilegios Administrativos
    -- por seguridad hay que cambiar el superusuario de nombre, no dejarlo 'root'
    CREATE USER 'admin'@'%' IDENTIFIED BY 'campus2024';
    GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' WITH GRANT OPTION;
    

USE prueba_clase_14;

CREATE TABLE users(
    id INT PRIMARY KEY,
    username VARCHAR(100),
    email VARCHAR(100)
);

CREATE USER worker@localHost IDENTIFIED BY 'bukaros123';

GRANT SELECT (username, email) ON prueba_clase_14.users TO worker@localHost;


-- Recargar privilegios
FLUSH PRIVILEGES;

-- Limitar accesos de red

-- Especificaciones de Lugares de Origen de la Conexión

    GRANT UPDATE INSERT, SELECT ON mundo.pais TO campus@%.campuslands.com;
    CREATE USER 'user2'@'%.campuslands.com' IDENTIFIED BY 'Campus2023;';
    GRANT UPDATE, INSERT, SELECT ON campus.* TO 'user2'@'%.campuslands.com';
    FLUSH PRIVILEGES;

-- Comodines (?) comando GRANT
-- . => Todas las bases de datos y todas las tablas
-- base.* => todas las tablas de una base de datos
-- base.tabla => tabla especifica de una base de datos esp
-- * => Todas las tablas de la base de datos actualmente seleccionada

-- PREPARE Y EXECUTE
    -- Sirven para prevenir ataques de inyección SQL ...

    USE world;
    SELECT * FROM city WHERE countrycode = 'COL';

    -- en este caso está siendo vulnerable a inyeccion sql entonces así se soluciona:

    PREPARE stmt FROM 'SELECT * FROM city WHERE countrycode = ?'; 
    SET @pais = 'COL';
    EXECUTE stmt USING @pais;
    -- Prepare: crea una versión preparada de la sentencia SQL donde los valores específicos se reemplazan  -luego de usarla es buena practica deshacerla;
    DEALLOCATE PREPARE stmt;
    -- Execute: