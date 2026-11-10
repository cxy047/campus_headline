<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>上传素材 - 校园头条后台</title>
    <link href="${pageContext.request.contextPath}/static/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root { --brand:#00A86B; --brand-dark:#00875A; --brand-line:#CBEBDA; --line:#E5EBE7; }
        body {
            background: #F4F7F5; min-height: 100vh; color: #1F2937;
            font-family: "Noto Sans SC", "Microsoft YaHei", "PingFang SC", system-ui, sans-serif;
        }
        .page-title { font-weight: 800; font-size: 1.15rem; color: var(--brand-dark); margin: 26px 0 18px; }
        .panel {
            background: #fff; border: 1px solid var(--line); border-radius: 18px;
            padding: 34px 38px; box-shadow: 0 14px 34px rgba(15,23,42,.07);
        }
        .form-label { font-weight: 600; font-size: .86rem; }
        .form-control { border-radius: 10px; padding: 10px 14px; border-color: #DDE7E1; background: #FBFDFC; }
        .form-control:focus { border-color: #6FD3A9; box-shadow: 0 0 0 3px rgba(0,168,107,.12); background: #fff; }
        .btn-back {
            border: 1px solid var(--line); background: #fff; color: #4B5563;
            border-radius: 10px; font-weight: 600; padding: 9px 22px; text-decoration: none;
        }
        .btn-back:hover { border-color: var(--brand-line); color: var(--brand-dark); }
        .btn-submit { background: var(--brand); border: 0; color: #fff; border-radius: 10px; font-weight: 700; padding: 9px 26px; }
        .btn-submit:hover { background: var(--brand-dark); color: #fff; }
        .alert { border-radius: 12px; font-size: .9rem; }
    </style>
</head>
<body>
<div class="container" style="max-width: 720px;">
    <div class="page-title"><i class="bi bi-cloud-arrow-up me-2"></i>上传素材</div>

    <c:if test="${not empty msg}">
        <div class="alert alert-danger"><i class="bi bi-exclamation-circle me-1"></i>${fn:escapeXml(msg)}</div>
    </c:if>

    <div class="panel">
        <form action="${pageContext.request.contextPath}/material/upload" method="post" enctype="multipart/form-data">
            <div class="mb-4">
                <label class="form-label">选择文件</label>
                <input type="file" name="file" class="form-control" required>
                <div class="form-text">支持图片、视频等素材文件，单个文件最大 200MB。</div>
            </div>
            <div class="d-flex justify-content-end gap-2">
                <a href="${pageContext.request.contextPath}/material/list" class="btn-back"><i class="bi bi-arrow-left me-1"></i>返回</a>
                <button type="submit" class="btn-submit"><i class="bi bi-cloud-arrow-up me-1"></i>开始上传</button>
            </div>
        </form>
    </div>
</div>
<script src="${pageContext.request.contextPath}/static/js/bootstrap.bundle.min.js"></script>
</body>
</html>
