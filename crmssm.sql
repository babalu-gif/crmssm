/*
Navicat MySQL Data Transfer

Source Server         : mysql
Source Server Version : 50536
Source Host           : localhost:3306
Source Database       : crmssm

Target Server Type    : MYSQL
Target Server Version : 50536
File Encoding         : 65001

Date: 2022-04-16 11:13:38
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for tbl_activity
-- ----------------------------
DROP TABLE IF EXISTS `tbl_activity`;
CREATE TABLE `tbl_activity` (
  `id` char(32) NOT NULL,
  `owner` char(32) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `start_date` char(10) DEFAULT NULL,
  `end_date` char(10) DEFAULT NULL,
  `cost` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `create_time` char(19) DEFAULT NULL,
  `create_by` varchar(255) DEFAULT NULL,
  `edit_time` char(19) DEFAULT NULL,
  `edit_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_activity
-- ----------------------------
INSERT INTO `tbl_activity` VALUES ('1e884b48db074fe5a1c1603bd7e737fa', '40f6cdea0bd34aceb77492a1656d9fb3', '吃饭', '2022-03-25', '2022-03-25', '1000', '公司聚餐', '2022-03-24 11:13:11', '张三', '2022-03-24 15:22:32', '张三');
INSERT INTO `tbl_activity` VALUES ('1ec7b501c5d9496cbd55673672952521', '40f6cdea0bd34aceb77492a1656d9fb3', '测试8', '2022-03-05', '2022-04-01', '8', '这是测试8的描述', '2022-03-24 20:45:31', '张三', null, null);
INSERT INTO `tbl_activity` VALUES ('2b5b28a04dea438abfb8be23ce3b5a95', '40f6cdea0bd34aceb77492a1656d9fb3', '测试4', '2022-03-15', '2022-03-18', '4', '这是测试4', '2022-03-22 16:28:34', '张三', null, null);
INSERT INTO `tbl_activity` VALUES ('43095fe37b8344638301705afdaed94c', '40f6cdea0bd34aceb77492a1656d9fb3', '测试7', '2022-02-27', '2022-02-28', '7', '这是测试7的描述', '2022-03-24 20:44:27', '张三', null, null);
INSERT INTO `tbl_activity` VALUES ('59ed7498718b412f9ff7b7c4d59868b0', '40f6cdea0bd34aceb77492a1656d9fb3', '测试1', '2022-02-27', '2022-04-09', '1', '这是测试1的描述', '2022-03-24 11:07:34', '张三', null, null);
INSERT INTO `tbl_activity` VALUES ('74f36d7b524b446faf9a10241a07449d', '40f6cdea0bd34aceb77492a1656d9fb3', '测试6', '2022-04-03', '2022-04-22', '6', '这是测试6的描述', '2022-03-24 20:44:08', '张三', null, null);
INSERT INTO `tbl_activity` VALUES ('847160b9a54b4660a3fca5d2adf44e19', '40f6cdea0bd34aceb77492a1656d9fb3', '发传单', '2022-03-21', '2022-03-31', '500', '发传单，每小时50。', '2022-03-24 11:12:39', '张三', null, null);
INSERT INTO `tbl_activity` VALUES ('95a2713766df4c63beaab4e762b2f735', '40f6cdea0bd34aceb77492a1656d9fb3', '吃饭1', '2022-03-25', '2022-03-25', '1000', '公司聚餐', '2022-03-26 09:28:01', '张三', null, null);
INSERT INTO `tbl_activity` VALUES ('b5f175fe5ca94507b79eb6d1b4742c79', '40f6cdea0bd34aceb77492a1656d9fb3', '测试2', '2022-03-15', '2022-03-31', '2', '这是测试2', '2022-03-22 16:23:13', '张三', null, null);
INSERT INTO `tbl_activity` VALUES ('b867ce3c7e9f44c88c8db486561a5098', '40f6cdea0bd34aceb77492a1656d9fb3', '测试9', '2022-03-04', '2022-03-05', '9', '这是测试9的描述', '2022-03-24 20:45:46', '张三', null, null);
INSERT INTO `tbl_activity` VALUES ('c0e179935e254b25a5ba2a8103175e23', '06f5fc056eac41558a964f96daa7f27c', '测试11', '2022-03-03', '2022-04-07', '11', '这是测试11的描述', '2022-03-28 10:13:59', '张三', null, null);
INSERT INTO `tbl_activity` VALUES ('ca97e710253643fc804d14da069df14e', '40f6cdea0bd34aceb77492a1656d9fb3', '测试12', '2022-02-28', '2022-03-15', '12', '这是测试12的描述', '2022-03-28 10:14:27', '张三', null, null);
INSERT INTO `tbl_activity` VALUES ('d15b55bcd4c447aebf0f4aa8462fdcca', '40f6cdea0bd34aceb77492a1656d9fb3', '测试10', '2022-03-25', '2022-03-25', '10', '这是测试10的描述', '2022-03-24 20:46:04', '张三', null, null);
INSERT INTO `tbl_activity` VALUES ('d302a91eb1d14276bd14bf43b846cdb8', '40f6cdea0bd34aceb77492a1656d9fb3', '测试5', '2022-02-28', '2022-03-27', '5', '这是测试5的描述', '2022-03-24 20:43:48', '张三', null, null);
INSERT INTO `tbl_activity` VALUES ('dd72ab90caff49f287f9abc874d717ca', '40f6cdea0bd34aceb77492a1656d9fb3', '发传单1', '2022-03-21', '2022-03-31', '500', '发传单，每小时50。', '2022-03-25 21:32:13', '张三', null, null);
INSERT INTO `tbl_activity` VALUES ('e0b43043fc42449aa6e436a99936f99a', '06f5fc056eac41558a964f96daa7f27c', '测试3', '2022-03-01', '2022-03-30', '32', '这是测试3', '2022-03-22 16:35:03', '张三', '2022-03-24 15:22:26', '张三');

-- ----------------------------
-- Table structure for tbl_activity_remark
-- ----------------------------
DROP TABLE IF EXISTS `tbl_activity_remark`;
CREATE TABLE `tbl_activity_remark` (
  `id` char(32) NOT NULL,
  `note_content` varchar(255) DEFAULT NULL,
  `create_time` char(19) DEFAULT NULL,
  `create_by` varchar(255) DEFAULT NULL,
  `edit_time` char(19) DEFAULT NULL,
  `edit_by` varchar(255) DEFAULT NULL,
  `edit_flag` char(1) DEFAULT NULL COMMENT '0��ʾδ�޸ģ�1��ʾ���޸�',
  `activity_id` char(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_activity_remark
-- ----------------------------
INSERT INTO `tbl_activity_remark` VALUES ('02ed754f4c4247e585b63ca49bdd7be1', '吃了吗', '2022-03-27 09:51:49', '张三', '2022-03-28 18:31:18', '张三', '1', '1e884b48db074fe5a1c1603bd7e737fa');
INSERT INTO `tbl_activity_remark` VALUES ('1e884b48db074fe5a1c1603bd7e737fc', '吃饭饭', '2022-03-24 20:44:46', '李四', '2022-03-28 16:52:44', '张三', '1', '1e884b48db074fe5a1c1603bd7e737fa');
INSERT INTO `tbl_activity_remark` VALUES ('8f9d90b7d99441ffa5d410d9bd60ce22', '富婆，饿饿，饭饭。', '2022-03-27 10:16:09', '张三', '', '', '0', '1e884b48db074fe5a1c1603bd7e737fa');
INSERT INTO `tbl_activity_remark` VALUES ('b3acca8236e14b1bac5966d37b13927d', 'hh1', '2022-03-31 21:21:35', '张三', '2022-04-03 10:26:37', '李四', '1', '1e884b48db074fe5a1c1603bd7e737fa');

-- ----------------------------
-- Table structure for tbl_clue
-- ----------------------------
DROP TABLE IF EXISTS `tbl_clue`;
CREATE TABLE `tbl_clue` (
  `id` char(32) NOT NULL,
  `fullname` varchar(255) DEFAULT NULL,
  `appellation` varchar(255) DEFAULT NULL,
  `owner` char(32) DEFAULT NULL,
  `company` varchar(255) DEFAULT NULL,
  `job` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  `mphone` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `source` varchar(255) DEFAULT NULL,
  `create_by` varchar(255) DEFAULT NULL,
  `create_time` char(19) DEFAULT NULL,
  `edit_by` varchar(255) DEFAULT NULL,
  `edit_time` char(19) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `contact_summary` varchar(255) DEFAULT NULL,
  `next_contact_time` char(10) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_clue
-- ----------------------------
INSERT INTO `tbl_clue` VALUES ('65c25097c8ed4a2bbd298087b146a882', '盖亚', '博士', '40f6cdea0bd34aceb77492a1656d9fb3', 'M785', '博士后', '3103656377@qq.com', '010-34567121', 'com.m785', '13598771997', '试图联系', '合作伙伴研讨会', '张三', '2022-03-27 21:18:36', null, null, '', '', '2022-03-27', 'M785星云');

-- ----------------------------
-- Table structure for tbl_clue_activity_relation
-- ----------------------------
DROP TABLE IF EXISTS `tbl_clue_activity_relation`;
CREATE TABLE `tbl_clue_activity_relation` (
  `id` char(32) NOT NULL,
  `clue_id` char(32) DEFAULT NULL,
  `activity_id` char(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_clue_activity_relation
-- ----------------------------
INSERT INTO `tbl_clue_activity_relation` VALUES ('30c0a20a4cf145479b5cfe4fa878dd82', '65c25097c8ed4a2bbd298087b146a882', '1e884b48db074fe5a1c1603bd7e737fa');
INSERT INTO `tbl_clue_activity_relation` VALUES ('ba47f33084e34074b80346363eb57c48', '', '1ec7b501c5d9496cbd55673672952521');
INSERT INTO `tbl_clue_activity_relation` VALUES ('c80ce028e163440098be99c332533d7e', '65c25097c8ed4a2bbd298087b146a882', '95a2713766df4c63beaab4e762b2f735');

-- ----------------------------
-- Table structure for tbl_clue_activity_relation_copy
-- ----------------------------
DROP TABLE IF EXISTS `tbl_clue_activity_relation_copy`;
CREATE TABLE `tbl_clue_activity_relation_copy` (
  `id` char(32) NOT NULL,
  `clue_id` char(32) DEFAULT NULL,
  `activity_id` char(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_clue_activity_relation_copy
-- ----------------------------
INSERT INTO `tbl_clue_activity_relation_copy` VALUES ('02ed754f4c4247e585b63ca49bdd7b12', '02ed754f4c4247e585b63ca49bdd7be2', '847160b9a54b4660a3fca5d2adf44e19');
INSERT INTO `tbl_clue_activity_relation_copy` VALUES ('1e884b48db074fe5a1c1603bd7e73712', '02ed754f4c4247e585b63ca49bdd7be2', '1e884b48db074fe5a1c1603bd7e737fa');

-- ----------------------------
-- Table structure for tbl_clue_remark
-- ----------------------------
DROP TABLE IF EXISTS `tbl_clue_remark`;
CREATE TABLE `tbl_clue_remark` (
  `id` char(32) NOT NULL,
  `note_content` varchar(255) DEFAULT NULL,
  `create_by` varchar(255) DEFAULT NULL,
  `create_time` char(19) DEFAULT NULL,
  `edit_by` varchar(255) DEFAULT NULL,
  `edit_time` char(19) DEFAULT NULL,
  `edit_flag` char(1) DEFAULT NULL,
  `clue_id` char(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_clue_remark
-- ----------------------------
INSERT INTO `tbl_clue_remark` VALUES ('65c25097c8ed4a2bbd298087b146a883', '盖亚！！！', '张三', '2022-03-24 11:13:1', null, null, '0', '65c25097c8ed4a2bbd298087b146a882');
INSERT INTO `tbl_clue_remark` VALUES ('65c25097c8ed4a2bbd298087b146a884', 'yyds', '张三', '2022-03-24 11:13:12', '张三', '2022-03-24 11:14:12', '1', '65c25097c8ed4a2bbd298087b146a882');
INSERT INTO `tbl_clue_remark` VALUES ('bf250a1cf8344385bafad77470c7c9c1', '嘿嘿嘿', '张三', '2022-03-28 16:23:36', null, null, '0', '65c25097c8ed4a2bbd298087b146a882');

-- ----------------------------
-- Table structure for tbl_contacts
-- ----------------------------
DROP TABLE IF EXISTS `tbl_contacts`;
CREATE TABLE `tbl_contacts` (
  `id` char(32) NOT NULL,
  `owner` char(32) DEFAULT NULL,
  `source` varchar(255) DEFAULT NULL,
  `customer_id` char(32) DEFAULT NULL,
  `fullname` varchar(255) DEFAULT NULL,
  `appellation` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `mphone` varchar(255) DEFAULT NULL,
  `job` varchar(255) DEFAULT NULL,
  `create_by` varchar(255) DEFAULT NULL,
  `create_time` char(19) DEFAULT NULL,
  `edit_by` varchar(255) DEFAULT NULL,
  `edit_time` char(19) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `contact_summary` varchar(255) DEFAULT NULL,
  `next_contact_time` char(10) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_contacts
-- ----------------------------
INSERT INTO `tbl_contacts` VALUES ('179658350d924d23bff11deb8532eafe', '40f6cdea0bd34aceb77492a1656d9fb3', '广告', '793a9d03a7924d66baffe9be380480e4', 'ewrert', '先生', '3194244910@qq.com', '13598771997', 'CTO', '张三', '2022-04-10 10:46:47', null, null, '', '', '2022-05-06', '324534');
INSERT INTO `tbl_contacts` VALUES ('25b4ea26ab074501ba0cbdffcab62c99', '40f6cdea0bd34aceb77492a1656d9fb3', '广告', 'c86765cc1c52407599ba715de6254b11', '桃夭', '女士', '3103656377@qq.com', '12345678910', '花瓶', '张三', '2022-04-01 09:41:31', null, null, '洛克十二花神之一', '三月花神', '2022-03-31', '洛克王国');
INSERT INTO `tbl_contacts` VALUES ('7d95cff88986410983f40058cb103642', '06f5fc056eac41558a964f96daa7f27c', '交易会', '793a9d03a7924d66baffe9be380480e4', '闫玉如', '女士', '3103656377@qq.com', '13598771997', 'のerew', '张三', '2022-04-01 10:03:05', null, null, '', '', '2022-05-07', '345');
INSERT INTO `tbl_contacts` VALUES ('86ccc4aa924744cd813dde8606354956', '40f6cdea0bd34aceb77492a1656d9fb3', '聊天', '63d02c4d9e7b48039bb13d22c955a9ec', '天天', '夫人', '3194244901@qq.com', '13598871197', '', '张三', '2022-04-08 19:58:47', '张三', '2022-04-09 17:13:59', '', '天猫测试', '2022-05-06', '天猫');
INSERT INTO `tbl_contacts` VALUES ('90ed7557a64846fd916f83efcc5c9730', '40f6cdea0bd34aceb77492a1656d9fb3', '交易会', '793a9d03a7924d66baffe9be380480e4', '单于', '博士', '3194244910@qq.com', '13598771997', '', '张三', '2022-04-10 10:54:50', '张三', '2022-04-10 12:01:27', '', '', '2022-05-06', '而儿童1');
INSERT INTO `tbl_contacts` VALUES ('a809328f5ab54a8aa8fc4c86b0e1c15f', '40f6cdea0bd34aceb77492a1656d9fb3', '交易会', 'e921401bf1104aae979a5dc6cdc38ebe', '美狄亚', '夫人', '3103656377@qq.com', '13598771997', '仓库管理员', '张三', '2022-03-31 15:55:52', '张三', '2022-04-09 17:07:01', '宠物', '美羊羊', '2022-03-31', '洛克王国');
INSERT INTO `tbl_contacts` VALUES ('c54c918a56f546528ebf2917e2244e99', '06f5fc056eac41558a964f96daa7f27c', '交易会', '793a9d03a7924d66baffe9be380480e4', 'hhh怪', '博士', '3194244910@qq.com', '13598771997', '', '张三', '2022-04-10 11:28:34', '张三', '2022-04-10 12:09:02', '1ewrwe', 'erwr', '2022-05-07', 'dfsd1');
INSERT INTO `tbl_contacts` VALUES ('e5d755801a6e4344992fb97e915ccd70', '40f6cdea0bd34aceb77492a1656d9fb3', '合作伙伴', '793a9d03a7924d66baffe9be380480e4', '京东数科', '博士', '3194244910@qq.com', '13598771997', '', '张三', '2022-04-10 11:11:27', null, null, '', '', '2022-05-06', 'ewrwe');

-- ----------------------------
-- Table structure for tbl_contacts_activity_relation
-- ----------------------------
DROP TABLE IF EXISTS `tbl_contacts_activity_relation`;
CREATE TABLE `tbl_contacts_activity_relation` (
  `id` char(32) NOT NULL,
  `contacts_id` char(32) DEFAULT NULL,
  `activity_id` char(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_contacts_activity_relation
-- ----------------------------
INSERT INTO `tbl_contacts_activity_relation` VALUES ('019822647c834d2db0393fba4ac4e641', '7d95cff88986410983f40058cb103642', '2b5b28a04dea438abfb8be23ce3b5a95');
INSERT INTO `tbl_contacts_activity_relation` VALUES ('0352fd0fdaca43639173e7c793e80192', 'e5d755801a6e4344992fb97e915ccd70', '1e884b48db074fe5a1c1603bd7e737fa');
INSERT INTO `tbl_contacts_activity_relation` VALUES ('09011105f52b480198e93ceb1b718b36', '25b4ea26ab074501ba0cbdffcab62c99', 'e0b43043fc42449aa6e436a99936f99a');
INSERT INTO `tbl_contacts_activity_relation` VALUES ('141b3134c5984456ac1112e56235e71e', '25b4ea26ab074501ba0cbdffcab62c99', '2b5b28a04dea438abfb8be23ce3b5a95');
INSERT INTO `tbl_contacts_activity_relation` VALUES ('1d6a049230014d76bd23d15658cf1e0d', '25b4ea26ab074501ba0cbdffcab62c99', 'd302a91eb1d14276bd14bf43b846cdb8');
INSERT INTO `tbl_contacts_activity_relation` VALUES ('4d57dcf18ff44d62a2a7c8184f5e3a93', 'a809328f5ab54a8aa8fc4c86b0e1c15f', '59ed7498718b412f9ff7b7c4d59868b0');
INSERT INTO `tbl_contacts_activity_relation` VALUES ('554d0a8a5a424611aa8a352b68b13902', '25b4ea26ab074501ba0cbdffcab62c99', '59ed7498718b412f9ff7b7c4d59868b0');
INSERT INTO `tbl_contacts_activity_relation` VALUES ('79eb3c5f4a684330a2054edfb9d88518', 'c95223c8f3c94ee3a5fe5246a9c7c899', 'b5f175fe5ca94507b79eb6d1b4742c79');
INSERT INTO `tbl_contacts_activity_relation` VALUES ('89d0e3ea68bc420593ceb8989d4a62dd', '7d95cff88986410983f40058cb103642', '95a2713766df4c63beaab4e762b2f735');
INSERT INTO `tbl_contacts_activity_relation` VALUES ('8b4a4bd99c324a6789b71cacc6235f0b', '25b4ea26ab074501ba0cbdffcab62c99', '1e884b48db074fe5a1c1603bd7e737fa');
INSERT INTO `tbl_contacts_activity_relation` VALUES ('c71699b4610a47d9b10680795127e6ff', '25b4ea26ab074501ba0cbdffcab62c99', 'b5f175fe5ca94507b79eb6d1b4742c79');
INSERT INTO `tbl_contacts_activity_relation` VALUES ('d34fe2c65dcc4b428deb78c054abdb92', 'a809328f5ab54a8aa8fc4c86b0e1c15f', '847160b9a54b4660a3fca5d2adf44e19');
INSERT INTO `tbl_contacts_activity_relation` VALUES ('d41ca54feb5b49da9e5b8e130e0c8d06', 'a809328f5ab54a8aa8fc4c86b0e1c15f', '1e884b48db074fe5a1c1603bd7e737fa');
INSERT INTO `tbl_contacts_activity_relation` VALUES ('d72f2c80f041446a9679d41f394d1f7f', '7d95cff88986410983f40058cb103642', '1e884b48db074fe5a1c1603bd7e737fa');
INSERT INTO `tbl_contacts_activity_relation` VALUES ('e501661c6d944300a5af4b42ee6c8a95', 'e5d755801a6e4344992fb97e915ccd70', '95a2713766df4c63beaab4e762b2f735');
INSERT INTO `tbl_contacts_activity_relation` VALUES ('fa0f3c5d76094ab1b85aa1ef3968c672', 'c95223c8f3c94ee3a5fe5246a9c7c899', '59ed7498718b412f9ff7b7c4d59868b0');

-- ----------------------------
-- Table structure for tbl_contacts_remark
-- ----------------------------
DROP TABLE IF EXISTS `tbl_contacts_remark`;
CREATE TABLE `tbl_contacts_remark` (
  `id` char(32) NOT NULL,
  `note_content` varchar(255) DEFAULT NULL,
  `create_by` varchar(255) DEFAULT NULL,
  `create_time` char(19) DEFAULT NULL,
  `edit_by` varchar(255) DEFAULT NULL,
  `edit_time` char(19) DEFAULT NULL,
  `edit_flag` char(1) DEFAULT NULL,
  `contacts_id` char(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_contacts_remark
-- ----------------------------
INSERT INTO `tbl_contacts_remark` VALUES ('3677521c6364403da382c60fd03ff673', '美羊羊好！', '张三', '2022-03-31 15:55:52', null, null, '0', 'a809328f5ab54a8aa8fc4c86b0e1c15f');
INSERT INTO `tbl_contacts_remark` VALUES ('4663083c91994f55912e802415d55007', '黑什么？', '张三', '2022-03-31 15:55:52', null, null, '0', 'a809328f5ab54a8aa8fc4c86b0e1c15f');
INSERT INTO `tbl_contacts_remark` VALUES ('952f848045044ff4a63387559d08a3c9', '这是啥', '张三', '2022-04-10 15:35:03', '张三', '2022-04-10 15:44:22', '1', 'e5d755801a6e4344992fb97e915ccd70');
INSERT INTO `tbl_contacts_remark` VALUES ('b117e3fceb8d4920a6f6f85723a4f592', 'O(∩_∩)O哈哈~', '张三', '2022-04-10 15:32:44', null, null, '0', 'e5d755801a6e4344992fb97e915ccd70');
INSERT INTO `tbl_contacts_remark` VALUES ('ff896a509d1e4862b09d0d438ddbacbb', 'test1', '张三', '2022-04-10 15:49:08', '张三', '2022-04-10 15:54:17', '1', 'e5d755801a6e4344992fb97e915ccd70');

-- ----------------------------
-- Table structure for tbl_customer
-- ----------------------------
DROP TABLE IF EXISTS `tbl_customer`;
CREATE TABLE `tbl_customer` (
  `id` char(32) NOT NULL,
  `owner` char(32) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `create_by` varchar(255) DEFAULT NULL,
  `create_time` char(19) DEFAULT NULL,
  `edit_by` varchar(255) DEFAULT NULL,
  `edit_time` char(19) DEFAULT NULL,
  `contact_summary` varchar(255) DEFAULT NULL,
  `next_contact_time` char(10) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_customer
-- ----------------------------
INSERT INTO `tbl_customer` VALUES ('63d02c4d9e7b48039bb13d22c955a9ec', '40f6cdea0bd34aceb77492a1656d9fb3', '天猫', null, null, '张三', '2022-04-09 17:13:59', null, null, null, null, null, null);
INSERT INTO `tbl_customer` VALUES ('793a9d03a7924d66baffe9be380480e4', '06f5fc056eac41558a964f96daa7f27c', '黑马', 'http://www.baidu.com', '010-4546591', '张三', '2022-04-01 10:03:05', '张三', '2022-04-10 11:48:26', 'eeee1', '2022-06-04', 'eeeeh', '3451');
INSERT INTO `tbl_customer` VALUES ('948dd4a0cadd4067b69cc3231f5031de', '40f6cdea0bd34aceb77492a1656d9fb3', '京东', 'https://www.jd.com/', '010-4546361', '张三', '2022-04-08 19:58:47', '张三', '2022-04-08 20:00:03', '', '2022-05-06', '', 'dasd');
INSERT INTO `tbl_customer` VALUES ('c86765cc1c52407599ba715de6254b11', '40f6cdea0bd34aceb77492a1656d9fb3', '动力节点', 'http://www.bjpowernode.com', '010-84846010', '张三', '2022-04-01 09:41:31', null, null, '三月花神', '2022-03-31', '洛克十二花神之一', '洛克王国');
INSERT INTO `tbl_customer` VALUES ('e921401bf1104aae979a5dc6cdc38ebe', '40f6cdea0bd34aceb77492a1656d9fb3', '阿里巴巴', 'http://www.bjpowernode.com', '010-84846003', '张三', '2022-03-31 15:55:52', null, null, '美羊羊', '2022-03-31', '宠物', '洛克王国');

-- ----------------------------
-- Table structure for tbl_customer_remark
-- ----------------------------
DROP TABLE IF EXISTS `tbl_customer_remark`;
CREATE TABLE `tbl_customer_remark` (
  `id` char(32) NOT NULL,
  `note_content` varchar(255) DEFAULT NULL,
  `create_by` varchar(255) DEFAULT NULL,
  `create_time` char(19) DEFAULT NULL,
  `edit_by` varchar(255) DEFAULT NULL,
  `edit_time` char(19) DEFAULT NULL,
  `edit_flag` char(1) DEFAULT NULL,
  `customer_id` char(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_customer_remark
-- ----------------------------
INSERT INTO `tbl_customer_remark` VALUES ('9247bd9ecd014a198e6e4619d7af7061', 'hh', '张三', '2022-04-10 10:17:03', null, null, '0', '793a9d03a7924d66baffe9be380480e4');
INSERT INTO `tbl_customer_remark` VALUES ('9cabf64f9a5543739870c9558f881e54', '美羊羊好！', '张三', '2022-03-31 15:55:52', '张三', '2022-04-07 16:56:57', '1', 'e921401bf1104aae979a5dc6cdc38ebe');

-- ----------------------------
-- Table structure for tbl_dic_type
-- ----------------------------
DROP TABLE IF EXISTS `tbl_dic_type`;
CREATE TABLE `tbl_dic_type` (
  `code` varchar(255) NOT NULL COMMENT '����������������Ϊ�գ����ܺ������ġ�',
  `name` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_dic_type
-- ----------------------------
INSERT INTO `tbl_dic_type` VALUES ('appellation', '称呼', null);
INSERT INTO `tbl_dic_type` VALUES ('clueState', '线索状态', null);
INSERT INTO `tbl_dic_type` VALUES ('returnPriority', '回访优先级', null);
INSERT INTO `tbl_dic_type` VALUES ('returnState', '回访状态', null);
INSERT INTO `tbl_dic_type` VALUES ('source', '来源', null);
INSERT INTO `tbl_dic_type` VALUES ('stage', '阶段', null);
INSERT INTO `tbl_dic_type` VALUES ('transactionType', '交易类型', null);

-- ----------------------------
-- Table structure for tbl_dic_value
-- ----------------------------
DROP TABLE IF EXISTS `tbl_dic_value`;
CREATE TABLE `tbl_dic_value` (
  `id` char(32) NOT NULL COMMENT '����������UUID',
  `value` varchar(255) DEFAULT NULL COMMENT '����Ϊ�գ�����Ҫ��ͬһ���ֵ��������ֵ�ֵ�����ظ�������Ψһ�ԡ�',
  `text` varchar(255) DEFAULT NULL COMMENT '����Ϊ��',
  `order_no` varchar(255) DEFAULT NULL COMMENT '����Ϊ�գ�����Ϊ�յ�ʱ��Ҫ�������������',
  `type_code` varchar(255) DEFAULT NULL COMMENT '���',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_dic_value
-- ----------------------------
INSERT INTO `tbl_dic_value` VALUES ('06e3cbdf10a44eca8511dddfc6896c55', '虚假线索', '虚假线索', '4', 'clueState');
INSERT INTO `tbl_dic_value` VALUES ('0fe33840c6d84bf78df55d49b169a894', '销售邮件', '销售邮件', '8', 'source');
INSERT INTO `tbl_dic_value` VALUES ('12302fd42bd349c1bb768b19600e6b20', '交易会', '交易会', '11', 'source');
INSERT INTO `tbl_dic_value` VALUES ('1615f0bb3e604552a86cde9a2ad45bea', '最高', '最高', '2', 'returnPriority');
INSERT INTO `tbl_dic_value` VALUES ('176039d2a90e4b1a81c5ab8707268636', '教授', '教授', '5', 'appellation');
INSERT INTO `tbl_dic_value` VALUES ('1e0bd307e6ee425599327447f8387285', '将来联系', '将来联系', '2', 'clueState');
INSERT INTO `tbl_dic_value` VALUES ('2173663b40b949ce928db92607b5fe57', '丢失线索', '丢失线索', '5', 'clueState');
INSERT INTO `tbl_dic_value` VALUES ('2876690b7e744333b7f1867102f91153', '未启动', '未启动', '1', 'returnState');
INSERT INTO `tbl_dic_value` VALUES ('29805c804dd94974b568cfc9017b2e4c', '成交', '成交', '7', 'stage');
INSERT INTO `tbl_dic_value` VALUES ('310e6a49bd8a4962b3f95a1d92eb76f4', '试图联系', '试图联系', '1', 'clueState');
INSERT INTO `tbl_dic_value` VALUES ('31539e7ed8c848fc913e1c2c93d76fd1', '博士', '博士', '4', 'appellation');
INSERT INTO `tbl_dic_value` VALUES ('31539e7ed8c848fc913e1c2c93d76fd2', '需求分析', '需求分析', '2', 'stage');
INSERT INTO `tbl_dic_value` VALUES ('31539e7ed8c848fc913e1c2c93d76fd3', '价值建议', '价值建议', '3', 'stage');
INSERT INTO `tbl_dic_value` VALUES ('31539e7ed8c848fc913e1c2c93d76fd4', '确定决策者', '确定决策者', '4', 'stage');
INSERT INTO `tbl_dic_value` VALUES ('31539e7ed8c848fc913e1c2c93d76fd5', '提案/报价', '提案/报价', '5', 'stage');
INSERT INTO `tbl_dic_value` VALUES ('31539e7ed8c848fc913e1c2c93d76fd6', '谈判/复审', '谈判/复审', '6', 'stage');
INSERT INTO `tbl_dic_value` VALUES ('37ef211719134b009e10b7108194cf46', '资质审查', '资质审查', '1', 'stage');
INSERT INTO `tbl_dic_value` VALUES ('391807b5324d4f16bd58c882750ee632', '丢失的线索', '丢失的线索', '8', 'stage');
INSERT INTO `tbl_dic_value` VALUES ('3a39605d67da48f2a3ef52e19d243953', '聊天', '聊天', '14', 'source');
INSERT INTO `tbl_dic_value` VALUES ('474ab93e2e114816abf3ffc596b19131', '低', '低', '3', 'returnPriority');
INSERT INTO `tbl_dic_value` VALUES ('48512bfed26145d4a38d3616e2d2cf79', '广告', '广告', '1', 'source');
INSERT INTO `tbl_dic_value` VALUES ('4d03a42898684135809d380597ed3268', '合作伙伴研讨会', '合作伙伴研讨会', '9', 'source');
INSERT INTO `tbl_dic_value` VALUES ('59795c49896947e1ab61b7312bd0597c', '先生', '先生', '1', 'appellation');
INSERT INTO `tbl_dic_value` VALUES ('5c6e9e10ca414bd499c07b886f86202a', '高', '高', '1', 'returnPriority');
INSERT INTO `tbl_dic_value` VALUES ('67165c27076e4c8599f42de57850e39c', '夫人', '夫人', '2', 'appellation');
INSERT INTO `tbl_dic_value` VALUES ('68a1b1e814d5497a999b8f1298ace62b', '因竞争丢失关闭', '因竞争丢失关闭', '9', 'stage');
INSERT INTO `tbl_dic_value` VALUES ('6b86f215e69f4dbd8a2daa22efccf0cf', 'web调研', 'web调研', '13', 'source');
INSERT INTO `tbl_dic_value` VALUES ('72f13af8f5d34134b5b3f42c5d477510', '合作伙伴', '合作伙伴', '6', 'source');
INSERT INTO `tbl_dic_value` VALUES ('7c07db3146794c60bf975749952176df', '未联系', '未联系', '6', 'clueState');
INSERT INTO `tbl_dic_value` VALUES ('86c56aca9eef49058145ec20d5466c17', '内部研讨会', '内部研讨会', '10', 'source');
INSERT INTO `tbl_dic_value` VALUES ('86c56aca9eef49058145ec20d5466c89', '女士', '女士', '3', 'appellation');
INSERT INTO `tbl_dic_value` VALUES ('9095bda1f9c34f098d5b92fb870eba17', '进行中', '进行中', '3', 'returnState');
INSERT INTO `tbl_dic_value` VALUES ('9095bda1f9c34f098d5b92fb870eba18', '新业务', '新业务', '1', 'transactionType');
INSERT INTO `tbl_dic_value` VALUES ('9095bda1f9c34f098d5b92fb870eba19', '已有业务', '已有业务', '2', 'transactionType');

-- ----------------------------
-- Table structure for tbl_tran
-- ----------------------------
DROP TABLE IF EXISTS `tbl_tran`;
CREATE TABLE `tbl_tran` (
  `id` char(32) NOT NULL,
  `owner` char(32) DEFAULT NULL,
  `money` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `expected_date` char(10) DEFAULT NULL,
  `customer_id` char(32) DEFAULT NULL,
  `stage` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `source` varchar(255) DEFAULT NULL,
  `activity_id` char(32) DEFAULT NULL,
  `contacts_id` char(32) DEFAULT NULL,
  `create_by` varchar(255) DEFAULT NULL,
  `create_time` char(19) DEFAULT NULL,
  `edit_by` varchar(255) DEFAULT NULL,
  `edit_time` char(19) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `contact_summary` varchar(255) DEFAULT NULL,
  `next_contact_time` char(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_tran
-- ----------------------------
INSERT INTO `tbl_tran` VALUES ('829cc5cfdba44ce2a2360ce48edad099', '40f6cdea0bd34aceb77492a1656d9fb3', '12321', '阿里巴巴-测试1', '2022-04-05', 'e921401bf1104aae979a5dc6cdc38ebe', '31539e7ed8c848fc913e1c2c93d76fd5', '新业务', '广告', '1ec7b501c5d9496cbd55673672952521', '25b4ea26ab074501ba0cbdffcab62c99', '张三', '2022-04-08 10:02:09', '张三', '2022-04-08 11:19:11', '', '', '2022-04-22');
INSERT INTO `tbl_tran` VALUES ('baeac8756d28451284a0a5dbea91bc11', '40f6cdea0bd34aceb77492a1656d9fb3', '200', '黑马-测试1', '2022-04-27', '793a9d03a7924d66baffe9be380480e4', '31539e7ed8c848fc913e1c2c93d76fd5', '已有业务', '广告', '1e884b48db074fe5a1c1603bd7e737fa', '25b4ea26ab074501ba0cbdffcab62c99', '张三', '2022-04-08 15:42:37', null, null, '', '', '2022-04-22');

-- ----------------------------
-- Table structure for tbl_tran_history
-- ----------------------------
DROP TABLE IF EXISTS `tbl_tran_history`;
CREATE TABLE `tbl_tran_history` (
  `id` char(32) NOT NULL,
  `stage` varchar(255) DEFAULT NULL,
  `money` varchar(255) DEFAULT NULL,
  `expected_date` char(10) DEFAULT NULL,
  `create_time` char(19) DEFAULT NULL,
  `create_by` varchar(255) DEFAULT NULL,
  `tran_id` char(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_tran_history
-- ----------------------------
INSERT INTO `tbl_tran_history` VALUES ('025c3dbc63b64be9a39bcfabb2db5695', '31539e7ed8c848fc913e1c2c93d76fd4', '12321', '2022-04-05', '2022-04-08 10:02:09', '张三', '829cc5cfdba44ce2a2360ce48edad099');
INSERT INTO `tbl_tran_history` VALUES ('1b263e13dcad40828e47a26727baf34a', '31539e7ed8c848fc913e1c2c93d76fd5', '200', '2022-04-27', '2022-04-08 15:42:37', '张三', 'baeac8756d28451284a0a5dbea91bc11');
INSERT INTO `tbl_tran_history` VALUES ('6417f6b943214e16bd03b96b5a5ef8be', '31539e7ed8c848fc913e1c2c93d76fd3', '1000', '2022-04-12', '2022-04-08 15:39:47', '张三', '685a8670ff814bd1bd921a7f8c76de21');
INSERT INTO `tbl_tran_history` VALUES ('6bda0b9e87944995b6a98076a9cb9260', '31539e7ed8c848fc913e1c2c93d76fd3', '2000', '2022-04-04', '2022-04-08 21:37:42', '张三', 'dee0c546fa744462b1d081b1ec0446dc');
INSERT INTO `tbl_tran_history` VALUES ('971924c2d2d846f0bd89fbfd8d6fe2e4', '31539e7ed8c848fc913e1c2c93d76fd2', '12', '2022-03-28', '2022-04-08 09:21:10', '张三', '8e5dbcc48a914f919b87303eedf242e8');
INSERT INTO `tbl_tran_history` VALUES ('b51987291c144e11972be8730be2b0f0', '31539e7ed8c848fc913e1c2c93d76fd2', '4000', '2022-04-08', '2022-04-08 15:41:03', '张三', '80e35174d9874b70ada9b0b367fdef2e');
INSERT INTO `tbl_tran_history` VALUES ('c1adc77a8e3242e895b5a33969bcb1ca', '31539e7ed8c848fc913e1c2c93d76fd5', '12321', '2022-04-05', '2022-04-08 11:19:11', '张三', '829cc5cfdba44ce2a2360ce48edad099');
INSERT INTO `tbl_tran_history` VALUES ('df5ceded0d194433b9b7fd1512162c54', '31539e7ed8c848fc913e1c2c93d76fd4', '50000', '2022-04-12', '2022-04-08 15:40:28', '张三', 'ce710936774541f9b9821a1eeed7c260');
INSERT INTO `tbl_tran_history` VALUES ('e381c5d2ae524eb4a300520a955aede7', '31539e7ed8c848fc913e1c2c93d76fd2', '120', '2022-03-28', '2022-04-08 11:24:04', '张三', '8e5dbcc48a914f919b87303eedf242e8');

-- ----------------------------
-- Table structure for tbl_tran_remark
-- ----------------------------
DROP TABLE IF EXISTS `tbl_tran_remark`;
CREATE TABLE `tbl_tran_remark` (
  `id` char(32) NOT NULL,
  `note_content` varchar(255) DEFAULT NULL,
  `create_by` varchar(255) DEFAULT NULL,
  `create_time` char(19) DEFAULT NULL,
  `edit_by` varchar(255) DEFAULT NULL,
  `edit_time` char(19) DEFAULT NULL,
  `edit_flag` char(1) DEFAULT NULL,
  `tran_id` char(32) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_tran_remark
-- ----------------------------

-- ----------------------------
-- Table structure for tbl_user
-- ----------------------------
DROP TABLE IF EXISTS `tbl_user`;
CREATE TABLE `tbl_user` (
  `id` char(32) NOT NULL COMMENT 'uuid\r\n            ',
  `login_act` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `login_pwd` varchar(255) DEFAULT NULL COMMENT '密码不能采用明文存储，采用密文，MD5加密之后的数据',
  `email` varchar(255) DEFAULT NULL,
  `expire_time` char(19) DEFAULT NULL COMMENT '失效时间为空的时候表示永不失效，失效时间为2018-10-10 10:10:10，则表示在该时间之前该账户可用。',
  `lock_state` char(1) DEFAULT NULL COMMENT '锁定状态为空时表示启用，为0时表示锁定，为1时表示启用。',
  `deptno` char(4) DEFAULT NULL,
  `allow_ips` varchar(255) DEFAULT NULL COMMENT '允许访问的IP为空时表示IP地址永不受限，允许访问的IP可以是一个，也可以是多个，当多个IP地址的时候，采用半角逗号分隔。允许IP是192.168.100.2，表示该用户只能在IP地址为192.168.100.2的机器上使用。',
  `createTime` char(19) DEFAULT NULL,
  `create_by` varchar(255) DEFAULT NULL,
  `edit_time` char(19) DEFAULT NULL,
  `edit_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tbl_user
-- ----------------------------
INSERT INTO `tbl_user` VALUES ('06f5fc056eac41558a964f96daa7f27c', 'ls', '李四', '123', 'ls@163.com', '2022-11-30 23:50:55', '1', 'A001', '192.168.1.1,0:0:0:0:0:0:0:1', '2018-11-22 12:11:40', '李四', null, null);
INSERT INTO `tbl_user` VALUES ('40f6cdea0bd34aceb77492a1656d9fb3', 'zs', '张三', '111', 'zs@qq.com', '2022-11-30 23:50:55', '1', 'A001', '192.168.1.1,192.168.1.2,127.0.0.1,0:0:0:0:0:0:0:1', '2018-11-22 11:37:34', '张三', null, null);
