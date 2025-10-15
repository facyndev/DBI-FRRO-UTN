-- Práctica Nº 2: JOINS
-- Practica en Clase: 1 – 2 – 6 – 7 – 10 – 11 – 12 – 14 – 15 – 16
-- Práctica Complementaria: 3 – 4 – 5 – 8 – 9 – 13
-- BASE DE DATOS: AGENCIA_PERSONAL

-- 1) Mostrar del Contrato 5: DNI, Apellido y Nombre de la persona contratada y el
-- sueldo acordado en el contrato
-- |nombre |apellido |sueldo |dni|
SELECT P.nombre, P.apellido, C.sueldo, P.dni FROM `agencia_personal`.`personas` P
INNER JOIN `agencia_personal`.`contratos` C ON P.dni=C.dni
WHERE C.nro_contrato = 5;

-- 2) ¿Quiénes fueron contratados por la empresa Viejos Amigos o Tráigame Eso?
-- Mostrar el DNI, número de contrato, fecha de incorporación, fecha de solicitud en la
-- agencia de los contratados y fecha de caducidad (si no tiene fecha de caducidad colocar
-- ‘Sin Fecha’). Ordenado por fecha de contrato y nombre de empresa
-- | Dni |nro_contrato|fecha_incorporacion|fecha_solicitud|fecha_caducidad|
SELECT 
	C.dni, 
    C.nro_contrato, 
    C.fecha_incorporacion, 
    C.fecha_solicitud, 
    IFNULL(C.fecha_caducidad, "Sin Fecha") 
    FROM `agencia_personal`.`contratos` C
	INNER JOIN `agencia_personal`.`solicitudes_empresas` S ON C.cuit=S.cuit AND C.cod_cargo=S.cod_cargo AND C.fecha_solicitud=S.fecha_solicitud
    INNER JOIN `agencia_personal`.`empresas` E ON E.cuit=S.cuit
    WHERE E.razon_social IN ("Tráigame Eso", "Viejos Amigos")
    ORDER BY C.fecha_solicitud, E.razon_social;

-- 3 Listado de las solicitudes consignando razón social, dirección y e_mail de la
-- empresa, descripción del cargo solicitado y años de experiencia solicitados, ordenado por
-- fecha d solicitud y descripción de cargo.
SELECT E.razon_social, E.direccion, E.e_mail, C.desc_cargo, S.anios_experiencia 
	FROM `agencia_personal`.`solicitudes_empresas` S
    INNER JOIN `agencia_personal`.`empresas` E ON S.cuit=E.cuit
    INNER JOIN `agencia_personal`.`cargos` C ON S.cod_cargo=C.cod_cargo
    ORDER BY S.fecha_solicitud, C.desc_cargo;
    
-- 4) Listar todos los candidatos con título de bachiller o un título de educación no
-- formal. Mostrar nombre y apellido, descripción del título y DNI.
SELECT PS.dni, PS.nombre, PS.apellido, T.desc_titulo FROM `agencia_personal`.`personas` PS
	INNER JOIN `agencia_personal`.`personas_titulos` PT ON PS.dni=PT.dni
	INNER JOIN `agencia_personal`.`titulos` T ON PT.cod_titulo=T.cod_titulo
	WHERE T.desc_titulo = "Bachiller" OR T.tipo_titulo LIKE "%no formal%";
    
-- 5) Realizar el punto 4 sin mostrar el campo DNI pero para todos los títulos.
SELECT PS.nombre, PS.apellido, T.desc_titulo FROM `agencia_personal`.`personas` PS
	INNER JOIN `agencia_personal`.`personas_titulos` PT ON PS.dni=PT.dni
	INNER JOIN `agencia_personal`.`titulos` T ON PT.cod_titulo=T.cod_titulo;

-- 6) Empleados que no tengan referencias o hayan puesto de referencia a Armando
-- Esteban Quito o Felipe Rojas. Mostrarlos de la siguiente forma:
-- Pérez, Juan tiene como referencia a Felipe Rojas cuando trabajo en Constructora Gaia
-- S.A
SELECT DISTINCT
	CONCAT(P.apellido, " ", P.nombre, " ", 
	IFNULL(CONCAT("tiene como referencia a ", A.persona_contacto), 
    CONCAT("no tiene referencias")), 
	" cuando trabajó en ", UPPER(E.razon_social)) as texto
	FROM `agencia_personal`.`personas` P 
		INNER JOIN `agencia_personal`.`antecedentes` A ON P.dni=A.dni
		INNER JOIN empresas E ON A.cuit=E.cuit
	WHERE A.persona_contacto IN ("Armando Esteban Quito", "Felipe Rojas") or A.persona_contacto IS NULL;

-- 7) Seleccionar para la empresa Viejos amigos, fechas de solicitudes, descripción del
-- cargo solicitado y edad máxima y mínima . Encabezado:
-- |Empresa  | Fecha  Solicitud dd-mm-YYYY    |Cargo |Edad Mín / Sin especificar    |Edad Máx / Sin especificar    |
SELECT 
	razon_social "Empresa", 
    DATE_FORMAT(fecha_solicitud, "%d/%m/%Y") "Fecha Solicitud", 
    desc_cargo "Cargo", 
    IFNULL(edad_minima, "Sin especificar") "Edad Mín.", 
    IFNULL(edad_maxima, "Sin especificar") "Edad Máx."
	FROM `agencia_personal`.`empresas` E 
		INNER JOIN `agencia_personal`.`solicitudes_empresas` SE ON E.cuit=SE.cuit
        INNER JOIN `agencia_personal`.`cargos` C ON SE.cod_cargo=C.cod_cargo
	WHERE `razon_social` = "Viejos amigos";
        

-- 8) Mostrar los antecedentes de cada postulante:
-- Postulante (nombre y apellido) Cargo (descripción del cargo)
SELECT CONCAT(P.nombre, " ", P.apellido) "Postulante", C.desc_cargo "Cargo"
	FROM `agencia_personal`.`personas` P
    INNER JOIN `agencia_personal`.`antecedentes` A ON P.dni=A.dni
    INNER JOIN `agencia_personal`.`cargos` C ON C.cod_cargo=A.cod_cargo;

-- 9) Mostrar todas las evaluaciones realizadas para cada solicitud ordenar en forma
-- ascendente por empresa y descendente por cargo:
SELECT EMP.razon_social "Empresa", CAR.desc_cargo "Cargo", EVA.desc_evaluacion "Desc_Evaluacion", EEL.resultado "Resultado" 
	FROM `agencia_personal`.`solicitudes_empresas` SOL
		INNER JOIN `agencia_personal`.`empresas` EMP ON SOL.cuit=EMP.cuit 
		INNER JOIN `agencia_personal`.`cargos` CAR ON SOL.cod_cargo=CAR.cod_cargo
		INNER JOIN `agencia_personal`.`entrevistas` ENT ON SOL.cuit=ENT.cuit AND SOL.cod_cargo=ENT.cod_cargo AND SOL.fecha_solicitud=ENT.fecha_solicitud
		INNER JOIN `agencia_personal`.`entrevistas_evaluaciones` EEL ON ENT.nro_entrevista=EEL.nro_entrevista
		INNER JOIN `agencia_personal`.`evaluaciones` EVA ON EEL.cod_evaluacion=EVA.cod_evaluacion
    ORDER BY EMP.razon_social ASC, CAR.desc_cargo DESC;

-- 10) Listar las empresas solicitantes mostrando la razón social y fecha de cada solicitud,
-- y descripción del cargo solicitado. Si hay empresas que no hayan solicitado que salga la
-- leyenda: Sin Solicitudes en la fecha y en la descripción del cargo.
-- |cuit |razon_social |Fecha Solicitud |Cargo
SELECT E.cuit "cuit", razon_social "razon_social", 
	IFNULL(DATE_FORMAT(fecha_solicitud, "%d/%m/%Y"), "Sin Solicitudes") "Fecha Solicitud", 
    IFNULL(desc_cargo, "Sin Solicitudes") "Cargo"
	FROM `agencia_personal`.`empresas` E 
		LEFT JOIN `agencia_personal`.`solicitudes_empresas` SE ON E.cuit=SE.cuit
        LEFT JOIN `agencia_personal`.`cargos` C ON SE.cod_cargo=C.cod_cargo;

-- misma consulta resuelta con right
SELECT E.cuit "cuit", razon_social "razon_social", 
	IFNULL(DATE_FORMAT(fecha_solicitud, "%d/%m/%Y"), "Sin Solicitudes") "Fecha Solicitud", 
    IFNULL(desc_cargo, "Sin Solicitudes") "Cargo"
	FROM `agencia_personal`.`cargos` C 
		RIGHT JOIN `agencia_personal`.`solicitudes_empresas` SE ON SE.cod_cargo=C.cod_cargo
		RIGHT JOIN `agencia_personal`.`empresas` E ON E.cuit=SE.cuit;
     
-- usando right join nos quedamos con todos los cargos y los registros coincidentes de las solicitudes
SELECT
	IFNULL(E.cuit, "Sin solicitudes") "CUIT", 
	IFNULL(razon_social, "Sin solicitudes") "razon_social", 
	IFNULL(DATE_FORMAT(fecha_solicitud, "%d/%m/%Y"), "Sin Solicitudes") "Fecha Solicitud", 
    desc_cargo "Cargo"
	FROM `agencia_personal`.`empresas` E 
		RIGHT JOIN `agencia_personal`.`solicitudes_empresas` SE ON E.cuit=SE.cuit
        RIGHT JOIN `agencia_personal`.`cargos` C ON SE.cod_cargo=C.cod_cargo; 

-- Empresas que solicitaron cargos y los cargos que no fueron solicitados
SELECT
	IFNULL(E.cuit, "Sin solicitudes") "CUIT", 
	IFNULL(razon_social, "Sin solicitudes") "razon_social", 
	IFNULL(DATE_FORMAT(fecha_solicitud, "%d/%m/%Y"), "Sin Solicitudes") "Fecha Solicitud", 
    IFNULL(desc_cargo, "Sin Solicitudes") "Cargo"
	FROM `agencia_personal`.`empresas` E 
		LEFT JOIN `agencia_personal`.`solicitudes_empresas` SE ON E.cuit=SE.cuit
        RIGHT JOIN `agencia_personal`.`cargos` C ON SE.cod_cargo=C.cod_cargo;

-- 11) Mostrar para todas las solicitudes la razón social de la empresa solicitante, el cargo
-- y si se hubiese realizado un contrato los datos de la(s) persona(s).
-- cuit razon_social desc_cargo DNI Apellido Nombre
SELECT 
	E.cuit "cuit", E.razon_social "Razon social", C.desc_cargo "Cargo", 
	IFNULL(P.dni, "Sin contrato") "DNI",
	IFNULL(CONCAT(P.apellido, ", ", P.nombre), "Sin contrato") "Apellido y Nombre"
	FROM `agencia_personal`.`solicitudes_empresas` SE 
		INNER JOIN `agencia_personal`.`empresas` E ON SE.cuit=E.cuit
        INNER JOIN `agencia_personal`.`cargos` C ON SE.cod_cargo=C.cod_cargo
        LEFT JOIN `agencia_personal`.`contratos` CON 
			ON SE.cod_cargo=CON.cod_cargo and SE.cuit=CON.cuit and SE.fecha_solicitud=CON.fecha_solicitud
        LEFT JOIN `agencia_personal`.`personas` P ON CON.dni=P.dni; 
		 
-- 12) Mostrar para todas las solicitudes la razón social de la empresa solicitante, el cargo de
-- las solicitudes para las cuales no se haya realizado un contrato.
-- |cuit |razon_social |desc_cargo
SELECT E.cuit "CUIT", E.razon_social "Razón social", desc_cargo "Cargo"
	FROM `agencia_personal`.`solicitudes_empresas` SE 
		INNER JOIN `agencia_personal`.`empresas` E ON SE.cuit=E.cuit
        INNER JOIN `agencia_personal`.`cargos` CARGOS ON SE.cod_cargo=CARGOS.cod_cargo
        LEFT JOIN `agencia_personal`.`contratos` C 
			ON SE.cod_cargo=C.cod_cargo and SE.fecha_solicitud=C.fecha_solicitud and SE.cuit=C.cuit
	WHERE nro_contrato IS NULL;

-- 13) Listar todos los cargos y para aquellos que hayan sido mencionados como
-- antecedente por alguna persona indicar nombre y apellido de la persona y empresa donde
-- lo ocupó.
-- desc_cargo DNI Apellido razon_social
SELECT desc_cargo "Cargo", P.dni "DNI", apellido "Apellido", razon_social "Razón social"
	FROM `agencia_personal`.`cargos` C 
		LEFT JOIN `agencia_personal`.`antecedentes` A ON C.cod_cargo=A.cod_cargo
        LEFT JOIN `agencia_personal`.`personas` P ON A.dni=P.dni
        LEFT JOIN `agencia_personal`.`empresas` E ON A.cuit=E.cuit
        ;

use `afatse`;
-- BASE DE DATOS: AFATSE
-- 14) Indicar todos los instructores que tengan un supervisor.
-- Cuil Instructor | Nombre Instructor | Apellido Instructor | Cuil Supervisor | Nombre Supervisor | Apellido Supervisor

-- ejemplo de self join, unir una tabla consigo misma usando diferentes alias
SELECT 
	INS.cuil "Cuil Instructor", INS.nombre "Nombre Instructor", INS.apellido "Apellido Instructor",
	SUP.cuil "Cuil Supervisor", SUP.nombre "Nombre Supervisor", SUP.apellido "Apellido Supervisor"
	FROM `afatse`.`instructores` INS 
		INNER JOIN `afatse`.`instructores` SUP ON INS.cuil_supervisor=SUP.cuil
	WHERE INS.cuil_supervisor IS NOT NULL;

--  15 16

-- 15) Ídem 14) pero para todos los instructores. Si no tiene supervisor mostrar esos
-- campos en blanco
SELECT 
	INS.cuil "Cuil Instructor", INS.nombre "Nombre Instructor", INS.apellido "Apellido Instructor",
	IFNULL(SUP.cuil, "") "Cuil Supervisor", 
    IFNULL(SUP.nombre, "") "Nombre Supervisor", 
    IFNULL(SUP.apellido, "") "Apellido Supervisor"
	FROM `afatse`.`instructores` INS 
		LEFT JOIN `afatse`.`instructores` SUP ON INS.cuil_supervisor=SUP.cuil;

-- 16) Ranking de Notas por Supervisor e Instructor. El ranking deberá indicar para cada
-- supervisor los instructores a su cargo y las notas de los exámenes que el instructor haya
-- corregido en el 2014. Indicando los datos del supervisor , nombre y apellido del instructor,
-- plan de capacitación, curso, nombre y apellido del alumno, examen, fecha de evaluación y
-- nota. En caso de que no tenga supervisor a cargo indicar espacios en blanco. Ordenado
-- ascendente por nombre y apellido de supervisor y descendente por fecha.
SELECT 
	IFNULL(SUP.cuil, "") "Cuil Supervisor", IFNULL(SUP.nombre, "") "Nombre Supervisor", IFNULL(SUP.apellido, "") "Apellido Supervisor", 
    INST.nombre "Nombre Instructor", INST.apellido "Apellido Instructor", 
    nom_plan, nro_curso, AL.nombre, AL.apellido, nro_examen, 
    DATE_FORMAT(fecha_evaluacion, "%d/%m/%Y"), nota 
	FROM `afatse`.`instructores` SUP 
		RIGHT JOIN `afatse`.`instructores` INST ON SUP.cuil=INST.cuil_supervisor
        INNER JOIN `afatse`.`evaluaciones` EVAL ON INST.cuil=EVAL.cuil
        INNER JOIN `afatse`.`alumnos` AL ON EVAL.dni=AL.dni
	WHERE YEAR(fecha_evaluacion) = 2014;
        
        
