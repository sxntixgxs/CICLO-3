# Operacion De Combinación de Tablas (JOINS)


```SQL
-- PRODUCTO CRUZ, TODOS CON TODOS
USE world;
SELECT C.code, C.name, D.id, D.name, D.countrycode
FROM country AS C, city AS D
```

+ **INNER JOIN** INTERSECCION
    ```SQL
    -- id = 1
    USE world;
    -- Ciudades de Colombia
    SELECT P.name, C.name
    FROM country AS P
    JOIN city AS C ON P.code = C.countrycode
    WHERE P.name = "Colombia";
    ```
+ **LEFT JOIN**: Todos el conjunto de A y donde no haya relación con B entonces NULL.

    ![Ejemplo](https://www.w3schools.com/sql/img_left_join.png)
        
    ```SQL
        -- id = 2
        SELECT L.language, P.name
        FROM countrylanguage AS L
        LEFT JOIN country AS P on L.countrycode = P.code;
    ```
+ **RIGHT JOIN**: Todos los elementos del conjunto B, donde no haya relación con A es NULL

    ```SQL
    -- id = 3
    SELECT P.name, C.name
    FROM city AS C
    RIGHT JOIN country AS P on C.countrycode = P.code
    WHERE P.name = "Colombia";
    ```
+ **FULL OUTER JOIN**: Todos los de A y todos los de B, en MySQL no existe como tal, entonces hay que ahcerla por aparte el left join y el right join, teniendo en cuenta que los campos deben ser iguales en ambas consultas.