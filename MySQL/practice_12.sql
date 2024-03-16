USE Hospital;
SELECT * FROM Dept;
SELECT * FROM Doctor;
SELECT * FROM Emp;
SELECT * FROM Enfermo;
SELECT * FROM Hospital;
SELECT * FROM Plantilla;
SELECT * FROM Sala;

-- Para cada ejercicio se debe construir el procedimiento almacenado que lo resuelva.

-- 1. Construya el procedimiento almacenado que saque todos los empleados que se dieron de
-- alta entre una determinada fecha inicial y fecha final y que pertenecen a un determinado
-- departamento.
DELIMITER //
CREATE PROCEDURE consulta_empleados_por_fecha_departamento(IN fecha_in DATE, IN fecha_out DATE, IN depto VARCHAR(100))
    BEGIN

        SELECT E.*
        FROM Emp AS E
        INNER JOIN Dept AS D ON E.Dept_No = D.Dept_No
        WHERE (fecha_in <= Fecha_Alt <= fecha_out) AND D.Dnombre = depto;
    END//
DELIMITER ; 
DROP PROCEDURE consulta_empleados_por_fecha_departamento;
CALL consulta_empleados_por_fecha_departamento('1981-01-01','1987-02-02','VENTAS');
-- 2. Construya el procedimiento que inserte un empleado.

DELIMITER //
CREATE PROCEDURE insertar_empleado(IN id INT, IN apellido VARCHAR(100),IN oficio VARCHAR(100), IN id_dir INT, IN fecha_alta DATE, IN salary INT, IN comision INT, IN id_dep INT)
    BEGIN
            DECLARE EXIT HANDLER FOR SQLEXCEPTION
            BEGIN
                SELECT 'Hay algún error con los datos, revise que los ids correspondan' AS Error;   
                END;
            DECLARE CONTINUE HANDLER FOR 1062 
            BEGIN 
                SELECT 'Ya hay un empleado registrado con ese ID';
            END;

        INSERT INTO Emp( Emp_No, Apellido, Oficio, Dir, Fecha_Alt, Salario, Comision, Dept_No)
        VALUES(
            id,UPPER(apellido),UPPER(oficio),id_dir,fecha_alta,salary,comision,id_dep
        );

    END//
DELIMITER ;
DROP PROCEDURE insertar_empleado;
CALL insertar_empleado(6666,"gato",'michigan',7839,'2025-06-01',65000,0,30);
SELECT * FROM Emp;

--  3. Construya el procedimiento que recupere el nombre, número y número de personas a
-- partir del número de departamento.

DELIMITER //
CREATE PROCEDURE consultar_num_empleados_departamento(IN id_dep INT)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE empleados INT DEFAULT 0;
    DECLARE current_emp INT;
    DECLARE cur1 CURSOR FOR SELECT Dept_No FROM Emp;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = True; -- exception for FETCH

    OPEN cur1;
    my_loop: LOOP
        FETCH cur1 INTO current_emp;
        IF done THEN
            LEAVE my_loop;
        END IF;
        IF current_emp = id_dep THEN
            SET empleados = empleados + 1;
        END IF;
    END LOOP;
    CLOSE cur1;
    SELECT empleados AS NumEmpleados, id_dep AS NumDepto;
END//
DELIMITER;
DROP PROCEDURE consultar_num_empleados_departamento;
CALL consultar_num_empleados_departamento(20);

-- Diseñe y construya un procedimiento igual que el anterior, pero que recupere también las
-- personas que trabajan en dicho departamento, pasándole como parámetro el nombres
DROP PROCEDURE consultar_empleados_por_nombre_departamento;
DELIMITER //
CREATE PROCEDURE consultar_empleados_por_nombre_departamento(IN nom_dep VARCHAR(100))
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE empleados INT DEFAULT 0;
    DECLARE current_emp VARCHAR;
    DECLARE cur1 CURSOR FOR SELECT DNombre FROM Emp;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = True; -- exception for FETCH

    OPEN cur1;
    my_loop: LOOP
        FETCH cur1 INTO current_emp;
        IF done THEN
            LEAVE my_loop;
        END IF;
        IF current_emp = nom_dep THEN
            SET empleados = empleados + 1;
        END IF;
    END LOOP;
    CLOSE cur1;
    SELECT empleados AS NumEmpleados, id_dep AS NumDepto;
    SELECT E.Apellido, E.Salario, D.DNombre,
    FROM Emp AS E
    INNER JOIN Dept AS D ON E.Dept_No = D.Dept_No
    WHERE D.DNombre = nom_dep;
END//
DELIMITER;    
CALL consultar_empleados_por_nombre_departamento("CONTABILIDAD");
SELECT E.Apellido, E.Salario ,D.DNombre
FROM Emp AS E
INNER JOIN Dept AS D ON E.Dept_No = D.Dept_No
WHERE D.DNombre = "CONTABILIDAD";

CREATE PROCEDURE consultar_por_apellido(IN apell VARCHAR(100))
    BEGIN
        SELECT E.Oficio, E.Salario, E.Comision
        FROM Emp AS E
        WHERE Apellido = apell;
    END;
CALL consultar_por_apellido("GATO")
;

-- 6
DELIMITER //

CREATE PROCEDURE consultar_por_apellido2(IN apell VARCHAR(100))
BEGIN
    SELECT E.Oficio, E.Salario, E.Comision
    FROM Emp AS E
    WHERE (apell IS NULL OR E.Apellido = apell);
END//

DELIMITER ;


DROP PROCEDURE consultar_por_apellido2;
CALL consultar_por_apellido2('');

-- DBA de la base de datos tienda te da la estructura de la base de datos y algunos
-- procedimientos almacenados y te pide que agregues excepciones a los procedimientos
-- almacenados registrando el error en la tabla “errores_log” (debes diseñar una estructura para
-- esta tabla y crearla ).

USE tienda_2;
SELECT * FROM Productos;
SELECT * FROM Clientes;
SELECT * FROM Ventas;
DROP TABLE errores_log;
CREATE TABLE IF NOT EXISTS errores_log(
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    fecha DATE NOT NULL,
    info TEXT NOT NULL,
    num_error INT NOT NULL
);
DROP PROCEDURE registrar_error;
DELIMITER //

CREATE PROCEDURE registrar_error(
    IN p_fecha DATE, 
    IN p_info TEXT, 
    IN p_num_error INT
)
BEGIN
    INSERT INTO tabla_de_errores (fecha, info, num_error) 
    VALUES (p_fecha, p_info, p_num_error);
END //

DELIMITER ;

--1er procedimiento
DROP PROCEDURE AñadirProducto;

DELIMITER //
CREATE PROCEDURE AñadirProducto(IN nombre VARCHAR(255), IN precio DECIMAL(10, 2),
IN stock INT)
BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN 
            CALL registrar_error(NOW(),MESSAGE_TEXT,MYSQL_ERRNO());
        END;
    
        INSERT INTO Productos(nombre, precio, stock) VALUES (nombre, precio, stock);
        END //
DELIMITER ;

