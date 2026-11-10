<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>校园头条 - 校园新闻资讯系统</title>
    <link href="${pageContext.request.contextPath}/static/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            --brand:#00A86B; --brand-dark:#00875A; --brand-deep:#006B4F;
            --brand-soft:#E6F7F0; --brand-line:#CBEBDA;
            --line:#E5EBE7; --muted:#6B7280;
        }
        body {
            background: linear-gradient(180deg, #F4F7F5 0%, #EEF5F1 100%);
            min-height: 100vh;
            font-family: "Noto Sans SC", "Microsoft YaHei", "PingFang SC", system-ui, sans-serif;
            color: #1F2937;
        }
        .site-nav { background: rgba(255,255,255,.96); backdrop-filter: blur(10px); border-bottom: 1px solid var(--line); }
        .navbar-brand { font-weight: 800; color: #1F2937; }
        .brand-mark {
            width: 34px; height: 34px; border-radius: 10px; display: inline-flex;
            align-items: center; justify-content: center;
            background: linear-gradient(135deg, #00A86B, #16A095); color: #fff;
            box-shadow: 0 5px 12px rgba(0,168,107,.26);
        }
        .site-nav .nav-link { color: #374151; font-weight: 500; }
        .site-nav .nav-link:hover, .site-nav .nav-link.active { color: var(--brand); }
        .btn-login { color: var(--brand-dark); font-weight: 600; text-decoration: none; padding: 6px 14px; }
        .btn-login:hover { color: var(--brand); }
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
        /* ---------- Hero ---------- */
        .hero {
            position: relative; overflow: hidden;
            border-radius: 22px; padding: 38px 42px;
            background: linear-gradient(135deg, #006B4F 0%, #00A86B 58%, #16A095 100%);
            color: #fff; box-shadow: 0 18px 42px rgba(0,107,79,.24);
        }
        .hero::after {
            content: ""; position: absolute; width: 280px; height: 280px; border-radius: 50%;
            right: -70px; top: -130px; background: rgba(255,255,255,.10);
        }
        .hero .eyebrow { font-size: .78rem; letter-spacing: .22em; color: rgba(255,255,255,.65); font-weight: 600; }
        .hero h1 { font-weight: 800; margin: 6px 0 8px; }
        .hero .sub { color: rgba(255,255,255,.78); font-size: .92rem; margin-bottom: 22px; }
        .hero-search { display: flex; background: #fff; border-radius: 999px; padding: 5px; max-width: 520px; box-shadow: 0 8px 22px rgba(0,60,40,.18); }
        .hero-search input {
            border: 0; outline: 0; flex: 1; border-radius: 999px; padding: 8px 18px; font-size: .92rem;
            background: transparent; color: #1F2937;
        }
        .hero-search button {
            border: 0; border-radius: 999px; background: var(--brand); color: #fff;
            font-weight: 700; padding: 8px 26px; white-space: nowrap;
        }
        .hero-search button:hover { background: var(--brand-dark); }
        .hot-tags { margin-top: 16px; font-size: .8rem; color: rgba(255,255,255,.72); }
        .hot-tags a {
            display: inline-block; color: #fff; text-decoration: none;
            background: rgba(255,255,255,.16); border: 1px solid rgba(255,255,255,.22);
            border-radius: 999px; padding: 2px 12px; margin-left: 6px; font-size: .78rem;
        }
        .hot-tags a:hover { background: rgba(255,255,255,.28); }
        .stat-card {
            display: flex; align-items: center; gap: 12px;
            background: rgba(255,255,255,.12); border: 1px solid rgba(255,255,255,.18);
            border-radius: 14px; padding: 12px 16px; margin-bottom: 12px;
            color: #fff; text-decoration: none; transition: background .18s ease;
        }
        .stat-card:hover { background: rgba(255,255,255,.2); color: #fff; }
        .stat-card .ic {
            width: 38px; height: 38px; border-radius: 10px; flex: 0 0 auto;
            background: rgba(255,255,255,.18); display: grid; place-items: center; font-size: 1.05rem;
        }
        .stat-card .n { font-size: 1.25rem; font-weight: 800; line-height: 1.1; }
        .stat-card .t { font-size: .76rem; color: rgba(255,255,255,.75); }
        .stat-card .arr { margin-left: auto; color: rgba(255,255,255,.55); }
        /* ---------- 分类 Tab ---------- */
        .cat-tabs { display: flex; flex-wrap: wrap; gap: 10px; margin: 26px 0 20px; }
        .cat-tabs a {
            border-radius: 999px; padding: 7px 18px; font-size: .88rem; font-weight: 600;
            text-decoration: none; color: #374151; background: #fff; border: 1px solid var(--line);
        }
        .cat-tabs a:hover { border-color: var(--brand-line); color: var(--brand-dark); }
        .cat-tabs a.active { background: var(--brand); border-color: var(--brand); color: #fff; }
        /* ---------- 资讯列表 ---------- */
        .sec-title { font-weight: 800; font-size: 1.05rem; border-left: 4px solid var(--brand); padding-left: 10px; }
        .sec-more { color: var(--muted); font-size: .82rem; }
        .news-item {
            display: flex; gap: 16px; background: #fff; border: 1px solid var(--line);
            border-radius: 16px; padding: 16px 18px; margin-bottom: 14px;
            text-decoration: none; color: inherit; transition: border-color .18s ease, box-shadow .18s ease;
        }
        .news-item:hover { border-color: var(--brand-line); box-shadow: 0 10px 26px rgba(15,23,42,.07); color: inherit; }
        .news-cover {
            width: 132px; height: 98px; border-radius: 12px; object-fit: cover; flex: 0 0 auto;
        }
        .news-body { flex: 1; min-width: 0; }
        .news-title { font-weight: 700; font-size: 1.02rem; color: #1F2937; margin: 6px 0 5px; }
        .news-item:hover .news-title { color: var(--brand-dark); }
        .news-excerpt {
            color: var(--muted); font-size: .86rem; margin: 0;
            display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;
        }
        .news-meta { color: #94a3b8; font-size: .78rem; margin-top: 8px; }
        .news-views { color: #94a3b8; font-size: .78rem; white-space: nowrap; }
        .cat-badge { font-size: .72rem; font-weight: 600; border-radius: 6px; padding: 2px 9px; }
        .cat-notice  { background: #E6F7F0; color: #00875A; }
        .cat-activity{ background: #FFF3E6; color: #C2410C; }
        .cat-academic{ background: #E8F1FD; color: #1D5FD1; }
        .cat-style   { background: #F3E9FD; color: #7C3AED; }
        /* ---------- 侧边栏 ---------- */
        .side-card {
            background: #fff; border: 1px solid var(--line); border-radius: 16px;
            padding: 20px 22px; margin-bottom: 18px;
        }
        .side-card h6 { font-weight: 800; font-size: .95rem; margin-bottom: 14px; }
        .side-card h6 i { color: var(--brand); margin-right: 6px; }
        .side-card .side-link { font-size: .78rem; color: var(--muted); text-decoration: none; }
        .side-card .side-link:hover { color: var(--brand); }
        .hot-item { display: flex; gap: 10px; padding: 8px 0; text-decoration: none; color: inherit; }
        .hot-item .rank {
            width: 20px; height: 20px; border-radius: 6px; flex: 0 0 auto; margin-top: 1px;
            display: grid; place-items: center; font-size: .72rem; font-weight: 800;
            background: #F1F5F3; color: #94a3b8;
        }
        .hot-item:nth-child(-n+3) .rank { background: var(--brand); color: #fff; }
        .hot-item .hot-title {
            font-size: .86rem; font-weight: 600; color: #334155; line-height: 1.4;
            display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;
        }
        .hot-item:hover .hot-title { color: var(--brand-dark); }
        .hot-item .hot-views { margin-left: auto; color: #94a3b8; font-size: .75rem; white-space: nowrap; padding-left: 8px; }
        .latest-item { padding: 8px 0; border-bottom: 1px dashed #eef2f0; }
        .latest-item:last-child { border-bottom: 0; }
        .latest-item a {
            font-size: .87rem; font-weight: 600; color: #334155; text-decoration: none;
            display: block; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;
        }
        .latest-item a:hover { color: var(--brand-dark); }
        .latest-item .lm { color: #94a3b8; font-size: .75rem; margin-top: 2px; }
        .cta-card {
            border-radius: 16px; padding: 26px 24px; text-align: center; color: #fff;
            background: linear-gradient(135deg, #006B4F 0%, #00A86B 60%, #16A095 100%);
            box-shadow: 0 14px 30px rgba(0,107,79,.22); margin-bottom: 18px;
        }
        .cta-card .cta-ic {
            width: 46px; height: 46px; border-radius: 12px; margin: 0 auto 12px;
            background: rgba(255,255,255,.16); display: grid; place-items: center; font-size: 1.3rem;
        }
        .cta-card h6 { color: #fff; font-weight: 800; }
        .cta-card p { color: rgba(255,255,255,.78); font-size: .8rem; margin-bottom: 14px; }
        .cta-card .btn {
            background: #fff; color: var(--brand-dark); font-weight: 700;
            border-radius: 999px; padding: 7px 22px; font-size: .86rem;
        }
        .cta-card .btn:hover { color: var(--brand); }
        .cat-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; }
        .cat-grid a {
            display: flex; align-items: center; gap: 8px; padding: 10px 14px;
            background: #F7FAF8; border: 1px solid var(--line); border-radius: 10px;
            font-size: .84rem; font-weight: 600; color: #374151; text-decoration: none;
        }
        .cat-grid a:hover { border-color: var(--brand-line); color: var(--brand-dark); background: var(--brand-soft); }
        /* ---------- 分页 / 页脚 ---------- */
        .page-link { color: var(--brand-dark); border-radius: 8px; margin: 0 2px; }
        .page-item.active .page-link { background: var(--brand); border-color: var(--brand); color: #fff; }
        .footer {
            margin-top: 46px; padding: 22px 0; color: #94a3b8; font-size: .8rem;
            border-top: 1px solid var(--line);
        }
    </style>
</head>
<body>

<!-- ============ 导航栏 ============ -->
<nav class="navbar navbar-expand-lg sticky-top site-nav">
    <div class="container">
        <a class="navbar-brand d-flex align-items-center gap-2" href="${pageContext.request.contextPath}/index">
            <span class="brand-mark"><i class="bi bi-newspaper"></i></span>
            校园头条
        </a>
        <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navMenu">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navMenu">
            <ul class="navbar-nav me-auto ms-lg-3">
                <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/index"><i class="bi bi-house-door me-1"></i>首页</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/video"><i class="bi bi-play-circle me-1"></i>视频</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/topic"><i class="bi bi-chat-square-text me-1"></i>话题</a></li>
                <c:if test="${not empty loginUser}">
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/user/profile"><i class="bi bi-person me-1"></i>个人中心</a></li>
                </c:if>
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

<div class="container mt-4">

    <!-- ============ Hero + 统计 ============ -->
    <div class="hero">
        <div class="row align-items-center position-relative">
            <div class="col-lg-7">
                <div class="eyebrow">HI · CAMPUS HEADLINE</div>
                <h1>校园头条</h1>
                <p class="sub">聚焦校园新闻、活动通知与学术动态，做你身边的校园资讯站</p>
                <form class="hero-search" action="${pageContext.request.contextPath}/index" method="get">
                    <input type="text" name="keyword" placeholder="搜索你关心的校园新闻…" value="${keyword}">
                    <button type="submit"><i class="bi bi-search me-1"></i>搜索</button>
                </form>
                <div class="hot-tags">
                    热门搜索：
                    <a href="${pageContext.request.contextPath}/index?keyword=开学">开学</a>
                    <a href="${pageContext.request.contextPath}/index?keyword=运动会">运动会</a>
                    <a href="${pageContext.request.contextPath}/index?keyword=讲座">讲座</a>
                    <a href="${pageContext.request.contextPath}/index?keyword=社团">社团</a>
                </div>
            </div>
            <div class="col-lg-5 mt-4 mt-lg-0">
                <a class="stat-card" href="${pageContext.request.contextPath}/index">
                    <span class="ic"><i class="bi bi-newspaper"></i></span>
                    <span><span class="n">${page.total}</span> <span class="t">篇<br>校园新闻</span></span>
                    <span class="arr"><i class="bi bi-chevron-right"></i></span>
                </a>
                <a class="stat-card" href="${pageContext.request.contextPath}/video">
                    <span class="ic"><i class="bi bi-play-circle"></i></span>
                    <span><span class="n">${videoTotal}</span> <span class="t">个<br>校园视频</span></span>
                    <span class="arr"><i class="bi bi-chevron-right"></i></span>
                </a>
                <a class="stat-card" href="${pageContext.request.contextPath}/topic" style="margin-bottom:0;">
                    <span class="ic"><i class="bi bi-chat-square-text"></i></span>
                    <span><span class="n">${topicTotal}</span> <span class="t">个<br>讨论话题</span></span>
                    <span class="arr"><i class="bi bi-chevron-right"></i></span>
                </a>
            </div>
        </div>
    </div>

    <!-- ============ 分类筛选 ============ -->
    <div class="cat-tabs">
        <a href="${pageContext.request.contextPath}/index" class="${empty category ? 'active' : ''}"><i class="bi bi-grid me-1"></i>全部</a>
        <a href="${pageContext.request.contextPath}/index?category=校园通知" class="${category=='校园通知' ? 'active' : ''}"><i class="bi bi-megaphone me-1"></i>校园通知</a>
        <a href="${pageContext.request.contextPath}/index?category=校园活动" class="${category=='校园活动' ? 'active' : ''}"><i class="bi bi-calendar-event me-1"></i>校园活动</a>
        <a href="${pageContext.request.contextPath}/index?category=学术动态" class="${category=='学术动态' ? 'active' : ''}"><i class="bi bi-book me-1"></i>学术动态</a>
        <a href="${pageContext.request.contextPath}/index?category=校园风采" class="${category=='校园风采' ? 'active' : ''}"><i class="bi bi-stars me-1"></i>校园风采</a>
    </div>

    <div class="row g-4">
        <!-- ============ 最新资讯 ============ -->
        <div class="col-lg-8">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <div class="sec-title">最新资讯</div>
                <div class="sec-more">共 ${page.total} 条</div>
            </div>

            <c:forEach var="news" items="${page.records}">
                <a href="${pageContext.request.contextPath}/detail?id=${news.id}" class="news-item">
                    <c:choose>
                        <c:when test="${not empty news.cover}">
                            <img class="news-cover" src="${pageContext.request.contextPath}${news.cover}" alt="">
                        </c:when>
                        <c:when test="${news.category == '校园通知'}">
                            <img class="news-cover" src="${pageContext.request.contextPath}/images/default-notice.jpg" alt="">
                        </c:when>
                        <c:when test="${news.category == '校园活动'}">
                            <img class="news-cover" src="${pageContext.request.contextPath}/images/default-activity.jpg" alt="">
                        </c:when>
                        <c:when test="${news.category == '学术动态'}">
                            <img class="news-cover" src="${pageContext.request.contextPath}/images/default-academic.jpg" alt="">
                        </c:when>
                        <c:when test="${news.category == '校园风采'}">
                            <img class="news-cover" src="${pageContext.request.contextPath}/images/default-campus.jpg" alt="">
                        </c:when>
                        <c:otherwise>
                            <img class="news-cover" src="${pageContext.request.contextPath}/images/default-news.jpg" alt="">
                        </c:otherwise>
                    </c:choose>
                    <div class="news-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <c:choose>
                                <c:when test="${news.category == '校园通知'}"><span class="cat-badge cat-notice">校园通知</span></c:when>
                                <c:when test="${news.category == '校园活动'}"><span class="cat-badge cat-activity">校园活动</span></c:when>
                                <c:when test="${news.category == '学术动态'}"><span class="cat-badge cat-academic">学术动态</span></c:when>
                                <c:when test="${news.category == '校园风采'}"><span class="cat-badge cat-style">校园风采</span></c:when>
                                <c:otherwise><span class="cat-badge cat-notice">${news.category}</span></c:otherwise>
                            </c:choose>
                            <span class="news-views"><i class="bi bi-eye"></i> ${news.views}</span>
                        </div>
                        <div class="news-title">${news.title}</div>
                        <p class="news-excerpt">
                            <c:choose>
                                <c:when test="${fn:length(news.content) > 90}">${fn:substring(news.content, 0, 90)}…</c:when>
                                <c:otherwise>${news.content}</c:otherwise>
                            </c:choose>
                        </p>
                        <div class="news-meta">
                            <i class="bi bi-person"></i> ${news.author}
                            <span class="ms-3"><i class="bi bi-calendar3"></i> <fmt:formatDate value="${news.createTime}" pattern="yyyy-MM-dd"/></span>
                        </div>
                    </div>
                </a>
            </c:forEach>

            <c:if test="${empty page.records}">
                <div class="text-center py-5 text-muted">
                    <i class="bi bi-inbox display-4 d-block mb-3"></i>
                    暂无新闻，换个关键词或分类试试
                </div>
            </c:if>

            <!-- 分页 -->
            <c:if test="${page.pages > 1}">
                <nav class="d-flex justify-content-center mt-4">
                    <ul class="pagination mb-0">
                        <li class="page-item ${page.current == 1 ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/index?current=${page.current-1}&keyword=${keyword}&category=${category}">上一页</a>
                        </li>
                        <c:forEach begin="1" end="${page.pages}" var="i">
                            <li class="page-item ${page.current == i ? 'active' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/index?current=${i}&keyword=${keyword}&category=${category}">${i}</a>
                            </li>
                        </c:forEach>
                        <li class="page-item ${page.current == page.pages ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/index?current=${page.current+1}&keyword=${keyword}&category=${category}">下一页</a>
                        </li>
                    </ul>
                </nav>
            </c:if>
        </div>

        <!-- ============ 侧边栏 ============ -->
        <div class="col-lg-4">
            <div class="side-card">
                <div class="d-flex justify-content-between align-items-center">
                    <h6 class="mb-0"><i class="bi bi-fire" style="color:#E8590C;"></i>热门新闻</h6>
                    <span class="side-link">TOP 5</span>
                </div>
                <div class="mt-2">
                    <c:forEach var="h" items="${hotNews}" varStatus="s">
                        <a class="hot-item" href="${pageContext.request.contextPath}/detail?id=${h.id}">
                            <span class="rank">${s.index + 1}</span>
                            <span class="hot-title">${h.title}</span>
                            <span class="hot-views"><i class="bi bi-eye"></i> ${h.views}</span>
                        </a>
                    </c:forEach>
                </div>
            </div>

            <div class="side-card">
                <div class="d-flex justify-content-between align-items-center">
                    <h6 class="mb-0"><i class="bi bi-clock-history"></i>最新发布</h6>
                    <a class="side-link" href="${pageContext.request.contextPath}/index">查看全部</a>
                </div>
                <div class="mt-2">
                    <c:forEach var="l" items="${latestNews}">
                        <div class="latest-item">
                            <a href="${pageContext.request.contextPath}/detail?id=${l.id}">${l.title}</a>
                            <div class="lm"><fmt:formatDate value="${l.createTime}" pattern="MM-dd HH:mm"/> · ${l.category}</div>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <div class="cta-card">
                <div class="cta-ic"><i class="bi bi-pencil-square"></i></div>
                <h6>有校园新鲜事分享？</h6>
                <p>登录后即可投稿，审核通过后展示在首页</p>
                <a class="btn" href="${pageContext.request.contextPath}${empty loginUser ? '/login' : '/user/profile'}">
                    <i class="bi bi-heart me-1"></i>我要投稿
                </a>
            </div>

            <div class="side-card">
                <h6><i class="bi bi-grid"></i>分类频道</h6>
                <div class="cat-grid">
                    <a href="${pageContext.request.contextPath}/index?category=校园通知"><i class="bi bi-megaphone" style="color:var(--brand);"></i>校园通知</a>
                    <a href="${pageContext.request.contextPath}/index?category=校园活动"><i class="bi bi-calendar-event" style="color:#C2410C;"></i>校园活动</a>
                    <a href="${pageContext.request.contextPath}/index?category=学术动态"><i class="bi bi-book" style="color:#1D5FD1;"></i>学术动态</a>
                    <a href="${pageContext.request.contextPath}/index?category=校园风采"><i class="bi bi-stars" style="color:#7C3AED;"></i>校园风采</a>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- ============ 页脚 ============ -->
<div class="footer">
    <div class="container d-flex justify-content-between flex-wrap">
        <span><i class="bi bi-newspaper me-1"></i>校园头条 · 校园新闻资讯系统</span>
        <span>SSM 框架课程设计 · Spring 6 + SpringMVC + MyBatis-Plus</span>
    </div>
</div>

<script src="${pageContext.request.contextPath}/static/js/bootstrap.bundle.min.js"></script>
</body>
</html>
