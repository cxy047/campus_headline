<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>发表新闻 - 校园头条</title>
    <link href="${pageContext.request.contextPath}/static/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            --brand:#00A86B; --brand-dark:#00875A; --brand-deep:#006B4F;
            --brand-soft:#E6F7F0; --brand-line:#CBEBDA;
            --line:#E5EBE7;
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
        .btn-outline-brand {
            color: var(--brand-dark); border: 1px solid var(--brand-line);
            font-weight: 600; border-radius: 999px; background: #fff;
        }
        .btn-outline-brand:hover { background: var(--brand); border-color: var(--brand); color: #fff; }
        .panel {
            background: #fff; border: 1px solid var(--line); border-radius: 18px;
            padding: 32px 36px; box-shadow: 0 14px 34px rgba(15,23,42,.07);
        }
        .panel h3 { font-weight: 800; margin-bottom: 4px; }
        .form-label { font-weight: 600; font-size: .86rem; }
        .form-control, .form-select { border-radius: 10px; padding: 10px 14px; border-color: #DDE7E1; background: #FBFDFC; }
        .form-control:focus, .form-select:focus { border-color: #6FD3A9; box-shadow: 0 0 0 3px rgba(0,168,107,.12); background: #fff; }
        .btn-brand { background: var(--brand); border: 0; color: #fff; border-radius: 10px; font-weight: 600; padding: 9px 26px; }
        .btn-brand:hover { background: var(--brand-dark); color: #fff; }
        .alert { border-radius: 12px; font-size: .9rem; }
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
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/user/profile"><i class="bi bi-person-gear me-1"></i>个人中心</a></li>
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
    <div class="row justify-content-center">
        <div class="col-lg-9">
            <c:if test="${not empty error}">
                <div class="alert alert-danger d-flex align-items-center gap-2">
                    <i class="bi bi-exclamation-circle-fill"></i> ${fn:escapeXml(error)}
                </div>
            </c:if>
            <div class="panel">
                <div class="d-flex justify-content-between align-items-start mb-4">
                    <div>
                        <h3>发表新闻</h3>
                        <div class="text-muted small">提交后进入待审核状态，管理员审核通过后展示在首页</div>
                    </div>
                    <a href="${pageContext.request.contextPath}/user/profile" class="btn btn-outline-brand btn-sm px-3">
                        <i class="bi bi-arrow-left me-1"></i>返回个人中心
                    </a>
                </div>
                <form action="${pageContext.request.contextPath}/user/profile/publish" method="post" enctype="multipart/form-data">
                    <div class="mb-3">
                        <label class="form-label">新闻标题</label>
                        <input type="text" name="title" class="form-control" maxlength="200" placeholder="请输入新闻标题" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">新闻分类</label>
                        <select name="category" class="form-select">
                            <option value="校园通知">校园通知</option>
                            <option value="校园活动">校园活动</option>
                            <option value="学术动态">学术动态</option>
                            <option value="校园风采">校园风采</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">封面图片 <span class="text-muted small fw-normal">（可选，不上传则使用默认配图）</span></label>
                        <input type="file" name="coverFile" class="form-control" accept="image/jpeg,image/png,image/gif,image/webp">
                        <div class="form-text">支持 jpg / png / gif / webp，不超过 5MB。</div>
                    </div>
                    <div class="mb-4">
                        <label class="form-label">正文内容</label>
                        <textarea name="content" class="form-control" rows="12" placeholder="请输入新闻正文..." required></textarea>
                    </div>
                    <div class="d-flex gap-2">
                        <button type="submit" class="btn btn-brand"><i class="bi bi-send me-1"></i>提交投稿</button>
                        <a href="${pageContext.request.contextPath}/user/profile" class="btn btn-outline-brand px-4">取消</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/static/js/bootstrap.bundle.min.js"></script>
</body>
</html>
