-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 13, 2026 at 07:50 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `logistics_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `audit_logs`
--

CREATE TABLE `audit_logs` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `action` varchar(255) NOT NULL,
  `details` text DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `audit_logs`
--

INSERT INTO `audit_logs` (`id`, `user_id`, `action`, `details`, `timestamp`) VALUES
(1, 1, 'USER_LOGIN', 'Admin user logged in', '2026-01-22 03:52:26'),
(2, 2, 'OPTIMIZATION_RUN', 'Executed optimization scenario #1', '2026-01-22 03:52:26'),
(3, 3, 'PLAN_APPROVED', 'Approved optimization plan #1', '2026-01-22 03:52:26'),
(4, 2, 'DATA_UPLOAD', 'Uploaded vessel data via Excel', '2026-01-22 03:52:26'),
(5, 1, 'USER_CREATED', 'Created new logistics planner account', '2026-01-22 03:52:26');

-- --------------------------------------------------------

--
-- Table structure for table `plans`
--

CREATE TABLE `plans` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `schedule_json` text DEFAULT NULL,
  `total_cost` decimal(15,2) NOT NULL,
  `status` enum('pending','approved','rejected') DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `plans`
--

INSERT INTO `plans` (`id`, `user_id`, `schedule_json`, `total_cost`, `status`, `created_at`) VALUES
(1, 2, '{\"vessel_1\": {\"port\": \"Paradip\", \"plant\": \"Plant A\"}, \"vessel_2\": {\"port\": \"Haldia\", \"plant\": \"Plant B\"}}', 150000.00, 'approved', '2026-01-22 03:52:26'),
(2, 2, '{\"vessel_3\": {\"port\": \"Visakhapatnam\", \"plant\": \"Plant C\"}, \"vessel_4\": {\"port\": \"Chennai\", \"plant\": \"Plant D\"}}', 165000.00, 'approved', '2026-01-22 03:52:26'),
(3, 2, '{\"vessel_5\": {\"port\": \"Paradip\", \"plant\": \"Plant E\"}}', 95000.00, 'approved', '2026-01-22 03:52:26'),
(4, 2, '[{\"vessel_id\":1,\"vessel_name\":\"MV Ocean Pride\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000},{\"vessel_id\":2,\"vessel_name\":\"MV Sea Master\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000},{\"vessel_id\":3,\"vessel_name\":\"MV Cargo King\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000},{\"vessel_id\":4,\"vessel_name\":\"MV Bulk Carrier\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000},{\"vessel_id\":5,\"vessel_name\":\"MV Steel Hauler\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000}]', 325000.00, 'approved', '2026-01-22 08:50:55'),
(5, 2, '[{\"vessel_id\":1,\"vessel_name\":\"MV Ocean Pride\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000},{\"vessel_id\":2,\"vessel_name\":\"MV Sea Master\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000},{\"vessel_id\":3,\"vessel_name\":\"MV Cargo King\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000},{\"vessel_id\":4,\"vessel_name\":\"MV Bulk Carrier\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000},{\"vessel_id\":5,\"vessel_name\":\"MV Steel Hauler\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000}]', 325000.00, 'approved', '2026-01-22 08:51:03'),
(6, 2, '[{\"vessel_id\":1,\"vessel_name\":\"MV Ocean Pride\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000},{\"vessel_id\":2,\"vessel_name\":\"MV Sea Master\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000},{\"vessel_id\":3,\"vessel_name\":\"MV Cargo King\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000},{\"vessel_id\":4,\"vessel_name\":\"MV Bulk Carrier\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000},{\"vessel_id\":5,\"vessel_name\":\"MV Steel Hauler\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000}]', 325000.00, 'approved', '2026-01-22 08:55:50'),
(7, 2, '[{\"vessel_id\":1,\"vessel_name\":\"MV Ocean Pride\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000},{\"vessel_id\":2,\"vessel_name\":\"MV Sea Master\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000},{\"vessel_id\":3,\"vessel_name\":\"MV Cargo King\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000},{\"vessel_id\":4,\"vessel_name\":\"MV Bulk Carrier\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000},{\"vessel_id\":5,\"vessel_name\":\"MV Steel Hauler\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000}]', 325000.00, 'approved', '2026-01-22 08:55:52'),
(8, 2, '[{\"vessel_id\":1,\"vessel_name\":\"MV Ocean Pride\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000},{\"vessel_id\":2,\"vessel_name\":\"MV Sea Master\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000},{\"vessel_id\":3,\"vessel_name\":\"MV Cargo King\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000},{\"vessel_id\":4,\"vessel_name\":\"MV Bulk Carrier\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000},{\"vessel_id\":5,\"vessel_name\":\"MV Steel Hauler\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000}]', 325000.00, 'approved', '2026-01-22 08:56:01'),
(9, 2, '[{\"vessel_id\":1,\"vessel_name\":\"MV Ocean Pride\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000},{\"vessel_id\":2,\"vessel_name\":\"MV Sea Master\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000},{\"vessel_id\":3,\"vessel_name\":\"MV Cargo King\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000},{\"vessel_id\":4,\"vessel_name\":\"MV Bulk Carrier\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000},{\"vessel_id\":5,\"vessel_name\":\"MV Steel Hauler\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000}]', 325000.00, 'approved', '2026-01-22 08:56:06'),
(10, 2, '[{\"vessel_id\":1,\"vessel_name\":\"MV Ocean Pride\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000},{\"vessel_id\":2,\"vessel_name\":\"MV Sea Master\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000},{\"vessel_id\":3,\"vessel_name\":\"MV Cargo King\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000},{\"vessel_id\":4,\"vessel_name\":\"MV Bulk Carrier\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000},{\"vessel_id\":5,\"vessel_name\":\"MV Steel Hauler\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000}]', 325000.00, 'approved', '2026-01-22 09:08:12'),
(11, 2, '[{\"vessel_id\":2,\"vessel_name\":\"MV Sea Master\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000},{\"vessel_id\":3,\"vessel_name\":\"MV Cargo King\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000},{\"vessel_id\":4,\"vessel_name\":\"MV Bulk Carrier\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000},{\"vessel_id\":5,\"vessel_name\":\"MV Steel Hauler\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000}]', 260000.00, 'approved', '2026-01-22 15:35:57'),
(12, 2, '[{\"vessel_id\":2,\"vessel_name\":\"MV Sea Master\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000},{\"vessel_id\":3,\"vessel_name\":\"MV Cargo King\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000},{\"vessel_id\":4,\"vessel_name\":\"MV Bulk Carrier\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000},{\"vessel_id\":5,\"vessel_name\":\"MV Steel Hauler\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000}]', 260000.00, 'approved', '2026-01-22 16:34:26'),
(13, 2, '[{\"vessel_id\":2,\"vessel_name\":\"MV Sea Master\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000},{\"vessel_id\":3,\"vessel_name\":\"MV Cargo King\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000},{\"vessel_id\":4,\"vessel_name\":\"MV Bulk Carrier\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000},{\"vessel_id\":5,\"vessel_name\":\"MV Steel Hauler\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000}]', 260000.00, 'approved', '2026-01-22 16:34:27'),
(14, 2, '[{\"vessel_id\":2,\"vessel_name\":\"MV Sea Master\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000},{\"vessel_id\":3,\"vessel_name\":\"MV Cargo King\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000},{\"vessel_id\":4,\"vessel_name\":\"MV Bulk Carrier\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000},{\"vessel_id\":5,\"vessel_name\":\"MV Steel Hauler\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000}]', 260000.00, 'approved', '2026-01-23 04:42:13'),
(15, 2, '[{\"vessel_id\":2,\"vessel_name\":\"MV Sea Master\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000},{\"vessel_id\":3,\"vessel_name\":\"MV Cargo King\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000},{\"vessel_id\":4,\"vessel_name\":\"MV Bulk Carrier\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000},{\"vessel_id\":5,\"vessel_name\":\"MV Steel Hauler\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000}]', 260000.00, 'pending', '2026-01-23 15:33:16'),
(16, 2, '[{\"vessel_id\":2,\"vessel_name\":\"MV Sea Master\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000},{\"vessel_id\":3,\"vessel_name\":\"MV Cargo King\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000},{\"vessel_id\":4,\"vessel_name\":\"MV Bulk Carrier\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000},{\"vessel_id\":5,\"vessel_name\":\"MV Steel Hauler\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000}]', 260000.00, 'pending', '2026-01-23 15:33:30'),
(17, 2, '[{\"vessel_id\":2,\"vessel_name\":\"MV Sea Master\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000},{\"vessel_id\":3,\"vessel_name\":\"MV Cargo King\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000},{\"vessel_id\":4,\"vessel_name\":\"MV Bulk Carrier\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000},{\"vessel_id\":5,\"vessel_name\":\"MV Steel Hauler\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000}]', 260000.00, 'pending', '2026-01-24 11:24:15'),
(18, 2, '[{\"vessel_id\":2,\"vessel_name\":\"MV Sea Master\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000},{\"vessel_id\":3,\"vessel_name\":\"MV Cargo King\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000},{\"vessel_id\":4,\"vessel_name\":\"MV Bulk Carrier\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000},{\"vessel_id\":5,\"vessel_name\":\"MV Steel Hauler\",\"port_id\":1,\"port_name\":\"Paradip\",\"plant_id\":1,\"plant_name\":\"Plant A\",\"breakdown\":{\"handling\":50000,\"production\":10000,\"transport\":5000},\"total_cost\":65000}]', 260000.00, 'pending', '2026-02-12 12:37:55');

-- --------------------------------------------------------

--
-- Table structure for table `plants`
--

CREATE TABLE `plants` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `demand` int(11) NOT NULL,
  `location` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `plants`
--

INSERT INTO `plants` (`id`, `name`, `demand`, `location`) VALUES
(1, 'Plant A', 30000, 'Rourkela'),
(2, 'Plant B', 25000, 'Bokaro'),
(3, 'Plant C', 35000, 'Jamshedpur'),
(4, 'Plant D', 28000, 'Durgapur'),
(5, 'Plant E', 32000, 'Burnpur');

-- --------------------------------------------------------

--
-- Table structure for table `ports`
--

CREATE TABLE `ports` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `capacity` int(11) NOT NULL,
  `location` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `ports`
--

INSERT INTO `ports` (`id`, `name`, `capacity`, `location`) VALUES
(1, 'Paradip', 50000, 'Odisha'),
(2, 'Haldia', 40000, 'West Bengal'),
(3, 'Visakhapatnam', 35000, 'Andhra Pradesh'),
(4, 'Chennai', 45000, 'Tamil Nadu');

-- --------------------------------------------------------

--
-- Table structure for table `rail_costs`
--

CREATE TABLE `rail_costs` (
  `id` int(11) NOT NULL,
  `from_port_id` int(11) NOT NULL,
  `to_plant_id` int(11) NOT NULL,
  `cost_per_ton` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `rail_costs`
--

INSERT INTO `rail_costs` (`id`, `from_port_id`, `to_plant_id`, `cost_per_ton`) VALUES
(1, 1, 1, 2.50),
(2, 1, 2, 2.80),
(3, 1, 3, 3.10),
(4, 1, 4, 3.40),
(5, 1, 5, 3.70),
(6, 2, 1, 2.30),
(7, 2, 2, 2.60),
(8, 2, 3, 2.90),
(9, 2, 4, 3.20),
(10, 2, 5, 3.50),
(11, 3, 1, 3.20),
(12, 3, 2, 3.50),
(13, 3, 3, 3.80),
(14, 3, 4, 4.10),
(15, 3, 5, 4.40),
(16, 4, 1, 3.80),
(17, 4, 2, 4.10),
(18, 4, 3, 4.40),
(19, 4, 4, 4.70),
(20, 4, 5, 5.00);

-- --------------------------------------------------------

--
-- Table structure for table `stocks`
--

CREATE TABLE `stocks` (
  `id` int(11) NOT NULL,
  `plant_id` int(11) NOT NULL,
  `product` varchar(100) NOT NULL,
  `quantity` int(11) NOT NULL,
  `aging_days` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `stocks`
--

INSERT INTO `stocks` (`id`, `plant_id`, `product`, `quantity`, `aging_days`) VALUES
(1, 1, 'Iron Ore', 25000, 5),
(2, 1, 'Coal', 15000, 3),
(3, 2, 'Iron Ore', 20000, 7),
(4, 2, 'Coal', 18000, 4),
(5, 3, 'Iron Ore', 30000, 2),
(6, 3, 'Coal', 12000, 6),
(7, 4, 'Iron Ore', 22000, 8),
(8, 4, 'Coal', 16000, 5),
(9, 5, 'Iron Ore', 28000, 4),
(10, 5, 'Coal', 14000, 7),
(11, 1, 'Iron Ore', 28000, 6),
(12, 2, 'Coal', 19000, 4),
(13, 1, 'Iron Ore', 28000, 6),
(14, 2, 'Coal', 19000, 4);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('admin','logistics_planner','operations_manager') NOT NULL,
  `reset_token` varchar(255) DEFAULT NULL,
  `reset_token_expires` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `password_hash`, `role`, `reset_token`, `reset_token_expires`, `created_at`) VALUES
(1, 'admin', 'admin@example.com', '$2y$10$aNfYGYPFdGmaCEAAWMhnlO6L4XsX9/YbjujS4wt8sEzhgBZpXIy6G', 'admin', NULL, NULL, '2026-01-22 03:52:25'),
(2, 'planner', 'planner@example.com', '$2y$10$B9O/EPQReNiV6SHb2/EvBOIegK28AjRqEMTkKKUjSNttGSnuDN97m', 'logistics_planner', NULL, NULL, '2026-01-22 03:52:25'),
(3, 'manager', 'manager@example.com', '$2y$10$KydjLo2q5Xtn3AfP6NS5g.pVDmo4cV.fcNX/tMUeZGCbc7No2kZy.', 'operations_manager', NULL, NULL, '2026-01-22 03:52:25');

-- --------------------------------------------------------

--
-- Table structure for table `vessels`
--

CREATE TABLE `vessels` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `capacity` int(11) NOT NULL,
  `eta` date NOT NULL,
  `predicted_delay` float DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `vessels`
--

INSERT INTO `vessels` (`id`, `name`, `capacity`, `eta`, `predicted_delay`) VALUES
(2, 'MV Sea Master', 45000, '2023-10-05', 1.8),
(3, 'MV Cargo King', 55000, '2023-10-10', 3.2),
(4, 'MV Bulk Carrier', 48000, '2023-10-15', 1.5),
(5, 'MV Steel Hauler', 52000, '2023-10-20', 2.1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `plans`
--
ALTER TABLE `plans`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `idx_plans_status` (`status`),
  ADD KEY `idx_plans_created_at` (`created_at`);

--
-- Indexes for table `plants`
--
ALTER TABLE `plants`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ports`
--
ALTER TABLE `ports`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `rail_costs`
--
ALTER TABLE `rail_costs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `from_port_id` (`from_port_id`),
  ADD KEY `to_plant_id` (`to_plant_id`);

--
-- Indexes for table `stocks`
--
ALTER TABLE `stocks`
  ADD PRIMARY KEY (`id`),
  ADD KEY `plant_id` (`plant_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `idx_users_username` (`username`),
  ADD KEY `idx_users_email` (`email`);

--
-- Indexes for table `vessels`
--
ALTER TABLE `vessels`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_vessels_eta` (`eta`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `audit_logs`
--
ALTER TABLE `audit_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `plans`
--
ALTER TABLE `plans`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `plants`
--
ALTER TABLE `plants`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `ports`
--
ALTER TABLE `ports`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `rail_costs`
--
ALTER TABLE `rail_costs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `stocks`
--
ALTER TABLE `stocks`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `vessels`
--
ALTER TABLE `vessels`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD CONSTRAINT `audit_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `plans`
--
ALTER TABLE `plans`
  ADD CONSTRAINT `plans_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `rail_costs`
--
ALTER TABLE `rail_costs`
  ADD CONSTRAINT `rail_costs_ibfk_1` FOREIGN KEY (`from_port_id`) REFERENCES `ports` (`id`),
  ADD CONSTRAINT `rail_costs_ibfk_2` FOREIGN KEY (`to_plant_id`) REFERENCES `plants` (`id`);

--
-- Constraints for table `stocks`
--
ALTER TABLE `stocks`
  ADD CONSTRAINT `stocks_ibfk_1` FOREIGN KEY (`plant_id`) REFERENCES `plants` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
