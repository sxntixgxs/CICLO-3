-- Procedimientos Almacenados
-- ESTRUCTURA IF THEN ELSE
-- Crear un procedimiento almacenado para contar el número de ciudades en un país específico 

-- Estructura GENERAL
IF condicion THEN
ELSE
END IF;

--Ejemplo
-- Supongamos una tabla usuarios con campos id,nombre,edad. queremos clasificar a los usuarios como Mayor o Menor basado en su edad.

CREATE TABLE usuarios(
    id INT AUTO_INCREMENT,
    nombre VARCHAR(100),
    edad INT,
    categoria VARCHAR(10),
    PRIMARY KEY (id)
);

DELIMITER // 
CREATE PROCEDURE ClasificarUsuario(IN userID INT)
BEGIN 
    DECLARE userAge INT;
    SELECT edad INTO userAge FROM usuarios WHERE id = userID;
    IF user >= 18 THEN
        UPDATE usuarios SET categoria = "Mayor" WHERE ...
        ...
        -- puta madre

-- ESTRUCTURA LOOP

-- Ejecuta un bloque de código hasta encontrar un LEAVE
-- Usar LOOP cuando no se sabe previamente cuantas iteraciones necesito
-- Estructura general:
    LOOP 
        -- Acciones a repetir
        IF condicion_salida THEN
            LEAVE loop_label;
        END IF;
    END LOOP loop_label
-- EJEMPLO
-- Supongamos que queremos aumentar el salario de los empleados en un 10% hasta que alcance un máximo de 5000

CREATE PROCEDURE AumentarSalario (IN empleadoID INT)
BEGIN 
    LOOP
        UPDATE empleados 
        SET salario = salario * 1.1 
        WHERE id = empleadoID AND SALARIO <= 5000;
        IF salario > 5000 THEN
            LEAVE;
        END IF;
    END LOOP;
END //
DELIMITER ;

-- Estructura REPEAT
-- Se ejecuta hasta que una condición específica se cumple
-- Util cuando sabes que el bloque de codigo debe ejecutarse al menos una vesz y continuar hasta que se cumpla una condicion
-- Opta por REPEAT cuando la condición de terminación es más importante que la condición de inicio

-- Estructura general:
REPEAT 
    -- Acciones a repetir
UNTIL condicion
END REPEAT;

-- Aumentar el salario de los empleados en un 5% rep hasta que todos tengan un salario minimo de 3000
DELIMITER //
CREATE PROCEDURE AumentarSalarios()
BEGIN 
    REPEAT 
        UPDATE empleados SET salario = salario * 1.05 WHERE salario < 3000;
        UNTIL (SELECT COUNT(*) FROM empleados WHERE salario < 3000) = 0
    END REPEAT;
END//
DELIMITER ;

-- Estructura WHILE
-- Ideal para repetir algo mientras una condición sea cierta
-- WHILE primero pregunta y después hace
WHILE condicion DO
    -- ACCIONES A REPETIR
END WHILE;


DELIMITER //
CREATE PROCEDURE ContarEmpleadosAltosSalarios()
BEGIN
    DECLARE contador INT DEFAULT 0;
    DECLARE totalEmpleados INT DEFAULT 0;
    SELECT COUNT(*) INTO totalEmpleados FROM empleados WHERE salario > 4000;
    WHILE contador < totalEmpleados DO
        SET contador = contador +1;
    END WHILE;
    SELECT contador;
END//
DELIMITER ;

-- CASE
-- Similar a las declaraciones SWITCH
CASE expresion
    WHEN valor1 THEN
        --Acciones para valor1
    WHEN valor2 THEN 
        --Acciones para valor2
    ELSE 
        -- Acciones si no se cumple ninguno de los casos anteriores
END CASE;

-- Ejemplo

CREATE TABLE empleados(
    id
    nombre
    salario
    categoria
)
DELIMITER // 
CREATE PROCEDURE AsignarCategoriaSalario()
BEGIN 
    DECLARE done INT DEFAULT FALSE;
    DECLARE empid INT;
    DECLARE empsal DECIMAL(10,2);
    DECLARE cur1 CURSOR FOR SELECT id, salario FROM empleados; -- cursor es como una tabla simplificada de la tabla completa
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE; -- es una excepcion que es cuando el fetch llegue al final, es decir encuentre un NOT FOUND cambie el done a true

    OPEN cur1;
    read_loop: LOOP
        FETCH cur1 INTO empid, empsal; -- fetch es como for each recorre todos y hace algo por cada1
        IF done THEN
            LEAVE read_loop; -- cierra el ciclo cuando el fetch finaliza
        END IF;
        CASE 
            WHEN empsal <= 3000 THEN
                UPDATE empleados SET categoria = "Entrada" WHERE id = empid;
            WHEN empsal > 3000 AND empsal <= 7000 THEN
                UPDATE empleados SET categoria = "Media" WHERE id = empid;
            ELSE 
                UPDATE empleados SET categoria = "Alta" WHERE id = empid;
        END CASE;
    END LOOP;
    CLOSE cur1;
END //
DELIMITER ;

-- Ejemplo IF THEN ELSE

-- Ejemplo CASE

CREATE PROCEDURE AsignarDescuento(IN nivelUsuario VARCHAR(50), OUT descuento INT)
BEGIN 
    CASE nivelUsuario
        WHEN 'Principiante' THEN SET descuento = 5;
                WHEN 'Intermedio' THEN SET descuento = 10;
                        WHEN 'Experto' THEN SET descuento = 15;
        ELSE SET descuento = 0;
    END CASE;
END;

-- ejempLOOP
-- EJEMPLO REPEAT
-- EJEMPLO WHILE

-- MANEJO DE ERRORES
    -- DECLARE HANDLER se usa para definir las acciones que se deben tomar cuando pase un error o una condicion especifica durante la ejecucion de un procedimiento

    -- 2 tipos.
        -- CONTINUE el control pasa al siguiente statement despues del que causó el error
        -- EXIT el control s esale del codigo actual -BEGIN END-
    -- Como se captura un error especifico, como un error de duplicado en una insercion -codigo de errror 1062 en MySQL

    -- En este caso, si se intenta insertar un usuario con un nombre de usuario o email que ya existe, el procedimiento devolverá un mensaje de error.

BEGIN
    DECLARE EXIT HANDLER FOR 1062
    SELECT 'Error: El usuario ya existe.';
    INSERT INTO usuarios(username,email)VALUE(username,email);
END;

USE tienda;
DELIMITER $$
CREATE PROCEDURE insertarFabricante(IN idfab INT, IN nomfab VARCHAR(100))
BEGIN
    DECLARE EXIT HANDLER FOR 1062 SELECT CONCAT("Error. El fabricante ",nomfab,"ya existe") AS ERROR;
    INSERT INTO fabricante VALUES(idfab, nomfab);
END$$
DELIMITER ;
DROP PROCEDURE insertarFabricante;
CALL insertarFabricante(10,'Oppo');

-- Manejo de errores
-- Ej si ocurre cualquier error SQL durante la actualización del usuario, el procedimiento registra el error y revierte la transacción para mantener la integridad de los datos.

CREATE PROCEDURE ActualizarUsuario(IN userID INT, IN newEmail VARCHAR(100))
BEGIN 
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN 
        -- Se podría registrar el error en una tabla de logs
        INSERT INTO error_logs(error_message) VALUES ('Error al actualizar usuario');
        ROLLBACK; -- Revertir la transaccion
    END;    
    START TRANSACTION;
    UPDATE usuarios SET email = newEmail WHERE id = userID;
    COMMIT;
END;