/* Claves 
    Integridad de datos,
    Rendimiento,
    Relaciones entre tablas,
    Prevención de datos duplicados
*/

CREATE SCHEMA prueba;
USE prueba;

-- Claves Priarias - PRIMARY KEY - 

CREATE TABLE estudiantes ( 
    id INT PRIMARY KEY,
    nombre VARCHAR(50)
);

CREATE TABLE estudiantes (
    id INT,
    nombre VARCHAR(50),
    PRIMARY KEY(id)
);

-- Claves Foraneas / Externas - FOREIGN KEY - 
CREATE TABLE cursos(
    id INT PRIMARY KEY,
    nombre VARCHAR(50)
);

CREATE TABLE inscripciones (
    estudiante_id INT,
    curso_id INT,
    FOREIGN KEY (estudiante_id) REFERENCES estudiantes(id),
    FOREIGN KEY (curso_id) REFERENCES cursos(id)
);

-- 2. Restricciones 

-- 2.1 Unicidad UNIQUE

CREATE TABLE empleados(
    id INT PRIMARY KEY,
    codigo_empleado INT UNIQUE,
    nombre VARCHAR(50)
);

-- 2.2 Valor predeterminado - DEFAULT -
CREATE TABLE pedidos(
    id INT PRIMARY KEY,
    fecha_pedido DATE DEFAULT (CURRENT_DATE),
    total DECIMAL(10,2) DEFAULT 0.00
);

INSERT INTO pedidos(id,total) VALUES (1,100), (2,30),(3,150);

INSERT INTO pedidos(id) VALUES (5);

SELECT * FROM pedidos;

-- 2.3 Verificacion - CHECK - 
-- Crear una tabla productos con un id, nombre, cantidad donde se verifique que la cantidad debe ser mayor a 0
CREATE TABLE producto(
    id INT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    cantidad INT CHECK (cantidad > 0)
);

INSERT INTO producto VALUES(1,"Bandeja Paisa",1);
SELECT * FROM producto;

-- 2.4 No nulos - NOT NULL -
CREATE TABLE clientes (
    id INT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

-- 2.5 Auto incremento - AUTO INCREMENT - 
DROP TABLE IF EXISTS empleados;
CREATE TABLE empleados (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50)
);
INSERT INTO empleados(nombre) VALUES ("eldiablo"),("lorenzo");

SELECT * FROM empleados;

-- 3. Entidad Relacion y el modelo Relacional
-- Componentes principales del modelo E-R
/* 1. Entidades: Objetos del mundo real de interés para el sistema
    2. Atributos: Caracteristiscas o propiedades de las _entidades_.
    3. Relaciones: Asociaciones o conexiones entre las _entidades_.
    4. Cardinalidad: Cantidad de instancias de una entidad en la otra / Cuantas veces está una entidad en otra:
        - 1:1
        - 1:N
        - N:M
*/

-- Modelo Relacional
/* Es una representación lógica más concreta y física de la base de datos
    - Los datos se organizan en tablas y relaciones
    - Las tablas filas(registros) y columnas(campos) 
    - Las relaciones se hacen a través de las llaves (Primaras y Foraneas)
    
    */