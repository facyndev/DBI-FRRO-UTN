-- Practica Nº 4: GROUP BY - HAVING
-- Practica en Clase: 1 – 2 – 4 – 8 – 9 – 13 – 14 – 15
-- Práctica Complementaria: 3 – 5 – 6 – 7 – 10 – 11 – 12
-- BASE DE DATOS: AGENCIA_PERSONAL

-- **1) Mostrar las comisiones pagadas por la empresa Tráigame eso
SELECT razon_social "razon_social", sum( importe_comision ) "Comisiones Pagas"
	FROM `agencia_personal`.`empresas` E
		INNER JOIN `agencia_personal`.`solicitudes_empresas` SE 
			ON E.cuit=SE.cuit
		INNER JOIN `agencia_personal`.`contratos` C 	
			ON SE.cuit=C.cuit and SE.cod_cargo=C.cod_cargo and SE.fecha_solicitud=C.fecha_solicitud
        INNER JOIN `agencia_personal`.`comisiones` COM 
			ON C.nro_contrato=COM.nro_contrato
	WHERE razon_social="Tráigame eso" and fecha_pago IS NOT NULL ;

-- **2) Ídem 1) pero para todas las empresas.
SELECT razon_social "razon_social", sum( importe_comision ) "Comisiones Pagas"
	FROM `agencia_personal`.`empresas` E
		INNER JOIN `agencia_personal`.`solicitudes_empresas` SE 
			ON E.cuit=SE.cuit
		INNER JOIN `agencia_personal`.`contratos` C 	
			ON SE.cuit=C.cuit and SE.cod_cargo=C.cod_cargo and SE.fecha_solicitud=C.fecha_solicitud
        INNER JOIN `agencia_personal`.`comisiones` COM 
			ON C.nro_contrato=COM.nro_contrato
	WHERE fecha_pago IS NOT NULL
    GROUP BY E.cuit, E.razon_social;
    
-- 3) Mostrar el promedio, desviación estándar y varianza del puntaje de las
-- evaluaciones de entrevistas, por tipo de evaluación y entrevistador. 
-- Ordenar por promedio en forma ascendente y luego por desviación estándar en forma descendente.
-- nombre_entrevistador cod_evaluacion AVG( resul tado ) STD( resultad o ) variance(resultado)
SELECT nombre_entrevistador, desc_evaluacion, 
	AVG(EE.resultado) "Promedio",
	STD(EE.resultado) "Desvío estandar",
	VARIANCE(EE.resultado) "Varianza"
	FROM `agencia_personal`.`entrevistas` E
		INNER JOIN `agencia_personal`.`entrevistas_evaluaciones` EE 
			ON E.nro_entrevista=EE.nro_entrevista
		INNER JOIN `agencia_personal`.`evaluaciones`EVAL
			ON EE.cod_evaluacion=EVAL.cod_evaluacion
	GROUP BY nombre_entrevistador, EE.cod_evaluacion
    ORDER BY AVG(EE.resultado), STD(EE.resultado) DESC;

-- **4) Ídem 3) pero para Angélica Doria, con promedio mayor a 71. Ordenar por código
-- de evaluación.
SELECT nombre_entrevistador, desc_evaluacion, 
	AVG(EE.resultado) "Promedio",
	STD(EE.resultado) "Desvío estandar",
	VARIANCE(EE.resultado) "Varianza"
	FROM `agencia_personal`.`entrevistas` E
		INNER JOIN `agencia_personal`.`entrevistas_evaluaciones` EE 
			ON E.nro_entrevista=EE.nro_entrevista
		INNER JOIN `agencia_personal`.`evaluaciones`EVAL
			ON EE.cod_evaluacion=EVAL.cod_evaluacion
	WHERE nombre_entrevistador="Angélica Doria"
	GROUP BY nombre_entrevistador, EE.cod_evaluacion
    HAVING AVG(EE.resultado)>71
    ORDER BY AVG(EE.resultado), STD(EE.resultado) DESC;

-- 5) Cuantas entrevistas fueron hechas por cada entrevistador en octubre de 2014.
SELECT ENT.nombre_entrevistador, COUNT(ENT.nombre_entrevistador) "Cantidad de entrevistas" FROM `agencia_personal`.`entrevistas` ENT
WHERE ENT.fecha_entrevista BETWEEN "2014-10-01" AND "2014-10-31"
GROUP BY ENT.nombre_entrevistador;

-- 6) Ídem 4) pero para todos los entrevistadores. Mostrar nombre y cantidad.
-- Ordenado por cantidad de entrevistas.
SELECT E.nombre_entrevistador, EE.cod_evaluacion, 
	COUNT(*),
	AVG(EE.resultado) "Promedio",
	STD(EE.resultado) "Desvío estandar",
	VARIANCE(EE.resultado) "Varianza"
	FROM `agencia_personal`.`entrevistas` E
		INNER JOIN `agencia_personal`.`entrevistas_evaluaciones` EE 
			ON E.nro_entrevista=EE.nro_entrevista
		INNER JOIN `agencia_personal`.`evaluaciones` EVAL
			ON EE.cod_evaluacion=EVAL.cod_evaluacion
	GROUP BY nombre_entrevistador, EE.cod_evaluacion
    HAVING AVG(EE.resultado)>71
    ORDER BY COUNT(*);

-- 7) Ídem 6) para aquellos cuya 	 cantidad de entrevistas por código de evaluación
-- sea mayor que 1. Ordenado por nombre en forma descendente y por código de
-- evaluación en forma ascendente
SELECT E.nombre_entrevistador, EE.cod_evaluacion, 
	COUNT(*),
	AVG(EE.resultado) "Promedio",
	STD(EE.resultado) "Desvío estandar",
	VARIANCE(EE.resultado) "Varianza"
	FROM `agencia_personal`.`entrevistas` E
		INNER JOIN `agencia_personal`.`entrevistas_evaluaciones` EE 
			ON E.nro_entrevista=EE.nro_entrevista
		INNER JOIN `agencia_personal`.`evaluaciones` EVAL
			ON EE.cod_evaluacion=EVAL.cod_evaluacion
	GROUP BY EE.cod_evaluacion, E.nombre_entrevistador
    HAVING COUNT(*) > 1
    ORDER BY E.nombre_entrevistador DESC, EE.cod_evaluacion ASC;

-- **8) Mostrar para cada contrato cantidad total de las comisiones, cantidad a pagar,
-- cantidad pagadas.
SELECT CON.nro_contrato "contrato", 
	count(*) "Total", 
    count(fecha_pago) "pagadas", 
    count(*) - count(fecha_pago) "a pagar"
	FROM `agencia_personal`.`contratos` CON 
		INNER JOIN `agencia_personal`.`comisiones` COM 
			ON CON.nro_contrato=COM.nro_contrato
	GROUP BY CON.nro_contrato;
-- Error Code: 1140. In aggregated query without GROUP BY, 
-- expression #1 of SELECT list contains nonaggregated column 'agencia_personal.CON.nro_contrato'; this is incompatible with sql_mode=only_full_group_by
            

-- **9) Mostrar para cada contrato la cantidad de comisiones, el % de comisiones pagas y
-- el % de impagas.|
SELECT 
	CON.nro_contrato, 
    COUNT(COM.nro_contrato) "Total",  
    (COUNT(COM.fecha_pago) / COUNT(COM.nro_contrato) * 100) "pagadas",
    100 - (COUNT(COM.fecha_pago) / COUNT(COM.nro_contrato) * 100) "impagas"
    FROM `agencia_personal`.`contratos` CON
	INNER JOIN `agencia_personal`.`comisiones` COM ON COM.nro_contrato=CON.nro_contrato
	GROUP BY CON.nro_contrato;

-- 10) Mostar la cantidad de empresas diferentes que han realizado solicitudes y la
-- diferencia respecto al total de solicitudes.
SELECT COUNT(DISTINCT SOL.cuit) "Cantidad", COUNT(SOL.CUIT) - COUNT(DISTINCT SOL.cuit) "Diferencia" FROM `agencia_personal`.`solicitudes_empresas` SOL;


-- 11) Cantidad de solicitudes por empresas.
SELECT 
	SOL.cuit,
    EMP.razon_social,
    COUNT(*) "Cantidad"
    FROM `agencia_personal`.`solicitudes_empresas` SOL
    INNER JOIN `agencia_personal`.`empresas` EMP ON EMP.cuit=SOL.cuit
	GROUP BY SOL.cuit, EMP.razon_social;	

-- 12) Cantidad de solicitudes por empresas y cargos.
SELECT 
	SOL.cuit,
    EMP.razon_social,
    CAR.cod_cargo,
    COUNT(*) "Cantidad"
    FROM `agencia_personal`.`solicitudes_empresas` SOL
    INNER JOIN `agencia_personal`.`empresas` EMP ON EMP.cuit=SOL.cuit
    INNER JOIN `agencia_personal`.`cargos` CAR ON SOL.cod_cargo=CAR.cod_cargo
	GROUP BY SOL.cuit, EMP.razon_social, CAR.cod_cargo;

-- LEFT/RIGHT JOIN
-- **13) Listar las empresas, indicando todos sus datos y la cantidad de personas diferentes
-- que han mencionado dicha empresa como antecedente laboral. Si alguna empresa NO fue
-- mencionada como antecedente laboral deberá indicar 0 en la cantidad de personas.
SELECT EMP.*, COUNT(DISTINCT ANT.dni) "Cantidad de personas" FROM `agencia_personal`.`empresas` EMP
LEFT JOIN `agencia_personal`.`antecedentes` ANT ON EMP.cuit=ANT.cuit
GROUP BY EMP.cuit;

-- **14) Indicar para cada cargo la cantidad de veces que fue solicitado. Ordenado en
-- forma descendente por cantidad de solicitudes. Si un cargo nunca fue solicitado, mostrar
-- 0. 
SELECT CAR.cod_cargo, CAR.desc_cargo, COUNT(SOL.cod_cargo) "Cantidad de solicitudes" FROM `agencia_personal`.`cargos` CAR
LEFT JOIN `agencia_personal`.`solicitudes_empresas` SOL ON CAR.cod_cargo=SOL.cod_cargo
GROUP BY CAR.cod_cargo
ORDER BY COUNT(SOL.cod_cargo) DESC;

-- **15) Indicar los cargos que hayan sido solicitados menos de 2 veces
SELECT CAR.cod_cargo, CAR.desc_cargo, COUNT(SOL.cod_cargo) "Cantidad de solicitudes" FROM `agencia_personal`.`cargos` CAR
LEFT JOIN `agencia_personal`.`solicitudes_empresas` SOL ON CAR.cod_cargo=SOL.cod_cargo
GROUP BY CAR.cod_cargo
HAVING COUNT(SOL.cod_cargo) < 2
ORDER BY COUNT(SOL.cod_cargo) DESC;
