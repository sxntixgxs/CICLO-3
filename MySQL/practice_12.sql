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
CALL consultar_num_empleados_departamento(1000);

-- Diseñe y construya un procedimiento igual que el anterior, pero que recupere también las
-- personas que trabajan en dicho departamento, pasándole como parámetro el nombres

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

SELECT E.Apellido, E.Salario ,D.DNombre
FROM Emp AS E
INNER JOIN Dept AS D ON E.Dept_No = D.Dept_No
WHERE D.DNombre = "CONTABILIDAD";