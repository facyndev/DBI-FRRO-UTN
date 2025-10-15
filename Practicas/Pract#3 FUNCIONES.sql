-- Práctica Nº 3: Funciones de presentación de datos
-- Practica Complementaria: 1 – 2 – 3 – 4 – 5
-- BASE DE DATOS: AGENCIA_PERSONAL

-- 1) Para aquellos contratos que no hayan terminado, calcular la fecha de caducidad
-- como la fecha de solicitud más 30 días (no actualizar la base de datos). Función ADDDATE
SELECT nro_contrato, fecha_incorporacion, fecha_finalizacion_contrato, ifnull(fecha_caducidad, adddate(fecha_solicitud, INTERVAL 30 DAY)) "Fecha Caducidad" FROM `agencia_personal`.`contratos`
	WHERE fecha_caducidad IS NULL;

-- 2) Mostrar los contratos. Indicar nombre y apellido de la persona, razón social de la
-- empresa fecha de inicio del contrato y fecha de caducidad del contrato. Si la fecha no ha
-- terminado mostrar “Contrato Vigente”. Función IFNULL
SELECT 
	CON.nro_contrato "Nro Contrato",
	PER.nombre "Nombre", 
    PER.apellido "Apellido", 
    EMP.razon_social "Razon Social", 
    CON.fecha_incorporacion "Fecha Inicio",
    IFNULL(CON.fecha_caducidad, "Contrato Vigente") "Fecha Caducidad"
    FROM `agencia_personal`.`contratos` CON
	INNER JOIN `agencia_personal`.`personas` PER ON PER.dni=CON.dni
    INNER JOIN `agencia_personal`.`empresas` EMP ON EMP.cuit=CON.cuit;
	



-- 3) Para aquellos contratos que terminaron antes de la fecha de finalización, indicar la
-- cantidad de días que finalizaron antes de tiempo. Función DATEDIFF
SELECT 
	CON.nro_contrato "Nro Contrato",
	PER.nombre "Nombre", 
    PER.apellido "Apellido", 
    EMP.razon_social "Razon Social", 
    CON.fecha_incorporacion "Fecha Inicio",
    CON.fecha_finalizacion_contrato "Fecha Finalizacion",
    IFNULL(CON.fecha_caducidad, "Contrato Vigente") "Fecha Caducidad",
    DATEDIFF(CON.fecha_finalizacion_contrato, CON.fecha_caducidad)
    FROM `agencia_personal`.`contratos` CON
	INNER JOIN `agencia_personal`.`personas` PER ON PER.dni=CON.dni
    INNER JOIN `agencia_personal`.`empresas` EMP ON EMP.cuit=CON.cuit
    WHERE CON.fecha_caducidad < CON.fecha_finalizacion_contrato;


-- 4) Emitir un listado de comisiones impagas para cobrar. Indicar cuit, razón social de la
-- empresa y dirección, año y mes de la comisión, importe y la fecha de vencimiento que se
-- calcula como la fecha actual más dos meses. Función ADDDATE con INTERVAL
SELECT EMP.cuit, EMP.razon_social, EMP.direccion, COM.anio_contrato, COM.mes_contrato, COM.importe_comision, adddate(CURDATE(), INTERVAL 2 MONTH) fecha_vencimiento
FROM `agencia_personal`.`comisiones` COM
INNER JOIN `agencia_personal`.`contratos` CON ON COM.nro_contrato=CON.nro_contrato
INNER JOIN `agencia_personal`.`empresas` EMP ON CON.cuit=EMP.cuit
WHERE COM.fecha_pago IS NULL;


-- 5) Mostrar en qué día mes y año nacieron las personas (mostrarlos en columnas
-- separadas) y sus nombres y apellidos concatenados. Funciones DAY, YEAR, MONTH y CONCAT
SELECT 
	CONCAT(PER.nombre, " ", PER.apellido) "Nombre y apellido", 
    PER.fecha_nacimiento "Fecha Nacimiento",
    DAY(PER.fecha_nacimiento) "Dia",
    MONTH(PER.fecha_nacimiento) "Mes",
    YEAR(PER.fecha_nacimiento) "Año"
    FROM `agencia_personal`.`personas` PER;
