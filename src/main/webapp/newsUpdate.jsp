<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>编辑新闻 - 校园头条后台</title>
    <link href="${pageContext.request.contextPath}/static/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            --brand:#00A86B; --brand-dark:#00875A; --brand-soft:#E6F7F0;
            --brand-line:#CBEBDA; --line:#E5EBE7;
        }
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
        .form-label .opt { color: #9CA3AF; font-weight: 400; font-size: .78rem; margin-left: 4px; }
        .form-control, .form-select {
            border-radius: 10px; padding: 10px 14px; border-color: #DDE7E1;
            background: #FBFDFC; font-size: .92rem;
        }
        .form-control:focus, .form-select:focus { border-color: #6FD3A9; box-shadow: 0 0 0 3px rgba(0,168,107,.12); background: #fff; }
        .form-text { font-size: .78rem; color: #9CA3AF; }
        .cover-cur { border-radius: 10px; max-height: 90px; display: block; margin-bottom: 8px; }
        .btn-back {
            border: 1px solid var(--line); background: #fff; color: #4B5563;
            border-radius: 10px; font-weight: 600; padding: 9px 22px; text-decoration: none;
        }
        .btn-back:hover { border-color: var(--brand-line); color: var(--brand-dark); }
        .btn-submit {
            background: var(--brand); border: 0; color: #fff;
            border-radius: 10px; font-weight: 700; padding: 9px 26px;
        }
        .btn-submit:hover { background: var(--brand-dark); color: #fff; }
        .alert { border-radius: 12px; font-size: .9rem; }
    </style>
</head>
<body>
<div class="container" style="max-width: 880px;">
    <div class="page-title"><i class="bi bi-pencil-square me-2"></i>编辑新闻</div>

    <c:if test="${not empty errorMsg}">
        <div class="alert alert-danger"><i class="bi bi-exclamation-circle me-1"></i>${fn:escapeXml(errorMsg)}</div>
    </c:if>

    <div class="panel">
        <form action="${pageContext.request.contextPath}/news/update" method="post" enctype="multipart/form-data">
            <input type="hidden" name="id" value="${news.id}">
            <input type="hidden" name="status" value="${news.status}">
            <div class="row g-3 mb-3">
                <div class="col-md-6">
                    <label class="form-label">新闻标题</label>
                    <input type="text" name="title" class="form-control" maxlength="200" value="${fn:escapeXml(news.title)}" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label">新闻分类</label>
                    <select name="category" class="form-select">
                        <option value="校园通知" ${news.category == '校园通知' ? 'selected' : ''}>校园通知</option>
                        <option value="校园活动" ${news.category == '校园活动' ? 'selected' : ''}>校园活动</option>
                        <option value="学术动态" ${news.category == '学术动态' ? 'selected' : ''}>学术动态</option>
                        <option value="校园风采" ${news.category == '校园风采' ? 'selected' : ''}>校园风采</option>
                    </select>
                </div>
                <div class="col-md-6">
                    <label class="form-label">作者</label>
                    <input type="text" name="author" class="form-control" value="${fn:escapeXml(news.author)}" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label">封面图片<span class="opt">（可选，不选择则保持原封面）</span></label>
                    <c:if test="${not empty news.cover}">
                        <img class="cover-cur" src="${pageContext.request.contextPath}${news.cover}" alt="当前封面">
                    </c:if>
                    <input type="file" name="coverFile" class="form-control" accept="image/jpeg,image/png,image/gif,image/webp">
                    <div class="form-text">支持 jpg / png / gif / webp，不超过 5MB。</div>
                </div>
            </div>
            <div class="mb-4">
                <label class="form-label">新闻内容</label>
                <textarea name="content" class="form-control" rows="10" required>${fn:escapeXml(news.content)}</textarea>
            </div>
            <div class="d-flex justify-content-end gap-2">
                <a href="${pageContext.request.contextPath}/news/list" class="btn-back"><i class="bi bi-arrow-left me-1"></i>返回</a>
                <button type="submit" class="btn-submit"><i class="bi bi-check2 me-1"></i>保存修改</button>
            </div>
        </form>
    </div>
</div>
<script src="${pageContext.request.contextPath}/static/js/bootstrap.bundle.min.js"></script>
</body>
</html>
