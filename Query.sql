-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: localhost    Database: campus_headline
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `campus_headline`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `campus_headline` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `campus_headline`;

--
-- Table structure for table `comment`
--

DROP TABLE IF EXISTS `comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comment` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键',
  `news_id` int NOT NULL COMMENT '目标实体ID（配合 target_type 判定实体类型）',
  `user_id` int NOT NULL COMMENT '评论者ID（外键，关联 user.id）',
  `content` varchar(500) NOT NULL COMMENT '评论内容',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '评论时间',
  `target_type` varchar(20) NOT NULL DEFAULT 'news' COMMENT 'NEWS/VIDEO/TOPIC',
  PRIMARY KEY (`id`),
  KEY `idx_comment_news` (`news_id`),
  KEY `idx_comment_user` (`user_id`),
  CONSTRAINT `fk_comment_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comment`
--

LOCK TABLES `comment` WRITE;
/*!40000 ALTER TABLE `comment` DISABLE KEYS */;
INSERT INTO `comment` VALUES (1,1,2,'运动会报名已经截止了吗？还想参加接力赛。','2026-10-26 19:41:30','news'),(3,2,2,'这次分享会很有收获，期待下次活动。','2026-10-26 19:41:30','news'),(10,4,4,'很美妙的歌声，冠军实至名归','2026-10-27 21:26:12','news'),(11,15,4,'哇，听到这首歌，感觉一下子就回到了童年','2026-10-27 21:27:45','video');
/*!40000 ALTER TABLE `comment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `material`
--

DROP TABLE IF EXISTS `material`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `material` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键',
  `file_name` varchar(200) NOT NULL COMMENT '原始文件名',
  `file_path` varchar(500) NOT NULL COMMENT '实际存储路径',
  `file_size` bigint DEFAULT NULL COMMENT '文件大小(字节)',
  `file_type` varchar(50) DEFAULT NULL COMMENT '文件类型(image/video/doc)',
  `upload_user_id` int DEFAULT NULL COMMENT '上传者ID（外键，关联 user.id）',
  `upload_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '上传时间',
  PRIMARY KEY (`id`),
  KEY `idx_material_upload_user` (`upload_user_id`),
  CONSTRAINT `fk_material_upload_user` FOREIGN KEY (`upload_user_id`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `material`
--

LOCK TABLES `material` WRITE;
/*!40000 ALTER TABLE `material` DISABLE KEYS */;
INSERT INTO `material` VALUES (6,'test1.mp4','/upload/e62bc05f0d984e7a8fb632be2b1a295f.mp4',19964859,'video',1,'2026-10-27 20:40:13'),(7,'test2.mp4','/upload/26e5af00e8a84017943601b9ebd28c5a.mp4',4427072,'video',1,'2026-10-27 20:47:23'),(8,'test3.mp4','/upload/351e1997069a4c4e9db0c1166ec5f765.mp4',4746655,'video',1,'2026-10-27 20:49:35'),(9,'test5.mp4','/upload/e3a9852257574f3bbb056a2c6094f569.mp4',50802260,'video',1,'2026-10-27 21:09:45'),(10,'test4.mp4','/upload/bc3b1df09dda4000b1352c670a62263a.mp4',9186999,'video',1,'2026-10-27 21:14:45');
/*!40000 ALTER TABLE `material` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `news`
--

DROP TABLE IF EXISTS `news`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `news` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键',
  `title` varchar(200) NOT NULL COMMENT '新闻标题',
  `content` text NOT NULL COMMENT '新闻内容',
  `author` varchar(50) NOT NULL COMMENT '作者',
  `user_id` int DEFAULT NULL,
  `category` varchar(50) DEFAULT NULL COMMENT '新闻分类',
  `views` int DEFAULT '0' COMMENT '浏览量',
  `status` tinyint DEFAULT '0' COMMENT '状态 0草稿 1已发布 2已审核 3已驳回',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '发布时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `cover` varchar(500) DEFAULT NULL COMMENT '封面图路径',
  PRIMARY KEY (`id`),
  KEY `idx_news_user` (`user_id`),
  CONSTRAINT `fk_news_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `news`
--

LOCK TABLES `news` WRITE;
/*!40000 ALTER TABLE `news` DISABLE KEYS */;
INSERT INTO `news` VALUES (1,'学校2026秋季运动会通知','定于11月10日举办秋季运动会，请各班积极报名参加。报名截止日期11月5日。竞赛项目包括田径、篮球、足球等。','教务处',NULL,'校园通知',341,2,'2026-10-26 19:41:30','2026-10-29 20:00:43',NULL),(2,'校园读书分享会圆满结束','本次读书活动吸引200多名同学参与，共分享书籍50余本，同学们收获满满。','学生会',NULL,'校园活动',198,2,'2026-10-26 19:41:30','2026-10-27 21:24:49',NULL),(3,'计算机科学与技术、网络空间安全、人工智能：谁才是未来就业的“黄金赛道”？','在数字化浪潮席卷全球的今天，计算机相关专业的就业前景成为考生和职场人关注的焦点。计算机科学与技术、网络空间安全、人工智能三大领域，究竟哪个更具就业竞争力？\r\n一、行业需求：人工智能“一骑绝尘”，网络安全“缺口巨大”\r\n\r\n1. 人工智能：需求爆发式增长，高端人才供不应求\r\n\r\n根据人力资源社会保障部及行业预测，2025年我国人工智能核心产业规模将突破1.2万亿元，但相关人才缺口达500万以上，供求比例高达1:10。算法工程师、机器学习工程师等岗位需求激增，2025年春招数据显示，AI工程师岗位求职人数同比增速33.4%，算法工程师岗位增速达69.6%。AI技术已渗透至金融、医疗、制造、教育等传统领域，催生大量复合型岗位（如AI产品经理、解决方案架构师），进一步扩大了需求规模。\r\n\r\n2. 网络空间安全：政策驱动下，人才缺口持续扩大\r\n\r\n随着《网络安全法》《数据安全法》等法规的全面实施，我国网络安全人才缺口已突破300万，且以每年15%-20%的速度增长。金融、能源、政府等关键行业对安全岗位需求尤为迫切，例如金融机构年均新增安全岗位2.3万个，能源企业年增长35%。教育部预测，2027年网络安全人员缺口将达327万，而相关本科专业毕业生规模仅约1.45万人，供需矛盾突出。\r\n\r\n3. 计算机科学与技术：基础学科就业覆盖面广，但竞争加剧\r\n\r\n作为传统工科专业，计算机科学与技术就业方向多元，涵盖软件开发、数据分析、网络安全、人工智能等领域。然而，随着互联网行业增速放缓，传统岗位（如Java后端、基础开发）竞争日益激烈，企业招聘更看重项目经验。新兴技能（如AI、云原生、网络安全）需求上升，倒逼从业者持续学习。\r\n\r\n二、薪资水平：人工智能“高薪领跑”，网络安全“起步高、增长快”\r\n\r\n1. 人工智能：应届生起薪20-30万元，核心岗位年薪百万\r\n\r\n技术研发类岗位（如算法工程师、机器学习工程师）薪资普遍较高，核心算法研发岗年薪可达50-100万元。地域差异显著：一线城市（北京、上海、深圳、杭州）平均月薪约1.8万元，新一线城市（苏州、南京）约1.4万元。互联网大厂算法岗硕士应届生年薪可达50万元以上，远超传统行业。\r\n\r\n2. 网络空间安全：应届生年薪15-30万元，资深人才年薪百万\r\n\r\n网络安全领域薪资涨幅显著，20-30万年薪群体占比从19.48%升至38.43%。一线城市应届生起薪普遍达到8-15万元/年，硕士毕业生在头部互联网企业可获得15-30万元的年薪包（含签字费、股票等激励）。工作3-5年后，渗透测试工程师、安全架构师等岗位年薪可达30-80万元，掌握AI安全、云原生安全等稀缺技能的专家级人才年薪突破百万。\r\n\r\n3. 计算机科学与技术：薪资分化明显，高端岗位竞争力强\r\n\r\n传统岗位薪资增长趋缓，例如2023届计算机本科平均月薪6771元，首次被电子信息类专业反超。但高端技术岗（如架构师、技术专家）及复合型人才（懂技术+行业知识）薪资优势显著，例如金融科技领域资深工程师年薪可达40-60万元。\r\n\r\n三、发展潜力：人工智能“技术迭代快”，网络安全“政策红利强”\r\n\r\n1. 人工智能：技术驱动，应用场景持续拓展\r\n\r\n生成式AI、多模态大模型等技术突破正在重塑互联网商业模式，从广告营销到线上交易，AI正在引发底层逻辑的变革。例如，Chatbot通过个性化推荐与执行，有望颠覆传统搜索广告模式；AI搜索时代催生的GEO（生成式引擎优化）业务，为广告主提供更精准的投放方案。未来，AI将与物联网、区块链等技术深度融合，创造更多新兴岗位。\r\n\r\n2. 网络空间安全：政策强驱动，行业壁垒高\r\n\r\n网络安全已上升至国家战略高度，《关键信息基础设施安全保护条例》等政策明确要求运营者设置专门安全管理机构，直接催生非互联网领域的就业机会。例如，国家电网、三大运营商等央企提供的岗位兼具稳定性与技术深度，部分岗位享受事业编制待遇。此外，数据隐私合规、AI安全等细分领域需求激增，例如GDPR合规专家年薪已达40-60万元。\r\n没有绝对的“黄金赛道”，只有适合的“职业规划”\r\n\r\n计算机科学与技术、网络空间安全、人工智能三大领域各有千秋：人工智能以高薪和技术溢价领跑，网络安全以政策红利和人才缺口取胜，计算机科学与技术以基础扎实和转型灵活见长。最终选择需结合个人兴趣、能力特长与行业趋势，避免盲目跟风。在数字化时代，持续学习、跨界融合才是保持竞争力的核心法则。\r\n\r\n\r\n\r\n','计算机学院',NULL,'学术动态',102,2,'2026-10-26 19:41:30','2026-10-27 21:30:58',NULL),(4,'第20届校园歌手大赛精彩落幕','经过三轮激烈角逐，冠军由来自音乐学院的同学获得。','文艺部',NULL,'校园风采',259,2,'2026-10-26 19:41:30','2026-10-27 21:26:12',NULL),(5,'图书馆寒假开放时间调整','寒假期间图书馆每周二、四、六开放，欢迎同学们前来学习。','图书馆',NULL,'校园通知',79,2,'2026-10-26 19:41:30','2026-10-27 21:26:33',NULL),(6,'新食堂菜品上新','第二食堂新增川菜窗口，价格实惠味道地道，快来尝尝吧！','后勤处',NULL,'校园通知',211,2,'2026-10-26 19:41:30','2026-10-27 21:19:52',NULL),(7,'（草稿）校庆筹备工作启动','明年是我校建校50周年，各项筹备工作已启动……','校长办公室',NULL,'校园通知',0,0,'2026-10-26 19:41:30','2026-10-26 19:41:30',NULL),(8,'（草稿）新学期选课公告','下学期选课将于本周开始……','教务处',NULL,'校园通知',0,0,'2026-10-26 19:41:30','2026-10-26 19:41:30',NULL);
/*!40000 ALTER TABLE `news` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `news_like`
--

DROP TABLE IF EXISTS `news_like`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `news_like` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键',
  `news_id` int NOT NULL COMMENT '目标实体ID（配合 target_type 判定实体类型）',
  `user_id` int NOT NULL COMMENT '点赞者ID（外键，关联 user.id）',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '点赞时间',
  `target_type` varchar(20) NOT NULL DEFAULT 'news' COMMENT 'NEWS/VIDEO/TOPIC',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_news_like_target` (`news_id`,`user_id`,`target_type`),
  KEY `fk_like_user` (`user_id`),
  CONSTRAINT `fk_like_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `news_like`
--

LOCK TABLES `news_like` WRITE;
/*!40000 ALTER TABLE `news_like` DISABLE KEYS */;
INSERT INTO `news_like` VALUES (1,1,2,'2026-10-26 19:41:30','news'),(2,1,3,'2026-10-26 19:41:30','news'),(3,2,2,'2026-10-26 19:41:30','news'),(4,2,3,'2026-10-26 19:41:30','news'),(5,3,2,'2026-10-26 19:41:30','news'),(6,4,2,'2026-10-26 19:41:30','news'),(7,4,3,'2026-10-26 19:41:30','news'),(12,15,4,'2026-10-27 21:26:57','video');
/*!40000 ALTER TABLE `news_like` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `topic`
--

DROP TABLE IF EXISTS `topic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `topic` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键',
  `title` varchar(100) NOT NULL COMMENT '话题标题',
  `content` varchar(1000) NOT NULL COMMENT '话题内容',
  `user_id` int DEFAULT NULL COMMENT '发起者ID（外键，关联 user.id）',
  `author` varchar(50) NOT NULL COMMENT '发起者姓名（冗余）',
  `status` tinyint NOT NULL DEFAULT '2' COMMENT '状态：1待审核 2已审核 3已驳回',
  `views` int DEFAULT '0' COMMENT '浏览量',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '发起时间',
  PRIMARY KEY (`id`),
  KEY `idx_topic_user` (`user_id`),
  CONSTRAINT `fk_topic_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `topic`
--

LOCK TABLES `topic` WRITE;
/*!40000 ALTER TABLE `topic` DISABLE KEYS */;
INSERT INTO `topic` VALUES (1,'期末复习互助打卡','期末考试临近，大家在评论区互相分享复习资料和自习室占座攻略吧！一起加油！',2,'小明',2,217,'2026-10-26 22:42:07'),(2,'食堂新窗口测评','第二食堂川菜窗口开业一周了，大家觉得味道怎么样？推荐哪道菜？',2,'小明',2,186,'2026-10-26 22:42:07'),(4,'图书馆自习座位建议','期末季图书馆一座难求，你希望学校增加自习座位或延长开放时间吗？',3,'李编辑',2,98,'2026-10-26 22:42:07'),(5,'军训风采征集','欢迎大家分享军训期间的照片和趣事，选出最精彩的瞬间！',2,'小明',2,6,'2026-10-26 22:49:56');
/*!40000 ALTER TABLE `topic` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键',
  `username` varchar(50) NOT NULL COMMENT '账号',
  `password` varchar(100) NOT NULL COMMENT '密码',
  `real_name` varchar(50) NOT NULL COMMENT '真实姓名',
  `role` varchar(20) DEFAULT 'user' COMMENT '角色 admin管理员 user普通用户',
  `avatar` varchar(500) DEFAULT NULL,
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'admin','123456','管理员','admin','/avatar/ffc756bdede8494fa22bc8d0ff4c9de9.png','2026-10-26 19:41:30'),(2,'student','123456','小明','user',NULL,'2026-10-26 19:41:30'),(3,'editor','123456','李编辑','admin',NULL,'2026-10-26 19:41:30'),(4,'zzzz','123456','ccc','user','/avatar/2bc0dd7242b445829c0432bf329c4597.jpeg','2026-10-26 20:32:36');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `video`
--

DROP TABLE IF EXISTS `video`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `video` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '主键',
  `title` varchar(200) NOT NULL COMMENT '视频标题',
  `description` varchar(500) DEFAULT NULL COMMENT '视频简介',
  `url` varchar(500) NOT NULL COMMENT '视频地址（mp4）',
  `cover` varchar(500) DEFAULT NULL COMMENT '封面图地址',
  `author` varchar(50) DEFAULT NULL COMMENT '发布者',
  `user_id` int DEFAULT NULL COMMENT '发布者ID（关联 user.id，可为空）',
  `status` tinyint NOT NULL DEFAULT '2' COMMENT '状态：1待审核 2已审核 3已驳回',
  `duration` varchar(20) DEFAULT NULL COMMENT '时长，如 03:25',
  `views` int DEFAULT '0' COMMENT '播放量',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '发布时间',
  PRIMARY KEY (`id`),
  KEY `idx_video_user` (`user_id`),
  CONSTRAINT `fk_video_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `video`
--

LOCK TABLES `video` WRITE;
/*!40000 ALTER TABLE `video` DISABLE KEYS */;
INSERT INTO `video` VALUES (10,'校园宣传片：四季如春','跟随镜头走过校园的春夏秋冬，感受最美校园风景。','/upload/e62bc05f0d984e7a8fb632be2b1a295f.mp4','','宣传部',NULL,2,'0:27',4,'2026-10-27 20:40:13'),(11,'运动会精彩集锦','秋季运动会田径赛场高光时刻回顾','/upload/26e5af00e8a84017943601b9ebd28c5a.mp4','','体育部',NULL,2,'0:22',1,'2026-10-27 20:47:23'),(12,'公开课：人工智能导论','计算机学院公开课节选，带你入门人工智能。','/upload/351e1997069a4c4e9db0c1166ec5f765.mp4','','计算机学院',NULL,2,'0：25',1,'2026-10-27 20:49:35'),(13,'环境宣传','文明我先行，礼仪伴成长。让文明种子在心中生根发芽，做一个讲文明、懂礼仪的新时代好青年。','/upload/e3a9852257574f3bbb056a2c6094f569.mp4','','卫生部',NULL,2,'01:25',2,'2026-10-27 21:09:45'),(15,'分享一首歌','听到这首歌，仿佛又回到了童年。','/upload/bc3b1df09dda4000b1352c670a62263a.mp4','','一个平凡的人',NULL,2,'00:16',4,'2026-10-27 21:14:45');
/*!40000 ALTER TABLE `video` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-29 20:21:46
