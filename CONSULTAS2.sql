CREATE TABLE EMPLE(
    EMP_NO NUMBER(4),
    APELLIDO VARCHAR2(20),
    OFICIO VARCHAR2(20),
    DIR NUMBER(4),
    FECHA_ALT DATE,
    SALARIO NUMBER(10),
    COMISION NUMBER(10),
    DEPT_NO NUMBER(3)
);

CREATE TABLE DEPART(
    DEPT_NO NUMBER(3),
    DNOMBRE VARCHAR2(20),
    LOC VARCHAR2(20)
);

INSERT INTO EMPLE VALUES(7369, 'SÁNCHEZ', 'EMPLEADO', 7902, '17/12/1980', 104000, NULL, 20);
INSERT INTO EMPLE VALUES(7499, 'ARROYO', 'VENDEDOR', 7698, '20/02/1980', 208000, 3900, 30);
INSERT INTO EMPLE VALUES(7521, 'SALA', 'VENDEDOR', 7698, '22/02/1981', 162500, 162500, 30);
INSERT INTO EMPLE VALUES(7566, 'JIMÉNEZ', 'DIRECTOR', 7839, '02/04/1981', 386750, NULL, 20);
INSERT INTO EMPLE VALUES(7654, 'MARTÍN', 'VENDEDOR', 7698, '29/09/1981', 162500, 182000, 30);
INSERT INTO EMPLE VALUES(7788, 'GIL', 'ANALISTA', 7566, '09/11/1981', 390000, NULL, 20);
INSERT INTO EMPLE VALUES(7839, 'REY', 'PRESIDENTE', NULL, '17/11/1981', 650000, NULL, 10);
INSERT INTO EMPLE VALUES(7844, 'TOVAR', 'VENDEDOR', 7698, '08/09/1981', 195000, 0, 30);
INSERT INTO EMPLE VALUES(7876, 'ALONSO', 'EMPLEADO', 7788, '23/09/1981', 143000, NULL, 20);
INSERT INTO EMPLE VALUES(7900, 'JIMENO', 'EMPLEADO', 7698, '03/12/1981', 1235000, NULL, 30);
INSERT INTO EMPLE VALUES(7902, 'FERNÁNDEZ', 'ANALISTA', 7566, '03/12/1981', 390000, NULL, 20);
INSERT INTO EMPLE VALUES(7934, 'MUÑOZ', 'EMPLEADO', 7782, '23/01/1982', 169000, NULL, 10);

INSERT INTO DEPART VALUES(10, 'CONTABILIDAD', 'SEVILLA');
INSERT INTO DEPART VALUES(20, 'INVESTIGACIÓN', 'MADRID');
INSERT INTO DEPART VALUES(30, 'VENTAS', 'BARCELONA');
INSERT INTO DEPART VALUES(40, 'PRODUCCIÓN', 'BILBAO');


-- 1. Mostrar los datos de los empleados que pertenezcan al mismo departamento que GIL?.

SELECT * FROM EMPLE 
WHERE DEPT_NO = (SELECT DEPT_NO 
    FROM EMPLE 
    WHERE APELLIDO = 'GIL');

-- 2. Mostrar los datos de los empleados que tengan el mismo oficio que ?CEREZO?. El resultado debe ir ordenado por apellido.

SELECT *
FROM EMPLE
WHERE APELLIDO = (SELECT OFICIO FROM EMPLE WHERE APELLIDO = 'CEREZO');

-- 3. Mostrar los empleados (nombre, oficio, salario y fecha de alta) quedesempeñen el mismo oficio que ?JIMÉNEZ? 
-- o que tengan un salario mayor o igual que ?FERNÁNDEZ?.

SELECT APELLIDO, OFICIO, SALARIO, FECHA_ALT
FROM EMPLE
WHERE APELLIDO = (SELECT OFICIO FROM EMPLE WHERE APELLIDO = 'JIMENEZ') 
OR SALARIO >= (SELECT SALARIO FROM EMPLE WHERE APELLIDO = 'FERNANDEZ');

--4. Mostrar en pantalla el apellido, oficio y salario de los empleados del departamento de ?FERNÁNDEZ? que tengan su mismo salario.

SELECT APELLIDO, OFICIO, SALARIO
FROM EMPLE
WHERE DEPT_NO = (SELECT DEPT_NO FROM EMPLE WHERE APELLIDO = 'FERNÁNDEZ')
AND SALARIO = (SELECT SALARIO FROM EMPLE WHERE APELLIDO = 'FERNÁNDEZ');

-- 5. Mostrar los datos de los empleados que tengan un salario mayor que ?GIL? y que pertenezcan al departamento número 10.

SELECT *
FROM EMPLE
WHERE SALARIO > (SELECT SALARIO FROM EMPLE WHERE APELLIDO = 'GIL')
AND DEPT_NO = 10;

-- 6. Mostrar los apellidos, oficios y localizaciones de los departamentos de cada uno de los empleados

SELECT APELLIDO, OFICIO, LOC
FROM EMPLE E
INNER JOIN DEPART D ON 
D.DEPT_NO = E.DEPT_NO;

-- 7. Seleccionar el apellido, el oficio y localidad de los departamentos donde trabajan los analistas.

SELECT APELLIDO, OFICIO, LOC
FROM EMPLE E
INNER JOIN DEPART D ON 
D.DEPT_NO = E.DEPT_NO WHERE OFICIO = 'ANALISTA';

-- 8. Actualizar el salario de los empleados del departamento 20 incrementandolos un 10€

UPDATE EMPLE SET SALARIO = SALARIO * 1.10 WHERE DEPT_NO = 20;
UPDATE EMPLE SET SALARIO = SALARIO * 1.10 WHERE DEPT_NO = (SELECT DEPT_NO FROM EMPLE WHERE APELLIDO = 'GIL');

-- 9. Mostrar para cada empleado el siguietne texto:
--    Mi nombre es: apellido mi sueldo es: salario empleado

SELECT 'MI NOMBRE ES ' || APELLIDO || ' Y MI SUELDO ES ' || SALARIO
AS NOMBREYSUELDO
FROM EMPLE;

-- Mostrar lo anterior espaciado por la derecha

SELECT 'MI NOMBRE ES ' || RPAD(APELLIDO, 20, ' ') || ' Y MI SUELDO ES ' || SALARIO
AS NOMBREYSUELDO
FROM EMPLE;

-- Que todos los salarios aparezcan pegados a la derecha

SELECT 'MI NOMBRE ES ' || LPAD(APELLIDO, 8, ' ') || ' Y MI SUELDO ES ' || SALARIO
AS NOMBREYSUELDO
FROM EMPLE;

-- Crear una tabla llamada MARIO con el contenido de la consulta anterior

CREATE TABLE MARIO AS
SELECT 'MI NOMBRE ES ' || LPAD(APELLIDO, 8, ' ') || ' Y MI SUELDO ES ' || SALARIO
AS NOMBREYSUELDO
FROM EMPLE;

-- De la tabla mario, por cada registro, indicar la posicion donde se encuentra la primera letra A.

SELECT INSTR(NOMBRE_DETALLADO, 'A'), NOMBRE_DETALLADO
FROM MARIO;

-- 8. Seleccionar el apellido, el oficio y salario de los empleados que trabajan en
-- Madrid.

SELECT APELLIDO, OFICIO, SALARIO
FROM EMPLE
WHERE LOC = 'MADRID';

-- 9. Seleccionar el apellido, salario y localidad donde trabajan de los empleados
-- que tengan un salario entre 200000 y 300000.

SELECT APELLIDO, OFICIO, LOC
FROM EMPLE E
INNER JOIN DEPART D ON 
D.DEPT_NO = E.DEPT_NO WHERE SALARIO BETWEEN 200000 AND 300000;

-- 11. Mostrar el apellido, salario y nombre del departamento de los empleados
--     que tengan el mismo oficio que ?GIL? y que no tengan comisión.

SELECT E.APELLIDO, E.SALARIO, D.DNOMBRE
FROM EMPLE E 
INNER JOIN DEPART D
ON E.DEPT_NO = D.DEPT_NO
AND OFICIO = (SELECT OFICIO
    FROM EMPLE
    WHERE APELLIDO = 'GIL')
AND nvl(COMISION, 0) = 0;

-- 12. Mostrar los datos de los empleados que trabajan en el departamento de
--     contabilidad, ordenados por apellidos.

SELECT *
FROM EMPLE
WHERE DEPT_NO = (SELECT DEPT_NO
     FROM DEPART
     WHERE DNOMBRE = 'CONTABILIDAD')
ORDER BY APELLIDO;

-- EN CASO DE QUE CONTABILIDAD ESTUVIESE EN MAYUS/MINUS, HABRÍA QUE 
-- PONER EL UPPER


-- 13. Apellido de los empleados que trabajan en Sevilla y cuyo oficio sea analista
--     o empleado.

SELECT APELLIDO
FROM EMPLE
WHERE DEPT_NO = (SELECT DEPT_NO
     FROM DEPART
     WHERE LOC='SEVILLA')
AND OFICIO IN ('ANALISTA', 'EMPLEADO');

-- El mismo con INNER JOIN:

SELECT E.APELLIDO
FROM EMPLE E 
INNER JOIN DEPART D
ON E.DEPT_NO = D.DEPT_NO
WHERE INITCAP(LOC) = 'Sevilla'
AND OFICIO IN('ANALISTA', 'EMPLEADO');


-- 14. Calcula el salario medio de todos los empleados.

SELECT AVG(SALARIO)
FROM EMPLE;

-- 15. ¿Cuál es el máximo salario de los empleados del departamento 10?

SELECT MAX(SALARIO) 
FROM EMPLE 
WHERE DEPT_NO = 10;

-- 16. Calcula el salario mínimo de los empleados del departamento 'VENTAS'.

SELECT MIN(SALARIO)
FROM EMPLE
WHERE DEPT_NO = (SELECT DEPT_NO
     FROM DEPART
     WHERE DNOMBRE = 'VENTAS');

-- 17. Calcula el promedio del salario de los empleados del departamento de
--     'CONTABILIDAD'.

SELECT AVG (SALARIO)
FROM EMPLE
WHERE DEPT_NO = (SELECT DEPT_NO
     FROM DEPART
     WHERE DNOMBRE = 'CONTABILIDAD');

-- 18. Mostrar los datos de los empleados cuyo salario sea mayor que la media de
--     todos los salarios.

SELECT *
FROM EMPLE
WHERE SALARIO > (SELECT
    AVG(SALARIO)
    FROM EMPLE);

-- 19. ¿Cuántos empleados hay en el departamento número 10?

SELECT COUNT(*)
FROM EMPLE
WHERE DEPT_NO = 10;

-- 20. ¿Cuántos empleados hay en el departamento de 'VENTAS'?

SELECT COUNT(*)
FROM EMPLE
WHERE DEPT_NO = (SELECT DEPT_NO
     FROM DEPART
     WHERE DNOMBRE = 'VENTAS');

-- 21. Calcula el número de empleados que hay que no tienen comisión.

SELECT COUNT(*) AS SIN_COMISION
FROM EMPLE
WHERE nvl(COMISION, 0) = 0;


-- 22. Seleccionar el apellido del empleado que tiene máximo salario.

SELECT APELLIDO
FROM EMPLE
WHERE SALARIO = (SELECT
    MAX(SALARIO)
    FROM EMPLE)

-- 23. Mostrar los apellidos del empleado que tiene el salario más bajo.

SELECT APELLIDO
FROM EMPLE
WHERE SALARIO = (SELECT MIN(SALARIO)
    FROM EMPLE);

-- 24. Mostrar los datos del empleado que tiene el salario más alto en el
--     departamento de 'VENTAS'.

SELECT APELLIDO
FROM EMPLE
WHERE SALARIO = (SELECT MAX(SALARIO)
    FROM EMPLE)
AND DEPT_NO = (SELECT DEPT_NO
    FROM DEPART
    WHERE DNOMBRE = 'VENTAS');

-- 25. A partir de la tabla EMPLE visualizar cuántos apellidos de los empleados
--     empiezan por la letra ?A'.

SELECT COUNT(*) AS EMPLEADOS_POR_A
FROM EMPLE
WHERE APELLIDO LIKE 'A%';

-- 26. Dada la tabla EMPLE, obtener el sueldo medio, el número de comisiones no
--     nulas, el máximo sueldo y el sueldo mínimo de los empleados del
--     departamento 30.

SELECT ROUND(AVG(SALARIO),2) AS SALARIO_MEDIO,
MAX(SALARIO) AS SALARIO_MAX
MIN(SALARIO) AS SALARIO_MIN
COUNT(*)
FROM EMPLE
WHERE DEPT_NO = 30 AND COMISION IS NOT NULL

-- Muestra todos los empleados que no trabajan en Sevilla sin utilizar la sentencia
-- distinto

SELECT *
FROM EMPLE E
INNER JOIN DEPART D
ON E.DEPT_NO = D.DEPT_NO
WHERE LOC NOT IN ('SEVILLA');

SELECT *
FROM EMPLE 
WHERE DEPT_NO IN (SELECT DEPT_NO
    FROM DEPART
    WHERE LOC 
    NOT IN ('SEVILLA'));
    















