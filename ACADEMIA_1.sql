CREATE TABLE ALUMNOS (
    cNomAlu VARCHAR2(12),
    cApe1Alu VARCHAR2(12), 
    cApe2Alu VARCHAR2(12),
    nCodAlu NUMBER(4),
    cDirAlu VARCHAR2(32),
    dFecAlu DATE,
    cSexAlu VARCHAR(1),
    nCurAlu NUMBER(4)
);

CREATE TABLE CURSOS(
    cNomCur VARCHAR(32), 
    nCodCur NUMERIC(4),
    nCodProf VARCHAR2(10),
    nMaxAlu NUMBER(3),
    dFecIni DATE,
    dFecFin DATE,
    nNumHor NUMERIC(4)
);

CREATE TABLE PROFESORES(
    cNomPro VARCHAR2(12), 
    cApe1Pro VARCHAR2(12),
    cApe2Pro VARCHAR2(12),
    cNIFPro VARCHAR2(9),
    cDirPro VARCHAR2(32),
    cTitPro VARCHAR(32),
    nCuoPro NUMERIC(7)
);

-- PROCEDEMOS CON LAS CLAVES PRIMARIAS Y FORÁNEAS DE LAS TABLAS

ALTER TABLE PROFESORES ADD CONSTRAINT PK_PROFESORES PRIMARY KEY (cNIFPro);

ALTER TABLE CURSOS ADD CONSTRAINT PK_CURSOS PRIMARY KEY (nCodCur);

ALTER TABLE ALUMNOS ADD CONSTRAINT PK_ALUMNOS PRIMARY KEY (nCodAlu);

-- CLAVE FORANEA DE ALUMNOS A CURSOS

ALTER TABLE ALUMNOS ADD CONSTRAINT FK_ALU_CUR FOREIGN KEY(nCurAlu) REFERENCES CURSOS(nCodCur);

-- La informacion del numero de horas del curso es imprescindible para almacenarlo

ALTER TABLE CURSOS MODIFY nNumHor NUMBER(4) NOT NULL;

-- El campo Gana o cuota de profeosr no puede estar en ningun caso vacio

ALTER TABLE PROFESORES MODIFY nCuoPro NOT NULL;

-- Dos cursos no pueden llamarse igual. Lo mismo con los profesores.

ALTER TABLE CURSOS ADD CONSTRAINT UK_CUR_CNOMCUR UNIQUE(cNomCur);
ALTER TABLE PROFESORES ADD CONSTRAINT UK_PRO_CAPE1PRO UNIQUE(cApe1Pro,cApe2Pro,cNomPro);

-- Podemos identificar las tuplas de las tablas CURSOS y ALUMNOS mediante el atributo CODIGO correspondiente y en PROFESORES usando el DNI.
-- Realizado en el apartado 2 -- 
-- Cumplir la relación normal entre fecha comienzo y fecha fin (orden cronológico).--

ALTER TABLE CURSOS ADD CONSTRAINT CK_FECHA CHECK (dFecIni<=dFecFin);

-- Los valores para el atributo sexo son sólo M y H en mayusculas --

ALTER TABLE ALUMNOS ADD CONSTRAINT CK_ALU_SEXO CHECK (cSexAlu IN ('H','M'));

-- Se ha de mantener la regla de integridad de referencial.

ALTER TABLE CURSOS ADD CONSTRAINT FK_CUR_PRO FOREIGN KEY (nCodProf) REFERENCES PROFESORES(cNIFPro);

-- Insertar las siguientes tuplas.

INSERT INTO PROFESORES VALUES('Juan', 'Arch', 'López', '32432455', 'Puerta Negra, 4' ,'Ing Informática', 7500);
INSERT INTO PROFESORES VALUES('María', 'Oliva', 'Rubio', '43215643', 'Juan Alfonso 32', 'Lda. Fil. Inglesa', 5400);

INSERT INTO CURSOS VALUES('Inglés Básico', 1, '43215643', 15, '01/11/2000', '22-DIC-00', 120);
INSERT INTO CURSOS VALUES('Administración Linux', 2, '32432455', NULL, '01-SEP-00','22-DIC-00', 80);

INSERT INTO ALUMNOS VALUES('Lucas', 'Manilva', 'López', 1 ,'Alamar, 3', '01-NOV-1979', 'V', 1); -- No se puede introducir V en sexo
INSERT INTO ALUMNOS VALUES('Antonia', 'López', 'Alcantara', 2, 'Maniquí,21', NULL, 'M', 2); -- Restriccion de foreign key no existe el curso
INSERT INTO ALUMNOS VALUES('Manuel', 'Alcantara', 'Pedrós', 3, 'Julian 2', NULL, NULL, 2); 
INSERT INTO ALUMNOS VALUES('José', 'Pérez', 'Caballar', 4, 'Jarcha 5', '3-FEB-1977', 'H', 1); -- No se puede introducir V, la cambiamos

INSERT INTO ALUMNOS VALUES('Sergio', 'Navas', 'Retal', 1, NULL, 'P', NULL, NULL); --Sexo no puede ser P, tiene que tener un curso

-- Añadir el campo edad de tipo numércio a la tabla profesor

ALTER TABLE PROFESORES ADD nEdad NUMBER(3);

-- 5. Añadir las siguientes restricciones:
 -- • la edad de los profesores está entre 18 y 65 años.
 
 ALTER TABLE PROFESORES ADD CONSTRAINT CK_PROFESOR_NEDAD CHECK (NEDAD BETWEEN 18 AND 65);
 
  --• no se puede añadir un curso si su número de alumnos máximo es menor que 10.
  
  ALTER TABLE CURSOS ADD CONSTRAINT CK_CURSOS_NMAXIMO_ALUMNOS CHECK(nMaxAlu>=10);
  
  --• El número de horas de los cursos debe ser mayor que 100.
  
UPDATE CURSOS SET nNumHor=101 WHERE nNumHor<101;
ALTER TABLE CURSOS ADD CONSTRAINT CK_CURSOS_nNumHor CHECK(nNumHor>100);
--HEMOS CAMBIADO NUMERO DE HORAS A 101 PARA QUE SE PUEDA EJECUTAR EL CHEQUEO.

 -- 6. Eliminar la restricción que controla los valores permitidos para el atributo sexo.
 
 ALTER TABLE ALUMNOS DROP CONSTRAINT CK_ALU_SEXO;
 
 -- 7. Eliminar la restricción de tipo NOT NULL del atributo GANA.
 
 ALTER TABLE PROFESORES MODIFY nCuoPro NULL;
 
-- 8. Modificar el tipo de datos de DIRECCION a cadena de caracteres de 40 como
-- máximo y el del atributo DNI para poder introducir la letra del NIF.

ALTER TABLE PROFESORES MODIFY (cNIFPro VARCHAR2(10),cDirPro VARCHAR2(40));
ALTER TABLE ALUMNOS MODIFY (cDirAlu VARCHAR2(40));

-- 9. Insertar restricción no nula en el campo FECHA_INICO de CURSOS.

ALTER TABLE CURSOS MODIFY dFecIni NOT NULL;

-- 10. Cambiar la clave primaria de Profesor al nombre y apellidos.

-- NO SE PUEDE MODIFICAR LA CLAVE PRIMARIA DE PROFESOR PORQUE ES UTILIZADA COMO FORÁNEA POR CURSOS

-- 11. Insertar las siguientes tupla en alumnos:
  -- EL PRIMER REGISTRO NO SE PUEDE INSERTAR PORQUE EL DNI SE REPITE
  -- EL SEGUNDO NO SE PUEDE INSERTAR PORQUE NO EXISTE UN CÓDIGO DE CURSO CON EL DATO 3
  
-- 12. La fecha de nacimiento de Antonia López está equivocada. La verdadera es 23 de
-- diciembre de 1976.

UPDATE ALUMNOS SET dFecAlu = '23/12/1976' WHERE cNomAlu='Antonia' AND cApe1Alu='López';

-- 13. Cambiar a Antonia López al curso de código 5.
  -- NO SE PUEDE MODIFICAR EL CÓDIGO DE CURSO DE NINGÚN ALUMNO A 5 PORQUE NO EXISTE ESE CURSO
  
-- 14. Eliminar la profesora Laura Jiménez
  
DELETE PROFESORes WHERE cNomPro='Laura' AND cApe1Pro='Jiménez';

-- 15.- Crear una tabla NOMBRE DE ALUMNOS que tenga un solo atributo
-- (NOMBRE_COMPLETO) de tipo cadena de caracteres y con el contenido de la
--tabla alumnos en esos campos.

CREATE TABLE NOMBRES AS
 SELECT cApe1Alu||' '||cApe2Alu||','||cNomAlu AS NOMBRE_COMPLETO FROM ALUMNOS;
 
-- 16. Borrar las tablas

DROP TABLE ALUMNOS;
DROP TABLE CURSOS;
DROP TABLE PROFESOR;
  
DROP USER UNIVERSIDAD CASCADE;











    