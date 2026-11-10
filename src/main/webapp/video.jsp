<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%-- 直接访问 video.jsp 时没有 page 数据，跳转到 Controller 统一处理 --%>
<c:if test="${empty page}"><c:redirect url="/video"/></c:if>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>校园视频 - 校园头条</title>
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

        .video-card {
            display: block; height: 100%; background: #fff; border: 1px solid var(--line);
            border-radius: 14px; overflow: hidden; text-decoration: none; color: inherit;
            transition: transform .2s ease, box-shadow .2s ease, border-color .2s ease;
        }
        .video-card:hover { transform: translateY(-3px); border-color: var(--brand-line); box-shadow: 0 14px 30px rgba(15,23,42,.09); }
        .cover {
            position: relative; aspect-ratio: 16/9; overflow: hidden;
            display: grid; place-items: center;
            background: linear-gradient(135deg, #006B4F, #16A095);
        }
        .cover.c2 { background: linear-gradient(135deg, #0E7490, #22D3EE); }
        .cover.c3 { background: linear-gradient(135deg, #00875A, #4FD1A5); }
        .cover.c4 { background: linear-gradient(135deg, #065F46, #34D399); }
        .cover > i { font-size: 2.4rem; color: rgba(255,255,255,.85); }
        .cover img { position: absolute; inset: 0; width: 100%; height: 100%; object-fit: cover; }
        .play-badge {
            position: absolute; inset: 0; display: grid; place-items: center;
            background: rgba(0,0,0,.18); opacity: 0; transition: opacity .18s ease;
        }
        .video-card:hover .play-badge { opacity: 1; }
        .play-badge span {
            width: 52px; height: 52px; border-radius: 50%;
            background: rgba(255,255,255,.92); color: var(--brand-dark);
            display: grid; place-items: center; font-size: 1.3rem;
            box-shadow: 0 8px 20px rgba(0,0,0,.25);
        }
        .duration {
            position: absolute; right: 10px; bottom: 10px;
            background: rgba(0,0,0,.68); color: #fff; font-size: .72rem;
            padding: 2px 8px; border-radius: 6px;
        }
        .video-main { padding: 14px 16px 12px; }
        .video-main h3 {
            font-size: .96rem; font-weight: 700; line-height: 1.5; margin: 0 0 8px;
            display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;
        }
        .video-card:hover h3 { color: var(--brand-dark); }
        .video-meta { display: flex; align-items: center; justify-content: space-between; color: #9CA3AF; font-size: .76rem; }

        .page-link { color: var(--brand-dark); border-color: var(--line); border-radius: 9px !important; margin: 0 3px; }
        .page-item.active .page-link { background: var(--brand); border-color: var(--brand); }
        .site-footer { margin-top: 48px; border-top: 1px solid var(--line); background: #fff; }
        .site-footer .inner {
            max-width: 1140px; margin: 0 auto; padding: 22px 16px;
            display: flex; flex-wrap: wrap; gap: 8px; justify-content: space-between;
            color: var(--muted); font-size: .84rem;
        }
        .empty-state { text-align: center; padding: 72px 16px; color: #9CA3AF; background: #fff; border: 1px solid var(--line); border-radius: 14px; }

        /* ---------- 发布视频面板 ---------- */
        .publish-panel { background: #fff; border: 1px solid var(--line); border-radius: 16px; padding: 20px 24px; margin-bottom: 26px; box-shadow: 0 8px 22px rgba(15,23,42,.05); }
        .publish-panel .pp-head { display: flex; align-items: center; justify-content: space-between; }
        .publish-panel .pp-title { font-weight: 700; font-size: .95rem; color: var(--ink); }
        .publish-panel .pp-title i { color: var(--brand); margin-right: 7px; }
        .guest-tip { margin-top: 14px; text-align: center; color: #9CA3AF; font-size: .88rem; border: 1px dashed var(--line); border-radius: 12px; padding: 22px; }
        .guest-tip a { display: block; color: var(--brand-dark); font-weight: 700; text-decoration: none; margin-top: 4px; }
        .publish-form { margin-top: 18px; }
        .publish-form .form-label { font-weight: 600; font-size: .84rem; color: #374151; }
        .publish-form .form-label .opt { color: #9CA3AF; font-weight: 400; font-size: .76rem; }
        .publish-form .form-control { border-radius: 10px; border-color: #DDE7E1; background: #FBFDFC; font-size: .9rem; }
        .publish-form .form-control:focus { border-color: #6FD3A9; box-shadow: 0 0 0 3px rgba(0,168,107,.12); background: #fff; }
        .btn-submit-review { background: var(--brand); border: 0; color: #fff; font-weight: 700; border-radius: 999px; padding: 8px 24px; }
        .btn-submit-review:hover { background: var(--brand-dark); color: #fff; }
        .audit-hint { color: #9CA3AF; font-size: .8rem; }
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
                <li class="nav-item"><a class="nav-link active" href="${pageContext.request.contextPath}/video"><i class="bi bi-play-circle me-1"></i>视频</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/topic"><i class="bi bi-chat-square-text me-1"></i>话题</a></li>
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
        <h1>校园视频</h1>
        <span class="hint">共 ${page.total} 个视频</span>
    </div>

    <!-- ============ 发布视频 ============ -->
    <div class="publish-panel">
        <div class="pp-head">
            <span class="pp-title"><i class="bi bi-cloud-arrow-up"></i>发布视频</span>
            <c:if test="${not empty loginUser}">
                <button type="button" class="btn btn-brand btn-sm px-3" id="togglePublishBtn">
                    <i class="bi bi-plus-lg me-1"></i>我要投稿
                </button>
            </c:if>
        </div>
        <c:choose>
            <c:when test="${empty loginUser}">
                <div class="guest-tip">
                    <i class="bi bi-lock me-1"></i>登录后即可投稿视频
                    <a href="${pageContext.request.contextPath}/login">去登录</a>
                </div>
            </c:when>
            <c:otherwise>
                <form class="publish-form d-none" action="${pageContext.request.contextPath}/user/profile/video" method="post" enctype="multipart/form-data" id="publishVideoForm">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">视频标题</label>
                            <input type="text" name="title" class="form-control" maxlength="200" required placeholder="给视频起个标题，如：校园运动会精彩集锦">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">时长<span class="opt">（自动识别）</span></label>
                            <input type="text" name="duration" id="pv_duration" class="form-control" maxlength="20" readonly placeholder="选择视频后自动显示">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">上传本地视频<span class="opt">（推荐，最大 200MB）</span></label>
                            <input type="file" name="videoFile" id="pv_videoFile" class="form-control" accept="video/*">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">或填写视频地址<span class="opt">（选填）</span></label>
                            <input type="text" name="url" id="pv_url" class="form-control" maxlength="500" placeholder="https://…/video.mp4，或素材管理里的 /upload/xxx">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">封面图<span class="opt">（选填，不填则自动用视频首帧）</span></label>
                            <input type="file" name="coverFile" id="pv_coverFile" class="form-control" accept="image/jpeg,image/png,image/gif,image/webp">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">或填写封面图地址<span class="opt">（选填）</span></label>
                            <input type="text" name="cover" id="pv_cover" class="form-control" maxlength="500" placeholder="https://… 或 /images/default-news.jpg">
                        </div>
                        <div class="col-12">
                            <label class="form-label">视频简介<span class="opt">（选填）</span></label>
                            <textarea name="description" class="form-control" rows="2" maxlength="500" placeholder="简单介绍一下这个视频"></textarea>
                        </div>
                    </div>
                    <div class="d-flex align-items-center gap-3 mt-3">
                        <button type="submit" class="btn-submit-review" id="pv_submit"><i class="bi bi-send me-1"></i>提交审核</button>
                        <span class="audit-hint">提交后需管理员审核通过，才会在视频页展示</span>
                    </div>
                </form>
            </c:otherwise>
        </c:choose>
    </div>

    <c:if test="${not empty msg}">
        <div class="alert alert-success alert-dismissible fade show" style="border-radius:12px;font-size:.9rem">
            <i class="bi bi-check-circle me-1"></i>${fn:escapeXml(msg)}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show" style="border-radius:12px;font-size:.9rem">
            <i class="bi bi-exclamation-circle me-1"></i>${fn:escapeXml(error)}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <div class="row g-4">
        <c:forEach var="v" items="${page.records}" varStatus="st">
            <div class="col-md-6 col-lg-3">
                <a href="${pageContext.request.contextPath}/video/detail?id=${v.id}" class="video-card">
                    <div class="cover c${st.index % 4 + 1}">
                        <i class="bi bi-camera-video"></i>
                        <c:if test="${not empty v.cover}">
                            <c:choose>
                                <c:when test="${fn:startsWith(v.cover, 'http')}">
                                    <img src="${v.cover}" alt="" loading="lazy" onerror="this.remove()">
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}${v.cover}" alt="" loading="lazy" onerror="this.remove()">
                                </c:otherwise>
                            </c:choose>
                        </c:if>
                        <div class="play-badge"><span><i class="bi bi-play-fill"></i></span></div>
                        <c:if test="${not empty v.duration}"><span class="duration">${v.duration}</span></c:if>
                    </div>
                    <div class="video-main">
                        <h3>${fn:escapeXml(v.title)}</h3>
                        <div class="video-meta">
                            <span><i class="bi bi-person me-1"></i>${fn:escapeXml(v.author)}</span>
                            <span><i class="bi bi-play-btn me-1"></i>${v.views}</span>
                        </div>
                    </div>
                </a>
            </div>
        </c:forEach>
    </div>

    <c:if test="${empty page.records}">
        <div class="empty-state">
            <i class="bi bi-camera-video-off" style="font-size:3rem;color:#D1D5DB"></i>
            <h5 class="mt-3" style="color:#4B5563">暂无视频</h5>
            <p class="mb-0" style="font-size:.9rem">敬请期待更多校园视频内容</p>
        </div>
    </c:if>

    <c:if test="${page.pages > 1}">
        <nav class="mt-4" aria-label="分页导航">
            <ul class="pagination justify-content-center">
                <li class="page-item ${page.current le 1 ? 'disabled' : ''}">
                    <a class="page-link" href="${pageContext.request.contextPath}/video?current=${page.current - 1}">上一页</a>
                </li>
                <c:forEach begin="1" end="${page.pages}" var="i">
                    <li class="page-item ${page.current == i ? 'active' : ''}">
                        <a class="page-link" href="${pageContext.request.contextPath}/video?current=${i}">${i}</a>
                    </li>
                </c:forEach>
                <li class="page-item ${page.current ge page.pages ? 'disabled' : ''}">
                    <a class="page-link" href="${pageContext.request.contextPath}/video?current=${page.current + 1}">下一页</a>
                </li>
            </ul>
        </nav>
    </c:if>
</div>

<footer class="site-footer">
    <div class="inner">
        <span><i class="bi bi-newspaper me-1"></i>校园头条 · 校园新闻资讯系统</span>
        <span>SSM 框架课程设计</span>
    </div>
</footer>

<script src="${pageContext.request.contextPath}/static/js/bootstrap.bundle.min.js"></script>
<script>
(function() {
    // 展开/收起投稿表单
    var toggleBtn = document.getElementById('togglePublishBtn');
    var form = document.getElementById('publishVideoForm');
    if (toggleBtn && form) {
        toggleBtn.addEventListener('click', function() {
            form.classList.toggle('d-none');
        });
    }
    var fileInput = document.getElementById('pv_videoFile');
    if (!fileInput) return;
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
    var urlInput = document.getElementById('pv_url');
    var durInput = document.getElementById('pv_duration');
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
})();
</script>
</body>
</html>
