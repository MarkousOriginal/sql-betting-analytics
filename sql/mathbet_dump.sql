-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: localhost    Database: mathbet
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
-- Temporary view structure for view `countries_excel`
--

DROP TABLE IF EXISTS `countries_excel`;
/*!50001 DROP VIEW IF EXISTS `countries_excel`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `countries_excel` AS SELECT 
 1 AS `country`,
 1 AS `total_deposits`,
 1 AS `total_withdrawals`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `daily_summary`
--

DROP TABLE IF EXISTS `daily_summary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `daily_summary` (
  `summary_date` date NOT NULL,
  `total_deposits` decimal(10,2) DEFAULT NULL,
  `total_withdrawals` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`summary_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `daily_summary`
--

LOCK TABLES `daily_summary` WRITE;
/*!40000 ALTER TABLE `daily_summary` DISABLE KEYS */;
INSERT INTO `daily_summary` VALUES ('2025-04-17',0.00,1000.00),('2025-04-19',0.00,0.00);
/*!40000 ALTER TABLE `daily_summary` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `game_event`
--

DROP TABLE IF EXISTS `game_event`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `game_event` (
  `game_id` int NOT NULL AUTO_INCREMENT,
  `sport_type` varchar(45) NOT NULL,
  `tournament` varchar(60) NOT NULL,
  `match_date` datetime NOT NULL,
  `results` enum('1','X','2') DEFAULT NULL,
  `entos_edras` int NOT NULL,
  `ektos_edras` int NOT NULL,
  PRIMARY KEY (`game_id`),
  KEY `fk_game_entos_idx` (`entos_edras`),
  KEY `fk_game_ektos_idx` (`ektos_edras`),
  CONSTRAINT `fk_game_ektos` FOREIGN KEY (`ektos_edras`) REFERENCES `teams` (`team_id`),
  CONSTRAINT `fk_game_entos` FOREIGN KEY (`entos_edras`) REFERENCES `teams` (`team_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game_event`
--

LOCK TABLES `game_event` WRITE;
/*!40000 ALTER TABLE `game_event` DISABLE KEYS */;
INSERT INTO `game_event` VALUES (1,'football','super league','2025-04-16 00:00:00','1',1,3),(2,'basketball','basketball league','2025-04-16 00:00:00','1',2,4),(3,'football','super league','2025-04-16 00:00:00','2',5,7),(4,'football','super league','2025-04-16 00:00:00','X',9,11),(5,'basketball','basketball league','2025-04-16 00:00:00','1',6,8),(6,'football','super league','2025-04-16 00:00:00','2',13,15),(7,'football','super league','2025-04-16 00:00:00','X',17,19),(8,'football','super league','2025-04-16 00:00:00','1',21,23),(9,'basketball','basketball league','2025-04-16 00:00:00','2',10,12),(10,'basketball','basketball league','2025-04-16 00:00:00','1',14,16),(11,'basketball','basketball league','2025-04-16 00:00:00','2',18,20);
/*!40000 ALTER TABLE `game_event` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `update_winners_balance` AFTER UPDATE ON `game_event` FOR EACH ROW BEGIN
    IF OLD.results IS NULL AND NEW.results IS NOT NULL THEN
        UPDATE pelates p
        JOIN stoixhmata s ON p.customer_id = s.customers_id
        SET p.acc_amount = p.acc_amount + s.potential_earnings
        WHERE s.game_id = NEW.game_id
			AND s.results_prediction = NEW.results;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Temporary view structure for view `game_event_odds_stats`
--

DROP TABLE IF EXISTS `game_event_odds_stats`;
/*!50001 DROP VIEW IF EXISTS `game_event_odds_stats`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `game_event_odds_stats` AS SELECT 
 1 AS `game_id`,
 1 AS `sport_type`,
 1 AS `tournament`,
 1 AS `match_date`,
 1 AS `max_odds`,
 1 AS `min_odds`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `high_earnings_customers`
--

DROP TABLE IF EXISTS `high_earnings_customers`;
/*!50001 DROP VIEW IF EXISTS `high_earnings_customers`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `high_earnings_customers` AS SELECT 
 1 AS `customer_id`,
 1 AS `name`,
 1 AS `total_profit`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `high_risk_customers`
--

DROP TABLE IF EXISTS `high_risk_customers`;
/*!50001 DROP VIEW IF EXISTS `high_risk_customers`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `high_risk_customers` AS SELECT 
 1 AS `customer_id`,
 1 AS `name`,
 1 AS `average_odds`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `pelates`
--

DROP TABLE IF EXISTS `pelates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pelates` (
  `customer_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `dateofbirth` date NOT NULL,
  `countryoforigin` varchar(60) NOT NULL,
  `registerdate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `acc_amount` decimal(10,2) NOT NULL,
  `lastloginhour` datetime DEFAULT NULL,
  PRIMARY KEY (`customer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pelates`
--

LOCK TABLES `pelates` WRITE;
/*!40000 ALTER TABLE `pelates` DISABLE KEYS */;
INSERT INTO `pelates` VALUES (1,'makrhs','1998-09-30','greece','2025-04-15 00:28:07',10500.00,NULL),(2,'pelekidou','2001-07-16','albania','2025-04-15 00:28:07',3000.00,NULL),(3,'stella','2000-10-22','america','2025-04-15 00:28:07',4950.00,NULL),(4,'bassalos','1980-10-20','greece','2025-04-15 14:19:57',7022.50,NULL),(5,'bakoulas','2001-04-12','spain','2025-04-15 14:19:57',7500.00,NULL),(6,'akhs','1998-08-16','italy','2025-04-15 14:19:57',8577.00,NULL),(7,'giannis','1999-05-08','france','2025-04-15 14:19:57',7074.00,NULL),(8,'giannis','2001-10-05','portugal','2025-04-15 14:19:57',5225.00,NULL),(9,'myrofora','1997-07-16','germany','2025-04-15 14:19:57',1357.00,NULL),(10,'charoulla','2001-11-25','cyprus','2025-04-15 14:24:27',7726.53,NULL),(11,'ioanna','2000-08-18','japan','2025-04-15 14:24:27',10457.91,NULL);
/*!40000 ALTER TABLE `pelates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stoixhmata`
--

DROP TABLE IF EXISTS `stoixhmata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stoixhmata` (
  `bet_id` int NOT NULL AUTO_INCREMENT,
  `amount` decimal(10,2) NOT NULL,
  `odds` float NOT NULL,
  `results_prediction` enum('1','X','2') NOT NULL,
  `potential_earnings` decimal(10,2) GENERATED ALWAYS AS ((`amount` * `odds`)) STORED,
  `bet_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `customers_id` int NOT NULL,
  `game_id` int NOT NULL,
  PRIMARY KEY (`bet_id`),
  KEY `fk_stoixhmata_customer_idx` (`customers_id`),
  KEY `fk_stoixhmata_game_idx` (`game_id`),
  CONSTRAINT `fk_stoixhmata_customer` FOREIGN KEY (`customers_id`) REFERENCES `pelates` (`customer_id`),
  CONSTRAINT `fk_stoixhmata_game` FOREIGN KEY (`game_id`) REFERENCES `game_event` (`game_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stoixhmata`
--

LOCK TABLES `stoixhmata` WRITE;
/*!40000 ALTER TABLE `stoixhmata` DISABLE KEYS */;
INSERT INTO `stoixhmata` (`bet_id`, `amount`, `odds`, `results_prediction`, `bet_date`, `customers_id`, `game_id`) VALUES (1,1000.00,1.5,'1','2025-04-15 12:14:36',1,1),(2,2000.00,1.15,'2','2025-04-15 12:15:05',2,2),(3,50.00,1.7,'X','2025-04-15 12:49:00',3,3),(4,15.00,2.5,'X','2025-04-15 12:49:00',4,4),(5,500.00,1.07,'2','2025-04-15 12:49:00',5,5),(6,423.00,1.46,'1','2025-04-15 12:49:00',6,6),(7,426.00,1.78,'1','2025-04-15 12:49:00',7,7),(8,775.00,1.98,'X','2025-04-15 12:49:00',8,8),(9,643.00,2.45,'1','2025-04-15 12:49:00',9,9),(10,679.00,2.07,'1','2025-04-15 12:49:00',10,10),(11,873.00,2.67,'2','2025-04-15 12:50:03',11,11);
/*!40000 ALTER TABLE `stoixhmata` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `check_balance_before_bet` BEFORE INSERT ON `stoixhmata` FOR EACH ROW BEGIN
  DECLARE ypoloipo DECIMAL(10,2);

IF NEW.amount <= 0 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Το ποσό του στοιχήματος πρέπει να είναι θετικό.';
  END IF;
  
  SELECT acc_amount INTO ypoloipo
  FROM pelates
  WHERE customer_id = NEW.customers_id;

  IF NEW.amount > ypoloipo THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Ανεπαρκές υπόλοιπο για το στοίχημα.';
  ELSE
    UPDATE pelates
    SET acc_amount = acc_amount - NEW.amount
    WHERE customer_id = NEW.customers_id;
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `synalages`
--

DROP TABLE IF EXISTS `synalages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `synalages` (
  `transaction_id` int NOT NULL AUTO_INCREMENT,
  `date_of_transaction` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ammountoftran` decimal(10,2) NOT NULL,
  `currency` varchar(45) NOT NULL,
  `typos` enum('Katathesh','analhpsh','stoixhma') NOT NULL,
  `customer_id` int NOT NULL,
  PRIMARY KEY (`transaction_id`),
  KEY `fk_synalages_customer_idx` (`customer_id`),
  CONSTRAINT `fk_synalages_customer` FOREIGN KEY (`customer_id`) REFERENCES `pelates` (`customer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `synalages`
--

LOCK TABLES `synalages` WRITE;
/*!40000 ALTER TABLE `synalages` DISABLE KEYS */;
INSERT INTO `synalages` VALUES (1,'2025-04-15 12:02:23',10000.00,'euro','Katathesh',1),(30,'2025-04-15 12:12:46',5000.00,'albanian lek','Katathesh',2),(31,'2025-04-15 12:12:46',5000.00,'dolars','Katathesh',3),(32,'2025-04-15 12:12:46',7000.00,'euro','Katathesh',4),(33,'2025-04-15 12:12:46',8000.00,'euro','Katathesh',5),(34,'2025-04-15 12:12:46',9000.00,'euro','Katathesh',6),(35,'2025-04-15 12:12:46',7500.00,'euro','Katathesh',7),(36,'2025-04-15 12:12:46',6000.00,'euro','Katathesh',8),(37,'2025-04-15 12:12:46',2000.00,'euro','Katathesh',9),(38,'2025-04-15 12:12:46',8000.00,'euro','Katathesh',10),(39,'2025-04-15 12:12:46',9000.00,'japanese yen','Katathesh',11),(40,'2025-04-15 12:14:36',1000.00,'euro','stoixhma',1),(41,'2025-04-15 12:15:05',2000.00,'albanian lek','stoixhma',2),(42,'2025-04-15 12:49:00',50.00,'dolars','stoixhma',3),(43,'2025-04-15 12:49:00',15.00,'euro','stoixhma',4),(44,'2025-04-15 12:49:00',500.00,'euro','stoixhma',5),(45,'2025-04-15 12:49:00',423.00,'euro','stoixhma',6),(46,'2025-04-15 12:49:00',426.00,'euro','stoixhma',7),(47,'2025-04-15 12:49:00',775.00,'euro','stoixhma',8),(48,'2025-04-15 12:49:00',643.00,'euro','stoixhma',9),(49,'2025-04-15 12:49:00',679.00,'euro','stoixhma',10),(50,'2025-04-15 12:50:03',873.00,'japanese yen','stoixhma',11),(51,'2025-04-17 13:42:56',1000.00,'euro','analhpsh',10);
/*!40000 ALTER TABLE `synalages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `teams`
--

DROP TABLE IF EXISTS `teams`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `teams` (
  `team_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(60) NOT NULL,
  `country` varchar(45) NOT NULL,
  `sport_type` varchar(45) NOT NULL,
  PRIMARY KEY (`team_id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `teams`
--

LOCK TABLES `teams` WRITE;
/*!40000 ALTER TABLE `teams` DISABLE KEYS */;
INSERT INTO `teams` VALUES (1,'panathinaikos','greece','football'),(2,'panathinaikos','greece','basketball'),(3,'olympiakos','greece','football'),(4,'olympiakos','greece','basketball'),(5,'aek','greece','football'),(6,'aek','greece','basketball'),(7,'paok','greece','footbal'),(8,'paok','greece','basketball'),(9,'arhs','greece','football'),(10,'arhs','greece','basketball'),(11,'panionios','greece','football'),(12,'panionios','greece','basketball'),(13,'hraklhs','greece','football'),(14,'hraklhs','greece','basketball'),(15,'patra','greece','football'),(16,'patra','greece','basketball'),(17,'athina','greece','football'),(18,'athina','greece','basketball'),(19,'assoe','greece','football'),(20,'assoe','greece','basketball'),(21,'ekpa','greece','football'),(22,'ekpa','greece','basketball'),(23,'lamia','greece','football'),(24,'lamia','greece','basketball');
/*!40000 ALTER TABLE `teams` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `view_etairia_kerdos`
--

DROP TABLE IF EXISTS `view_etairia_kerdos`;
/*!50001 DROP VIEW IF EXISTS `view_etairia_kerdos`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `view_etairia_kerdos` AS SELECT 
 1 AS `game_id`,
 1 AS `results_prediction`,
 1 AS `actual_result`,
 1 AS `company_profit_or_loss`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping events for database 'mathbet'
--
/*!50106 SET @save_time_zone= @@TIME_ZONE */ ;
/*!50106 DROP EVENT IF EXISTS `calculate_daily_summary` */;
DELIMITER ;;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;;
/*!50003 SET character_set_client  = utf8mb4 */ ;;
/*!50003 SET character_set_results = utf8mb4 */ ;;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;;
/*!50003 SET @saved_time_zone      = @@time_zone */ ;;
/*!50003 SET time_zone             = 'SYSTEM' */ ;;
/*!50106 CREATE*/ /*!50117 DEFINER=`root`@`localhost`*/ /*!50106 EVENT `calculate_daily_summary` ON SCHEDULE EVERY 1 DAY STARTS '2025-04-22 00:01:00' ON COMPLETION NOT PRESERVE ENABLE DO BEGIN
    IF NOT EXISTS (
        SELECT 1 
        FROM daily_summary 
        WHERE summary_date = CURDATE() - INTERVAL 1 DAY
    ) THEN

        INSERT INTO daily_summary (
            summary_date,
            total_deposits,
            total_withdrawals
        )
        SELECT
            CURDATE() - INTERVAL 1 DAY,
            IFNULL(SUM(CASE 
                        WHEN typos = 'Katathesh' 
                        THEN ammountoftran 
                        ELSE 0 
                      END), 0),
            IFNULL(SUM(CASE 
                        WHEN typos = 'Analhpsh' 
                        THEN ammountoftran 
                        ELSE 0 
                      END), 0)
        FROM synalages
        WHERE date_of_transaction >= CURDATE() - INTERVAL 1 DAY
          AND date_of_transaction < CURDATE();

    END IF;
END */ ;;
/*!50003 SET time_zone             = @saved_time_zone */ ;;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;;
/*!50003 SET character_set_client  = @saved_cs_client */ ;;
/*!50003 SET character_set_results = @saved_cs_results */ ;;
/*!50003 SET collation_connection  = @saved_col_connection */ ;;
DELIMITER ;
/*!50106 SET TIME_ZONE= @save_time_zone */ ;

--
-- Dumping routines for database 'mathbet'
--
/*!50003 DROP FUNCTION IF EXISTS `get_profit_or_loss` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `get_profit_or_loss`(
    in_start_date DATE,
    in_end_date DATE,
    in_customer_id INT
) RETURNS decimal(10,2)
    DETERMINISTIC
BEGIN
    DECLARE total_profit_loss DECIMAL(10,2);

    SELECT 
        SUM(
            CASE 
                WHEN s.results_prediction = g.results 
                THEN s.potential_earnings - s.amount
                ELSE -s.amount
            END
        )
    INTO total_profit_loss
    FROM stoixhmata s
    JOIN game_event g ON s.game_id = g.game_id
    WHERE 
        s.customers_id = in_customer_id
        AND s.bet_date BETWEEN in_start_date AND in_end_date
        AND g.results IS NOT NULL;

    RETURN IFNULL(total_profit_loss, 0);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `top_k_profitable_games` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `top_k_profitable_games`(
    IN in_start_date DATE,
    IN in_end_date DATE,
    IN in_k INT
)
BEGIN
    SELECT 
        g.game_id,
        g.sport_type,
        g.tournament,
        g.match_date,
        SUM(
            CASE 
                WHEN s.results_prediction = g.results 
                THEN -s.potential_earnings
                ELSE s.amount
            END
        ) AS net_company_profit
    FROM stoixhmata s
    JOIN game_event g ON s.game_id = g.game_id
    WHERE g.match_date BETWEEN in_start_date AND in_end_date AND g.results IS NOT NULL
    GROUP BY g.game_id, g.sport_type, g.tournament, g.match_date
    ORDER BY net_company_profit DESC
    LIMIT in_k;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `countries_excel`
--

/*!50001 DROP VIEW IF EXISTS `countries_excel`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `countries_excel` AS select `p`.`countryoforigin` AS `country`,ifnull(sum((case when (`s`.`typos` = 'katathesh') then `s`.`ammountoftran` else 0 end)),0) AS `total_deposits`,ifnull(sum((case when (`s`.`typos` = 'analhpsh') then `s`.`ammountoftran` else 0 end)),0) AS `total_withdrawals` from (`pelates` `p` left join `synalages` `s` on((`p`.`customer_id` = `s`.`customer_id`))) group by `country` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `game_event_odds_stats`
--

/*!50001 DROP VIEW IF EXISTS `game_event_odds_stats`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `game_event_odds_stats` AS select `g`.`game_id` AS `game_id`,`g`.`sport_type` AS `sport_type`,`g`.`tournament` AS `tournament`,`g`.`match_date` AS `match_date`,max(`s`.`odds`) AS `max_odds`,min(`s`.`odds`) AS `min_odds` from (`stoixhmata` `s` join `game_event` `g` on((`s`.`game_id` = `g`.`game_id`))) group by `g`.`game_id`,`g`.`sport_type`,`g`.`tournament`,`g`.`match_date` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `high_earnings_customers`
--

/*!50001 DROP VIEW IF EXISTS `high_earnings_customers`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `high_earnings_customers` AS select `p`.`customer_id` AS `customer_id`,`p`.`name` AS `name`,sum((`s`.`potential_earnings` - `s`.`amount`)) AS `total_profit` from ((`pelates` `p` join `stoixhmata` `s` on((`p`.`customer_id` = `s`.`customers_id`))) join `game_event` `g` on((`s`.`game_id` = `g`.`game_id`))) where (`s`.`results_prediction` = `g`.`results`) group by `p`.`customer_id`,`p`.`name` having (`total_profit` > (select avg(`sub`.`profit`) from (select `s`.`customers_id` AS `customers_id`,sum((`s`.`potential_earnings` - `s`.`amount`)) AS `profit` from (`stoixhmata` `s` join `game_event` `g` on((`s`.`game_id` = `g`.`game_id`))) where (`s`.`results_prediction` = `g`.`results`) group by `s`.`customers_id`) `sub`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `high_risk_customers`
--

/*!50001 DROP VIEW IF EXISTS `high_risk_customers`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `high_risk_customers` AS select `p`.`customer_id` AS `customer_id`,`p`.`name` AS `name`,avg(`s`.`odds`) AS `average_odds` from (`pelates` `p` join `stoixhmata` `s` on((`p`.`customer_id` = `s`.`customers_id`))) group by `p`.`customer_id`,`p`.`name` having (avg(`s`.`odds`) > 2) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_etairia_kerdos`
--

/*!50001 DROP VIEW IF EXISTS `view_etairia_kerdos`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `view_etairia_kerdos` AS select `ge`.`game_id` AS `game_id`,`s`.`results_prediction` AS `results_prediction`,`ge`.`results` AS `actual_result`,sum((case when (`s`.`results_prediction` = `ge`.`results`) then -(`s`.`potential_earnings`) else `s`.`amount` end)) AS `company_profit_or_loss` from (`stoixhmata` `s` join `game_event` `ge` on((`s`.`game_id` = `ge`.`game_id`))) group by `ge`.`game_id`,`s`.`results_prediction`,`ge`.`results` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-04-21 21:13:21
