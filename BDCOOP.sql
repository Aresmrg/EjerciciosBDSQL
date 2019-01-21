CREATE TABLE Coop (
    cCooCdg varchar2(10) NOT NULL PRIMARY KEY,
    cCooNom varchar2(30) NULL ,
    cCoodir varchar2(30) NULL ,
    nPvpAct number(5, 2) NULL
) ;
CREATE TABLE Entregas (
    nEntNum int NOT NULL PRIMARY KEY,
    cSocCdg varchar2(10) NULL ,
    cParCdg varchar2(10) NULL ,
    dEntFec date DEFAULT sysdate ,
    nEntKgsAceituna number(12, 2) DEFAULT 0,
    nEntKgsAceite number(12, 2) DEFAULT 0
) ;
CREATE TABLE Pagos (
    nPagNum int NOT NULL PRIMARY KEY,
    dPagFec date NULL ,
    cSocCdg varchar2(10) NULL ,
    nPagEur number(10, 2) NULL
) ;
CREATE TABLE Parcelas (
    cParCdg varchar2(10) NOT NULL PRIMARY KEY,
    cSocCdg varchar2(10) NULL ,
    cParSit varchar2(30) NULL ,
    nParOli int NULL ,
    nParPrd number(12, 2) NULL
) ;
CREATE TABLE Pruebas (
    nPrbNum int NOT NULL PRIMARY KEY,
    nEntNum int NULL ,
    dPrbFec date NULL ,
    nEntGrd number(5, 2) NULL
);
CREATE TABLE Socios (
    cSocCdg varchar2(10) NOT NULL PRIMARY KEY,
    cSocNom varchar2(30) NULL ,
    cCooCdg varchar2(10) NOT NULL,
    nSocKgs number(12, 2) DEFAULT 0
) ;

ALTER TABLE SOCIOS ADD CONSTRAINT FK_SOCIOS_COOP FOREIGN KEY (cCooCdg) REFERENCES COOP (cCooCdg);
ALTER TABLE PRUEBAS ADD CONSTRAINT FK_PRUEBAS_ENTREGAS FOREIGN KEY (nEntNum) REFERENCES ENTREGAS (nEntNum);
ALTER TABLE ENTREGAS ADD CONSTRAINT FK_ENTREGAS_SOCIOS FOREIGN KEY (cSocCdg) REFERENCES SOCIOS (cSocCdg);
ALTER TABLE ENTREGAS ADD CONSTRAINT FK_ENTREGAS_PARCELAS FOREIGN KEY (cParCdg) REFERENCES PARCELAS (cParCdg);
ALTER TABLE PAGOS ADD CONSTRAINT FK_PAGOS_SOCIOS FOREIGN KEY (cSocCdg) REFERENCES SOCIOS (cSocCdg);
ALTER TABLE PARCELAS ADD CONSTRAINT FK_PARCELAS_SOCIOS FOREIGN KEY (cSocCdg) REFERENCES SOCIOS (cSocCdg);

ALTER TABLE PARCELAS ADD CONSTRAINT CHK_OLIVOS_PARCELA CHECK (nParOli BETWEEN 100 AND 100000);
ALTER TABLE PAGOS MODIFY dPagFec DEFAULT SYSDATE;
ALTER TABLE PRUEBAS MODIFY dPrbFec DEFAULT SYSDATE;


INSERT INTO COOP VALUES ('1','COOP UNO','CALLE UNO',3);
INSERT INTO COOP VALUES ('2','COOP DOS','CALLE DOS',4);
INSERT INTO COOP VALUES ('3','COOP TRES','CALLE TRES',2);

INSERT INTO SOCIOS VALUES ('1','FERNANDO','1',10000);
INSERT INTO SOCIOS VALUES ('2','MARIO','1',203000);
INSERT INTO SOCIOS VALUES ('3','ROBERTO','2',90300);
INSERT INTO SOCIOS VALUES ('4','SERGIO','2',340000);
INSERT INTO SOCIOS VALUES ('5','ANTONIO','2',8000);
INSERT INTO SOCIOS VALUES ('6','JOSE','2',11134);
INSERT INTO SOCIOS VALUES ('7','RAFA','3',91246);

INSERT INTO PARCELAS VALUES ('1','2','JAEN',4000,30000);
INSERT INTO PARCELAS VALUES ('2','2','CORDOBA',34000,173000);
INSERT INTO PARCELAS VALUES ('3','1','JAEN',1500,10000);
INSERT INTO PARCELAS VALUES ('4','3','SEVILLA',15000,90300);
INSERT INTO PARCELAS VALUES ('5','5','ALMERIA',800,8000);
INSERT INTO PARCELAS VALUES ('6','6','MARRUECOS',2000,11134);
INSERT INTO PARCELAS VALUES ('7','7','CALABRIA',4000,30000);
INSERT INTO PARCELAS VALUES ('8','7','SICILIA',8000,61246);
INSERT INTO PARCELAS VALUES ('9','4','CORDOBA',11000,30000);
INSERT INTO PARCELAS VALUES ('10','4','CORDOBA',21000,110000);
INSERT INTO PARCELAS VALUES ('11','4','CORDOBA',40000,200000);

INSERT INTO PAGOS VALUES (1,'11/11/17','1',10000);
INSERT INTO PAGOS VALUES (2,'22/01/17','2',34000);
INSERT INTO PAGOS VALUES (3,'08/02/17','5',888);
INSERT INTO PAGOS VALUES (4,'01/03/17','5',1325);
INSERT INTO PAGOS VALUES (5,'14/10/17','6',12517);
INSERT INTO PAGOS VALUES (6,'11/12/17','4',12158);
INSERT INTO PAGOS VALUES (7,'06/03/17','3',2430);
INSERT INTO PAGOS VALUES (8,'13/02/17','7',21445);
INSERT INTO PAGOS VALUES (9,'27/10/17','2',15515);
INSERT INTO PAGOS VALUES (10,'30/10/17','3',1423);

INSERT INTO ENTREGAS VALUES (1,'1','3','12/12/17',8000,6500);
INSERT INTO ENTREGAS VALUES (2,'2','1','21/12/17',9000,7500);
INSERT INTO ENTREGAS VALUES (3,'2','2','23/12/17',18000,15500);
INSERT INTO ENTREGAS VALUES (4,'3','4','01/01/17',5000,4500);
INSERT INTO ENTREGAS VALUES (5,'4','9','12/01/17',18000,15000);
INSERT INTO ENTREGAS VALUES (6,'4','10','13/01/17',26000,24000);
INSERT INTO ENTREGAS VALUES (7,'4','11','15/01/17',5000,3000);
INSERT INTO ENTREGAS VALUES (8,'5','5','15/01/17',10000,7500);
INSERT INTO ENTREGAS VALUES (9,'6','6','02/02/17',4000,3000);
INSERT INTO ENTREGAS VALUES (10,'7','7','21/02/17',6500,5400);
INSERT INTO ENTREGAS VALUES (11,'7','8','24/02/17',3000,2000);

INSERT INTO PRUEBAS VALUES (1, 3,'12/12/17', 20);
INSERT INTO PRUEBAS VALUES (2, 1,'21/12/17', 24);
INSERT INTO PRUEBAS VALUES (3, 2,'23/12/17', 21);
INSERT INTO PRUEBAS VALUES (4, 4,'01/01/17', 38);
INSERT INTO PRUEBAS VALUES (5, 9,'12/01/17', 65);
INSERT INTO PRUEBAS VALUES (6, 10,'13/01/17', 13);
INSERT INTO PRUEBAS VALUES (7, 11,'15/01/17', 25);
INSERT INTO PRUEBAS VALUES (8, 5,'15/01/17', 33);
INSERT INTO PRUEBAS VALUES (9, 6,'02/02/17', 8);
INSERT INTO PRUEBAS VALUES (10, 7,'21/02/17', 14);
INSERT INTO PRUEBAS VALUES (11, 8,'24/02/17', 25);

/*
1.  Crear el procedimiento almacenado LISSALDOSOC que pasándole como parámetros dos fechas y el código de un Socio
    nos devuelva como parámetro de salida el saldo actual de ese socio. El saldo actual de un socio se calcula acumulando los
    kilos de aceite entregados entre esas dos fechas (cada entrega debe tener realizada su prueba correspondiente – “son
    kilos de aceite”-) y multiplicándolos por el precio actual del aceite en esa cooperativa y restando a la cantidad anterior los
    pagos realizados a ese cliente entre esas dos fechas.
*/

CREATE OR REPLACE PROCEDURE LISSALDOSOC (xFecIni DATE, xFecFin DATE, xSoc SOCIOS.cSocCDG%TYPE, xSaldo OUT NUMBER)
IS

    xnPvpAct COOP.nPvpAct%TYPE;
    xTotPag NUMBER(12,2);
    xKgsAceite NUMBER(12, 2);

BEGIN

    -- Precio del aceite de la cooperativa del socio.
    SELECT NVL(nPvpAct, 0) INTO xnPvpAct
    FROM COOP t1
    INNER JOIN SOCIOS t2 ON t1.ccoocdg = t2.ccoocdg
    WHERE cSocCdg = xSoc;
    
    -- Pagos realizados a los socios entre las dos fechas
    SELECT SUM(nPagEur) INTO xTotPag
    FROM PAGOS
    WHERE cSocCdg = xSoc AND dPagFec BETWEEN xFecIni AND xFecFin;
    
    -- Kg de aceite entregados por el socio entre las dos fechas
    SELECT SUM(NENTKGSACEITUNA * NENTGRD / 100) INTO xKgsAceite
    FROM ENTREGAS t1
    INNER JOIN PRUEBAS t2 ON t1.NENTNUM = t2.NENTNUM
    WHERE cSocCdg = xSoc AND dEntFec BETWEEN xFecIni AND xFecFin;
    xSaldo := (xnPvpAct * xKgsAceite) - xTotPag;
END;


/* 
2.  Crear el procedimiento almacenado LISSALDO que pasándole como parámetros de entrada dos códigos de socios nos
    muestre el siguiente listado
*/

CREATE OR REPLACE PROCEDURE LISSALDO (xSoc1 SOCIOS.cSocCDG%TYPE, xSoc2 SOCIOS.cSocCDG%TYPER)
IS

    CURSOR cSocios IS SELECT * FROM SOCIOS WHERE cSocCdg BETWEEN xSoc1 AND xSoc2;
    xcSocios cSocios%ROWTYPE;
    xnPvpAct COOP.nPvpAct%TYPE;
    xTotPag NUMBER(12,2);
    xKgsAceite NUMBER(12, 2);

BEGIN

    OPEN cSocios
    LOOP
        FETCH cSocios INTO xcSocios;
        EXIT WHEN cSocios%NOTFOUND;
        -- Precio del aceite de la Cooperativa del Socio
        SELECT NVL(nPvpAct, 0) INTO xnPvpAct FROM COOP t1 INNER JOIN SOCIOS t2 ON t1.ccoocdg = t2.ccoocdg WHERE cSocCdg = xcSocios.cSocCdg;
        
        -- Pagos realizados al Socio entre las dos fechas
        SELECT SUM(NVL(nPagEur,0)) INTO xnPvpAct FROM COOP t1 INNER JOIN SOCIOS t2 ON t1.ccoocdg = t2.ccoocdg WHERE cSocCdg = xcSocios.cSocCdg;
        
         -- Kg de aceite entregados por el socio entre las dos fechas
        SELECT SUM(NENTKGSACEITUNA * NENTGRD / 100) INTO xKgsAceite FROM ENTREGAS t1 INNER JOIN PRUEBAS t2 ON t1.NENTNUM = t2.NENTNUM WHERE cSocCdg = xSoc;
              
        DBMS_OUTPUT.PUT_LINE(xcSocios.cSocCdg || ' - ' || xcSocios.cSocNom || ' - Precio Aceite ' || xnPvpAct.nPvpAct || ' - ' || XTOTLPAG || ' - ' || xKgsAceite.NENTKGSACEITUNA);
    END LOOP;
    CLOSE cSocios

END;

/*3. Crear el procedimiento almacenado IPRODUC que cree una tabla llamada PRODUC que no debe existir en la que se debe 
insertar un registro por cada socio y cada parcela de ese socio con el numero de entregas que se ha hecho de ese socio 
y la fecha de la ultima entrega
    CSocNom 
    CParCdg 
    CParSit 
    NTotEnt (numero total de entregas que se han realizado sobre esa parcela) 
    DUltEnt (con formato Jueves, 11 de diciembre de 2016)*/
    
CREATE OR REPLACE PROCEDURE pIPRODUC 
IS
    xTabla VARCHAR2(300):=NULL;
    xPermisos VARCHAR2(50):=NULL;
    xBorrarTabla VARCHAR2(50):=NULL;
    
    CURSOR cSocios IS
        SELECT CSOCNOM,CPARCDG,CPARSIT
        FROM SOCIOS S INNER JOIN PARCELAS P ON S.CSOCCDG=P.CSOCCDG;
    
    CURSOR cDatosSocios(x PARCELAS.CPARCDG%TYPE) IS
        SELECT COUNT(*) AS NUM_ENTREGAS FROM ENTREGAS WHERE CPARCDG=x GROUP BY CPARCDG;
    
    CURSOR cFechaSocios(x PARCELAS.CPARCDG%TYPE) IS
        SELECT MAX(TO_CHAR(DENTFEC,'DAY') || ',' || TO_CHAR(DENTFEC,'DD') || ' DE ' || TO_CHAR(DENTFEC,'MONTH') || ' DE ' || TO_CHAR(DENTFEC,'YYYY')) AS FECHA
        FROM ENTREGAS WHERE CPARCDG=x;
    
    xcSocios cSocios%ROWTYPE;
    xcDatosSocios cDatosSocios%ROWTYPE;
    xcFechaSocios cFechaSocios%ROWTYPE;
BEGIN
    xBorrarTabla:='DROP TABLE PRODUC';
    xPermisos := 'GRANT CREATE TABLE TO BDCoop';
    xTabla :=
         'CREATE TABLE PRODUC(
            cSocNom VARCHAR2(30),
            cParCdg VARCHAR2(10),
            cParSit VARCHAR2(30),
            NtotEnt NUMBER(5),
            DUltEnt VARCHAR2(50)
        )';
    EXECUTE IMMEDIATE xBorrarTabla;
    EXECUTE IMMEDIATE xPermisos;
    EXECUTE IMMEDIATE xTabla;
    OPEN cSocios;
    LOOP
        FETCH cSocios INTO xcSocios;
        EXIT WHEN cSocios%NOTFOUND;
        OPEN cDatosSocios(xcSocios.CPARCDG);
        LOOP
            FETCH cDatosSocios INTO xcDatosSocios;
            EXIT WHEN cDatosSocios%NOTFOUND;
            OPEN cFechaSocios(xcSocios.CPARCDG);
            LOOP
                FETCH cFechaSocios INTO xcFechaSocios;
                EXIT WHEN cFechaSocios%NOTFOUND;
                INSERT INTO PRODUC VALUES(xcSocios.cSocNom, xcSocios.cParCdg, xcSocios.cParSit, xcDatosSocios.Num_Entregas, xcFechaSocios.FECHA);
            END LOOP;
            CLOSE cFechaSocios;
        END LOOP;
        CLOSE cDatosSocios;
    END LOOP;
    CLOSE cSocios;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error, no hay datos en la tabla');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: DEMASIADOS VALORES DEVUELTOS');
    WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('SE HA PRODUCIDO UN ERROR');
END;

SET SERVEROUTPUT ON;
BEGIN
    pIPRODUC;
END;

select * from PRODUC;    
    
/* 4. Crear el procedimiento almacenado LISCOOP que pasándole como parámetro de entrada un número ‘x’ nos muestre un
      listado de las cooperativas / socios que tienen al menos ‘x’ socios y nos devuelva como parámetro de salida cuantas
      cooperativas aparecen en el listado. El formato del listado será de la forma:
*/

CREATE OR REPLACE PROCEDURE sp_LISCOOP (x NUMBER)
IS

    CURSOR cCoo IS
        SELECT t1.CCOOCDG, cCooNom, COUNT(*) AS nSocios
        FROM COOP t1
        INNER JOIN SOCIOS t2 ON t1.CCOOCDG = t2.CCOOCDG
        GROUP BY t1.cCooCdg, cCooNom
        HAVING COUNT(*) >= x
        ORDER BY t1.CCOOCDG;
    xcCoo cCoo%ROWTYPE;

    CURSOR cSoc (xcc COOP.CCOOCDG%TYPE) IS
        SELECT * FROM SOCIOS WHERE cCooCdg = xcc; -- Parametrizado porque por cada cooperativa, nos enseñará todos los clientes, hay que pasar la cooperativa en la que está
    xcSoc cSoc%ROWTYPE;
    
BEGIN
    DBMS_OUTPUT.PUT_LINE('HOLA');
    OPEN cCoo;
    LOOP
        FETCH cCoo INTO xcCoo;
        EXIT WHEN cCoo%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Cooperativa: ' || xcCoo.cCooCdg || ' - ' || xcCoo.cCooNom || ' - ' || xcCoo.nSocios);
        DBMS_OUTPUT.PUT_LINE('Listado de socios: ');
        
            OPEN cSoc (xcCoo.cCooCdg);
            LOOP
                FETCH cSoc INTO xcSoc;
                EXIT WHEN cSoc%NOTFOUND;
                DBMS_OUTPUT.PUT_LINE('      Socio: ' || xcSoc.cSocCdg || ' - ' || xcSoc.cSOcNom);
            END LOOP;
            CLOSE cSoc; 
    END LOOP;
    CLOSE cCoo;
END;

/* 
   Procedimiento LISTAENTREGAS desde socio1 hasta socio2.
   Mostrar un listado de socios cuyo código esté entre socio1 y socio2.
   Por cada socio del listado, mostrar todas sus entregas
*/

CREATE OR REPLACE PROCEDURE LISTAENTREGAS (xSocio1 NUMBER, xSocio2 NUMBER)
IS

    SELECT * FROM ENTREGAS
    WHERE cSocCdg BETWEEN xSocio1 AND xSocio2;
    
BEGIN
END;

/*
    Crear los Triggers necesarios para que cada vez que se inserte una prueba, se borre una prueba o se modifique el campo
    nEntGrd de un registro de Pruebas se actualicen los campos nEntKgsAceite y nSocKgs. Comprobar que los datos de la
    prueba sean correctos e imprimir un ticket con el siguiente formato:
    
    Nº Entrega...(nEntNum)
    Fecha.............(dEntFec)
    Socio... (cSocCdg) – (cSocNom)
    Kilos Aceituna...........(nEntKgs)
    Grados...................(nPrbGrd)
    Kilos Aceite.............(¿??????)
*/

CREATE OR REPLACE TRIGGER tr_PRUEBAS_Ins
AFTER INSERT 
ON PRUEBAS
FOR EACH ROW
DECLARE
    CURSOR cEntregas IS
        SELECT CSOCCDG,DENTFEC,NENTKGSACEITUNA,NENTKGSACEITE,NENTNUM FROM ENTREGAS WHERE NENTNUM=:NEW.NENTNUM;
    xcCodSoc cEntregas%ROWTYPE;
    xcCantKilos ENTREGAS.NENTKGSACEITE%TYPE;
BEGIN
    SELECT NVL(NENTKGSACEITUNA, 0) * :NEW.NENTGRD AS CANT_KILOS INTO xcCantKilos FROM ENTREGAS WHERE NENTNUM =:NEW.NENTNUM;
    UPDATE ENTREGAS SET NENTKGSACEITE = xcCantKilos WHERE NENTNUM = :NEW.NENTNUM;
    
    OPEN cEntregas;
    LOOP
        FETCH cEntregas INTO xcCodSoc;
        EXIT WHEN cEntregas%NOTFOUND;
        UPDATE SOCIOS SET NSOCKGS=xcCantKilos WHERE CCOOCDG=xcCodSoc.CSOCCDG; 
        DBMS_OUTPUT.PUT_LINE('                                                                        Nº ENTREGA....... ' || xcCodSoc.NENTNUM);
        DBMS_OUTPUT.PUT_LINE('                                                                        FECHA....... ' || xcCodSoc.DENTFEC);
        DBMS_OUTPUT.PUT_LINE('                                                                                                ');
        DBMS_OUTPUT.PUT_LINE('SOCIO.........' || xcCodSoc.CSOCCDG);
        DBMS_OUTPUT.PUT_LINE('KILOS ACEITUNA.........' || xcCodSoc.NENTKGSACEITUNA);
        DBMS_OUTPUT.PUT_LINE('GRADOS.........' || :NEW.NENTGRD);
        DBMS_OUTPUT.PUT_LINE('KILOS ACEITE.........' || xcCodSoc.NENTKGSACEITE);
    END LOOP;
    CLOSE cEntregas;
    
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error, no hay datos en la tabla');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: DEMASIADOS VALORES DEVUELTOS');
    WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('SE HA PRODUCIDO UN ERROR');
END;

CREATE OR REPLACE TRIGGER tr_PRUEBAS_Del
AFTER DELETE 
ON PRUEBAS
FOR EACH ROW    
DECLARE
    CURSOR cEntregas IS
        SELECT CSOCCDG,DENTFEC,NENTKGSACEITUNA,NENTKGSACEITE,NENTNUM FROM ENTREGAS WHERE NENTNUM=:OLD.NENTNUM;
    xcCodSoc cEntregas%ROWTYPE;
    xcCantKilos ENTREGAS.NENTKGSACEITE%TYPE;
BEGIN
    --SELECT NVL(NENTKGSACEITUNA,0)*:NEW.NENTGRD AS CANT_KILOS INTO xcCantKilos FROM ENTREGAS WHERE NENTNUM =:NEW.NENTNUM;
    UPDATE ENTREGAS SET NENTKGSACEITE=0 WHERE NENTNUM =:OLD.NENTNUM;
    OPEN cEntregas;
    LOOP
        FETCH cEntregas INTO xcCodSoc;
        EXIT WHEN cEntregas%NOTFOUND;
        UPDATE SOCIOS SET NSOCKGS=0 WHERE CCOOCDG=xcCodSoc.CSOCCDG; 
        DBMS_OUTPUT.PUT_LINE('                                                                        Nº ENTREGA....... ' || xcCodSoc.NENTNUM);
        DBMS_OUTPUT.PUT_LINE('                                                                        FECHA....... ' || xcCodSoc.DENTFEC);
        DBMS_OUTPUT.PUT_LINE('                                                                                                ');
        DBMS_OUTPUT.PUT_LINE('SOCIO.........' || xcCodSoc.CSOCCDG);
        DBMS_OUTPUT.PUT_LINE('KILOS ACEITUNA.........' || xcCodSoc.NENTKGSACEITUNA);
        DBMS_OUTPUT.PUT_LINE('GRADOS.........' || :OLD.NENTGRD);
        DBMS_OUTPUT.PUT_LINE('KILOS ACEITE.........' || xcCodSoc.NENTKGSACEITE);
    END LOOP;
    CLOSE cEntregas;
    
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error, no hay datos en la tabla');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: DEMASIADOS VALORES DEVUELTOS');
    WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('SE HA PRODUCIDO UN ERROR');
END;

CREATE OR REPLACE TRIGGER tr_PRUEBAS_Upd
AFTER UPDATE 
ON PRUEBAS
FOR EACH ROW    
DECLARE
    CURSOR cEntregas IS
        SELECT CSOCCDG,DENTFEC,NENTKGSACEITUNA,NENTKGSACEITE,NENTNUM FROM ENTREGAS WHERE NENTNUM=:OLD.NENTNUM;
    xcCodSoc cEntregas%ROWTYPE;
    xcCantKilos ENTREGAS.NENTKGSACEITE%TYPE;
BEGIN
    SELECT NVL(NENTKGSACEITUNA,0)*:NEW.NENTGRD AS CANT_KILOS INTO xcCantKilos FROM ENTREGAS WHERE NENTNUM =:NEW.NENTNUM;
    UPDATE ENTREGAS SET NENTKGSACEITE=xcCantKilos WHERE NENTNUM =:OLD.NENTNUM;
    OPEN cEntregas;
    LOOP
        FETCH cEntregas INTO xcCodSoc;
        EXIT WHEN cEntregas%NOTFOUND;
        UPDATE SOCIOS SET NSOCKGS=0 WHERE CCOOCDG=xcCodSoc.CSOCCDG; 
        DBMS_OUTPUT.PUT_LINE('                                                                        Nº ENTREGA....... ' || xcCodSoc.NENTNUM);
        DBMS_OUTPUT.PUT_LINE('                                                                        FECHA....... ' || xcCodSoc.DENTFEC);
        DBMS_OUTPUT.PUT_LINE('                                                                                                ');
        DBMS_OUTPUT.PUT_LINE('SOCIO.........' || xcCodSoc.CSOCCDG);
        DBMS_OUTPUT.PUT_LINE('KILOS ACEITUNA.........' || xcCodSoc.NENTKGSACEITUNA);
        DBMS_OUTPUT.PUT_LINE('GRADOS.........' || :NEW.NENTGRD);
        DBMS_OUTPUT.PUT_LINE('KILOS ACEITE.........' || xcCodSoc.NENTKGSACEITE);
    END LOOP;
    CLOSE cEntregas;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error, no hay datos en la tabla');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: DEMASIADOS VALORES DEVUELTOS');
    WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('SE HA PRODUCIDO UN ERROR');
END;

SET SERVEROUTPUT ON;
BEGIN
    UPDATE PRUEBAS SET NENTGRD=2 WHERE NPRBNUM=11;
END;

/*
    Crear los Triggers necesarios para que no se pueda modificar ningún campo de tipo fecha de ninguna tabla, ni se pueda
    borrar ningún pago con importe distinto de 0.
*/

CREATE OR REPLACE TRIGGER tr_Entrega_Upd
BEFORE UPDATE
ON ENTREGAS
FOR EACH ROW
BEGIN
    IF :OLD.DENTFEC <> :NEW.DENTFEC THEN
        RAISE_APPLICATION_ERROR(-20050,'NO SE PUEDE MODIFICAR LA FECHA DE ENTREGA');
    END IF;
END;

CREATE OR REPLACE TRIGGER tr_Pruebas_Upd2
BEFORE UPDATE
ON PRUEBAS
FOR EACH ROW
BEGIN
    IF :OLD.DPRBFEC <> :NEW.DPRBFEC THEN
        RAISE_APPLICATION_ERROR(-20050,'NO SE PUEDE MODIFICAR LA FECHA DE LA PRUEBA');
    END IF;
END;

CREATE OR REPLACE TRIGGER tr_Pagos_Upd
BEFORE UPDATE
ON PAGOS
FOR EACH ROW
BEGIN
    IF :OLD.DPAGFEC <> :NEW.DPAGFEC THEN
        RAISE_APPLICATION_ERROR(-20050,'NO SE PUEDE MODIFICAR LA FECHA DE PAGO');
    END IF;
END;

CREATE OR REPLACE TRIGGER tr_Pagos_Upd3
BEFORE DELETE
ON PAGOS
FOR EACH ROW
BEGIN
    IF :OLD.NPAGEUR != 0 THEN
        RAISE_APPLICATION_ERROR(-20051,'NO SE PUEDE BORRAR UN PAGO CON VALOR 0');
    END IF;
END;











