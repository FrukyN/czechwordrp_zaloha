
CREATE TABLE IF NOT EXISTS `prison_inmates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(60) DEFAULT NULL,
  `playername` varchar(60) DEFAULT NULL,
  `prison` varchar(200) DEFAULT NULL,
  `reason` varchar(200) DEFAULT NULL,
  `remainingTime` int(11) DEFAULT NULL,
  `officerName` varchar(60) DEFAULT NULL,
  `date` varchar(50) DEFAULT NULL,
  `items` longtext DEFAULT NULL,
  `weapons` longtext DEFAULT NULL,
  `clothes` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=utf8mb4;


CREATE TABLE IF NOT EXISTS `prison_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(60) DEFAULT NULL,
  `playername` varchar(60) DEFAULT NULL,
  `prison` varchar(200) DEFAULT NULL,
  `reason` varchar(200) DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  `officerName` varchar(60) DEFAULT NULL,
  `arrestTime` varchar(60) DEFAULT NULL,
  `releaseTime` varchar(60) DEFAULT '0',
  `escaped` tinyint(4) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8mb4;