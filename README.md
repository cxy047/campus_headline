# 📰 校园头条 SSM - 新闻管理系统

> Spring + SpringMVC + MyBatis-Plus 三层架构校园新闻管理系统 · 含完整测试资产

---

## 📋 项目概览

| 项目 | 说明 |
|------|------|
| **项目类型** | 校园新闻/话题/视频聚合管理系统 |
| **技术栈** | Spring 6.1.2 + SpringMVC 6.1.2 + MyBatis-Plus 3.5.17 + MySQL 8 + Druid + Tomcat 10.1 |
| **前端** | JSP + Bootstrap 5 |
| **测试角色** | 开发 + 全流程黑盒功能测试 + 接口测试 |
| **数据库设计** | 7 表 + `target_type + target_id` 多态关联（统一 news/video/topic 评论点赞） |

## 🎯 功能模块

- **登录注册**（`UserController`）：Session + 双拦截器（LoginInterceptor 登录态 + RoleInterceptor admin 角色）
- **新闻管理**（`NewsController`）：列表/搜索/详情/新增/编辑/删除/提审/审核通过/驳回
- **话题广场**（`TopicController`）：列表/详情/发帖（普通用户发帖自动 pending）/管理/审核
- **视频专区**（`VideoController`）：列表/播放/新增/编辑/删除/审核
- **评论系统**（`CommentController`）：支持 news/video/topic 多态目标（`target_type + target_id`）
- **点赞功能**（`LikeController`）：toggle 模式，同样多态关联
- **文件上传**（`UploadController` / `CoverController` / `AvatarController`）：封面、头像、素材三类
- **个人中心**（`UserProfileController`）：资料修改、密码修改、发布入口、删除自己内容

## 🛡 权限模型

| 拦截器 | 保护路径 | 说明 |
|--------|----------|------|
| **LoginInterceptor** | `/news/**`、`/material/**`、`/comment/*`、`/like/**`、`/topic/*`、`/video/*`、`/user/profile/**` | Session 取 `loginUser`，未登录返回 401 或重定向 |
| **RoleInterceptor** | `/news/add/update/delete`、`/video/*`（写操作）、`/topic/*`（写操作）、`/material/**` | 仅 `role=admin` 可访问，否则 403 |

## 🧪 测试资产

全部随仓库公开，面试可逐条复述：

| 文件 | 说明 |
|------|------|
| [`test/测试用例表.md`](./test/测试用例表.md) | **56 条**黑盒用例，等价类 + 边界值 + 场景法 + 判定表，8 大模块全覆盖 |
| [`test/缺陷清单.md`](./test/缺陷清单.md) | **4 个真实缺陷**（S2×2 + S3×2），含重现步骤、根因分析、修复方案、代码定位 |
| [`test/测试总结报告.md`](./test/测试总结报告.md) | 测试执行总结、指标统计、定位方法论 |

### 缺陷速览（面试高频）

| 严重度 | 缺陷摘要 | 根因定位 |
|--------|----------|----------|
| **S2** | RoleInterceptor 路径配置错误，新闻审核接口完全不受保护 | `springmvc.xml` 写的 `/news/audit` vs Controller 实际 `/news/auditPass` |
| **S2** | 评论删除缺少 RoleInterceptor 保护，任何登录用户可删任意评论 | springmvc.xml 未配置 `/comment/delete` + CommentController 无身份校验 |
| **S3** | 写操作用 GET 请求，CSRF 风险 | Controller 大量 @GetMapping 写操作 |
| **S3** | `file:` 路径前缀 Tomcat 10.1 下 404 | `location="file:${user.home}/campus_upload/"` 需改为 `file:/` |

**缺陷在源码中的证据（可复述）**：

```xml
<!-- springmvc.xml 第 62-64 行：RoleInterceptor 配置错误位置 -->
<mvc:mapping path="/news/audit"/>    <!-- 错误！Controller 里是 /news/auditPass -->
<mvc:mapping path="/news/publish"/>   <!-- 错误！Controller 里是 /news/submitAudit -->
<mvc:mapping path="/news/draft"/>     <!-- 错误！Controller 里根本没有这个路径 -->
```

## ✅ 测试指标

| 指标 | 数值 |
|------|------|
| 用例总数 | 56 |
| 通过（修复前） | 49 |
| 失败（修复前） | 7 |
| 缺陷总数 | 4（**S2 权限绕过 × 2** + S3 × 2） |
| 修复率 | **100%** |
| 覆盖层级 | 页面功能 + Postman 接口 + SQL 数据校验 |
| 覆盖平台 | Tomcat 9 / 10.1 双版本验证 |

## 🛠 本地运行

```bash
# 1. 创建 MySQL 数据库，执行 Query.sql 初始化表结构
mysql -u root -p < Query.sql

# 2. 复制配置模板并填写数据库连接信息
#    cp src/main/resources/jdbc.properties.example src/main/resources/jdbc.properties

# 3. Maven 打包
mvn clean package

# 4. 部署到 Tomcat 10.1
# 将 target/campus_headline.war 复制到 tomcat/webapps/ 下

# 5. 启动 Tomcat
cd tomcat/bin
startup.bat

# 6. 访问 http://localhost:8080/campus_headline/
# 默认管理员账号：admin / admin123
```

## 📁 仓库结构

```
campus_headline/
├── src/main/java/com/chenxy/
│   ├── controller/           # 12 个 Controller
│   ├── interceptor/          # LoginInterceptor + RoleInterceptor + LogAspect
│   ├── entity/               # 7 个实体
│   └── mapper/               # MyBatis-Plus Mapper
├── src/main/resources/        # spring.xml / springmvc.xml / mybatis-config.xml / jdbc.properties
├── Query.sql                 # 数据库表结构初始化
├── pom.xml                   # Maven 依赖
├── tomcat/                   # 部署容器（Tomcat 10.1）
├── test/                     # 📌 测试资产目录
│   ├── 测试用例表.md
│   ├── 缺陷清单.md
│   └── 测试总结报告.md
└── README.md
```
