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
CREATE PROCEDURE consulta_empleados_por_rango_fecha(IN fecha_in DATE, IN fecha_fin DATE, IN depto INT)
    BEGIN 
        SELECT E.*
        FROM Emp as E
        WHERE E.Fecha_Alt < fecha_fin AND E.Fecha_Alt > fecha_in AND E.Dept_No = depto;
    END// 
DELIMITER $$
DROP PROCEDURE consulta_empleados_por_rango_fecha;
CALL consulta_empleados_por_rango_fecha('1983-01-01','1999-01-01',20)

-- 2. Construya el procedimiento que inserte un empleado.

DELIMITER //
CREATE PROCEDURE insertar_empleado (IN num INT, IN ap VARCHAR(100),IN carg VARCHAR(100),IN director INT, IN fecha DATE, IN sueldo INT, IN com INT, depto INT)
    BEGIN
        INSERT INTO Emp(Emp_No,Apellido,Oficio,Dir,Fecha_Alt,Salario,Comision,Dept_No)
        VALUES(num,ap,carg,director,fecha,sueldo,com,depto);

    END //
DELIMITER $$


CALL insertar_empleado(666,'MICHI','OWNER',777,'2024-01-01',999999,999,99);
SELECT * FROM Emp;



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
        SELECT D.Dnombre, D.Dept_No, COUNT(*)
        FROM Emp AS E
        INNER JOIN Dept AS D ON D.Dept_No = E.Dept_No
        GROUP BY D.Dept_No;

DELIMITER //
CREATE PROCEDURE consultar_por_num_depto(IN num INT)
    BEGIN
        SELECT D.Dnombre, D.Dept_No, COUNT(*) AS NumEmpleados
        FROM Emp AS E
        INNER JOIN Dept AS D ON D.Dept_No = E.Dept_No
        GROUP BY D.Dept_No
        HAVING D.Dept_No = num;
    END //
DELIMITER $$
DROP PROCEDURE consultar_por_num_depto;
CALL consultar_por_num_depto(10);




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

        SELECT D.Dnombre, D.Dept_No, E.Apellido, E.Salario
        FROM Emp AS E
        INNER JOIN Dept AS D ON D.Dept_No = E.Dept_No
        ;

DELIMITER //
CREATE PROCEDURE consultar_emp_por_nombre_depto(IN depto VARCHAR(100))
    BEGIN
        SELECT D.Dnombre, D.Dept_No, E.Apellido, E.Salario
        FROM Emp AS E
        INNER JOIN Dept AS D ON D.Dept_No = E.Dept_No
        WHERE D.Dnombre = depto;
    END //
DELIMITER ;

CALL  consultar_emp_por_nombre_depto('CONTABILIDAD');

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



-- Construya un procedimiento para devolver salario, oficio y comisión, pasándole el apellido.

SELECT *
FROM Emp;

DELIMITER //
CREATE PROCEDURE info_por_apellido(IN apellido VARCHAR(100))
    BEGIN
        SELECT E.Salario, E.Oficio, E.Comision
        FROM Emp E
        WHERE E.Apellido = apellido;
    END //
DELIMITER $$

CALL info_por_apellido('SERRA');
-- Tal como el ejercicio anterior, pero si no le pasamos ningún valor, mostrará los datos de
-- todos los empleados.

DELIMITER //
CREATE PROCEDURE info_por_apellido(IN apellido VARCHAR(100))
    BEGIN
        IF apellido = '' THEN
            SELECT * FROM Emp;
        ELSE 
            SELECT E.Salario, E.Oficio, E.Comision
            FROM Emp E
            WHERE E.Apellido = apellido;
        END IF;
    END //
DELIMITER $$
    
DROP PROCEDURE info_por_apellido;
CALL info_por_apellido('');
CALL info_por_apellido('SERRA');


-- Construya un procedimiento para mostrar el salario, oficio, apellido y nombre del
-- departamento de todos los empleados que contengan en su apellido el valor que le
-- pasemos como parámetro.

CALL insertar_empleado(7999,'SERRA','EMPLEADO',7119,'1999-02-02',1999,1999,20);
SELECT * FROM Emp;
CALL info_por_apellido('SERRA')


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

