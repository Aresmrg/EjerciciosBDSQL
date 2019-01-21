CREATE TABLE FAMILIAS (
    CARTFML varchar2 (4) NOT NULL ,
    CFMLDSC varchar2 (30) NOT NULL ,
    CONSTRAINT PK_FAMILIAS PRIMARY KEY (CARTFML)
);

CREATE TABLE ARTICULOS (
    CARTFML varchar2 (4) NOT NULL ,
    CARTCDG varchar2 (4) NOT NULL ,
    CARTDSC varchar2 (30) ,
    NARTPRC number(10, 2) ,
    NARTEXS number(10, 2) ,
    CONSTRAINT PK_ARTICULOS PRIMARY KEY ( CARTFML, CARTCDG) ,
    CONSTRAINT FK_ARTICULOS_FAMILIAS FOREIGN KEY (CARTFML)
    REFERENCES FAMILIAS (cARTFML)
);

CREATE TABLE COMPRAS (
    DCOMPFCH date NOT NULL ,
    CARTFML varchar2 (4) ,
    CARTCDG varchar2 (4) ,
    NCMPUND number(10, 2) DEFAULT (0),
    NCMPPRC number(10, 2) ,
    NCMPIMP number(20,4) ,
    NCMP_ID number(10, 0) NOT NULL ,
    CONSTRAINT PK_COMPRAS PRIMARY KEY(NCMP_ID),
    CONSTRAINT FK_COMPRAS_ARTICULOS
    FOREIGN KEY (CARTFML,CARTCDG)
    REFERENCES ARTICULOS (CARTFML,CARTCDG),
    CONSTRAINT CK_COMPRAS_NCMPUND CHECK (NCMPUND > 0)
);

CREATE SEQUENCE SQ_COMPRAS START WITH 1 INCREMENT BY 1;

CREATE TABLE VENTAS (
    DVNTFCH DATE NOT NULL ,
    CARTFML VARCHAR2 (4) ,
    CARTCDG VARCHAR2 (4) ,
    NVNTUND NUMBER(10, 2) DEFAULT (0),
    NVNTPRC NUMBER(10, 2) ,
    NVNT_ID NUMBER(10, 0) NOT NULL ,
    CONSTRAINT PK_VENTAS PRIMARY KEY(NVNT_ID),
    CONSTRAINT FK_ARTICULOS_VENTAS
    FOREIGN KEY(CARTFML,CARTCDG)
    REFERENCES ARTICULOS (CARTFML,CARTCDG),
    CONSTRAINT CK_VENTAS_NCMPUND CHECK (NVNTUND > 0)
);
CREATE SEQUENCE SQ_VENTAS START WITH 1 INCREMENT BY 1;
    CREATE TABLE ROTURAS (
    DRTRFCH DATE NOT NULL ,
    CARTFML VARCHAR2 (4) ,
    CARTCDG VARCHAR2 (4) ,
    NRTRUND NUMBER(10, 2)DEFAULT (0),
    NRTR_ID NUMBER(10, 0)NOT NULL ,
    CONSTRAINT PK_ROTURAS PRIMARY KEY(NRTR_ID),
    CONSTRAINT FK_ARTICULOS_ROTURAS
    FOREIGN KEY(CARTFML,CARTCDG)
    REFERENCES ARTICULOS (CARTFML,CARTCDG),
    CONSTRAINT CK_ROTURAS_NCMPUND CHECK (NRTRUND > 0)
);

CREATE SEQUENCE SQ_ROTURAS START WITH 1 INCREMENT BY 1;

Insert Into Familias Values ('F1','Discos Duros');
Insert Into Familias Values ('F2','Procesadores');
Insert Into Familias Values ('F3','Pantallas');

--Insert Into Familias Values ('F1SE','NUEVA');

COMMIT;

Insert Into Articulos Values ('F1','SEA1','HD Seagate 40 GB',1,1);
Insert Into Articulos Values ('F1','IBM1','HD IBM 80 GB',2,2);
Insert Into Articulos Values ('F1','IBM2','HD IBM 120 GB',3,3);
Insert Into Articulos Values ('F2','P4-1','Pentium 4 2400 Mh',4,4);
Insert Into Articulos Values ('F2','P4-2','Pentium 4 3000 Mh',5,5);
Insert Into Articulos Values ('F2','P3-X','Pentium 3 Xeon',6,6);
Insert Into Articulos Values ('F3','TFT1','TFT LG 5100',7,7);

--Insert Into Articulos Values ('F1SE','A1','NUEVO',1,1);

COMMIT;

Insert into Compras (dcompfch,cartfml,cartcdg,ncmpund,ncmpprc,ncmpimp,ncmp_id)
Values(SYSDATE,'F1','SEA1',1,1,1*1,SQ_COMPRAS.NEXTVAL);
Insert into Compras (dcompfch,cartfml,cartcdg,ncmpund,ncmpprc,ncmpimp,ncmp_id)
Values(SYSDATE,'F1','IBM1',2,2,2*2,SQ_COMPRAS.NEXTVAL);
Insert into Compras (dcompfch,cartfml,cartcdg,ncmpund,ncmpprc,ncmpimp,ncmp_id)
Values(SYSDATE,'F1','IBM2',3,3,3*3,SQ_COMPRAS.NEXTVAL);
Insert into Compras (dcompfch,cartfml,cartcdg,ncmpund,ncmpprc,ncmpimp,ncmp_id)
Values(SYSDATE,'F2','P4-1',4,4,4*4,SQ_COMPRAS.NEXTVAL);
Insert into Compras (dcompfch,cartfml,cartcdg,ncmpund,ncmpprc,ncmpimp,ncmp_id)
Values(SYSDATE,'F2','P4-2',5,5,5*5,SQ_COMPRAS.NEXTVAL);
Insert into Compras (dcompfch,cartfml,cartcdg,ncmpund,ncmpprc,ncmpimp,ncmp_id)
Values(SYSDATE,'F3','TFT1',6,6,6*6,SQ_COMPRAS.NEXTVAL);

COMMIT;

Insert into Ventas (dvntfch,cartfml,cartcdg,nvntund,nvntprc,nvnt_id)
Values (SYSDATE,'F1','IBM1',1,4,SQ_VENTAS.NEXTVAL);
Insert into Ventas (dvntfch,cartfml,cartcdg,nvntund,nvntprc,nvnt_id)
Values (SYSDATE,'F2','P4-1',1,5,SQ_VENTAS.NEXTVAL);
Insert into Ventas (dvntfch,cartfml,cartcdg,nvntund,nvntprc,nvnt_id)
Values (SYSDATE,'F2','P4-2',3,6,SQ_VENTAS.NEXTVAL);
Insert into Ventas (dvntfch,cartfml,cartcdg,nvntund,nvntprc,nvnt_id)
Values (SYSDATE,'F1','SEA1',3,6,SQ_VENTAS.NEXTVAL);

COMMIT;

Insert Into Roturas Values (SYSDATE,'F3','TFT1',2,SQ_ROTURAS.NEXTVAL);

-- 1. Mostrar las familias de artículos.

SELECT * FROM FAMILIAS

-- 2. Mostrar la descripción de los artículos.

SELECT CARTDSC FROM ARTICULOS

-- 3. Mostrar las ventas con el subtotal de cada venta.

SELECT NVNTUND * NVNTPRC AS  SUBTOTAL FROM VENTAS

-- 4. Mostrar el código de los artículos que se han comprado con precio comprendido
-- entre 3 y 5 euros.

SELECT CARTCDG FROM COMPRAS WHERE NCMPRC BETWEEN 3 AND 5

-- 5. Mostrar las compras de artículos de las familias F1 y F3 (hacerlo de al menos dos
-- formas diferentes).

SELECT CARTCDG FROM COMPRAS WHERE CARTFML = 'F1' 
UNION
SELECT CARTCDG FROM COMPRAS WHERE CARTFML = 'F3'

SELECT * FROM COMPRAS WHERE CARTFML IN ('F3','F1');

-- 6. Familias que contengan la letra P en su descripción.

SELECT * FROM FAMILIAS WHERE CFMLDSC LIKE '%P%'

-- 7. Artículos de los que se han realizado compras (hacerlo de al menos dos formas
-- diferentes).

SELECT CARTDSC 
FROM ARTICULOS A
INNER JOIN COMPRAS C
ON A.CARTCDG = C.CARTCDG AND A.CARTFML = C.CARTFML;

SELECT CARTDSC
FROM ARTICULOS
WHERE CARTCDG||CARTFML IN (SELECT CARTCDG||CARTFML
                           FROM COMPRAS);

-- 8. Artículos de los que no se han realizado ventas.

SELECT *
FROM ARTICULOS
WHERE CARTCDG||CARTFML NOT IN (SELECT CARTCDG||CARTFML
                               FROM VENTAS)

SELECT * FROM ARTICULOS
MINUS
SELECT * FROM ARTICULOS WHERE CARTFML||CARTCDG IN (SELECT CARTCDG||CARTFML FROM VENTAS)

-- 9. Artículos ordenados por su descripción de forma descendente.

SELECT *
FROM ARTICULOS
ORDER BY CARTDSC DESC;

-- 10. Roturas con alias para todos sus campos.

SELECT DRTRFCH AS FECHA_ROTURA, 
       CARTFML AS FAMILIA_ARTICULO,
       CARTCDG AS CODIGO_ARTICULO,
       NRTRUND AS NUMERO_ROTURA,
       NRTR_ID AS IDENTIFICACION_ROTURA
FROM ROTURAS

-- 11. Familias de las que se han producido roturas (hacerlo de al menos dos formas
-- diferentes).

SELECT F.*
FROM FAMILIAS F
INNER JOIN ROTURAS R
ON F.CARTFML = R.CARTFML

SELECT *
FROM FAMILIAS
WHERE CARTFML IN (SELECT CARTFML
                  FROM ROTURAS)

-- 12. Nombre de los artículos de los que se han producido ventas (hacerlo de al menos
-- dos formas diferentes).

SELECT CARTDSC
FROM ARTICULOS A
INNER JOIN VENTAS V
ON A.CARTCDG = V.CARTCDG

SELECT CARTDSC
FROM ARTICULOS
WHERE CARTCDG IN (SELECT CARTCDG
                  FROM VENTAS)

-- 13. Código y nombre del artículo del que se ha realizado la compra más cara.

SELECT A.CARTCDG, A.CARTDSC
FROM ARTICULOS A
INNER JOIN COMPRAS C
ON A.CARTFML = C.CARTFML AND A.CARTCDG = C.CARTCDG
WHERE NCMPIMP IN (SELECT MAX(NCMPIMP)
                  FROM COMPRAS)
                  
-- Con vista interactiva:

SELECT CARTCDG,CARTDSC FROM ARTICULOS A                         -- mostramos los campos que se piden
WHERE CARTFML||CARTCDG IN (
    SELECT CARTFML||CARTCDG FROM COMPRAS WHERE NCMPIMP IN (     -- todos los articulos que se han comprado a 36€
        SELECT NCMPIMP FROM                                     
            (SELECT * FROM COMPRAS ORDER BY NCMPIMP DESC)       -- ordenar por importe
        WHERE ROWNUM = 1));                                     -- nos quedamos con el primero   

-- 14. Descripción de las familias de los artículos de los que se ha realizado las 2 compras
-- más baratas.

SELECT CCFMLDSC FROM FAMILIAS A                      
WHERE CARTFML IN (
    SELECT CARTFML FROM COMPRAS WHERE NCMPIMP IN (   
        SELECT NCMPIMP FROM                                     
            (SELECT * FROM COMPRAS ORDER BY NCMPIMP ASC) 
        WHERE ROWNUM <= 2)); 

-- 15. Familias que tienen 2 o más artículos.

SELECT * FROM FAMILIAS WHERE CARTFML IN (
    SELECT CARTFML
    FROM ARTICULOS
    GROUP BY CARTFML
    HAVING COUNT(*) > 2);
    
SELECT F.CARTFML, F.CFMLDSC 
FROM FAMILIAS F
INNER JOIN ARTICULOS A ON A.CARTFML = F.CARTFML
GROUP BY F.CARTFML, F.CFMLDSC
HAVING COUNT (*) > 2;

-- 16. Artículos que se han comprado y aún no se han vendido.

SELECT * FROM ARTICULOS A
WHERE CARTFML||CARTCDG IN (SELECT CARTFML||CARTCDG FROM COMPRAS)
AND CARTFML||CARTCDG NOT IN (SELECT CARTFML||CARTCDG FROM VENTAS)

SELECT * FROM ARTICULOS A WHERE CARTFML||CARTCDG IN (
    SELECT CARTFML||CARTCDG FROM COMPRAS
    MINUS
    SELECT CARTFML||CARTCDG FROM VENTAS);

-- 17. Familia o familias de las que se disponen de más artículos.

CREATE VIEW VFA AS
    SELECT CARTFML, SUM(NARTEXS) AS NUMERO
    FROM ARTICULOS
    GROUP BY CARTFML

SELECT * FROM VFA 
WHERE NUMERO IN (SELECT MAX(NUMERO) 
                 FROM VFA);
                 
-- con inner

SELECT F.* 
FROM VFA A
INNER JOIN FAMILIAS F 
ON A.CARTFML = F.CARTFML
WHERE NUMERO IN (SELECT MAX(NUMERO) 
                 FROM VFA);

-- 18. Calcular el importe total de todos los artículos del almacén.

SELECT SUM(NARTPRC * NARTEXS) AS IMPORTE_TOTAL FROM ARTICULOS;

-- 19. Listado de todos los artículos con el total de unidades que se han comprado, el
-- total de unidades que se han vendido y el total de unidades que se han roto de cada
-- uno de ellos.

SELECT A.CARTCDG, A.CARTDSC, 
SUM(NVL(NCMPUND, 0)) AS COMPRADOS, SUM(NVL(NVNTUND,0)) AS VENDIDOS, SUM(NVL(NRTRUND,0)) AS ROTOS
FROM ARTICULOS A
LEFT OUTER JOIN COMPRAS C ON A.CARTFML = C.CARTFML AND A.CARTCDG = C.CARTCDG
LEFT OUTER JOIN VENTAS V ON A.CARTFML = V.CARTFML AND A.CARTCDG = V.CARTCDG
LEFT OUTER JOIN ROTURAS R ON A.CARTFML = R.CARTFML AND A.CARTCDG = R.CARTCDG
GROUP BY A.CARTCDG, A.CARTDSC

-- FORMA CORRECTA DE HACERLO

CREATE VIEW VC1 AS
    SELECT CARTFML, CARTCDG, SUM(NVL(NCMPUND, 0)) AS COMPRADOS
    FROM COMPRAS
    GROUP BY CARTFML, CARTCDG;
    
CREATE VIEW VV1 AS
    SELECT CARTFML, CARTCDG, SUM(NVL(NVNTUND,0)) AS VENDIDOS
    FROM VENTAS
    GROUP BY CARTFML, CARTCDG;
    
CREATE VIEW VR1 AS
    SELECT CARTFML, CARTCDG, SUM(NVL(NRTRUND,0)) AS ROTOS
    FROM ROTURAS
    GROUP BY CARTFML, CARTCDG;
    
SELECT A.*, NVL(COMPRADOS,0) AS COMPRADOS, NVL(VENDIDOS, 0) AS VENDIDOS, NVL(ROTOS, 0) AS ROTOS
FROM ARTICULOS A
LEFT OUTER JOIN VC1 C ON A.CARTFML = C.CARTFML AND A.CARTCDG = C.CARTCDG
LEFT OUTER JOIN VV1 V ON A.CARTFML = V.CARTFML AND A.CARTCDG = V.CARTCDG
LEFT OUTER JOIN VR1 R ON A.CARTFML = R.CARTFML AND A.CARTCDG = R.CARTCDG
    

-- 20. Precio medio de los artículos por familia.

SELECT CARTFML, AVG(NARTPRC) AS PRECIO_MEDIO_X_FAMILIA
FROM ARTICULOS
GROUP BY CARTFML

-- 21. Mostrar un listado agrupado por familias donde se muestre el número de artículos
-- de cada familia y el valor de sus existencias.

SELECT CARTFML, COUNT(*) AS NUM_ART_X_FAMILIA, SUM(NARTPRC * NARTEXS) AS VALOR_EX
FROM ARTICULOS
GROUP BY CARTFML

-- 22. Familia que tiene el artículo de precio más alto.

SELECT * FROM FAMILIAS WHERE CARTFML IN (
    SELECT CARTFML FROM ARTICULOS WHERE NARTPRC IN (
        SELECT MAX(NARTPRC) FROM ARTICULOS));


-- 23. Familias de las que se ha vendido más de 40 euros en total.

SELECT F.CARTFML, F.CFMLDSC
FROM VENTAS V
INNER JOIN FAMILIAS F ON V.CARTFML = F.CARTFML
GROUP BY F.CARTFML, F.CFMLDSC
HAVING SUM(NVNTPRC * NVNTUND) > 40;

-- 24. Familias de las que se ha vendido más que el valor en inventario del artículo con
-- código ‘IBM2’.

SELECT F.CARTFML, F.CFMLDSC
FROM VENTAS V
INNER JOIN FAMILIAS F ON V.CARTFML = F.CARTFML
GROUP BY F.CARTFML, F.CFMLDSC
HAVING SUM(NVNTPRC * NVNTUND) > (SELECT NARTPRC * NARTEXS 
                                 FROM ARTICULOS 
                                 WHERE CARTCDG = 'IBM2');

-- 25. Calcular los beneficios de la empresa: existencias + ventas - compras.

SELECT
(SELECT SUM(NARTPRC*NARTEXS) FROM ARTICULOS)
+
(SELECT SUM(NVNTPRC*NVNTUND) FROM VENTAS)
-
(SELECT SUM(NCMPPRC*NCMPUND) FROM COMPRAS)
AS BENEFICIO
FROM DUAL;

-- 26. Realizar un listado donde se muestre el total de ventas agrupadas por meses.

SELECT TO_CHAR(DVNTFCH, 'MM/YYYY') AS MES, SUM(NVNTPRC*NVNTUND) AS VENTAS_X_MESES
FROM VENTAS V
GROUP BY TO_CHAR(DVNTFCH, 'MM/YYYY')
ORDER BY TO_CHAR(DVNTFCH, 'MM/YYYY');






