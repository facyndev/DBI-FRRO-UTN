-- Practica Nº 5: Subconsultas, Tablas Temporales y Variables
-- Practica en Clase: 1 – 2 – 3 – 4 – 7 – 9 – 10 – 11 – 12 – 16
-- Práctica Complementaria: 5 – 6 – 8 – 13 – 14 – 15 – 17
-- BASE DE DATOS: AGENCIA_PERSONAL

-- 1 )¿Qué personas fueron contratadas por las mismas empresas que Stefanía Lopez?
-- |dni |apellido |nombre|
SELECT PER.dni, PER.apellido, PER.nombre FROM `agencia_personal`.`contratos` CON
INNER JOIN `agencia_personal`.`personas` PER ON PER.dni=CON.dni
WHERE CON.cuit IN (
	SELECT CON.cuit FROM `agencia_personal`.`contratos` CON
		INNER JOIN `agencia_personal`.`personas` PER ON PER.dni=CON.dni
		WHERE CONCAT(PER.nombre, " ", PER.apellido) LIKE "Stefan_a Lopez"
)
GROUP BY PER.dni;

-- 2) Encontrar a aquellos empleados que ganan menos que el máximo sueldo de los empleados
-- de Viejos Amigos.
-- |dni |nombre y apellidos |sueldo
SELECT @sueldo_maximo = (
		SELECT MAX(CON.sueldo) FROM `agencia_personal`.`contratos` CON
			INNER JOIN `agencia_personal`.`empresas` EMP ON EMP.cuit=CON.cuit
			WHERE EMP.razon_social = "Viejos Amigos");
SELECT @sueldo_maximo;

SELECT 
	PER.dni, 
    CONCAT(PER.nombre, " ", PER.apellido) "Nombre y apellidos", 
    CON.sueldo 
    FROM `agencia_personal`.`contratos` CON
    INNER JOIN `agencia_personal`.`personas` PER ON PER.dni=CON.dni
    WHERE CON.sueldo < @sueldo_maximo;

-- 3) Mostrar empresas contratantes y sus promedios de comisiones pagadas o a pagar, pero sólo
-- de aquellas cuyo promedio supere al promedio de Tráigame eso.
SET @promedio_comision = (
	SELECT AVG(COM.importe_comision) FROM `agencia_personal`.`comisiones` COM
		INNER JOIN `agencia_personal`.`contratos` CON 
			ON COM.nro_contrato=CON.nro_contrato
		INNER JOIN `agencia_personal`.`empresas` EMP 
			ON CON.cuit=EMP.cuit
	WHERE EMP.razon_social LIKE "Tr_igame eso"
);
SELECT @promedio_comision;

SELECT EMP.cuit, EMP.razon_social, AVG(COM.importe_comision) "Promedio comision"
FROM `agencia_personal`.`contratos` CON
	INNER JOIN `agencia_personal`.`empresas` EMP 
		ON CON.cuit=EMP.cuit
	INNER JOIN `agencia_personal`.`comisiones` COM 
		ON CON.nro_contrato=COM.nro_contrato
	GROUP BY EMP.cuit
    HAVING AVG(COM.importe_comision) > @promedio_comision;

-- 4) Seleccionar las comisiones pagadas que tengan un importe menor al promedio de todas las
-- comisiones(pagas y no pagas), mostrando razón social de la empresa contratante, mes
-- contrato, año contrato , nro. contrato, nombre y apellido del empleado.
SET @promedio_comisiones = (SELECT AVG(importe_comision) FROM `agencia_personal`.`comisiones`);
SELECT @promedio_comisiones;

SELECT 
	EMP.razon_social "Razon social",
    CONCAT(PER.nombre, " ", PER.apellido) "Nombre y apellido",
    CON.nro_contrato "Numero de contrato",
    COM.mes_contrato "Mes de contrato",
    COM.anio_contrato "Año de contrato",
    COM.importe_comision "Importe de comision"
    FROM `agencia_personal`.`comisiones` COM
		INNER JOIN `agencia_personal`.`contratos` CON 
			ON COM.nro_contrato=CON.nro_contrato
		INNER JOIN `agencia_personal`.`empresas` EMP 
			ON CON.cuit=EMP.cuit
		INNER JOIN `agencia_personal`.`personas` PER 
			ON CON.dni=PER.dni
	WHERE COM.fecha_pago IS NOT NULL AND COM.importe_comision < @promedio_comisiones;

-- 5) Determinar las empresas que en promedio pagaron más que el promedio de las comisiones
SET @promedio_comisiones = (SELECT AVG(importe_comision) FROM `agencia_personal`.`comisiones`);

SELECT EMP.razon_social, ROUND(AVG(COM.importe_comision)) "Promedio comision" 
	FROM `agencia_personal`.`empresas` EMP
	INNER JOIN `agencia_personal`.`contratos` CON ON CON.cuit=EMP.cuit
	INNER JOIN `agencia_personal`.`comisiones` COM ON CON.nro_contrato=COM.nro_contrato
    GROUP BY EMP.cuit
    HAVING AVG(COM.importe_comision ) > @promedio_comisiones;

-- 6) Seleccionar los empleados que no tengan educación no formal o terciario.
-- |apellido |nombre |
SELECT DISTINCT PER.apellido, PER.nombre 
	FROM `agencia_personal`.`contratos` CON
	INNER JOIN `agencia_personal`.`personas_titulos` PERT ON CON.dni=PERT.dni
    INNER JOIN `agencia_personal`.`titulos` TIT ON PERT.cod_titulo=TIT.cod_titulo
    WHERE TIT.tipo_titulo NOT IN ("Educacion no formal", "Terciario");
    
-- 7) Mostrar los empleados cuyo salario supere al promedio de sueldo de la empresa que los
-- contrató.
-- |cuit | dni | sueldo | prom

-- 8) Determinar las empresas que pagaron en promedio la mayor o menor de las comisiones
-- |razon_social | promedio
SET @comision_maxima = (SELECT MAX(importe_comision) FROM `agencia_personal`.`comisiones`);
SET @comision_minima = (SELECT MIN(importe_comision) FROM `agencia_personal`.`comisiones`);

DROP TEMPORARY TABLE IF EXISTS `agencia_personal`.`tt_comisiones_extremas`;
CREATE TEMPORARY TABLE `agencia_personal`.`tt_comisiones_extremas`
	SELECT @comision_maxima "importe_comision"
    UNION ALL
    SELECT @comision_minima;
    
SELECT EMP.razon_social, AVG(COM.importe_comision) "promedio" 
	FROM `agencia_personal`.`contratos` CON
	INNER JOIN `agencia_personal`.`empresas` EMP ON CON.cuit=EMP.cuit
    INNER JOIN `agencia_personal`.`comisiones` COM ON CON.nro_contrato=COM.nro_contrato
	GROUP BY CON.cuit
	HAVING AVG(COM.importe_comision) IN (SELECT importe_comision FROM `agencia_personal`.`tt_comisiones_extremas`);
    
DROP TEMPORARY TABLE IF EXISTS `agencia_personal`.`tt_comisiones_extremas`;

-- 9) Alumnos que se hayan inscripto a más cursos que Antoine de Saint-Exupery. Mostrar
-- todos los datos de los alumnos, la cantidad de cursos a la que se inscribió y cuantas
-- veces más que Antoine de Saint-Exupery.
-- |dni |nombre|apellido |direccion |email |te |count(*) count(*)- @cant)
SET @cant = (SELECT count(*) FROM `afatse`.`inscripciones` INS
	INNER JOIN `afatse`.`alumnos` ALU ON ALU.dni=INS.dni
    WHERE ALU.nombre = "Antoine de" AND ALU.apellido = "Saint-Exupery");

SELECT 
	ALU.dni,
    ALU.nombre,
    ALU.apellido,
    ALU.direccion,
    ALU.email,
    ALU.tel,
    COUNT(*) "Cantidad de cursos incriptos",
    COUNT(*) - @cant "Mas veces que Antoine de Saint-Exupery"
	FROM `afatse`.`inscripciones` INS
	INNER JOIN `afatse`.`alumnos` ALU ON ALU.dni=INS.dni
    GROUP BY ALU.dni
    HAVING COUNT(*) > @cant;

-- 10) En el año 2014, qué cantidad de alumnos se han inscripto a los Planes de Capacitación
-- indicando para cada Plan de Capacitación la cantidad de alumnos inscriptos y el
-- porcentaje que representa respecto del total de inscriptos a los Planes de Capacitación
-- dictados en el año.
SET @total_inscriptos = (SELECT COUNT(*) FROM `afatse`.`inscripciones` INS WHERE YEAR(INS.fecha_inscripcion) = "2014");
SELECT @total_inscriptos;

SELECT 
	PLC.nom_plan, 
    COUNT(*),
    ROUND((COUNT(*) / @total_inscriptos) * 100, 2) "% Total"
    FROM `afatse`.`plan_capacitacion` PLC
    INNER JOIN `afatse`.`inscripciones` INS ON PLC.nom_plan=INS.nom_plan
	WHERE YEAR(INS.fecha_inscripcion) = "2014"
    GROUP BY PLC.nom_plan;

-- 11) Indicar el valor actual de los planes de Capacitación
-- nom_plan fecha_desde_plan valor_plan
DROP TEMPORARY TABLE IF EXISTS `afatse`.`tt_fechas_plan_mas_recientes`;

CREATE TEMPORARY TABLE `afatse`.`tt_fechas_plan_mas_recientes` AS
	SELECT PLC.nom_plan, MAX(PLC.fecha_desde_plan) "fecha_mas_reciente"
    FROM `afatse`.`valores_plan` PLC
    GROUP BY PLC.nom_plan;
    
SELECT PLC.nom_plan, PLC.fecha_desde_plan, PLC.valor_plan FROM 
	`afatse`.`valores_plan` PLC
    INNER JOIN `afatse`.`tt_fechas_plan_mas_recientes` FPMR ON PLC.nom_plan=FPMR.nom_plan
    WHERE FPMR.fecha_mas_reciente = PLC.fecha_desde_plan;
    
DROP TEMPORARY TABLE IF EXISTS `afatse`.`tt_fechas_plan_mas_recientes`;

-- 12) Plan de capacitacion mas barato. Indicar los datos del plan de capacitacion y el valor actual
-- nom_plan desc_plan hs modalidad valor_plan
SET @mas_barato = (SELECT MIN(valor_plan) FROM `afatse`.`valores_plan`);

SELECT PLC.nom_plan, PLC.desc_plan, PLC.hs, PLC.modalidad, VPLC.valor_plan FROM `afatse`.`plan_capacitacion` PLC
	INNER JOIN `afatse`.`valores_plan` VPLC ON PLC.nom_plan = VPLC.nom_plan
    WHERE VPLC.valor_plan = @mas_barato;
    
-- 13) ¿Qué instructores que han dictado algún curso del Plan de Capacitación “Marketing 1” el
-- año 2014 y no vayan a dictarlo este año? (año 2015)
SELECT CI.cuil FROM `afatse`.`cursos_instructores` CI
    INNER JOIN `afatse`.`cursos` CUR ON CUR.nro_curso = CI.nro_curso AND CUR.nom_plan = CI.nom_plan
	INNER JOIN `afatse`.`plan_capacitacion` PLC ON CI.nom_plan = PLC.nom_plan
    WHERE 
		PLC.nom_plan = "Marketing 1" 
        AND YEAR(CUR.fecha_ini) = '2014' 
		AND NOT CI.cuil IN (
			SELECT CI.cuil FROM `afatse`.`cursos_instructores` CI
			INNER JOIN `afatse`.`cursos` CUR ON CUR.nro_curso = CI.nro_curso AND CUR.nom_plan = CI.nom_plan
			INNER JOIN `afatse`.`plan_capacitacion` PLC ON CI.nom_plan = PLC.nom_plan
			WHERE PLC.nom_plan = "Marketing 1" AND YEAR(CUR.fecha_ini) = '2015'
			GROUP BY CI.cuil
        )
    GROUP BY CI.cuil;
    
-- 14) Alumnos que tengan todas sus cuotas pagas hasta la fecha.
DROP TEMPORARY TABLE IF EXISTS `afatse`.`tt_alumnos_cuotas_impagas`;

CREATE TEMPORARY TABLE `afatse`.`tt_alumnos_cuotas_impagas`
	SELECT ALU.dni FROM `afatse`.`alumnos` ALU
	INNER JOIN `afatse`.`cuotas` CUO ON ALU.dni=CUO.dni
    WHERE CUO.fecha_pago IS NULL
	GROUP BY ALU.DNI;

SELECT 
	ALU.*
	FROM `afatse`.`cuotas` CUO
    INNER JOIN `afatse`.`alumnos` ALU ON ALU.dni = CUO.dni
    WHERE CUO.fecha_pago <= CURDATE() AND ALU.dni NOT IN (SELECT dni FROM `afatse`.`tt_alumnos_cuotas_impagas`)
	GROUP BY ALU.dni
	ORDER BY ALU.dni ASC;
    
DROP TEMPORARY TABLE `afatse`.`tt_alumnos_cuotas_impagas`;

-- 15) Alumnos cuyo promedio supere al del curso que realizan. Mostrar dni, nombre y apellido,
-- promedio y promedio del curso.
DROP TEMPORARY TABLE IF EXISTS `afatse`.`tt_curso_promedio`;

# Promedio de las notas de todos los alumnos de cada curso con su plan correspondiente
CREATE TEMPORARY TABLE `afatse`.`tt_curso_promedio`
	SELECT EVA.nro_curso, EVA.nom_plan, AVG(EVA.nota) "prome"
		FROM `afatse`.`evaluaciones` EVA
		GROUP BY EVA.nro_curso, EVA.nom_plan;
        
# Alumnos cuyo promedio de notas del curso al que esta inscripto es mayor al promedio general
SELECT ALU.dni, ALU.nombre, ALU.apellido, AVG(EVA.nota), CURP.prome FROM `afatse`.`alumnos` ALU
	INNER JOIN `afatse`.`inscripciones` INS ON ALU.dni = INS.dni
    INNER JOIN `afatse`.`evaluaciones` EVA ON EVA.dni = INS.dni AND EVA.nro_curso = INS.nro_curso AND EVA.nom_plan = INS.nom_plan
    INNER JOIN `afatse`.`tt_curso_promedio` CURP ON CURP.nro_curso = EVA.nro_curso AND CURP.nom_plan = EVA.nom_plan
    GROUP BY ALU.dni, EVA.nro_curso, EVA.nom_plan, CURP.prome
    HAVING AVG(EVA.nota) > CURP.prome
    ORDER BY (ALU.nombre) ASC;
	
DROP TEMPORARY TABLE `afatse`.`tt_curso_promedio`;

-- 16)Para conocer la disponibilidad de lugar en los cursos que empiezan en abril para
-- lanzar una campaña se desea conocer la cantidad de alumnos inscriptos a los cursos
-- que comienzan a partir del 1/04/2014 indicando: Plan de Capacitación, curso, fecha de
-- inicio, salón, cantidad de alumnos inscriptos y diferencia con el cupo de alumnos
-- registrado para el curso que tengan al más del 80% de lugares disponibles respecto del
-- cupo.
-- Ayuda: tener en cuenta el uso de los paréntesis y la precedencia de los operadores
-- matemáticos.
-- nro_curso fecha_ini salon cupo count( dni ) ( cupo - count( dni ) )

-- Objetivo: Conocer disponibilidad de cursos que empiezan en abril
-- A traves de: Conocer cuantos inscriptos que hay desde 1/04/2014


SELECT 
    CUR.nro_curso "Curso", 
    CUR.fecha_ini "Fecha inicio", 
    CUR.salon,
    CUR.cupo,
    COUNT(INS.dni) "Cantidad de inscriptos", 
    CUR.cupo - COUNT(INS.dni) "Disponibles"
    FROM `afatse`.`inscripciones` INS
    RIGHT JOIN `afatse`.`cursos` CUR ON INS.nro_curso = CUR.nro_curso AND INS.nom_plan = CUR.nom_plan
    WHERE CUR.fecha_ini >= "2014-04-1"
	GROUP BY CUR.nom_plan, CUR.nro_curso
    HAVING (((CUR.cupo - COUNT(INS.dni)) / CUR.cupo) * 100) > 80; 
    
    
# Indicar el último incremento de los valores de los planes de capacitación, consignando
# nombre del plan fecha del valor actual, fecha el valor anterior, valor actual, valor anterior y
# diferencia entre los valores. Si el curso tiene un único valor mostrar la fecha anterior en
# NULL el valor anterior en 0 y la diferencia en 0.
DROP TEMPORARY TABLE IF EXISTS `afatse`.`tt_fecha_ultimo_valor_plan`;
CREATE TEMPORARY TABLE `afatse`.`tt_fecha_ultimo_valor_plan`
	SELECT VAL.nom_plan, MAX(VAL.fecha_desde_plan) "fecha_actual" FROM `afatse`.`valores_plan` VAL
	GROUP BY VAL.nom_plan;

DROP TEMPORARY TABLE IF EXISTS `afatse`.`tt_diferencia_dias_plan_anterior`;
CREATE TEMPORARY TABLE `afatse`.`tt_diferencia_dias_plan_anterior`
SELECT VAL.nom_plan, MIN(DATEDIFF(FUVP.fecha_actual, VAL.fecha_desde_plan)) "menor_diferencia_dias" FROM `afatse`.`valores_plan` VAL 
	LEFT JOIN `afatse`.`tt_fecha_ultimo_valor_plan` FUVP ON FUVP.nom_plan = VAL.nom_plan
	WHERE NOT DATEDIFF(FUVP.fecha_actual, VAL.fecha_desde_plan) = 0 
    GROUP BY VAL.nom_plan;
	
DROP TEMPORARY TABLE IF EXISTS `afatse`.`tt_planes_anteriores`;
CREATE TEMPORARY TABLE `afatse`.`tt_planes_anteriores`
	SELECT VAL.nom_plan, VAL.fecha_desde_plan, VAL.valor_plan FROM `afatse`.`valores_plan` VAL 
		LEFT JOIN `afatse`.`tt_fecha_ultimo_valor_plan` FUVP ON FUVP.nom_plan = VAL.nom_plan
		INNER JOIN  `afatse`.`tt_diferencia_dias_plan_anterior` DDPA ON DDPA.nom_plan = VAL.nom_plan
        WHERE DATEDIFF(FUVP.fecha_actual, VAL.fecha_desde_plan) = DDPA.menor_diferencia_dias;

SELECT * FROM `afatse`.`tt_planes_anteriores`;

	
    


    


