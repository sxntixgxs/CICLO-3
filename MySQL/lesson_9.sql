/*
     NORMALIZACION DE BASES DE DATOS
     1 FN identificar tablas con sus respectivos campos. Elimina las repeticiones de datos y asegura la atomicidad.
     2. Identifica dependencias funcionales directas y transitivas, cada atributo NO CLAVE en una tabla debe depender completamente de la clave primaria de esa tabla y no de solo una parte de ella /sacar las que no tienen dependencias primarias y van en una tabla aparte
     3. Elimina las dependencias funcionales y transitivas, se identifican las relaciones, cada atributo no clave en una tabla debe depender unicamente de la clave primaria de esa tabla y no de otros atributos no clave
     4. Se rompen los muchos a muchos ...

Problemas: 
    Una columna tiene varios valores, un campo telefonos que almacena varios numeros en una sola fila
*/
CREATE TABLE estudiante(
    id INT,
    nombre VARCHAR(100),
    telefonos VARCHAR(255)
); -- version sin 4 FN

-- solucion
CREATE TABLE telefonos(
    id_est INT,
    telefono VARCHAR(15)
    FOREIGN KEY (id_est) REFERENCES estudiante(id)
    PRIMARY KEY (id_est,telefono)
);
CREATE TABLE estudiante(
    id INT PRIMARY KEY,
    nombre VARCHAR(100)
    id_tel INT
    FOREIGN KEY (id_tel) REFERENCES telefonos(id_est)
);

--     normalizar la siguiente estructura
CREATE TABLE CursoEstudiante(
    cursoID INT,
    estudianteID INT,
    nombreCurso VARCHAR(100),
    nombreEstudiante VARCHAR(100),
    PRIMARY KEY (cursoID, estudianteID),
    FOREIGN KEY (cursoID) REFERENCES curso(id),
    FOREIGN KEY (estudianteID) REFERENCES estudiante(id)
);
DROP TABLE estudiante;

CREATE SCHEMA prueba_clase_9;
USE prueba_clase_9;
DROP TABLE curso;
DROP TABLE estudiante;
CREATE TABLE curso(
    id INT PRIMARY KEY,
    nombre VARCHAR(100)
);
DROP TABLE CursoEstudiante;
CREATE TABLE CursoEstudiante(
    curso_id INT,
    estudiante_id INT,
    PRIMARY KEY(curso_id,estudiante_id),
    FOREIGN KEY (curso_id) REFERENCES curso(id),
    FOREIGN KEY (estudiante_id) REFERENCES estudiante(id)
);
DROP TABLE CursoEstudiante;
CREATE TABLE estudiante(
    id INT PRIMARY KEY,
    nombre VARCHAR(100)
);

-- 3 ejercicio normalizar la siguiente estructura
CREATE TABLE profesor(
    profesor_id INT,
    nombre VARCHAR(100),
    departamento_id INT,
    nombre_departamento VARCHAR(100)
);

-- solucion
CREATE TABLE profesor(
    id INT,
    nombre VARCHAR(100),
    departamento_id INT,
    FOREIGN KEY (departamento_id) REFERENCES departamento(id)
);

CREATE TABLE departamento(
    id INT PRIMARY KEY,
    nombre VARCHAR(100)
);

-- Normalizar la siguiente estructura si 'horario' depende solo de 'cursoid'

CREATE TABLE asignacion(
    ProfesorID INT,
    CursoID INT,
    PRIMARY KEY (ProfesorID,CursoID),
    FOREIGN KEY (ProfesorID) REFERENCES profesor(id),
    FOREIGN KEY (CursoID) REFERENCES curso(id)
);
DROP TABLE asignacion;

-- solucion


DROP TABLE profesor;
DROP TABLE curso;
CREATE TABLE profesor(
    id INT PRIMARY KEY,
    nombre VARCHAR(100)
);
CREATE TABLE curso(
    id INT PRIMARY KEY,
    nombre VARCHAR(50),
    id_profesor INT,
    FOREIGN KEY (id_profesor) REFERENCES profesor(id)
);
CREATE TABLE horario(
    id INT PRIMARY KEY
);
CREATE TABLE curso-horario(
    id_curso INT,
    id_horario INT,
    PRIMARY KEY(id_curso,id_horario)
    FOREIGN KEY (id_curso) REFERENCES curso(id),
    FOREIGN KEY (id_horario) REFERENCES horario(id)
);
-- normalizar la siguiente estructura para un sistema de gestión de un hospital
-- Hay una tabla que intenta manejar multiples aspectos de la información del paciente, las visitas al medico, los tratamientos y las recetas

CREATE TABLE RegistroHospital (
    PacienteID INT,
    NombrePaciente VARCHAR(100),
    FechaNacimiento DATE,
    MedicoID INT,
    NombreMedico VARCHAR(100),
    Especialidad VARCHAR(100),
    FechaVisita DATETIME,
    DescripcionTratamiento VARCHAR(255),
    Medicamento VARCHAR(100),
    DOSIS VARCHAR(50)
);
-- solucion!
CREATE TABLE paciente(
    id INT PRIMARY KEY,
    nombre VARCHAR(100),
    fecha_nacimiento DATE
);
CREATE TABLE medico(
    id INT PRIMARY KEY,
    nombre VARCHAR(100),
    especialidad VARCHAR(100)
);

CREATE TABLE tratamiento(
    id INT PRIMARY KEY,
    descripcion_tratamiento VARCHAR(255)
);

CREATE TABLE medicamento(
    id INT PRIMARY KEY,
    nombre VARCHAR(100)
);
CREATE TABLE tratamiento_medicamento(
    id_tratamiento INT,
    id_medicamento INT,
    dosis VARCHAR(50),
    PRIMARY KEY(id_tratamiento,id_medicamento),
    FOREIGN KEY (id_tratamiento) REFERENCES tratamiento(id),
    FOREIGN KEY (id_medicamento) REFERENCES medicamento(id)
);

CREATE TABLE cita(
    id INT PRIMARY KEY,
    id_paciente INT,
    id_medico INT,
    id_tratamiento INT,
    id_medicamento INT,
    fecha DATETIME,
    FOREIGN KEY (id_paciente) REFERENCES paciente(id),
    FOREIGN KEY (id_medico) REFERENCES medico(id),
    FOREIGN KEY (id_tratamiento) REFERENCES tratamiento(id),
    FOREIGN KEY (id_medicamento) REFERENCES medicamento(id)
);

-- pacientes 2022 id, nombre,fecha, nombre med, tratamiento
SELECT 
    P.id AS ID_Paciente,
    P.nombre AS Paciente, 
    C.fecha AS Fecha_Cita, 
    M.nombre AS Nombre_Medico, 
    T.descripcion_tratamiento AS Descripcion_Tratamiento
FROM cita AS C
INNER JOIN paciente AS P ON C.id_paciente = P.id
INNER JOIN medico AS M ON C.id_medico = M.id
INNER JOIN tratamiento AS T ON C.id_tratamiento = T.id
WHERE C.fecha LIKE "2022%";
