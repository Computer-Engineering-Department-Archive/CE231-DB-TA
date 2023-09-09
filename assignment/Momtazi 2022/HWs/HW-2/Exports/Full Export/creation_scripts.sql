-- CREATE SCHEMA IF NOT EXISTS `vaccination-system`;

CREATE TABLE `people` (
  `social_id` int PRIMARY KEY,
  `first_name` varchar(50),
  `last_name` varchar(50),
  `gender` boolean,
  `birth_date` datetime,
  `sickness_history` boolean
);

CREATE TABLE `nurses` (
  `social_id` int PRIMARY KEY,
  `nurse_code` int,
  `certification_level` int
);

CREATE TABLE `doctors` (
  `social_id` int PRIMARY KEY,
  `association_number` int
);

CREATE TABLE `health_centers` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `code` int UNIQUE,
  `vaccination_center_id` int
);

CREATE TABLE `vaccination_centers` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `name` varchar(50),
  `address` varchar(200)
);

CREATE TABLE `vials` (
  `serial_number` int PRIMARY KEY,
  `dose_counts` int,
  `country` varchar(50),
  `created_on` datetime,
  `health_center_id` int,
  `brand_name` varchar(50)
);

CREATE TABLE `institutes` (
  `name` varchar(50) PRIMARY KEY,
  `nationality` varchar(50),
  `type` ENUM ('state', 'private', 'semi_private')
);

CREATE TABLE `brands` (
  `name` varchar(50) PRIMARY KEY,
  `dose_count` int,
  `institude_name` varchar(50)
);

CREATE TABLE `administrations` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `administrated_to` int,
  `admissioned_on` datetime,
  `administrator` int,
  `vaccination_center_id` int,
  `score` int check (`score` between 1 and 5)
);

ALTER TABLE `nurses` ADD FOREIGN KEY (`social_id`) REFERENCES `people` (`social_id`);

ALTER TABLE `doctors` ADD FOREIGN KEY (`social_id`) REFERENCES `people` (`social_id`);

ALTER TABLE `health_centers` ADD FOREIGN KEY (`vaccination_center_id`) REFERENCES `vaccination_centers` (`id`);

ALTER TABLE `vials` ADD FOREIGN KEY (`health_center_id`) REFERENCES `health_centers` (`id`);

ALTER TABLE `vials` ADD FOREIGN KEY (`brand_name`) REFERENCES `brands` (`name`);

ALTER TABLE `brands` ADD FOREIGN KEY (`institude_name`) REFERENCES `institutes` (`name`);

ALTER TABLE `administrations` ADD FOREIGN KEY (`administrated_to`) REFERENCES `people` (`social_id`);

ALTER TABLE `administrations` ADD FOREIGN KEY (`administrator`) REFERENCES `people` (`social_id`);

ALTER TABLE `administrations` ADD FOREIGN KEY (`vaccination_center_id`) REFERENCES `vaccination_centers` (`id`);
