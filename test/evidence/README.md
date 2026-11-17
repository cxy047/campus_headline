# 测试证据目录

本目录存放缺陷修复与用例执行的证据，供 [缺陷清单](../缺陷清单.md) 与 [测试用例表](../测试用例表.md) 交叉引用。

## 一、已入库证据

### 1.1 文本证据（可直接核对代码）

| 文件 | 对应缺陷 / 用例 | 内容 | 数据来源 |
|------|------|------|------|
| [BUG-001-拦截器路径配置.md](./BUG-001-拦截器路径配置.md) | BUG-001 / TC-B10 | RoleInterceptor 路径修复前后配置片段 + 验证步骤 | `src/main/resources/springmvc.xml`、`NewsController.java` |
| [BUG-002-评论删除身份校验.md](./BUG-002-评论删除身份校验.md) | BUG-002 / TC-E05、TC-H05 | 评论删除身份校验代码 + 验证步骤 | `CommentController.java`、`CommentServiceImpl.java` |

### 1.2 运行期截图（`screenshots/`，共 14 张）

均由本地 Tomcat + Postman + Navicat（MySQL）实机操作产出，文件名即引用路径。

| 文件 | 对应缺陷 / 用例 | 截图内容与证明点 |
|------|------|------|
| [BUG-001-01-postman-普通用户审核.png](./screenshots/BUG-001-01-postman-普通用户审核.png) | BUG-001 / TC-B10 | 普通用户身份 GET `/news/auditPass?id=7`，响应 403 Forbidden，页面提示「无权访问：仅管理员可执行此操作」，越权审核被 RoleInterceptor 拦截 |
| [BUG-001-02-mysql-越权请求被拦-status仍为0.png](./screenshots/BUG-001-02-mysql-越权请求被拦-status仍为0.png) | BUG-001 / TC-B10 | 普通用户越权调用 `/news/auditPass?id=7` 被 403 拦截后，Navicat 查询 news 表 id=7 的 status 仍为 0（草稿），数据未被改动 |
| [BUG-001-02-mysql-管理员审核生效-status为2.png](./screenshots/BUG-001-02-mysql-管理员审核生效-status为2.png) | BUG-001 / 回归 | 管理员审核同一新闻后，id=7 的 status 变为 2（已审核），证明拦截器修复未影响管理员正常审核流程 |
| [BUG-002-01-postman-删除他人评论.png](./screenshots/BUG-002-01-postman-删除他人评论.png) | BUG-002 / TC-H05 | student 身份 GET `/comment/delete?id=19&targetId=4&targetType=news`，响应 302、`Location: /detail?id=4#comments`，请求未真正删除评论 |
| [BUG-002-02-sql-删除后仍存在.png](./screenshots/BUG-002-02-sql-删除后仍存在.png) | BUG-002 | 请求执行后查询 comment 表，id=19 仍存在且 `user_id=4`，他人（zzzz）的评论未被删除 |
| [BUG-003-01-f12-get写操作.png](./screenshots/BUG-003-01-f12-get写操作.png) | BUG-003 / TC-H01 | F12 Network：`/like/toggle?targetId=5&targetType=news` 的 Request Method=GET、Status Code=302，证明写操作仍以 GET 暴露 |
| [TC-A02.png](./screenshots/TC-A02.png) | TC-A02 | 错误密码登录后停留登录页，提示「账号或密码错误！」 |
| [TC-B05.png](./screenshots/TC-B05.png) | TC-B05 | 普通用户访问 `/news/toAdd`，页面返回「无权访问：仅管理员可执行此操作」 |
| [TC-C04-01-列表未展示.png](./screenshots/TC-C04-01-列表未展示.png) | TC-C04 | 普通用户（小明）发布话题后回到 `/topic`，列表仍为 4 条，未展示新话题 |
| [TC-C04-02-sql-待审核.png](./screenshots/TC-C04-02-sql-待审核.png) | TC-C04 | SQL 查询 topic 表 id=9「测试话题」，status=1（待审核），说明已入库但未审核通过 |
| [TC-E07-02-取消后计数.png](./screenshots/TC-E07-02-取消后计数.png) | TC-E07 | 详情页 `/detail?id=5` 取消点赞后，点赞数回落为 0 |
| [TC-E07-03-sql-无记录.png](./screenshots/TC-E07-03-sql-无记录.png) | TC-E07 | `SELECT ... FROM news_like WHERE target_type='news' AND news_id=5` 返回 0 行，点赞记录已删除 |
| [TC-H02.png](./screenshots/TC-H02.png) | TC-H02 | Postman POST `/user/login`，username=`' OR 1=1 --`，返回登录页并提示「账号或密码错误！」，注入未绕过 |
| [TC-H03.png](./screenshots/TC-H03.png) | TC-H03 | 未登录 POST `/news/add`（`Accept: application/json`）返回 401 Unauthorized，由 LoginInterceptor 先行拦截 |

## 二、待补截图（运行期证据）

| 待补文件名（建议） | 对应用例 / 缺陷 | 截图内容 | 目的 |
|------|------|------|------|
| `TC-D02.png` | TC-D02 | `/video/detail?id=10` 播放器与封面正常加载；F12 中带 `Range` 的请求返回 206 Partial Content | 验证视频播放与分段加载 |
| `TC-F03.png` | TC-F03 | 上传 210MB 文件（超过 `max-file-size` 200MB），返回超限报错 | 验证 multipart 大小限制生效 |
| `BUG-004-01-upload-404.png` | BUG-004 | `/upload/xxx.jpg` 修复前返回 404 | 证明 `file:` 前缀问题存在 |
| `BUG-004-02-upload-成功.png` | BUG-004 | 同一地址修复后正常返回图片 | 证明改为 `file:/` 后恢复正常 |

## 三、已知待处理项

- **BUG-003（GET 写操作 / CSRF）**：状态为「方案已定，待实施」。计划方案为写操作由 `@GetMapping` 改为 `@PostMapping`，同步改造 JSP 表单/AJAX 请求，并增加 CSRF Token 生成与校验；因涉及 4 个 Controller 的 10 余个写接口及对应页面、改造后需逐页回归，本期未实施，代码保持原状。本目录已入库现状截图 `BUG-003-01-f12-get写操作.png`，改造完成后需补修复后截图并复测 TC-H01。
- **BUG-004（上传路径）**：配置文件已改为 `file:/` 前缀，运行期访问截图仍待补（见第二节）。
- 待补截图入库后，在 [测试用例表](../测试用例表.md) 末尾的证据索引中补充对应链接。
