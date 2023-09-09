-- phpMyAdmin SQL Dump
-- version 4.9.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 01, 2020 at 02:20 AM
-- Server version: 10.4.8-MariaDB
-- PHP Version: 7.3.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `restaurant_manager`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_address_log` ()  BEGIN
	DELETE FROM address_log
    WHERE (DATEDIFF(Date(CURRENT_TIMESTAMP()),  Date(log_time))) >= 3;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_customer_log` ()  BEGIN
	DELETE FROM customer_log
    WHERE (DATEDIFF(Date(CURRENT_TIMESTAMP()),  Date(log_time))) >= 3;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_delivery_log` ()  BEGIN
	DELETE FROM delivery_log
    WHERE (DATEDIFF(Date(CURRENT_TIMESTAMP()),  Date(log_time))) >= 3;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_food_log` ()  BEGIN
	DELETE FROM food_log
    WHERE (DATEDIFF(Date(CURRENT_TIMESTAMP()),  Date(log_time))) >= 3;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_food_receipt_log` ()  BEGIN
	DELETE FROM food_receipt_log
    WHERE (DATEDIFF(Date(CURRENT_TIMESTAMP()),  Date(log_time))) >= 3;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_market_log` ()  BEGIN
	DELETE FROM market_log
    WHERE (DATEDIFF(Date(CURRENT_TIMESTAMP()),  Date(log_time))) >= 3;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_material_log` ()  BEGIN
	DELETE FROM material_log
    WHERE (DATEDIFF(Date(CURRENT_TIMESTAMP()),  Date(log_time))) >= 3;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_material_receipt_log` ()  BEGIN
	DELETE FROM material_receipt_log
    WHERE (DATEDIFF(Date(CURRENT_TIMESTAMP()),  Date(log_time))) >= 3;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `address`
--

CREATE TABLE `address` (
  `address_id` int(11) NOT NULL,
  `name` varchar(30) NOT NULL,
  `address_str` varchar(150) NOT NULL,
  `phone_number` char(11) NOT NULL,
  `customer_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `address`
--

INSERT INTO `address` (`address_id`, `name`, `address_str`, `phone_number`, `customer_id`) VALUES
(1, 'Home', 'No. 1, Gol Davari, Sarv, Tehran, Iran', '02144162672', 1),
(2, 'Work', 'No. 3, Shariati St., Tehran, Iran', '02188324211', 1),
(3, 'University', 'No. 1, Valiasr St. Amirkabir University of Technology, Tehran, Iran', '02164541234', 1),
(4, 'Home', 'No. 32, Tajrish, Tehran, Iran', '02133652892', 2),
(5, 'Work', 'No. 63, Vanak, Tehran, Iran', '02177124551', 2),
(6, 'University', 'No. 121, Valiasr St. Amirkabir University of Technology', '02164541234', 2),
(7, 'Home', 'No. 72, Shohada, Tehran, Iran', '02133754365', 3),
(8, 'Work', 'No. 163, TehranPars, Tehran, Iran', '02166145551', 3),
(9, 'University', 'No. 87, Valiasr St. Amirkabir University of Technology, Tehran, Iran', '02164541234', 3),
(10, 'Home', 'No. 23, Tooti, Hafez St., Shariati, Tehran, Iran', '02144194365', 4),
(11, 'Work', 'No. 163, Mirdamad, Tehran, Iran', '02155145551', 4),
(12, 'University', 'No. 87, Valiasr St. Amirkabir University of Technology, Tehran, Iran', '02164541234', 4),
(13, 'Home', 'No. 72, ShareRey, Tehran, Iran', '02144564365', 5),
(14, 'Work', 'No. 163, Shahriyar, Tehran, Iran', '02199143451', 5),
(15, 'University', 'No. 87, Valiasr St. Amirkabir University of Technology, Tehran, Iran', '02164541234', 5);

--
-- Triggers `address`
--
DELIMITER $$
CREATE TRIGGER `delete_address_log` AFTER DELETE ON `address` FOR EACH ROW INSERT INTO `address_log` (`log_time`, `operation`, `address_id`, `table_name`) VALUES (current_timestamp(), "DELETE", old.address_id, "address")
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insert_address_log` AFTER INSERT ON `address` FOR EACH ROW INSERT INTO `address_log` (`log_time`, `operation`, `address_id`, `table_name`) VALUES (current_timestamp(), "INSERT", new.address_id, "address")
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_address_log` AFTER UPDATE ON `address` FOR EACH ROW INSERT INTO `address_log` (`log_time`, `operation`, `address_id`, `table_name`) VALUES (current_timestamp(), "UPDATE", new.address_id, "address")
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `address_log`
--

CREATE TABLE `address_log` (
  `log_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `operation` enum('UPDATE','INSERT','DELETE') NOT NULL,
  `address_id` int(11) NOT NULL,
  `table_name` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `address_log`
--

INSERT INTO `address_log` (`log_time`, `operation`, `address_id`, `table_name`) VALUES
('2020-01-30 21:02:19', 'INSERT', 45, 'address'),
('2020-01-31 06:44:11', 'UPDATE', 45, 'address'),
('2020-01-31 06:45:04', 'DELETE', 45, 'address');

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `customer_id` int(11) NOT NULL,
  `f_name` varchar(45) NOT NULL,
  `l_name` varchar(45) NOT NULL,
  `mobile_number` char(11) NOT NULL,
  `age` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`customer_id`, `f_name`, `l_name`, `mobile_number`, `age`) VALUES
(1, 'Ali', 'Nazari', '09212812589', 21),
(2, 'MohamadAli', 'Keshavarz', '09127125632', 20),
(3, 'Mahdi', 'SadeqZadeh', '09375312567', 20),
(4, 'Maryam', 'Safi', '09385412789', 19),
(5, 'Mahan', 'ZendehDel', '09336523999', 18),
(6, 'Parham', 'Alvani', '09126543811', 25),
(7, 'Erfan', 'Abedi', '09384567123', 20),
(8, 'Saeedeh', 'Momtazi', '09123423666', 35);

--
-- Triggers `customer`
--
DELIMITER $$
CREATE TRIGGER `delete_customer_log` AFTER DELETE ON `customer` FOR EACH ROW INSERT INTO `customer_log` (`log_time`, `operation`, `customer_id`, `table_name`) VALUES (current_timestamp(), "DELETE", old.customer_id, "customer")
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insert_customer_log` AFTER INSERT ON `customer` FOR EACH ROW INSERT INTO `customer_log` (`log_time`, `operation`, `customer_id`, `table_name`) VALUES (current_timestamp(), "INSERT", new.customer_id, "customer")
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_customer_log` AFTER UPDATE ON `customer` FOR EACH ROW INSERT INTO `customer_log` (`log_time`, `operation`, `customer_id`, `table_name`) VALUES (current_timestamp(), "UPDATE", new.customer_id, "customer")
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `customer_log`
--

CREATE TABLE `customer_log` (
  `log_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `operation` enum('UPDATE','INSERT','DELETE') NOT NULL,
  `customer_id` int(11) NOT NULL,
  `table_name` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `customer_log`
--

INSERT INTO `customer_log` (`log_time`, `operation`, `customer_id`, `table_name`) VALUES
('2020-01-31 06:46:18', 'INSERT', 10, 'customer'),
('2020-01-31 08:53:23', 'DELETE', 10, 'customer');

-- --------------------------------------------------------

--
-- Table structure for table `delivery`
--

CREATE TABLE `delivery` (
  `delivery_id` int(11) NOT NULL,
  `f_name` varchar(45) NOT NULL,
  `l_name` varchar(45) NOT NULL,
  `identification_number` char(10) NOT NULL,
  `phone_number` char(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `delivery`
--

INSERT INTO `delivery` (`delivery_id`, `f_name`, `l_name`, `identification_number`, `phone_number`) VALUES
(1, 'Reza', 'Safa Bakhsh', '0024312190', '09121128923'),
(2, 'Maryam', 'Amir Mazlaghani', '0061235420', '09119423876'),
(3, 'Hamed', 'Farbeh', '0041231211', '09135423876'),
(4, 'Mohamad', 'Rahmati', '0491235432', '09382354123');

--
-- Triggers `delivery`
--
DELIMITER $$
CREATE TRIGGER `delete_delivery_log` AFTER DELETE ON `delivery` FOR EACH ROW INSERT INTO `delivery_log` (`log_time`, `operation`, `delivery_id`, `table_name`) VALUES (current_timestamp(), "DELETE", old.delivery_id, "delivery")
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insert_delivery_log` AFTER INSERT ON `delivery` FOR EACH ROW INSERT INTO `delivery_log` (`log_time`, `operation`, `delivery_id`, `table_name`) VALUES (current_timestamp(), "INSERT", new.delivery_id, "delivery")
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_delivery_log` AFTER UPDATE ON `delivery` FOR EACH ROW INSERT INTO `delivery_log` (`log_time`, `operation`, `delivery_id`, `table_name`) VALUES (current_timestamp(), "UPDATE", new.delivery_id, "delivery")
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `delivery_log`
--

CREATE TABLE `delivery_log` (
  `log_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `operation` enum('UPDATE','INSERT','DELETE') NOT NULL,
  `delivery_id` int(11) NOT NULL,
  `table_name` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `delivery_log`
--

INSERT INTO `delivery_log` (`log_time`, `operation`, `delivery_id`, `table_name`) VALUES
('2020-01-31 14:16:53', 'INSERT', 6, 'delivery'),
('2020-01-31 14:16:55', 'DELETE', 6, 'delivery');

-- --------------------------------------------------------

--
-- Table structure for table `food`
--

CREATE TABLE `food` (
  `food_id` int(11) NOT NULL,
  `name` varchar(30) NOT NULL,
  `price` decimal(10,0) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `food`
--

INSERT INTO `food` (`food_id`, `name`, `price`) VALUES
(1, 'Pizza', '40000'),
(2, 'Kebab', '30000'),
(3, 'Chicken Kebab', '25000'),
(4, 'Chicken', '24000'),
(5, 'Fish', '35000'),
(6, 'Hot Dog', '20000'),
(7, 'Steak', '45000'),
(8, 'Pasta', '30000'),
(9, 'French Fries', '10000');

--
-- Triggers `food`
--
DELIMITER $$
CREATE TRIGGER `delete_food_log` AFTER DELETE ON `food` FOR EACH ROW INSERT INTO `food_log` (`log_time`, `operation`, `food_id`, `table_name`) VALUES (current_timestamp(), "DELETE", old.food_id, "food")
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insert_food_log` AFTER INSERT ON `food` FOR EACH ROW INSERT INTO `food_log` (`log_time`, `operation`, `food_id`, `table_name`) VALUES (current_timestamp(), "INSERT", new.food_id, "food")
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_food_log` AFTER UPDATE ON `food` FOR EACH ROW INSERT INTO `food_log` (`log_time`, `operation`, `food_id`, `table_name`) VALUES (current_timestamp(), "UPDATE", new.food_id, "food")
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `food_log`
--

CREATE TABLE `food_log` (
  `log_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `operation` enum('UPDATE','INSERT','DELETE') NOT NULL,
  `food_id` int(11) NOT NULL,
  `table_name` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `food_log`
--

INSERT INTO `food_log` (`log_time`, `operation`, `food_id`, `table_name`) VALUES
('2020-01-31 08:56:16', 'INSERT', 11, 'food'),
('2020-01-31 08:56:25', 'DELETE', 11, 'food'),
('2020-01-31 12:46:12', 'INSERT', 12, 'food'),
('2020-01-31 12:46:19', 'DELETE', 12, 'food'),
('2020-01-31 13:14:45', 'INSERT', 13, 'food'),
('2020-01-31 13:14:47', 'DELETE', 13, 'food');

-- --------------------------------------------------------

--
-- Table structure for table `food_receipt`
--

CREATE TABLE `food_receipt` (
  `receipt_id` int(11) NOT NULL,
  `total_price` decimal(10,0) NOT NULL,
  `serve_place` enum('inside','outside') NOT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `address_id` int(11) DEFAULT NULL,
  `delievery_id` int(11) DEFAULT NULL,
  `food_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `food_receipt`
--

INSERT INTO `food_receipt` (`receipt_id`, `total_price`, `serve_place`, `customer_id`, `address_id`, `delievery_id`, `food_id`) VALUES
(2, '30000', 'outside', 3, 3, 2, 2),
(3, '40000', 'outside', 6, 5, 4, 1);

--
-- Triggers `food_receipt`
--
DELIMITER $$
CREATE TRIGGER `delete_food_receipt_log` AFTER DELETE ON `food_receipt` FOR EACH ROW INSERT INTO `food_receipt_log` (`log_time`, `operation`, `food_receipt_id`, `table_name`) VALUES (current_timestamp(), "DELETE", old.receipt_id, "food_receipt")
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insert_food_receipt_log` AFTER INSERT ON `food_receipt` FOR EACH ROW INSERT INTO `food_receipt_log` (`log_time`, `operation`, `food_receipt_id`, `table_name`) VALUES (current_timestamp(), "INSERT", new.receipt_id, "food_receipt")
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_food_receipt_log` AFTER UPDATE ON `food_receipt` FOR EACH ROW INSERT INTO `food_receipt_log` (`log_time`, `operation`, `food_receipt_id`, `table_name`) VALUES (current_timestamp(), "UPDATE", new.receipt_id, "food_receipt")
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `food_receipt_log`
--

CREATE TABLE `food_receipt_log` (
  `log_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `operation` enum('UPDATE','INSERT','DELETE') NOT NULL,
  `food_receipt_id` int(11) NOT NULL,
  `table_name` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `food_receipt_log`
--

INSERT INTO `food_receipt_log` (`log_time`, `operation`, `food_receipt_id`, `table_name`) VALUES
('2020-01-31 14:30:37', 'INSERT', 9, 'food_receipt'),
('2020-01-31 14:32:12', 'UPDATE', 1, 'food_receipt'),
('2020-01-31 14:54:55', 'INSERT', 2, 'food_receipt'),
('2020-01-31 20:36:02', 'INSERT', 3, 'food_receipt'),
('2020-01-31 20:38:20', 'INSERT', 4, 'food_receipt'),
('2020-01-31 20:40:18', 'INSERT', 5, 'food_receipt'),
('2020-01-31 20:40:44', 'INSERT', 6, 'food_receipt'),
('2020-01-31 20:41:09', 'INSERT', 7, 'food_receipt'),
('2020-01-31 20:42:24', 'INSERT', 8, 'food_receipt'),
('2020-01-31 20:43:39', 'INSERT', 9, 'food_receipt'),
('2020-01-31 20:44:52', 'INSERT', 10, 'food_receipt'),
('2020-01-31 20:45:25', 'INSERT', 11, 'food_receipt'),
('2020-01-31 20:45:49', 'INSERT', 12, 'food_receipt'),
('2020-01-31 20:46:51', 'INSERT', 13, 'food_receipt'),
('2020-01-31 20:47:32', 'INSERT', 14, 'food_receipt'),
('2020-01-31 20:53:56', 'INSERT', 15, 'food_receipt'),
('2020-01-31 20:54:40', 'INSERT', 16, 'food_receipt'),
('2020-01-31 20:55:23', 'INSERT', 17, 'food_receipt'),
('2020-01-31 20:55:37', 'INSERT', 18, 'food_receipt'),
('2020-01-31 20:58:15', 'INSERT', 19, 'food_receipt'),
('2020-01-31 20:59:20', 'INSERT', 20, 'food_receipt'),
('2020-01-31 21:02:15', 'INSERT', 21, 'food_receipt'),
('2020-01-31 21:02:33', 'INSERT', 22, 'food_receipt'),
('2020-01-31 21:05:10', 'INSERT', 23, 'food_receipt'),
('2020-01-31 21:11:06', 'INSERT', 1, 'food_receipt'),
('2020-01-31 21:12:11', 'DELETE', 1, 'food_receipt'),
('2020-01-31 21:14:55', 'INSERT', 2, 'food_receipt'),
('2020-01-31 21:15:11', 'INSERT', 3, 'food_receipt');

-- --------------------------------------------------------

--
-- Table structure for table `market`
--

CREATE TABLE `market` (
  `market_id` int(11) NOT NULL,
  `market_name` varchar(45) NOT NULL,
  `is_active` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `market`
--

INSERT INTO `market` (`market_id`, `market_name`, `is_active`) VALUES
(1, 'Shahrvand', 1),
(2, 'Refah', 1),
(3, 'Hyper Star', 1),
(4, 'City Star', 0),
(5, 'Hyper Me', 1),
(6, 'Kourosh', 1),
(7, 'Ta\'aavoni', 1),
(8, 'Ya\'qub', 1);

--
-- Triggers `market`
--
DELIMITER $$
CREATE TRIGGER `delete_market_log` AFTER DELETE ON `market` FOR EACH ROW INSERT INTO `market_log` (`log_time`, `operation`, `market_id`, `table_name`) VALUES (current_timestamp(), "DELETE", old.market_id, "market")
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insert_market_log` AFTER INSERT ON `market` FOR EACH ROW INSERT INTO `market_log` (`log_time`, `operation`, `market_id`, `table_name`) VALUES (current_timestamp(), "INSERT", new.market_id, "market")
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_market_log` AFTER UPDATE ON `market` FOR EACH ROW INSERT INTO `market_log` (`log_time`, `operation`, `market_id`, `table_name`) VALUES (current_timestamp(), "UPDATE", new.market_id, "market")
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `market_log`
--

CREATE TABLE `market_log` (
  `log_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `operation` enum('UPDATE','INSERT','DELETE') NOT NULL,
  `market_id` int(11) NOT NULL,
  `table_name` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `market_log`
--

INSERT INTO `market_log` (`log_time`, `operation`, `market_id`, `table_name`) VALUES
('2020-01-31 06:50:34', 'INSERT', 10, 'market'),
('2020-01-31 06:50:37', 'DELETE', 10, 'market'),
('2020-01-31 06:58:10', 'INSERT', 11, 'market'),
('2020-01-31 06:58:16', 'INSERT', 12, 'market'),
('2020-01-31 06:58:19', 'DELETE', 12, 'market'),
('2020-01-31 06:58:20', 'DELETE', 11, 'market');

-- --------------------------------------------------------

--
-- Table structure for table `material`
--

CREATE TABLE `material` (
  `material_id` int(11) NOT NULL,
  `name` varchar(45) NOT NULL,
  `price` decimal(10,0) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `material`
--

INSERT INTO `material` (`material_id`, `name`, `price`) VALUES
(1, 'Bread', '2000'),
(2, 'Salt', '500'),
(3, 'Garlic', '2000'),
(4, 'Tomato', '3000'),
(5, 'Potato', '4000'),
(6, 'Water', '1000'),
(7, 'Rice', '15000'),
(8, 'Chicken', '20000'),
(9, 'Meat', '80000'),
(10, 'Pepper', '2500');

--
-- Triggers `material`
--
DELIMITER $$
CREATE TRIGGER `delete_material_log` AFTER DELETE ON `material` FOR EACH ROW INSERT INTO `material_log` (`log_time`, `operation`, `material_id`, `table_name`) VALUES (current_timestamp(), "DELETE", old.material_id, "material")
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insert_material_log` AFTER INSERT ON `material` FOR EACH ROW INSERT INTO `material_log` (`log_time`, `operation`, `material_id`, `table_name`) VALUES (current_timestamp(), "INSERT", new.material_id, "material")
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_material_log` AFTER UPDATE ON `material` FOR EACH ROW INSERT INTO `material_log` (`log_time`, `operation`, `material_id`, `table_name`) VALUES (current_timestamp(), "UPDATE", new.material_id, "material")
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `material_log`
--

CREATE TABLE `material_log` (
  `log_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `operation` enum('UPDATE','INSERT','DELETE') NOT NULL,
  `material_id` int(11) NOT NULL,
  `table_name` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `material_log`
--

INSERT INTO `material_log` (`log_time`, `operation`, `material_id`, `table_name`) VALUES
('2020-01-31 14:21:44', 'INSERT', 12, 'material'),
('2020-01-31 14:21:48', 'INSERT', 13, 'material'),
('2020-01-31 14:21:49', 'DELETE', 12, 'material'),
('2020-01-31 14:21:50', 'DELETE', 13, 'material');

-- --------------------------------------------------------

--
-- Table structure for table `material_market`
--

CREATE TABLE `material_market` (
  `material_id` int(11) NOT NULL,
  `market_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `material_receipt`
--

CREATE TABLE `material_receipt` (
  `material_receipt_id` int(11) NOT NULL,
  `total_price` decimal(10,0) NOT NULL,
  `market_id` int(11) NOT NULL,
  `material_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `material_receipt`
--

INSERT INTO `material_receipt` (`material_receipt_id`, `total_price`, `market_id`, `material_id`) VALUES
(1, '3000', 3, 1),
(4, '0', 1, 5),
(5, '0', 7, 6);

--
-- Triggers `material_receipt`
--
DELIMITER $$
CREATE TRIGGER `delete_material_receipt_log` AFTER DELETE ON `material_receipt` FOR EACH ROW INSERT INTO `material_receipt_log` (`log_time`, `operation`, `material_receipt_id`, `table_name`) VALUES (current_timestamp(), "DELETE", old.material_receipt_id, "material_receipt")
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `insert_material_receipt_log` AFTER INSERT ON `material_receipt` FOR EACH ROW INSERT INTO `material_receipt_log` (`log_time`, `operation`, `material_receipt_id`, `table_name`) VALUES (current_timestamp(), "INSERT", new.material_receipt_id, "material_receipt")
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_material_receipt_log` AFTER UPDATE ON `material_receipt` FOR EACH ROW INSERT INTO `material_receipt_log` (`log_time`, `operation`, `material_receipt_id`, `table_name`) VALUES (current_timestamp(), "UPDATE", new.material_receipt_id, "material_receipt")
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `material_receipt_log`
--

CREATE TABLE `material_receipt_log` (
  `log_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `operation` enum('UPDATE','INSERT','DELETE') NOT NULL,
  `material_receipt_id` int(11) NOT NULL,
  `table_name` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `material_receipt_log`
--

INSERT INTO `material_receipt_log` (`log_time`, `operation`, `material_receipt_id`, `table_name`) VALUES
('2020-01-31 13:34:49', 'INSERT', 1, 'material_receipt'),
('2020-01-31 21:26:28', 'DELETE', 1, 'material_receipt'),
('2020-01-31 21:33:36', 'INSERT', 1, 'material_receipt'),
('2020-01-31 21:56:29', 'INSERT', 3, 'material_receipt'),
('2020-01-31 21:56:35', 'DELETE', 3, 'material_receipt'),
('2020-01-31 22:00:11', 'INSERT', 4, 'material_receipt'),
('2020-01-31 22:00:17', 'INSERT', 5, 'material_receipt');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `address`
--
ALTER TABLE `address`
  ADD PRIMARY KEY (`address_id`),
  ADD KEY `FOREIGN` (`customer_id`) USING BTREE;

--
-- Indexes for table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`customer_id`);

--
-- Indexes for table `delivery`
--
ALTER TABLE `delivery`
  ADD PRIMARY KEY (`delivery_id`);

--
-- Indexes for table `food`
--
ALTER TABLE `food`
  ADD PRIMARY KEY (`food_id`);

--
-- Indexes for table `food_receipt`
--
ALTER TABLE `food_receipt`
  ADD PRIMARY KEY (`receipt_id`),
  ADD KEY `FK_Address` (`address_id`),
  ADD KEY `FK_Customer` (`customer_id`),
  ADD KEY `FK_Delivery` (`delievery_id`),
  ADD KEY `FK_Food` (`food_id`);

--
-- Indexes for table `market`
--
ALTER TABLE `market`
  ADD PRIMARY KEY (`market_id`);

--
-- Indexes for table `material`
--
ALTER TABLE `material`
  ADD PRIMARY KEY (`material_id`);

--
-- Indexes for table `material_market`
--
ALTER TABLE `material_market`
  ADD PRIMARY KEY (`material_id`,`market_id`);

--
-- Indexes for table `material_receipt`
--
ALTER TABLE `material_receipt`
  ADD PRIMARY KEY (`material_receipt_id`),
  ADD KEY `FK_Market` (`market_id`),
  ADD KEY `FK_Material` (`material_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `address`
--
ALTER TABLE `address`
  MODIFY `address_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `customer`
--
ALTER TABLE `customer`
  MODIFY `customer_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `delivery`
--
ALTER TABLE `delivery`
  MODIFY `delivery_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `food`
--
ALTER TABLE `food`
  MODIFY `food_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `food_receipt`
--
ALTER TABLE `food_receipt`
  MODIFY `receipt_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `market`
--
ALTER TABLE `market`
  MODIFY `market_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `material`
--
ALTER TABLE `material`
  MODIFY `material_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `material_receipt`
--
ALTER TABLE `material_receipt`
  MODIFY `material_receipt_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `address`
--
ALTER TABLE `address`
  ADD CONSTRAINT `FOREIGN` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `food_receipt`
--
ALTER TABLE `food_receipt`
  ADD CONSTRAINT `FK_Address` FOREIGN KEY (`address_id`) REFERENCES `address` (`address_id`),
  ADD CONSTRAINT `FK_Customer` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`),
  ADD CONSTRAINT `FK_Delivery` FOREIGN KEY (`delievery_id`) REFERENCES `delivery` (`delivery_id`),
  ADD CONSTRAINT `FK_Food` FOREIGN KEY (`food_id`) REFERENCES `food` (`food_id`);

--
-- Constraints for table `material_receipt`
--
ALTER TABLE `material_receipt`
  ADD CONSTRAINT `FK_Market` FOREIGN KEY (`market_id`) REFERENCES `market` (`market_id`),
  ADD CONSTRAINT `FK_Material` FOREIGN KEY (`material_id`) REFERENCES `material` (`material_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
