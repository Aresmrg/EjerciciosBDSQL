CREATE TABLE EMPLEADOS (
    cDNIEmpl VARCHAR2(9) PRIMARY KEY, -- DNI del empleado
    cNomEmpl VARCHAR2(100) NOT NULL, -- Nombre del Empleado
    nSueldoB NUMBER(10,2) -- Sueldo Base del Empleado
);

CREATE TABLE CATEGORIAS (
    cCodCat VARCHAR2(1) PRIMARY KEY,    -- Codigo Categoria
    cDesCat VARCHAR2(100) NOT NULL,     -- Descripcion de la Categoria
    nPorcBeneficio NUMBER(10,2)
                                        -- Porcentaje Beneficio para el Empleado que realice un contrato de alquiler de un piso de
                                        -- esta categoria
);

CREATE TABLE PISOS (
    cRefPiso VARCHAR2(10) PRIMARY KEY,  -- Referencia del piso
    cCodCat VARCHAR2(1) NOT NULL,       -- Categoria a la que pertenece
    cDirPiso VARCHAR2(100) NOT NULL,    -- Direccion del piso
    nPrecioMensual NUMBER(10,2),        -- Precio Mensual del Alquiler
    dFecDisponible DATE                 -- Fecha a partir de la cual el piso esta disponible para alquilar
);

CREATE TABLE CONTRATOS (
    nNumContr NUMBER(10) PRIMARY KEY,       -- Numero de Contrato
    dFecContr DATE,                         -- Fecha del contrato
    cRefPiso VARCHAR2(10) NOT NULL,         -- Referencia del piso que se contrata
    cDNIEmpl VARCHAR2(9) NOT NULL,          -- DNI del empleado que hace el contrato de alquiler
    cNomEstudiante VARCHAR2(100) NOT NULL,  -- Nombre del Estudiante que hace el contrato
    dFecIni DATE,                           -- Fecha de Inicio del contrato
    dFecFin DATE                            -- Fecha de Finalización del contrato
);

CREATE TABLE NOMINAS (
    cDNIEmpl VARCHAR2(9) NOT NULL,      -- DNI del empleado
    cNomEmpl VARCHAR2(100) NOT NULL,    -- Nombre del Empleado
    nAnio NUMBER(4),                    -- Año de la Nomina
    nMes NUMBER(2),                     -- Mes de la Nomina
    nSueldoB NUMBER(10,2),              -- Sueldo Base del Empleado
    nBeneficioM NUMBER(10,2)
    -- Beneficio obtenido en el Año/Mes de la Nomina por el empleado a partir de los contratos
    -- firmados en ese Año/Mes
);

INSERT INTO EMPLEADOS VALUES ('12345678A','GARCIA GARCIA, MANUEL',900);
INSERT INTO CATEGORIAS VALUES ('C','PISO 3 DORMITORIOS',5);
INSERT INTO PISOS VALUES ('258-C','C','AVDA. CONSTITUCION,123,2-F',600,'30/06/2018');
INSERT INTO CONTRATOS VALUES (1001, '23/05/2018', '258-C', '12345678A', 'MIGUEL GONZALEZ',
'15/07/2018','30/09/2018');


/*
    1. Crear un trigger que cada vez que se inserte un CONTRATO DE ALQUILER se actualice la tabla de NOMINAS,
       con el siguiente funcionamiento:
       
       se genera un nuevo registro con el DNI y nombre del empleado, mes y año de la nómina, sueldo base y beneficio obtenido por el alquiler que se va a dar de alta.
*/

create or replace TRIGGER tr_CONT_NOM_up
AFTER INSERT
ON CONTRATOS
FOR EACH ROW
DECLARE
    
    CURSOR cNominas IS
        SELECT * FROM NOMINAS N INNER JOIN CONTRATOS C ON N.CDNIEMPL = C.CDNIEMPL;  

    xcNominas cNominas%ROWTYPE;
    xnPrecioMensual PISOS.nPrecioMensual%TYPE;
    xNPORCBENEFICIO CATEGORIAS.NPORCBENEFICIO%TYPE;
    xcNomEMpl EMPLEADOS.cNomEMpl%TYPE;
    xnSueldoB EMPLEADOS.nSueldoB%TYPE;
    xcFecDisponible PISOS.dFecDisponible%TYPE;
    xcDniEmpl EMPLEADOS.CDNIEMPL%TYPE;

BEGIN

    SELECT dFecDisponible INTO xcFecDisponible FROM PISOS P INNER JOIN CONTRATOS C ON P.CREFPISO = C.CREFPISO WHERE :OLD.CREFPISO = :NEW.CREFPISO;
    SELECT nPrecioMensual INTO XnPrecioMensual FROM PISOS WHERE CREFPISO = :NEW.CREFPISO;
    SELECT NPORCBENEFICIO INTO XNPORCBENEFICIO FROM PISOS P INNER JOIN CATEGORIAS C ON P.CCODCAT = C.CCODCAT WHERE CREFPISO = :NEW.CREFPISO;
    SELECT cNomEMpl INTO xcNomEMpl FROM EMPLEADOS WHERE :NEW.CDNIEMPL = :OLD.CDNIEMPL;
    SELECT nSueldoB INTO xnSueldoB FROM EMPLEADOS WHERE :NEW.CDNIEMPL = :OLD.CDNIEMPL;

    IF (:NEW.dFecIni < xcFecDisponible) THEN
        RAISE_APPLICATION_ERROR(-2001,'No se puede insertar un contrato con esta fecha, esta ocupado');
    END IF;

    SELECT COUNT(*) INTO xcDniEmpl FROM EMPLEADOS WHERE CDNIEMPL = :NEW.CDNIEMPL;

    OPEN cNominas;
    LOOP 
        FETCH cNominas INTO xcNominas;
        EXIT WHEN cNominas%NOTFOUND;
        IF ( xcDniEmpl = 1) THEN
            IF( :NEW.dFecIni > xcFecDisponible ) THEN
                UPDATE NOMINAS SET nBeneficioM = nBeneficioM + ((TO_CHAR(:NEW.DFECFIN, 'MM') - TO_CHAR(:NEW.DFECINI, 'MM')) * xnPrecioMensual * XNPORCBENEFICIO) WHERE CDNIEMPL = :NEW.CDNIEMPL;
            END IF;
        END IF;

        IF ( xcDniEmpl != 1) THEN
           INSERT INTO NOMINAS VALUES (:NEW.CDNIEMPL, xcNomEmpl, TO_CHAR(:NEW.DFECCONTR, 'YYYY'), TO_CHAR(:NEW.DFECCONTR, 'MM'), xnSueldoB, (TO_CHAR(:NEW.DFECFIN, 'MM') - TO_CHAR(:NEW.DFECINI, 'MM')) * xnPrecioMensual * XNPORCBENEFICIO);
       END IF;
    END LOOP;
    CLOSE cNominas;
END;

/*
    2. Crear un trigger que cada vez que se borre un CONTRATO DE ALQUILER se actualice la tabla de NOMINAS,
    siguiendo el funcionamiento del apartado anterior, pero decrementando el beneficio obtenido por el empleado
    que realizó el contrato de alquiler. Si el beneficio por alquilar del empleado que realizó el contrato quedara a 0,
    se debe borrar este registro de NOMINAS.
*/

create or replace TRIGGER tr_CONT_NOM_del
BEFORE DELETE
ON CONTRATOS
FOR EACH ROW
DECLARE
    
    CURSOR cNominas IS
        SELECT * FROM NOMINAS N INNER JOIN CONTRATOS C ON N.CDNIEMPL = C.CDNIEMPL;  

    xcNominas cNominas%ROWTYPE;
    xnPrecioMensual PISOS.nPrecioMensual%TYPE;
    xNPORCBENEFICIO CATEGORIAS.NPORCBENEFICIO%TYPE;
    xcNomEMpl EMPLEADOS.cNomEMpl%TYPE;
    xnSueldoB EMPLEADOS.nSueldoB%TYPE;
    xcFecDisponible PISOS.dFecDisponible%TYPE;
    xcDniEmpl EMPLEADOS.CDNIEMPL%TYPE;

BEGIN

    SELECT dFecDisponible INTO xcFecDisponible FROM PISOS P INNER JOIN CONTRATOS C ON P.CREFPISO = C.CREFPISO WHERE P.CREFPISO = :OLD.CREFPISO;
    SELECT nPrecioMensual INTO XnPrecioMensual FROM PISOS WHERE CREFPISO = :OLD.CREFPISO;
    SELECT NPORCBENEFICIO INTO XNPORCBENEFICIO FROM PISOS P INNER JOIN CATEGORIAS C ON P.CCODCAT = C.CCODCAT WHERE CREFPISO = :OLD.CREFPISO;
    SELECT cNomEMpl INTO xcNomEMpl FROM EMPLEADOS WHERE CDNIEMPL = :OLD.CDNIEMPL;
    SELECT nSueldoB INTO xnSueldoB FROM EMPLEADOS WHERE CDNIEMPL = :OLD.CDNIEMPL;

    IF (:OLD.dFecIni < xcFecDisponible) THEN
        RAISE_APPLICATION_ERROR(-2001,'No se puede insertar un contrato con esta fecha, esta ocupado');
    END IF;

    SELECT COUNT(*) INTO xcDniEmpl FROM EMPLEADOS WHERE CDNIEMPL = :OLD.CDNIEMPL;

    OPEN cNominas;
    LOOP 
        FETCH cNominas INTO xcNominas;
        EXIT WHEN cNominas%NOTFOUND;
        IF ( xcDniEmpl = 1) THEN
            IF( :NEW.dFecIni > xcFecDisponible ) THEN
                UPDATE NOMINAS SET nBeneficioM = nBeneficioM - ((TO_CHAR(:OLD.DFECFIN, 'MM') - TO_CHAR(:OLD.DFECINI, 'MM')) * xnPrecioMensual * XNPORCBENEFICIO) WHERE CDNIEMPL = :OLD.CDNIEMPL;
                DELETE NOMINAS WHERE nBeneficioM <= 0 AND CDNIEMPL = :OLD.CDNIEMPL;
            END IF;
        END IF;
    END LOOP;
    CLOSE cNominas;
END;


/*
    3. Crear un trigger para que no se pueda modificar la fecha de un CONTRATO DE ALQUILER.
*/

CREATE OR REPLACE TRIGGER tr_CONTRATO_res
AFTER UPDATE ON 
CONTRATOS
FOR EACH ROW
BEGIN
    
    IF (:OLD.DFECINI != :NEW.DFECINI) THEN
        RAISE_APPLICATION_ERROR(-20030,'NO SE PUEDE MODIFICAR LA FECHA DE INICIO');
    END IF;
    IF (:OLD.DFECFIN != :NEW.DFECFIN) THEN
        RAISE_APPLICATION_ERROR(-20030,'NO SE PUEDE MODIFICAR LA FECHA DE FIN');
    END IF;
    
END;

-- UPDATE CONTRATOS SET DFECINI = SYSDATE;

/*
    4. Crear el procedimiento almacenado sp_LISTADOS_BENEFICIOS. Este procedimiento tendrá dos parámetros
    de entrada ( xfecha_inicio y xfecha_fin ) y un parámetro de salida ( xTotalBeneficios).
*/

CREATE OR REPLACE PROCEDURE sp_LISTADOS_BENEFICIOS ( xfecha_inicio CONTRATOS.DFECCONTR%TYPE,  xfecha_fin CONTRATOS.DFECCONTR%TYPE, xTotalBeneficios OUT NUMBER)
IS

    CURSOR cEmpleados IS
        SELECT E.cDniEmpl, E.cNomEmpl, cRefPiso FROM EMPLEADOS E INNER JOIN CONTRATOS C ON E.CDNIEMPL = C.CDNIEMPL
        WHERE DFECCONTR BETWEEN xfecha_inicio AND xfecha_fin;
    xcEmpleados cEmpleados%ROWTYPE;
    
    CURSOR cCategoria (xRef PISOS.cRefPiso%TYPE)IS
        SELECT C.cCodCat, cDesCat, nPorcBeneficio FROM CATEGORIAS C INNER JOIN PISOS P ON C.CCODCAT = P.CCODCAT
        WHERE cRefPiso = xRef;
    xcCategoria cCategoria%ROWTYPE;
    
    CURSOR cContratos (xcCodCat CATEGORIAS.CCODCAT%TYPE)IS
        SELECT nNumContr, dFecContr, dFecIni, dFecFin, nPrecioMensual FROM CONTRATOS C INNER JOIN PISOS P ON C.CREFPISO = P.CREFPISO
        WHERE P.cCodCat = xcCodCat;
    xcContratos cContratos%ROWTYPE;

BEGIN
    
    OPEN cEmpleados;
    LOOP
        FETCH cEmpleados INTO xcEmpleados;
        EXIT WHEN cEmpleados%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Empleado: ' || xcEmpleados.cDniEmpl || ' - ' || xcEmpleados.cNomEmpl);
        
        OPEN cCategoria(xcEmpleados.cRefPiso);
        LOOP
            FETCH cCategoria INTO xcCategoria;
            EXIT WHEN cCategoria%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE('      Categoría: ' || xcCategoria.cCodCat || ' - ' || xcCategoria.cDesCat || ' - ' || xcCategoria.nPorcBeneficio);
            
            OPEN cContratos(xcCategoria.cCodCat);
            LOOP
                FETCH cContratos INTO xcContratos;
                EXIT WHEN cContratos%NOTFOUND;
                DBMS_OUTPUT.PUT_LINE('              Contrato: ' || xcContratos.nNumContr || ' - ' || xcContratos.dFecContr || ' - ' || xcContratos.dFecIni || ' - ' || xcContratos.dFecFin || ' - ' || (TO_CHAR(xcContratos.dFecFin, 'MM') - TO_CHAR(xcContratos.dFecIni, 'MM')) * xcContratos.nPrecioMensual *  xcCategoria.nPorcBeneficio);
            
            END LOOP;
            CLOSE cContratos;   
        END LOOP;
        CLOSE cCategoria;
    END LOOP;
    CLOSE cEmpleados; 
END;



SET SERVEROUTPUT ON;
DECLARE
    xTot NUMBER;
BEGIN
    sp_LISTADOS_BENEFICIOS('22/05/2018', '28/05/2018', xTot);
END;











