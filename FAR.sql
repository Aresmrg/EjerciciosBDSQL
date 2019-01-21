CREATE TABLE MEDICAMENTOS (
    cCodMed varchar2 (13) NOT NULL,
    cDesMed varchar2 (100) NOT NULL,
    nPvpMed number(12, 2) NOT NULL
);
COMMIT;

CREATE TABLE COMPANIAS (
    cCodComp varchar2 (13) NOT NULL,
    cNomComp varchar2 (100) NOT NULL
);
COMMIT;

CREATE TABLE TARIFASCOMP (
    cCodMed varchar2 (13) NOT NULL,
    cCodComp varchar2 (13) NOT NULL,
    nPvpTar number(12, 2) NOT NULL
);
COMMIT;

CREATE TABLE TICKETS (
    nNumTick number(10, 0) NOT NULL ,
    dFecTick date 
);
COMMIT;

CREATE TABLE LINTICKETS (
    nNumTick number(10, 0) NOT NULL ,
    nNumLin number(10, 0) NOT NULL ,
    cCodMed varchar2 (13) NOT NULL,
    nPrecio number(12, 2),
    nCantidad number(12, 3) 
);
COMMIT;

CREATE TABLE RECETAS (
    nNumRec number(10, 0) NOT NULL ,
    nNumTick number(10, 0) NOT NULL ,
    nNumLin number(10, 0) NOT NULL ,
    dFecRec date,
    Paciente varchar2 (100),
    dFecNac date NULL ,
    cCodComp varchar2 (13) 
);
COMMIT;

-- Restricciones

ALTER TABLE Companias ADD CONSTRAINT PK_Companias PRIMARY KEY (cCodComp);
ALTER TABLE Medicamentos ADD CONSTRAINT PK_Medicamentos PRIMARY KEY (cCodMed);
ALTER TABLE TarifasComp ADD CONSTRAINT PK_TarifasComp PRIMARY KEY (cCodMed,cCodComp);
ALTER TABLE Tickets ADD CONSTRAINT PK_Tickets PRIMARY KEY (nNumTick);
ALTER TABLE LinTickets ADD CONSTRAINT PK_LinTickets PRIMARY KEY (nNumTick,nNumLin) ;
ALTER TABLE Recetas ADD CONSTRAINT PK_Recetas PRIMARY KEY (nNumRec);
COMMIT;

-- Agregar datos

INSERT INTO MEDICAMENTOS VALUES ('MED01','MEDICAMENTO UNO', 20);
INSERT INTO MEDICAMENTOS VALUES ('MED02','MEDICAMENTO DOS', 12);
INSERT INTO MEDICAMENTOS VALUES ('MED03','MEDICAMENTO TRES', 14);
INSERT INTO MEDICAMENTOS VALUES ('MED04','MEDICAMENTO CUATRO', 5);
INSERT INTO MEDICAMENTOS VALUES ('MED05','MEDICAMENTO CINCO', 30);
INSERT INTO MEDICAMENTOS VALUES ('MED06','VIAGRA', 24);
COMMIT;

INSERT INTO COMPANIAS VALUES ('COMP01','BAYERN');
INSERT INTO COMPANIAS VALUES ('COMP02','ELLAONE');
INSERT INTO COMPANIAS VALUES ('COMP03','DALSY');
COMMIT;

INSERT INTO TARIFASCOMP VALUES ('MED01','COMP01',20);
INSERT INTO TARIFASCOMP VALUES ('MED02','COMP01',19);
INSERT INTO TARIFASCOMP VALUES ('MED02','COMP02',20);
INSERT INTO TARIFASCOMP VALUES ('MED04','COMP02',6);
INSERT INTO TARIFASCOMP VALUES ('MED04','COMP03',8);
INSERT INTO TARIFASCOMP VALUES ('MED06','COMP03',25);
COMMIT;

INSERT INTO TICKETS VALUES (001, '14/01/2018');
INSERT INTO TICKETS VALUES (002, '15/01/2018');
INSERT INTO TICKETS VALUES (003, '15/01/2018');
INSERT INTO TICKETS VALUES (004, '20/02/2018');
INSERT INTO TICKETS VALUES (005, '21/03/2018');
COMMIT;

INSERT INTO LINTICKETS VALUES (001,01,'MED01', 20, 2);
INSERT INTO LINTICKETS VALUES (001,02,'MED06', 24, 5);
INSERT INTO LINTICKETS VALUES (002,01,'MED02', 20, 1);
INSERT INTO LINTICKETS VALUES (003,01,'MED04', 20, 2);
INSERT INTO LINTICKETS VALUES (003,02,'MED06', 24, 1);
INSERT INTO LINTICKETS VALUES (004,01,'MED01', 20, 1);
INSERT INTO LINTICKETS VALUES (005,01,'MED06', 25, 2);
INSERT INTO LINTICKETS VALUES (005,02,'MED01', 20, 2);
COMMIT;

INSERT INTO RECETAS VALUES (001,001,01, SYSDATE, 'CHEMA ALONSO', NULL, 'COMP01');
INSERT INTO RECETAS VALUES (002,002,01, SYSDATE, 'SERGIO CRUH', NULL, 'COMP01');
INSERT INTO RECETAS VALUES (003,003,01, SYSDATE, 'MARIO', NULL, 'COMP02');
INSERT INTO RECETAS VALUES (004,004,01, SYSDATE, 'JOSE MARIA', NULL, 'COMP01');
INSERT INTO RECETAS VALUES (005,005,01, SYSDATE, 'LOLA', NULL, 'COMP03');
INSERT INTO RECETAS VALUES (006,005,01, '20/05/2018', 'LOLA', NULL, 'COMP03');
INSERT INTO RECETAS VALUES (007,005,02, '20/05/2018', 'LOLA', NULL, 'COMP01');
COMMIT;

--------------------------------------------------------------------------------
----------------------------- PROCEDIMIENTOS -----------------------------------
--------------------------------------------------------------------------------

/*
    1. Procedimiento que pasándole como entrada los parámetros Código compañía,
    fecha inicial y fecha final, nos inserte en la tabla Ventas un registro por 
    cada medicamento recetado por la compañía entre las fechas indicadas en los
    parámetros de entrada con el total de ventas de este medicamento.
*/

CREATE TABLE Ventas (
    cCodComp varchar2 (13) ,
    cCodMed varchar2 (13),
    nTotVen number (10)
);

ALTER TABLE VENTAS ADD CONSTRAINT PK_VENTAS PRIMARY KEY (cCodComp, cCodMed);

CREATE OR REPLACE PROCEDURE sp_INSVENTAS (xcCodComp COMPANIAS.cCodComp%TYPE, xdFecIni DATE, xdFecFin DATE)
IS

    CURSOR cMed IS
        
        SELECT CCODMED, CCODCOMP, COUNT(*) AS TotalVentas FROM LINTICKETS L INNER JOIN RECETAS R ON
        L.NNUMTICK = R.NNUMTICK WHERE DFECREC BETWEEN xdFecIni AND xdFecFin
        AND CCODCOMP = xcCodComp
        GROUP BY CCODCOMP, CCODMED;
        
    xcMed cMed%ROWTYPE;
    xventas NUMBER;

BEGIN

    OPEN cMed;
        LOOP
            FETCH cMed INTO xcMed;
            EXIT WHEN cMed%NOTFOUND;
            INSERT INTO VENTAS VALUES(xcMed.CCODCOMP, xcMed.CCODMED, xcMed.TotalVentas);
        END LOOP;
    CLOSE cMed;
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('ERROR NO HAY DATOS');
        WHEN TOO_MANY_ROWS THEN
            DBMS_OUTPUT.PUT_LINE('ERROR DEMASIADOS DATOS');
END;

SET SERVEROUTPUT ON;
DECLARE
BEGIN

    sp_INSVENTAS('COMP01', '19/05/2018', '21/05/2018');

END;

/*
    2. Procedimiento que pasándole como parámetro de entrada el número de ticket lo imprima con el siguiente formato y
    devuelva como parámetro de salida el total del ticket.
    
                                                                                                    TICKET Nº… nNumTick
                                                                                                    FECHA…….. dFecTick
Línea       Referencia      Descripción         Unidades        Precio      Subtotal
nNumLin     cCodMed         cDesMed             nCantidad       nPrecio     nCantidad*nPrecio
Paciente                    cNomComp ( Esta línea se imprime si está asociada a RECETA )

nNumLin     cCodMed         cDesMed             nCantidad       nPrecio     nCantidad*nPrecio
Paciente    cNomComp ( Esta línea se imprime si está asociada a RECETA )
…………………………………
                                                                            TOTAL A PAGAR ……. ??????????????
*/

CREATE OR REPLACE PROCEDURE sp_LISTICKET (xnNumTick TICKETS.nNumTick%TYPE, xTOTAL OUT NUMBER)
IS

    CURSOR cTICKET(X TICKETS.nNumTick%TYPE) IS 
    SELECT L.*,T.DFECTICK,M.CDESMED FROM TICKETS T
    INNER JOIN LINTICKETS L ON T.nNumTick = L.nNumTick
    INNER JOIN MEDICAMENTOS M ON L.cCodMed = M.cCodMed
    WHERE T.nNumTick = X;
    regTICKET cTICKET%ROWTYPE;
    
    CURSOR cRECETAS(Y RECETAS.nNumTick%TYPE) IS
    SELECT R.PACIENTE,C.CNOMCOMP FROM RECETAS R 
    INNER JOIN COMPANIAS C ON R.cCodComp = C.cCodComp
    WHERE nNumTick = Y;
    regRECETAS cRECETAS%ROWTYPE;

    xTICKET TICKETS%ROWTYPE;
BEGIN
    SELECT * INTO xTICKET FROM TICKETS WHERE nNumTick = xnNumTick;
    DBMS_OUTPUT.PUT_LINE('TICKET Nº   ' || xTICKET.nNumTick);
    DBMS_OUTPUT.PUT_LINE('FECHA   ' || xTICKET.dFecTick);
    
    OPEN cTICKET(xnNumTick);
    LOOP
    
        FETCH cTICKET INTO regTICKET;
        EXIT WHEN cTICKET%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Línea     Referencia      Descripción     Unidades        Precio      Subtotal');
        DBMS_OUTPUT.PUT_LINE('------------------------------------------------------------------------------');
        DBMS_OUTPUT.PUT_LINE(regTICKET.nNumLin || '         ' || regTICKET.cCodMed ||  '           ' || regTICKET.cDesMed ||  '            ' || regTICKET.nCantidad ||  '            ' || regTICKET.nPrecio ||  '            ' || (regTICKET.nCantidad*regTICKET.nPrecio));
        
        OPEN cRECETAS(regTICKET.nNumTick);
        LOOP
            FETCH cRECETAS INTO regRECETAS;
            EXIT WHEN cRECETAS%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(regRECETAS.Paciente ||  '      ' || regRECETAS.cNomComp);
            xTotal := xTotal + (regTICKET.nCantidad*regTICKET.nPrecio);
        END LOOP;
        CLOSE cRECETAS;
        
    END LOOP;
    CLOSE cTICKET;
    
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('ERROR NO HAY DATOS');
    WHEN TOO_MANY_ROWS THEN
         DBMS_OUTPUT.PUT_LINE('ERROR DEMASIADOS DATOS');
         
END;

SET SERVEROUTPUT ON;
DECLARE
xTOT NUMBER;
BEGIN
    sp_LISTICKET(001, xTOT);
    DBMS_OUTPUT.PUT_LINE('TOTAL: ' || xTOT);
END;



/* 
  1. Cuando se añada una receta asociada a una línea de ticket o se modifique la compañía de la receta (solo este campo)
     el precio de la línea de ticket (nPrecio) asociada a la receta se debe actualizar de forma automática con la tarifa asociada a ese
     medicamento para la compañía indicada en la receta.
*/

CREATE OR REPLACE TRIGGER far_REC_tr
AFTER INSERT OR UPDATE OF CCODCOMP
ON RECETAS
FOR EACH ROW
DECLARE
    xasoc NUMBER;
BEGIN
    
    SELECT COUNT(*) INTO xAsoc FROM LINTICKETS WHERE NNUMLIN = :NEW.NNUMLIN;
    
    IF xasoc = 1 THEN
        UPDATE LINTICKETS SET NPRECIO = (SELECT NPVPTAR FROM TARIFASCOMP
        WHERE CCODCOMP = :NEW.CCODCOMP) WHERE NNUMLIN = :NEW.NNUMLIN;
    ELSIF UPDATING THEN
        UPDATE LINTICKETS SET NPRECIO = (SELECT NPVPTAR FROM TARIFASCOMP
        WHERE CCODCOMP = :OLD.CCODCOMP) WHERE NNUMLIN = :NEW.NNUMLIN;
    ELSE
        RAISE_APPLICATION_ERROR(-20001,'Ha habido un error.');
    END IF;     
    
END;

/*
    Si se elimina una receta se actualiza el precio de la línea de ticket (nPrecio) asociada a dicha receta con el precio
    genérico (nPvpMed) para ese medicamento.
*/

CREATE OR REPLACE TRIGGER del_REC_tr
AFTER DELETE
ON RECETAS
FOR EACH ROW
DECLARE
    xPvpMed NUMBER;
BEGIN
    
    SELECT NPVPMED INTO xPvpMed FROM MEDICAMENTOS WHERE CCODMED = :OLD.CCODMED;
    
    UPDATE LINTICKETS SET nPrecio = xPvpMed WHERE CCODMED = :OLD.CCODMED AND NNUMTICK = :OLD.NNUMTICK;
    
    RAISE_APPLICATION_ERROR(-20001,'Ha habido un error.');
    
END;





