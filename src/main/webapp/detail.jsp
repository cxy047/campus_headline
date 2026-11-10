<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${news.title} - 校园头条</title>
    <link href="${pageContext.request.contextPath}/static/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            --brand:#00A86B; --brand-dark:#00875A; --brand-deep:#006B4F;
            --brand-soft:#E6F7F0; --brand-line:#CBEBDA;
            --line:#E5EBE7; --muted:#6B7280; --ink:#1F2937;
        }
        body {
            background: linear-gradient(180deg, #F4F7F5 0%, #EEF5F1 100%);
            min-height: 100vh;
            font-family: "Noto Sans SC", "Microsoft YaHei", "PingFang SC", system-ui, sans-serif;
            color: var(--ink);
        }
        .site-nav { background: rgba(255,255,255,.96); backdrop-filter: blur(10px); border-bottom: 1px solid var(--line); }
        .navbar-brand { font-weight: 800; color: var(--ink); }
        .brand-mark {
            width: 34px; height: 34px; border-radius: 10px; display: inline-flex;
            align-items: center; justify-content: center;
            background: linear-gradient(135deg, #00A86B, #16A095); color: #fff;
            box-shadow: 0 5px 12px rgba(0,168,107,.26);
        }
        .site-nav .nav-link { color: #374151; font-weight: 500; }
        .site-nav .nav-link:hover { color: var(--brand); }
        .btn-login { color: var(--brand-dark); font-weight: 600; text-decoration: none; padding: 6px 14px; }
        .btn-register {
            background: var(--brand); color: #fff; font-weight: 600;
            border-radius: 999px; padding: 6px 20px; text-decoration: none;
        }
        .btn-register:hover { background: var(--brand-dark); color: #fff; }
        .user-chip { color: #4B5563; font-size: .9rem; text-decoration: none; }
        .user-chip:hover { color: var(--brand-dark); }
        .nav-avatar { width: 30px; height: 30px; border-radius: 50%; object-fit: cover; border: 2px solid var(--brand-line); }
        .avatar-fallback {
            width: 30px; height: 30px; border-radius: 50%; display: inline-flex;
            align-items: center; justify-content: center;
            background: var(--brand-soft); color: var(--brand-dark); font-weight: 700; font-size: .82rem;
        }
        .crumb { color: #94a3b8; font-size: .84rem; margin: 22px 0 16px; }
        .crumb a { color: #94a3b8; text-decoration: none; }
        .crumb a:hover { color: var(--brand); }
        .article {
            background: #fff; border: 1px solid var(--line); border-radius: 18px;
            padding: 40px 46px 30px; box-shadow: 0 10px 28px rgba(15,23,42,.06);
        }
        .article h1 { font-weight: 800; font-size: 1.65rem; line-height: 1.4; margin-bottom: 16px; }
        .article .meta { color: #94a3b8; font-size: .85rem; border-bottom: 1px solid #F0F5F2; padding-bottom: 18px; margin-bottom: 24px; }
        .cat-badge { font-size: .74rem; font-weight: 600; border-radius: 6px; padding: 2px 9px; text-decoration: none; }
        .cat-notice  { background: #E6F7F0; color: #00875A; }
        .cat-activity{ background: #FFF3E6; color: #C2410C; }
        .cat-academic{ background: #E8F1FD; color: #1D5FD1; }
        .cat-style   { background: #F3E9FD; color: #7C3AED; }
        .article .content { font-size: 1.02rem; line-height: 2; color: #374151; white-space: pre-wrap; word-break: break-word; }
        .actions { display: flex; gap: 12px; border-top: 1px solid #F0F5F2; margin-top: 28px; padding-top: 20px; }
        .action-btn {
            display: inline-flex; align-items: center; gap: 7px;
            border: 1px solid var(--line); border-radius: 999px; background: #fff;
            padding: 7px 18px; font-size: .88rem; color: #4B5563; text-decoration: none;
            transition: all .15s ease;
        }
        .action-btn b { font-weight: 700; }
        .action-btn:hover { border-color: var(--brand-line); color: var(--brand-dark); }
        .action-btn.like.active { background: #FEF2F2; border-color: #FECACA; color: #DC2626; }
        .comments {
            margin-top: 22px; background: #fff; border: 1px solid var(--line);
            border-radius: 18px; padding: 24px 28px; box-shadow: 0 10px 28px rgba(15,23,42,.06);
        }
        .comments h2 { font-size: 1.05rem; font-weight: 800; margin: 0 0 16px; }
        .comments h2::before { content: ""; display: inline-block; width: 4px; height: 15px; border-radius: 2px; background: var(--brand); margin-right: 9px; vertical-align: -2px; }
        .comments h2 .num { color: var(--brand); }
        .login-tip {
            text-align: center; color: #94a3b8; font-size: .88rem;
            border: 1px dashed var(--line); border-radius: 12px; padding: 18px;
        }
        .login-tip a { color: var(--brand-dark); font-weight: 700; text-decoration: none; margin-left: 6px; }
        .comment-form textarea {
            width: 100%; border: 1px solid var(--line); border-radius: 12px; padding: 12px 14px;
            resize: vertical; font-size: .92rem; outline: none; font-family: inherit; background: #FBFDFC;
        }
        .comment-form textarea:focus { border-color: #6FD3A9; box-shadow: 0 0 0 3px rgba(0,168,107,.12); background: #fff; }
        .form-foot { display: flex; justify-content: space-between; align-items: center; margin-top: 10px; }
        .form-foot .who { color: #9CA3AF; font-size: .8rem; }
        .btn-publish {
            border: 0; border-radius: 10px; background: var(--brand); color: #fff;
            font-weight: 700; font-size: .86rem; padding: 8px 20px;
        }
        .btn-publish:hover { background: var(--brand-dark); }
        .comment-list { margin-top: 18px; }
        .comment-item { display: flex; gap: 12px; padding: 14px 0; border-top: 1px solid #F2F6F4; }
        .comment-item:first-child { border-top: 0; }
        .avatar {
            width: 40px; height: 40px; border-radius: 50%; flex: 0 0 auto; overflow: hidden;
            background: var(--brand-soft); color: var(--brand-dark);
            display: grid; place-items: center; font-weight: 800; font-size: .95rem;
        }
        .avatar img { width: 100%; height: 100%; object-fit: cover; }
        .comment-body { flex: 1; min-width: 0; }
        .comment-head { display: flex; align-items: center; gap: 8px; font-size: .88rem; }
        .comment-time { color: #9CA3AF; font-size: .76rem; margin-left: auto; }
        .comment-body p { margin: 6px 0 0; color: #374151; font-size: .92rem; line-height: 1.75; white-space: pre-wrap; word-break: break-word; }
        .comment-del { display: inline-block; margin-top: 6px; font-size: .76rem; color: #9CA3AF; text-decoration: none; }
        .comment-del:hover { color: #DC2626; }
        .badge-admin { background: #FFF3E6; color: #C2410C; font-size: .68rem; border-radius: 999px; padding: 1px 8px; font-weight: 700; }
        .no-comment { color: #9CA3AF; text-align: center; padding: 24px 0 6px; font-size: .88rem; }
        .footer { margin-top: 44px; padding: 22px 0; color: #94a3b8; font-size: .8rem; border-top: 1px solid var(--line); }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg sticky-top site-nav">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center gap-2" href="${pageContext.request.contextPath}/index">
            <span class="brand-mark"><i class="bi bi-newspaper"></i></span>
            校园头条
        </a>
        <div class="collapse navbar-collapse">
            <ul class="navbar-nav me-auto ms-lg-3">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/index"><i class="bi bi-house-door me-1"></i>首页</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/video"><i class="bi bi-play-circle me-1"></i>视频</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/topic"><i class="bi bi-chat-square-text me-1"></i>话题</a></li>
            </ul>
            <ul class="navbar-nav align-items-center">
                <c:if test="${empty loginUser}">
                    <li class="nav-item"><a class="btn-login" href="${pageContext.request.contextPath}/login">登录</a></li>
                    <li class="nav-item ms-1"><a class="btn-register" href="${pageContext.request.contextPath}/register">注册</a></li>
                </c:if>
                <c:if test="${not empty loginUser}">
                    <li class="nav-item me-2">
                        <a class="user-chip d-inline-flex align-items-center gap-2" href="${pageContext.request.contextPath}/user/profile">
                            <c:choose>
                                <c:when test="${not empty loginUser.avatar}">
                                    <img class="nav-avatar" src="${pageContext.request.contextPath}${loginUser.avatar}" alt="头像">
                                </c:when>
                                <c:otherwise><span class="avatar-fallback">${fn:substring(loginUser.realName, 0, 1)}</span></c:otherwise>
                            </c:choose>
                            ${fn:escapeXml(loginUser.realName)}
                        </a>
                    </li>
                    <li class="nav-item"><a class="btn-login" href="${pageContext.request.contextPath}/user/logout">退出</a></li>
                </c:if>
            </ul>
        </div>
    </div>
</nav>

<div class="container" style="max-width: 920px;">
    <div class="crumb">
        <a href="${pageContext.request.contextPath}/index"><i class="bi bi-house-door"></i> 首页</a>
        <span class="mx-1">/</span>
        <a href="${pageContext.request.contextPath}/index?category=${news.category}">${news.category}</a>
        <span class="mx-1">/</span> 正文
    </div>

    <!-- ============ 正文 ============ -->
    <article class="article">
        <h1>${news.title}</h1>
        <div class="meta">
            <i class="bi bi-person"></i> ${news.author}
            <span class="ms-3">
                <c:choose>
                    <c:when test="${news.category == '校园通知'}"><span class="cat-badge cat-notice">校园通知</span></c:when>
                    <c:when test="${news.category == '校园活动'}"><span class="cat-badge cat-activity">校园活动</span></c:when>
                    <c:when test="${news.category == '学术动态'}"><span class="cat-badge cat-academic">学术动态</span></c:when>
                    <c:when test="${news.category == '校园风采'}"><span class="cat-badge cat-style">校园风采</span></c:when>
                    <c:otherwise><span class="cat-badge cat-notice">${news.category}</span></c:otherwise>
                </c:choose>
            </span>
            <span class="ms-3"><i class="bi bi-eye"></i> ${news.views} 次浏览</span>
            <span class="ms-3"><i class="bi bi-calendar3"></i> <fmt:formatDate value="${news.createTime}" pattern="yyyy-MM-dd HH:mm"/></span>
        </div>
        <div class="content">${news.content}</div>

        <div class="actions">
            <c:choose>
                <c:when test="${not empty loginUser}">
                    <a href="${pageContext.request.contextPath}/like/toggle?targetId=${news.id}&targetType=news"
                       class="action-btn like ${liked == 1 ? 'active' : ''}">
                        <i class="bi ${liked == 1 ? 'bi-heart-fill' : 'bi-heart'}"></i>
                        <span>点赞</span><b>${likeCount}</b>
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login" class="action-btn like">
                        <i class="bi bi-heart"></i><span>点赞</span><b>${likeCount}</b>
                    </a>
                </c:otherwise>
            </c:choose>
            <a href="#comments" class="action-btn">
                <i class="bi bi-chat-dots"></i><span>评论</span><b>${commentCount}</b>
            </a>
        </div>
    </article>

    <!-- ============ 评论区 ============ -->
    <section class="comments" id="comments">
        <h2>评论 <span class="num">${commentCount}</span></h2>
        <c:choose>
            <c:when test="${not empty loginUser}">
                <form class="comment-form" action="${pageContext.request.contextPath}/comment/add" method="post">
                    <input type="hidden" name="targetId" value="${news.id}">
                    <input type="hidden" name="targetType" value="news">
                    <textarea name="content" rows="3" maxlength="500" required placeholder="说点什么吧...（最多 500 字）"></textarea>
                    <div class="form-foot">
                        <span class="who"><i class="bi bi-person-circle me-1"></i>以 ${loginUser.realName} 的身份评论</span>
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
                            <strong>${cm.userName}</strong>
                            <c:if test="${cm.userRole == 'admin'}"><span class="badge-admin">管理员</span></c:if>
                            <span class="comment-time"><fmt:formatDate value="${cm.createTime}" pattern="yyyy-MM-dd HH:mm"/></span>
                        </div>
                        <p>${cm.content}</p>
                        <c:if test="${not empty loginUser and (loginUser.id == cm.userId or loginUser.role == 'admin')}">
                            <a class="comment-del"
                               href="${pageContext.request.contextPath}/comment/delete?id=${cm.id}&targetId=${news.id}&targetType=news"
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

<div class="footer">
    <div class="container d-flex justify-content-between flex-wrap">
        <span><i class="bi bi-newspaper me-1"></i>校园头条 · 校园新闻资讯系统</span>
        <span>SSM 框架课程设计</span>
    </div>
</div>

<script src="${pageContext.request.contextPath}/static/js/bootstrap.bundle.min.js"></script>
</body>
</html>
