<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>视频管理 - 校园头条后台</title>
    <link href="${pageContext.request.contextPath}/static/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            --brand: #00A86B; --brand-dark: #00875A; --brand-deep: #006B4F;
            --brand-soft: #E6F7F0; --brand-line: #CBEBDA;
        }
        body {
            background: #F4F7F5; color: #1F2937;
            font-family: "Noto Sans SC", "Microsoft YaHei", "PingFang SC", system-ui, sans-serif;
        }
        .sidebar { min-height: 100vh; background: linear-gradient(180deg, #064E3B 0%, #006B4F 100%); padding-top: 20px; }
        .sidebar a { color: rgba(255,255,255,.82); padding: 12px 20px; display: block; text-decoration: none; border-left: 3px solid transparent; }
        .sidebar a:hover, .sidebar a.active { background: rgba(255,255,255,.12); border-left-color: #7CE3B8; color: #fff; }
        .sidebar .brand { font-size: 1.3rem; font-weight: 700; color: #fff; padding: 10px 20px; margin-bottom: 20px; }
        .content-area { padding: 30px; }
        .card { border: 1px solid #E5EBE7; box-shadow: 0 8px 24px rgba(15,23,42,.05); border-radius: 14px; }
        .table th { background: #F5F9F6; font-weight: 600; }
        .table a { color: var(--brand-dark); text-decoration: none; }
        .table a:hover { color: var(--brand-deep); text-decoration: underline; }
        .btn-primary {
            --bs-btn-bg: var(--brand); --bs-btn-border-color: var(--brand);
            --bs-btn-hover-bg: var(--brand-dark); --bs-btn-hover-border-color: var(--brand-dark);
            --bs-btn-active-bg: var(--brand-deep); --bs-btn-active-border-color: var(--brand-deep);
            font-weight: 600;
        }
        .btn-outline-primary {
            --bs-btn-color: var(--brand-dark); --bs-btn-border-color: var(--brand-line);
            --bs-btn-hover-bg: var(--brand); --bs-btn-hover-border-color: var(--brand); --bs-btn-hover-color: #fff;
            --bs-btn-active-bg: var(--brand-dark); --bs-btn-active-border-color: var(--brand-dark);
            font-weight: 600;
        }
        .page-link { color: var(--brand-dark); border-color: #E5EBE7; }
        .page-item.active .page-link { background: var(--brand); border-color: var(--brand); }
        .form-control:focus { border-color: #6FD3A9; box-shadow: 0 0 0 3px rgba(0,168,107,.12); }
        .alert { border-radius: 12px; font-size: .9rem; }
    </style>
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <!-- 侧边栏 -->
        <div class="col-md-2 sidebar">
            <div class="brand"><i class="bi bi-newspaper"></i> 校园头条</div>
            <a href="${pageContext.request.contextPath}/index"><i class="bi bi-house"></i> 前台首页</a>
            <a href="${pageContext.request.contextPath}/news/list"><i class="bi bi-file-earmark-text"></i> 新闻管理</a>
            <a href="${pageContext.request.contextPath}/video/manage" class="active"><i class="bi bi-play-circle"></i> 视频管理</a>
            <a href="${pageContext.request.contextPath}/topic/manage"><i class="bi bi-chat-square-text"></i> 话题管理</a>
            <a href="${pageContext.request.contextPath}/material/list"><i class="bi bi-images"></i> 素材管理</a>
            <a href="${pageContext.request.contextPath}/user/logout"><i class="bi bi-box-arrow-right"></i> 退出登录</a>
        </div>
        <!-- 主内容 -->
        <div class="col-md-10 content-area">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h3 class="mb-1">视频管理</h3>
                    <small class="text-muted">欢迎回来，${loginUser.realName}（${loginUser.role}）</small>
                </div>
                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addVideoModal">
                    <i class="bi bi-plus-circle"></i> 添加视频
                </button>
            </div>

            <c:if test="${not empty successMsg}">
                <div class="alert alert-success alert-dismissible fade show">
                    <i class="bi bi-check-circle me-1"></i>${fn:escapeXml(successMsg)}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${not empty errorMsg}">
                <div class="alert alert-danger alert-dismissible fade show">
                    <i class="bi bi-exclamation-circle me-1"></i>${fn:escapeXml(errorMsg)}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <div class="card p-4">
                <table class="table table-hover align-middle">
                    <thead>
                        <tr>
                            <th style="width:60px">ID</th>
                            <th>标题</th>
                            <th style="width:90px">状态</th>
                            <th style="width:110px">发布者</th>
                            <th style="width:90px">时长</th>
                            <th style="width:90px">播放量</th>
                            <th style="width:120px">发布时间</th>
                            <th style="width:290px">操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="v" items="${page.records}">
                            <tr>
                                <td>${v.id}</td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/video/detail?id=${v.id}" target="_blank">${fn:escapeXml(v.title)}</a>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${v.status == 1}"><span class="badge bg-warning text-dark">待审核</span></c:when>
                                        <c:when test="${v.status == 3}"><span class="badge bg-danger">已驳回</span></c:when>
                                        <c:otherwise><span class="badge bg-success">已审核</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${fn:escapeXml(v.author)}</td>
                                <td>${empty v.duration ? '-' : v.duration}</td>
                                <td>${v.views}</td>
                                <td><fmt:formatDate value="${v.createTime}" pattern="yyyy-MM-dd"/></td>
                                <td>
                                    <c:if test="${v.status == 1 || v.status == 3}">
                                        <a href="${pageContext.request.contextPath}/video/auditPass?id=${v.id}"
                                           class="btn btn-sm btn-outline-success">通过</a>
                                    </c:if>
                                    <c:if test="${v.status == 1 || v.status == 2}">
                                        <a href="${pageContext.request.contextPath}/video/auditReject?id=${v.id}"
                                           class="btn btn-sm btn-outline-primary">驳回</a>
                                    </c:if>
                                    <a href="${pageContext.request.contextPath}/video/detail?id=${v.id}" target="_blank"
                                       class="btn btn-sm btn-outline-secondary">预览</a>
                                    <button type="button" class="btn btn-sm btn-outline-warning btn-edit-video"
                                            data-id="${v.id}"
                                            data-title="${fn:escapeXml(v.title)}"
                                            data-url="${fn:escapeXml(v.url)}"
                                            data-description="${fn:escapeXml(v.description)}"
                                            data-cover="${fn:escapeXml(v.cover)}"
                                            data-author="${fn:escapeXml(v.author)}"
                                            data-duration="${fn:escapeXml(v.duration)}">编辑</button>
                                    <a href="${pageContext.request.contextPath}/video/delete?id=${v.id}"
                                       class="btn btn-sm btn-outline-danger"
                                       onclick="return confirm('确定删除该视频吗？删除后不可恢复')">删除</a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty page.records}">
                            <tr><td colspan="8" class="text-center text-muted py-4">暂无视频</td></tr>
                        </c:if>
                    </tbody>
                </table>

                <c:if test="${page.pages > 1}">
                    <nav class="mt-3" aria-label="分页导航">
                        <ul class="pagination justify-content-center mb-0">
                            <li class="page-item ${page.current le 1 ? 'disabled' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/video/manage?current=${page.current - 1}">上一页</a>
                            </li>
                            <c:forEach begin="1" end="${page.pages}" var="i">
                                <li class="page-item ${page.current == i ? 'active' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/video/manage?current=${i}">${i}</a>
                                </li>
                            </c:forEach>
                            <li class="page-item ${page.current ge page.pages ? 'disabled' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/video/manage?current=${page.current + 1}">下一页</a>
                            </li>
                        </ul>
                    </nav>
                </c:if>
            </div>
        </div>
    </div>
</div>

<!-- 添加视频弹窗 -->
<div class="modal fade" id="addVideoModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content" style="border:0;border-radius:16px">
            <div class="modal-header" style="background:linear-gradient(135deg,#006B4F,#00A86B);color:#fff;border:0">
                <h5 class="modal-title fw-bold"><i class="bi bi-plus-circle me-2"></i>添加视频</h5>
                <button type="button" class="btn-close" style="filter:brightness(0) invert(1)" data-bs-dismiss="modal" aria-label="关闭"></button>
            </div>
            <form id="addVideoForm" action="${pageContext.request.contextPath}/video/add" method="post" enctype="multipart/form-data">
                <div class="modal-body p-4">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">视频标题 <span class="text-danger">*</span></label>
                        <input type="text" name="title" class="form-control" maxlength="200" required placeholder="如：校园宣传片：四季校园">
                    </div>
                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">上传本地视频 <span class="text-muted small fw-normal">（推荐）</span></label>
                            <input type="file" name="videoFile" id="av_videoFile" class="form-control" accept="video/mp4,video/webm,video/ogg">
                            <div class="form-text">最大 200MB，与填写地址二选一；选择后自动识别时长与首帧封面。</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">视频地址（mp4）</label>
                            <input type="url" name="url" id="av_url" class="form-control" maxlength="500" placeholder="https://example.com/video.mp4">
                            <div class="form-text">不上传本地文件时必填，支持 mp4 直链。</div>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">视频简介</label>
                        <textarea name="description" class="form-control" rows="2" maxlength="500" placeholder="一句话介绍视频内容"></textarea>
                    </div>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">上传封面图</label>
                            <input type="file" name="coverFile" id="av_coverFile" class="form-control" accept="image/jpeg,image/png,image/gif,image/webp">
                            <div class="form-text">不超过 5MB，留空则自动使用视频首帧。</div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">封面图地址 <span class="text-muted small fw-normal">（与上传二选一）</span></label>
                            <input type="url" name="cover" id="av_cover" class="form-control" maxlength="500" placeholder="https://example.com/cover.jpg">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">发布者</label>
                            <input type="text" name="author" class="form-control" maxlength="50" placeholder="默认：校园头条">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">时长</label>
                            <input type="text" name="duration" id="av_duration" class="form-control" maxlength="20" placeholder="上传视频后自动识别">
                        </div>
                    </div>
                </div>
                <div class="modal-footer" style="border-top:1px solid #EEF2F0">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">取消</button>
                    <button type="submit" id="av_submit" class="btn btn-primary"><i class="bi bi-check2 me-1"></i>保存视频</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- 编辑视频弹窗 -->
<div class="modal fade" id="editVideoModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content" style="border:0;border-radius:16px">
            <div class="modal-header" style="background:linear-gradient(135deg,#006B4F,#00A86B);color:#fff;border:0">
                <h5 class="modal-title fw-bold"><i class="bi bi-pencil-square me-2"></i>编辑视频</h5>
                <button type="button" class="btn-close" style="filter:brightness(0) invert(1)" data-bs-dismiss="modal" aria-label="关闭"></button>
            </div>
            <form id="editVideoForm" action="${pageContext.request.contextPath}/video/edit" method="post" enctype="multipart/form-data">
                <input type="hidden" name="id" id="ev_id">
                <div class="modal-body p-4">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">视频标题 <span class="text-danger">*</span></label>
                        <input type="text" name="title" id="ev_title" class="form-control" maxlength="200" required>
                    </div>
                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">视频地址（mp4）<span class="text-danger">*</span></label>
                            <input type="text" name="url" id="ev_url" class="form-control" maxlength="500" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">重新上传视频 <span class="text-muted small fw-normal">（留空保持原视频）</span></label>
                            <input type="file" name="videoFile" id="ev_videoFile" class="form-control" accept="video/mp4,video/webm,video/ogg">
                            <div class="form-text">选择后自动识别时长与首帧封面。</div>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">视频简介</label>
                        <textarea name="description" id="ev_description" class="form-control" rows="2" maxlength="500"></textarea>
                    </div>
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">上传封面图 <span class="text-muted small fw-normal">（留空保持原封面）</span></label>
                            <input type="file" name="coverFile" id="ev_coverFile" class="form-control" accept="image/jpeg,image/png,image/gif,image/webp">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">封面图地址</label>
                            <input type="text" name="cover" id="ev_cover" class="form-control" maxlength="500">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">发布者</label>
                            <input type="text" name="author" id="ev_author" class="form-control" maxlength="50">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">时长</label>
                            <input type="text" name="duration" id="ev_duration" class="form-control" maxlength="20">
                        </div>
                    </div>
                </div>
                <div class="modal-footer" style="border-top:1px solid #EEF2F0">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">取消</button>
                    <button type="submit" id="ev_submit" class="btn btn-primary"><i class="bi bi-check2 me-1"></i>保存修改</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/static/js/bootstrap.bundle.min.js"></script>
<script>
    // 编辑按钮：把当前行数据填充进编辑弹窗
    document.querySelectorAll('.btn-edit-video').forEach(function (btn) {
        btn.addEventListener('click', function () {
            document.getElementById('ev_id').value = this.dataset.id;
            document.getElementById('ev_title').value = this.dataset.title;
            document.getElementById('ev_url').value = this.dataset.url;
            document.getElementById('ev_description').value = this.dataset.description;
            document.getElementById('ev_cover').value = this.dataset.cover;
            document.getElementById('ev_author').value = this.dataset.author;
            document.getElementById('ev_duration').value = this.dataset.duration;
            new bootstrap.Modal(document.getElementById('editVideoModal')).show();
        });
    });

    // 选择视频后自动识别时长（mm:ss）并截取首帧作为封面兜底，与前台投稿一致
    function probeVideo(src, onDone) {
        var v = document.createElement('video');
        v.preload = 'auto'; v.muted = true; v.crossOrigin = 'anonymous'; v.src = src;
        var finished = false;
        function done(dur, blob) { if (!finished) { finished = true; onDone(dur, blob); } }
        v.addEventListener('loadedmetadata', function () {
            var d = isFinite(v.duration) ? v.duration : 0;
            var m = Math.floor(d / 60), s = Math.floor(d % 60);
            var durStr = (m < 10 ? '0' + m : m) + ':' + (s < 10 ? '0' + s : s);
            v.addEventListener('seeked', function () {
                try {
                    var canvas = document.createElement('canvas');
                    canvas.width = v.videoWidth; canvas.height = v.videoHeight;
                    canvas.getContext('2d').drawImage(v, 0, 0);
                    canvas.toBlob(function (b) { done(durStr, b); }, 'image/jpeg', 0.8);
                } catch (e) { done(durStr, null); }
            }, { once: true });
            try { v.currentTime = Math.min(0.1, d); } catch (e) { done(durStr, null); }
        });
        v.addEventListener('error', function () { done('', null); });
        setTimeout(function () { done('', null); }, 8000);
    }

    function bindVideoAuto(cfg) {
        var coverBlob = null;
        var fileInput = document.getElementById(cfg.fileId);
        var durInput = document.getElementById(cfg.durId);
        var coverFile = document.getElementById(cfg.coverFileId);
        var coverUrl = document.getElementById(cfg.coverUrlId);
        var form = document.getElementById(cfg.formId);
        var btn = document.getElementById(cfg.submitId);
        fileInput.addEventListener('change', function () {
            coverBlob = null;
            if (this.files && this.files[0]) {
                btn.disabled = true; // 识别完成前禁止提交，避免时长/首帧丢失
                var objUrl = URL.createObjectURL(this.files[0]);
                probeVideo(objUrl, function (dur, blob) {
                    if (dur) durInput.value = dur;
                    if (blob) coverBlob = blob;
                    URL.revokeObjectURL(objUrl);
                    btn.disabled = false;
                });
            }
        });
        if (cfg.urlId) {
            var urlInput = document.getElementById(cfg.urlId);
            urlInput.addEventListener('change', function () {
                coverBlob = null;
                if (this.value && this.value.trim()) {
                    btn.disabled = true;
                    probeVideo(this.value.trim(), function (dur, blob) {
                        if (dur && !durInput.value) durInput.value = dur;
                        if (blob) coverBlob = blob;
                        btn.disabled = false;
                    });
                }
            });
        }
        // 提交：未手动选封面且已截到首帧时，把首帧并入 coverFile 一起上传
        form.addEventListener('submit', function (e) {
            var manualCover = coverFile.files.length > 0 || coverUrl.value.trim();
            if (!coverBlob || manualCover) return; // 走原生提交
            e.preventDefault();
            var fd = new FormData(form);
            fd.set('coverFile', coverBlob, 'cover.jpg');
            var btn = document.getElementById(cfg.submitId);
            btn.disabled = true;
            fetch(form.action, { method: 'POST', body: fd }).then(function (resp) {
                window.location.href = resp.url;
            }).catch(function () {
                btn.disabled = false;
                form.submit();
            });
        });
    }

    bindVideoAuto({ formId: 'addVideoForm', fileId: 'av_videoFile', urlId: 'av_url', durId: 'av_duration', coverFileId: 'av_coverFile', coverUrlId: 'av_cover', submitId: 'av_submit' });
    bindVideoAuto({ formId: 'editVideoForm', fileId: 'ev_videoFile', urlId: null, durId: 'ev_duration', coverFileId: 'ev_coverFile', coverUrlId: 'ev_cover', submitId: 'ev_submit' });
</script>
</body>
</html>
