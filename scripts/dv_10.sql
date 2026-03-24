-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: localhost    Database: generator_cms
-- ------------------------------------------------------
-- Server version	8.0.44

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
-- Table structure for table `banners`
--

DROP TABLE IF EXISTS `banners`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `banners` (
                           `id` int NOT NULL AUTO_INCREMENT,
                           `title` varchar(100) DEFAULT NULL,
                           `image_url` varchar(255) NOT NULL,
                           `link_url` varchar(255) DEFAULT NULL,
                           `position` enum('HOME_SLIDER','SIDEBAR','FOOTER') DEFAULT 'HOME_SLIDER',
                           `is_active` tinyint(1) DEFAULT '1',
                           `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                           PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `banners`
--

LOCK TABLES `banners` WRITE;
/*!40000 ALTER TABLE `banners` DISABLE KEYS */;
INSERT INTO `banners` VALUES (1,'Khuyến mãi máy phát điện','/uploads/banner1.jpg','/products','HOME_SLIDER',1,'2026-02-03 05:54:22'),(2,'Dịch vụ bảo trì','/uploads/banner2.jpg','/maintenance','SIDEBAR',1,'2026-02-03 05:54:22'),(3,'Liên hệ kỹ thuật','/uploads/banner3.jpg','/contact','FOOTER',1,'2026-02-03 05:54:22');
/*!40000 ALTER TABLE `banners` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `brands`
--

DROP TABLE IF EXISTS `brands`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `brands` (
                          `id` int NOT NULL AUTO_INCREMENT,
                          `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
                          `slug` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
                          `logo_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
                          PRIMARY KEY (`id`),
                          UNIQUE KEY `slug` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `brands`
--

LOCK TABLES `brands` WRITE;
/*!40000 ALTER TABLE `brands` DISABLE KEYS */;
INSERT INTO `brands` VALUES (1,'Honda','honda',NULL),(2,'Cummins','cummins',NULL),(3,'Hyundai','hyundai','/uploads/brands/hyundai.png'),(4,'Mitsubishi','mitsubishi','/uploads/brands/mitsubishi.png'),(5,'Doosan','doosan','/uploads/brands/doosan.png'),(6,'Perkins','perkins','/uploads/brands/perkins.png'),(7,'Denyo','denyo','/uploads/brands/denyo.png'),(8,'Bugi','bugi',NULL);
/*!40000 ALTER TABLE `brands` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
                              `id` int NOT NULL AUTO_INCREMENT,
                              `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
                              `slug` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
                              `parent_id` int DEFAULT NULL,
                              PRIMARY KEY (`id`),
                              UNIQUE KEY `slug` (`slug`),
                              KEY `parent_id` (`parent_id`),
                              CONSTRAINT `categories_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,'Máy công nghiệp','industrial',NULL),(2,'Máy gia đình','home-use',NULL);
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_categories`
--

DROP TABLE IF EXISTS `cms_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cms_categories` (
                                  `id` int NOT NULL AUTO_INCREMENT,
                                  `name` varchar(100) NOT NULL,
                                  `type` enum('NEWS','TECHNICAL_DOC','MARKETING','PROJECT') NOT NULL,
                                  `description` text,
                                  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_categories`
--

LOCK TABLES `cms_categories` WRITE;
/*!40000 ALTER TABLE `cms_categories` DISABLE KEYS */;
INSERT INTO `cms_categories` VALUES (1,'Tin tức','NEWS','Tin tức ngành máy phát điện'),(2,'Tài liệu kỹ thuật','TECHNICAL_DOC','Hướng dẫn và tài liệu'),(3,'Dự án','PROJECT','Dự án đã triển khai');
/*!40000 ALTER TABLE `cms_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cms_posts`
--

DROP TABLE IF EXISTS `cms_posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cms_posts` (
                             `id` int NOT NULL AUTO_INCREMENT,
                             `title` varchar(255) NOT NULL,
                             `content` longtext,
                             `attachment_url` varchar(255) DEFAULT NULL,
                             `thumbnail_url` varchar(255) DEFAULT NULL,
                             `author_id` int NOT NULL,
                             `category_id` int NOT NULL,
                             `related_product_model` varchar(100) DEFAULT NULL,
                             `status` enum('DRAFT','PENDING','PUBLISHED','HIDDEN') DEFAULT 'PENDING',
                             `approved_by` int DEFAULT NULL,
                             `published_at` datetime DEFAULT NULL,
                             `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                             PRIMARY KEY (`id`),
                             KEY `author_id` (`author_id`),
                             KEY `category_id` (`category_id`),
                             KEY `approved_by` (`approved_by`),
                             CONSTRAINT `cms_posts_ibfk_1` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`),
                             CONSTRAINT `cms_posts_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `cms_categories` (`id`),
                             CONSTRAINT `cms_posts_ibfk_3` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cms_posts`
--

LOCK TABLES `cms_posts` WRITE;
/*!40000 ALTER TABLE `cms_posts` DISABLE KEYS */;
INSERT INTO `cms_posts` VALUES (1,'Hướng dẫn vận hành máy phát điện (cơ bản)','Nội dung hướng dẫn vận hành an toàn, kiểm tra dầu/nước làm mát, test tải...',NULL,'/uploads/thumbs/doc1.jpg',10,2,'honda-power-20kva','PUBLISHED',9,'2026-02-03 12:54:22','2026-02-03 05:54:22'),(2,'Dự án lắp đặt tại Bắc Ninh','Triển khai hệ thống máy phát điện 50kVA cho nhà máy, nghiệm thu theo checklist...',NULL,'/uploads/thumbs/project1.jpg',9,3,'honda-power-50kva','PUBLISHED',9,'2026-02-03 12:54:22','2026-02-03 05:54:22'),(3,'Ra mắt dòng máy Cummins thế hệ mới','Cummins vừa công bố dòng máy C90D5 với hiệu suất vượt trội...',NULL,'/uploads/banner1.jpg',9,1,NULL,'PUBLISHED',NULL,'2026-02-04 23:34:53','2026-02-04 16:34:53'),(4,'Lịch bảo trì Tết Nguyên Đán 2026','Thông báo lịch trực kỹ thuật và bảo trì trong dịp lễ...',NULL,'/uploads/banner2.jpg',9,1,NULL,'PUBLISHED',NULL,'2026-02-04 23:34:53','2026-02-04 16:34:53'),(5,'Hướng dẫn thay dầu máy tại nhà','Quy trình 5 bước thay dầu máy phát điện Honda...',NULL,'/uploads/thumbs/doc1.jpg',11,2,NULL,'PUBLISHED',NULL,'2026-02-04 23:34:53','2026-02-04 16:34:53');
/*!40000 ALTER TABLE `cms_posts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contract_events`
--

DROP TABLE IF EXISTS `contract_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contract_events` (
                                   `id` bigint NOT NULL AUTO_INCREMENT,
                                   `contract_id` int NOT NULL,
                                   `event_type` enum('CREATED','STATUS_CHANGED','TERMINATED','REACTIVATED','UPDATED','NOTE') NOT NULL,
                                   `reason_code` varchar(50) DEFAULT NULL,
                                   `terminated_reason` varchar(255) DEFAULT NULL,
                                   `decision_doc` varchar(255) DEFAULT NULL,
                                   `note` text,
                                   `actor_id` int DEFAULT NULL,
                                   `old_status` enum('PENDING_SERIAL','ACTIVE','EXPIRED','TERMINATED') DEFAULT NULL,
                                   `new_status` enum('PENDING_SERIAL','ACTIVE','EXPIRED','TERMINATED') DEFAULT NULL,
                                   `meta` json DEFAULT NULL,
                                   `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                   PRIMARY KEY (`id`),
                                   KEY `idx_contract_events_contract_id` (`contract_id`),
                                   KEY `idx_contract_events_event_type` (`event_type`),
                                   KEY `idx_contract_events_created_at` (`created_at`),
                                   KEY `idx_contract_events_actor_id` (`actor_id`),
                                   KEY `idx_contract_events_contract_created` (`contract_id`,`created_at`),
                                   CONSTRAINT `fk_contract_events_actor` FOREIGN KEY (`actor_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
                                   CONSTRAINT `fk_contract_events_contract` FOREIGN KEY (`contract_id`) REFERENCES `contracts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contract_events`
--

LOCK TABLES `contract_events` WRITE;
/*!40000 ALTER TABLE `contract_events` DISABLE KEYS */;
INSERT INTO `contract_events` VALUES (4,15,'TERMINATED','CONTRACT_VIOLATION','Vi phạm quy định của hợp đồng','QD-193','Làm ăn vớ vẩn',9,'ACTIVE','TERMINATED','{\"ip\": \"0:0:0:0:0:0:0:1\", \"source\": \"manager_contract_detail\", \"user_agent\": \"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36\"}','2026-03-05 08:37:00'),(5,18,'TERMINATED','OTHER','Vi phạm quy định của hợp đồng','QD-193','123',9,'ACTIVE','TERMINATED','{\"ip\": \"0:0:0:0:0:0:0:1\"}','2026-03-05 09:36:18'),(6,13,'UPDATED','CONTRACT_UPDATED',NULL,NULL,'Cập nhật thông tin hợp đồng',9,'ACTIVE','ACTIVE','{\"action\": \"EDIT_CONTRACT\", \"end_date\": \"2027-02-05\", \"start_date\": \"2026-02-05\", \"customer_id\": 39, \"contract_number\": \"HD-2026-20021\"}','2026-03-05 09:58:37'),(7,5,'UPDATED','CONTRACT_UPDATED',NULL,NULL,'Cập nhật thông tin hợp đồng',9,'ACTIVE','ACTIVE','{\"action\": \"EDIT_CONTRACT\", \"end_date\": \"2026-12-31\", \"start_date\": \"2026-01-01\", \"customer_id\": 25, \"contract_number\": \"HD-BAOTRI-2026-A1\"}','2026-03-05 10:24:58'),(8,5,'UPDATED','CONTRACT_UPDATED',NULL,NULL,'Cập nhật thông tin hợp đồng',9,'ACTIVE','ACTIVE','{\"action\": \"EDIT_CONTRACT\", \"end_date\": \"2026-12-31\", \"start_date\": \"2026-01-01\", \"customer_id\": 25, \"contract_number\": \"HD-BAOTRI-2026-A1\"}','2026-03-05 10:25:16'),(9,5,'UPDATED','CONTRACT_UPDATED',NULL,NULL,'Cập nhật thông tin hợp đồng',9,'ACTIVE','ACTIVE','{\"action\": \"EDIT_CONTRACT\", \"end_date\": \"2026-12-31\", \"start_date\": \"2026-01-01\", \"customer_id\": 25, \"contract_number\": \"HD-BAOTRI-2026-A1\"}','2026-03-05 10:27:07'),(10,5,'UPDATED','CONTRACT_UPDATED',NULL,NULL,'Cập nhật thông tin hợp đồng',9,'ACTIVE','ACTIVE','{\"action\": \"EDIT_CONTRACT\", \"end_date\": \"2026-12-31\", \"start_date\": \"2026-01-01\", \"customer_id\": 25, \"contract_number\": \"HD-BAOTRI-2026-A1\"}','2026-03-05 10:27:21'),(11,5,'UPDATED','CONTRACT_UPDATED',NULL,NULL,'Cập nhật thông tin hợp đồng',9,'ACTIVE','ACTIVE','{\"action\": \"EDIT_CONTRACT\", \"end_date\": \"2026-12-31\", \"start_date\": \"2026-01-01\", \"customer_id\": 25, \"contract_number\": \"HD-BAOTRI-2026-A1\"}','2026-03-05 10:27:37'),(12,5,'UPDATED','CONTRACT_UPDATED',NULL,NULL,'Cập nhật thông tin hợp đồng',9,'ACTIVE','ACTIVE','{\"action\": \"EDIT_CONTRACT\", \"end_date\": \"2026-12-31\", \"start_date\": \"2026-01-01\", \"customer_id\": 25, \"contract_number\": \"HD-BAOTRI-2026-A1\"}','2026-03-05 10:27:57'),(13,5,'UPDATED','CONTRACT_UPDATED',NULL,NULL,'Cập nhật thông tin hợp đồng',9,'ACTIVE','ACTIVE','{\"action\": \"EDIT_CONTRACT\", \"end_date\": \"2026-12-31\", \"start_date\": \"2026-01-01\", \"customer_id\": 25, \"contract_number\": \"HD-BAOTRI-2026-A1\"}','2026-03-05 10:49:56'),(14,19,'TERMINATED','CONTRACT_VIOLATION','Khách thay đổi ý định','QD-198','123',9,'PENDING_SERIAL','TERMINATED','{\"ip\": \"0:0:0:0:0:0:0:1\"}','2026-03-06 04:53:57');
/*!40000 ALTER TABLE `contract_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contracts`
--

DROP TABLE IF EXISTS `contracts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contracts` (
                             `id` int NOT NULL AUTO_INCREMENT,
                             `contract_number` varchar(50) NOT NULL,
                             `customer_id` int NOT NULL,
                             `start_date` date DEFAULT NULL,
                             `end_date` date DEFAULT NULL,
                             `status` enum('PENDING_SERIAL','ACTIVE','EXPIRED','TERMINATED') NOT NULL DEFAULT 'PENDING_SERIAL',
                             `manager_id` int DEFAULT NULL,
                             `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                             `terminated_at` datetime DEFAULT NULL,
                             `signed_date` date DEFAULT NULL,
                             `file_path` varchar(255) DEFAULT NULL,
                             PRIMARY KEY (`id`),
                             UNIQUE KEY `contract_number` (`contract_number`),
                             KEY `customer_id` (`customer_id`),
                             KEY `manager_id` (`manager_id`),
                             KEY `idx_contracts_status_terminated_at` (`status`,`terminated_at`),
                             CONSTRAINT `contracts_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `users` (`id`),
                             CONSTRAINT `contracts_ibfk_3` FOREIGN KEY (`manager_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contracts`
--

LOCK TABLES `contracts` WRITE;
/*!40000 ALTER TABLE `contracts` DISABLE KEYS */;
INSERT INTO `contracts` VALUES (1,'CT-2026-001',25,'2026-01-01','2027-01-01','ACTIVE',9,'2026-02-03 05:54:22',NULL,NULL,NULL),(2,'CT-2025-099',12,'2025-01-01','2025-12-31','EXPIRED',9,'2026-02-03 05:54:22',NULL,NULL,NULL),(4,'HD-2026-186195',29,'2026-02-03','2027-02-03','ACTIVE',9,'2026-02-03 15:10:25',NULL,NULL,NULL),(5,'HD-BAOTRI-2026-A1',25,'2026-01-01','2026-12-31','ACTIVE',9,'2026-02-04 16:34:53',NULL,NULL,NULL),(7,'HD-VIP-EXPIRED',12,'2024-01-01','2025-01-01','EXPIRED',9,'2026-02-04 16:34:53',NULL,NULL,NULL),(13,'HD-2026-20021',39,'2026-02-05','2027-02-05','ACTIVE',9,'2026-02-04 18:08:25',NULL,NULL,NULL),(15,'HD-2026-18619d12',25,'2026-02-05','2027-01-05','TERMINATED',9,'2026-02-05 11:22:52','2026-03-05 15:37:00',NULL,NULL),(16,'HD-TEST-001',39,'2026-02-07','2027-02-07','TERMINATED',9,'2026-02-07 11:45:59','2026-03-05 14:46:08',NULL,NULL),(18,'HD-2026-1869152112',25,'2026-03-05','2026-03-21','TERMINATED',9,'2026-03-05 09:34:33','2026-03-05 16:36:18',NULL,NULL),(19,'HD-2026-0931212',25,'2026-03-06','2026-04-24','TERMINATED',9,'2026-03-06 04:53:19','2026-03-06 11:53:57',NULL,NULL),(21,'HD-2026-186195222',25,'2026-03-10','2026-05-01','ACTIVE',9,'2026-03-10 09:27:34',NULL,NULL,NULL),(40,'HD-2026-2002',25,'2026-03-16','2027-11-15','ACTIVE',9,'2026-03-15 15:31:55',NULL,NULL,''),(41,'HD-2026-2003',25,'2026-03-18','2027-11-17','ACTIVE',9,'2026-03-17 09:36:21',NULL,NULL,'uploads/ai-extractions/1773740386734_37fee9202cb64d589410bbfccf59d07a.pdf'),(42,'HD-2026-2004',25,'2026-03-22','2027-12-21','ACTIVE',9,'2026-03-20 17:44:10',NULL,'2026-03-21','uploads/ai-extractions/1774028813787_e814e9a2239d4c9fb4613fb696da43c9.pdf');
/*!40000 ALTER TABLE `contracts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `incidents`
--

DROP TABLE IF EXISTS `incidents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `incidents` (
                             `id` int NOT NULL AUTO_INCREMENT,
                             `product_id` int NOT NULL,
                             `reported_by` int DEFAULT NULL,
                             `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
                             `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
                             `image_evidence` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
                             `priority` enum('LOW','MEDIUM','HIGH','CRITICAL') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'MEDIUM',
                             `status` enum('NEW','VERIFYING','WAITING_MANAGER','APPROVED','IN_PROGRESS','COMPLETED','REJECTED') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'NEW',
                             `technician_id` int DEFAULT NULL,
                             `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                             `resolved_at` datetime DEFAULT NULL,
                             `input_contract_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
                             `input_serial_number` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
                             `contract_id` int DEFAULT NULL,
                             PRIMARY KEY (`id`),
                             KEY `product_id` (`product_id`),
                             KEY `reported_by` (`reported_by`),
                             KEY `technician_id` (`technician_id`),
                             KEY `fk_incident_contract` (`contract_id`),
                             CONSTRAINT `fk_incident_contract` FOREIGN KEY (`contract_id`) REFERENCES `contracts` (`id`),
                             CONSTRAINT `incidents_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
                             CONSTRAINT `incidents_ibfk_2` FOREIGN KEY (`reported_by`) REFERENCES `users` (`id`),
                             CONSTRAINT `incidents_ibfk_3` FOREIGN KEY (`technician_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `incidents`
--

LOCK TABLES `incidents` WRITE;
/*!40000 ALTER TABLE `incidents` DISABLE KEYS */;
INSERT INTO `incidents` VALUES (1,3,25,'Máy rung bất thường','Máy rung mạnh khi tải cao',NULL,'HIGH','NEW',11,'2026-02-03 05:54:22',NULL,NULL,NULL,1),(2,4,12,'Không khởi động được','Máy không đề được, nghi lỗi ắc quy',NULL,'CRITICAL','VERIFYING',11,'2026-02-03 05:54:22',NULL,'CT-NHAP-TAY-000','SN-NHAP-TAY-000',NULL),(3,1,25,'Máy có tiếng kêu lạ','Khi khởi động nghe tiếng cạch cạch ở bộ đề',NULL,'MEDIUM','IN_PROGRESS',11,'2026-02-04 16:34:53',NULL,NULL,NULL,NULL),(4,2,25,'Rò rỉ nhiên liệu','Phát hiện vết dầu loang dưới chân máy',NULL,'CRITICAL','NEW',NULL,'2026-02-04 16:34:53',NULL,NULL,NULL,NULL),(5,3,12,'Bảng điều khiển không sáng','Màn hình LCD bị tối đen không hiển thị thông số',NULL,'LOW','COMPLETED',11,'2026-02-04 16:34:53',NULL,NULL,NULL,NULL),(6,4,12,'Khói đen bất thường','Máy ra nhiều khói đen khi tải trên 80%',NULL,'HIGH','WAITING_MANAGER',11,'2026-02-04 16:34:53',NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `incidents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invoices`
--

DROP TABLE IF EXISTS `invoices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `invoices` (
                            `id` bigint NOT NULL AUTO_INCREMENT,
                            `invoice_code` varchar(50) NOT NULL,
                            `customer_id` bigint NOT NULL,
                            `quote_id` bigint DEFAULT NULL,
                            `maintenance_id` int NOT NULL,
                            `created_by` int DEFAULT NULL,
                            `subtotal` decimal(15,2) NOT NULL DEFAULT '0.00',
                            `tax_rate` decimal(5,2) NOT NULL DEFAULT '0.00',
                            `tax_amount` decimal(15,2) NOT NULL DEFAULT '0.00',
                            `total_amount` decimal(15,2) NOT NULL DEFAULT '0.00',
                            `payment_method` varchar(50) DEFAULT NULL,
                            `payment_status` varchar(20) NOT NULL DEFAULT 'UNPAID',
                            `note` text,
                            `issued_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                            `due_date` timestamp NULL DEFAULT NULL,
                            `paid_at` timestamp NULL DEFAULT NULL,
                            PRIMARY KEY (`id`),
                            UNIQUE KEY `invoice_code` (`invoice_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invoices`
--

LOCK TABLES `invoices` WRITE;
/*!40000 ALTER TABLE `invoices` DISABLE KEYS */;
/*!40000 ALTER TABLE `invoices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `maintenance_images`
--

DROP TABLE IF EXISTS `maintenance_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `maintenance_images` (
                                      `id` int NOT NULL AUTO_INCREMENT,
                                      `maintenance_id` int NOT NULL,
                                      `image_path` varchar(255) NOT NULL,
                                      `uploaded_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                      `image_type` enum('BEFORE','AFTER') NOT NULL DEFAULT 'AFTER',
                                      PRIMARY KEY (`id`),
                                      KEY `fk_maintenance_image` (`maintenance_id`),
                                      CONSTRAINT `fk_maintenance_image` FOREIGN KEY (`maintenance_id`) REFERENCES `maintenances` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `maintenance_images`
--

LOCK TABLES `maintenance_images` WRITE;
/*!40000 ALTER TABLE `maintenance_images` DISABLE KEYS */;
INSERT INTO `maintenance_images` VALUES (1,10,'uploads/maintenance/m10_1772597421023.jfif','2026-03-04 04:10:21','AFTER'),(2,27,'uploads/maintenance/m27_1772597447082.jfif','2026-03-04 04:10:47','AFTER'),(3,30,'uploads/maintenance/m30_1772598212920.jfif','2026-03-04 04:23:32','AFTER'),(5,21,'uploads/maintenance/m21_1772605116288.jfif','2026-03-04 06:18:36','AFTER'),(7,24,'uploads/maintenance/m24_1773133778591.webp','2026-03-10 09:09:38','AFTER'),(8,24,'uploads/maintenance/m24_1773133785540.webp','2026-03-10 09:09:45','AFTER');
/*!40000 ALTER TABLE `maintenance_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `maintenance_spare_parts`
--

DROP TABLE IF EXISTS `maintenance_spare_parts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `maintenance_spare_parts` (
                                           `maintenance_id` int NOT NULL,
                                           `spare_part_id` int NOT NULL,
                                           `quantity_used` int NOT NULL,
                                           `cost_at_time` decimal(15,2) DEFAULT NULL,
                                           PRIMARY KEY (`maintenance_id`,`spare_part_id`),
                                           KEY `spare_part_id` (`spare_part_id`),
                                           CONSTRAINT `maintenance_spare_parts_ibfk_1` FOREIGN KEY (`maintenance_id`) REFERENCES `maintenances` (`id`) ON DELETE CASCADE,
                                           CONSTRAINT `maintenance_spare_parts_ibfk_2` FOREIGN KEY (`spare_part_id`) REFERENCES `spare_parts` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `maintenance_spare_parts`
--

LOCK TABLES `maintenance_spare_parts` WRITE;
/*!40000 ALTER TABLE `maintenance_spare_parts` DISABLE KEYS */;
INSERT INTO `maintenance_spare_parts` VALUES (21,1,3,450000.00),(21,2,6,480000.00),(22,2,21,1680000.00),(23,2,2,160000.00),(24,1,3,450000.00);
/*!40000 ALTER TABLE `maintenance_spare_parts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `maintenances`
--

DROP TABLE IF EXISTS `maintenances`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `maintenances` (
                                `id` int NOT NULL AUTO_INCREMENT,
                                `product_id` int NOT NULL,
                                `technician_id` int DEFAULT NULL,
                                `incident_id` int DEFAULT NULL,
                                `maintenance_date` date NOT NULL,
                                `type` enum('PERIODIC','REPAIR','INSPECTION') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'PERIODIC',
                                `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
                                `actual_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
                                `total_cost` decimal(15,2) DEFAULT '0.00',
                                `labor_cost` decimal(15,2) DEFAULT '0.00',
                                `status` enum('SCHEDULED','COMPLETED','CANCELLED') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'COMPLETED',
                                `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                `created_by` int DEFAULT NULL COMMENT 'Người tạo/phân công việc',
                                `assignment_status` enum('DRAFT','PENDING_APPROVAL','APPROVED','REJECTED') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'DRAFT',
                                `approved_by` int DEFAULT NULL,
                                `completed_at` datetime DEFAULT NULL,
                                PRIMARY KEY (`id`),
                                KEY `product_id` (`product_id`),
                                KEY `technician_id` (`technician_id`),
                                KEY `incident_id` (`incident_id`),
                                KEY `fk_maintenance_creator` (`created_by`),
                                KEY `fk_maintenance_approver` (`approved_by`),
                                CONSTRAINT `fk_maintenance_approver` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`),
                                CONSTRAINT `fk_maintenance_creator` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
                                CONSTRAINT `maintenances_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
                                CONSTRAINT `maintenances_ibfk_2` FOREIGN KEY (`technician_id`) REFERENCES `users` (`id`),
                                CONSTRAINT `maintenances_ibfk_3` FOREIGN KEY (`incident_id`) REFERENCES `incidents` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=65 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `maintenances`
--

LOCK TABLES `maintenances` WRITE;
/*!40000 ALTER TABLE `maintenances` DISABLE KEYS */;
INSERT INTO `maintenances` VALUES (21,19,11,NULL,'2026-03-06','REPAIR','','l',930000.00,0.00,'SCHEDULED','2026-03-06 06:22:40',NULL,'DRAFT',NULL,NULL),(22,3,11,NULL,'2026-03-06','REPAIR','','1212',1680000.00,0.00,'SCHEDULED','2026-03-06 06:48:54',NULL,'DRAFT',NULL,NULL),(23,2,11,NULL,'2026-03-06','REPAIR','','f',160000.00,0.00,'COMPLETED','2026-03-06 06:56:57',NULL,'DRAFT',NULL,NULL),(24,1,11,NULL,'2026-03-10','REPAIR','abc','abc',450000.00,0.00,'COMPLETED','2026-03-10 09:08:25',NULL,'DRAFT',NULL,NULL),(25,1,11,NULL,'2026-03-20','REPAIR','Máy không khởi động','Đã thay bugi và vệ sinh bộ lọc',560000.00,160000.00,'COMPLETED','2026-03-20 06:33:41',9,'APPROVED',9,'2026-03-20 10:00:00'),(26,2,11,NULL,'2026-03-21','PERIODIC','Bảo trì định kỳ tháng','Đã thay lọc dầu và kiểm tra hệ thống',300000.00,100000.00,'COMPLETED','2026-03-20 06:33:41',9,'APPROVED',9,'2026-03-21 09:30:00'),(27,3,11,NULL,'2026-03-22','INSPECTION','Kiểm tra trước vận hành','Máy hoạt động ổn định',0.00,0.00,'COMPLETED','2026-03-20 06:33:41',9,'APPROVED',9,'2026-03-22 08:00:00'),(28,1,11,NULL,'2026-03-23','REPAIR','Máy rung mạnh','Đã thay lọc dầu và siết lại ốc',450000.00,0.00,'COMPLETED','2026-03-20 06:33:41',9,'APPROVED',9,'2026-03-23 11:00:00'),(29,2,11,NULL,'2026-03-24','PERIODIC','Bảo trì quý',NULL,0.00,0.00,'SCHEDULED','2026-03-20 06:33:41',9,'APPROVED',9,NULL),(30,1,11,NULL,'2026-03-01','REPAIR','Máy không khởi động','Thay bugi',400000.00,100000.00,'COMPLETED','2026-03-20 06:33:41',9,'APPROVED',9,'2026-03-01 10:00:00'),(31,2,11,NULL,'2026-03-02','PERIODIC','Bảo trì định kỳ','Thay lọc dầu',300000.00,100000.00,'COMPLETED','2026-03-20 06:33:41',9,'APPROVED',9,'2026-03-02 09:00:00'),(32,3,11,NULL,'2026-03-03','INSPECTION','Kiểm tra tổng thể','Ổn định',0.00,0.00,'COMPLETED','2026-03-20 06:33:41',9,'APPROVED',9,'2026-03-03 08:00:00'),(33,1,11,NULL,'2026-03-04','REPAIR','Máy rung','Siết ốc + lọc dầu',450000.00,0.00,'COMPLETED','2026-03-20 06:33:41',9,'APPROVED',9,'2026-03-04 11:00:00'),(34,2,11,NULL,'2026-03-05','PERIODIC','Bảo trì tháng','Kiểm tra hệ thống',0.00,0.00,'SCHEDULED','2026-03-20 06:33:41',9,'APPROVED',9,NULL),(35,3,11,NULL,'2026-03-06','REPAIR','Hỏng bugi','Thay mới',160000.00,60000.00,'COMPLETED','2026-03-20 06:33:41',9,'APPROVED',9,'2026-03-06 10:00:00'),(36,1,11,NULL,'2026-03-07','PERIODIC','Bảo trì quý','Thay dầu',300000.00,100000.00,'COMPLETED','2026-03-20 06:33:41',9,'APPROVED',9,'2026-03-07 09:00:00'),(37,2,11,NULL,'2026-03-08','INSPECTION','Check trước vận hành','OK',0.00,0.00,'COMPLETED','2026-03-20 06:33:41',9,'APPROVED',9,'2026-03-08 08:00:00'),(38,3,11,NULL,'2026-03-09','REPAIR','Máy yếu','Thay lọc dầu',150000.00,50000.00,'COMPLETED','2026-03-20 06:33:41',9,'APPROVED',9,'2026-03-09 10:00:00'),(39,1,11,NULL,'2026-03-10','PERIODIC','Bảo trì định kỳ','Kiểm tra điện áp',0.00,0.00,'SCHEDULED','2026-03-20 06:33:41',9,'APPROVED',9,NULL),(40,2,11,NULL,'2026-03-11','REPAIR','Máy nóng','Thay bugi',240000.00,80000.00,'COMPLETED','2026-03-20 06:33:41',9,'APPROVED',9,'2026-03-11 11:00:00'),(41,3,11,NULL,'2026-03-12','INSPECTION','Kiểm tra','OK',0.00,0.00,'COMPLETED','2026-03-20 06:33:41',9,'APPROVED',9,'2026-03-12 09:00:00'),(42,1,11,NULL,'2026-03-13','REPAIR','Rò dầu','Thay lọc dầu',150000.00,50000.00,'COMPLETED','2026-03-20 06:33:41',9,'APPROVED',9,'2026-03-13 10:00:00'),(43,2,11,NULL,'2026-03-14','PERIODIC','Bảo trì','Thay dầu',300000.00,100000.00,'COMPLETED','2026-03-20 06:33:41',9,'APPROVED',9,'2026-03-14 09:00:00'),(44,3,11,NULL,'2026-03-15','REPAIR','Hỏng nhẹ','Sửa chữa',200000.00,50000.00,'COMPLETED','2026-03-20 06:33:41',9,'APPROVED',9,'2026-03-15 11:00:00'),(45,1,11,NULL,'2026-03-20','REPAIR','Máy không khởi động','Đã thay bugi và vệ sinh bộ lọc',560000.00,160000.00,'COMPLETED','2026-03-20 06:34:53',9,'APPROVED',9,'2026-03-20 10:00:00'),(46,2,11,NULL,'2026-03-21','PERIODIC','Bảo trì định kỳ tháng','Đã thay lọc dầu và kiểm tra hệ thống',300000.00,100000.00,'COMPLETED','2026-03-20 06:34:53',9,'APPROVED',9,'2026-03-21 09:30:00'),(47,3,11,NULL,'2026-03-22','INSPECTION','Kiểm tra trước vận hành','Máy hoạt động ổn định',0.00,0.00,'COMPLETED','2026-03-20 06:34:53',9,'APPROVED',9,'2026-03-22 08:00:00'),(48,1,11,NULL,'2026-03-23','REPAIR','Máy rung mạnh','Đã thay lọc dầu và siết lại ốc',450000.00,0.00,'COMPLETED','2026-03-20 06:34:53',9,'APPROVED',9,'2026-03-23 11:00:00'),(49,2,11,NULL,'2026-03-24','PERIODIC','Bảo trì quý',NULL,0.00,0.00,'SCHEDULED','2026-03-20 06:34:53',9,'APPROVED',9,NULL),(50,1,11,NULL,'2026-03-01','REPAIR','Máy không khởi động','Thay bugi',400000.00,100000.00,'COMPLETED','2026-03-20 06:34:53',9,'APPROVED',9,'2026-03-01 10:00:00'),(51,2,11,NULL,'2026-03-02','PERIODIC','Bảo trì định kỳ','Thay lọc dầu',300000.00,100000.00,'COMPLETED','2026-03-20 06:34:53',9,'APPROVED',9,'2026-03-02 09:00:00'),(52,3,11,NULL,'2026-03-03','INSPECTION','Kiểm tra tổng thể','Ổn định',0.00,0.00,'COMPLETED','2026-03-20 06:34:53',9,'APPROVED',9,'2026-03-03 08:00:00'),(53,1,11,NULL,'2026-03-04','REPAIR','Máy rung','Siết ốc + lọc dầu',450000.00,0.00,'COMPLETED','2026-03-20 06:34:53',9,'APPROVED',9,'2026-03-04 11:00:00'),(54,2,11,NULL,'2026-03-05','PERIODIC','Bảo trì tháng','Kiểm tra hệ thống',0.00,0.00,'SCHEDULED','2026-03-20 06:34:53',9,'APPROVED',9,NULL),(55,3,11,NULL,'2026-03-06','REPAIR','Hỏng bugi','Thay mới',160000.00,60000.00,'COMPLETED','2026-03-20 06:34:53',9,'APPROVED',9,'2026-03-06 10:00:00'),(56,1,11,NULL,'2026-03-07','PERIODIC','Bảo trì quý','Thay dầu',300000.00,100000.00,'COMPLETED','2026-03-20 06:34:53',9,'APPROVED',9,'2026-03-07 09:00:00'),(57,2,11,NULL,'2026-03-08','INSPECTION','Check trước vận hành','OK',0.00,0.00,'COMPLETED','2026-03-20 06:34:53',9,'APPROVED',9,'2026-03-08 08:00:00'),(58,3,11,NULL,'2026-03-09','REPAIR','Máy yếu','Thay lọc dầu',150000.00,50000.00,'COMPLETED','2026-03-20 06:34:53',9,'APPROVED',9,'2026-03-09 10:00:00'),(59,1,11,NULL,'2026-03-10','PERIODIC','Bảo trì định kỳ','Kiểm tra điện áp',0.00,0.00,'SCHEDULED','2026-03-20 06:34:53',9,'APPROVED',9,NULL),(60,2,11,NULL,'2026-03-11','REPAIR','Máy nóng','Thay bugi',240000.00,80000.00,'COMPLETED','2026-03-20 06:34:53',9,'APPROVED',9,'2026-03-11 11:00:00'),(61,3,11,NULL,'2026-03-12','INSPECTION','Kiểm tra','OK',0.00,0.00,'COMPLETED','2026-03-20 06:34:53',9,'APPROVED',9,'2026-03-12 09:00:00'),(62,1,11,NULL,'2026-03-13','REPAIR','Rò dầu','Thay lọc dầu',150000.00,50000.00,'COMPLETED','2026-03-20 06:34:53',9,'APPROVED',9,'2026-03-13 10:00:00'),(63,2,11,NULL,'2026-03-14','PERIODIC','Bảo trì','Thay dầu',300000.00,100000.00,'COMPLETED','2026-03-20 06:34:53',9,'APPROVED',9,'2026-03-14 09:00:00'),(64,3,11,NULL,'2026-03-15','REPAIR','Hỏng nhẹ','Sửa chữa',200000.00,50000.00,'COMPLETED','2026-03-20 06:34:53',9,'APPROVED',9,'2026-03-15 11:00:00');
/*!40000 ALTER TABLE `maintenances` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `news`
--

DROP TABLE IF EXISTS `news`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `news` (
                        `id` bigint NOT NULL AUTO_INCREMENT,
                        `title` varchar(255) NOT NULL,
                        `slug` varchar(255) DEFAULT NULL,
                        `summary` text,
                        `content` longtext NOT NULL,
                        `seo_description` varchar(255) DEFAULT NULL,
                        `is_featured` tinyint(1) NOT NULL DEFAULT '0',
                        `image_url` varchar(255) DEFAULT NULL,
                        `author` varchar(150) DEFAULT NULL,
                        `category` varchar(100) DEFAULT NULL,
                        `status` varchar(50) NOT NULL DEFAULT 'draft',
                        `views` int NOT NULL DEFAULT '0',
                        `published_at` datetime DEFAULT NULL,
                        `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
                        `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                        PRIMARY KEY (`id`),
                        UNIQUE KEY `slug` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `news`
--

LOCK TABLES `news` WRITE;
/*!40000 ALTER TABLE `news` DISABLE KEYS */;
INSERT INTO `news` VALUES (1,'Hướng dẫn cách lọc gió máy phát điện','huong-dan-cach-loc-gio-may-phat-dien','Lọc gió đơn giản lắm','<h3>1. Lọc gi&oacute; m&aacute;y ph&aacute;t điện l&agrave; g&igrave;?</h3>\r\n\r\n<p>Lọc gi&oacute; (air filter) l&agrave; bộ phận c&oacute; nhiệm vụ <strong>lọc sạch kh&ocirc;ng kh&iacute; trước khi đưa v&agrave;o buồng đốt của động cơ</strong>. Kh&ocirc;ng kh&iacute; sạch gi&uacute;p qu&aacute; tr&igrave;nh đốt ch&aacute;y nhi&ecirc;n liệu diễn ra hiệu quả hơn, từ đ&oacute; n&acirc;ng cao hiệu suất hoạt động của m&aacute;y ph&aacute;t điện.</p>\r\n\r\n<h3>2. Vai tr&ograve; của lọc gi&oacute; trong m&aacute;y ph&aacute;t điện</h3>\r\n\r\n<p>Bộ lọc gi&oacute; đảm nhận nhiều vai tr&ograve; quan trọng:</p>\r\n\r\n<ul>\r\n	<li>\r\n	<p><strong>Ngăn chặn bụi bẩn, tạp chất</strong>: Giữ cho kh&ocirc;ng kh&iacute; v&agrave;o động cơ lu&ocirc;n sạch, tr&aacute;nh l&agrave;m m&agrave;i m&ograve;n c&aacute;c chi tiết b&ecirc;n trong.</p>\r\n	</li>\r\n	<li>\r\n	<p><strong>Tăng hiệu suất đốt ch&aacute;y nhi&ecirc;n liệu</strong>: Kh&ocirc;ng kh&iacute; sạch gi&uacute;p qu&aacute; tr&igrave;nh ch&aacute;y diễn ra tối ưu, tiết kiệm nhi&ecirc;n liệu.</p>\r\n	</li>\r\n	<li>\r\n	<p><strong>Bảo vệ động cơ</strong>: Giảm nguy cơ hư hỏng, k&eacute;o d&agrave;i tuổi thọ m&aacute;y.</p>\r\n	</li>\r\n	<li>\r\n	<p><strong>Giảm kh&iacute; thải độc hại</strong>: Gi&uacute;p m&aacute;y vận h&agrave;nh ổn định v&agrave; th&acirc;n thiện hơn với m&ocirc;i trường.</p>\r\n	</li>\r\n</ul>\r\n\r\n<h3>3. Cấu tạo của lọc gi&oacute;</h3>\r\n\r\n<p>Một bộ lọc gi&oacute; m&aacute;y ph&aacute;t điện thường bao gồm:</p>\r\n\r\n<ul>\r\n	<li>\r\n	<p><strong>Vỏ lọc</strong>: L&agrave; lớp bảo vệ b&ecirc;n ngo&agrave;i, thường l&agrave;m bằng nhựa hoặc kim loại.</p>\r\n	</li>\r\n	<li>\r\n	<p><strong>Phần tử lọc (lọc l&otilde;i)</strong>: L&agrave; bộ phận ch&iacute;nh, thường được l&agrave;m từ giấy, b&ocirc;ng hoặc vật liệu tổng hợp c&oacute; khả năng giữ bụi tốt.</p>\r\n	</li>\r\n	<li>\r\n	<p><strong>Gioăng cao su</strong>: Gi&uacute;p đảm bảo k&iacute;n kh&iacute;, kh&ocirc;ng cho kh&ocirc;ng kh&iacute; chưa lọc lọt v&agrave;o động cơ.</p>\r\n	</li>\r\n</ul>\r\n\r\n<h3>4. Dấu hiệu lọc gi&oacute; cần được thay thế</h3>\r\n\r\n<p>Sau một thời gian sử dụng, lọc gi&oacute; sẽ bị b&aacute;m bụi v&agrave; giảm hiệu quả. Một số dấu hiệu nhận biết:</p>\r\n\r\n<ul>\r\n	<li>\r\n	<p>M&aacute;y ph&aacute;t điện <strong>hoạt động yếu hơn b&igrave;nh thường</strong></p>\r\n	</li>\r\n	<li>\r\n	<p><strong>Tăng ti&ecirc;u hao nhi&ecirc;n liệu</strong></p>\r\n	</li>\r\n	<li>\r\n	<p>Động cơ ph&aacute;t ra <strong>tiếng ồn lớn hoặc rung mạnh</strong></p>\r\n	</li>\r\n	<li>\r\n	<p>Lọc gi&oacute; c&oacute; m&agrave;u <strong>đen, bẩn hoặc bị tắc nghẽn</strong></p>\r\n	</li>\r\n</ul>\r\n\r\n<h3>5. C&aacute;ch vệ sinh v&agrave; bảo dưỡng lọc gi&oacute;</h3>\r\n\r\n<p>Để đảm bảo m&aacute;y ph&aacute;t điện hoạt động ổn định, bạn n&ecirc;n:</p>\r\n\r\n<ul>\r\n	<li>\r\n	<p><strong>Kiểm tra định kỳ</strong>: Khoảng 100&ndash;300 giờ hoạt động (t&ugrave;y m&ocirc;i trường).</p>\r\n	</li>\r\n	<li>\r\n	<p><strong>Vệ sinh lọc gi&oacute;</strong>:</p>\r\n\r\n	<ul>\r\n		<li>\r\n		<p>Với lọc giấy: d&ugrave;ng kh&iacute; n&eacute;n thổi bụi (kh&ocirc;ng rửa nước).</p>\r\n		</li>\r\n		<li>\r\n		<p>Với lọc m&uacute;t: c&oacute; thể rửa bằng nước v&agrave; dung dịch nhẹ, sau đ&oacute; phơi kh&ocirc;.</p>\r\n		</li>\r\n	</ul>\r\n	</li>\r\n	<li>\r\n	<p><strong>Thay mới</strong>: Khi lọc bị hư hỏng hoặc kh&ocirc;ng thể l&agrave;m sạch.</p>\r\n	</li>\r\n</ul>\r\n\r\n<h3>6. Một số lưu &yacute; khi sử dụng</h3>\r\n\r\n<ul>\r\n	<li>\r\n	<p>Kh&ocirc;ng vận h&agrave;nh m&aacute;y khi <strong>kh&ocirc;ng c&oacute; lọc gi&oacute;</strong>.</p>\r\n	</li>\r\n	<li>\r\n	<p>Sử dụng <strong>lọc gi&oacute; ch&iacute;nh h&atilde;ng hoặc ph&ugrave; hợp</strong> với từng loại m&aacute;y.</p>\r\n	</li>\r\n	<li>\r\n	<p>Đặt m&aacute;y ở m&ocirc;i trường <strong>&iacute;t bụi</strong> để giảm tải cho lọc gi&oacute;.</p>\r\n	</li>\r\n</ul>','Trong hệ thống máy phát điện, bộ phận lọc gió là một chi tiết tuy nhỏ nhưng đóng vai trò vô cùng quan trọng trong việc đảm bảo hiệu suất hoạt động và tuổi thọ của động cơ.',1,'1774026254164_images.jpg','Kỹ thuật viên hệ thống','Lọc gió','published',3,'2026-03-21 00:03:00','2026-03-21 00:03:59','2026-03-21 00:05:40'),(2,'Các bước thay dầu nhớt máy phát điện đơn giản, hiệu quả ngay tại nhà','cac-buoc-thay-dau-nhot-may-phat-dien-don-gian-hieu-qua-ngay-tai-nha','Thay dầu nhớt cho máy phát điện','<h2>1. Tại Sao Thay Dầu Nhớt Lại Quan Trọng Đến Thế?</h2>\r\n\r\n<p>Dầu nhớt trong động cơ m&aacute;y ph&aacute;t điện thực hiện rất nhiều vai tr&ograve; quan trọng, trong đ&oacute; phải kể đến như:</p>\r\n\r\n<p><a href=\"https://tongkhomayphatdien.com/wp-content/uploads/2023/10/tai-sao-phai-thay-dau-nhot-may-phat-dien.jpg\"><img alt=\"tai-sao-phai-thay-dau-nhot-may-phat-dien\" src=\"https://tongkhomayphatdien.com/wp-content/uploads/2023/10/tai-sao-phai-thay-dau-nhot-may-phat-dien.jpg\" style=\"height:600px; width:800px\" /></a></p>\r\n\r\n<p>Thay dầu nhớt m&aacute;y ph&aacute;t điện đem lại nhiều lợi &iacute;ch</p>\r\n\r\n<ul>\r\n	<li><strong>B&ocirc;i trơn &amp; giảm m&agrave;i m&ograve;n:</strong>&nbsp;Đ&acirc;y l&agrave; chức năng ch&iacute;nh gi&uacute;p c&aacute;c bộ phận chuyển động như piston, trục khuỷu, xu p&aacute;p&hellip; lướt nhẹ nh&agrave;ng, kh&ocirc;ng bị cọ s&aacute;t l&agrave;m m&ograve;n kim loại.</li>\r\n	<li><strong>L&agrave;m m&aacute;t:</strong>&nbsp;Dầu nhớt lu&acirc;n chuyển khắp động cơ, hấp thụ nhiệt v&agrave; gi&uacute;p giải nhiệt cho c&aacute;c chi tiết n&oacute;ng.</li>\r\n	<li><strong>L&agrave;m sạch:</strong>&nbsp;Dầu cuốn tr&ocirc;i bụi bẩn, cặn carbon, mạt kim loại nhỏ sinh ra trong qu&aacute; tr&igrave;nh hoạt động, giữ cho động cơ lu&ocirc;n sạch sẽ (c&aacute;c chất bẩn n&agrave;y sẽ được giữ lại ở lọc dầu).</li>\r\n	<li><strong>L&agrave;m k&iacute;n:</strong>&nbsp;Dầu tạo lớp m&agrave;ng mỏng gi&uacute;p l&agrave;m k&iacute;n khe hở giữa piston v&agrave; xi lanh, duy tr&igrave; &aacute;p suất n&eacute;n.</li>\r\n	<li><strong>Chống gỉ s&eacute;t:</strong>&nbsp;Ngăn chặn nước v&agrave; axit (sản phẩm phụ của qu&aacute; tr&igrave;nh đốt nhi&ecirc;n liệu) ăn m&ograve;n c&aacute;c chi tiết kim loại b&ecirc;n trong.</li>\r\n</ul>\r\n\r\n<p>Dầu nhớt sau một thời gian sử dụng sẽ bị biến chất (oxi h&oacute;a, nhiễm bẩn), mất đi khả năng bảo vệ động cơ. V&igrave; vậy, thay dầu định kỳ l&agrave; &ldquo;ch&igrave;a kh&oacute;a&rdquo; để m&aacute;y ph&aacute;t điện của bạn hoạt động ổn định, bền bỉ v&agrave; k&eacute;o d&agrave;i tuổi thọ.</p>\r\n\r\n<blockquote>\r\n<p>Ch&uacute;ng ta đ&atilde; c&ugrave;ng t&igrave;m hiểu tầm quan trọng của việc thay dầu nhớt động cơ m&aacute;y ph&aacute;t điện, hiểu được những vai tr&ograve; thiết yếu của dầu trong việc bảo vệ v&agrave; duy tr&igrave; hiệu suất của m&aacute;y. Vậy, c&acirc;u hỏi tiếp theo l&agrave;: Khi n&agrave;o bạn cần thay dầu nhớt cho m&aacute;y ph&aacute;t điện để đảm bảo m&aacute;y lu&ocirc;n hoạt động trong t&igrave;nh trạng tốt nhất?</p>\r\n</blockquote>\r\n\r\n<h2>2. Khi N&agrave;o Cần Thay Dầu Nhớt Cho M&aacute;y Ph&aacute;t Điện?</h2>\r\n\r\n<p>Đ&acirc;y l&agrave; c&acirc;u hỏi nhiều người quan t&acirc;m. Thời gian thay dầu nhớt thường được t&iacute;nh theo số giờ hoạt động của m&aacute;y hoặc thời gian sử dụng, t&ugrave;y theo điều kiện n&agrave;o đến trước.</p>\r\n\r\n<h3>2.1. Theo Giờ Hoạt Động</h3>\r\n\r\n<ul>\r\n	<li>Với hầu hết c&aacute;c d&ograve;ng m&aacute;y ph&aacute;t điện chạy dầu Diesel th&ocirc;ng thường: N&ecirc;n thay dầu sau khoảng 300 &ndash; 400 giờ hoạt động.</li>\r\n	<li>Trong m&ocirc;i trường khắc nghiệt (bụi bẩn nhiều, nhiệt độ cao, tải nặng thường xuy&ecirc;n): N&ecirc;n thay dầu sớm hơn, sau khoảng 200 &ndash; 250 giờ hoạt động.</li>\r\n</ul>\r\n\r\n<blockquote>\r\n<p><strong>LU&Ocirc;N LU&Ocirc;N ƯU TI&Ecirc;N</strong>&nbsp;kiểm tra s&aacute;ch hướng dẫn sử dụng đi k&egrave;m m&aacute;y của bạn. Nh&agrave; sản xuất sẽ đưa ra khuyến c&aacute;o ch&iacute;nh x&aacute;c nhất cho model m&aacute;y đ&oacute;.</p>\r\n</blockquote>\r\n\r\n<h3>2.2. Theo Thời Gian Sử Dụng (Kể cả khi &iacute;t chạy)</h3>\r\n\r\n<ul>\r\n	<li>Dầu nhớt vẫn bị oxi h&oacute;a v&agrave; biến chất theo thời gian ngay cả khi m&aacute;y kh&ocirc;ng chạy.</li>\r\n	<li>Nếu m&aacute;y &iacute;t d&ugrave;ng, bạn vẫn n&ecirc;n thay dầu nhớt &iacute;t nhất mỗi 6 th&aacute;ng đến 1 năm.</li>\r\n</ul>\r\n\r\n<h3>2.3. Kiểm tra bằng mắt thường</h3>\r\n\r\n<p>Nếu kiểm tra que thăm dầu thấy dầu chuyển sang m&agrave;u đen đậm, c&oacute; m&ugrave;i kh&eacute;t, lẫn nhiều cặn bẩn hoặc độ nhớt giảm r&otilde; rệt (dầu lo&atilde;ng như nước), th&igrave; khả năng cao l&agrave; cần thay dầu ngay, kể cả khi chưa đủ giờ chạy theo khuyến c&aacute;o.</p>\r\n\r\n<blockquote>\r\n<p><strong>Đừng k&eacute;o d&agrave;i thời gian thay dầu!</strong>&nbsp;Dầu cũ kh&ocirc;ng c&ograve;n khả năng b&ocirc;i trơn tốt sẽ l&agrave;m c&aacute;c chi tiết bị m&agrave;i m&ograve;n, t&iacute;ch tụ cặn carbon đ&oacute;ng k&eacute;t trong buồng đốt v&agrave; c&aacute;c đường dầu, dẫn đến giảm hiệu suất, tăng ti&ecirc;u hao nhi&ecirc;n liệu v&agrave; tệ nhất l&agrave; hỏng động cơ (b&oacute; m&aacute;y, hỏng bạc, m&ograve;n xi lanh&hellip;). Sửa chữa những lỗi n&agrave;y tốn k&eacute;m hơn thay dầu rất nhiều!</p>\r\n</blockquote>\r\n\r\n<p>Bạn đ&atilde; nắm r&otilde; thời điểm cần thay dầu nhớt cho m&aacute;y ph&aacute;t điện, dựa tr&ecirc;n số giờ hoạt động, thời gian sử dụng v&agrave; dấu hiệu kiểm tra bằng mắt thường. Để qu&aacute; tr&igrave;nh thay dầu diễn ra su&ocirc;n sẻ v&agrave; hiệu quả, bước chuẩn bị l&agrave; v&ocirc; c&ugrave;ng quan trọng. Vậy, cần chuẩn bị những g&igrave; trước khi thay dầu nhớt để đảm bảo an to&agrave;n v&agrave; đạt kết quả tốt nhất?</p>\r\n\r\n<h2>3. Chuẩn Bị G&igrave; Trước Khi Thay Dầu Nhớt</h2>\r\n\r\n<p>Một khi đ&atilde; x&aacute;c định cần thay dầu, việc chuẩn bị đầy đủ sẽ gi&uacute;p c&ocirc;ng việc diễn ra su&ocirc;n sẻ, nhanh ch&oacute;ng v&agrave; sạch sẽ.</p>\r\n\r\n<h3>3.1. Chuẩn Bị Dầu Nhớt Mới</h3>\r\n\r\n<ul>\r\n	<li><strong>Loại:</strong>&nbsp;Phải đ&uacute;ng loại dầu theo khuyến c&aacute;o của nh&agrave; sản xuất m&aacute;y ph&aacute;t điện (thường l&agrave; dầu động cơ Diesel, cấp API như CF, CI-4, CK-4&hellip; v&agrave; độ nhớt như SAE 15W-40, 10W-30&hellip; ph&ugrave; hợp với nhiệt độ m&ocirc;i trường). Kiểm tra s&aacute;ch hướng dẫn sử dụng m&aacute;y l&agrave; tốt nhất! Tr&aacute;nh d&ugrave;ng dầu động cơ xăng cho m&aacute;y dầu v&agrave; ngược lại.</li>\r\n	<li><strong>Số lượng:</strong>&nbsp;Kiểm tra s&aacute;ch hướng dẫn để biết dung t&iacute;ch dầu cần thiết của m&aacute;y. Chuẩn bị dư ra một ch&uacute;t để ph&ograve;ng trường hợp cần ch&acirc;m th&ecirc;m.</li>\r\n</ul>\r\n\r\n<h3>3.2. Chuẩn Bị Lọc Dầu Mới (Nếu m&aacute;y c&oacute; lọc dầu v&agrave; cần thay)</h3>\r\n\r\n<ul>\r\n	<li>Hầu hết c&aacute;c m&aacute;y ph&aacute;t điện chạy dầu Diesel đều c&oacute; lọc dầu. Lọc dầu n&ecirc;n được thay c&ugrave;ng với dầu nhớt để đảm bảo hiệu quả l&agrave;m sạch tốt nhất.</li>\r\n	<li>Mua đ&uacute;ng loại lọc dầu ph&ugrave; hợp với model m&aacute;y của bạn.</li>\r\n</ul>\r\n\r\n<h3>3.3. Chuẩn Bị Dụng Cụ</h3>\r\n\r\n<ul>\r\n	<li><strong>Khay/Th&ugrave;ng chứa dầu cũ</strong>: Phải đủ lớn để chứa hết lượng dầu cũ từ m&aacute;y.</li>\r\n	<li><strong>Bộ cờ l&ecirc;/tu&yacute;p</strong>: K&iacute;ch cỡ ph&ugrave; hợp để th&aacute;o ốc xả dầu v&agrave; c&oacute; thể cần dụng cụ chuy&ecirc;n dụng để th&aacute;o lọc dầu (cảo lọc dầu).</li>\r\n	<li><strong>Phễu</strong>: Gi&uacute;p đổ dầu mới v&agrave;o động cơ dễ d&agrave;ng, kh&ocirc;ng bị đổ ra ngo&agrave;i.</li>\r\n	<li><strong>Giẻ lau sạch hoặc giấy thấm</strong>: Để lau ch&ugrave;i dầu bẩn bị rớt ra.</li>\r\n	<li><strong>Găng tay bảo hộ:</strong>&nbsp;Dầu cũ c&oacute; thể chứa chất độc hại, tr&aacute;nh tiếp x&uacute;c trực tiếp.</li>\r\n	<li><strong>K&iacute;nh bảo hộ</strong>: Để bảo vệ mắt.</li>\r\n	<li><strong>C&oacute; thể cần th&ecirc;m</strong>: Tấm l&oacute;t s&agrave;n (bạt, b&igrave;a carton&hellip;) để tr&aacute;nh l&agrave;m bẩn nền nh&agrave;/xưởng.</li>\r\n</ul>\r\n\r\n<blockquote>\r\n<p><strong>Lưu &yacute;</strong>: Chọn nơi bằng phẳng, kh&ocirc; r&aacute;o, tho&aacute;ng kh&iacute; v&agrave; dễ d&agrave;ng thu gom dầu thải.</p>\r\n</blockquote>\r\n\r\n<p>Bạn đ&atilde; c&oacute; trong tay đầy đủ những vật liệu v&agrave; dụng cụ cần thiết trước khi thay dầu nhớt. Giờ đ&acirc;y, ch&uacute;ng ta sẽ đi v&agrave;o phần quan trọng nhất: chi tiết 6 bước thay dầu nhớt m&aacute;y ph&aacute;t điện. H&atilde;y l&agrave;m theo từng bước một c&aacute;ch cẩn thận để đảm bảo an to&agrave;n v&agrave; hiệu quả tối đa.</p>\r\n\r\n<h2>4. Chi Tiết C&aacute;c Bước Thay Dầu Nhớt M&aacute;y Ph&aacute;t Điện</h2>\r\n\r\n<p>Đ&acirc;y l&agrave; phần quan trọng nhất, Bạn h&atilde;y l&agrave;m theo từng bước thật cẩn thận!</p>\r\n\r\n<h3>Bước 1: Đảm bảo An To&agrave;n &amp; L&agrave;m Ấm Động Cơ</h3>\r\n\r\n<ul>\r\n	<li>Đảm bảo m&aacute;y ph&aacute;t điện đ&atilde;&nbsp;<strong>TẮT HO&Agrave;N TO&Agrave;N</strong>, r&uacute;t ch&igrave;a kh&oacute;a (nếu c&oacute;) hoặc ngắt c&ocirc;ng tắc khởi động để m&aacute;y kh&ocirc;ng thể tự hoạt động ngo&agrave;i &yacute; muốn.</li>\r\n	<li>Động cơ khi thay dầu n&ecirc;n c&ograve;n ấm (kh&ocirc;ng n&oacute;ng hổi, cũng kh&ocirc;ng nguội tanh). Việc n&agrave;y gi&uacute;p dầu cũ lo&atilde;ng hơn v&agrave; chảy ra dễ d&agrave;ng, cuốn theo cặn bẩn tốt hơn. Nếu m&aacute;y đang nguội, h&atilde;y cho chạy kh&ocirc;ng tải khoảng 5-10 ph&uacute;t rồi tắt m&aacute;y.</li>\r\n	<li>Đeo găng tay v&agrave; k&iacute;nh bảo hộ v&agrave;o.</li>\r\n</ul>\r\n\r\n<h3>Bước 2: X&aacute;c Định Vị Tr&iacute; &amp; Chuẩn Bị Xả Dầu</h3>\r\n\r\n<ul>\r\n	<li>T&igrave;m vị tr&iacute; ốc xả dầu ở dưới đ&aacute;y động cơ (thường l&agrave; bulong lớn nhất ở dưới đ&aacute;y).</li>\r\n	<li>T&igrave;m vị tr&iacute; lọc dầu (nếu c&oacute;) &ndash; thường l&agrave; một hộp kim loại h&igrave;nh trụ vặn v&agrave;o th&acirc;n động cơ.</li>\r\n	<li>Đặt khay chứa dầu cũ ngay dưới ốc xả dầu, đảm bảo khay đủ rộng v&agrave; vị tr&iacute; ch&iacute;nh x&aacute;c để hứng to&agrave;n bộ lượng dầu khi chảy ra. Đặt tấm l&oacute;t s&agrave;n (nếu c&oacute;) b&ecirc;n dưới đề ph&ograve;ng dầu rớt.</li>\r\n</ul>\r\n\r\n<h3>Bước 3: Xả Hết Dầu Cũ Ra Ngo&agrave;i</h3>\r\n\r\n<ul>\r\n	<li>D&ugrave;ng cờ l&ecirc; ph&ugrave; hợp từ từ nới lỏng ốc xả dầu.&nbsp;<strong>Lưu &yacute;:</strong>&nbsp;Dầu c&oacute; thể c&ograve;n n&oacute;ng, h&atilde;y cẩn thận.</li>\r\n	<li>Khi ốc đ&atilde; lỏng, d&ugrave;ng tay từ từ th&aacute;o hẳn ốc ra. Bạn cố gắng giữ ốc kh&ocirc;ng rơi v&agrave;o khay dầu bẩn. L&uacute;c n&agrave;y dầu cũ sẽ bắt đầu chảy mạnh xuống khay.</li>\r\n	<li>Để dầu chảy ra hết ho&agrave;n to&agrave;n c&oacute; thể sẽ mất v&agrave;i ph&uacute;t. Bạn h&atilde;y nghi&ecirc;ng m&aacute;y để dầu chảy ra sạch hơn.</li>\r\n	<li>Trong l&uacute;c chờ dầu chảy hết, bạn c&oacute; thể tranh thủ vệ sinh sơ khu vực xung quanh lỗ xả dầu v&agrave; vị tr&iacute; lắp lọc dầu bằng giẻ sạch.</li>\r\n</ul>\r\n\r\n<p><a href=\"https://tongkhomayphatdien.com/wp-content/uploads/2023/10/xa-dau-cu-ra-ngoai.jpg\"><img alt=\"xa-dau-cu-ra-ngoai\" src=\"https://tongkhomayphatdien.com/wp-content/uploads/2023/10/xa-dau-cu-ra-ngoai.jpg\" style=\"height:600px; width:800px\" /></a></p>\r\n\r\n<p>Xả hết dầu cũ ra ngo&agrave;i</p>\r\n\r\n<h3>Bước 4: Thay Lọc Dầu</h3>\r\n\r\n<ul>\r\n	<li>Sau khi dầu đ&atilde; chảy hết, di chuyển khay dầu bẩn ra một ch&uacute;t.</li>\r\n	<li>Sử dụng cảo lọc dầu hoặc d&ugrave;ng tay để th&aacute;o lọc dầu cũ ra.&nbsp;<strong>Lưu &yacute;:</strong>&nbsp;Vẫn sẽ c&oacute; một &iacute;t dầu c&ograve;n đọng trong lọc chảy ra khi bạn th&aacute;o, h&atilde;y chuẩn bị giẻ hoặc khay nhỏ hơn để hứng.</li>\r\n	<li>D&ugrave;ng một ch&uacute;t dầu nhớt mới thoa l&ecirc;n gioăng cao su (miếng đệm tr&ograve;n m&agrave;u đen) ở miệng lọc dầu mới. Việc n&agrave;y gi&uacute;p gioăng k&iacute;n hơn v&agrave; lần sau dễ th&aacute;o hơn.</li>\r\n	<li>Đổ một &iacute;t dầu nhớt mới (khoảng 1/3 &ndash; 1/2 lọc) v&agrave;o lọc dầu mới trước khi lắp. Điều n&agrave;y gi&uacute;p hệ thống b&ocirc;i trơn được l&agrave;m đầy nhanh hơn khi khởi động lại m&aacute;y.</li>\r\n	<li>Tiếp theo bạn cần vặn bằng tay cho đến khi gioăng chạm v&agrave;o th&acirc;n động cơ, sau đ&oacute; siết th&ecirc;m khoảng 1/2 đến 3/4 v&ograve;ng nữa bằng tay hoặc theo chỉ dẫn tr&ecirc;n vỏ lọc/s&aacute;ch hướng dẫn m&aacute;y.&nbsp;<strong>Đừng siết qu&aacute; chặt</strong>,&nbsp;v&igrave;&nbsp;c&oacute; thể l&agrave;m biến dạng gioăng, g&acirc;y r&ograve; rỉ hoặc rất kh&oacute; th&aacute;o lần sau.</li>\r\n</ul>\r\n\r\n<h3>Bước 5: Vặn Lại Ốc Xả Dầu &amp; Đổ Dầu Nhớt Mới</h3>\r\n\r\n<ul>\r\n	<li>Lắp lại ốc xả dầu (nhớ kiểm tra v&ograve;ng đệm/long đền nếu c&oacute;, n&ecirc;n thay mới v&ograve;ng đệm nếu n&oacute; bị hỏng hoặc xẹp).</li>\r\n	<li>D&ugrave;ng cờ l&ecirc; siết chặt ốc xả dầu. Khi siết bạn cần siết vừa đủ chặt, kh&ocirc;ng d&ugrave;ng hết sức siết qu&aacute; mạnh, đặc biệt l&agrave; ốc xả dầu thường nằm tr&ecirc;n vật liệu nh&ocirc;m của c&aacute;c-te, siết qu&aacute; đ&agrave; c&oacute; thể l&agrave;m chờn ren, hỏng lỗ xả dầu cực kỳ tốn k&eacute;m để sửa chữa!</li>\r\n	<li>Đặt phễu v&agrave;o lỗ ch&acirc;m dầu (thường ở ph&iacute;a tr&ecirc;n động cơ, c&oacute; nắp hoặc que thăm dầu đi k&egrave;m).</li>\r\n	<li>Từ từ đổ lượng dầu nhớt mới đ&atilde; chuẩn bị v&agrave;o động cơ qua phễu.</li>\r\n</ul>\r\n\r\n<p><a href=\"https://tongkhomayphatdien.com/wp-content/uploads/2023/10/thay-dau-nhot-moi-cho-may-phat-dien.jpg\"><img alt=\"thay-dau-nhot-moi-cho-may-phat-dien\" src=\"https://tongkhomayphatdien.com/wp-content/uploads/2023/10/thay-dau-nhot-moi-cho-may-phat-dien.jpg\" style=\"height:600px; width:800px\" /></a></p>\r\n\r\n<p>Đổ dầu nhớt mới cho m&aacute;y ph&aacute;t điện</p>\r\n\r\n<h3>Bước 6: Kiểm Tra Mức Dầu Lần Đầu</h3>\r\n\r\n<ul>\r\n	<li>Sau khi đổ gần hết lượng dầu khuyến c&aacute;o th&igrave; mới r&uacute;t phễu ra.</li>\r\n	<li>R&uacute;t que thăm dầu ra, lau sạch bằng giẻ.</li>\r\n	<li>Cắm que thăm dầu v&agrave;o lại hết cỡ (hoặc vặn ren v&agrave;o nếu que thăm c&oacute; ren), sau đ&oacute; r&uacute;t ra.</li>\r\n	<li>Kiểm tra mức dầu tr&ecirc;n que thăm. Mức dầu l&yacute; tưởng l&agrave; nằm giữa hai vạch MIN v&agrave; MAX, hoặc chạm vạch MAX. Nếu chưa đủ, ch&acirc;m th&ecirc;m từ từ từng ch&uacute;t một v&agrave; kiểm tra lại bằng que thăm cho đến khi đạt mức mong muốn.&nbsp;<strong>Đừng đổ qu&aacute; vạch MAX</strong>, nếu qu&aacute; nhiều dầu cũng c&oacute; thể g&acirc;y hại cho động cơ.</li>\r\n</ul>\r\n\r\n<h3>Bước 7: Khởi Động M&aacute;y &amp; Kiểm Tra Ban Đầu</h3>\r\n\r\n<ul>\r\n	<li>Sau khi đ&atilde; ch&acirc;m đủ dầu, đ&oacute;ng nắp ch&acirc;m dầu lại.</li>\r\n	<li><a href=\"https://tongkhomayphatdien.com/cach-bat-may-phat-dien/\">Khởi động m&aacute;y ph&aacute;t điện</a>&nbsp;v&agrave; cho chạy kh&ocirc;ng tải khoảng 1-2 ph&uacute;t. Mục đ&iacute;ch l&agrave; để bơm dầu mới lu&acirc;n chuyển khắp c&aacute;c chi tiết v&agrave; l&agrave;m đầy lọc dầu.</li>\r\n	<li>Nghe xem tiếng động cơ c&oacute; g&igrave; bất thường kh&ocirc;ng? C&oacute; đ&egrave;n b&aacute;o &aacute;p suất dầu tr&ecirc;n bảng điều khiển kh&ocirc;ng? (Nếu c&oacute;, đ&egrave;n n&agrave;y sẽ tắt sau v&agrave;i gi&acirc;y khi dầu đ&atilde; được bơm l&ecirc;n).</li>\r\n	<li>Nh&igrave;n quanh khu vực ốc xả dầu v&agrave; lọc dầu xem c&oacute; bị r&ograve; rỉ kh&ocirc;ng.</li>\r\n</ul>\r\n\r\n<h3>Bước 8: Tắt M&aacute;y, Chờ Dầu Hồi Về v&agrave; Kiểm Tra Lại Mức Dầu Cuối C&ugrave;ng</h3>\r\n\r\n<ul>\r\n	<li>Tắt m&aacute;y ph&aacute;t điện.</li>\r\n	<li>Chờ khoảng 5-10 ph&uacute;t để to&agrave;n bộ dầu tr&ecirc;n động cơ chảy hết về đ&aacute;y c&aacute;c-te.</li>\r\n	<li>Kiểm tra lại mức dầu bằng que thăm lần cuối theo c&aacute;ch tương tự Bước 6. Th&ocirc;ng thường, mức dầu sẽ hơi giảm xuống sau khi l&agrave;m đầy lọc v&agrave; c&aacute;c đường dẫn dầu.</li>\r\n	<li>Nếu mức dầu dưới vạch MAX, ch&acirc;m th&ecirc;m dầu từ từ cho đến khi đạt mức MAX tr&ecirc;n que thăm.</li>\r\n</ul>\r\n\r\n<h3>Bước 9: Thu Gom v&agrave; Xử L&yacute; Dầu Thải</h3>\r\n\r\n<ul>\r\n	<li>Dầu nhớt cũ v&agrave; lọc dầu cũ l&agrave; chất thải nguy hại, kh&ocirc;ng được đổ ra m&ocirc;i trường.</li>\r\n	<li>Đậy k&iacute;n th&ugrave;ng chứa dầu cũ v&agrave; lọc dầu cũ.</li>\r\n	<li>Đưa đến c&aacute;c điểm thu gom dầu thải, cửa h&agrave;ng sửa chữa &ocirc; t&ocirc;/xe m&aacute;y hoặc c&aacute;c đơn vị chuy&ecirc;n xử l&yacute; chất thải nguy hại theo quy định của địa phương. Việc n&agrave;y gi&uacute;p bảo vệ m&ocirc;i trường của ch&uacute;ng ta.</li>\r\n</ul>\r\n\r\n<p>Ch&uacute;ng ta đ&atilde; c&ugrave;ng thực hiện chi tiết 6 bước thay dầu nhớt m&aacute;y ph&aacute;t điện, từ việc xả dầu cũ đến ch&acirc;m dầu mới v&agrave; kiểm tra ban đầu. Để đảm bảo qu&aacute; tr&igrave;nh n&agrave;y diễn ra su&ocirc;n sẻ v&agrave; mang lại hiệu quả l&acirc;u d&agrave;i, c&oacute; một v&agrave;i lưu &yacute; quan trọng khi thay dầu m&aacute;y ph&aacute;t điện m&agrave; bạn cần ghi nhớ.</p>\r\n\r\n<h2>5. Một V&agrave;i Lưu &Yacute; Khi Thay Dầu M&aacute;y Ph&aacute;t Điện</h2>\r\n\r\n<p><a href=\"https://tongkhomayphatdien.com/wp-content/uploads/2023/10/luu-y-khi-thay-dau-may-phat-dien.jpg\"><img alt=\"luu-y-khi-thay-dau-may-phat-dien\" src=\"https://tongkhomayphatdien.com/wp-content/uploads/2023/10/luu-y-khi-thay-dau-may-phat-dien.jpg\" style=\"height:600px; width:800px\" /></a></p>\r\n\r\n<p>Lưu &yacute; khi thay dầu m&aacute;y ph&aacute;t điện</p>\r\n\r\n<ul>\r\n	<li><strong>Tuyệt đối kh&ocirc;ng d&ugrave;ng dầu k&eacute;m chất lượng:&nbsp;</strong>Dầu k&eacute;m chất lượng sẽ kh&ocirc;ng đảm bảo khả năng b&ocirc;i trơn, bảo vệ động cơ k&eacute;m, thậm ch&iacute; chứa tạp chất g&acirc;y hại.</li>\r\n	<li><strong>Kh&ocirc;ng pha trộn c&aacute;c loại dầu kh&aacute;c nhau:</strong>&nbsp;Mỗi loại dầu c&oacute; c&ocirc;ng thức phụ gia kh&aacute;c nhau, pha trộn c&oacute; thể g&acirc;y kết tủa, l&agrave;m giảm khả năng b&ocirc;i trơn.</li>\r\n	<li><strong>Đừng chủ quan với mức dầu:</strong>&nbsp;Thường xuy&ecirc;n kiểm tra mức dầu bằng que thăm, kh&ocirc;ng chỉ khi thay m&agrave; cả trong qu&aacute; tr&igrave;nh sử dụng m&aacute;y, đặc biệt trước những lần chạy d&agrave;i. Khi thiếu dầu hoặc qu&aacute; nhiều dầu đều kh&ocirc;ng tốt.</li>\r\n	<li><strong>Vệ sinh khu vực l&agrave;m việc:</strong>&nbsp;Dầu nhớt bẩn rất kh&oacute; l&agrave;m sạch, h&atilde;y cẩn thận v&agrave; chuẩn bị đủ giẻ lau, tấm l&oacute;t.</li>\r\n	<li><strong>Ghi lại lịch sử bảo dưỡng:</strong>&nbsp;Ghi lại ng&agrave;y/giờ chạy khi thay dầu nhớt để tiện theo d&otilde;i lần thay tiếp theo. Hoặc bạn cũng c&oacute; thể tham khảo&nbsp;<a href=\"https://tongkhomayphatdien.com/nhung-moc-thoi-gian-can-bao-duong-may-phat-dien/\">mốc thời gian bảo dưỡng m&aacute;y ph&aacute;t điện</a>&nbsp;để hạn chế việc ghi ch&eacute;p phiền to&aacute;i.</li>\r\n</ul>\r\n\r\n<p>Bạn đ&atilde; nắm được những lưu &yacute; quan trọng khi thay dầu m&aacute;y ph&aacute;t điện, gi&uacute;p đảm bảo an to&agrave;n v&agrave; hiệu quả. Mặc d&ugrave; việc thay dầu nhớt l&agrave; một c&ocirc;ng việc bảo dưỡng cơ bản, nhưng kh&ocirc;ng phải l&uacute;c n&agrave;o bạn cũng c&oacute; thể tự m&igrave;nh thực hiện. Vậy, khi n&agrave;o bạn n&ecirc;n gọi cho chuy&ecirc;n gia để được hỗ trợ tốt nhất?</p>\r\n\r\n<h2>6. Khi N&agrave;o Bạn N&ecirc;n Gọi Cho Chuy&ecirc;n Gia?</h2>\r\n\r\n<p>Mặc d&ugrave; việc thay dầu nhớt kh&aacute; đơn giản, nhưng c&oacute; những trường hợp bạn n&ecirc;n li&ecirc;n hệ với&nbsp;<a href=\"https://tongkhomayphatdien.com/\"><strong>Benzen Power</strong></a>:</p>\r\n\r\n<ul>\r\n	<li>Bạn cảm thấy kh&ocirc;ng tự tin hoặc kh&ocirc;ng c&oacute; đủ dụng cụ.</li>\r\n	<li>M&aacute;y ph&aacute;t điện của bạn l&agrave; loại c&ocirc;ng suất lớn, cấu tạo phức tạp.</li>\r\n	<li>Bạn gặp kh&oacute; khăn trong việc x&aacute;c định loại dầu, lọc dầu ph&ugrave; hợp.</li>\r\n	<li>Sau khi thay dầu, m&aacute;y c&oacute; dấu hiệu bất thường (tiếng k&ecirc;u lạ, r&ograve; rỉ dầu&hellip;).</li>\r\n	<li>Bạn muốn kiểm tra tổng thể c&aacute;c hạng mục bảo dưỡng kh&aacute;c.</li>\r\n</ul>','Quy trình này tuy dễ nhưng lại vô cùng quan trọng để duy trì tuổi thọ và hiệu suất của máy.',1,'1774026547457_tai-sao-phai-thay-dau-nhot-may-phat-dien.jpg','Kỹ thuật viên hệ thống','Dầu nhớt','published',3,'2026-03-21 00:08:00','2026-03-21 00:08:11','2026-03-21 00:09:27'),(3,'Hướng dẫn làm sạch bộ lọc gió máy phát điện đúng cách','huong-dan-lam-sach-bo-loc-gio-may-phat-dien-dung-cach','Bụi bẩn và mảnh vụn có thể tích tụ lâu ngày trên bộ lọc gió, từ đó làm ảnh hưởng đến hiệu suất hoạt động của máy phát điện. Vậy Điện máy XANH sẽ hướng dẫn chi tiết cho bạn cách làm sạch bộ lọc gió máy phát điện sao cho hiệu quả và đúng cách nhé!','<h3>1Bộ lọc gi&oacute; m&aacute;y ph&aacute;t điện c&oacute; chức năng g&igrave;?</h3>\r\n\r\n<p>Bộ lọc gi&oacute; m&aacute;y ph&aacute;t điện c&oacute; khả năng loại bỏ bụi bẩn v&agrave; c&aacute;c chất cặn bẩn kh&aacute;c trong kh&ocirc;ng kh&iacute; trước khi đưa v&agrave;o bộ phận buồng đốt, nhờ đ&oacute; gi&uacute;p cho động cơ m&aacute;y hoạt động ổn định v&agrave; bền bỉ hơn.</p>\r\n\r\n<p>C&oacute; thể n&oacute;i, m&aacute;y ph&aacute;t điện c&agrave;ng hoạt động nhiều th&igrave; bộ lọc gi&oacute; c&agrave;ng b&aacute;m nhiều bụi. L&uacute;c n&agrave;y, bạn cần phải vệ sinh bộ lọc gi&oacute;, nhằm tr&aacute;nh l&agrave;m giảm lượng kh&ocirc;ng kh&iacute; đi v&agrave;o buồng đốt v&agrave; g&acirc;y ngạt cho động cơ, nhờ đ&oacute; giảm thiểu sự cố g&acirc;y hỏng cho m&aacute;y ph&aacute;t điện.</p>\r\n\r\n<p><strong>Xem th&ecirc;m</strong>:&nbsp;<a href=\"https://www.dienmayxanh.com/kinh-nghiem-hay/may-phat-dien-la-gi-phan-loai-cau-tao-nguyen-ly-1485946\" target=\"_blank\">M&aacute;y ph&aacute;t điện l&agrave; g&igrave;? Ph&acirc;n loại, cấu tạo, nguy&ecirc;n l&yacute; hoạt động</a></p>\r\n\r\n<p><img alt=\"Kích thước và hình dạng bộ lọc gió có thể khác nhau tùy theo dòng máy phát điện\" src=\"https://cdn.tgdd.vn//News/1533306//Huong-dan-lam-sach-bo-loc-gio-may-phat-dien-dung-cach-1-730x436.jpg\" /></p>\r\n\r\n<p>K&iacute;ch thước v&agrave; h&igrave;nh dạng bộ lọc gi&oacute; c&oacute; thể kh&aacute;c nhau t&ugrave;y theo d&ograve;ng m&aacute;y ph&aacute;t điện</p>\r\n\r\n<h3>2Dấu hiệu cần vệ sinh bộ lọc gi&oacute; m&aacute;y ph&aacute;t điện</h3>\r\n\r\n<p>Nhận biết bằng mắt thường</p>\r\n\r\n<p>Bạn c&oacute; thể nhận biết mức độ b&aacute;m bụi tr&ecirc;n bộ lọc gi&oacute; bằng mắt thường. Lớp bụi thường c&oacute;&nbsp;<strong>m&agrave;u x&aacute;m trắng</strong>&nbsp;hoặc&nbsp;<strong>x&aacute;m đen</strong>, b&aacute;m tr&ecirc;n bề mặt của bộ lọc gi&oacute;.</p>\r\n\r\n<p><img alt=\"Bụi bẩn sẽ bám trên bộ lọc gió sau khoảng thời gian dài sử dụng\" src=\"https://cdn.tgdd.vn//News/1533306//Huong-dan-lam-sach-bo-loc-gio-may-phat-dien-dung-cach-2-730x462.jpg\" /></p>\r\n\r\n<p>Bụi bẩn sẽ b&aacute;m tr&ecirc;n bộ lọc gi&oacute; sau khoảng thời gian d&agrave;i sử dụng</p>\r\n\r\n<p>Tăng mức ti&ecirc;u thụ nhi&ecirc;n liệu</p>\r\n\r\n<p>Khi bộ lọc gi&oacute; b&aacute;m nhiều bụi bẩn, động cơ m&aacute;y ph&aacute;t điện sẽ bị thiếu oxy v&agrave; c&oacute; xu hướng đốt ch&aacute;y nhiều nhi&ecirc;n liệu hơn, từ đ&oacute; l&agrave;m giảm hiệu suất hoạt động của m&aacute;y.</p>\r\n\r\n<p><img alt=\"Máy phát điện chạy xăng Tolsen 79987 2200W có thùng xăng 4 lít, khi bộ lọc gió bị bám bẩn nhiều có thể khiến cho máy sử dụng nhiều nhiên liệu hơn để đốt cháy\" src=\"https://cdn.tgdd.vn//News/1533306//Huong-dan-lam-sach-bo-loc-gio-may-phat-dien-dung-cach-3-730x426.jpg\" /></p>\r\n\r\n<p><a href=\"https://www.dienmayxanh.com/may-phat-dien/tolsen-79987-3500w\" target=\"_blank\">M&aacute;y ph&aacute;t điện chạy xăng Tolsen 79987 2200W</a>&nbsp;c&oacute; th&ugrave;ng xăng 4 l&iacute;t, khi bộ lọc gi&oacute; bị b&aacute;m bẩn nhiều c&oacute; thể khiến cho m&aacute;y sử dụng nhiều nhi&ecirc;n liệu hơn để đốt ch&aacute;y</p>\r\n\r\n<p>M&aacute;y ph&aacute;t điện kh&ocirc;ng hoạt động hoặc kh&ocirc;ng khởi động được</p>\r\n\r\n<p>Bộ lọc gi&oacute; bẩn sẽ l&agrave;m mất đi sự c&acirc;n bằng giữa hỗn hợp kh&ocirc;ng kh&iacute; v&agrave; nhi&ecirc;n liệu bị mất, khiến cho m&aacute;y ph&aacute;t điện đ&aacute;nh lửa sai v&agrave; động cơ phải hoạt động nhiều hơn.</p>\r\n\r\n<p>Nếu cứ duy tr&igrave; t&igrave;nh trạng bộ lọc gi&oacute; bẩn v&agrave; m&aacute;y ph&aacute;t điện vẫn cứ hoạt động qu&aacute; c&ocirc;ng suất th&igrave; một l&uacute;c n&agrave;o đ&oacute; m&aacute;y sẽ kh&ocirc;ng c&ograve;n khả năng khởi động hoặc kh&ocirc;ng thể hoạt động được nữa.</p>\r\n\r\n<p><img alt=\"Bộ lọc gió bám nhiều bụi có thể làm cho máy phát điện không hoạt động\" src=\"https://cdn.tgdd.vn//News/1533306//Huong-dan-lam-sach-bo-loc-gio-may-phat-dien-dung-cach-4-730x535.jpg\" /></p>\r\n\r\n<p>Bộ lọc gi&oacute; b&aacute;m nhiều bụi c&oacute; thể l&agrave;m cho m&aacute;y ph&aacute;t điện kh&ocirc;ng hoạt động</p>\r\n\r\n<p>Tiếng ồn động cơ bất thường</p>\r\n\r\n<p>Lớp bụi c&agrave;ng b&aacute;m nhiều tr&ecirc;n bộ lọc gi&oacute;, luồng kh&ocirc;ng kh&iacute; đi v&agrave;o buồng đốt sẽ trở n&ecirc;n kh&oacute; khăn, dẫn đến m&aacute;y ph&aacute;t điện xuất hiện c&aacute;c &acirc;m thanh bất thường k&egrave;m theo động cơ m&aacute;y rung lắc dữ dội.</p>\r\n\r\n<p><img alt=\"Máy phát điện có thể xuất hiện tiếng động lạ khi hoạt động do không vệ sinh bộ lọc gió trong khoảng thời gian dài\" src=\"https://cdn.tgdd.vn//News/1533306//Huong-dan-lam-sach-bo-loc-gio-may-phat-dien-dung-cach-5-730x486.jpg\" /></p>\r\n\r\n<p>M&aacute;y ph&aacute;t điện c&oacute; thể xuất hiện tiếng động lạ khi hoạt động do kh&ocirc;ng vệ sinh bộ lọc gi&oacute; trong khoảng thời gian d&agrave;i</p>\r\n\r\n<p>Kh&oacute;i đen từ ống xả</p>\r\n\r\n<p>Do giảm lượng kh&ocirc;ng kh&iacute; đi v&agrave;o buồng đốt, qu&aacute; tr&igrave;nh đốt ch&aacute;y nhi&ecirc;n liệu gặp kh&oacute; khăn v&agrave; c&oacute; thể tạo ra kh&oacute;i đen từ kh&iacute; thải của m&aacute;y.</p>\r\n\r\n<p>Chưa hết, qu&aacute; tr&igrave;nh đốt ch&aacute;y diễn ra kh&ocirc;ng đ&uacute;ng c&aacute;ch như nhi&ecirc;n liệu kh&ocirc;ng được đốt ch&aacute;y hết từ buồng đốt sẽ c&oacute; xu hướng đi xuống hệ thống xả, rồi chảy ra ngo&agrave;i ống xả. Khi chạm v&agrave;o ống xả, phần nhi&ecirc;n liệu n&agrave;y c&oacute; thể bắt ch&aacute;y, tạo ra ngọn lửa v&agrave; nhả kh&oacute;i đen từ ống xả.</p>\r\n\r\n<p><img alt=\"Bộ lọc gió trên máy phát điện bị bám quá nhiều bụi có thể làm xuất hiện khói đen khi máy hoạt động\" src=\"https://cdn.tgdd.vn//News/1533306//Huong-dan-lam-sach-bo-loc-gio-may-phat-dien-dung-cach-6-730x516.jpg\" /></p>\r\n\r\n<p>Bộ lọc gi&oacute; tr&ecirc;n m&aacute;y ph&aacute;t điện bị b&aacute;m qu&aacute; nhiều bụi c&oacute; thể l&agrave;m xuất hiện kh&oacute;i đen khi m&aacute;y hoạt động</p>\r\n\r\n<p>M&ugrave;i nhi&ecirc;n liệu nồng nặc</p>\r\n\r\n<p>Khi nhi&ecirc;n liệu kh&ocirc;ng được đốt ch&aacute;y hết từ buồng đốt, n&oacute; c&oacute; xu hướng đi xuống hệ thống xả, rồi chảy ra ngo&agrave;i ống xả. L&uacute;c n&agrave;y, bạn sẽ ngửi thất m&ugrave;i nhi&ecirc;n liệu nồng nặc.</p>\r\n\r\n<p><img alt=\"Bộ lọc gió quá bẩn làm ảnh hưởng đến quá trình đốt cháy nhiên liệu, từ đó dễ xuất hiện mùi nhiên liệu nồng nặc gây ảnh hưởng đến sức khỏe\" src=\"https://cdn.tgdd.vn//News/1533306//Huong-dan-lam-sach-bo-loc-gio-may-phat-dien-dung-cach-7-730x511.jpg\" /></p>\r\n\r\n<p>Bộ lọc gi&oacute; qu&aacute; bẩn l&agrave;m ảnh hưởng đến qu&aacute; tr&igrave;nh đốt ch&aacute;y nhi&ecirc;n liệu, từ đ&oacute; dễ xuất hiện m&ugrave;i nhi&ecirc;n liệu nồng nặc g&acirc;y ảnh hưởng đến sức khỏe</p>\r\n\r\n<h3>3Hướng dẫn l&agrave;m sạch bộ lọc gi&oacute; m&aacute;y ph&aacute;t điện</h3>\r\n\r\n<p>Tắt m&aacute;y ph&aacute;t điện</p>\r\n\r\n<p>Để đảm bảo an to&agrave;n khi thao t&aacute;c, bạn cần tắt m&aacute;y v&agrave; r&uacute;t d&acirc;y điện của thiết bị ra khỏi ổ cắm nguồn điện. Sau đ&oacute;, bạn chờ cho m&aacute;y ph&aacute;t điện nguội hẳn nếu như vừa mới sử dụng. Cuối c&ugrave;ng, bạn h&atilde;y di chuyển m&aacute;y đến khu vực th&ocirc;ng tho&aacute;ng v&agrave; c&oacute; nhiều &aacute;nh s&aacute;ng.</p>\r\n\r\n<p><img alt=\"Tắt máy phát điện và rút dây điện của thiết bị để đảm bảo an toàn\" src=\"https://cdn.tgdd.vn//News/1533306//Huong-dan-lam-sach-bo-loc-gio-may-phat-dien-dung-cach-8-730x412.jpg\" /></p>\r\n\r\n<p>Tắt m&aacute;y ph&aacute;t điện v&agrave; r&uacute;t d&acirc;y điện của thiết bị để đảm bảo an to&agrave;n</p>\r\n\r\n<p>X&aacute;c định vị tr&iacute; vỏ bộ lọc gi&oacute;</p>\r\n\r\n<p>Hầu hết, bộ lọc gi&oacute; đều được đặt trong hộp nhựa k&iacute;n (vỏ bộ lọc gi&oacute;) v&agrave; được đặt ở vị tr&iacute; b&ecirc;n trong m&aacute;y ph&aacute;t điện. Vị tr&iacute; của hộp bộ lọc gi&oacute; nằm b&ecirc;n cạnh tay cầm khởi động k&eacute;o của m&aacute;y.</p>\r\n\r\n<p>Tuy nhi&ecirc;n, với d&ograve;ng m&aacute;y ph&aacute;t điện biến tần, bạn cần th&aacute;o bảng điều khiển ở ph&iacute;a trước vỏ, rồi mới lấy được hộp bộ lọc gi&oacute; ra ngo&agrave;i.</p>\r\n\r\n<p><img alt=\"Máy phát điện có vị trí bộ lọc gió khác nhau tùy theo sản phẩm\" src=\"https://cdn.tgdd.vn//News/1533306//Huong-dan-lam-sach-bo-loc-gio-may-phat-dien-dung-cach-9-730x502.jpg\" /></p>\r\n\r\n<p>M&aacute;y ph&aacute;t điện c&oacute; vị tr&iacute; bộ lọc gi&oacute; kh&aacute;c nhau t&ugrave;y theo sản phẩm</p>\r\n\r\n<p>Vệ sinh hoặc thay thế bộ lọc gi&oacute;</p>\r\n\r\n<p>Bạn c&oacute; thể d&ugrave;ng m&aacute;y h&uacute;t bụi mini hoặc chổi vệ sinh dụng cụ để loại bỏ lớp bụi bẩn tr&ecirc;n bộ lọc gi&oacute;. Sau đ&oacute;, bạn c&oacute; thể rửa bộ lọc gi&oacute; với hỗn hợp nước giặt tẩy (gồm c&oacute; nước v&agrave; chất giặt tẩy) để l&agrave;m sạch bụi bẩn ho&agrave;n to&agrave;n.</p>\r\n\r\n<p>Tiếp theo, bạn xả bộ lọc với nước sạch, rồi phẩy nhẹ v&agrave; đem phơi hong nắng. Trường hợp, nếu bạn ph&aacute;t hiện bộ lọc đ&atilde; qu&aacute; cũ hoặc bị hỏng th&igrave; n&ecirc;n thay bộ lọc gi&oacute; mới thay v&igrave; phải vệ sinh nh&eacute;!</p>\r\n\r\n<p><img alt=\"Vệ sinh bộ lọc gió (một số máy sử dụng mút lọc gió) \" src=\"https://cdn.tgdd.vn//News/1533306//Huong-dan-lam-sach-bo-loc-gio-may-phat-dien-dung-cach-10-730x515.jpg\" /></p>\r\n\r\n<p>Vệ sinh bộ lọc gi&oacute; (một số m&aacute;y sử dụng m&uacute;t lọc gi&oacute;)</p>\r\n\r\n<p>Tra dầu v&agrave;o hộp chứa bộ lọc</p>\r\n\r\n<p>Bạn c&oacute; thể b&ocirc;i một &iacute;t dầu động cơ đều khắp bề mặt b&ecirc;n trong của hộp chứa bộ lọc gi&oacute; m&aacute;y ph&aacute;t điện. Khi b&ocirc;i dầu, bạn chỉ n&ecirc;n d&ugrave;ng lượng nhỏ vừa đủ v&agrave; tuyệt đối kh&ocirc;ng để dầu chảy ra khỏi vỏ hộp.</p>\r\n\r\n<p><img alt=\"Có thể tra dầu vào hộp chứa bộ lọc gió máy phát điện\" src=\"https://cdn.tgdd.vn//News/1533306//Huong-dan-lam-sach-bo-loc-gio-may-phat-dien-dung-cach-11-730x459.jpg\" /></p>\r\n\r\n<p>C&oacute; thể tra dầu v&agrave;o hộp chứa bộ lọc gi&oacute; m&aacute;y ph&aacute;t điện</p>\r\n\r\n<p>Lắp bộ lọc đ&atilde; được vệ sinh trở lại m&aacute;y</p>\r\n\r\n<p>Sau khi bộ lọc gi&oacute; đ&atilde; kh&ocirc; r&aacute;o, bạn lắp n&oacute; v&agrave;o lại b&ecirc;n trong hộp chứa, rồi đậy nắp lại l&agrave; xong!</p>\r\n\r\n<p><img alt=\"Lắp lại các bộ phận lọc gió và kiểm tra máy vận hành\" src=\"https://cdn.tgdd.vn//News/1533306//Huong-dan-lam-sach-bo-loc-gio-may-phat-dien-dung-cach-12-730x509.jpg\" /></p>\r\n\r\n<p>Lắp lại c&aacute;c bộ phận lọc gi&oacute; v&agrave; kiểm tra m&aacute;y vận h&agrave;nh</p>','Bộ lọc gió máy phát điện có khả năng loại bỏ bụi bẩn và các chất cặn bẩn khác trong không khí trước khi đưa vào bộ phận buồng đốt, nhờ đó giúp cho động cơ máy hoạt động ổn định và bền bỉ hơn.',0,'1774026745581_bo-loc-gio-may-phat-dien.jpg','Kỹ thuật viên hệ thống','Lọc gió','published',4,'2026-03-21 00:12:26','2026-03-21 00:12:25','2026-03-21 12:42:58');
/*!40000 ALTER TABLE `news` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `operational_logs`
--

DROP TABLE IF EXISTS `operational_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `operational_logs` (
                                    `id` int NOT NULL AUTO_INCREMENT,
                                    `product_id` int NOT NULL,
                                    `operator_id` int DEFAULT NULL,
                                    `start_time` datetime NOT NULL,
                                    `end_time` datetime DEFAULT NULL,
                                    `duration_hours` decimal(5,2) DEFAULT NULL,
                                    `reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
                                    `fuel_consumed` decimal(10,2) DEFAULT NULL,
                                    `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
                                    `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                    PRIMARY KEY (`id`),
                                    KEY `product_id` (`product_id`),
                                    KEY `operator_id` (`operator_id`),
                                    CONSTRAINT `operational_logs_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
                                    CONSTRAINT `operational_logs_ibfk_2` FOREIGN KEY (`operator_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `operational_logs`
--

LOCK TABLES `operational_logs` WRITE;
/*!40000 ALTER TABLE `operational_logs` DISABLE KEYS */;
INSERT INTO `operational_logs` VALUES (1,3,12,'2026-02-01 08:00:00','2026-02-01 12:00:00',4.00,'Chạy thử tải',15.50,'Vận hành ổn định','2026-02-03 05:54:22'),(2,3,12,'2026-02-03 09:00:00',NULL,NULL,'Đang vận hành',NULL,'Chưa kết thúc ca','2026-02-03 05:54:22'),(3,1,12,'2026-01-20 08:00:00','2026-01-20 12:00:00',4.00,'Mất điện lưới diện rộng',12.50,'Máy hoạt động ổn định','2026-02-04 16:34:53'),(4,1,12,'2026-01-25 14:00:00','2026-01-25 16:30:00',2.50,'Chạy test định kỳ hàng tuần',8.00,'Nhiệt độ nước làm mát hơi cao','2026-02-04 16:34:53'),(5,2,25,'2026-02-01 09:00:00','2026-02-01 18:00:00',9.00,'Sự cố điện trạm biến áp',45.00,'Hết dầu lúc 17h, đã tiếp thêm','2026-02-04 16:34:53'),(6,3,25,'2026-02-02 10:00:00','2026-02-02 11:00:00',1.00,'Kiểm tra sau bảo trì',3.50,'Đã thay lọc gió','2026-02-04 16:34:53');
/*!40000 ALTER TABLE `operational_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_reset_tokens`
--

DROP TABLE IF EXISTS `password_reset_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_reset_tokens` (
                                         `id` int NOT NULL AUTO_INCREMENT,
                                         `user_id` int NOT NULL,
                                         `token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
                                         `expiry_date` datetime NOT NULL,
                                         `is_used` tinyint DEFAULT '0',
                                         PRIMARY KEY (`id`),
                                         KEY `user_id` (`user_id`),
                                         CONSTRAINT `password_reset_tokens_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_reset_tokens`
--

LOCK TABLES `password_reset_tokens` WRITE;
/*!40000 ALTER TABLE `password_reset_tokens` DISABLE KEYS */;
INSERT INTO `password_reset_tokens` VALUES (9,46,'acaee190-ea8e-42fd-b627-029df2fcb51c','2026-03-01 00:13:41',1);
/*!40000 ALTER TABLE `password_reset_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permissions`
--

DROP TABLE IF EXISTS `permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `permissions` (
                               `id` int NOT NULL AUTO_INCREMENT,
                               `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
                               `code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
                               `module` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
                               PRIMARY KEY (`id`),
                               UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permissions`
--

LOCK TABLES `permissions` WRITE;
/*!40000 ALTER TABLE `permissions` DISABLE KEYS */;
INSERT INTO `permissions` VALUES (1,'Xem danh sách User','USER_VIEW','SYSTEM'),(2,'Tạo/Sửa/Xóa User','USER_MANAGE','SYSTEM'),(3,'Phân quyền Role','ROLE_MANAGE','SYSTEM'),(4,'Xem danh sách Máy','ASSET_VIEW','ASSET'),(5,'Thêm/Sửa thông tin Máy','ASSET_MANAGE','ASSET'),(6,'Quản lý Kho vật tư','INVENTORY_MANAGE','INVENTORY'),(7,'Gửi yêu cầu Báo hỏng','INCIDENT_CREATE','OPERATION'),(8,'Xử lý/Sửa chữa Sự cố','INCIDENT_RESOLVE','MAINTENANCE'),(9,'Xem/Ghi Nhật ký chạy máy','LOG_MANAGE','OPERATION'),(10,'Xem Báo cáo/Dashboard','REPORT_VIEW','REPORT'),(11,'Xử lý Báo giá','QUOTE_MANAGE','BUSINESS');
/*!40000 ALTER TABLE `permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_images`
--

DROP TABLE IF EXISTS `product_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_images` (
                                  `id` int NOT NULL AUTO_INCREMENT,
                                  `model_id` int DEFAULT NULL,
                                  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
                                  PRIMARY KEY (`id`),
                                  KEY `product_id` (`model_id`),
                                  CONSTRAINT `fk_images_model` FOREIGN KEY (`model_id`) REFERENCES `product_models` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_images`
--

LOCK TABLES `product_images` WRITE;
/*!40000 ALTER TABLE `product_images` DISABLE KEYS */;
INSERT INTO `product_images` VALUES (1,6,'/uploads/models/honda_20_1.jpg'),(2,6,'/uploads/models/honda_20_2.jpg'),(3,7,'/uploads/models/honda_50_1.jpg'),(4,8,'/uploads/models/cummins_40_1.jpg'),(5,10,'/uploads/products/detail_1_honda-eu22i.jpg'),(6,11,'/uploads/products/detail_1_honda-eu30is.jpg'),(7,12,'/uploads/products/detail_1_hyundai-dhy6000se.jpg'),(8,13,'/uploads/products/detail_1_hyundai-dhy12500se-3.jpg'),(9,14,'/uploads/products/detail_1_cummins-c110d5.jpg'),(10,15,'/uploads/products/detail_1_cummins-c220d5.jpg'),(11,16,'/uploads/products/detail_1_mitsubishi-mgs0500b.jpg'),(12,17,'/uploads/products/detail_1_mitsubishi-mgs1200b.jpg'),(13,18,'/uploads/products/detail_1_doosan-dp158ld.jpg'),(14,19,'/uploads/products/detail_1_denyo-dca-25esk.jpg'),(20,10,'/uploads/products/detail_2_honda-eu22i.jpg'),(21,11,'/uploads/products/detail_2_honda-eu30is.jpg'),(22,12,'/uploads/products/detail_2_hyundai-dhy6000se.jpg'),(23,13,'/uploads/products/detail_2_hyundai-dhy12500se-3.jpg'),(24,14,'/uploads/products/detail_2_cummins-c110d5.jpg'),(25,15,'/uploads/products/detail_2_cummins-c220d5.jpg'),(26,16,'/uploads/products/detail_2_mitsubishi-mgs0500b.jpg'),(27,17,'/uploads/products/detail_2_mitsubishi-mgs1200b.jpg'),(28,18,'/uploads/products/detail_2_doosan-dp158ld.jpg'),(29,19,'/uploads/products/detail_2_denyo-dca-25esk.jpg'),(32,22,'uploads/product-models/cc07df77-b218-4424-a962-2c1ee7737bad.webp'),(33,22,'uploads/product-models/44a6caf8-4b35-4a23-96e5-f413610b7a36.jpg'),(34,22,'uploads/product-models/212fe400-4eec-4866-b879-71ca143ae447.png'),(35,22,'uploads/product-models/cf633549-4c27-4b90-a1a2-06455a305f85.jpg'),(36,22,'uploads/product-models/9417f767-5066-4f81-b6f9-1b88e794da8a.webp');
/*!40000 ALTER TABLE `product_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_models`
--

DROP TABLE IF EXISTS `product_models`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_models` (
                                  `id` int NOT NULL AUTO_INCREMENT,
                                  `name` varchar(255) NOT NULL,
                                  `slug` varchar(255) DEFAULT NULL,
                                  `brand_id` int DEFAULT NULL,
                                  `category_id` int DEFAULT NULL,
                                  `origin` varchar(100) DEFAULT NULL,
                                  `fuel_type` enum('DIESEL','GASOLINE','OTHER') DEFAULT NULL,
                                  `power` decimal(10,2) DEFAULT NULL COMMENT 'Công suất (kVA)',
                                  `description` text,
                                  `specifications` text,
                                  `manual_url` varchar(255) DEFAULT NULL,
                                  `image_url` varchar(255) DEFAULT NULL,
                                  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                  `status` enum('ACTIVE','INACTIVE','COMING_SOON') DEFAULT 'ACTIVE',
                                  PRIMARY KEY (`id`),
                                  UNIQUE KEY `slug` (`slug`),
                                  KEY `brand_id` (`brand_id`),
                                  KEY `category_id` (`category_id`),
                                  CONSTRAINT `product_models_ibfk_1` FOREIGN KEY (`brand_id`) REFERENCES `brands` (`id`),
                                  CONSTRAINT `product_models_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_models`
--

LOCK TABLES `product_models` WRITE;
/*!40000 ALTER TABLE `product_models` DISABLE KEYS */;
INSERT INTO `product_models` VALUES (1,'Honda 5kVA','may-phat-dien-honda-5kva',1,1,'Japan','GASOLINE',5.00,'Máy phát điện Honda công suất 5kVA','Công suất 5kVA, chạy xăng','/manuals/honda-5kva.pdf','/images/honda-5kva.jpg','2026-02-06 06:16:33','ACTIVE'),(2,'Honda 10kVA','may-phat-dien-honda-10kva',1,1,'Japan','GASOLINE',10.00,'Máy phát điện Honda công suất 10kVA','Công suất 10kVA, chạy xăng','/manuals/honda-10kva.pdf','/images/honda-10kva.jpg','2026-02-06 06:16:33','ACTIVE'),(3,'Honda 15kVA','may-phat-dien-honda-15kva',1,1,'Japan','GASOLINE',15.00,'Máy phát điện Honda công suất 15kVA','Công suất 15kVA, chạy xăng','/manuals/honda-15kva.pdf','/images/honda-15kva.jpg','2026-02-06 06:16:33','ACTIVE'),(4,'Máy phát điện Hyundai 20kVA','may-phat-dien-hyundai-20kva',2,1,'Korea','DIESEL',20.00,'Máy phát điện Hyundai công suất 20kVA','Công suất 20kVA, chạy dầu','/manuals/hyundai-20kva.pdf','/images/hyundai-20kva.jpg','2026-02-06 06:16:33','ACTIVE'),(5,'Máy phát điện Hyundai 30kVA','may-phat-dien-hyundai-30kva',2,1,'Korea','DIESEL',30.00,'Máy phát điện Hyundai công suất 30kVA','Công suất 30kVA, chạy dầu','/manuals/hyundai-30kva.pdf','/images/hyundai-30kva.jpg','2026-02-06 06:16:33','ACTIVE'),(6,'Honda Power 20kVA','honda-power-20kva',1,1,'Japan','GASOLINE',20.00,'Máy phát điện Honda 20kVA dùng cho công trình nhỏ','20kVA; 220/380V; 50Hz; 72dB','https://docs.honda.com/20kva.pdf','https://img.honda.com/20kva.jpg','2026-02-03 05:54:22','ACTIVE'),(7,'Honda Power 50kVA','honda-power-50kva',1,1,'Japan','DIESEL',50.00,'Máy phát điện Honda diesel 50kVA cho nhà xưởng','50kVA; 380V; 50Hz; 75dB','https://docs.honda.com/50kva.pdf','https://img.honda.com/50kva.jpg','2026-02-03 05:54:22','ACTIVE'),(8,'Cummins C40D5','cummins-c40d5',2,1,'USA','DIESEL',40.00,'Máy phát điện Cummins 40kVA bền bỉ','40kVA; 380V; 50Hz; Turbo','https://cummins.com/c40d5.pdf','https://cummins.com/c40.jpg','2026-02-03 05:54:22','ACTIVE'),(9,'Cummins C90D5 (Coming Soon)','cummins-c90d5-coming-soon',2,1,'USA','DIESEL',90.00,'Model dự kiến mở bán, dùng cho tải lớn','90kVA; 380V; 50Hz; 82dB','https://cummins.com/c90d5.pdf','https://cummins.com/c90.jpg','2026-02-03 05:54:22','COMING_SOON'),(10,'Honda EU22i Inverter','honda-eu22i',1,2,'Thailand','GASOLINE',2.20,'Máy phát điện xách tay siêu êm, công nghệ Inverter tiết kiệm nhiên liệu.','2.2kVA; 220V; Siêu cách âm','https://honda.com/manual/eu22i.pdf','/uploads/models/honda_eu22i.jpg','2026-02-04 16:37:44','ACTIVE'),(11,'Honda EU30is','honda-eu30is',1,2,'Japan','GASOLINE',3.00,'Dòng máy gia đình cao cấp, đề nổ, bánh xe di chuyển tiện lợi.','3.0kVA; Chạy được điều hòa 9000BTU','https://honda.com/manual/eu30is.pdf','/uploads/models/honda_eu30is.jpg','2026-02-04 16:37:44','ACTIVE'),(12,'Hyundai DHY6000SE','hyundai-dhy6000se',3,2,'Korea','DIESEL',5.50,'Máy chạy dầu vỏ cách âm, phù hợp hộ gia đình kinh doanh.','5.5kVA; 1 Pha; Thùng cách âm','https://hyundai.com/manual/dhy6000.pdf','/uploads/models/hyundai_dhy6000.jpg','2026-02-04 16:37:44','ACTIVE'),(13,'Hyundai DHY12500SE-3','hyundai-dhy12500se-3',3,1,'Korea','DIESEL',11.00,'Máy 3 pha chạy dầu, phù hợp nhà xưởng nhỏ, thang máy.','11kVA; 3 Pha; Tự động ATS','https://hyundai.com/manual/dhy12500.pdf','/uploads/models/hyundai_dhy12500.jpg','2026-02-04 16:37:44','ACTIVE'),(14,'Cummins C110D5','cummins-c110d5',2,1,'India','DIESEL',110.00,'Dòng máy công suất lớn cho tòa nhà văn phòng, khách sạn.','100kVA Prime / 110kVA Standby','https://cummins.com/manual/c110d5.pdf','/uploads/models/cummins_c110.jpg','2026-02-04 16:37:44','ACTIVE'),(15,'Cummins C220D5','cummins-c220d5',2,1,'UK','DIESEL',220.00,'Máy phát điện dự phòng cho nhà máy sản xuất quy mô vừa.','200kVA Prime / 220kVA Standby','https://cummins.com/manual/c220d5.pdf','/uploads/models/cummins_c220.jpg','2026-02-04 16:37:44','ACTIVE'),(16,'Mitsubishi MGS0500B','mitsubishi-mgs0500b',4,1,'Singapore','DIESEL',500.00,'Tổ máy Mitsubishi chính hãng, độ bền cực cao cho KCN.','500kVA; Động cơ S6R-PTA','https://mitsubishi.com/manual/mgs0500.pdf','/uploads/models/mitsubishi_500.jpg','2026-02-04 16:37:44','COMING_SOON'),(17,'Mitsubishi MGS1200B','mitsubishi-mgs1200b',4,1,'Vietnam','DIESEL',1250.00,'Trạm điện dự phòng công suất lớn.','1250kVA; Động cơ S12H-PTA','https://mitsubishi.com/manual/mgs1200.pdf','/uploads/models/mitsubishi_1200.jpg','2026-02-04 16:37:44','ACTIVE'),(18,'Doosan DP158LD','doosan-dp158ld',5,1,'Korea','DIESEL',600.00,'Động cơ Doosan mạnh mẽ, chi phí vận hành thấp.','600kVA; Turbo tăng áp','https://doosan.com/manual/dp158.pdf','/uploads/models/doosan_600.jpg','2026-02-04 16:37:44','ACTIVE'),(19,'Denyo DCA-25ESK','denyo-dca-25esk',6,1,'Japan','DIESEL',25.00,'Máy phát điện siêu chống ồn, chuyên dùng cho sự kiện, quay phim.','25kVA; Độ ồn < 60dB','https://denyo.com/manual/dca25.pdf','/uploads/models/denyo_25.jpg','2026-02-04 16:37:44','ACTIVE'),(22,'Mô tơ hahasadas','mo-to-hahasadas',8,1,'tung cua','DIESEL',456.00,'ádasdhkjsgkj','ÁHJGZJKC',NULL,'uploads/product-models/cc07df77-b218-4424-a962-2c1ee7737bad.webp','2026-03-10 09:16:35','ACTIVE');
/*!40000 ALTER TABLE `product_models` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
                            `id` int NOT NULL AUTO_INCREMENT,
                            `serial_number` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
                            `manufacture_year` int DEFAULT NULL,
                            `current_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
                            `status` enum('RUNNING','MAINTENANCE','BROKEN','RECEIVED_QUOTE','READY','REPAIRING') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
                            `total_running_hours` decimal(10,1) DEFAULT '0.0',
                            `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                            `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                            `customer_id` int DEFAULT NULL,
                            `purchase_date` date DEFAULT NULL COMMENT 'Ngày khách mua thực tế',
                            `model_id` int DEFAULT NULL,
                            `contract_id` int NOT NULL,
                            PRIMARY KEY (`id`),
                            UNIQUE KEY `serial_number` (`serial_number`),
                            KEY `fk_product_customer` (`customer_id`),
                            KEY `fk_product_model` (`model_id`),
                            KEY `fk_product_contract` (`contract_id`),
                            CONSTRAINT `fk_product_contract` FOREIGN KEY (`contract_id`) REFERENCES `contracts` (`id`),
                            CONSTRAINT `fk_product_customer` FOREIGN KEY (`customer_id`) REFERENCES `users` (`id`),
                            CONSTRAINT `fk_product_model` FOREIGN KEY (`model_id`) REFERENCES `product_models` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,'SN-2026-8888',2004,'Kho nhà khách hàng - Hà Nội','MAINTENANCE',0.0,'2026-02-01 13:12:16','2026-03-16 13:33:58',25,NULL,1,5),(2,'SN-2026-0001',2025,'Kho Hà Nội','MAINTENANCE',120.5,'2026-02-03 05:54:22','2026-03-06 06:58:04',25,'2025-11-12',6,1),(3,'SN-2026-0002',2024,'Nhà máy Bắc Ninh','MAINTENANCE',560.0,'2026-02-03 05:54:22','2026-03-06 06:50:44',25,'2024-06-20',7,7),(4,'SN-2026-0003',2023,'KCN VSIP','RUNNING',820.3,'2026-02-03 05:54:22','2026-02-27 06:05:17',12,'2023-03-15',8,2),(5,'SN-2026-7777',NULL,'Khách hàng mới','RUNNING',0.0,'2026-02-03 15:10:25','2026-02-06 18:01:20',29,'2026-02-03',9,4),(13,'SN-2026-5555',2006,'Nguyễn Quang Huy','MAINTENANCE',12.0,'2026-02-04 17:52:54','2026-03-10 08:45:49',39,'2026-12-07',19,13),(15,'SN-2026-123421',2003,'Nguyễn Quang Huy','MAINTENANCE',29.0,'2026-02-05 11:22:52','2026-03-02 16:15:23',25,'2026-02-05',17,15),(16,'SN-2026-086085',2007,'Kho Fpt','READY',0.0,'2026-02-07 12:52:17','2026-02-07 12:52:17',39,'2026-02-07',1,16),(17,'SN-2026-99991',2002,'Kho Fpt','READY',67.0,'2026-02-07 12:53:19','2026-02-07 12:54:03',39,'2026-02-07',8,16),(18,'SN-2026-99991212',2002,'FPT UNIVER','READY',0.0,'2026-03-05 09:35:59','2026-03-05 09:35:59',25,'2026-03-05',13,18),(19,'SN-2026-13421',2005,'Kho Fpt123','MAINTENANCE',0.0,'2026-03-05 10:08:28','2026-03-06 06:24:11',25,'2026-03-05',12,5),(20,'SN-2026-11112',2002,'FPT UNIVER','MAINTENANCE',0.0,'2026-03-05 10:46:53','2026-03-06 06:16:05',25,'2026-03-05',10,5),(21,'SN-2026-12342',2002,'FPT Hòa Lạc','READY',0.0,'2026-03-10 09:29:04','2026-03-10 09:29:04',25,'2026-03-10',6,21),(22,'SN-2026-9997',2001,'FPT Hòa Lạc','READY',0.0,'2026-03-10 09:30:13','2026-03-10 09:30:13',25,'2026-03-10',5,21),(25,'SN-2026-50',2002,'FPT hòa lạc','READY',122.0,'2026-03-15 15:32:57','2026-03-17 09:28:54',25,NULL,5,40),(26,'SN-2026-999',2002,'FPT Hòa Lạc','READY',0.0,'2026-03-17 09:40:21','2026-03-17 09:40:21',25,'2026-03-03',2,41),(27,'SN-2026-666',2002,'FPT Hòa Lạc','READY',0.0,'2026-03-17 09:40:21','2026-03-17 09:40:21',25,'2026-03-03',8,41),(28,'SN-2026-51',2002,'FPT Hòa Lạc','READY',0.0,'2026-03-17 10:01:18','2026-03-17 10:01:18',25,'2026-03-03',4,41),(29,'SN-2026-555',2002,'FPT Hòa Lạc','READY',0.0,'2026-03-17 10:01:27','2026-03-17 10:01:27',25,'2026-03-03',4,41),(30,'SN-2026-998',2002,'FPT Hòa Lạc','READY',0.0,'2026-03-17 10:01:27','2026-03-17 10:01:27',25,'2026-03-03',2,41),(31,'SN-2026-76757',2002,'FPT Hòa Lạc','READY',0.0,'2026-03-17 10:01:38','2026-03-17 10:01:38',25,'2026-03-03',4,41),(32,'SN-2026-501212',2002,'FPT','READY',0.0,'2026-03-17 15:44:14','2026-03-17 15:44:14',25,'2026-03-17',11,41),(33,'SN-2026-69',2002,'FPT Hòa Lạc','READY',0.0,'2026-03-20 17:47:51','2026-03-20 17:47:51',25,'2026-03-03',4,42),(34,'SN-2026-229',2002,'FPT Hòa Lạc','READY',0.0,'2026-03-20 17:47:51','2026-03-20 17:47:51',25,'2026-03-03',2,42),(35,'SN-2026-266',2002,'FPT Hòa Lạc','READY',0.0,'2026-03-20 17:47:51','2026-03-20 17:47:51',25,'2026-03-03',8,42);
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quote_details`
--

DROP TABLE IF EXISTS `quote_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quote_details` (
                                 `id` int NOT NULL AUTO_INCREMENT,
                                 `quote_id` int NOT NULL,
                                 `description` varchar(255) DEFAULT NULL,
                                 `quantity` int DEFAULT '1',
                                 `unit_price` decimal(15,2) DEFAULT NULL,
                                 `total_price` decimal(15,2) DEFAULT NULL,
                                 PRIMARY KEY (`id`),
                                 KEY `quote_id` (`quote_id`),
                                 CONSTRAINT `quote_details_ibfk_1` FOREIGN KEY (`quote_id`) REFERENCES `quotes` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quote_details`
--

LOCK TABLES `quote_details` WRITE;
/*!40000 ALTER TABLE `quote_details` DISABLE KEYS */;
INSERT INTO `quote_details` VALUES (5,3,'Lọc dầu (SP-001)',10,1500000.00,15000000.00),(6,3,'Bugi (SP-002)',5,400000.00,2000000.00),(7,4,'Lọc dầu (SP-001)',10,1500000.00,15000000.00),(8,4,'Bugi (SP-002)',5,400000.00,2000000.00),(9,5,'Bugi (SP-002)',2,160000.00,320000.00),(10,6,'Lọc dầu (SP-001)',3,150000.00,450000.00);
/*!40000 ALTER TABLE `quote_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quotes`
--

DROP TABLE IF EXISTS `quotes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quotes` (
                          `id` int NOT NULL AUTO_INCREMENT,
                          `customer_id` int NOT NULL,
                          `created_by` int NOT NULL,
                          `total_amount` decimal(15,2) DEFAULT NULL,
                          `status` enum('DRAFT','PENDING','APPROVED','REJECTED','SENT') DEFAULT 'DRAFT',
                          `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                          `approved_at` timestamp NULL DEFAULT NULL,
                          `maintenance_id` int DEFAULT NULL,
                          PRIMARY KEY (`id`),
                          KEY `customer_id` (`customer_id`),
                          CONSTRAINT `quotes_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quotes`
--

LOCK TABLES `quotes` WRITE;
/*!40000 ALTER TABLE `quotes` DISABLE KEYS */;
INSERT INTO `quotes` VALUES (2,25,4,12.00,'APPROVED','2026-03-02 14:43:51','2026-03-02 14:43:51',16),(3,25,25,1900000.00,'APPROVED','2026-03-02 14:47:57','2026-03-02 14:47:57',16),(4,25,25,1900000.00,'APPROVED','2026-03-02 15:12:12','2026-03-02 15:12:12',16),(5,25,11,160000.00,'APPROVED','2026-03-06 06:58:04','2026-03-06 06:58:04',23),(6,25,11,450000.00,'APPROVED','2026-03-10 09:12:34','2026-03-10 09:12:34',24);
/*!40000 ALTER TABLE `quotes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role_permissions`
--

DROP TABLE IF EXISTS `role_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role_permissions` (
                                    `role_id` int NOT NULL,
                                    `permission_id` int NOT NULL,
                                    PRIMARY KEY (`role_id`,`permission_id`),
                                    KEY `permission_id` (`permission_id`),
                                    CONSTRAINT `role_permissions_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
                                    CONSTRAINT `role_permissions_ibfk_2` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role_permissions`
--

LOCK TABLES `role_permissions` WRITE;
/*!40000 ALTER TABLE `role_permissions` DISABLE KEYS */;
INSERT INTO `role_permissions` VALUES (1,1),(1,2),(1,3),(2,3),(1,4),(2,4),(3,4),(4,4),(5,4),(2,5),(2,6),(4,6),(5,7),(4,8),(2,9),(4,9),(1,10),(2,10),(2,11),(3,11);
/*!40000 ALTER TABLE `role_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
                         `id` int NOT NULL AUTO_INCREMENT,
                         `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
                         `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
                         `status` tinyint DEFAULT '1',
                         `redirect_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
                         PRIMARY KEY (`id`),
                         UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'Admin','Quản trị hệ thống - Cấu hình, Phân quyền, User',1,'/admin/user/user-list'),(2,'Manager','Quản lý vận hành - Xem báo cáo, Duyệt kho, Quản lý máy',1,'/manager'),(3,'Staff','Nhân viên kinh doanh - Xử lý báo giá, CSKH',1,'/staff'),(4,'Technical','Kỹ thuật viên - Bảo trì, Sửa chữa, Kiểm kê kho',1,'/technical/my-tasks'),(5,'User','Khách hàng/Vận hành - Xem máy, Báo hỏng update',1,'/home'),(6,'IT','Quản trị Nội dung & Giao diện',1,'/it');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `spare_parts`
--

DROP TABLE IF EXISTS `spare_parts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `spare_parts` (
                               `id` int NOT NULL AUTO_INCREMENT,
                               `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
                               `part_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
                               `unit` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
                               `quantity_in_stock` int DEFAULT '0',
                               `min_stock_alert` int DEFAULT '5',
                               `price` decimal(15,2) DEFAULT NULL,
                               `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
                               PRIMARY KEY (`id`),
                               UNIQUE KEY `part_code` (`part_code`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `spare_parts`
--

LOCK TABLES `spare_parts` WRITE;
/*!40000 ALTER TABLE `spare_parts` DISABLE KEYS */;
INSERT INTO `spare_parts` VALUES (1,'Lọc dầu','SP-001','Cái',9,5,150000.00,'Lọc dầu định kỳ'),(2,'Bugi','SP-002','Cái',22,10,80000.00,'Bugi cho máy xăng'),(3,'Bugi','SP-003','Cái',0,3,1200000.00,NULL),(12,'Lọc gió','SP-201','Cái',50,10,120000.00,'Lọc gió động cơ'),(13,'Dây curoa','SP-202','Cái',40,5,200000.00,'Dây truyền động'),(14,'Ắc quy','SP-203','Cái',20,5,1500000.00,'Ắc quy máy'),(15,'Van xăng','SP-204','Cái',30,5,250000.00,'Van cấp nhiên liệu'),(16,'Bơm dầu','SP-205','Cái',10,2,800000.00,'Bơm dầu động cơ'),(17,'Van xăng1','SP-206','Cái',30,5,250000.00,'Van cấp nhiên liệu'),(18,'Bơm dầu1','SP-207','Cái',10,2,800000.00,'Bơm dầu động cơ');
/*!40000 ALTER TABLE `spare_parts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `system_requests`
--

DROP TABLE IF EXISTS `system_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `system_requests` (
                                   `id` bigint NOT NULL AUTO_INCREMENT,
                                   `sender_id` int NOT NULL,
                                   `receiver_role` varchar(50) NOT NULL,
                                   `request_type` varchar(50) NOT NULL,
                                   `request_data` text,
                                   `status` varchar(20) DEFAULT 'PENDING',
                                   `response_message` text,
                                   `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                   `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                   PRIMARY KEY (`id`),
                                   KEY `sender_id` (`sender_id`),
                                   CONSTRAINT `system_requests_ibfk_1` FOREIGN KEY (`sender_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `system_requests`
--

LOCK TABLES `system_requests` WRITE;
/*!40000 ALTER TABLE `system_requests` DISABLE KEYS */;
INSERT INTO `system_requests` VALUES (16,45,'MANAGER','INCIDENT_REPORT','{\"issueType\":\"MAINTENANCE\",\"reporterPhone\":\"0966808596\",\"productId\":\"15\",\"description\":\"fdsa\",\"preferredDate\":\"2026-02-27\",\"title\":\"fdsa\",\"reporterName\":\"Nguyễn Quang Huy\",\"reporterEmail\":\"huyasus2852@gmail.com\",\"technicianId\":\"11\",\"priority\":\"MEDIUM\",\"maintenanceType\":\"REPAIR\",\"staffNote\":\"fdsa\"}','TASK_CREATED','Đã duyệt','2026-02-26 15:36:11','2026-02-26 17:51:15'),(17,45,'MANAGER','INCIDENT_REPORT','{\"issueType\":\"MAINTENANCE\",\"reporterPhone\":\"0987654321\",\"productId\":\"4\",\"description\":\"cmm\",\"preferredDate\":\"2026-02-28\",\"title\":\"gửi staff\",\"reporterName\":\"Phạm Khách Hàng\",\"reporterEmail\":\"user@cms.com\",\"technicianId\":\"11\",\"priority\":\"MEDIUM\",\"maintenanceType\":\"REPAIR\",\"staffNote\":\"gửi manager\"}','TASK_CREATED','Đã duyệt','2026-02-26 17:53:12','2026-02-26 17:54:06'),(18,45,'MANAGER','INCIDENT_REPORT','{\"issueType\":\"PERIODIC\",\"reporterPhone\":\"0966808596\",\"productId\":\"3\",\"description\":\"fdsa\",\"preferredDate\":\"2026-02-28\",\"title\":\"fdsa\",\"reporterName\":\"Nguyễn Quang Huy\",\"reporterEmail\":\"huyasus2852@gmail.com\",\"technicianId\":\"11\",\"priority\":\"MEDIUM\",\"maintenanceType\":\"REPAIR\",\"staffNote\":\"fdsa\"}','TASK_CREATED','Đã duyệt','2026-02-26 18:01:34','2026-02-26 18:02:13'),(19,45,'MANAGER','INCIDENT_REPORT','{\"issueType\":\"PERIODIC\",\"reporterPhone\":\"0966808596\",\"productId\":\"2\",\"description\":\"fdsa\",\"preferredDate\":\"2026-02-28\",\"title\":\"fdsa\",\"reporterName\":\"Nguyễn Quang Huy\",\"reporterEmail\":\"huyasus2852@gmail.com\",\"technicianId\":\"11\",\"priority\":\"MEDIUM\",\"maintenanceType\":\"REPAIR\",\"staffNote\":\"fdsa\"}','TASK_CREATED','Đã duyệt','2026-02-26 18:07:20','2026-02-26 18:07:59'),(20,45,'MANAGER','INCIDENT_REPORT','{\"issueType\":\"PERIODIC\",\"reporterPhone\":\"0966808596\",\"productId\":\"1\",\"description\":\"fdsa\",\"preferredDate\":\"2026-02-28\",\"title\":\"fds\",\"reporterName\":\"Nguyễn Quang Huy\",\"reporterEmail\":\"huyasus2852@gmail.com\",\"technicianId\":\"11\",\"priority\":\"MEDIUM\",\"maintenanceType\":\"REPAIR\",\"staffNote\":\"fdsa\"}','TASK_CREATED','Đã duyệt','2026-02-26 18:20:58','2026-02-26 18:21:30'),(21,45,'MANAGER','INCIDENT_REPORT','{\"issueType\":\"REPAIR\",\"reporterPhone\":\"0966808596\",\"productId\":\"15\",\"description\":\"fdsa\",\"preferredDate\":\"2026-02-28\",\"title\":\"fdas\",\"reporterName\":\"Nguyễn Quang Huy\",\"reporterEmail\":\"huyasus2852@gmail.com\",\"technicianId\":\"11\",\"priority\":\"MEDIUM\",\"maintenanceType\":\"REPAIR\",\"staffNote\":\"\"}','TASK_CREATED','Đã duyệt','2026-02-27 06:05:40','2026-02-27 06:06:30'),(22,10,'MANAGER','REPAIR_QUOTE','{\"maintenanceId\":8,\"technicianId\":11,\"laborCost\":0,\"partsTotal\":6800000,\"grandTotal\":6800000,\"materials\":[{\"sparePartId\":2,\"partName\":\"Bugi (SP-002)\",\"quantityUsed\":10,\"costAtTime\":800000},{\"sparePartId\":3,\"partName\":\"Ắc quy (SP-003)\",\"quantityUsed\":5,\"costAtTime\":6000000}]}','APPROVED','Đã duyệt','2026-02-27 06:07:15','2026-02-28 08:26:56'),(23,45,'MANAGER','INCIDENT_REPORT','{\"issueType\":\"REPAIR\",\"reporterPhone\":\"0966808596\",\"productId\":\"3\",\"description\":\"fdsa\",\"preferredDate\":\"2026-03-01\",\"title\":\"fdsa\",\"reporterName\":\"Nguyễn Quang Huy\",\"reporterEmail\":\"huyasus2852@gmail.com\",\"technicianId\":\"11\",\"priority\":\"MEDIUM\",\"maintenanceType\":\"REPAIR\",\"staffNote\":\"fdsa\"}','TASK_CREATED','Đã duyệt','2026-02-28 16:08:53','2026-02-28 16:09:30'),(24,10,'MANAGER','REPAIR_QUOTE','{\"maintenanceId\":9,\"technicianId\":11,\"laborCost\":0,\"partsTotal\":12800000,\"grandTotal\":12800000,\"materials\":[{\"sparePartId\":2,\"partName\":\"Bugi (SP-002)\",\"quantityUsed\":10,\"costAtTime\":800000},{\"sparePartId\":3,\"partName\":\"Ắc quy (SP-003)\",\"quantityUsed\":10,\"costAtTime\":12000000}]}','APPROVED','Đã duyệt','2026-02-28 16:10:01','2026-02-28 16:15:27'),(25,9,'Staff','INCIDENT_REPORT','{\"issueType\":\"PERIODIC\",\"reporterPhone\":\"0966808596\",\"productId\":\"2\",\"description\":\"fdsa\",\"preferredDate\":\"2026-03-01\",\"title\":\"fdsa\",\"reporterName\":\"Nguyễn Quang Huy\",\"reporterEmail\":\"huyasus2852@gmail.com\",\"technicianId\":\"11\",\"priority\":\"MEDIUM\",\"maintenanceType\":\"REPAIR\",\"staffNote\":\"fdsa\"}','APPROVED','Đã duyệt','2026-02-28 16:51:08','2026-02-28 16:51:50'),(26,9,'Staff','INCIDENT_REPORT','{\"issueType\":\"REPAIR\",\"reporterPhone\":\"0966808596\",\"productId\":\"1\",\"description\":\"fdsa\",\"preferredDate\":\"2026-03-03\",\"title\":\"fdsa\",\"reporterName\":\"Nguyễn Quang Huy\",\"reporterEmail\":\"huyasus2852@gmail.com\",\"technicianId\":\"11\",\"priority\":\"MEDIUM\",\"maintenanceType\":\"REPAIR\",\"staffNote\":\"fdsa\"}','TASK_CREATED','Đã duyệt','2026-03-01 14:18:36','2026-03-01 14:19:41'),(27,10,'USER','REPAIR_QUOTE','{\"maintenanceId\":10,\"technicianId\":11,\"laborCost\":0,\"partsTotal\":6000000,\"grandTotal\":6000000,\"materials\":[{\"sparePartId\":3,\"partName\":\"Ắc quy (SP-003)\",\"quantityUsed\":5,\"costAtTime\":6000000}]}','WAITING_CUSTOMER','Đã duyệt','2026-03-01 14:19:55','2026-03-02 07:14:59'),(28,9,'STAFF','INCIDENT_REPORT','{\"issueType\":\"REPAIR\",\"reporterPhone\":\"0966808596\",\"productId\":\"15\",\"description\":\"fdsa\",\"preferredDate\":\"2026-03-03\",\"title\":\"fdsa\",\"reporterName\":\"Nguyễn Quang Huy\",\"reporterEmail\":\"huyasus2852@gmail.com\",\"technicianId\":\"11\",\"priority\":\"MEDIUM\",\"maintenanceType\":\"REPAIR\",\"staffNote\":\"fdsa\"}','TASK_CREATED','Đã duyệt','2026-03-02 06:22:11','2026-03-02 07:16:16'),(29,25,'STAFF','REPAIR_QUOTE','{\"maintenanceId\":11,\"technicianId\":11,\"laborCost\":0,\"partsTotal\":80000,\"grandTotal\":80000,\"materials\":[{\"sparePartId\":2,\"partName\":\"Bugi (SP-002)\",\"quantityUsed\":1,\"costAtTime\":80000}]}','APPROVED_BY_CUSTOMER','Khách hàng đã ĐỒNG Ý chi phí. Vui lòng tiến hành sửa chữa.','2026-03-02 07:16:36','2026-03-02 07:50:44'),(30,25,'TECH','REPAIR_QUOTE','{\"maintenanceId\":11,\"technicianId\":11,\"laborCost\":0,\"partsTotal\":80000,\"grandTotal\":80000,\"materials\":[{\"sparePartId\":2,\"partName\":\"Bugi (SP-002)\",\"quantityUsed\":1,\"costAtTime\":80000}]}','APPROVED_BY_CUSTOMER','Khách hàng đã ĐỒNG Ý chi phí. Vui lòng tiến hành sửa chữa.','2026-03-02 07:37:29','2026-03-02 10:02:24'),(31,10,'USER','REPAIR_QUOTE','{\"maintenanceId\":11,\"technicianId\":11,\"laborCost\":0,\"partsTotal\":80000,\"grandTotal\":80000,\"materials\":[{\"sparePartId\":2,\"partName\":\"Bugi (SP-002)\",\"quantityUsed\":1,\"costAtTime\":80000}]}','WAITING_CUSTOMER','Đã duyệt','2026-03-02 07:47:14','2026-03-02 07:47:52'),(32,10,'USER','REPAIR_QUOTE','{\"maintenanceId\":11,\"technicianId\":11,\"laborCost\":0,\"partsTotal\":1580000,\"grandTotal\":1580000,\"materials\":[{\"sparePartId\":1,\"partName\":\"Lọc dầu (SP-001)\",\"quantityUsed\":10,\"costAtTime\":1500000},{\"sparePartId\":2,\"partName\":\"Bugi (SP-002)\",\"quantityUsed\":1,\"costAtTime\":80000}]}','WAITING_CUSTOMER','Đã duyệt','2026-03-02 09:59:31','2026-03-02 10:01:55'),(33,9,'STAFF','INCIDENT_REPORT','{\"issueType\":\"REPAIR\",\"reporterPhone\":\"0966808596\",\"productId\":\"2\",\"description\":\"fda\",\"preferredDate\":\"2026-03-04\",\"title\":\"fdsa\",\"reporterName\":\"Nguyễn Quang Huy\",\"reporterEmail\":\"huyasus2852@gmail.com\",\"technicianId\":\"11\",\"priority\":\"MEDIUM\",\"maintenanceType\":\"REPAIR\",\"staffNote\":\"fdsa\"}','TASK_CREATED','Đã duyệt','2026-03-02 10:03:28','2026-03-02 10:04:00'),(34,25,'TECH','REPAIR_QUOTE','{\"maintenanceId\":12,\"technicianId\":11,\"laborCost\":0,\"partsTotal\":2300000,\"grandTotal\":2300000,\"materials\":[{\"sparePartId\":1,\"partName\":\"Lọc dầu (SP-001)\",\"quantityUsed\":10,\"costAtTime\":1500000},{\"sparePartId\":2,\"partName\":\"Bugi (SP-002)\",\"quantityUsed\":10,\"costAtTime\":800000}]}','APPROVED_BY_CUSTOMER','Khách hàng đã ĐỒNG Ý chi phí. Vui lòng tiến hành sửa chữa.','2026-03-02 10:07:02','2026-03-02 10:07:54'),(35,9,'STAFF','INCIDENT_REPORT','{\"issueType\":\"PERIODIC\",\"reporterPhone\":\"0966808596\",\"productId\":\"3\",\"description\":\"nj\",\"preferredDate\":\"2026-03-11\",\"title\":\"nj\",\"reporterName\":\"Nguyễn Quang Huy\",\"reporterEmail\":\"huyasus2852@gmail.com\",\"technicianId\":\"11\",\"priority\":\"MEDIUM\",\"maintenanceType\":\"REPAIR\",\"staffNote\":\"\"}','TASK_CREATED','Đã duyệt','2026-03-02 10:17:49','2026-03-02 10:18:21'),(36,9,'STAFF','INCIDENT_REPORT','{\"issueType\":\"REPAIR\",\"reporterPhone\":\"0966808596\",\"productId\":\"1\",\"description\":\"\",\"preferredDate\":\"2026-03-04\",\"title\":\"fdsa\",\"reporterName\":\"Nguyễn Quang Huy\",\"reporterEmail\":\"huyasus2852@gmail.com\",\"technicianId\":\"11\",\"priority\":\"MEDIUM\",\"maintenanceType\":\"REPAIR\",\"staffNote\":\"\"}','TASK_CREATED','Đã duyệt','2026-03-02 10:21:15','2026-03-02 10:21:46'),(37,25,'TECH','REPAIR_QUOTE','{\"maintenanceId\":14,\"technicianId\":11,\"laborCost\":0,\"partsTotal\":1150000,\"grandTotal\":1150000,\"materials\":[{\"sparePartId\":1,\"partName\":\"Lọc dầu (SP-001)\",\"quantityUsed\":5,\"costAtTime\":750000},{\"sparePartId\":2,\"partName\":\"Bugi (SP-002)\",\"quantityUsed\":5,\"costAtTime\":400000}]}','APPROVED_BY_CUSTOMER','Khách hàng đã ĐỒNG Ý chi phí. Vui lòng tiến hành sửa chữa.','2026-03-02 10:22:11','2026-03-02 10:23:27'),(38,9,'STAFF','INCIDENT_REPORT','{\"issueType\":\"REPAIR\",\"reporterPhone\":\"0966808596\",\"productId\":\"15\",\"description\":\"\",\"preferredDate\":\"2026-03-04\",\"title\":\"fds\",\"reporterName\":\"Nguyễn Quang Huy\",\"reporterEmail\":\"huyasus2852@gmail.com\",\"technicianId\":\"11\",\"priority\":\"MEDIUM\",\"maintenanceType\":\"REPAIR\",\"staffNote\":\"fds\"}','TASK_CREATED','Đã duyệt','2026-03-02 14:15:15','2026-03-02 14:16:46'),(39,25,'TECH','REPAIR_QUOTE','{\"maintenanceId\":15,\"technicianId\":11,\"laborCost\":0,\"partsTotal\":640000,\"grandTotal\":640000,\"materials\":[{\"sparePartId\":2,\"partName\":\"Bugi (SP-002)\",\"quantityUsed\":8,\"costAtTime\":640000}]}','APPROVED_BY_CUSTOMER','Khách hàng đã ĐỒNG Ý chi phí. Vui lòng tiến hành sửa chữa.','2026-03-02 14:17:10','2026-03-02 14:18:04'),(40,9,'STAFF','INCIDENT_REPORT','{\"issueType\":\"REPAIR\",\"reporterPhone\":\"0966808596\",\"productId\":\"2\",\"description\":\"\",\"preferredDate\":\"2026-03-03\",\"title\":\"fd\",\"reporterName\":\"Nguyễn Quang Huy\",\"reporterEmail\":\"huyasus2852@gmail.com\",\"technicianId\":\"11\",\"priority\":\"MEDIUM\",\"maintenanceType\":\"REPAIR\",\"staffNote\":\"\"}','TASK_CREATED','Đã duyệt','2026-03-02 14:32:59','2026-03-02 14:33:32'),(41,25,'TECH','REPAIR_QUOTE','{\"maintenanceId\":16,\"technicianId\":11,\"laborCost\":0,\"partsTotal\":400000,\"grandTotal\":400000,\"materials\":[{\"sparePartId\":2,\"partName\":\"Bugi (SP-002)\",\"quantityUsed\":5,\"costAtTime\":400000}]}','APPROVED_BY_CUSTOMER','Khách hàng đã ĐỒNG Ý chi phí. Vui lòng tiến hành sửa chữa.','2026-03-02 14:33:46','2026-03-02 14:34:28'),(42,9,'STAFF','INCIDENT_REPORT','{\"issueType\":\"REPAIR\",\"reporterPhone\":\"0966808596\",\"productId\":\"2\",\"description\":\"\",\"preferredDate\":\"2026-03-04\",\"title\":\"fds\",\"reporterName\":\"Nguyễn Quang Huy\",\"reporterEmail\":\"huyasus2852@gmail.com\",\"technicianId\":\"11\",\"priority\":\"MEDIUM\",\"maintenanceType\":\"REPAIR\",\"staffNote\":\"fd\"}','TASK_CREATED','Đã duyệt','2026-03-02 14:46:08','2026-03-02 14:46:47'),(43,25,'TECH','REPAIR_QUOTE','{\"maintenanceId\":16,\"technicianId\":11,\"laborCost\":0,\"partsTotal\":1900000,\"grandTotal\":1900000,\"materials\":[{\"sparePartId\":1,\"partName\":\"Lọc dầu (SP-001)\",\"quantityUsed\":10,\"costAtTime\":1500000},{\"sparePartId\":2,\"partName\":\"Bugi (SP-002)\",\"quantityUsed\":5,\"costAtTime\":400000}]}','APPROVED_BY_CUSTOMER','Khách hàng đã ĐỒNG Ý chi phí. Vui lòng tiến hành sửa chữa.','2026-03-02 14:47:09','2026-03-02 14:47:57'),(44,9,'STAFF','INCIDENT_REPORT','{\"issueType\":\"REPAIR\",\"reporterPhone\":\"0966808596\",\"productId\":\"1\",\"description\":\"\",\"preferredDate\":\"2026-03-07\",\"title\":\"gửi lên staff\",\"reporterName\":\"Nguyễn Quang Huy\",\"reporterEmail\":\"huyasus2852@gmail.com\",\"technicianId\":\"11\",\"priority\":\"MEDIUM\",\"maintenanceType\":\"REPAIR\",\"staffNote\":\"gửi lên manager\\r\\n\"}','TASK_CREATED','Đã duyệt','2026-03-02 15:09:30','2026-03-02 15:10:08'),(45,25,'TECH','REPAIR_QUOTE','{\"maintenanceId\":16,\"technicianId\":11,\"laborCost\":0,\"partsTotal\":1900000,\"grandTotal\":1900000,\"materials\":[{\"sparePartId\":1,\"partName\":\"Lọc dầu (SP-001)\",\"quantityUsed\":10,\"costAtTime\":1500000},{\"sparePartId\":2,\"partName\":\"Bugi (SP-002)\",\"quantityUsed\":5,\"costAtTime\":400000}]}','APPROVED_BY_CUSTOMER','Khách hàng đã ĐỒNG Ý chi phí. Vui lòng tiến hành sửa chữa.','2026-03-02 15:10:43','2026-03-02 15:12:12'),(46,9,'STAFF','INCIDENT_REPORT','{\"issueType\":\"REPAIR\",\"reporterPhone\":\"0966808596\",\"productId\":\"15\",\"description\":\"\",\"preferredDate\":\"2026-03-05\",\"title\":\"fd\",\"reporterName\":\"Nguyễn Quang Huy\",\"reporterEmail\":\"huyasus2852@gmail.com\",\"technicianId\":\"11\",\"priority\":\"MEDIUM\",\"maintenanceType\":\"REPAIR\",\"staffNote\":\"\"}','TASK_CREATED','Đã duyệt','2026-03-02 16:15:23','2026-03-02 16:15:58'),(47,11,'STAFF','REPAIR_QUOTE','{\"maintenanceId\":12,\"technicianId\":11,\"actualDescription\":null,\"laborCost\":0.0,\"partsTotal\":2300000.0,\"grandTotal\":2300000.0,\"materials\":[{\"sparePartId\":1,\"quantityUsed\":10,\"costAtTime\":1500000.0},{\"sparePartId\":2,\"quantityUsed\":10,\"costAtTime\":800000.0}]}','WAITING_STAFF',NULL,'2026-03-02 16:16:42','2026-03-02 16:16:42'),(48,41,'USER','CUSTOMER_SUPPORT','{\"customerPhone\":\"0966808596\",\"subject\":\"giải thích lí do hủy hợp đồng\",\"customerEmail\":\"huyasus2852@gmail.com\",\"requestKind\":\"CONTRACT_RELATED_REQUEST\",\"message\":\"123\",\"customerName\":\"Nguyễn Quang Huy\"}','RESPONDED','do vấn đề về pháp lý ạ','2026-03-05 17:05:17','2026-03-05 17:28:16'),(49,41,'USER','CUSTOMER_SUPPORT','{\"customerPhone\":\"0966808596\",\"subject\":\"24234\",\"customerEmail\":\"huyasus2852@gmail.com\",\"requestKind\":\"CONTRACT_RELATED_REQUEST\",\"message\":\"1234134\",\"customerName\":\"Nguyễn Quang Huy\"}','RESPONDED','dạ','2026-03-05 17:43:03','2026-03-05 17:43:16'),(50,9,'STAFF','INCIDENT_REPORT','{\"issueType\":\"REPAIR\",\"reporterPhone\":\"0966808596\",\"productId\":\"20\",\"description\":\"\",\"preferredDate\":\"2026-03-09\",\"title\":\"5\",\"reporterName\":\"Nguyễn Quang Huy\",\"reporterEmail\":\"huyasus2852@gmail.com\",\"technicianId\":\"11\",\"priority\":\"MEDIUM\",\"maintenanceType\":\"REPAIR\",\"staffNote\":\"\"}','TASK_CREATED','Đã duyệt','2026-03-06 06:16:05','2026-03-06 06:20:57'),(51,9,'STAFF','INCIDENT_REPORT','{\"issueType\":\"REPAIR\",\"reporterPhone\":\"0966808596\",\"productId\":\"19\",\"description\":\"\",\"preferredDate\":\"2026-03-08\",\"title\":\"l\",\"reporterName\":\"Nguyễn Quang Huy\",\"reporterEmail\":\"huyasus2852@gmail.com\",\"technicianId\":\"11\",\"priority\":\"MEDIUM\",\"maintenanceType\":\"REPAIR\",\"staffNote\":\"\"}','TASK_CREATED','Đã duyệt','2026-03-06 06:22:05','2026-03-06 06:22:40'),(52,25,'TECH','REPAIR_QUOTE','{\"maintenanceId\":21,\"technicianId\":11,\"actualDescription\":\"l\",\"partsTotal\":400000,\"materials\":[{\"sparePartId\":2,\"partName\":\"Bugi (SP-002)\",\"quantityUsed\":5,\"costAtTime\":400000}]}','APPROVED_BY_CUSTOMER','Khách hàng đã ĐỒNG Ý chi phí. Vui lòng tiến hành sửa chữa.','2026-03-06 06:23:04','2026-03-06 06:24:15'),(53,9,'STAFF','INCIDENT_REPORT','{\"issueType\":\"REPAIR\",\"reporterPhone\":\"0966808596\",\"productId\":\"3\",\"description\":\"\",\"preferredDate\":\"2026-03-08\",\"title\":\"l\",\"reporterName\":\"Nguyễn Quang Huy\",\"reporterEmail\":\"huyasus2852@gmail.com\",\"technicianId\":\"11\",\"priority\":\"MEDIUM\",\"maintenanceType\":\"REPAIR\",\"staffNote\":\"123\"}','TASK_CREATED','Đã duyệt','2026-03-06 06:42:01','2026-03-06 06:48:55'),(54,25,'TECH','REPAIR_QUOTE','{\"maintenanceId\":22,\"technicianId\":11,\"actualDescription\":\"1212\",\"partsTotal\":1680000,\"materials\":[{\"sparePartId\":2,\"partName\":\"Bugi (SP-002)\",\"quantityUsed\":21,\"costAtTime\":1680000}]}','APPROVED_BY_CUSTOMER','Khách hàng đã ĐỒNG Ý chi phí. Vui lòng tiến hành sửa chữa.','2026-03-06 06:49:45','2026-03-06 06:50:44'),(55,9,'STAFF','INCIDENT_REPORT','{\"issueType\":\"REPAIR\",\"reporterPhone\":\"0966808596\",\"productId\":\"2\",\"description\":\"\",\"preferredDate\":\"2026-03-08\",\"title\":\"l\",\"reporterName\":\"Nguyễn Quang Huy\",\"reporterEmail\":\"huyasus2852@gmail.com\",\"technicianId\":\"11\",\"priority\":\"MEDIUM\",\"maintenanceType\":\"REPAIR\",\"staffNote\":\"\"}','TASK_CREATED','Đã duyệt','2026-03-06 06:55:06','2026-03-06 06:56:57'),(56,25,'TECH','REPAIR_QUOTE','{\"maintenanceId\":23,\"technicianId\":11,\"actualDescription\":\"f\",\"partsTotal\":160000,\"materials\":[{\"sparePartId\":2,\"partName\":\"Bugi (SP-002)\",\"quantityUsed\":2,\"costAtTime\":160000}]}','COMPLETED','Khách hàng đã ĐỒNG Ý chi phí. Vui lòng tiến hành sửa chữa.','2026-03-06 06:57:23','2026-03-10 08:35:09'),(57,9,'STAFF','INCIDENT_REPORT','{\"issueType\":\"INSPECTION\\u0027\",\"reporterPhone\":\"0948374757\",\"productId\":\"13\",\"description\":\"\",\"preferredDate\":\"2026-03-08\",\"title\":\"máy không nổ\",\"reporterName\":\"Nguyễn Quang Huy\",\"reporterEmail\":\"tuequang2852@gmail.com\",\"technicianId\":\"11\",\"priority\":\"MEDIUM\",\"maintenanceType\":\"REPAIR\",\"staffNote\":\"gửi lên manager\"}','APPROVED','Đã duyệt','2026-03-10 08:45:49','2026-03-10 08:56:03'),(58,9,'STAFF','INCIDENT_REPORT','{\"issueType\":\"REPAIR\",\"reporterPhone\":\"0966808596\",\"productId\":\"1\",\"description\":\"abc\",\"preferredDate\":\"2026-03-10\",\"title\":\"abc\",\"reporterName\":\"Nguyễn Quang Huy\",\"reporterEmail\":\"huyasus2852@gmail.com\",\"technicianId\":\"11\",\"priority\":\"MEDIUM\",\"maintenanceType\":\"REPAIR\",\"staffNote\":\"aaa\"}','TASK_CREATED','Đã duyệt','2026-03-10 09:07:52','2026-03-10 09:08:25'),(59,25,'CUSTOMER','REPAIR_QUOTE','{\"maintenanceId\":24,\"technicianId\":11,\"actualDescription\":\"abc\",\"partsTotal\":450000,\"materials\":[{\"sparePartId\":1,\"partName\":\"Lọc dầu (SP-001)\",\"quantityUsed\":3,\"unitPrice\":150000,\"costAtTime\":450000}]}','COMPLETED','Khách hàng đã ĐỒNG Ý chi phí. Vui lòng tiến hành sửa chữa.','2026-03-10 09:10:03','2026-03-10 09:13:55'),(60,9,'STAFF','INCIDENT_REPORT','{\"issueType\":\"PERIODIC\",\"reporterPhone\":\"0966808596\",\"productId\":\"1\",\"description\":\"đytyt\",\"preferredDate\":\"2026-03-16\",\"title\":\"hhb\",\"reporterName\":\"Nguyễn Quang Huy\",\"reporterEmail\":\"huyasus2852@gmail.com\",\"technicianId\":\"11\",\"priority\":\"MEDIUM\",\"maintenanceType\":\"REPAIR\",\"staffNote\":\"buii\",\"startTime\":\"08:35\",\"endTime\":\"10:35\"}','APPROVED','Đã duyệt','2026-03-16 13:33:58','2026-03-16 13:36:46');
/*!40000 ALTER TABLE `system_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
                         `id` int NOT NULL AUTO_INCREMENT,
                         `role_id` int DEFAULT NULL,
                         `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
                         `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
                         `full_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
                         `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
                         `avatar_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
                         `status` tinyint DEFAULT '1',
                         `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                         PRIMARY KEY (`id`),
                         UNIQUE KEY `email` (`email`),
                         UNIQUE KEY `unique_phone` (`phone`),
                         KEY `role_id` (`role_id`),
                         CONSTRAINT `users_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (9,2,'manager@cms.com','$2a$10$QnXcb/EBe/JFLEoMVApeWu4Si6hvtZAXuXUpaX/TG86Drj80tfOvy','Nguyễn Quản Lý',NULL,NULL,1,'2026-01-12 22:03:09'),(10,3,'staff@cms.com','$2a$10$eAccYoNOHEqXve8aIWT8Nu3ueN6NB9ITsUgpyFkatbw77oFb2q9Dq','Trần Sale',NULL,NULL,1,'2026-01-12 22:03:09'),(11,4,'tech@cms.com','$2a$10$jJlMmJeiia14iXBiwlVBMuYM.cWqX2QqP7EJ8yuEPHEHHnpoRvWOa','Lê Kỹ Thuật',NULL,NULL,1,'2026-01-12 22:03:09'),(12,5,'user@cms.com','$2a$10$qVSK05xFTUc8ys4JeaUAbOvexzpGrLGVIyU14EEcYvdss.SWe6YNG','Phạm Khách Hàng','0987654321','uploads/usser-account-260nw-669118549.webp',0,'2026-01-12 22:03:09'),(25,5,'huyasus2852@gmail.com','$2a$10$7XS/APbmFsEhF4Vt/YmmSuDyCxkG7qMamp9Pi181/SwKaAtfTwW.e','Nguyễn Quang Huy','0966808596','uploads/settopreviewit2gahemaquai2-156-6257-6202-1567778967.webp',1,'2026-01-23 04:16:55'),(27,1,'admin@cms.com','$2a$10$tIODelqK3BH4FMiQ4pgm3OgF95FwAQC6FI3EinB/VqWEaDuaJ085S','Admin','0966808591','uploads/settopreviewit2gahemaquai2-156-6257-6202-1567778967.webp',1,'2026-01-24 13:23:54'),(29,5,'vutrang121206@gmail.com','$2a$12$5qNOvTp68IgZ.SeUv34KR.jdkbOLuLQFEUndxTJDIlNnvlvM6eCcG','Vũ Ngọc Trang','0934521223','uploads/anh-dep-83.jpg',1,'2026-02-03 15:06:21'),(39,5,'tuequang2852@gmail.com','$2a$10$GyCUleMMzg7r5iidYvLUZOcdbmFsfkhae95WDV1V07nHAL7Oaz486','Nguyễn Quang Huy','0948374757','uploads/download.jpg',1,'2026-02-04 13:35:44'),(40,6,'it@cms.com','$2a$10$3ME/XvMeC7QDXkz16d0zMus2uNfww1UhWElvOd6bRho4GkvE3nM7e','Nguyễn Văn IT','0965478124','uploads/download.jpg',1,'2026-02-06 07:03:35'),(41,3,'staffcms@cms.com','$2a$10$cFDSppUOD3pxlrpmrqax4.m556OO/ZsrPdaxHAF8zTwRBiBz0wse6','Nguyễn Văn Staff','0964578123','uploads/usser-account-260nw-669118549.webp',1,'2026-02-06 07:58:50'),(44,5,'huynqhe186195@fpt.edu.vn','$2a$12$I6hnNMcGqcaA.8csjOoJ8Or5r3vV3bEzR05yZooYvujHRsPO1iYdi','Nguyễn Quang Huy','0976546321',NULL,0,'2026-02-07 19:58:33'),(45,3,'staff123@gmail.com','$2a$10$1I62WTp8tYzMRZ9FWghJyuw95MKvysmceC8u3VDHPemanlHIpR/QO','staff123','0932131231','https://ui-avatars.com/api/?name=staff123',1,'2026-02-24 05:07:47'),(46,1,'Lamdfgf123@gmail.com','$2a$12$/ab7eo5nKKuvQGVaEEt1L.PU7n5AgSd9UOLCsrfsurV8LgL/drWe6','dungdzpro','0912721535','https://ui-avatars.com/api/?name=dungdzpro',1,'2026-02-28 17:03:25');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-03-21 12:51:47
