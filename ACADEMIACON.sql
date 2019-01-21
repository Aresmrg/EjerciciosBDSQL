CREATE TABLE Alumnos (
    cCodAlu VARCHAR2(13) PRIMARY KEY,
    cNomAlu VARCHAR2(100),
    dFecNac DATE,
    Localidad VARCHAR2(50),
    nTestAprobados NUMBER(10, 0) DEFAULT 0,
    nPractAprobadas NUMBER(10, 0) DEFAULT 0
);

CREATE TABLE Practicos (
    cCodAlu VARCHAR2(13) NOT NULL ,
    FechaPract DATE NOT NULL ,
    Matricula VARCHAR (10),
    nFallosGraves NUMBER(10, 0) DEFAULT 0,
    nFallosLeves NUMBER(10, 0) DEFAULT 0,
    
    CONSTRAINT PK_e_Practicos PRIMARY KEY (cCodAlu,FechaPract)
);

CREATE TABLE Teoricos (
    cCodAlu VARCHAR2(13) NOT NULL,
    nNumTest NUMBER(10, 0) NOT NULL,
    FechaTest DATE NOT NULL,
    nAciertos NUMBER(10, 0) DEFAULT 0,
    nFallos NUMBER(10, 0) DEFAULT 0,
    
    CONSTRAINT PK_e_Teoricos PRIMARY KEY (cCodAlu,nNumTest,FechaTest)
);

CREATE TABLE Test (
    nNumTest NUMBER(10, 0) NOT NULL ,
    Tema VARCHAR2(100) NOT NULL ,
    nPreguntas NUMBER(10, 0) DEFAULT 0,
    
    CONSTRAINT PK_e_Test PRIMARY KEY (nNumTest)
);

------------------------------- RESTRICCIONES ----------------------------------

ALTER TABLE PRACTICOS ADD CONSTRAINT FK_PRACTICOS_ALUM FOREIGN KEY (cCodAlu) REFERENCES ALUMNOS (cCodAlu);
ALTER TABLE TEORICOS ADD CONSTRAINT FK_TEORICOS_ALUM FOREIGN KEY (cCodAlu) REFERENCES ALUMNOS (cCodAlu);
ALTER TABLE TEORICOS ADD CONSTRAINT FK_TEORICOS_TEST FOREIGN KEY (nNumTest) REFERENCES TEST (nNumTest);

ALTER TABLE TEORICOS MODIFY FECHATEST DEFAULT SYSDATE;
ALTER TABLE PRACTICOS MODIFY FECHAPRACT DEFAULT SYSDATE;

ALTER TABLE PRACTICOS ADD nFallos NUMBER (10, 0);
ALTER TABLE PRACTICOS ADD CONSTRAINT SUMA_FALLOS CHECK (nFallosGraves + nFallosLeves < nFallos);

ALTER TABLE TEORICOS ADD AprobadoSN VARCHAR2(1);

ALTER TABLE TEORICOS MODIFY AprobadoSN DEFAULT 'N';
ALTER TABLE TEORICOS ADD CONSTRAINT APROBADOSN CHECK (APROBADOSN = 'S' OR APROBADOSN = 'N');

--------------------------- INTRODUCIMOS VALORES -------------------------------

INSERT INTO ALUMNOS VALUES ('A01', 'PABLO RODRIGUEZ', '29/09/2006', 'LOJA', 10, 10);
INSERT INTO ALUMNOS VALUES ('A02', 'ARMANDO MUÑOZ', '30/04/1998', 'GRANADA', 2, 1);
INSERT INTO ALUMNOS VALUES ('A03', 'RICKY BERWICK', '06/01/2000', 'VALLADOLID', 5, 6);
INSERT INTO ALUMNOS VALUES ('A04', 'VIN DIESEL', '20/02/1997', 'CUENCA', 8, 2);
INSERT INTO ALUMNOS VALUES ('A05', 'FORREST GUMP', '11/04/1997', 'GIRONA', 4, 5);
INSERT INTO ALUMNOS VALUES ('A06', 'DOMINIC TORETTO', '08/02/1999', 'GRANADA', 1, 1);
INSERT INTO ALUMNOS VALUES ('A07', 'ESTANISLAO RODRIGUEZ', '31/01/1990', 'MALAGA', 0, 3);
INSERT INTO ALUMNOS VALUES ('A08', 'JOSE MANUEL ARANDA', '8/02/2000', 'MADRID', 8, 9);
INSERT INTO ALUMNOS VALUES ('A09', 'JUAN ANTONIO CASTILLO', '22/11/1995', 'BARCELONA', 1, 4);
INSERT INTO ALUMNOS VALUES ('A10', 'PABLO CARMONA', '23/09/1992', 'VALENCIA', 5, 8);
INSERT INTO ALUMNOS VALUES ('A11', 'JOSE MARIA GARCIA', '01/02/1993', 'PALENCIA', 1, 4);
COMMIT;

INSERT INTO TEST VALUES (1, 'SEÑALES DE TRAFICO', 100);
INSERT INTO TEST VALUES (2, 'VELOCIDADES', 30);
INSERT INTO TEST VALUES (3, 'PEATONES', 40);
INSERT INTO TEST VALUES (4, 'PARTES DEL COCHE', 60);
INSERT INTO TEST VALUES (5, 'LUCES', 50);
INSERT INTO TEST VALUES (6, 'PRIMEROS AUXILIOS', 10);
INSERT INTO TEST VALUES (7, 'NEUMATICOS', 90);
INSERT INTO TEST VALUES (8, 'TIPOS DE VEHICULO', 10);
INSERT INTO TEST VALUES (9, 'SEGURIDAD VIAL', 50);
INSERT INTO TEST VALUES (10, 'MECANICA', 200);
COMMIT;

INSERT INTO TEORICOS VALUES ('A01', 1, SYSDATE, 90, 10);
INSERT INTO TEORICOS VALUES ('A01', 2, SYSDATE, 25, 5);
INSERT INTO TEORICOS VALUES ('A02', 10, SYSDATE, 100, 100);
INSERT INTO TEORICOS VALUES ('A03', 9, SYSDATE, 25, 5);
INSERT INTO TEORICOS VALUES ('A04', 4, SYSDATE, 10, 50);
INSERT INTO TEORICOS VALUES ('A06', 1, SYSDATE, 10, 90);
INSERT INTO TEORICOS VALUES ('A06', 2, SYSDATE, 15, 15);
INSERT INTO TEORICOS VALUES ('A06', 5, SYSDATE, 40, 10);
INSERT INTO TEORICOS VALUES ('A05', 5, SYSDATE, 10, 5);
INSERT INTO TEORICOS VALUES ('A11', 8, SYSDATE, 10, 0);
INSERT INTO TEORICOS VALUES ('A10', 1, SYSDATE, 0, 0);
COMMIT;

INSERT INTO PRACTICOS VALUES ('A01', SYSDATE, '3929FET', 0, 0);
INSERT INTO PRACTICOS VALUES ('A02', SYSDATE, '7854GHJ', 5, 4);
INSERT INTO PRACTICOS VALUES ('A03', SYSDATE, '5274KLO', 8, 1);
INSERT INTO PRACTICOS VALUES ('A04', SYSDATE, '0000JCP', 1, 4);
INSERT INTO PRACTICOS VALUES ('A05', SYSDATE, '1028ERC', 0, 2);
INSERT INTO PRACTICOS VALUES ('A06', SYSDATE, '7878WRC', 5, 1);
INSERT INTO PRACTICOS VALUES ('A08', SYSDATE, '6389HTY', 2, 2);
INSERT INTO PRACTICOS VALUES ('A09', SYSDATE, '4826ÑQA', 8, 0);
INSERT INTO PRACTICOS VALUES ('A10', SYSDATE, '8725OIU', 0, 6);
COMMIT;

------------------------------- EJERCICIOS -------------------------------------

/* Realizar las siguientes consultas:
    a. Alumnos que han realizado practicas en coches que no han sido utilizados para las prácticas los alumnos de
       GRANADA.
    b. Alumnos que solo han realizado test con más de 40 preguntas.
    c. Listado con los diferentes Temas de los test y número de realizaciones de los anteriores en cada mes de cada
       año; con el siguiente formato :
    
       Tema Año Mes Nº Realizados
    
    d. Nombre, fecha nacimiento y localidad de los alumnos que han realizado todos los Test del Tema SEGURIDAD. 
*/

-- a)

SELECT A.CCODALU, MATRICULA FROM ALUMNOS A
INNER JOIN PRACTICOS P
ON A.CCODALU = P.CCODALU
WHERE A.CCODALU NOT IN (SELECT CCODALU, MATRICULA FROM PRACTICOS)
AND A.LOCALIDAD != 'GRANADA';

-- b)

SELECT A.* FROM ALUMNOS A
INNER JOIN TEORICOS T1 ON A.CCODALU = T1.CCODALU
INNER JOIN TEST T2 ON T1.NNUMTEST = T2.NNUMTEST
WHERE NPREGUNTAS > 40;

-- c)

SELECT TEMA, TO_CHAR(FECHATEST, 'YYYY') AS ANIO, TO_CHAR(FECHATEST, 'MM') AS MES, COUNT(*) AS NTESTS_POR_TEMA FROM TEST T
INNER JOIN TEORICOS T1 ON T.NNUMTEST = T1.NNUMTEST
GROUP BY TEMA, TO_CHAR(FECHATEST, 'YYYY'), TO_CHAR(FECHATEST, 'MM');

-- d)

SELECT CNOMALU, DFECNAC, LOCALIDAD FROM ALUMNOS A
INNER JOIN TEORICOS T ON A.CCODALU = T.CCODALU
WHERE NNUMTEST = (SELECT T.NNUMTEST FROM TEORICOS T INNER JOIN
                  TEST T1 ON T.NNUMTEST = T1.NNUMTEST 
                  WHERE TEMA LIKE '%SEGURIDAD%');


/* Realizar el procedimiento almacenado sp_Listado_Teoricos que pasándole como parámetro de entrada el código de un
alumno, nos muestre su nombre, fecha nacimiento y localidad, nos liste todos sus teóricos indicando para cada uno de
ellos tema, fecha realización, número de aciertos, número de fallos y si está aprobado o no y nos devuelva como parámetro
de salida el número de teóricos aprobados que tiene ( tened en cuenta que el valor del campo nTestAprobados de la tabla
Alumnos puede no estar actualizado ) */


CREATE OR REPLACE PROCEDURE sp_LISTADO_TEORICOS (xcCodAlu ALUMNOS.cCodAlu%TYPE, xAPROBADOS OUT NUMBER)
IS

    CURSOR cTEST IS 
        SELECT T.*,T1.TEMA,T1.NPREGUNTAS FROM TEORICOS T 
        INNER JOIN TEST t1 ON t.nNumTest = t1.nNumTest
        WHERE cCodALu = xcCodAlu;
    xcTEST cTEST%ROWTYPE;
    xTEXTOAPRO VARCHAR2(1);

    NR NUMBER;
    xALUMNO ALUMNOS%ROWTYPE;
    
BEGIN

    xAPROBADOS := 0;
    -- COMPROBAR QUE EXISTE EL ALUMNO
    SELECT COUNT(*) INTO NR FROM ALUMNOS WHERE cCodAlu = xcCodAlu;
    IF (NR != 1) THEN
        RAISE_APPLICATION_ERROR(-20001, 'NO EXISTE EL ALUMNO CON DICHO CODIGO');
    END IF;
    
    SELECT * INTO xALUMNO FROM ALUMNOS WHERE cCodAlu = xcCodAlu;
    DBMS_OUTPUT.PUT_LINE('CODIGO: ' || xALUMNO.cCodAlu || 'NOMBRE: ' || xALUMNO.cNomAlu || 'FEC.NAC: ' || xALUMNO.dFecNac || 'LOCALIDAD: ' || xALUMNO.LOCALIDAD);
    OPEN cTEST;
        LOOP
            FETCH cTEST INTO xcTEST;
            EXIT WHEN cTEST%NOTFOUND;
            xTEXTOAPRO := 'N';
            
            IF (xcTEST.nPREGUNTAS <= 40 AND xcTEST.nFALLOS < 4) THEN
                xAPROBADOS := xAPROBADOS + 1;
                xTEXTOAPRO := 'S';
            END IF;
            
            IF (xcTEST.nPREGUNTAS <= 40 AND xcTEST.nFALLOS <= 5) THEN
                xAPROBADOS := xAPROBADOS + 1;
                xTEXTOAPRO := 'S';
            END IF;
            
            DBMS_OUTPUT.PUT_LINE('TEMA ' || xcTEST.TEMA || '  FECHA ' ||xcTEST.FECHATEST || '  ACIERTOS  ' || xcTEST.nACIERTOS || '  FALLOS  ' || xcTEST.nFALLOS || '  PREGUNTAS  ' || xcTEST.nPREGUNTAS || ' RESULTADO ' || xTEXTOAPRO);

        END LOOP;
    CLOSE cTEST;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('NO HAY DATOS');
END;


SET SERVEROUTPUT ON;
DECLARE
    xApro NUMBER;
BEGIN
    sp_LISTADO_TEORICOS ('123',xApro);
    DBMS_OUTPUT.PUT_LINE('EL ALUMNO 123 HA APROBADO ' || xApro || ' TESTS.');
END;

/* Realizar los siguientes Triggers :
    a. Trigger que cada vez que se inserten registros en la tabla Teóricos, actualice la tabla Alumnos.
    b. Trigger que cada vez que se modifiquen registros en la tabla Prácticos, actualice la tabla Alumnos. (Hay que tener
       en cuenta los valores anteriores a la modificación).
*/

-- a)

CREATE OR REPLACE TRIGGER tr_TEORICOS_Ins
AFTER 
INSERT
ON TEORICOS
FOR EACH ROW
DECLARE 
    xnNumeroPreg NUMBER(10,0); 
BEGIN
    SELECT nPreguntas INTO xnNumeroPreg FROM TEST WHERE nNumTest = :NEW.nNumTest;
    
    -- Para aprobados:
    IF ( xnNumeroPreg <= 40 AND :NEW.nFallos < 4 ) THEN
        UPDATE ALUMNOS SET nTestAprobados = NVL(nTestAprobados, 0) + 1 WHERE cCodAlu = :new.cCodAlu;
    END IF;
    IF ( xnNumeroPreg > 40 AND :NEW.nFallos <= 5 ) THEN
        UPDATE ALUMNOS SET nTestAprobados = NVL(nTestAprobados, 0) + 1 WHERE cCodAlu = :new.cCodAlu;
    END IF;
    
    -- Para suspenso:
    IF ( xnNumeroPreg <= 40 AND :NEW.nFallos > 4 ) THEN
        RAISE_APPLICATION_ERROR(-20001, 'SUSPENSO');
    END IF;
    IF ( xnNumeroPreg > 40 AND :NEW.nFallos >= 5 ) THEN
        RAISE_APPLICATION_ERROR(-20001, 'SUSPENSO');
    END IF;
END;

-- b)

CREATE OR REPLACE TRIGGER tr_PRACTICOS_Ins
AFTER 
UPDATE
ON PRACTICOS
FOR EACH ROW
DECLARE 
BEGIN
    IF (( :NEW.nNumeroFallosLeves < 3 AND  :OLD.NFALLOSLEVES > 3) AND (:NEW.nFallosGraves = 0 AND :OLD.nFallosGraves > 0))THEN
        -- Estaba suspenso y aprueba
        xApro := 1;
    END IF;
    IF ( :NEW.nNumeroFallosLeves >3 AND :OLD.nNumeroFallosLeves <=3 ) THEN
        -- Estaba aprobado y suspende
        xApro := -1;
    END IF;
    IF ( xApro <> 0 ) THEN
        UPDATE ALUMNOS SET nPractAprobadas = NVL(nPractAprobadas, 0) + xApro
        WHERE cCodAlu = :NEW.cCodAlu
    END IF;    
END;















