<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%-- 直接访问 topic.jsp 时没有 page 数据，跳转到 Controller 统一处理 --%>
<c:if test="${empty page}"><c:redirect url="/topic"/></c:if>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>话题广场 - 校园头条</title>
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
            width: 38px; height: 38px; border-radius: 11px;
            background: linear-gradient(135deg, #00A86B, #16A095);
            display: inline-grid; place-items: center; color: #fff; font-size: 1.05rem;
            box-shadow: 0 6px 14px rgba(0,168,107,.28);
        }
        .navbar-brand { font-weight: 800; color: var(--ink); }
        .site-nav .nav-link { color: #374151; font-weight: 500; }
        .site-nav .nav-link:hover, .site-nav .nav-link.active { color: var(--brand); }
        .user-chip { color: #4B5563; font-size: .9rem; text-decoration: none; }
        .user-chip:hover { color: var(--brand); }
        .nav-avatar { width: 30px; height: 30px; border-radius: 50%; object-fit: cover; border: 2px solid var(--brand-line); }
        .avatar-fallback {
            width: 30px; height: 30px; border-radius: 50%; display: inline-flex;
            align-items: center; justify-content: center;
            background: var(--brand-soft); color: var(--brand-dark); font-weight: 700; font-size: .82rem;
        }
        .btn-brand { background: var(--brand); border: 1px solid var(--brand); color: #fff; font-weight: 600; border-radius: 999px; }
        .btn-brand:hover { background: var(--brand-dark); border-color: var(--brand-dark); color: #fff; }
        .btn-outline-brand { color: var(--brand-dark); border: 1px solid var(--brand-line); font-weight: 600; border-radius: 999px; background: #fff; }
        .btn-outline-brand:hover { background: var(--brand); border-color: var(--brand); color: #fff; }

        .page-head { margin: 28px 0 20px; display: flex; align-items: baseline; justify-content: space-between; }
        .page-head h1 { font-size: 1.5rem; font-weight: 800; margin: 0; }
        .page-head h1::before {
            content: ""; display: inline-block; width: 5px; height: 20px; border-radius: 3px;
            background: var(--brand); margin-right: 10px; vertical-align: -3px;
        }
        .page-head .hint { color: #9CA3AF; font-size: .84rem; }

        .topic-card {
            display: flex; gap: 16px; background: #fff; border: 1px solid var(--line);
            border-radius: 14px; padding: 20px 22px; text-decoration: none; color: inherit;
            transition: transform .2s ease, box-shadow .2s ease, border-color .2s ease;
        }
        .topic-card:hover { transform: translateY(-2px); border-color: var(--brand-line); box-shadow: 0 12px 28px rgba(15,23,42,.08); }
        .topic-icon {
            flex: 0 0 auto; width: 48px; height: 48px; border-radius: 13px;
            display: grid; place-items: center; font-size: 1.25rem; color: #fff;
            background: linear-gradient(135deg, #00A86B, #16A095);
        }
        .topic-icon.t2 { background: linear-gradient(135deg, #0E7490, #22D3EE); }
        .topic-icon.t3 { background: linear-gradient(135deg, #F97316, #FBBF77); }
        .topic-icon.t4 { background: linear-gradient(135deg, #00875A, #4FD1A5); }
        .topic-body { flex: 1 1 auto; min-width: 0; }
        .topic-body h3 { font-size: 1.02rem; font-weight: 700; margin: 0 0 6px; }
        .topic-body h3 .hash { color: var(--brand); margin-right: 4px; }
        .topic-card:hover h3 { color: var(--brand-dark); }
        .topic-body p {
            margin: 0 0 10px; color: var(--muted); font-size: .87rem; line-height: 1.7;
            display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;
        }
        .topic-meta { display: flex; align-items: center; gap: 14px; color: #9CA3AF; font-size: .76rem; }
        .topic-meta i { margin-right: 3px; }

        .publish-card, .side-card { background: #fff; border: 1px solid var(--line); border-radius: 16px; padding: 20px; }
        .publish-card h3, .side-card h3 { font-size: 1rem; font-weight: 800; margin: 0 0 14px; }
        .publish-card h3 i, .side-card h3 i { color: var(--brand); margin-right: 6px; }
        .form-control { border-radius: 10px; border-color: #DDE7E1; background: #FBFDFC; font-size: .9rem; }
        .form-control:focus { border-color: #6FD3A9; box-shadow: 0 0 0 3px rgba(0,168,107,.12); background: #fff; }
        .login-tip {
            background: #F7FBF9; border: 1px dashed var(--brand-line); border-radius: 12px;
            padding: 16px; text-align: center; color: #6B7280; font-size: .88rem;
        }
        .login-tip a { color: var(--brand-dark); font-weight: 600; text-decoration: none; }

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
        .page-link { color: var(--brand-dark); border-color: var(--line); border-radius: 9px !important; margin: 0 3px; }
        .page-item.active .page-link { background: var(--brand); border-color: var(--brand); }
        .site-footer { margin-top: 48px; border-top: 1px solid var(--line); background: #fff; }
        .site-footer .inner {
            max-width: 1140px; margin: 0 auto; padding: 22px 16px;
            display: flex; flex-wrap: wrap; gap: 8px; justify-content: space-between;
            color: var(--muted); font-size: .84rem;
        }
        .empty-state { text-align: center; padding: 60px 16px; color: #9CA3AF; background: #fff; border: 1px solid var(--line); border-radius: 14px; }
        @media (max-width: 991px) { .side-sticky { position: static; } }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg sticky-top site-nav">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center gap-2" href="${pageContext.request.contextPath}/index">
            <span class="brand-mark"><i class="bi bi-newspaper"></i></span>校园头条
        </a>
        <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navMenu">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navMenu">
            <ul class="navbar-nav me-auto ms-lg-3">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/index"><i class="bi bi-house-door me-1"></i>首页</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/video"><i class="bi bi-play-circle me-1"></i>视频</a></li>
                <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/topic"><i class="bi bi-chat-square-text me-1"></i>话题</a></li>
                <c:if test="${not empty loginUser}">
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/user/profile"><i class="bi bi-person-gear me-1"></i>个人中心</a></li>
                </c:if>
            </ul>
            <ul class="navbar-nav align-items-lg-center gap-lg-2">
                <c:choose>
                    <c:when test="${not empty loginUser}">
                        <li class="nav-item">
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
                        <li class="nav-item"><a class="btn btn-outline-brand btn-sm px-3" href="${pageContext.request.contextPath}/user/logout"><i class="bi bi-box-arrow-right me-1"></i>退出</a></li>
                    </c:when>
                    <c:otherwise>
                        <li class="nav-item"><a class="btn btn-outline-brand btn-sm px-3" href="${pageContext.request.contextPath}/login">登录</a></li>
                        <li class="nav-item"><a class="btn btn-brand btn-sm px-3" href="${pageContext.request.contextPath}/register">注册</a></li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</nav>

<div class="container">
    <div class="page-head">
        <h1>话题广场</h1>
        <span class="hint">共 ${page.total} 个话题</span>
    </div>

    <c:if test="${not empty successMsg}">
        <div class="alert alert-success alert-dismissible fade show" style="border-radius:10px">
            <i class="bi bi-check-circle me-1"></i>${successMsg}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>
    <c:if test="${not empty errorMsg}">
        <div class="alert alert-danger alert-dismissible fade show" style="border-radius:10px">
            <i class="bi bi-exclamation-circle me-1"></i>${errorMsg}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <div class="row g-4">
        <div class="col-lg-8">
            <div class="d-flex flex-column gap-3">
                <c:forEach var="t" items="${page.records}" varStatus="st">
                    <a href="${pageContext.request.contextPath}/topic/detail?id=${t.id}" class="topic-card">
                        <div class="topic-icon t${st.index % 4 + 1}"><i class="bi bi-hash"></i></div>
                        <div class="topic-body">
                            <h3><span class="hash">#</span>${fn:escapeXml(t.title)}</h3>
                            <p>${fn:escapeXml(t.content)}</p>
                            <div class="topic-meta">
                                <span><i class="bi bi-person"></i>${fn:escapeXml(t.author)}</span>
                                <span><i class="bi bi-eye"></i>${t.views}</span>
                                <span><i class="bi bi-calendar3"></i><fmt:formatDate value="${t.createTime}" pattern="yyyy-MM-dd"/></span>
                            </div>
                        </div>
                    </a>
                </c:forEach>

                <c:if test="${empty page.records}">
                    <div class="empty-state">
                        <i class="bi bi-chat-square-text" style="font-size:3rem;color:#D1D5DB"></i>
                        <h5 class="mt-3" style="color:#4B5563">暂无话题</h5>
                        <p class="mb-0" style="font-size:.9rem">来发起第一个话题吧</p>
                    </div>
                </c:if>
            </div>

            <c:if test="${page.pages > 1}">
                <nav class="mt-4" aria-label="分页导航">
                    <ul class="pagination justify-content-center">
                        <li class="page-item ${page.current le 1 ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/topic?current=${page.current - 1}">上一页</a>
                        </li>
                        <c:forEach begin="1" end="${page.pages}" var="i">
                            <li class="page-item ${page.current == i ? 'active' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/topic?current=${i}">${i}</a>
                            </li>
                        </c:forEach>
                        <li class="page-item ${page.current ge page.pages ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/topic?current=${page.current + 1}">下一页</a>
                        </li>
                    </ul>
                </nav>
            </c:if>
        </div>

        <aside class="col-lg-4">
            <div class="side-sticky">
                <div class="publish-card mb-4">
                    <h3><i class="bi bi-megaphone"></i>发起话题</h3>
                    <c:choose>
                        <c:when test="${not empty loginUser}">
                            <form action="${pageContext.request.contextPath}/topic/add" method="post">
                                <div class="mb-3">
                                    <input type="text" class="form-control" name="title" maxlength="100" required placeholder="话题标题，如：期末复习互助打卡">
                                </div>
                                <div class="mb-3">
                                    <textarea class="form-control" name="content" rows="4" maxlength="1000" required placeholder="说点什么，引导大家一起讨论..."></textarea>
                                </div>
                                <button type="submit" class="btn btn-brand w-100"><i class="bi bi-send me-1"></i>发布话题</button>
                            </form>
                        </c:when>
                        <c:otherwise>
                            <div class="login-tip">
                                <i class="bi bi-lock me-1"></i>登录后即可发起话题<br>
                                <a href="${pageContext.request.contextPath}/login">去登录</a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

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
                        <c:if test="${empty hotTopics}">
                            <li><span class="views-mini">暂无话题数据</span></li>
                        </c:if>
                    </ol>
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
