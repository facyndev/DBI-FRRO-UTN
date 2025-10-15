CREATE DATABASE  IF NOT EXISTS `agencia_personal` /*!40100 DEFAULT CHARACTER SET utf8mb3 */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `agencia_personal`;
-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: agencia_personal
-- ------------------------------------------------------
-- Server version	8.0.41

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `antecedentes`
--

DROP TABLE IF EXISTS `antecedentes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `antecedentes` (
  `dni` varchar(20) NOT NULL,
  `cod_cargo` int NOT NULL,
  `cuit` varchar(20) NOT NULL,
  `fecha_desde` date NOT NULL,
  `fecha_hasta` date DEFAULT NULL,
  `persona_contacto` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`dni`,`cod_cargo`,`cuit`,`fecha_desde`),
  KEY `cuit` (`cuit`),
  KEY `trabajo_cargos_fk` (`cod_cargo`),
  CONSTRAINT `trabajo_cargos_fk` FOREIGN KEY (`cod_cargo`) REFERENCES `cargos` (`cod_cargo`) ON UPDATE CASCADE,
  CONSTRAINT `trabajo_empresas_fk` FOREIGN KEY (`cuit`) REFERENCES `empresas` (`cuit`) ON UPDATE CASCADE,
  CONSTRAINT `trabajo_personas_fk` FOREIGN KEY (`dni`) REFERENCES `personas` (`dni`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `antecedentes`
--

LOCK TABLES `antecedentes` WRITE;
/*!40000 ALTER TABLE `antecedentes` DISABLE KEYS */;
INSERT INTO `antecedentes` VALUES ('27890765',2,'30-20987654-4','2005-03-01',NULL,'Belen Arisa'),('27890765',6,'30-21098732-4','2005-01-05','2013-12-31','Juan Perez'),('28675888',2,'30-20987654-4','2004-06-01','2013-08-31','Belen Arisa'),('28675888',3,'30-20987654-4','2013-09-01','2014-11-16','Belen Arisa'),('29345777',4,'30-15876543-4','2013-01-01',NULL,'Armando Esteban Quito'),('29345777',5,'30-15876543-4','2005-04-01','2005-12-31','Armando Esteban Quito'),('30425782',6,'30-21098732-4','2005-01-05','2013-12-31','Juan Perez'),('30987654',6,'30-10504876-5','2014-04-15',NULL,NULL),('30987654',8,'30-21098732-4','2003-08-01','2013-04-14','Felipe Rojas'),('31345778',7,'30-23456328-5','2014-06-01',NULL,'Alicia Ramos');
/*!40000 ALTER TABLE `antecedentes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cargos`
--

DROP TABLE IF EXISTS `cargos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cargos` (
  `cod_cargo` int NOT NULL,
  `desc_cargo` varchar(50) NOT NULL,
  PRIMARY KEY (`cod_cargo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cargos`
--

LOCK TABLES `cargos` WRITE;
/*!40000 ALTER TABLE `cargos` DISABLE KEYS */;
INSERT INTO `cargos` VALUES (1,'cadete'),(2,'mozo'),(3,'cocinero'),(4,'organizador de eventos'),(5,'decorador'),(6,'Jefe de Desarrollo'),(7,'Director de Obras'),(8,'Programador');
/*!40000 ALTER TABLE `cargos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comisiones`
--

DROP TABLE IF EXISTS `comisiones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comisiones` (
  `nro_contrato` int NOT NULL,
  `anio_contrato` int NOT NULL,
  `mes_contrato` int NOT NULL,
  `fecha_pago` date DEFAULT NULL,
  `importe_comision` decimal(9,3) DEFAULT NULL,
  PRIMARY KEY (`nro_contrato`,`anio_contrato`,`mes_contrato`),
  CONSTRAINT `comisiones_contrato_fk` FOREIGN KEY (`nro_contrato`) REFERENCES `contratos` (`nro_contrato`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comisiones`
--

LOCK TABLES `comisiones` WRITE;
/*!40000 ALTER TABLE `comisiones` DISABLE KEYS */;
INSERT INTO `comisiones` VALUES (1,2014,11,'2014-12-03',120.000),(1,2014,12,'2015-01-05',120.000),(1,2015,1,'2015-02-03',120.000),(1,2015,2,NULL,120.000),(3,2014,11,'2014-11-30',176.000),(3,2014,12,'2014-12-28',176.000),(3,2015,1,'2015-01-26',176.000),(3,2015,2,'2015-01-26',176.000),(4,2014,12,'2015-02-01',247.000),(4,2015,1,NULL,247.000),(4,2015,2,NULL,247.000),(5,2015,1,'2015-02-01',288.820),(5,2015,2,NULL,288.820),(6,2015,1,NULL,1174.000),(6,2015,2,NULL,1174.000);
/*!40000 ALTER TABLE `comisiones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contratos`
--

DROP TABLE IF EXISTS `contratos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contratos` (
  `nro_contrato` int NOT NULL AUTO_INCREMENT,
  `fecha_incorporacion` date NOT NULL,
  `fecha_finalizacion_contrato` date DEFAULT NULL,
  `fecha_caducidad` date DEFAULT NULL,
  `sueldo` decimal(9,3) NOT NULL,
  `porcentaje_comision` decimal(9,3) NOT NULL,
  `dni` varchar(20) NOT NULL,
  `cuit` varchar(20) NOT NULL,
  `cod_cargo` int NOT NULL,
  `fecha_solicitud` date NOT NULL,
  PRIMARY KEY (`nro_contrato`),
  KEY `dni` (`dni`),
  KEY `cuit` (`cuit`,`cod_cargo`,`fecha_solicitud`),
  CONSTRAINT `contratos_personas_fk` FOREIGN KEY (`dni`) REFERENCES `personas` (`dni`) ON UPDATE CASCADE,
  CONSTRAINT `contratos_solicitudes_empresas_fk` FOREIGN KEY (`cuit`, `cod_cargo`, `fecha_solicitud`) REFERENCES `solicitudes_empresas` (`cuit`, `cod_cargo`, `fecha_solicitud`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contratos`
--

LOCK TABLES `contratos` WRITE;
/*!40000 ALTER TABLE `contratos` DISABLE KEYS */;
INSERT INTO `contratos` VALUES (1,'2014-11-01','2015-12-26',NULL,1200.000,10.000,'27890765','30-21008765-5',2,'2014-09-20'),(3,'2014-11-15','2015-12-24',NULL,1600.000,11.000,'28675888','30-10504876-5',3,'2014-09-21'),(4,'2014-12-01','2015-12-16','2015-12-15',1900.000,13.000,'29345777','30-10504876-5',4,'2014-09-13'),(5,'2015-01-02','2015-12-24','2015-03-12',2063.000,14.000,'29345777','30-10504876-5',5,'2014-09-21'),(6,'2015-01-02','2015-12-24',NULL,5870.000,20.000,'30987654','30-21098732-4',6,'2014-09-23'),(7,'2015-01-02','2014-09-24','2015-12-24',5870.000,20.000,'28675888','30-10504876-5',3,'2014-09-21');
/*!40000 ALTER TABLE `contratos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `emp_cont_stefania`
--

DROP TABLE IF EXISTS `emp_cont_stefania`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `emp_cont_stefania` (
  `nro_contrato` int NOT NULL DEFAULT '0',
  `dni` varchar(20) NOT NULL,
  `cuit` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `emp_cont_stefania`
--

LOCK TABLES `emp_cont_stefania` WRITE;
/*!40000 ALTER TABLE `emp_cont_stefania` DISABLE KEYS */;
INSERT INTO `emp_cont_stefania` VALUES (3,'28675888','30-10504876-5'),(7,'28675888','30-10504876-5');
/*!40000 ALTER TABLE `emp_cont_stefania` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `empresas`
--

DROP TABLE IF EXISTS `empresas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `empresas` (
  `cuit` varchar(20) NOT NULL,
  `razon_social` varchar(50) NOT NULL,
  `direccion` varchar(50) NOT NULL,
  `telefono` varchar(20) NOT NULL,
  `e_mail` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`cuit`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `empresas`
--

LOCK TABLES `empresas` WRITE;
/*!40000 ALTER TABLE `empresas` DISABLE KEYS */;
INSERT INTO `empresas` VALUES ('30-10504876-5','Viejos Amigos','Buenos Aires 4444','4444444','rrhh@viejosamigos.com.ar'),('30-15876543-4','Reuniones Improvisadas','Oroño 3333','4576879',NULL),('30-20987654-4','Porciones Reducidas','Viedma 1830','4556677',NULL),('30-21008765-5','Traigame eso','Zeballos 7456','4455667','traigameeso@gmail.com'),('30-21098732-4','Informatiks srl','Dorrego 2213 4 A','4857339','info@informatiks.biz'),('30-23456328-5','Constructora Gaia S.A.','Tucuman 649 PA','4647125',NULL);
/*!40000 ALTER TABLE `empresas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `entrevistas`
--

DROP TABLE IF EXISTS `entrevistas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `entrevistas` (
  `nro_entrevista` int NOT NULL,
  `fecha_entrevista` date NOT NULL,
  `hora_entrevista` time NOT NULL,
  `nombre_entrevistador` varchar(50) NOT NULL,
  `resultado_final` varchar(20) DEFAULT NULL,
  `dni` varchar(20) NOT NULL,
  `cuit` varchar(20) NOT NULL,
  `cod_cargo` int NOT NULL,
  `fecha_solicitud` date NOT NULL,
  PRIMARY KEY (`nro_entrevista`),
  KEY `dni` (`dni`),
  KEY `cuit` (`cuit`,`cod_cargo`,`fecha_solicitud`),
  CONSTRAINT `entrevistas_fk` FOREIGN KEY (`cuit`, `cod_cargo`, `fecha_solicitud`) REFERENCES `solicitudes_empresas` (`cuit`, `cod_cargo`, `fecha_solicitud`) ON UPDATE CASCADE,
  CONSTRAINT `entrevistas_personas_fk` FOREIGN KEY (`dni`) REFERENCES `personas` (`dni`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `entrevistas`
--

LOCK TABLES `entrevistas` WRITE;
/*!40000 ALTER TABLE `entrevistas` DISABLE KEYS */;
INSERT INTO `entrevistas` VALUES (1,'2014-10-09','18:00:00','Raul Somias','Apto','27890765','30-21008765-5',2,'2014-09-20'),(2,'2014-10-09','18:30:00','Tomas Sanchez','Apto','28675888','30-21008765-5',2,'2014-09-20'),(3,'2014-10-07','18:00:00','Angelica Doria','Apto','28675888','30-10504876-5',3,'2014-09-21'),(4,'2014-09-29','18:00:00','Angelica Doria','Apto','29345777','30-10504876-5',4,'2014-09-13'),(5,'2014-10-07','18:30:00','Angelica Doria','Apto','29345777','30-10504876-5',5,'2014-09-21'),(6,'2014-10-09','19:00:00','Tomas Sanchez','Apto','30987654','30-21098732-4',6,'2014-09-23');
/*!40000 ALTER TABLE `entrevistas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `entrevistas_evaluaciones`
--

DROP TABLE IF EXISTS `entrevistas_evaluaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `entrevistas_evaluaciones` (
  `nro_entrevista` int NOT NULL,
  `cod_evaluacion` int NOT NULL,
  `resultado` int NOT NULL,
  PRIMARY KEY (`nro_entrevista`,`cod_evaluacion`),
  KEY `nro_entrevista` (`nro_entrevista`),
  KEY `cod_evaluacion` (`cod_evaluacion`),
  CONSTRAINT `incluyen_entrevistas_fk` FOREIGN KEY (`nro_entrevista`) REFERENCES `entrevistas` (`nro_entrevista`) ON UPDATE CASCADE,
  CONSTRAINT `incluyen_evaluaciones_fk` FOREIGN KEY (`cod_evaluacion`) REFERENCES `evaluaciones` (`cod_evaluacion`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `entrevistas_evaluaciones`
--

LOCK TABLES `entrevistas_evaluaciones` WRITE;
/*!40000 ALTER TABLE `entrevistas_evaluaciones` DISABLE KEYS */;
INSERT INTO `entrevistas_evaluaciones` VALUES (1,1,80),(1,2,67),(1,3,82),(2,1,63),(2,2,72),(2,3,69),(3,1,67),(3,2,78),(3,3,81),(4,1,64),(4,2,57),(4,3,61),(5,1,81),(5,2,88),(5,3,73),(6,1,91),(6,2,95),(6,3,84);
/*!40000 ALTER TABLE `entrevistas_evaluaciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `evaluaciones`
--

DROP TABLE IF EXISTS `evaluaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `evaluaciones` (
  `cod_evaluacion` int NOT NULL,
  `desc_evaluacion` varchar(50) NOT NULL,
  PRIMARY KEY (`cod_evaluacion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `evaluaciones`
--

LOCK TABLES `evaluaciones` WRITE;
/*!40000 ALTER TABLE `evaluaciones` DISABLE KEYS */;
INSERT INTO `evaluaciones` VALUES (1,'Test de Personalidad'),(2,'Test de Aptitud y Eficiencia'),(3,'Test de Inteligencia');
/*!40000 ALTER TABLE `evaluaciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `personas`
--

DROP TABLE IF EXISTS `personas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `personas` (
  `dni` varchar(20) NOT NULL,
  `apellido` varchar(30) NOT NULL,
  `nombre` varchar(30) NOT NULL,
  `fecha_nacimiento` date NOT NULL,
  `fecha_registro_agencia` date NOT NULL,
  `direccion` varchar(50) DEFAULT NULL,
  `Telefono` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`dni`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `personas`
--

LOCK TABLES `personas` WRITE;
/*!40000 ALTER TABLE `personas` DISABLE KEYS */;
INSERT INTO `personas` VALUES ('27890765','Garcia','Eliseo','1981-01-10','2014-06-13','Tucuman 1111 piso 1 dpto 1','4641198'),('28675888','Lopez','Stefan�a','1982-05-20','2005-12-12','San Juan 3498','154876398'),('29345777','Wingdam','Raul','1983-03-01','2014-07-15','Juan Manuel de Rosas 1981','155287433'),('30425782','Losteau','Pedro','1982-08-25','2015-02-26','Laines 765','4854431'),('30987654','Guftafson','Juana','1984-07-02','2014-08-12','Arijon 3','4378900'),('31345778','Ruiz','Aquiles','1982-02-01','2014-06-18','Avellaneda 1165','4678922');
/*!40000 ALTER TABLE `personas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `personas_titulos`
--

DROP TABLE IF EXISTS `personas_titulos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `personas_titulos` (
  `dni` varchar(20) NOT NULL,
  `cod_titulo` int NOT NULL,
  `fecha_graduacion` date DEFAULT NULL,
  PRIMARY KEY (`dni`,`cod_titulo`),
  KEY `cod_titulo` (`cod_titulo`),
  CONSTRAINT `tienen_personas_fk` FOREIGN KEY (`dni`) REFERENCES `personas` (`dni`) ON UPDATE CASCADE,
  CONSTRAINT `tienen_titulos_fk` FOREIGN KEY (`cod_titulo`) REFERENCES `titulos` (`cod_titulo`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `personas_titulos`
--

LOCK TABLES `personas_titulos` WRITE;
/*!40000 ALTER TABLE `personas_titulos` DISABLE KEYS */;
INSERT INTO `personas_titulos` VALUES ('27890765',6,'2001-07-05'),('27890765',8,'1998-11-23'),('28675888',8,'2000-03-02'),('29345777',2,'2003-12-02'),('29345777',4,'2002-12-02'),('29345777',8,'2000-12-02'),('30425782',7,'2014-12-25'),('30987654',1,'2001-12-03'),('30987654',7,'2014-06-05'),('31345778',3,'1999-11-29'),('31345778',5,'2011-12-25');
/*!40000 ALTER TABLE `personas_titulos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `solicitudes_empresas`
--

DROP TABLE IF EXISTS `solicitudes_empresas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `solicitudes_empresas` (
  `cuit` varchar(20) NOT NULL,
  `cod_cargo` int NOT NULL,
  `fecha_solicitud` date NOT NULL,
  `anios_experiencia` int DEFAULT NULL,
  `edad_minima` int DEFAULT NULL,
  `edad_maxima` int DEFAULT NULL,
  `sexo` varchar(9) DEFAULT NULL,
  PRIMARY KEY (`cuit`,`cod_cargo`,`fecha_solicitud`),
  KEY `cuit` (`cuit`),
  KEY `solicita_cargos_fk` (`cod_cargo`),
  CONSTRAINT `solicita_cargos_fk` FOREIGN KEY (`cod_cargo`) REFERENCES `cargos` (`cod_cargo`) ON UPDATE CASCADE,
  CONSTRAINT `solicita_empresas_fk` FOREIGN KEY (`cuit`) REFERENCES `empresas` (`cuit`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `solicitudes_empresas`
--

LOCK TABLES `solicitudes_empresas` WRITE;
/*!40000 ALTER TABLE `solicitudes_empresas` DISABLE KEYS */;
INSERT INTO `solicitudes_empresas` VALUES ('30-10504876-5',3,'2014-09-21',NULL,NULL,NULL,NULL),('30-10504876-5',4,'2014-09-13',NULL,NULL,NULL,NULL),('30-10504876-5',5,'2014-09-21',1,25,65,NULL),('30-21008765-5',1,'2014-09-23',NULL,NULL,NULL,NULL),('30-21008765-5',2,'2014-09-20',NULL,NULL,NULL,'Femenino'),('30-21098732-4',6,'2014-01-09',NULL,NULL,NULL,NULL),('30-21098732-4',6,'2014-09-23',NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `solicitudes_empresas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `titulos`
--

DROP TABLE IF EXISTS `titulos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `titulos` (
  `cod_titulo` int NOT NULL,
  `desc_titulo` varchar(50) NOT NULL,
  `tipo_titulo` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`cod_titulo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `titulos`
--

LOCK TABLES `titulos` WRITE;
/*!40000 ALTER TABLE `titulos` DISABLE KEYS */;
INSERT INTO `titulos` VALUES (1,'Tecnico Electronico','Secundario'),(2,'Diseñador de Interiores','Terciario'),(3,'Tecnico Mecanico','Secundario'),(4,'Payaso de Circo','Educacion no formal'),(5,'Arquitecto','Universitario'),(6,'Entrenado de Lemures','Educacion no formal'),(7,'Ing en Sist de Inf','Universitario'),(8,'Bachiller','Secundario');
/*!40000 ALTER TABLE `titulos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'agencia_personal'
--

--
-- Dumping routines for database 'agencia_personal'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-04-21  9:39:53
