/* INDICES EN MYSQL
*/
-- CREATE INDEX Index_name
--     ON table_name(column1,column2,...)

CREATE INDEX idx_email /* si es foraneo se coloca fdx*/
    ON users(email);

-- INDICE SIMPLE
USE world;

CREATE INDEX idx_name
    ON country(name);

-- INDICES COMPUESTOS
-- PERMITE CONSULTAR POR VARIAS COLUMNAS
CREATE INDEX idx_order_date_status ON orders (order_date,status);
-- indices MAX_USER_CONNECTIONS
CREATE UNIQUE INDEX 

DROP INDEX idx_name ON country;


-- INDICE UNICO
-- indice unico sobre el nombre del pais
CREATE UNIQUE INDEX idx_unqname ON country(name);

-- INDICE DE TEXTO COMPLEToO
-- PERMITE BUSQUEDA EFICIENTE DE TEXTO COMPLETO EN CAMPOS DE TEXTO LARGO
-- LA BUSQUEDA DEBE SER POR PALABRAS EXAKTAKS no expresiones reg
CREATE FULLTEXT INDEX idx_article_content ON articles(content);
 
-- vistas VIEWS
-- OBJETOS DE LA BASE DE DATOS
-- TABLAS VIRTUALES (?) NO SE ALMACENAN FISICAMENTE Y SOLO SE CREAN? CUANDO SON PEDIDAS
-- SIMPLIFICACION CONSULTAS COMPLEJAS
-- SEGURIDAD, PORQUE LOS USUARIOS SOLO TIENEN ACCESO A LAS VISTAS QUE PARA ELLOS ES UNA TABLA PERO REALMENTE ES UNA VIEW

-- esta vista vista_detalles_usuario proporciona una forma simplificada de acceder a los detalles completos de los usuarios, combinando datos de las tablas usuarios y ...
CREATE VIEW vista_detalles_usuario AS
    SELECT u.id,u.nombre,d.direccion,d.telefono
    FROM usuarios u
    JOIN detalles_usuario d ON u.id = d.usuario_id;
    -- ejemplo
    DROP VIEW view_PopulationCity;
create VIEW view_PopulationCity as
    select *
        from (
            select Name as cityName, Population, CountryCode
            from city
            order by Population desc
        ) as ciudades

        inner join (
            select Code, Name as CountryName, Continent
                from country
        ) as countryFilter on ciudades.CountryCode = countryFilter.Code

        where Continent <> 'Oceania' and Continent <> 'Antarctica';

select *
    from (
        select *
        from (
            select Code, CountryName, CityName, Continent, format(Population, 0) as PopulationCity
            from view_PopulationCity
            where Continent = 'South America' or Continent = 'North America'
            order by Population desc
            limit 5
        ) as PopulationCitiesAmerica

        union

        select *
            from (
                select Code, CountryName, CityName, Continent, format(Population, 0) as PopulationCity
                from view_PopulationCity
                where Continent = 'Europe'
                order by Population desc
                limit 5
            ) as PopulationCitiesEurope

        union

        select *
            from (
                select Code, CountryName, CityName, Continent, format(Population, 0) as PopulationCity
                from view_PopulationCity
                where Continent = 'Asia'
                order by Population desc
                limit 5
            ) as PopulationCitiesAsia

        union

        select * 
            from (
                select Code, CountryName, CityName, Continent, format(Population, 0) as PopulationCity
                from view_PopulationCity
                where Continent = 'Africa'
                order by Population desc
                limit 5
            ) as PopulationCitiesAfrica
    ) as orderCitiesPopulation
    order by Continent asc, CityName desc;

-- sintaxis para cambiar una vista
CREATE OR REPLACE VIEW nombre_vista AS
    SELECT columnas
    FROM tablas
    WHERE condiciones;

SET @continente := "Asia";

CREATE OR REPLACE VIEW PopulationCitiesContinent AS
    SELECT *
        FROM (
            SELECT code, countryname, cityname, continent, FORMAT(population,0) AS 
            PopulationCity
            FROM view_populationcity
            WHERE continent = @continente
            ORDER BY population DESC
            LIMIT 5
        );

SELECT L.language, L.percentage,
IF(L.isofficial="F","No oficial","Oficial") AS Tipo,
    CASE 
        WHEN L.isofficial = "F" THEN "No oficial"  
        ELSE  "Oficial"
    END as Tipo2,
    CASE 
        WHEN L.percentage < 0.3 THEN "Poco hablado"
        WHEN L.percentage BETWEEN 0.4 AND 49 THEN "Medianamente hablado"
        ELSE "Muy hablado"
    END AS Type3
FROM world.countrylanguage L
JOIN world.country P ON L.countrycode = P.code
WHERE P.name = "Colombia";
    
SELECT 
    nombre,
    edad,
    (CASE 
        WHEN edad < 18 THEN "Menor de Edad"  
        ELSE  
    END)