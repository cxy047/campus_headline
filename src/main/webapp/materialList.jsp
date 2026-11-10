<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>素材管理 - 校园头条后台</title>
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
        .table th { background: #F5F9F6; font-weight: 600; white-space: nowrap; }
        .table td { vertical-align: middle; }
        .type-badge { font-size: .78rem; font-weight: 600; color: #374151; }
        .type-badge i { color: var(--brand); margin-right: 4px; }
        .btn-upload { background: var(--brand); border: 0; color: #fff; font-weight: 600; border-radius: 10px; padding: 9px 22px; text-decoration: none; }
        .btn-upload:hover { background: var(--brand-dark); color: #fff; }
        .page-link { color: var(--brand-dark); border-color: #E5EBE7; }
        .page-item.active .page-link { background: var(--brand); border-color: var(--brand); }
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
            <a href="${pageContext.request.contextPath}/video/manage"><i class="bi bi-play-circle"></i> 视频管理</a>
            <a href="${pageContext.request.contextPath}/topic/manage"><i class="bi bi-chat-square-text"></i> 话题管理</a>
            <a href="${pageContext.request.contextPath}/material/list" class="active"><i class="bi bi-images"></i> 素材管理</a>
            <a href="${pageContext.request.contextPath}/user/logout"><i class="bi bi-box-arrow-right"></i> 退出登录</a>
        </div>
        <!-- 主内容 -->
        <div class="col-md-10 content-area">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h3 class="mb-1">素材管理</h3>
                    <small class="text-muted">图片/附件上传记录</small>
                </div>
                <a href="${pageContext.request.contextPath}/material/toUpload" class="btn-upload">
                    <i class="bi bi-cloud-arrow-up me-1"></i>上传素材
                </a>
            </div>

            <div class="card p-4">
                <table class="table table-hover align-middle">
                    <thead>
                        <tr>
                            <th style="width:70px">ID</th>
                            <th>文件名</th>
                            <th style="width:110px">类型</th>
                            <th style="width:140px">大小</th>
                            <th style="width:180px">上传时间</th>
                            <th style="width:230px">操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="m" items="${page.records}">
                            <tr>
                                <td>${m.id}</td>
                                <td>${fn:escapeXml(m.fileName)}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${m.fileType == 'video'}"><span class="type-badge"><i class="bi bi-play-circle"></i>视频</span></c:when>
                                        <c:when test="${m.fileType == 'image'}"><span class="type-badge"><i class="bi bi-image"></i>图片</span></c:when>
                                        <c:when test="${m.fileType == 'doc'}"><span class="type-badge"><i class="bi bi-file-earmark-text"></i>文档</span></c:when>
                                        <c:otherwise><span class="type-badge"><i class="bi bi-file-earmark"></i>其他</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${m.fileSize} B</td>
                                <td><fmt:formatDate value="${m.uploadTime}" pattern="yyyy-MM-dd HH:mm"/></td>
                                <td>
                                    <a href="${pageContext.request.contextPath}${m.filePath}" target="_blank"
                                       class="btn btn-sm btn-outline-success">预览</a>
                                    <button type="button" class="btn btn-sm btn-outline-secondary"
                                            onclick="copyUrl('${pageContext.request.contextPath}${m.filePath}', this)">复制地址</button>
                                    <a href="${pageContext.request.contextPath}/material/delete?id=${m.id}"
                                       class="btn btn-sm btn-outline-danger"
                                       onclick="return confirm('确定删除该素材吗？删除后不可恢复')">删除</a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty page.records}">
                            <tr><td colspan="6" class="text-center text-muted py-4">暂无素材</td></tr>
                        </c:if>
                    </tbody>
                </table>

                <c:if test="${page.pages > 1}">
                    <nav class="mt-3" aria-label="分页导航">
                        <ul class="pagination justify-content-center mb-0">
                            <li class="page-item ${page.current le 1 ? 'disabled' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/material/list?current=${page.current - 1}">上一页</a>
                            </li>
                            <c:forEach begin="1" end="${page.pages}" var="i">
                                <li class="page-item ${page.current == i ? 'active' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/material/list?current=${i}">${i}</a>
                                </li>
                            </c:forEach>
                            <li class="page-item ${page.current ge page.pages ? 'disabled' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/material/list?current=${page.current + 1}">下一页</a>
                            </li>
                        </ul>
                    </nav>
                </c:if>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/static/js/bootstrap.bundle.min.js"></script>
<script>
    function copyUrl(path, btn) {
        var full = location.origin + path;
        var done = function () {
            var old = btn.innerText;
            btn.innerText = '已复制';
            setTimeout(function () { btn.innerText = old; }, 1200);
        };
        if (navigator.clipboard && navigator.clipboard.writeText) {
            navigator.clipboard.writeText(full).then(done);
        } else {
            var ta = document.createElement('textarea');
            ta.value = full;
            document.body.appendChild(ta);
            ta.select();
            document.execCommand('copy');
            document.body.removeChild(ta);
            done();
        }
    }
</script>
</body>
</html>
