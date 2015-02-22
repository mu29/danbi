# ************************************************************
# Sequel Pro SQL dump
# Version 4096
#
# http://www.sequelpro.com/
# http://code.google.com/p/sequel-pro/
#
# Host: localhost (MySQL 5.6.22)
# Database: danbi
# Generation Time: 2015-02-22 14:23:50 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table equip
# ------------------------------------------------------------

DROP TABLE IF EXISTS `equip`;

CREATE TABLE `equip` (
  `user_no` int(11) unsigned NOT NULL,
  `weapon` int(11) NOT NULL DEFAULT '0',
  `shield` int(11) NOT NULL DEFAULT '0',
  `helmet` int(11) NOT NULL DEFAULT '0',
  `armor` int(11) NOT NULL DEFAULT '0',
  `cape` int(11) NOT NULL DEFAULT '0',
  `shoes` int(11) NOT NULL DEFAULT '0',
  `accessory` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`user_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `equip` WRITE;
/*!40000 ALTER TABLE `equip` DISABLE KEYS */;

INSERT INTO `equip` (`user_no`, `weapon`, `shield`, `helmet`, `armor`, `cape`, `shoes`, `accessory`)
VALUES
	(1,7,0,0,0,0,14,0),
	(2,0,0,0,0,0,0,0),
	(3,0,0,0,0,0,0,0),
	(4,0,0,0,0,0,0,0),
	(6,0,0,0,0,0,0,0),
	(8,0,0,0,0,0,0,0),
	(9,0,0,0,0,0,0,0),
	(11,0,0,0,0,0,0,0),
	(12,0,0,0,0,0,0,0);

/*!40000 ALTER TABLE `equip` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table item
# ------------------------------------------------------------

DROP TABLE IF EXISTS `item`;

CREATE TABLE `item` (
  `user_no` int(11) NOT NULL,
  `item_no` int(11) NOT NULL,
  `amount` int(11) NOT NULL,
  `index` int(11) NOT NULL,
  `damage` int(11) NOT NULL DEFAULT '0',
  `magic_damage` int(11) NOT NULL DEFAULT '0',
  `defense` int(11) NOT NULL DEFAULT '0',
  `magic_defense` int(11) NOT NULL DEFAULT '0',
  `str` int(11) NOT NULL DEFAULT '0',
  `dex` int(11) NOT NULL DEFAULT '0',
  `agi` int(11) NOT NULL DEFAULT '0',
  `hp` int(11) NOT NULL DEFAULT '0',
  `mp` int(11) NOT NULL DEFAULT '0',
  `critical` int(11) NOT NULL DEFAULT '0',
  `avoid` int(11) NOT NULL DEFAULT '0',
  `hit` int(11) NOT NULL DEFAULT '0',
  `reinforce` int(11) NOT NULL DEFAULT '0',
  `trade` int(11) NOT NULL DEFAULT '1',
  `equipped` int(11) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `item` WRITE;
/*!40000 ALTER TABLE `item` DISABLE KEYS */;

INSERT INTO `item` (`user_no`, `item_no`, `amount`, `index`, `damage`, `magic_damage`, `defense`, `magic_defense`, `str`, `dex`, `agi`, `hp`, `mp`, `critical`, `avoid`, `hit`, `reinforce`, `trade`, `equipped`)
VALUES
	(1,1,1,10,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0),
	(1,1,1,7,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1),
	(1,1,1,15,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0),
	(1,6,1,14,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1),
	(1,1,1,13,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0),
	(1,8,3,12,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0),
	(1,1,1,11,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0),
	(12,1,1,5,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0),
	(12,1,1,4,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0),
	(12,1,1,3,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0),
	(12,8,2,2,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0),
	(12,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0);

/*!40000 ALTER TABLE `item` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table setting_item
# ------------------------------------------------------------

DROP TABLE IF EXISTS `setting_item`;

CREATE TABLE `setting_item` (
  `no` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` char(255) NOT NULL DEFAULT '',
  `description` char(255) NOT NULL DEFAULT '',
  `image` char(255) NOT NULL DEFAULT '',
  `job` int(11) NOT NULL DEFAULT '0',
  `limit_level` int(11) NOT NULL DEFAULT '1',
  `type` int(11) NOT NULL DEFAULT '0',
  `price` int(11) NOT NULL DEFAULT '0',
  `damage` int(11) NOT NULL DEFAULT '0',
  `magic_damage` int(11) NOT NULL DEFAULT '0',
  `defense` int(11) NOT NULL DEFAULT '0',
  `magic_defense` int(11) NOT NULL DEFAULT '0',
  `str` int(11) NOT NULL DEFAULT '0',
  `dex` int(11) NOT NULL DEFAULT '0',
  `agi` int(11) NOT NULL DEFAULT '0',
  `hp` int(11) NOT NULL DEFAULT '0',
  `mp` int(11) NOT NULL DEFAULT '0',
  `critical` int(11) NOT NULL DEFAULT '0',
  `avoid` int(11) NOT NULL DEFAULT '0',
  `hit` int(11) NOT NULL DEFAULT '0',
  `delay` int(11) NOT NULL DEFAULT '0',
  `consume` int(11) NOT NULL DEFAULT '1',
  `max_load` int(11) NOT NULL DEFAULT '1',
  `trade` int(11) NOT NULL DEFAULT '1',
  `function` char(255) DEFAULT NULL,
  PRIMARY KEY (`no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `setting_item` WRITE;
/*!40000 ALTER TABLE `setting_item` DISABLE KEYS */;

INSERT INTO `setting_item` (`no`, `name`, `description`, `image`, `job`, `limit_level`, `type`, `price`, `damage`, `magic_damage`, `defense`, `magic_defense`, `str`, `dex`, `agi`, `hp`, `mp`, `critical`, `avoid`, `hit`, `delay`, `consume`, `max_load`, `trade`, `function`)
VALUES
	(1,'목도','나무로 만든 검','001-Weapon01',0,1,0,100,10,10,10,10,5,4,3,2,1,10,5,5,2,0,1,1,NULL),
	(2,'냄비 뚜껑','방패가 없으니 이거라도 쓰자','009-Shield01',0,1,1,10,0,0,5,0,0,0,0,0,0,0,0,0,0,0,1,1,NULL),
	(3,'밀짚모자','난 해적왕이 될 사나이!','010-Head01',0,1,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,NULL),
	(4,'쫄쫄이 잠옷','입을 옷이 없다','014-Body02',0,1,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,NULL),
	(5,'누더기 망토','누가 쓰던걸까','019-Accessory04',0,1,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,NULL),
	(6,'등산화','아빠 등산화를 훔쳤다','020-Accessory05',0,1,5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,NULL),
	(7,'금반지','돌잔치때 받은 금반지','016-Accessory01',0,1,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,NULL),
	(8,'포션','뭐지 이 아이템은','021-Potion01',0,1,7,0,0,0,0,0,0,0,0,100,0,0,0,0,0,1,10,1,'potion');

/*!40000 ALTER TABLE `setting_item` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table setting_job
# ------------------------------------------------------------

DROP TABLE IF EXISTS `setting_job`;

CREATE TABLE `setting_job` (
  `no` int(11) NOT NULL DEFAULT '0',
  `name` char(255) NOT NULL DEFAULT '전사',
  `hp` int(11) NOT NULL DEFAULT '0',
  `mp` int(11) NOT NULL DEFAULT '0',
  `str` int(11) NOT NULL DEFAULT '0',
  `dex` int(11) NOT NULL DEFAULT '0',
  `agi` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `setting_job` WRITE;
/*!40000 ALTER TABLE `setting_job` DISABLE KEYS */;

INSERT INTO `setting_job` (`no`, `name`, `hp`, `mp`, `str`, `dex`, `agi`)
VALUES
	(1,'전사',1000,5,1,0,0),
	(2,'마법사',5,10,0,0,1),
	(3,'도적',7,7,0,1,0);

/*!40000 ALTER TABLE `setting_job` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table setting_npc
# ------------------------------------------------------------

DROP TABLE IF EXISTS `setting_npc`;

CREATE TABLE `setting_npc` (
  `no` int(11) DEFAULT NULL,
  `name` char(255) DEFAULT NULL,
  `image` char(255) DEFAULT NULL,
  `map` int(11) DEFAULT NULL,
  `x` int(11) DEFAULT NULL,
  `y` int(11) DEFAULT NULL,
  `direction` int(11) DEFAULT NULL,
  `function` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

LOCK TABLES `setting_npc` WRITE;
/*!40000 ALTER TABLE `setting_npc` DISABLE KEYS */;

INSERT INTO `setting_npc` (`no`, `name`, `image`, `map`, `x`, `y`, `direction`, `function`)
VALUES
	(1,'테스트','003-Fighter03',1,10,4,2,NULL);

/*!40000 ALTER TABLE `setting_npc` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table setting_register
# ------------------------------------------------------------

DROP TABLE IF EXISTS `setting_register`;

CREATE TABLE `setting_register` (
  `no` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `job` int(11) NOT NULL DEFAULT '1',
  `image` char(255) NOT NULL DEFAULT '001-Fighter01',
  `map` int(11) NOT NULL DEFAULT '0',
  `x` int(11) NOT NULL DEFAULT '0',
  `y` int(11) NOT NULL DEFAULT '0',
  `level` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`no`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

LOCK TABLES `setting_register` WRITE;
/*!40000 ALTER TABLE `setting_register` DISABLE KEYS */;

INSERT INTO `setting_register` (`no`, `job`, `image`, `map`, `x`, `y`, `level`)
VALUES
	(1,1,'001-Fighter01',1,0,0,1),
	(2,1,'002-Fighter02',1,0,0,1),
	(3,2,'004-Fighter04',1,0,0,1);

/*!40000 ALTER TABLE `setting_register` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table setting_reward
# ------------------------------------------------------------

DROP TABLE IF EXISTS `setting_reward`;

CREATE TABLE `setting_reward` (
  `no` int(11) DEFAULT NULL,
  `item_no` int(11) DEFAULT NULL,
  `num` int(11) DEFAULT '1',
  `per` int(11) DEFAULT '100'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

LOCK TABLES `setting_reward` WRITE;
/*!40000 ALTER TABLE `setting_reward` DISABLE KEYS */;

INSERT INTO `setting_reward` (`no`, `item_no`, `num`, `per`)
VALUES
	(1,1,1,10000);

/*!40000 ALTER TABLE `setting_reward` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table setting_shop
# ------------------------------------------------------------

DROP TABLE IF EXISTS `setting_shop`;

CREATE TABLE `setting_shop` (
  `no` int(11) DEFAULT NULL,
  `item_no` int(11) DEFAULT '1',
  `rate` int(11) DEFAULT '50'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `setting_shop` WRITE;
/*!40000 ALTER TABLE `setting_shop` DISABLE KEYS */;

INSERT INTO `setting_shop` (`no`, `item_no`, `rate`)
VALUES
	(1,8,50);

/*!40000 ALTER TABLE `setting_shop` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table setting_skill
# ------------------------------------------------------------

DROP TABLE IF EXISTS `setting_skill`;

CREATE TABLE `setting_skill` (
  `no` int(11) NOT NULL AUTO_INCREMENT,
  `name` char(255) DEFAULT NULL,
  `description` char(255) DEFAULT NULL,
  `type` char(255) DEFAULT NULL,
  `job` int(11) DEFAULT NULL,
  `delay` int(11) DEFAULT NULL,
  `limit_level` int(11) DEFAULT NULL,
  `max_rank` int(11) DEFAULT NULL,
  `user_animation` int(11) DEFAULT NULL,
  `target_animation` int(11) DEFAULT NULL,
  `image` char(255) DEFAULT NULL,
  `function` char(255) DEFAULT NULL,
  PRIMARY KEY (`no`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

LOCK TABLES `setting_skill` WRITE;
/*!40000 ALTER TABLE `setting_skill` DISABLE KEYS */;

INSERT INTO `setting_skill` (`no`, `name`, `description`, `type`, `job`, `delay`, `limit_level`, `max_rank`, `user_animation`, `target_animation`, `image`, `function`)
VALUES
	(1,'크로스 컷','전사의 기본적인 기술. 적을 두차례 벤다.','근접 공격',1,20,5,10,0,67,'050-Skill07','crossCut');

/*!40000 ALTER TABLE `setting_skill` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table setting_troop
# ------------------------------------------------------------

DROP TABLE IF EXISTS `setting_troop`;

CREATE TABLE `setting_troop` (
  `no` int(11) NOT NULL AUTO_INCREMENT,
  `name` char(255) DEFAULT NULL,
  `image` char(255) DEFAULT '001-Fighter01',
  `type` int(11) DEFAULT '0',
  `team` int(11) DEFAULT '0',
  `num` int(11) DEFAULT '1',
  `range` int(11) DEFAULT '5',
  `hp` int(11) DEFAULT '10',
  `mp` int(11) DEFAULT '10',
  `animation` int(11) DEFAULT '4',
  `damage` int(11) DEFAULT '1',
  `magic_damage` int(11) DEFAULT '1',
  `defense` int(11) DEFAULT '1',
  `magic_defense` int(11) DEFAULT '1',
  `critical` int(11) DEFAULT '10',
  `avoid` int(11) DEFAULT '50',
  `hit` int(11) DEFAULT '50',
  `move_speed` int(11) DEFAULT '20',
  `attack_speed` int(11) DEFAULT '20',
  `map` int(11) DEFAULT '1',
  `x` int(11) DEFAULT '0',
  `y` int(11) DEFAULT '0',
  `direction` int(11) DEFAULT '2',
  `regen` int(11) DEFAULT '10',
  `level` int(11) DEFAULT '1',
  `exp` int(11) DEFAULT '0',
  `gold` int(11) DEFAULT '0',
  `reward` int(11) DEFAULT NULL,
  `skill` char(255) DEFAULT NULL,
  `frequency` int(11) DEFAULT '0',
  `die` char(255) DEFAULT NULL,
  PRIMARY KEY (`no`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

LOCK TABLES `setting_troop` WRITE;
/*!40000 ALTER TABLE `setting_troop` DISABLE KEYS */;

INSERT INTO `setting_troop` (`no`, `name`, `image`, `type`, `team`, `num`, `range`, `hp`, `mp`, `animation`, `damage`, `magic_damage`, `defense`, `magic_defense`, `critical`, `avoid`, `hit`, `move_speed`, `attack_speed`, `map`, `x`, `y`, `direction`, `regen`, `level`, `exp`, `gold`, `reward`, `skill`, `frequency`, `die`)
VALUES
	(1,'다람쥐','168-Small10',4,0,1,10,10,10,4,3,1,1,1,10,50,50,5,5,2,5,5,2,30,1,10,100,1,'chipmunkSkill',50,NULL);

/*!40000 ALTER TABLE `setting_troop` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table skill
# ------------------------------------------------------------

DROP TABLE IF EXISTS `skill`;

CREATE TABLE `skill` (
  `user_no` int(11) DEFAULT NULL,
  `skill_no` int(11) DEFAULT NULL,
  `rank` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

LOCK TABLES `skill` WRITE;
/*!40000 ALTER TABLE `skill` DISABLE KEYS */;

INSERT INTO `skill` (`user_no`, `skill_no`, `rank`)
VALUES
	(1,1,1);

/*!40000 ALTER TABLE `skill` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table user
# ------------------------------------------------------------

DROP TABLE IF EXISTS `user`;

CREATE TABLE `user` (
  `no` int(11) NOT NULL AUTO_INCREMENT,
  `id` char(255) NOT NULL DEFAULT '',
  `pass` char(255) NOT NULL DEFAULT '',
  `name` char(255) NOT NULL DEFAULT '',
  `title` int(11) NOT NULL DEFAULT '0',
  `mail` char(255) NOT NULL DEFAULT '',
  `image` char(255) NOT NULL DEFAULT '001-Fighter01',
  `job` int(11) NOT NULL DEFAULT '0',
  `str` int(11) NOT NULL DEFAULT '0',
  `dex` int(11) NOT NULL DEFAULT '0',
  `agi` int(11) NOT NULL DEFAULT '0',
  `stat_point` int(11) NOT NULL DEFAULT '0',
  `skill_point` int(11) NOT NULL DEFAULT '0',
  `hp` int(11) NOT NULL DEFAULT '0',
  `mp` int(11) NOT NULL DEFAULT '0',
  `level` int(11) NOT NULL DEFAULT '1',
  `exp` int(11) NOT NULL DEFAULT '0',
  `gold` int(11) NOT NULL DEFAULT '0',
  `map` int(11) NOT NULL DEFAULT '0',
  `seed` int(11) NOT NULL DEFAULT '0',
  `x` int(11) NOT NULL DEFAULT '0',
  `y` int(11) NOT NULL DEFAULT '0',
  `direction` int(11) NOT NULL DEFAULT '2',
  `speed` int(11) NOT NULL DEFAULT '4',
  `admin` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`no`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;

INSERT INTO `user` (`no`, `id`, `pass`, `name`, `title`, `mail`, `image`, `job`, `str`, `dex`, `agi`, `stat_point`, `skill_point`, `hp`, `mp`, `level`, `exp`, `gold`, `map`, `seed`, `x`, `y`, `direction`, `speed`, `admin`)
VALUES
	(1,'1','PPAkXhcIYGcDVjdCgY/hHg==','테스트',0,'1','001-Fighter01',1,30,19,20,56,18,2451,31,6,130,10000,1,0,1,10,6,4,0),
	(2,'22','2','22',0,'2','002-Fighter02',1,0,0,0,0,0,10000,0,1,0,0,1,0,3,9,2,4,0),
	(3,'3','3','3',0,'3','004-Fighter04',2,0,0,0,0,0,0,0,1,0,0,1,0,13,7,2,4,0),
	(4,'11','1','1',0,'1','001-Fighter01',1,0,0,0,0,0,0,0,1,0,0,1,0,1,4,6,4,0),
	(5,'springday94','메롱메롱','?',0,'springday94@naver.com','002-Fighter02',1,0,0,0,0,0,0,0,1,0,0,1,0,0,0,2,4,0),
	(6,'4','4','4sdafa',0,'4sdaf','001-Fighter01',1,0,0,0,0,0,0,0,1,0,0,1,0,10,9,2,4,0),
	(7,'answp','sdafsa','asdfasdf',0,'sadfsadf','001-Fighter01',1,0,0,0,0,0,0,0,1,0,0,1,0,0,0,2,4,0),
	(8,'a','KkPhAQH4Tx5uyU3BEt3KAQ==','a',0,'a','001-Fighter01',1,11,4,0,0,3,39928,20,4,0,0,1,0,8,9,2,4,0),
	(9,'b','hqxcuUK5XT5yO4I6W1/2JQ==','b',0,'a','001-Fighter01',1,0,0,0,0,0,-90,0,1,0,0,1,0,3,6,6,4,0),
	(10,'123','PPAkXhcIYGcDVjdCgY/hHg==','1213',0,'1','001-Fighter01',1,0,0,0,0,0,0,0,1,0,0,1,0,0,0,2,4,0),
	(11,'chip','wtUrc38hNLCxbeFjlTKA1g==','???',0,'never','004-Fighter04',2,0,0,0,0,0,-27,0,1,0,0,1,0,0,0,2,4,0),
	(12,'2','gKBvNUyp+H1+LZJgpXESyA==','2',0,'2','002-Fighter02',1,0,0,0,10,2,2928,15,3,0,6300,1,0,16,12,4,4,0);

/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;



/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
