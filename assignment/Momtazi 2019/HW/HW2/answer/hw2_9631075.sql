-- phpMyAdmin SQL Dump
-- version 4.9.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 13, 2019 at 03:10 PM
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
-- Database: `hw2_9631075`
--

-- --------------------------------------------------------

--
-- Table structure for table `bill`
--

CREATE TABLE `bill` (
  `price` float NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 0,
  `customer_id` int(6) NOT NULL,
  `request_id` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `comment`
--

CREATE TABLE `comment` (
  `id` int(10) NOT NULL,
  `message` varchar(240) NOT NULL,
  `customer_id` int(6) NOT NULL,
  `reply_id` int(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `id` int(6) NOT NULL,
  `f_name` varchar(40) NOT NULL,
  `l_name` varchar(40) NOT NULL,
  `phone` char(11) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `link`
--

CREATE TABLE `link` (
  `url` varchar(100) NOT NULL,
  `shorten_url` varchar(30) NOT NULL,
  `start` datetime DEFAULT NULL,
  `access_foreign` int(10) DEFAULT 0,
  `access_local` int(10) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Triggers `link`
--
DELIMITER $$
CREATE TRIGGER `start_time_simpleLink` AFTER INSERT ON `link` FOR EACH ROW UPDATE link SET new.start = CURRENT_TIMESTAMP
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `premium_link`
--

CREATE TABLE `premium_link` (
  `url` varchar(100) NOT NULL,
  `shorten_link` varchar(30) NOT NULL,
  `start` datetime DEFAULT NULL,
  `access_foreign` int(10) DEFAULT 0,
  `access_local` int(10) DEFAULT 0,
  `expiration` datetime DEFAULT NULL,
  `status` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Triggers `premium_link`
--
DELIMITER $$
CREATE TRIGGER `expire_link` BEFORE DELETE ON `premium_link` FOR EACH ROW BEGIN
UPDATE premium_link SET status = 0;
SIGNAL SQLSTATE '77777';
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `start_time` AFTER INSERT ON `premium_link` FOR EACH ROW UPDATE premium_link SET new.start = CURRENT_TIMESTAMP
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `request`
--

CREATE TABLE `request` (
  `id` int(10) NOT NULL,
  `status` enum('accept','pending','reject') NOT NULL DEFAULT 'pending',
  `customer_id` int(6) NOT NULL,
  `shorten_url` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `bill`
--
ALTER TABLE `bill`
  ADD PRIMARY KEY (`request_id`),
  ADD KEY `customer_id` (`customer_id`);

--
-- Indexes for table `comment`
--
ALTER TABLE `comment`
  ADD PRIMARY KEY (`id`),
  ADD KEY `customer_id` (`customer_id`),
  ADD KEY `reply_id` (`reply_id`);

--
-- Indexes for table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `link`
--
ALTER TABLE `link`
  ADD PRIMARY KEY (`shorten_url`);

--
-- Indexes for table `premium_link`
--
ALTER TABLE `premium_link`
  ADD PRIMARY KEY (`shorten_link`);

--
-- Indexes for table `request`
--
ALTER TABLE `request`
  ADD PRIMARY KEY (`id`),
  ADD KEY `customer_id` (`customer_id`),
  ADD KEY `shorten_url` (`shorten_url`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bill`
--
ALTER TABLE `bill`
  ADD CONSTRAINT `bill_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`id`),
  ADD CONSTRAINT `bill_ibfk_2` FOREIGN KEY (`request_id`) REFERENCES `request` (`id`);

--
-- Constraints for table `comment`
--
ALTER TABLE `comment`
  ADD CONSTRAINT `comment_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`id`),
  ADD CONSTRAINT `comment_ibfk_2` FOREIGN KEY (`reply_id`) REFERENCES `comment` (`id`);

--
-- Constraints for table `request`
--
ALTER TABLE `request`
  ADD CONSTRAINT `request_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`id`),
  ADD CONSTRAINT `request_ibfk_2` FOREIGN KEY (`shorten_url`) REFERENCES `link` (`shorten_url`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
