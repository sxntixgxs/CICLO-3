-- link https://classroom.google.com/c/NjI0NTU4MjMwMzQw
-- II. Con la base de datos Tienda informática hacer las consultas propuestas:

USE ventas;

SELECT * FROM cliente;
SELECT * FROM comercial;
SELECT * FROM pedido;


-- Calcula la cantidad total que suman todos los pedidos que aparecen en la tabla pedido.

    SELECT COUNT(id) AS TotalPedidos
    FROM pedido;


-- 2. Calcula la cantidad media de todos los pedidos que aparecen en la tabla pedido.

    SELECT FORMAT(AVG(id),1) AS MediaPedidos
    FROM pedido;

-- 3. Calcula el número total de comerciales distintos que aparecen en la tabla pedido.
    SELECT * FROM pedido;
    SELECT COUNT(DISTINCT id_comercial)
    FROM pedido;

-- 4. Calcula el número total de clientes que aparecen en la tabla cliente.
    SELECT * FROM cliente;
    SELECT COUNT(id) AS NumClientes
    FROM cliente;

-- 5. Calcula cuál es la mayor cantidad que aparece en la tabla pedido.
    SELECT * FROM pedido;
    SELECT MAX(total)
    FROM pedido;

-- 6. Calcula cuál es la menor cantidad que aparece en la tabla pedido.

    SELECT MIN(total)
    FROM pedido;

-- 7. Calcula cuál es el valor máximo de categoría para cada una de las ciudades que aparece
-- en la tabla cliente.
    SELECT * FROM cliente;
    SELECT ciudad, MAX(categoría) AS ValorMaxPorCategoria
    FROM cliente
    GROUP BY ciudad;

-- 8. Calcula cuál es el máximo valor de los pedidos realizados durante el mismo día para cada
-- uno de los clientes. Es decir, el mismo cliente puede haber realizado varios pedidos de
-- diferentes cantidades el mismo día. Se pide que se calcule cuál es el pedido de máximo
-- valor para cada uno de los días en los que un cliente ha realizado un pedido. Muestra el
-- identificador del cliente, nombre, apellidos, la fecha y el valor de la cantidad.
    SELECT * FROM cliente;
    SELECT * FROM pedido;
    SELECT C.nombre, C.apellido1, P.fecha, MAX(P.total) AS MaxCantidad
    FROM pedido AS P
    INNER JOIN cliente AS C ON P.id_cliente = C.id
    GROUP BY C.nombre, C.apellido1, P.fecha
    ORDER BY P.fecha, C.nombre;

-- 9. Calcula cuál es el máximo valor de los pedidos realizados durante el mismo día para cada
-- uno de los clientes, teniendo en cuenta que sólo queremos mostrar aquellos pedidos que
-- superen la cantidad de 2000 €.

    SELECT C.nombre, C.apellido1, P.fecha, MAX(P.total) AS MaxCantidad
    FROM pedido AS P
    INNER JOIN cliente AS C ON P.id_cliente = C.id
    GROUP BY C.nombre, C.apellido1, P.fecha
    HAVING MaxCantidad > 2000
    ORDER BY P.fecha, C.nombre
;


-- 10. Calcula el máximo valor de los pedidos realizados para cada uno de los comerciales
-- durante la fecha 2016-08-17. Muestra el identificador del comercial, nombre, apellidos y
-- total.

    SELECT * FROM comercial;
    SELECT C.id, C.nombre, C.apellido1, MAX(P.total) AS ValorMaxPedido
    FROM pedido AS P
    INNER JOIN comercial AS C ON P.id_comercial = C.id
    WHERE P.fecha = '2016-08-17'
    GROUP BY C.id, C.nombre, C.apellido1;

-- 11. Devuelve un listado con el identificador de cliente, nombre y apellidos y el número total de
-- pedidos que ha realizado cada uno de clientes. Tenga en cuenta que pueden existir
-- clientes que no han realizado ningún pedido. Estos clientes también deben aparecer en el
-- listado indicando que el número de pedidos realizados es 0.
    SELECT * FROM cliente;
    SELECT * FROM pedido;
    SELECT C.id, C.nombre, C.apellido1, IFNULL(COUNT(P.id),0)
    FROM pedido AS P
    RIGHT JOIN cliente AS C ON P.id_cliente = C.id
    GROUP BY C.id, C.nombre, C.apellido1;


-- 12. Devuelve un listado con el identificador de cliente, nombre y apellidos y el número total de
-- pedidos que ha realizado cada uno de clientes durante el año 2017.

    SELECT C.id, C.nombre, C.apellido1
    FROM pedido AS P
    INNER JOIN cliente AS C ON P.id_cliente = C.id
    WHERE P.fecha LIKE '2017%'
    GROUP BY C.id
    ORDER BY C.id;

-- 13. Devuelve un listado que muestre el identificador de cliente, nombre, primer apellido y el
-- valor de la máxima cantidad del pedido realizado por cada uno de los clientes. El
-- resultado debe mostrar aquellos clientes que no han realizado ningún pedido indicando
-- que la máxima cantidad de sus pedidos realizados es 0. Puede hacer uso de la
-- función IFNULL.

    SELECT C.id, C.nombre, C.apellido1, IFNULL(MAX(P.total),0) AS MaxPedido
    FROM pedido AS P
    RIGHT JOIN cliente AS C ON P.id_cliente = C.id
    GROUP BY C.id;


-- 14. Devuelve cuál ha sido el pedido de máximo valor que se ha realizado cada año.
    SELECT * FROM pedido;
    SELECT YEAR(P.fecha) AS Anio,MAX(P.total) AS PedidoMasCaroPorAño
    FROM pedido AS P
    GROUP BY YEAR(P.fecha)
-- 15. Devuelve el número total de pedidos que se han realizado cada año.

    SELECT YEAR(P.fecha) AS Anio, COUNT(P.id) AS TotalPedidos
    FROM pedido AS P
    GROUP BY YEAR(P.fecha);