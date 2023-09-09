--
-- Database: `hw1_9631075`
--

-- --------------------------------------------------------

--
-- Table structure for table `discounts`
--

CREATE TABLE `discounts` (
  `code` varchar(6) NOT NULL,
  `passenger` int(11) NOT NULL,
  `availables` int(11) NOT NULL,
  `discount` int(11) NOT NULL,
  PRIMARY KEY (`code`,`passenger`)
);

-- --------------------------------------------------------

--
-- Table structure for table `drivers`
--

CREATE TABLE `drivers` (
  `id` int(11) NOT NULL,
  `first_name` varchar(45) NOT NULL,
  `last_name` varchar(45) NOT NULL,
  `status` int(1) NOT NULL,
  `phone` varchar(10) NOT NULL,
  PRIMARY KEY (`id`)
);

-- --------------------------------------------------------

--
-- Table structure for table `passengers`
--

CREATE TABLE `passengers` (
  `id` int(11) NOT NULL,
  `first_name` varchar(45) NOT NULL,
  `last_name` varchar(45) NOT NULL,
  `phone` varchar(10) NOT NULL,
  PRIMARY KEY (`id`)
);

-- --------------------------------------------------------

--
-- Table structure for table `rides`
--

CREATE TABLE `rides` (
  `id` int(11) NOT NULL,
  `driver` int(11) NOT NULL,
  `passenger` int(11) NOT NULL,
  `source_lat` float NOT NULL,
  `source_lng` float NOT NULL,
  `destination_lat` float NOT NULL,
  `destination_lng` float NOT NULL,
  `second_destination_lat` float DEFAULT NULL,
  `second_destination_lng` float DEFAULT NULL,
  `total_price` int(11) NOT NULL,
  `final_price` int(11) NOT NULL,
  `discount` varchar(6) DEFAULT NULL,
  `start_time` datetime NOT NULL,
  `finish_time` datetime NOT NULL,
  `score` int(1) NOT NULL,
  PRIMARY KEY (`id`)
);

ALTER TABLE `rides`
  ADD KEY `passenger_id` (`passenger`),
  ADD KEY `driver_id` (`driver`),
  ADD KEY `discount_code` (`discount`);

ALTER TABLE `rides`
  ADD CONSTRAINT `discount_code` FOREIGN KEY (`discount`) REFERENCES `discounts` (`code`),
  ADD CONSTRAINT `driver_id` FOREIGN KEY (`driver`) REFERENCES `drivers` (`id`),
  ADD CONSTRAINT `passenger_id` FOREIGN KEY (`passenger`) REFERENCES `passengers` (`id`);