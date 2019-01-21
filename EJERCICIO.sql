-- tabla para almacenar todos los alumnos de la BD
CREATE TABLE Alumnos(
    numMatricula NUMBER(4) PRIMARY KEY,
    nombre VARCHAR2(15),
    apellidos VARCHAR2(30),
    titulacion VARCHAR2(15),
    precioMatricula NUMBER(6,2)
);

-- tabla para los alumnos de informática
CREATE TABLE AlumnosInf(
    IDMatricula NUMBER(4) PRIMARY KEY,
    nombre_apellidos VARCHAR2(50),
    precio NUMBER(6,2)
);

CREATE TABLE Tabla_Departamento (
    Num_Depart Number(2) PRIMARY KEY,
    Nombre_Depart VARCHAR2(15),
    Ubicación VARCHAR2(15),
    Presupuesto NUMBER(10,2),
    Media_Salarios NUMBER(10,2),
    Total_Salarios NUMBER(10,2)
);

CREATE TABLE Tabla_Empleado(
    Num_Empleado Number(4) PRIMARY KEY,
    Nombre_Empleado VARCHAR(25),
    Categoría VARCHAR(10), -- Gerente, Comercial, …
    Jefe Number(4),
    Fecha_Contratacion DATE,
    Salario Number(7,2),
    Comision Number(7,2),
    Num_Depart NUMBER(2),
    FOREIGN KEY (Jefe) REFERENCES Tabla_Empleado,
    FOREIGN KEY (Num_Depart) REFERENCES Tabla_Departamento
);

INSERT INTO ALUMNOS VALUES(1, 'Juan', 'Alvarez', 'Administrativo', 1000);
INSERT INTO ALUMNOS VALUES(2, 'Jose', 'Jimenez', 'Informatica', 1200);
INSERT INTO ALUMNOS VALUES(3, 'Maria', 'Perez', 'Administrativo', 1000);
INSERT INTO ALUMNOS VALUES(4, 'Elena', 'Martinez', 'Informatica', 1200);

INSERT INTO TABLA_DEPARTAMENTO VALUES(1,'CONTABILIDAD','GRANADA',10000,1500,5000);
INSERT INTO TABLA_EMPLEADO VALUES(1,'MARIO','CONT',2,'20/05/18',1500,10,1);
INSERT INTO TABLA_EMPLEADO VALUES(2,'SERGIO MARICA','JEFE',2,'01/01/18',3500,20,1);
INSERT INTO TABLA_EMPLEADO VALUES(3,'SERGIO','caca',2,'01/01/18',500,300,1);

/*
    1. Desarrollar un procedimiento que visualice el apellido y la fecha
    de alta de todos los empleados ordenados por apellido.
*/

SET SERVEROUTPUT ON;
DECLARE

    CURSOR cApFec IS
        SELECT NOMBRE_EMPLEADO, FECHA_CONTRATACION FROM TABLA_EMPLEADO
        ORDER BY NOMBRE_EMPLEADO;
    xcApFec cApFec%ROWTYPE;

BEGIN

    OPEN cApFec;
    LOOP
        FETCH cApFec INTO xcApFec;
        EXIT WHEN cApFec%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Apellidos: ' || xcApFec.NOMBRE_EMPLEADO || ' - Fecha alta: ' || xcApFec.FECHA_CONTRATACION);
    END LOOP;
    CLOSE cApFec;
END;

/*
    2. Desarrollar un procedimiento que encuentre el primer
    empleado con un sueldo mayor de 2.000 €
*/

SET SERVEROUTPUT ON;
DECLARE

    CURSOR c2000 IS
        SELECT * FROM TABLA_EMPLEADO;
    xc2000 c2000%ROWTYPE;

BEGIN

    OPEN c2000;
    LOOP
        FETCH c2000 INTO xc2000;
        EXIT WHEN c2000%NOTFOUND;
        IF(xc2000.SALARIO > 2000) THEN
            DBMS_OUTPUT.PUT_LINE('Apellidos: ' || xc2000.NOMBRE_EMPLEADO || ' - Fecha alta: ' || xc2000.FECHA_CONTRATACION);
        END IF;
    END LOOP;
    CLOSE c2000;
END;

/*
    3. Realizar un procedimiento que visualice el número y apellido de
    un empleado, así como la localidad de su departamento,
    ordenado por el nombre de la localidad
*/

SET SERVEROUTPUT ON;
DECLARE

    CURSOR c2 IS
        SELECT NUM_EMPLEADO, NOMBRE_EMPLEADO, UBICACIÓN FROM TABLA_EMPLEADO T1
        INNER JOIN TABLA_DEPARTAMENTO T2 ON T1.NUM_DEPART = T2.NUM_DEPART
        ORDER BY UBICACIÓN;
    xc2 c2%ROWTYPE;

BEGIN

    OPEN c2;
    LOOP
        FETCH c2 INTO xc2;
        EXIT WHEN c2%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Numero empleado: ' || xc2.NUM_EMPLEADO || ' - Nombre: ' || xc2.NOMBRE_EMPLEADO || ' - Localidad: ' || xc2.UBICACIÓN);
    END LOOP;
    CLOSE c2;
END;

/*
    4. En la tabla EMPLE incrementar el salario el 10% a los
    empleados que tengan una comisión superior al 5% del salario.
*/

SET SERVEROUTPUT ON;
DECLARE

    CURSOR c10 IS
        SELECT * FROM TABLA_EMPLEADO;
    xc10 c10%ROWTYPE;

BEGIN

    OPEN c10;
    LOOP
        FETCH c10 INTO xc10;
        EXIT WHEN c10%NOTFOUND;
        IF(xc10.COMISION > (xc10.SALARIO * 0.5)) THEN
            UPDATE TABLA_EMPLEADO SET SALARIO = SALARIO * 1.10;
        END IF;
    END LOOP;
    CLOSE c10;
END;

/*
    6. Escribir un procedimiento que reciba una cadena y visualice el
    apellido y el número de empleado de todos los empleados cuyo
    apellido contenga la cadena especificada. Al finalizar visualizar
    el número de empleados mostrados.

*/

CREATE OR REPLACE PROCEDURE pr1 (xCadena TABLA_EMPLEADO.Nombre_Empleado%TYPE)
IS

    CURSOR Ap_Num IS
    SELECT NOMBRE_EMPLEADO, NUM_EMPLEADO FROM TABLA_EMPLEADO;
    xAp_Num Ap_Num%ROWTYPE;
    
BEGIN

    OPEN Ap_Num;
    LOOP
        FETCH Ap_Num INTO xAp_Num;
        EXIT WHEN Ap_Num%NOTFOUND;
        IF ( xAp_Num.NOMBRE_EMPLEADO LIKE xCadena ) THEN
            DBMS_OUTPUT.PUT_LINE ('Nombre: ' || xAp_Num.NOMBRE_EMPLEADO || ' - NUMERO: ' || xAp_Num.NUM_EMPLEADO);
        END IF;
    END LOOP;
    CLOSE Ap_Num;
END;

SET SERVEROUTPUT ON;
BEGIN
    pr1('MARIO');
END;

