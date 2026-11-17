# 测试证据目录

本目录存放缺陷修复与用例执行的证据，供 [缺陷清单](../缺陷清单.md) 与 [测试用例表](../测试用例表.md) 交叉引用。

## 一、已入库证据

### 1.1 文本证据（可直接核对代码）

| 文件 | 对应缺陷 / 用例 | 内容 | 数据来源 |
|------|------|------|------|
| [BUG-001-拦截器路径配置.md](./BUG-001-拦截器路径配置.md) | BUG-001 / TC-B10 | RoleInterceptor 路径修复前后配置片段 + 验证步骤 | `src/main/resources/springmvc.xml`、`NewsController.java` |
| [BUG-002-评论删除身份校验.md](./BUG-002-评论删除身份校验.md) | BUG-002 / TC-E05、TC-H05 | 评论删除身份校验代码 + 验证步骤 | `CommentController.java`、`CommentServiceImpl.java` |

### 1.2 运行期截图（`screenshots/`，共 20 张）

均由本地 Tomcat + Postman + Navicat（MySQL）实机操作产出，文件名即引用路径。

| 文件 | 对应缺陷 / 用例 | 截图内容与证明点 |
|------|------|------|
| [BUG-001-01-postman-普通用户审核.png](./screenshots/BUG-001-01-postman-普通用户审核.png) | BUG-001 / TC-B10 | 普通用户身份 GET `/news/auditPass?id=7`，响应 403 Forbidden，页面提示「无权访问：仅管理员可执行此操作」，越权审核被 RoleInterceptor 拦截 |
| [BUG-001-02-mysql-越权请求被拦-status仍为0.png](./screenshots/BUG-001-02-mysql-越权请求被拦-status仍为0.png) | BUG-001 / TC-B10 | 普通用户越权调用 `/news/auditPass?id=7` 被 403 拦截后，Navicat 查询 news 表 id=7 的 status 仍为 0（草稿），数据未被改动 |
| [BUG-001-02-mysql-管理员审核生效-status为2.png](./screenshots/BUG-001-02-mysql-管理员审核生效-status为2.png) | BUG-001 / 回归 | 管理员审核同一新闻后，id=7 的 status 变为 2（已审核），证明拦截器修复未影响管理员正常审核流程 |
| [BUG-002-01-postman-删除他人评论.png](./screenshots/BUG-002-01-postman-删除他人评论.png) | BUG-002 / TC-H05 | student 身份 GET `/comment/delete?id=19&targetId=4&targetType=news`，响应 302、`Location: /detail?id=4#comments`，请求未真正删除评论 |
| [BUG-002-02-sql-删除后仍存在.png](./screenshots/BUG-002-02-sql-删除后仍存在.png) | BUG-002 | 请求执行后查询 comment 表，id=19 仍存在且 `user_id=4`，他人（zzzz）的评论未被删除 |
| [BUG-003-01-f12-get写操作.png](./screenshots/BUG-003-01-f12-get写操作.png) | BUG-003 / TC-H01 | F12 Network：`/like/toggle?targetId=5&targetType=news` 的 Request Method=GET、Status Code=302，证明写操作仍以 GET 暴露 |
| [BUG-004-01-upload-视频正常播放.png](./screenshots/BUG-004-01-upload-视频正常播放.png) | BUG-004 | 浏览器直接访问 `/upload/e62bc05f0d984e7a8fb632be2b1a295f.mp4`，视频正常播放至 0:03/0:26，证明 `file:/` 修正后上传目录文件可正常访问 |
| [TC-A02.png](./screenshots/TC-A02.png) | TC-A02 | 错误密码登录后停留登录页，提示「账号或密码错误！」 |
| [TC-B05.png](./screenshots/TC-B05.png) | TC-B05 | 普通用户访问 `/news/toAdd`，页面返回「无权访问：仅管理员可执行此操作」 |
| [TC-C04-01-列表未展示.png](./screenshots/TC-C04-01-列表未展示.png) | TC-C04 | 普通用户（小明）发布话题后回到 `/topic`，列表仍为 4 条，未展示新话题 |
| [TC-C04-02-sql-待审核.png](./screenshots/TC-C04-02-sql-待审核.png) | TC-C04 | SQL 查询 topic 表 id=9「测试话题」，status=1（待审核），说明已入库但未审核通过 |
| [TC-E07-02-取消后计数.png](./screenshots/TC-E07-02-取消后计数.png) | TC-E07 | 详情页 `/detail?id=5` 取消点赞后，点赞数回落为 0 |
| [TC-E07-03-sql-无记录.png](./screenshots/TC-E07-03-sql-无记录.png) | TC-E07 | `SELECT ... FROM news_like WHERE target_type='news' AND news_id=5` 返回 0 行，点赞记录已删除 |
| [TC-D02-01-video-206.png](./screenshots/TC-D02-01-video-206.png) | TC-D02 | Chrome Network：`/upload/48d178b2ed934f9b852332ff32a11bc8.mp4` 返回 206 Partial Content，`Content-Range: bytes 1212416-2260991/19964859`、`Content-Type: video/mp4`，证明 Range 分段加载生效 |
| [TC-F03-01-curl-413.png](./screenshots/TC-F03-01-curl-413.png) | TC-F03 | curl 上传 210763964 字节文件到 `/material/upload`，返回 `HTTP/1.1 413`、`Content-Length: 707`，响应体含 `Maximum upload size exceeded` |
| [TC-F03-02-sql-material-无新增.png](./screenshots/TC-F03-02-sql-material-无新增.png) | TC-F03 | SQL `SELECT COUNT(*) cnt, MAX(id) max_id, MAX(upload_time) last_upload FROM material` 结果为 5 / 10 / 2026-10-27 21:14:45，上传被拒后未产生新记录 |
| [TC-F03-03-access-log-413.png](./screenshots/TC-F03-03-access-log-413.png) | TC-F03 | Tomcat 访问日志中多条 `POST /campus_headline_war/material/upload ... 413 707`，含 `2026/11/17 12:31:05 +0800` 一条，与 curl 请求时间对应 |
| [TC-F03-04-浏览器-连接重置.png](./screenshots/TC-F03-04-浏览器-连接重置.png) | TC-F03 | 浏览器上传大文件后在 `/material/upload` 显示「连接已重置 / ERR_CONNECTION_RESET」，作为客户端侧佐证（服务端以 413 为准） |
| [TC-H02.png](./screenshots/TC-H02.png) | TC-H02 | Postman POST `/user/login`，username=`' OR 1=1 --`，返回登录页并提示「账号或密码错误！」，注入未绕过 |
| [TC-H03.png](./screenshots/TC-H03.png) | TC-H03 | 未登录 POST `/news/add`（`Accept: application/json`）返回 401 Unauthorized，由 LoginInterceptor 先行拦截 |

## 二、证据完整性说明

运行期截图已全部入库（20 张），无待补项。

**关于 BUG-004 未单独采集 404 截图**：`/upload/**` 的请求实际由 [UploadController.serve](../../src/main/java/com/chenxy/controller/UploadController.java#L31) 的 `@GetMapping("/upload/{fileName:.+}")` 处理，其 handler 优先级高于 [springmvc.xml](../../src/main/resources/springmvc.xml#L26-L27) 中的 `<mvc:resources mapping="/upload/**" .../>`。该缺陷的成因是资源映射 location 缺少前导斜杠（`file:${user.home}/...`），修复后为 `file:/${user.home}/campus_upload/`。复现 404 需临时注释 Controller 映射并重新部署两次，故本次不做单独取证，改以下述证据链核对：

1. 配置行：`springmvc.xml` 第 26-27 行为 `location="file:/${user.home}/campus_upload/"`（修复后写法）；
2. 正向访问：上传目录内的视频经 `/upload/e62bc05f0d984e7a8fb632be2b1a295f.mp4` 可正常播放（`BUG-004-01-upload-视频正常播放.png`）；
3. 代码路径：`UploadController.serve` 从 `MaterialStorage.find(fileName)` 取文件，文件不存在时返回 404，存在时返回 200/206。

## 三、已知待处理项

- **BUG-003（GET 写操作 / CSRF）**：状态为「方案已定，待实施」。计划方案为写操作由 `@GetMapping` 改为 `@PostMapping`，同步改造 JSP 表单/AJAX 请求，并增加 CSRF Token 生成与校验；因涉及 4 个 Controller 的 10 余个写接口及对应页面、改造后需逐页回归，本期未实施，代码保持原状。本目录已入库现状截图 `BUG-003-01-f12-get写操作.png`，改造完成后需补修复后截图并复测 TC-H01。
- **BUG-004（上传路径）**：`springmvc.xml` 已修正为 `file:/` 前缀，正向访问证据见 1.2；未单独采集 404 截图，原因见第二节。
