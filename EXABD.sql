CREATE TABLE AUTOBUSES(
    Matricula VARCHAR2(7) PRIMARY KEY,
    Marca VARCHAR2(20) NOT NULL,
    Modelo VARCHAR2(20) NOT NULL
);

CREATE TABLE CONDUCTORES(
    NIF VARCHAR2(10) PRIMARY KEY,
    cNomConductor VARCHAR2(20) NOT NULL
);

CREATE TABLE CIUDADES(
    cCodCiudad VARCHAR2(10) PRIMARY KEY,
    cNomCiudad VARCHAR2(20) NOT NULL
);

CREATE TABLE RUTAS(
    NumRuta NUMBER(10) PRIMARY KEY,
    Fecha DATE,
    KmRuta NUMBER(10) NOT NULL,
    Matricula VARCHAR2(7) NOT NULL,
    NIF VARCHAR2(10) NOT NULL
);

CREATE TABLE PASA(
    NumRuta NUMBER(10) NOT NULL,
    cCodCiudad VARCHAR2(10) NOT NULL,
    Orden NUMBER(10) NOT NULL
);

-- CLAVES FORN�NEAS

ALTER TABLE PASA ADD CONSTRAINT FK_PASA_RUT FOREIGN KEY (NumRuta) REFERENCES RUTAS(NumRuta);
ALTER TABLE PASA ADD CONSTRAINT FK_PASA_CIU FOREIGN KEY (cCodCiudad) REFERENCES CIUDADES(cCodCiudad);
ALTER TABLE RUTAS ADD CONSTRAINT FK_RUTAS_AUTO FOREIGN KEY (Matricula) REFERENCES AUTOBUSES(Matricula);
ALTER TABLE RUTAS ADD CONSTRAINT FK_RUTAS_COND FOREIGN KEY (NIF) REFERENCES CONDUCTORES(NIF);

ALTER TABLE PASA ADD CONSTRAINT CK_ORDEN CHECK (Orden BETWEEN 0 AND 10);
ALTER TABLE RUTAS MODIFY KmRuta DEFAULT 1;

-- CONSULTAS:

-- 2. Nombre de las ciudades por las que pasan mas rutas.

CREATE VIEW V2 AS
    SELECT CCODCIUDAD, COUNT(*) AS NUMERO_VECES FROM PASA P
    GROUP BY CCODCIUDAD;
    
SELECT CNOMCIUDAD 
FROM CIUDADES 
WHERE CCODCIUDAD IN (SELECT CCODCIUDAD 
                     FROM V2 
                     WHERE NUMERO_VECES = (SELECT MAX(NUMERO_VECES) 
                                           FROM V2));

-- 3. Numero y fecha de las rutas que pasan por todas las ciudades

SELECT NUMRUTA, FECHA FROM RUTAS WHERE NUMRUTA IN(
    SELECT NUMRUTA, COUNT(DISTINCT CCODCIUDAD) AS NUMERO_VECES FROM PASA P
    GROUP BY NUMRUTA
    HAVING COUNT(DISTINCT CCODCIUDAD) = (SELECT COUNT(*) 
                                         FROM CIUDADES)
);
                    
-- 4. Nombre de los conductores que han realizado mas kilometros en todas las rutas que han realizado que el conductor 'PEPE SANCHEZ'

SELECT CNOMCONDUCTOR
FROM RUTAS R
INNER JOIN CONDUCTORES C
ON C.NIF = R.NIF
GROUP BY CNOMCONDUCTOR
HAVING SUM(KMRUTA) >= (SELECT SUM(KMRUTA) AS TOTAL
                       FROM RUTAS R
                       INNER JOIN CONDUCTORES C
                       ON C.NIF = R.NIF
                       WHERE UPPER(CNOMCONDUCTOR) LIKE '%PEPE SANCHEZ%');
                            


-- 5. Marca y modelo de cada autob�s y kil�metros totales realizados por cada uno de ellos.

SELECT MARCA, MODELO, SUM(KMRUTA) AS KILOMETRAJE
FROM AUTOBUSES A
INNER JOIN RUTAS R
ON A.MATRICULA = R.MATRICULA
GROUP BY MARCA, MODELO;

-- 6. Numero de rutas realizadas en ABRIL del a�o que marca el servidor de la base de datos

SELECT * FROM RUTAS
WHERE TO_CHAR(FECHA,'MM') = '04'
AND TO_CHAR(FECHA,'YYYY') = TO_CHAR(SYSDATE, 'YYYY');
               
-- 7. Numero, kilometros y fecha de las rutas que solo ha realizado el autobus con matricula '1234ABC'

SELECT * FROM RUTAS WHERE MATRICULA = '1234ABC'
MINUS
SELECT * FROM RUTAS WHERE MATRICULA <> '1234ABC';

-- 8. Nombre de los conductores que realizaron las rutas con mayor numero de ciudades por las que pasan.

CREATE VIEW V3 AS
    SELECT NUMRUTA, COUNT(DISTINCT CCODCIUDAD) AS NUM_CIUDADES FROM PASA
    GROUP BY NUMRUTA
    
SELECT CNOMCONDUCTOR FROM CONDUCTORES C
INNER JOIN RUTAS R ON C.NIF = R.NIF
WHERE NUMRUTA IN (SELECT NUMRUTA 
                  FROM V3 
                  WHERE NUM_CIUDADES = (SELECT MAX(NUM_CIUDADES 
                                        FROM V3);

-- 9. NIF y nombre de los conductores que nunca han conducido un autobus de la marca 'MERCEDES'

SELECT C.NIF, CNOMCONDUCTOR
FROM CONDUCTORES C
INNER JOIN RUTAS R
ON C.NIF = R.NIF
WHERE MATRICULA NOT IN (SELECT MATRICULA                    -- Si un conductor hubiera conducido mercedes alguna vez, no funcionaria, meteria al conductor
                        FROM AUTOBUSES
                        WHERE UPPER(MARCA) = 'MERCEDES');
                        
-- Forma correcta

SELECT * FROM CONDUCTORES WHERE NIF NOT IN (
    SELECT NIF FROM AUTOBUSES A
    INNER JOIN RUTAS R
    ON A.MATRICULA = R.MATRICULA
    WHERE UPPER(MARCA) LIKE '%MERCEDES%');
                        
                        
-- 10. (A) 

INSERT INTO AUTOBUSES VALUES ('1234ABC', 'VOLVO', 'C30');
INSERT INTO CONDUCTORES VALUES ('77136854Y', 'PEPE SANCHEZ');
INSERT INTO RUTAS VALUES (10, SYSDATE, 400, '1234ABC', '77136854Y');
INSERT INTO PASA VALUES (10, 'GRANADA', 'GRA');
INSERT INTO PASA VALUES (10, 'JAEN', 'JAE');
INSERT INTO PASA VALUES (10, 'MADRID', 'MAD');
INSERT INTO CIUDADES VALUES ('GRA', 'GRANADA');
INSERT INTO CIUDADES VALUES ('JAE', 'JAEN');
INSERT INTO CIUDADES VALUES ('MAD', 'MADRID');

-- 10. (B) 

DELETE RUTAS 
WHERE IN (SELECT MATRICULA FROM AUTOBUSES WHERE MARCA = 'VOLVO')
AND NIF IN (SELECT NIF FROM CONDUCTORES WHERE CNOMCONDUCTOR = 'PEPE SANCHEZ');


-- NOMBRE DE LOS CONDUCTORES QUE HAN REALIZADO UN TOTAL DE KILOMETROS INFERIOR A LA MEDIA DE LOS KILOMETROS TOTALES REALIZADOS POR LOS CONDUCTORES.

CREATE VIEW VKMT AS
     SELECT NIF, SUM(KMRUTA) AS KM_CONDUCTOR FROM RUTAS 
     GROUP BY NIF

SELECT CNOMCONDUCTOR
FROM VKMT V INNER JOIN CONDUCTORES C
ON V.NIF = C.NIF
WHERE KM_TOTALES < (SELECT AVG(KM_CONDUCTOR) AS MEDIA_TOTAL
                    FROM VKMT);



-- AUTOBUSES QUE NUNCA HAN REALIZADO NINGUNA RUTA CON MAS DE DOS CIUDADES ( DIRECTO )

CREATE VIEW VNR2 AS
    SELECT NUMRUTA 
    FROM PASA 
    GROUP BY NUMRUTA
    HAVING COUNT(DISTINCT CCODCIUDAD) = 2;  -- No necesario puesto que se supone que un bus no pasa dos veces por la misma ciudad.
    
SELECT MATRICULA FROM AUTOBUSES
MINUS 
SELECT MATRICULA FROM RUTAS WHERE NUMRUTA IN (SELECT * FROM VNR2);

-- CONDUCTORES QUE HAN CONDUCIDO TANTO VOLVO COMO MERCEDES

SELECT NIF
FROM RUTAS R INNER JOIN AUTOBUSES A ON A.MATRICULA = R.MATRICULA
WHERE UPPER(MARCA) LIKE '$MERECEDES$'
INTERSECT 
SELECT NIF
FROM RUTAS R INNER JOIN AUTOBUSES A ON A.MATRICULA = R.MATRICULA
WHERE UPPER(MARCA) LIKE '$VOLVO$';

-- CIUDADES POR LAS QUE PASO ALGUNA RUTA EL 1 DE ENERO DEL A�O DEL SERVIDOR

SELECT CCODCIUDAD 
FROM PASA P
INNER JOIN RUTAS ON R.NUMRUTA = P.NUMRUTA
WHERE TO_CHAR(FECHA,'DD/MM') = '01/01'
AND TO_CHAR(FECHA, 'YYYY') = TO_CHAR(SYSDATE, 'YYYY');

-- CUANTOS DIAS HAN PASADO DESDE QUE SE HIZO LA RUTA MAS ANTIGUA

SELECT SYSDATE - MIN(FECHA) FROM FRUTAS;





