<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>#${fn:escapeXml(topic.title)}# - 话题 - 校园头条</title>
    <link href="${pageContext.request.contextPath}/static/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            --brand: #00A86B; --brand-dark: #00875A; --brand-deep: #006B4F;
            --brand-soft: #E6F7F0; --brand-line: #CBEBDA;
            --ink: #1F2937; --muted: #6B7280; --line: #E5EBE7;
        }
        body {
            margin: 0; color: var(--ink);
            font-family: "Noto Sans SC", "Microsoft YaHei", "PingFang SC", system-ui, sans-serif;
            background: linear-gradient(180deg, #F4F7F5 0%, #EEF5F1 100%);
            min-height: 100vh;
        }
        .site-nav { background: rgba(255,255,255,.96); backdrop-filter: blur(12px); border-bottom: 1px solid var(--line); }
        .brand-mark {
            width: 34px; height: 34px; border-radius: 10px;
            background: linear-gradient(135deg, #00A86B, #16A095);
            display: inline-grid; place-items: center; color: #fff; font-size: .95rem;
            box-shadow: 0 5px 12px rgba(0,168,107,.26);
        }
        .navbar-brand { font-weight: 800; color: var(--ink); }
        .nav-avatar { width: 30px; height: 30px; border-radius: 50%; object-fit: cover; border: 2px solid var(--brand-line); }
        .avatar-fallback {
            width: 30px; height: 30px; border-radius: 50%; display: inline-flex;
            align-items: center; justify-content: center;
            background: var(--brand-soft); color: var(--brand-dark); font-weight: 700; font-size: .82rem;
        }
        .nav-user { color: #4B5563; font-size: .88rem; text-decoration: none; }
        .nav-user:hover { color: var(--brand); }
        .btn-brand { background: var(--brand); border: 1px solid var(--brand); color: #fff; font-weight: 600; border-radius: 999px; }
        .btn-brand:hover { background: var(--brand-dark); border-color: var(--brand-dark); color: #fff; }
        .btn-outline-brand { color: var(--brand-dark); border: 1px solid var(--brand-line); font-weight: 600; border-radius: 999px; background: #fff; }
        .btn-outline-brand:hover { background: var(--brand); border-color: var(--brand); color: #fff; }

        .breadcrumb-line { color: #9CA3AF; font-size: .82rem; margin: 0 0 18px; }
        .breadcrumb-line a { color: #6B7280; text-decoration: none; }
        .breadcrumb-line a:hover { color: var(--brand); }

        .topic-hero {
            background: linear-gradient(120deg, #006B4F 0%, #00A86B 60%, #16A095 100%);
            border-radius: 18px; color: #fff; padding: 32px 36px;
            box-shadow: 0 14px 36px rgba(0,107,79,.22);
        }
        .topic-hero .hash-badge {
            display: inline-grid; place-items: center;
            width: 52px; height: 52px; border-radius: 14px;
            background: rgba(255,255,255,.16); border: 1px solid rgba(255,255,255,.28);
            font-size: 1.5rem;
        }
        .topic-hero h1 { font-size: 1.5rem; font-weight: 800; margin: 14px 0 10px; }
        .topic-hero .meta { display: flex; flex-wrap: wrap; gap: 8px 18px; font-size: .84rem; color: rgba(255,255,255,.85); }
        .topic-hero .meta i { margin-right: 4px; }

        .topic-content-card {
            margin-top: 20px; background: #fff; border: 1px solid var(--line); border-radius: 16px;
            padding: 28px 32px; box-shadow: 0 10px 28px rgba(15,23,42,.06);
        }
        .topic-content-card h2 { font-size: 1.05rem; font-weight: 800; margin: 0 0 14px; }
        .topic-content-card h2::before {
            content: ""; display: inline-block; width: 4px; height: 16px; border-radius: 2px;
            background: var(--brand); margin-right: 10px; vertical-align: -2px;
        }
        .topic-content-card p { margin: 0; color: #374151; font-size: .95rem; line-height: 2; white-space: pre-wrap; word-break: break-word; }

        .side-card { background: #fff; border: 1px solid var(--line); border-radius: 16px; padding: 20px; }
        .side-card h3 { font-size: 1rem; font-weight: 800; margin: 0 0 6px; }
        .side-card h3 i { color: #FF8A3D; margin-right: 6px; }
        .rank-list { list-style: none; margin: 0; padding: 0; }
        .rank-list li { display: flex; align-items: flex-start; gap: 10px; padding: 10px 0; border-bottom: 1px dashed #EEF2F0; }
        .rank-list li:last-child { border-bottom: 0; }
        .rank {
            flex: 0 0 auto; width: 20px; height: 20px; margin-top: 1px;
            border-radius: 6px; display: grid; place-items: center;
            background: #F1F5F3; color: #9CA3AF; font-size: .7rem; font-weight: 800;
        }
        .rank.top { background: var(--brand); color: #fff; }
        .rank-list a { flex: 1 1 auto; color: #374151; text-decoration: none; font-size: .88rem; line-height: 1.55; }
        .rank-list a:hover { color: var(--brand-dark); }
        .views-mini { flex: 0 0 auto; color: #9CA3AF; font-size: .72rem; margin-top: 2px; }
        .side-sticky { position: sticky; top: 84px; }
        /* ---------- 点赞 / 评论 ---------- */
        .content-actions { display:flex; flex-wrap:wrap; gap:12px; margin-top:20px; padding-top:18px; border-top:1px solid #F0F4F1; }
        .action-btn { display:inline-flex; align-items:center; gap:8px; padding:8px 16px; border-radius:999px; border:1px solid var(--line); background:#fff; color:#4B5563; text-decoration:none; font-size:.88rem; font-weight:600; transition:all .18s ease; }
        .action-btn b { font-weight:700; color:var(--ink); }
        .action-btn:hover { border-color:var(--brand-line); color:var(--brand-dark); transform:translateY(-1px); }
        .action-btn.like.active { background:#FEF2F2; border-color:#FECACA; color:#DC2626; }
        .action-btn.like.active b { color:#DC2626; }
        .comments { margin-top:22px; background:#fff; border:1px solid var(--line); border-radius:16px; padding:22px 24px 26px; box-shadow:0 10px 24px rgba(15,23,42,.05); }
        .comments h2 { font-size:1.05rem; font-weight:800; margin:0 0 14px; }
        .comments h2::before { content:""; display:inline-block; width:4px; height:15px; border-radius:2px; background:var(--brand); margin-right:9px; vertical-align:-2px; }
        .comments h2 .num { color:var(--brand); }
        .comment-form textarea { width:100%; border:1px solid var(--line); border-radius:10px; padding:12px 14px; resize:vertical; font-size:.92rem; outline:none; font-family:inherit; background:#FBFDFC; color:var(--ink); }
        .comment-form textarea:focus { border-color:#6FD3A9; box-shadow:0 0 0 3px rgba(0,168,107,.12); background:#fff; }
        .form-foot { display:flex; align-items:center; justify-content:space-between; gap:12px; margin-top:10px; }
        .form-foot .who { color:#9CA3AF; font-size:.82rem; }
        .btn-publish { border:0; border-radius:9px; padding:8px 20px; background:var(--brand); color:#fff; font-weight:600; }
        .btn-publish:hover { background:var(--brand-dark); }
        .login-tip { background:#F7FBF9; border:1px dashed var(--brand-line); border-radius:10px; padding:14px; text-align:center; color:#6B7280; font-size:.88rem; }
        .login-tip a { color:var(--brand-dark); font-weight:600; text-decoration:none; }
        .comment-list { margin-top:18px; }
        .comment-item { display:flex; gap:12px; padding:14px 0; border-top:1px solid #F2F6F4; }
        .comment-item:first-child { border-top:0; padding-top:4px; }
        .avatar { width:38px; height:38px; border-radius:50%; flex:0 0 auto; overflow:hidden; background:linear-gradient(135deg,#00875A,#4FD1A5); color:#fff; display:grid; place-items:center; font-weight:700; font-size:.9rem; }
        .avatar img { width:100%; height:100%; border-radius:50%; object-fit:cover; }
        .comment-body { flex:1; min-width:0; }
        .comment-head { display:flex; align-items:center; gap:8px; flex-wrap:wrap; font-size:.86rem; }
        .comment-head strong { color:#111827; }
        .badge-admin { font-size:.66rem; padding:1px 6px; border-radius:999px; background:#FFF3E6; color:#C2410C; font-weight:700; }
        .comment-time { color:#9CA3AF; font-size:.76rem; margin-left:auto; }
        .comment-body p { margin:6px 0 0; color:#374151; font-size:.9rem; line-height:1.75; white-space:pre-wrap; word-break:break-word; }
        .comment-del { display:inline-block; margin-top:6px; font-size:.76rem; color:#9CA3AF; text-decoration:none; }
        .comment-del:hover { color:#DC2626; }
        .no-comment { color:#9CA3AF; text-align:center; padding:22px 0 4px; font-size:.88rem; }

        .site-footer { margin-top: 48px; border-top: 1px solid var(--line); background: #fff; }
        .site-footer .inner {
            max-width: 1140px; margin: 0 auto; padding: 22px 16px;
            display: flex; flex-wrap: wrap; gap: 8px; justify-content: space-between;
            color: var(--muted); font-size: .84rem;
        }
        @media (max-width: 991px) { .side-sticky { position: static; } }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg sticky-top site-nav">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center gap-2" href="${pageContext.request.contextPath}/index">
            <span class="brand-mark"><i class="bi bi-newspaper"></i></span>校园头条
        </a>
        <div class="d-flex align-items-center gap-2">
            <c:choose>
                <c:when test="${not empty loginUser}">
                    <a class="nav-user d-inline-flex align-items-center gap-2 me-2" href="${pageContext.request.contextPath}/user/profile">
                        <c:choose>
                            <c:when test="${not empty loginUser.avatar}">
                                <img class="nav-avatar" src="${pageContext.request.contextPath}${loginUser.avatar}" alt="头像">
                            </c:when>
                            <c:otherwise><span class="avatar-fallback">${fn:substring(loginUser.realName, 0, 1)}</span></c:otherwise>
                        </c:choose>
                        ${fn:escapeXml(loginUser.realName)}
                    </a>
                    <a class="btn btn-outline-brand btn-sm px-3" href="${pageContext.request.contextPath}/user/logout"><i class="bi bi-box-arrow-right me-1"></i>退出</a>
                </c:when>
                <c:otherwise>
                    <a class="btn btn-outline-brand btn-sm px-3" href="${pageContext.request.contextPath}/login">登录</a>
                    <a class="btn btn-brand btn-sm px-3" href="${pageContext.request.contextPath}/register">注册</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</nav>

<div class="container my-4">
    <div class="breadcrumb-line">
        <a href="${pageContext.request.contextPath}/index"><i class="bi bi-house-door me-1"></i>首页</a>
        <span class="mx-1">/</span>
        <a href="${pageContext.request.contextPath}/topic">话题广场</a>
        <span class="mx-1">/</span>
        <span>话题详情</span>
    </div>

    <div class="row g-4">
        <div class="col-lg-8">
            <div class="topic-hero">
                <span class="hash-badge"><i class="bi bi-hash"></i></span>
                <h1>${fn:escapeXml(topic.title)}</h1>
                <div class="meta">
                    <span><i class="bi bi-person"></i>${fn:escapeXml(topic.author)} 发起</span>
                    <span><i class="bi bi-eye"></i>${topic.views} 次浏览</span>
                    <span><i class="bi bi-calendar3"></i><fmt:formatDate value="${topic.createTime}" pattern="yyyy-MM-dd HH:mm"/></span>
                </div>
            </div>

            <div class="topic-content-card">
                <h2>话题详情</h2>
                <p>${fn:escapeXml(topic.content)}</p>

                <!-- 点赞 / 评论入口 -->
                <div class="content-actions">
                    <c:choose>
                        <c:when test="${not empty loginUser}">
                            <a href="${pageContext.request.contextPath}/like/toggle?targetId=${topic.id}&targetType=topic"
                               class="action-btn like ${liked ? 'active' : ''}">
                                <i class="bi ${liked ? 'bi-heart-fill' : 'bi-heart'}"></i>
                                <span>${liked ? '已点赞' : '点赞'}</span><b>${likeCount}</b>
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/login" class="action-btn like">
                                <i class="bi bi-heart"></i><span>点赞</span><b>${likeCount}</b>
                            </a>
                        </c:otherwise>
                    </c:choose>
                    <a href="#topicComments" class="action-btn">
                        <i class="bi bi-chat-dots"></i><span>评论</span><b>${commentCount}</b>
                    </a>
                </div>
            </div>

            <!-- ============ 评论区 ============ -->
            <section class="comments" id="topicComments">
                <h2>评论 <span class="num">${commentCount}</span></h2>
                <c:choose>
                    <c:when test="${not empty loginUser}">
                        <form class="comment-form" action="${pageContext.request.contextPath}/comment/add" method="post">
                            <input type="hidden" name="targetId" value="${topic.id}">
                            <input type="hidden" name="targetType" value="topic">
                            <textarea name="content" rows="3" maxlength="500" required placeholder="说点什么吧...（最多 500 字）"></textarea>
                            <div class="form-foot">
                                <span class="who"><i class="bi bi-person-circle me-1"></i>以 ${fn:escapeXml(loginUser.realName)} 的身份评论</span>
                                <button type="submit" class="btn-publish"><i class="bi bi-send me-1"></i>发表评论</button>
                            </div>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <div class="login-tip">
                            <i class="bi bi-lock me-1"></i>登录后即可参与评论与点赞
                            <a href="${pageContext.request.contextPath}/login">去登录</a>
                        </div>
                    </c:otherwise>
                </c:choose>
                <div class="comment-list">
                    <c:forEach var="cm" items="${comments}">
                        <div class="comment-item">
                            <div class="avatar">
                                <c:choose>
                                    <c:when test="${not empty cm.userAvatar}">
                                        <img src="${pageContext.request.contextPath}${cm.userAvatar}" alt="头像">
                                    </c:when>
                                    <c:otherwise>${fn:substring(cm.userName, 0, 1)}</c:otherwise>
                                </c:choose>
                            </div>
                            <div class="comment-body">
                                <div class="comment-head">
                                    <strong>${fn:escapeXml(cm.userName)}</strong>
                                    <c:if test="${cm.userRole == 'admin'}"><span class="badge-admin">管理员</span></c:if>
                                    <span class="comment-time"><fmt:formatDate value="${cm.createTime}" pattern="yyyy-MM-dd HH:mm"/></span>
                                </div>
                                <p>${fn:escapeXml(cm.content)}</p>
                                <c:if test="${not empty loginUser and (loginUser.id == cm.userId or loginUser.role == 'admin')}">
                                    <a class="comment-del"
                                       href="${pageContext.request.contextPath}/comment/delete?id=${cm.id}&targetId=${topic.id}&targetType=topic"
                                       onclick="return confirm('确定删除这条评论吗？')">
                                        <i class="bi bi-trash"></i> 删除
                                    </a>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty comments}">
                        <div class="no-comment"><i class="bi bi-chat-square-text me-1"></i>还没有评论，来抢沙发吧</div>
                    </c:if>
                </div>
            </section>
        </div>

        <aside class="col-lg-4">
            <div class="side-sticky">
                <div class="side-card">
                    <h3><i class="bi bi-fire"></i>热门话题</h3>
                    <ol class="rank-list">
                        <c:forEach var="hot" items="${hotTopics}" varStatus="st">
                            <li>
                                <span class="rank ${st.index lt 3 ? 'top' : ''}">${st.index + 1}</span>
                                <a href="${pageContext.request.contextPath}/topic/detail?id=${hot.id}">${fn:escapeXml(hot.title)}</a>
                                <span class="views-mini"><i class="bi bi-eye"></i> ${hot.views}</span>
                            </li>
                        </c:forEach>
                    </ol>
                </div>
                <div class="mt-3 text-center">
                    <a href="${pageContext.request.contextPath}/topic" class="btn btn-outline-brand px-4">
                        <i class="bi bi-arrow-left me-1"></i>返回话题广场
                    </a>
                </div>
            </div>
        </aside>
    </div>
</div>

<footer class="site-footer">
    <div class="inner">
        <span><i class="bi bi-newspaper me-1"></i>校园头条 · 校园新闻资讯系统</span>
        <span>SSM 框架课程设计</span>
    </div>
</footer>

<script src="${pageContext.request.contextPath}/static/js/bootstrap.bundle.min.js"></script>
</body>
</html>
