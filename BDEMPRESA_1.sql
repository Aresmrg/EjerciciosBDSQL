/*2. Crear el esquema/usuario/tablespace ( relacionados entre sí ) BD_Empresa con el siguiente DER*/
CREATE USER BDEMPRESA IDENTIFIED BY EDEMPRESA;
GRANT CONNECT,RESOURCE TO BDEMPRESA IDENTIFIED BY BDEMPRESA;

CREATE TABLE CENTROS(
    nNumCen NUMBER(2,0) NOT NULL,
    cNomCen VARCHAR2(30),
    cDirCen VARCHAR2(30)
);

CREATE TABLE DPTOS(
    nNumDpt NUMBER(3,0) NOT NULL,
    nNumCen NUMBER(2,0) NOT NULL,
    cDirDpt NUMBER(3,0),
    cTipDir VARCHAR2(1),
    nPreDpt NUMBER(10,2),
    nDptJef NUMBER(3,0),
    cNomDpt VARCHAR2(30)
);

CREATE TABLE EMPLEADOS(
    nCodEmp NUMBER(3,0) NOT NULL,
    nNumDpt NUMBER(3,0) NOT NULL,
    nExtTef NUMBER(3,0),
    dFecNac DATE,
    dFecIng DATE,
    nDptJef NUMBER(3,0),
    cNomDpt VARCHAR2(30)
);


--Primary keys

ALTER TABLE CENTROS ADD CONSTRAINT PK_CENTROS PRIMARY KEY (nNumCen);
ALTER TABLE DPTOS ADD CONSTRAINT PK_DEPARTAMENTOS PRIMARY KEY (nNumDpt);
ALTER TABLE EMPLEADOS ADD CONSTRAINT PK_EMPLEADOS PRIMARY KEY (nCodEmp);

--Foreign keys

ALTER TABLE DPTOS ADD CONSTRAINT FK_DEPARTAMENTOS_CENTROS FOREIGN KEY (nNumCen) REFERENCES CENTROS (nNumCen);
ALTER TABLE EMPLEADOS ADD CONSTRAINT FK_EMPLEADOS_DPTOS FOREIGN KEY (nNumDpt) REFERENCES DPTOS (nNumDpt);

-- El campo cTipDir solo admite los valores P o F.

ALTER TABLE DPTOS ADD CONSTRAINT CK_DPTOS_cTipDir CHECK (cTipDir IN('P', 'F'));

-- Dar de alta al empleado antonio que pertenece al dpto de informatica dentro del ies ayala 
-- insert solo utilizar los campos estrictamente necesarios
-- Una vez dado de alta, notificar su salario a 1800

INSERT INTO CENTROS (nNumCen, cNomCen) VALUES (1, 'IES AYALA');
INSERT INTO DPTOS (nNumDpt, nNumCen, cNomDpt) VALUES (2, 1, 'Informatica');
INSERT INTO EMPLEADOS (nCodDpt, nNumDpt, cNomEmp) VALUES (3, 2, 'Antonio');

UPDATE EMPLEADOS SET nSalEmp=1800 WHERE nCodEmp=3;

-- Añadir restriccion en la que el sueldo tiene que ser mayor a 2000
-- No se podria relizar dado que ya tenemos insertado un valor inferior a 2000
-- Para poder hacerlo:

UPDATE TABLE EMPLEADOS SET nSalEmp WHERE nSalEmp<2000;
ALTER TABLE EMPLEADOS ADD CONSTRAINT CK_SUELDO CHECK (nSalEmp>=2000);

-- Tabla centros añadir campo telefonos no puede ser nulo
-- Creamos la columna y ponemos la restriccion despues, ya que tenemos un valor (francisco ayala) con valor nulo, y no nos va a dejar meter la restriccion not null
-- Porque siempre que añadimos campos a tablas ya creadas, se añaden con valores nulos.

ALTER TABLE CENTROS ADD nNumTef VARCHAR2(20) NOT NULL;
UPDATE CENTROS SET nNumTef='958465217';
ALTER TABLE CENTROS MODIFY nNumTef NOT NULL;

-- Borramos ese numero

ALTER TABLE CENTROS DROP COLUMN nNumTef;

-- Queremos cambiar el sueldo del empleado a 1.500€ sin borrar la restriccion

ALTER TABLE EMPLEADOS DISABLE CONSTRAINT CK_SUELDO;
ALTER TABLE EMPLEADOS SET nSalEmp=1500 WHERE nCodEmp=3;
ALTER TABLE EMPLEADOS ENABLE NOVALIDATE CONSTRAINT CK_SUELDO;

-- Select para ver si lo hemos realizado bien:

SELECT * FROM DPTOS;

-- Borrar los departamentos cuyo nNumCen=1
-- No se puede realizar porque ya hay unempleado asignado al departamento que queremos borrar
-- Para poder hacerlo:

ALTER TABLE EMPLEADOS DISABLE CONSTRAINT FK_EMPLEADOS_DPTOS;
DELETE FROM DPTOS WHERE nNumCen=1;

-- La manera de Mario: Borramos todos los empleados que pertenecen a ese departamento y despues borramos el departamento correspondiente
-- para que no de ningun tipo de error.

DELETE FROM EMPLEADOS WHERE nNumCen=1;
DELETE FROM DPTOS WHERE nNumCen=1;

-- Borramos el usuario con todo lo que tuviera (ANTES TENEMOS QUE DESCONECTAR A BDEMPRESA Y REALIZARLO CON CONEXION ADMINISTRADOR)

DROP USER BDEMPRESA CASCADE;











