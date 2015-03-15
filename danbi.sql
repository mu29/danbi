/*
MySQL Data Transfer
Source Host: localhost
Source Database: danbi
Target Host: localhost
Target Database: danbi
Date: 2015-03-15 ���� 10:32:56
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for equip
-- ----------------------------
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

-- ----------------------------
-- Table structure for guild
-- ----------------------------
CREATE TABLE `guild` (
  `master` int(11) DEFAULT NULL,
  `guild_name` char(255) DEFAULT ''
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for guild_member
-- ----------------------------
CREATE TABLE `guild_member` (
  `guild_no` int(11) DEFAULT NULL,
  `user_no` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for item
-- ----------------------------
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

-- ----------------------------
-- Table structure for setting_item
-- ----------------------------
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
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for setting_job
-- ----------------------------
CREATE TABLE `setting_job` (
  `no` int(11) NOT NULL DEFAULT '0',
  `name` char(255) NOT NULL DEFAULT '전사',
  `hp` int(11) NOT NULL DEFAULT '0',
  `mp` int(11) NOT NULL DEFAULT '0',
  `str` int(11) NOT NULL DEFAULT '0',
  `dex` int(11) NOT NULL DEFAULT '0',
  `agi` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for setting_npc
-- ----------------------------
CREATE TABLE `setting_npc` (
  `no` int(11) DEFAULT NULL,
  `name` char(255) DEFAULT NULL,
  `image` char(255) DEFAULT NULL,
  `map` int(11) DEFAULT NULL,
  `x` int(11) DEFAULT NULL,
  `y` int(11) DEFAULT NULL,
  `direction` int(11) DEFAULT NULL,
  `function` char(255) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for setting_portal
-- ----------------------------
CREATE TABLE `setting_portal` (
  `map` int(11) DEFAULT NULL,
  `x` int(11) DEFAULT NULL,
  `y` int(11) DEFAULT NULL,
  `next_map` int(11) DEFAULT NULL,
  `next_x` int(11) DEFAULT NULL,
  `next_y` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for setting_register
-- ----------------------------
CREATE TABLE `setting_register` (
  `no` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `job` int(11) NOT NULL DEFAULT '1',
  `image` char(255) NOT NULL DEFAULT '001-Fighter01',
  `map` int(11) NOT NULL DEFAULT '0',
  `x` int(11) NOT NULL DEFAULT '0',
  `y` int(11) NOT NULL DEFAULT '0',
  `level` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`no`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for setting_reward
-- ----------------------------
CREATE TABLE `setting_reward` (
  `no` int(11) DEFAULT NULL,
  `item_no` int(11) DEFAULT NULL,
  `num` int(11) DEFAULT '1',
  `per` int(11) DEFAULT '100'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for setting_shop
-- ----------------------------
CREATE TABLE `setting_shop` (
  `no` int(11) DEFAULT NULL,
  `item_no` int(11) DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for setting_skill
-- ----------------------------
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
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for setting_troop
-- ----------------------------
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
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for skill
-- ----------------------------
CREATE TABLE `skill` (
  `user_no` int(11) DEFAULT NULL,
  `skill_no` int(11) DEFAULT NULL,
  `rank` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for user
-- ----------------------------
CREATE TABLE `user` (
  `no` int(11) NOT NULL AUTO_INCREMENT,
  `id` char(255) NOT NULL DEFAULT '',
  `pass` char(255) NOT NULL DEFAULT '',
  `name` char(255) NOT NULL DEFAULT '',
  `title` int(11) NOT NULL DEFAULT '0',
  `guild` int(11) DEFAULT '0',
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
) ENGINE=MyISAM AUTO_INCREMENT=17 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records 
-- ----------------------------
INSERT INTO `equip` VALUES ('1', '6', '0', '0', '0', '0', '0', '0');
INSERT INTO `equip` VALUES ('2', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `equip` VALUES ('3', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `equip` VALUES ('4', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `equip` VALUES ('6', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `equip` VALUES ('8', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `equip` VALUES ('9', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `equip` VALUES ('11', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `equip` VALUES ('12', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `equip` VALUES ('13', '1', '0', '0', '0', '0', '0', '0');
INSERT INTO `equip` VALUES ('15', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `equip` VALUES ('16', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `item` VALUES ('12', '1', '1', '6', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');
INSERT INTO `item` VALUES ('12', '1', '1', '5', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');
INSERT INTO `item` VALUES ('12', '1', '1', '4', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');
INSERT INTO `item` VALUES ('12', '1', '1', '3', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');
INSERT INTO `item` VALUES ('12', '8', '8', '2', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');
INSERT INTO `item` VALUES ('12', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');
INSERT INTO `item` VALUES ('1', '1', '1', '7', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');
INSERT INTO `item` VALUES ('1', '1', '1', '6', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1');
INSERT INTO `item` VALUES ('1', '1', '1', '5', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');
INSERT INTO `item` VALUES ('1', '1', '1', '4', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');
INSERT INTO `item` VALUES ('1', '1', '1', '3', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');
INSERT INTO `item` VALUES ('1', '8', '5', '2', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');
INSERT INTO `item` VALUES ('1', '1', '1', '1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');
INSERT INTO `item` VALUES ('1', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '0');
INSERT INTO `setting_item` VALUES ('1', '목도', '나무로 만든 검', '001-Weapon01', '0', '1', '0', '100', '10', '10', '10', '10', '5', '4', '3', '2', '1', '10', '5', '5', '2', '0', '1', '1', null);
INSERT INTO `setting_item` VALUES ('2', '냄비 뚜껑', '방패가 없으니 이거라도 쓰자', '009-Shield01', '0', '1', '1', '10', '0', '0', '5', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', null);
INSERT INTO `setting_item` VALUES ('3', '밀짚모자', '난 해적왕이 될 사나이!', '010-Head01', '0', '1', '2', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '1', '0', '1', '1', null);
INSERT INTO `setting_item` VALUES ('4', '쫄쫄이 잠옷', '입을 옷이 없다', '014-Body02', '0', '1', '3', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', null);
INSERT INTO `setting_item` VALUES ('5', '누더기 망토', '누가 쓰던걸까', '019-Accessory04', '0', '1', '4', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', null);
INSERT INTO `setting_item` VALUES ('6', '등산화', '아빠 등산화를 훔쳤다', '020-Accessory05', '0', '1', '5', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', null);
INSERT INTO `setting_item` VALUES ('7', '금반지', '돌잔치때 받은 금반지', '016-Accessory01', '0', '1', '6', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '1', '1', null);
INSERT INTO `setting_item` VALUES ('8', '포션', '뭐지 이 아이템은', '021-Potion01', '0', '1', '7', '100', '0', '0', '0', '0', '0', '0', '0', '10000', '0', '0', '0', '0', '0', '1', '10', '1', 'potion');
INSERT INTO `setting_job` VALUES ('1', '전사', '1000', '5', '1', '0', '0');
INSERT INTO `setting_job` VALUES ('2', '마법사', '5', '10', '0', '0', '1');
INSERT INTO `setting_job` VALUES ('3', '도적', '7', '7', '0', '1', '0');
INSERT INTO `setting_npc` VALUES ('1', '테스트', '003-Fighter03', '1', '10', '4', '2', 'testNpc');
INSERT INTO `setting_portal` VALUES ('1', '19', '8', '2', '0', '14');
INSERT INTO `setting_portal` VALUES ('2', '0', '14', '1', '19', '8');
INSERT INTO `setting_register` VALUES ('1', '1', '001-Fighter01', '1', '0', '0', '1');
INSERT INTO `setting_register` VALUES ('2', '1', '002-Fighter02', '1', '0', '0', '1');
INSERT INTO `setting_register` VALUES ('3', '2', '004-Fighter04', '1', '0', '0', '1');
INSERT INTO `setting_reward` VALUES ('1', '1', '1', '10000');
INSERT INTO `setting_reward` VALUES ('1', '8', '1', '10000');
INSERT INTO `setting_shop` VALUES ('1', '8');
INSERT INTO `setting_skill` VALUES ('1', '크로스 컷', '전사의 기본적인 기술. 적을 두차례 벤다.', '근접 공격', '1', '20', '5', '10', '0', '67', '050-Skill07', 'crossCut');
INSERT INTO `setting_troop` VALUES ('1', '다람쥐', '168-Small10', '4', '0', '10', '10', '10', '10', '4', '1', '1', '1', '1', '10', '50', '50', '5', '5', '2', '5', '5', '2', '30', '1', '10', '100', '1', 'chipmunkSkill', '50', null);
INSERT INTO `user` VALUES ('1', '1', 'PPAkXhcIYGcDVjdCgY/hHg==', '테스트', '0', '0', '1', '001-Fighter01', '1', '33', '19', '20', '68', '21', '9002', '46', '9', '800', '212000', '2', '0', '3', '11', '2', '4', '0');
INSERT INTO `user` VALUES ('2', '22', '2', '22', '0', '0', '2', '002-Fighter02', '1', '0', '0', '0', '0', '0', '10000', '0', '1', '0', '0', '1', '0', '3', '9', '2', '4', '0');
INSERT INTO `user` VALUES ('3', '3', '3', '3', '0', '0', '3', '004-Fighter04', '2', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '1', '0', '13', '7', '2', '4', '0');
INSERT INTO `user` VALUES ('4', '11', '1', '1', '0', '0', '1', '001-Fighter01', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '1', '0', '1', '4', '6', '4', '0');
INSERT INTO `user` VALUES ('5', 'springday94', '메롱메롱', '?', '0', '0', 'springday94@naver.com', '002-Fighter02', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '1', '0', '0', '0', '2', '4', '0');
INSERT INTO `user` VALUES ('6', '4', '4', '4sdafa', '0', '0', '4sdaf', '001-Fighter01', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '1', '0', '10', '9', '2', '4', '0');
INSERT INTO `user` VALUES ('7', 'answp', 'sdafsa', 'asdfasdf', '0', '0', 'sadfsadf', '001-Fighter01', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '1', '0', '0', '0', '2', '4', '0');
INSERT INTO `user` VALUES ('8', 'a', 'KkPhAQH4Tx5uyU3BEt3KAQ==', 'a', '0', '0', 'a', '001-Fighter01', '1', '11', '4', '0', '0', '3', '39928', '20', '4', '0', '0', '1', '0', '8', '9', '2', '4', '0');
INSERT INTO `user` VALUES ('9', 'b', 'hqxcuUK5XT5yO4I6W1/2JQ==', 'b', '0', '0', 'a', '001-Fighter01', '1', '0', '0', '0', '0', '0', '-90', '0', '1', '0', '0', '1', '0', '3', '6', '6', '4', '0');
INSERT INTO `user` VALUES ('10', '123', 'PPAkXhcIYGcDVjdCgY/hHg==', '1213', '0', '0', '1', '001-Fighter01', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '1', '0', '0', '0', '2', '4', '0');
INSERT INTO `user` VALUES ('11', 'chip', 'wtUrc38hNLCxbeFjlTKA1g==', '???', '0', '0', 'never', '004-Fighter04', '2', '0', '0', '0', '0', '0', '-27', '0', '1', '0', '0', '1', '0', '0', '0', '2', '4', '0');
INSERT INTO `user` VALUES ('12', '2', 'gKBvNUyp+H1+LZJgpXESyA==', '2', '0', '0', '2', '002-Fighter02', '1', '0', '0', '0', '10', '2', '2874', '15', '3', '30', '6600', '2', '0', '2', '12', '2', '4', '0');
INSERT INTO `user` VALUES ('13', 'test', 'MMobYwa4me92vrmWJTDIow==', 'test', '0', '0', 'test@co.kr', '001-Fighter01', '1', '0', '0', '0', '10', '2', '1875', '16', '3', '10', '500', '1', '0', '9', '11', '2', '4', '0');
INSERT INTO `user` VALUES ('14', '한글안되냐', 'PPAkXhcIYGcDVjdCgY/hHg==', '한글안되냐', '0', '0', '1', '001-Fighter01', '1', '0', '0', '0', '0', '0', '0', '0', '1', '0', '0', '1', '0', '0', '0', '2', '4', '0');
INSERT INTO `user` VALUES ('15', 'linja', 'A8BiSgM3VJ+dnGJ/C+st8Q==', '린자', '0', '0', 'linja0@naver.com', '001-Fighter01', '1', '0', '0', '0', '10', '2', '2991', '15', '3', '20', '0', '1', '0', '18', '8', '4', '4', '0');
INSERT INTO `user` VALUES ('16', '마니아', '3Kzn9z+j4YQPX+NoV4KkWA==', '마니아', '0', '0', 'mania@co.kr', '001-Fighter01', '1', '0', '0', '0', '5', '1', '2000', '10', '2', '0', '0', '1', '0', '13', '3', '6', '4', '0');
