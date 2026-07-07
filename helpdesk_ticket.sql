-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: helpdesk_ticket
-- ------------------------------------------------------
-- Server version	8.0.30

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
-- Table structure for table `cache`
--

DROP TABLE IF EXISTS `cache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cache` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL,
  PRIMARY KEY (`key`),
  KEY `cache_expiration_index` (`expiration`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache`
--

LOCK TABLES `cache` WRITE;
/*!40000 ALTER TABLE `cache` DISABLE KEYS */;
/*!40000 ALTER TABLE `cache` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cache_locks`
--

DROP TABLE IF EXISTS `cache_locks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cache_locks` (
  `key` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL,
  PRIMARY KEY (`key`),
  KEY `cache_locks_expiration_index` (`expiration`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cache_locks`
--

LOCK TABLES `cache_locks` WRITE;
/*!40000 ALTER TABLE `cache_locks` DISABLE KEYS */;
/*!40000 ALTER TABLE `cache_locks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comments`
--

DROP TABLE IF EXISTS `comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comments` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `ticket_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `comment` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `comments_ticket_id_foreign` (`ticket_id`),
  KEY `comments_user_id_foreign` (`user_id`),
  CONSTRAINT `comments_ticket_id_foreign` FOREIGN KEY (`ticket_id`) REFERENCES `tickets` (`id`) ON DELETE CASCADE,
  CONSTRAINT `comments_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comments`
--

LOCK TABLES `comments` WRITE;
/*!40000 ALTER TABLE `comments` DISABLE KEYS */;
INSERT INTO `comments` VALUES (1,2,3,'hallo boleh dijelaskan kendalanya bagaimana ya','2026-07-06 06:25:31','2026-07-06 06:25:31'),(2,2,5,'pas saya cek website langsung muncul error 404 kak','2026-07-06 06:39:04','2026-07-06 06:39:04'),(4,9,1,'ditunggu sebentar ya','2026-07-06 11:57:37','2026-07-06 11:57:37'),(5,10,1,'mohon ditunggu','2026-07-06 12:15:20','2026-07-06 12:15:20'),(6,10,4,'waitt','2026-07-06 12:16:56','2026-07-06 12:16:56');
/*!40000 ALTER TABLE `comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `failed_jobs`
--

DROP TABLE IF EXISTS `failed_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `failed_jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `failed_jobs`
--

LOCK TABLES `failed_jobs` WRITE;
/*!40000 ALTER TABLE `failed_jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `failed_jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `job_batches`
--

DROP TABLE IF EXISTS `job_batches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `job_batches` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_jobs` int NOT NULL,
  `pending_jobs` int NOT NULL,
  `failed_jobs` int NOT NULL,
  `failed_job_ids` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `options` mediumtext COLLATE utf8mb4_unicode_ci,
  `cancelled_at` int DEFAULT NULL,
  `created_at` int NOT NULL,
  `finished_at` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job_batches`
--

LOCK TABLES `job_batches` WRITE;
/*!40000 ALTER TABLE `job_batches` DISABLE KEYS */;
/*!40000 ALTER TABLE `job_batches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jobs`
--

DROP TABLE IF EXISTS `jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `jobs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `queue` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` tinyint unsigned NOT NULL,
  `reserved_at` int unsigned DEFAULT NULL,
  `available_at` int unsigned NOT NULL,
  `created_at` int unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobs_queue_index` (`queue`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jobs`
--

LOCK TABLES `jobs` WRITE;
/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `migrations` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` VALUES (1,'0001_01_01_000000_create_users_table',1),(2,'0001_01_01_000001_create_cache_table',1),(3,'0001_01_01_000002_create_jobs_table',1),(4,'2026_06_04_122622_create_tickets_table',1),(5,'2026_06_04_122740_create_comments_table',1),(6,'2026_06_04_122756_create_ticket_histories_table',1);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifications` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `sender_id` bigint unsigned NOT NULL,
  `user_id` bigint unsigned NOT NULL,
  `ticket_id` bigint unsigned NOT NULL,
  `title` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `is_read` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_notifications_user` (`user_id`),
  KEY `fk_notifications_ticket` (`ticket_id`),
  KEY `fk_notification_sender` (`sender_id`),
  CONSTRAINT `fk_notification_sender` FOREIGN KEY (`sender_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_notifications_ticket` FOREIGN KEY (`ticket_id`) REFERENCES `tickets` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_notifications_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
INSERT INTO `notifications` VALUES (7,3,5,2,'Balasan Ticket','Ada balasan pada ticket : Website Toko Error',0,'2026-07-06 06:25:31','2026-07-06 06:25:31'),(8,5,3,2,'Balasan Ticket','User membalas ticket : Website Toko Error',0,'2026-07-06 06:39:04','2026-07-06 06:39:04'),(10,1,2,6,'Ticket Baru','Anda mendapat ticket baru: cek error',0,'2026-07-06 10:53:44','2026-07-06 10:53:44'),(11,5,1,7,'Ticket Baru','Ticket baru dibuat: cek error 2',0,'2026-07-06 11:02:05','2026-07-06 11:02:05'),(12,5,1,8,'Ticket Baru','Ticket baru dibuat: cek error 3',0,'2026-07-06 11:02:19','2026-07-06 11:02:19'),(13,1,2,7,'Ticket Baru','Anda mendapat ticket baru: cek error 2',0,'2026-07-06 11:02:46','2026-07-06 11:02:46'),(14,2,5,7,'Status Ticket','Status ticket berubah menjadi Close',0,'2026-07-06 11:03:35','2026-07-06 11:03:35'),(15,5,1,9,'Ticket Baru','Ticket baru dibuat: website error',0,'2026-07-06 11:55:51','2026-07-06 11:55:51'),(16,1,3,9,'Ticket Baru','Anda mendapat ticket baru: website error',0,'2026-07-06 11:57:04','2026-07-06 11:57:04'),(17,1,5,9,'Balasan Ticket','Ada balasan pada ticket : website error',0,'2026-07-06 11:57:37','2026-07-06 11:57:37'),(18,3,5,9,'Status Ticket','Status ticket berubah menjadi Close',0,'2026-07-06 12:02:18','2026-07-06 12:02:18'),(19,5,1,10,'Ticket Baru','Ticket baru dibuat: Webiste error',0,'2026-07-06 12:11:35','2026-07-06 12:11:35'),(20,1,4,10,'Ticket Baru','Anda mendapat ticket baru: Webiste error',0,'2026-07-06 12:14:32','2026-07-06 12:14:32'),(21,1,5,10,'Balasan Ticket','Ada balasan pada ticket : Webiste error',0,'2026-07-06 12:15:20','2026-07-06 12:15:20'),(22,4,5,10,'Balasan Ticket','Ada balasan pada ticket : Webiste error',0,'2026-07-06 12:16:56','2026-07-06 12:16:56'),(23,4,5,10,'Status Ticket','Status ticket berubah menjadi Close',0,'2026-07-06 12:17:11','2026-07-06 12:17:11');
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_reset_tokens`
--

DROP TABLE IF EXISTS `password_reset_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_reset_tokens`
--

LOCK TABLES `password_reset_tokens` WRITE;
/*!40000 ALTER TABLE `password_reset_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_reset_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sessions` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint unsigned DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sessions_user_id_index` (`user_id`),
  KEY `sessions_last_activity_index` (`last_activity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticket_histories`
--

DROP TABLE IF EXISTS `ticket_histories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ticket_histories` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `ticket_id` bigint unsigned NOT NULL,
  `activity` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ticket_histories_ticket_id_foreign` (`ticket_id`),
  CONSTRAINT `ticket_histories_ticket_id_foreign` FOREIGN KEY (`ticket_id`) REFERENCES `tickets` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticket_histories`
--

LOCK TABLES `ticket_histories` WRITE;
/*!40000 ALTER TABLE `ticket_histories` DISABLE KEYS */;
INSERT INTO `ticket_histories` VALUES (1,1,'Ticket dibuat oleh user','2026-07-05 00:46:35','2026-07-05 00:46:35'),(2,2,'Ticket dibuat oleh user','2026-07-05 01:06:10','2026-07-05 01:06:10'),(3,3,'Ticket dibuat oleh user','2026-07-05 01:08:44','2026-07-05 01:08:44'),(4,1,'Ticket diassign ke Budi (IT Support)','2026-07-05 01:37:43','2026-07-05 01:37:43'),(5,2,'Ticket diassign ke Santi (Network Tech)','2026-07-05 01:38:39','2026-07-05 01:38:39'),(6,3,'Ticket diassign ke Santi (Network Tech)','2026-07-05 01:49:27','2026-07-05 01:49:27'),(7,4,'Ticket dibuat oleh user','2026-07-06 03:47:01','2026-07-06 03:47:01'),(8,5,'Ticket dibuat oleh user','2026-07-06 03:48:38','2026-07-06 03:48:38'),(9,5,'Ticket diassign ke Santi (Network Tech)','2026-07-06 03:50:30','2026-07-06 03:50:30'),(10,4,'Ticket diassign ke Budi (IT Support)','2026-07-06 04:38:12','2026-07-06 04:38:12'),(11,3,'Status berubah menjadi Close','2026-07-06 06:26:15','2026-07-06 06:26:15'),(12,1,'Status berubah menjadi In Progress','2026-07-06 08:04:51','2026-07-06 08:04:51'),(13,6,'Ticket dibuat oleh user','2026-07-06 10:36:45','2026-07-06 10:36:45'),(14,6,'Ticket diassign ke Budi (IT Support)','2026-07-06 10:53:44','2026-07-06 10:53:44'),(15,7,'Ticket dibuat oleh user','2026-07-06 11:02:05','2026-07-06 11:02:05'),(16,8,'Ticket dibuat oleh user','2026-07-06 11:02:19','2026-07-06 11:02:19'),(17,7,'Ticket diassign ke Budi (IT Support)','2026-07-06 11:02:46','2026-07-06 11:02:46'),(18,7,'Status berubah menjadi Close','2026-07-06 11:03:35','2026-07-06 11:03:35'),(19,9,'Ticket dibuat oleh user','2026-07-06 11:55:51','2026-07-06 11:55:51'),(20,9,'Ticket diassign ke Santi (Network Tech)','2026-07-06 11:57:04','2026-07-06 11:57:04'),(21,9,'Status berubah menjadi Close','2026-07-06 12:02:18','2026-07-06 12:02:18'),(22,10,'Ticket dibuat oleh user','2026-07-06 12:11:35','2026-07-06 12:11:35'),(23,10,'Ticket diassign ke Rian (Hardware)','2026-07-06 12:14:31','2026-07-06 12:14:31'),(24,10,'Status berubah menjadi Close','2026-07-06 12:17:11','2026-07-06 12:17:11');
/*!40000 ALTER TABLE `ticket_histories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tickets`
--

DROP TABLE IF EXISTS `tickets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tickets` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Open',
  `user_id` bigint unsigned NOT NULL,
  `assigned_to` bigint unsigned DEFAULT NULL,
  `image` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tickets_user_id_foreign` (`user_id`),
  KEY `fk_ticket_assigned` (`assigned_to`),
  CONSTRAINT `fk_ticket_assigned` FOREIGN KEY (`assigned_to`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tickets_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tickets`
--

LOCK TABLES `tickets` WRITE;
/*!40000 ALTER TABLE `tickets` DISABLE KEYS */;
INSERT INTO `tickets` VALUES (1,'Layar Bluescreen','Layar full biru dan ada perintah refresh','In Progress',5,2,'1783237594_1000000033.png','2026-07-05 00:46:35','2026-07-05 01:37:43'),(2,'Website Toko Error','Muncul 404','In Progress',5,3,'1783238770_Cuplikan layar 2026-06-07 140525.png','2026-07-05 01:06:10','2026-07-05 01:38:39'),(3,'Koneksi Wifi tidak dapat tersambung','Koneksi Trouble dan error dari 5 hari yang lalu','Close',6,3,'1783238924_Cuplikan layar 2026-06-03 125634.png','2026-07-05 01:08:44','2026-07-06 06:26:15'),(4,'Error Network','Jaringan tiba tiba mati','In Progress',5,2,'1783334821_1000000034.png','2026-07-06 03:47:01','2026-07-06 04:38:12'),(5,'Website loading lama','loading lama terhitung sejak 2 hari yang lalu','In Progress',5,3,'1783334918_1000000035.png','2026-07-06 03:48:38','2026-07-06 03:50:30'),(6,'cek error','error','In Progress',5,2,NULL,'2026-07-06 10:36:45','2026-07-06 10:53:44'),(7,'cek error 2','cek erorr','Close',5,2,NULL,'2026-07-06 11:02:05','2026-07-06 11:03:35'),(8,'cek error 3','cekk','Open',5,NULL,NULL,'2026-07-06 11:02:18','2026-07-06 11:02:18'),(9,'website error','error not found','Close',5,3,'1783364151_Cuplikan layar 2026-07-06 220142.png','2026-07-06 11:55:51','2026-07-06 12:02:18'),(10,'Webiste error','webiste muncul 404 not found','Close',5,4,'1783365095_1000000034.png','2026-07-06 12:11:35','2026-07-06 12:17:11');
/*!40000 ALTER TABLE `tickets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `role` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'user',
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Admin','admin@mail.com',NULL,'$2y$12$RYzj/yOrOHVhxs/f83DF.eRsz5hAdniWB7DNELL4Z5teJJ9rboej2',NULL,'2026-07-06 17:52:50','2026-07-06 17:52:50','admin'),(2,'Budi (IT Support)','budihelp@mail.com',NULL,'$2y$12$xC/IN3f5JLIiZSnjnacIPu5zWz7CWsuMiYxt5QHCL9nfVb14g/YVy',NULL,'2026-06-27 04:05:49','2026-06-27 04:05:49','helpdesk'),(3,'Santi (Network Tech)','santihelp@mail.com',NULL,'$2y$12$A8s21KCZK4OcWmA8Ta9P2ep9FV3DvjJroVCxY9k.zjmAvv9MMZCZK',NULL,'2026-06-27 04:05:49','2026-06-27 04:05:49','helpdesk'),(4,'Rian (Hardware)','rianhelp@mail.com',NULL,'$2y$12$oMBoxtfA9efG/hZOWSc3WOPsKko/mhKkIcW85ieejF7qy5gz6R/mS',NULL,'2026-06-27 04:05:49','2026-06-27 04:05:49','helpdesk'),(5,'User','user@mail.com',NULL,'$2y$12$Cy2g92/bZWU2yASej.v1bu2WO1LU9rZgtAD/8UlWC8sUXUfLt2Ypm',NULL,'2026-06-27 04:05:50','2026-06-27 04:05:50','user'),(6,'sania','sania@mail.com',NULL,'$2y$12$tqu9Pm2FjHSpEFI4kygfwuxowgMnFJ5rqujxIdNau44mi7KUTiIfC',NULL,'2026-07-04 23:09:34','2026-07-04 23:09:34','user'),(7,'sania warda','warda@mail.com',NULL,'$2y$12$O3FFql/DBprnW3KZgY229eN2HMjubn3mAW8Ncis3tIqB1ZgVdBXOe',NULL,'2026-07-06 08:11:51','2026-07-06 08:11:51','user');
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

-- Dump completed on 2026-07-07 13:27:04
