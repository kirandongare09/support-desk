-- MySQL dump 10.13  Distrib 5.7.20, for Linux (x86_64)
--
-- Host: localhost    Database: hms
-- ------------------------------------------------------
-- Server version	5.7.20-0ubuntu0.16.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `admin_info`
--

DROP TABLE IF EXISTS `admin_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `admin_info` (
  `admin_id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(50) NOT NULL,
  `password` varchar(150) NOT NULL,
  `name` varchar(150) NOT NULL,
  `phone_no` varchar(20) NOT NULL,
  PRIMARY KEY (`admin_id`),
  UNIQUE KEY `admin_id_UNIQUE` (`admin_id`),
  UNIQUE KEY `email_id_UNIQUE` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin_info`
--

LOCK TABLES `admin_info` WRITE;
/*!40000 ALTER TABLE `admin_info` DISABLE KEYS */;
INSERT INTO `admin_info` VALUES (1,'admin@tkietwarana.ac.in','admin123','Satyajit Bachche','9998889990');
/*!40000 ALTER TABLE `admin_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `service_call_info`
--

DROP TABLE IF EXISTS `service_call_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `service_call_info` (
  `service_call_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `engineer_id` int(5) DEFAULT NULL,
  `subject` varchar(200) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  `type` varchar(10) DEFAULT NULL,
  `catagory` varchar(20) DEFAULT NULL,
  `time_slot` varchar(45) NOT NULL,
  `priority` int(11) DEFAULT '1',
  `flag` int(11) DEFAULT '0',
  `status` int(11) DEFAULT '0',
  `cost` int(11) DEFAULT '0',
  `date` datetime DEFAULT NULL,
  `rating` int(11) DEFAULT NULL,
  `feedback` varchar(100) DEFAULT NULL,
  `otp` int(5) NOT NULL,
  `descriptionFull` varchar(100) DEFAULT '',
  `assignDate` datetime DEFAULT NULL,
  PRIMARY KEY (`service_call_id`),
  UNIQUE KEY `service_call_id_UNIQUE` (`service_call_id`),
  KEY `user_id_idx` (`user_id`),
  KEY `engineer_id_idx` (`engineer_id`),
  CONSTRAINT `engineer_id` FOREIGN KEY (`engineer_id`) REFERENCES `engineer_info` (`engineer_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `user_id` FOREIGN KEY (`user_id`) REFERENCES `user_info` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service_call_info`
--


--
-- Table structure for table `feedback_info`
--

DROP TABLE IF EXISTS `feedback_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `feedback_info` (
  `feedback_id` int(11) NOT NULL AUTO_INCREMENT,
  `service_call_id` int(11) NOT NULL,
  `text` varchar(250) NOT NULL,
  `user_id` int(11) NOT NULL,
  `engineer_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`feedback_id`),
  KEY `service_call_id_idx` (`service_call_id`),
  KEY `user_id_idx` (`user_id`),
  KEY `handymain_Id_idx` (`engineer_id`),
  CONSTRAINT `fk_feedback_info_1` FOREIGN KEY (`service_call_id`) REFERENCES `service_call_info` (`service_call_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_feedback_info_2` FOREIGN KEY (`engineer_id`) REFERENCES `engineer_info` (`engineer_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_feedback_info_3` FOREIGN KEY (`user_id`) REFERENCES `user_info` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `feedback_info`
--

LOCK TABLES `feedback_info` WRITE;
/*!40000 ALTER TABLE `feedback_info` DISABLE KEYS */;
/*!40000 ALTER TABLE `feedback_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `engineer_info`
--

DROP TABLE IF EXISTS `engineer_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `engineer_info` (
  `engineer_id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(40) NOT NULL,
  `password` varchar(150) NOT NULL,
  `name` varchar(150) NOT NULL,
  `phone_no` varchar(13) NOT NULL,
  `Catagory` varchar(13) NOT NULL,
  `slot1` int(5) DEFAULT '0',
  `slot2` int(5) DEFAULT '0',
  `slot3` int(5) DEFAULT '0',
  `issued` int(5) DEFAULT '0',
  `solved` int(5) DEFAULT '0',
  `today` int(5) DEFAULT '0',
  PRIMARY KEY (`engineer_id`),
  UNIQUE KEY `engineer_id_UNIQUE` (`engineer_id`),
  UNIQUE KEY `email_id_UNIQUE` (`email`),
  UNIQUE KEY `Phone_no_UNIQUE` (`phone_no`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `engineer_info`
--

LOCK TABLES `engineer_info` WRITE;
/*!40000 ALTER TABLE `engineer_info` DISABLE KEYS */;
INSERT INTO `engineer_info` VALUES (1,'sumitmohite@tkietwarana.ac.in','thanks123','Sumit Mohite','+918882229991','Hardware',0,0,0,0,0,0),(2,'amitjadhav@tkietwarana.ac.in','thanks123','Amit Jadhav','918889991112','Network',0,0,0,0,0,0),(3,'kirandongare@gmail.com','thanks123','Kiran Dongare','917282991112','Network',0,0,0,0,0,0);
/*!40000 ALTER TABLE `engineer_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `master_data`
--

DROP TABLE IF EXISTS `master_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `master_data` (
  `location` varchar(30) DEFAULT NULL,
  `technician` varchar(30) DEFAULT NULL,
  `equipment` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `master_data`
--

LOCK TABLES `master_data` WRITE;
/*!40000 ALTER TABLE `master_data` DISABLE KEYS */;
INSERT INTO `master_data` VALUES ('lab','Hardware','Monitor'),('lab','Hardware','CPU'),('lab','Hardware','Mouse'),('lab','Network','Modems'),('lab','Network','Hubs'),('lab','Network','Switches'),('office','Network','Routers'),('office','Network','Bridge'),('office','Network','Repeater'),('office','Hardware','Keyboard'),('lab','Hardware','Printers');
/*!40000 ALTER TABLE `master_data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_info`
--

DROP TABLE IF EXISTS `user_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_info` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(150) NOT NULL,
  `password` varchar(150) NOT NULL,
  `emp_id` varchar(150) NOT NULL,
  `phone_no` varchar(150) NOT NULL,
  `lab_name` varchar(150) NOT NULL,
  `gender` char(1) NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email_UNIQUE` (`email`),
  UNIQUE KEY `phone_no_UNIQUE` (`phone_no`),
  UNIQUE KEY `lab_name_UNIQUE` (`lab_name`),
  UNIQUE KEY `emp_id_UNIQUE` (`emp_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_info`
--

LOCK TABLES `user_info` WRITE;
/*!40000 ALTER TABLE `user_info` DISABLE KEYS */;
INSERT INTO `user_info` VALUES (1,'anilkhot@tkietwarana.ac.in','thanks123','MT2016018','8305771509','Database Lab','M','Anil Khot'),(2,'arpit.waghmare@tkietwarana.ac.in','thanks123','MT2016024','9066218124','Web Technology','M','Arpit Waghmare');
/*!40000 ALTER TABLE `user_info` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;


