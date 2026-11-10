<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>个人中心 - 校园头条</title>
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
        .user-chip { color: #4B5563; font-size: .9rem; text-decoration: none; }
        .nav-avatar { width: 30px; height: 30px; border-radius: 50%; object-fit: cover; border: 2px solid var(--brand-line); }
        .avatar-fallback {
            width: 30px; height: 30px; border-radius: 50%; display: inline-flex;
            align-items: center; justify-content: center;
            background: var(--brand-soft); color: var(--brand-dark); font-weight: 700; font-size: .82rem;
        }
        .role-badge {
            font-size: .68rem; padding: 2px 8px; border-radius: 999px;
            background: var(--brand-soft); color: var(--brand-dark); font-weight: 700;
        }
        .role-badge.admin { background: #FFF3E6; color: #C2410C; }
        .btn-outline-brand {
            color: var(--brand-dark); border: 1px solid var(--brand-line);
            font-weight: 600; border-radius: 999px; background: #fff;
        }
        .btn-outline-brand:hover { background: var(--brand); border-color: var(--brand); color: #fff; }
        .profile-hero {
            position: relative; overflow: hidden;
            border-radius: 22px; padding: 34px 40px;
            background: linear-gradient(135deg, #006B4F 0%, #00A86B 58%, #16A095 100%);
            color: #fff; box-shadow: 0 18px 42px rgba(0,107,79,.24);
        }
        .profile-hero::after {
            content: ""; position: absolute; width: 260px; height: 260px; border-radius: 50%;
            right: -70px; top: -120px; background: rgba(255,255,255,.10);
        }
        .avatar-wrap { position: relative; width: 96px; height: 96px; flex: 0 0 auto; cursor: pointer; }
        .profile-avatar {
            width: 96px; height: 96px; border-radius: 50%; object-fit: cover;
            border: 4px solid rgba(255,255,255,.85); background: #fff;
            box-shadow: 0 10px 26px rgba(15,23,42,.25);
        }
        .profile-avatar-fallback {
            width: 96px; height: 96px; border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            background: rgba(255,255,255,.94); color: var(--brand-dark);
            font-size: 2.2rem; font-weight: 800;
            border: 4px solid rgba(255,255,255,.85);
        }
        .avatar-mask {
            position: absolute; inset: 0; border-radius: 50%;
            background: rgba(0,0,0,.42); color: #fff;
            display: grid; place-items: center; font-size: .78rem; font-weight: 600;
            opacity: 0; transition: opacity .18s ease;
        }
        .avatar-wrap:hover .avatar-mask { opacity: 1; }
        .avatar-cam {
            position: absolute; right: -2px; bottom: -2px;
            width: 30px; height: 30px; border-radius: 50%;
            background: #fff; color: var(--brand-dark);
            display: grid; place-items: center; font-size: .82rem;
            box-shadow: 0 3px 10px rgba(15,23,42,.28);
            border: 2px solid rgba(255,255,255,.9);
        }
        .profile-hero h2 { font-weight: 800; margin: 0 0 4px; }
        .profile-hero .sub { color: rgba(255,255,255,.75); font-size: .9rem; }
        .stat-box {
            background: rgba(255,255,255,.12); border: 1px solid rgba(255,255,255,.18);
            border-radius: 14px; padding: 12px 18px; min-width: 92px; text-align: center;
        }
        .stat-box .n { font-size: 1.4rem; font-weight: 800; line-height: 1.1; }
        .stat-box .t { font-size: .76rem; color: rgba(255,255,255,.76); margin-top: 4px; }
        .panel {
            background: #fff; border: 1px solid var(--line); border-radius: 18px;
            padding: 26px 28px; box-shadow: 0 10px 28px rgba(15,23,42,.06);
        }
        .panel h5 { font-weight: 800; font-size: 1.02rem; margin: 0 0 18px; }
        .panel h5 i { color: var(--brand); margin-right: 6px; }
        .form-label { font-weight: 600; font-size: .85rem; }
        .form-control { border-radius: 10px; padding: 9px 13px; border-color: #DDE7E1; background: #FBFDFC; }
        .form-control:focus { border-color: #6FD3A9; box-shadow: 0 0 0 3px rgba(0,168,107,.12); background: #fff; }
        .btn-brand { background: var(--brand); border: 0; color: #fff; border-radius: 10px; font-weight: 600; }
        .btn-brand:hover { background: var(--brand-dark); color: #fff; }
        .btn-outline-primary {
            --bs-btn-color: var(--brand-dark); --bs-btn-border-color: var(--brand-line);
            --bs-btn-hover-bg: var(--brand); --bs-btn-hover-border-color: var(--brand);
            --bs-btn-hover-color: #fff; --bs-btn-active-bg: var(--brand-dark);
            font-weight: 600;
        }
        .nav-pills .nav-link { color: #475569; border-radius: 999px; font-weight: 600; font-size: .9rem; padding: 8px 18px; }
        .nav-pills .nav-link.active { background: var(--brand); color: #fff; }
        .record-item {
            border: 1px solid #eef2f7; border-radius: 14px; padding: 16px 18px;
            margin-bottom: 12px; background: #fff; transition: border-color .18s ease;
        }
        .record-item:hover { border-color: var(--brand-line); background: #FCFEFD; }
        .record-item .title { font-weight: 700; color: #1F2937; text-decoration: none; }
        .record-item .title:hover { color: var(--brand); }
        .record-item .meta { color: #94a3b8; font-size: .8rem; margin-top: 4px; }
        .record-item .content { color: #475569; font-size: .9rem; margin-top: 8px; }
        .badge-status { font-size: .72rem; font-weight: 600; }
        .publish-group-title {
            display: flex; align-items: center; gap: 8px;
            font-size: .92rem; font-weight: 800; color: #1F2937;
            margin: 4px 0 12px;
        }
        .publish-group-title i { color: var(--brand); }
        .publish-group-title .cnt {
            font-size: .74rem; font-weight: 700; color: var(--brand-dark);
            background: var(--brand-soft); border-radius: 999px; padding: 1px 9px;
        }
        .publish-group + .publish-group { margin-top: 22px; padding-top: 20px; border-top: 1px dashed var(--line); }
        .empty-mini { text-align: center; color: #94a3b8; padding: 34px 10px; font-size: .9rem; }
        .empty-mini i { display: block; font-size: 2rem; color: #cbd5e1; margin-bottom: 8px; }
        .alert { border-radius: 12px; font-size: .9rem; }
        /* ---------- 账号设置弹窗 ---------- */
        .settings-modal .modal-content { border: 0; border-radius: 18px; overflow: hidden; }
        .settings-modal .modal-header {
            background: linear-gradient(135deg, #006B4F, #00A86B); color: #fff;
            border: 0; padding: 18px 24px;
        }
        .settings-modal .modal-title { font-weight: 800; font-size: 1.05rem; }
        .settings-modal .btn-close { filter: brightness(0) invert(1); }
        .settings-modal .modal-body { padding: 22px 24px 26px; }
        .settings-modal .nav-pills { border-bottom: 1px solid var(--line); padding-bottom: 12px; margin-bottom: 18px; }
    </style>
</head>
<body>

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
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/index"><i class="bi bi-house-door me-1"></i>首页</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/video"><i class="bi bi-play-circle me-1"></i>视频</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/topic"><i class="bi bi-chat-square-text me-1"></i>话题</a></li>
                <c:if test="${loginUser.role == 'admin'}">
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/news/list"><i class="bi bi-speedometer2 me-1"></i>管理后台</a></li>
                    <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/material/list"><i class="bi bi-images me-1"></i>素材库</a></li>
                </c:if>
                <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/user/profile"><i class="bi bi-person-gear me-1"></i>个人中心</a></li>
            </ul>
            <ul class="navbar-nav align-items-lg-center gap-lg-2">
                <li class="nav-item">
                    <a class="user-chip d-inline-flex align-items-center gap-2" href="${pageContext.request.contextPath}/user/profile">
                        <c:choose>
                            <c:when test="${not empty loginUser.avatar}">
                                <img class="nav-avatar" src="${pageContext.request.contextPath}${loginUser.avatar}" alt="头像">
                            </c:when>
                            <c:otherwise>
                                <span class="avatar-fallback">${fn:substring(loginUser.realName, 0, 1)}</span>
                            </c:otherwise>
                        </c:choose>
                        ${fn:escapeXml(loginUser.realName)}
                        <span class="role-badge ${loginUser.role == 'admin' ? 'admin' : ''}">${loginUser.role == 'admin' ? '管理员' : '用户'}</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="btn btn-outline-brand btn-sm px-3" href="${pageContext.request.contextPath}/user/logout">
                        <i class="bi bi-box-arrow-right me-1"></i>退出
                    </a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<div class="container py-4">

    <c:if test="${not empty msg}">
        <div class="alert alert-success d-flex align-items-center gap-2">
            <i class="bi bi-check-circle-fill"></i> ${fn:escapeXml(msg)}
        </div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger d-flex align-items-center gap-2">
            <i class="bi bi-exclamation-circle-fill"></i> ${fn:escapeXml(error)}
        </div>
    </c:if>

    <!-- ============ 个人信息横幅 ============ -->
    <section class="profile-hero mb-4">
        <div class="row align-items-center g-4 position-relative" style="z-index:1">
            <div class="col-lg-7 d-flex align-items-center gap-4">
                <div class="avatar-wrap" title="点击更换头像" onclick="document.getElementById('avatarInput').click()">
                    <c:choose>
                        <c:when test="${not empty loginUser.avatar}">
                            <img class="profile-avatar" src="${pageContext.request.contextPath}${loginUser.avatar}" alt="头像">
                        </c:when>
                        <c:otherwise>
                            <div class="profile-avatar-fallback">${fn:substring(loginUser.realName, 0, 1)}</div>
                        </c:otherwise>
                    </c:choose>
                    <div class="avatar-mask">更换头像</div>
                    <span class="avatar-cam"><i class="bi bi-camera-fill"></i></span>
                </div>
                <form id="avatarForm" action="${pageContext.request.contextPath}/user/profile/avatar" method="post" enctype="multipart/form-data" class="d-none">
                    <input type="file" id="avatarInput" name="avatarFile" accept="image/jpeg,image/png,image/gif,image/webp"
                           onchange="if(this.files.length){document.getElementById('avatarForm').submit();}">
                </form>
                <div>
                    <h2>${fn:escapeXml(loginUser.realName)}</h2>
                    <div class="sub">
                        @${fn:escapeXml(loginUser.username)}
                        <span class="role-badge ${loginUser.role == 'admin' ? 'admin' : ''} ms-2">${loginUser.role == 'admin' ? '管理员' : '普通用户'}</span>
                    </div>
                    <div class="mt-3 d-flex flex-wrap gap-2">
                        <a href="${pageContext.request.contextPath}/user/profile/publish" class="btn btn-light btn-sm rounded-pill px-3 fw-semibold">
                            <i class="bi bi-pencil-square me-1"></i>发表新闻
                        </a>
                        <button type="button" class="btn btn-light btn-sm rounded-pill px-3 fw-semibold" data-bs-toggle="modal" data-bs-target="#videoModal">
                            <i class="bi bi-play-circle me-1"></i>发布视频
                        </button>
                        <button type="button" class="btn btn-outline-light btn-sm rounded-pill px-3" data-bs-toggle="modal" data-bs-target="#settingsModal">
                            <i class="bi bi-gear me-1"></i>账号设置
                        </button>
                        <c:if test="${loginUser.role == 'admin'}">
                            <a href="${pageContext.request.contextPath}/news/list" class="btn btn-outline-light btn-sm rounded-pill px-3">
                                <i class="bi bi-speedometer2 me-1"></i>进入后台
                            </a>
                        </c:if>
                    </div>
                </div>
            </div>
            <div class="col-lg-5">
                <div class="d-flex flex-wrap gap-2 justify-content-lg-end">
                    <div class="stat-box"><div class="n">${publishTotal}</div><div class="t">我的发布</div></div>
                    <div class="stat-box"><div class="n">${commentTotal}</div><div class="t">我的评论</div></div>
                    <div class="stat-box"><div class="n">${likeTotal}</div><div class="t">我的点赞</div></div>
                </div>
            </div>
        </div>
    </section>

    <!-- ============ 我的记录 ============ -->
    <div class="panel">
                <ul class="nav nav-pills gap-2 mb-4" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active" data-bs-toggle="pill" data-bs-target="#tab-news" type="button" role="tab">
                            我的发布 <span class="badge bg-light text-dark ms-1">${publishTotal}</span>
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" data-bs-toggle="pill" data-bs-target="#tab-comments" type="button" role="tab">
                            我的评论 <span class="badge bg-light text-dark ms-1">${commentTotal}</span>
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" data-bs-toggle="pill" data-bs-target="#tab-likes" type="button" role="tab">
                            我的点赞 <span class="badge bg-light text-dark ms-1">${likeTotal}</span>
                        </button>
                    </li>
                </ul>

                <div class="tab-content">
                    <!-- 我的发布：新闻 / 话题 / 视频 -->
                    <div class="tab-pane fade show active" id="tab-news" role="tabpanel">

                        <%-- ===== 新闻 ===== --%>
                        <c:if test="${not empty myNews}">
                            <div class="publish-group">
                                <div class="publish-group-title">
                                    <i class="bi bi-file-earmark-text"></i> 新闻
                                    <span class="cnt">${newsTotal}</span>
                                </div>
                                <c:forEach var="n" items="${myNews}">
                                    <div class="record-item">
                                        <div class="d-flex justify-content-between align-items-start gap-3">
                                            <a class="title" href="${pageContext.request.contextPath}/detail?id=${n.id}">${fn:escapeXml(n.title)}</a>
                                            <div class="d-flex align-items-center gap-2">
                                                <c:choose>
                                                    <c:when test="${n.status == 0}"><span class="badge bg-secondary badge-status">草稿</span></c:when>
                                                    <c:when test="${n.status == 1}"><span class="badge bg-warning text-dark badge-status">待审核</span></c:when>
                                                    <c:when test="${n.status == 2}"><span class="badge bg-success badge-status">已审核</span></c:when>
                                                    <c:when test="${n.status == 3}"><span class="badge bg-danger badge-status">已驳回</span></c:when>
                                                </c:choose>
                                                <a href="${pageContext.request.contextPath}/user/profile/news/delete?id=${n.id}"
                                                   class="btn btn-sm btn-outline-danger rounded-pill px-3"
                                                   onclick="return confirm('确定删除这条新闻吗？')">删除</a>
                                            </div>
                                        </div>
                                        <div class="meta">
                                            <span class="me-3"><i class="bi bi-tag"></i> ${fn:escapeXml(n.category)}</span>
                                            <span class="me-3"><i class="bi bi-eye"></i> ${n.views}</span>
                                            <span><fmt:formatDate value="${n.createTime}" pattern="yyyy-MM-dd HH:mm"/></span>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:if>

                        <%-- ===== 话题 ===== --%>
                        <c:if test="${not empty myTopics}">
                            <div class="publish-group">
                                <div class="publish-group-title">
                                    <i class="bi bi-chat-square-text"></i> 话题
                                    <span class="cnt">${topicTotal}</span>
                                </div>
                                <c:forEach var="t" items="${myTopics}">
                                    <div class="record-item">
                                        <div class="d-flex justify-content-between align-items-start gap-3">
                                            <a class="title" href="${pageContext.request.contextPath}/topic/detail?id=${t.id}">#${fn:escapeXml(t.title)}#</a>
                                            <a href="${pageContext.request.contextPath}/user/profile/topic/delete?id=${t.id}"
                                               class="btn btn-sm btn-outline-danger rounded-pill px-3"
                                               onclick="return confirm('确定删除这个话题吗？')">删除</a>
                                        </div>
                                        <div class="content">${fn:escapeXml(t.content)}</div>
                                        <div class="meta">
                                            <span class="me-3"><i class="bi bi-eye"></i> ${t.views}</span>
                                            <span><fmt:formatDate value="${t.createTime}" pattern="yyyy-MM-dd HH:mm"/></span>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:if>

                        <%-- ===== 视频 ===== --%>
                        <c:if test="${not empty myVideos}">
                            <div class="publish-group">
                                <div class="publish-group-title">
                                    <i class="bi bi-play-circle"></i> 视频
                                    <span class="cnt">${videoTotal}</span>
                                </div>
                                <c:forEach var="v" items="${myVideos}">
                                    <div class="record-item">
                                        <div class="d-flex justify-content-between align-items-start gap-3">
                                            <a class="title" href="${pageContext.request.contextPath}/video/detail?id=${v.id}">${fn:escapeXml(v.title)}</a>
                                            <a href="${pageContext.request.contextPath}/user/profile/video/delete?id=${v.id}"
                                               class="btn btn-sm btn-outline-danger rounded-pill px-3"
                                               onclick="return confirm('确定删除这个视频吗？')">删除</a>
                                        </div>
                                        <div class="meta">
                                            <span class="me-3"><i class="bi bi-clock"></i> ${empty v.duration ? '-' : v.duration}</span>
                                            <span class="me-3"><i class="bi bi-eye"></i> ${v.views}</span>
                                            <span><fmt:formatDate value="${v.createTime}" pattern="yyyy-MM-dd HH:mm"/></span>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:if>

                        <c:if test="${empty myNews and empty myTopics and empty myVideos}">
                            <div class="empty-mini">
                                <i class="bi bi-pencil-square"></i>
                                还没有发布过内容
                                <div class="mt-2 d-flex justify-content-center gap-2">
                                    <a href="${pageContext.request.contextPath}/user/profile/publish" class="btn btn-brand btn-sm px-3">去投稿</a>
                                    <a href="${pageContext.request.contextPath}/topic" class="btn btn-outline-primary btn-sm px-3">去发话题</a>
                                </div>
                            </div>
                        </c:if>
                    </div>

                    <!-- 我的评论 -->
                    <div class="tab-pane fade" id="tab-comments" role="tabpanel">
                        <c:forEach var="cm" items="${myComments}">
                            <div class="record-item">
                                <div class="d-flex justify-content-between align-items-start gap-3">
                                    <c:choose>
                                        <c:when test="${cm.targetType == 'video'}">
                                            <a class="title" href="${pageContext.request.contextPath}/video/detail?id=${cm.newsId}">${fn:escapeXml(cm.targetTitle)}</a>
                                        </c:when>
                                        <c:when test="${cm.targetType == 'topic'}">
                                            <a class="title" href="${pageContext.request.contextPath}/topic/detail?id=${cm.newsId}">${fn:escapeXml(cm.targetTitle)}</a>
                                        </c:when>
                                        <c:otherwise>
                                            <a class="title" href="${pageContext.request.contextPath}/detail?id=${cm.newsId}">${fn:escapeXml(cm.targetTitle)}</a>
                                        </c:otherwise>
                                    </c:choose>
                                    <a href="${pageContext.request.contextPath}/comment/delete?id=${cm.id}&amp;targetId=${cm.newsId}&amp;targetType=${cm.targetType}"
                                       class="btn btn-sm btn-outline-danger rounded-pill px-3"
                                       onclick="return confirm('确定删除这条评论吗？')">删除</a>
                                </div>
                                <div class="content">${fn:escapeXml(cm.content)}</div>
                                <div class="meta"><fmt:formatDate value="${cm.createTime}" pattern="yyyy-MM-dd HH:mm"/></div>
                            </div>
                        </c:forEach>
                        <c:if test="${empty myComments}">
                            <div class="empty-mini">
                                <i class="bi bi-chat-square-text"></i>
                                还没有发表过评论
                                <div class="mt-2"><a href="${pageContext.request.contextPath}/index" class="btn btn-outline-primary btn-sm px-3">去看看新闻</a></div>
                            </div>
                        </c:if>
                    </div>

                    <!-- 我的点赞 -->
                    <div class="tab-pane fade" id="tab-likes" role="tabpanel">
                        <c:forEach var="n" items="${likedNews}">
                            <div class="record-item">
                                <a class="title" href="${pageContext.request.contextPath}/detail?id=${n.id}">${fn:escapeXml(n.title)}</a>
                                <div class="meta">
                                    <span class="me-3"><i class="bi bi-person"></i> ${fn:escapeXml(n.author)}</span>
                                    <span class="me-3"><i class="bi bi-tag"></i> ${fn:escapeXml(n.category)}</span>
                                    <span><i class="bi bi-eye"></i> ${n.views}</span>
                                </div>
                            </div>
                        </c:forEach>
                        <c:if test="${empty likedNews}">
                            <div class="empty-mini">
                                <i class="bi bi-heart"></i>
                                还没有点赞过新闻
                                <div class="mt-2"><a href="${pageContext.request.contextPath}/index" class="btn btn-outline-primary btn-sm px-3">去逛逛</a></div>
                            </div>
                        </c:if>
                    </div>
                </div>
    </div>
</div>

<!-- ============ 账号设置弹窗 ============ -->
<div class="modal fade settings-modal" id="settingsModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="bi bi-gear me-2"></i>账号设置</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="关闭"></button>
            </div>
            <div class="modal-body">
                <ul class="nav nav-pills gap-2" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active" data-bs-toggle="pill" data-bs-target="#settings-profile" type="button" role="tab">
                            <i class="bi bi-person-vcard me-1"></i>基本资料
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" data-bs-toggle="pill" data-bs-target="#settings-password" type="button" role="tab">
                            <i class="bi bi-shield-lock me-1"></i>修改密码
                        </button>
                    </li>
                </ul>
                <div class="tab-content">
                    <div class="tab-pane fade show active" id="settings-profile" role="tabpanel">
                        <form action="${pageContext.request.contextPath}/user/profile/update" method="post">
                            <div class="mb-3">
                                <label class="form-label">账号</label>
                                <input type="text" class="form-control" value="${fn:escapeXml(loginUser.username)}" disabled>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">真实姓名</label>
                                <input type="text" name="realName" class="form-control" maxlength="50"
                                       value="${fn:escapeXml(loginUser.realName)}" required>
                            </div>
                            <button type="submit" class="btn btn-brand w-100">保存资料</button>
                        </form>
                    </div>
                    <div class="tab-pane fade" id="settings-password" role="tabpanel">
                        <form action="${pageContext.request.contextPath}/user/profile/password" method="post">
                            <div class="mb-3">
                                <label class="form-label">原密码</label>
                                <input type="password" name="oldPassword" class="form-control" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">新密码</label>
                                <input type="password" name="newPassword" class="form-control" minlength="6" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">确认新密码</label>
                                <input type="password" name="confirmPassword" class="form-control" minlength="6" required>
                            </div>
                            <button type="submit" class="btn btn-brand w-100">修改密码</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- ============ 发布视频弹窗 ============ -->
<div class="modal fade settings-modal" id="videoModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="bi bi-play-circle me-2"></i>发布视频</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="关闭"></button>
            </div>
            <form action="${pageContext.request.contextPath}/user/profile/video" method="post" enctype="multipart/form-data" id="publishVideoForm">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">视频标题 <span class="text-danger">*</span></label>
                        <input type="text" name="title" class="form-control" maxlength="200" required placeholder="如：校园宣传片：四季校园">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">上传本地视频 <span class="text-muted small fw-normal">（与视频地址二选一，不超过 200MB）</span></label>
                        <input type="file" name="videoFile" id="pv_videoFile" class="form-control" accept="video/*">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">视频地址（mp4）</label>
                        <input type="url" name="url" id="pv_url" class="form-control" maxlength="500" placeholder="https://example.com/video.mp4">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">视频简介</label>
                        <textarea name="description" class="form-control" rows="2" maxlength="500" placeholder="一句话介绍视频内容"></textarea>
                    </div>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">上传封面图 <span class="text-muted small fw-normal">（留空自动截取视频首帧）</span></label>
                            <input type="file" name="coverFile" id="pv_coverFile" class="form-control" accept="image/jpeg,image/png,image/gif,image/webp">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">封面图地址</label>
                            <input type="url" name="cover" id="pv_cover" class="form-control" maxlength="500" placeholder="https://example.com/cover.jpg">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">时长 <span class="text-muted small fw-normal">（自动识别）</span></label>
                            <input type="text" name="duration" id="pv_duration" class="form-control" maxlength="20" readonly placeholder="选择视频后自动识别">
                        </div>
                    </div>
                </div>
                <div class="modal-footer" style="border-top:1px solid var(--line)">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">取消</button>
                    <button type="submit" class="btn btn-brand px-4" id="pv_submit">发布</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/static/js/bootstrap.bundle.min.js"></script>
<script>
(function() {
    var coverBlob = null;
    // 读取视频元数据：自动识别时长并截取首帧作为封面
    function probeVideo(src, onDone) {
        var v = document.createElement('video');
        v.preload = 'auto'; v.muted = true; v.crossOrigin = 'anonymous'; v.src = src;
        var finished = false;
        function done(dur, blob) { if (!finished) { finished = true; onDone(dur, blob); } }
        v.addEventListener('loadedmetadata', function() {
            var d = isFinite(v.duration) ? v.duration : 0;
            var m = Math.floor(d / 60), s = Math.floor(d % 60);
            var durStr = (m < 10 ? '0' + m : m) + ':' + (s < 10 ? '0' + s : s);
            v.addEventListener('seeked', function() {
                try {
                    var canvas = document.createElement('canvas');
                    canvas.width = v.videoWidth; canvas.height = v.videoHeight;
                    canvas.getContext('2d').drawImage(v, 0, 0);
                    canvas.toBlob(function(b) { done(durStr, b); }, 'image/jpeg', 0.8);
                } catch (e) { done(durStr, null); }
            }, { once: true });
            try { v.currentTime = Math.min(0.1, d); } catch (e) { done(durStr, null); }
        });
        v.addEventListener('error', function() { done('', null); });
        setTimeout(function() { done('', null); }, 8000);
    }
    var fileInput = document.getElementById('pv_videoFile');
    var urlInput = document.getElementById('pv_url');
    var durInput = document.getElementById('pv_duration');
    if (fileInput) {
        fileInput.addEventListener('change', function() {
            coverBlob = null; durInput.value = '';
            if (this.files && this.files[0]) {
                var objUrl = URL.createObjectURL(this.files[0]);
                probeVideo(objUrl, function(dur, blob) {
                    durInput.value = dur;
                    if (blob) coverBlob = blob;
                    URL.revokeObjectURL(objUrl);
                });
            }
        });
        urlInput.addEventListener('change', function() {
            coverBlob = null; durInput.value = '';
            if (this.value && this.value.trim()) {
                probeVideo(this.value.trim(), function(dur, blob) {
                    durInput.value = dur;
                    if (blob) coverBlob = blob;
                });
            }
        });
        // 提交：把自动截取的首帧封面并入表单（未手动选封面时）
        document.getElementById('publishVideoForm').addEventListener('submit', function(e) {
            var manualCover = document.getElementById('pv_coverFile').files.length > 0
                || document.getElementById('pv_cover').value.trim();
            if (!coverBlob || manualCover) return; // 走原生提交
            e.preventDefault();
            var form = this;
            var fd = new FormData(form);
            fd.set('coverFile', coverBlob, 'cover.jpg');
            var btn = document.getElementById('pv_submit');
            btn.disabled = true;
            fetch(form.action, { method: 'POST', body: fd }).then(function(resp) {
                window.location.href = resp.url;
            }).catch(function() {
                btn.disabled = false;
                form.submit();
            });
        });
    }
})();
</script>
</body>
</html>
