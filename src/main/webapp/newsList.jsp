<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>新闻管理 - 校园头条后台</title>
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
        .news-title { color: #1F2937; font-weight: 600; text-decoration: none; }
        .news-title:hover { color: var(--brand-dark); }
        .btn-publish { background: var(--brand); border: 0; color: #fff; font-weight: 600; border-radius: 10px; padding: 9px 22px; text-decoration: none; }
        .btn-publish:hover { background: var(--brand-dark); color: #fff; }
        .form-control, .form-select { border-radius: 10px; border-color: #DDE7E1; background: #FBFDFC; font-size: .9rem; }
        .form-control:focus, .form-select:focus { border-color: #6FD3A9; box-shadow: 0 0 0 3px rgba(0,168,107,.12); background: #fff; }
        .btn-filter { border: 1px solid var(--brand-line); color: var(--brand-dark); font-weight: 600; border-radius: 10px; background: #fff; }
        .btn-filter:hover { background: var(--brand); color: #fff; border-color: var(--brand); }
        .cat-badge { font-size: .74rem; font-weight: 600; border-radius: 6px; padding: 2px 9px; }
        .cat-notice  { background: #E6F7F0; color: #00875A; }
        .cat-activity{ background: #FFF3E6; color: #C2410C; }
        .cat-academic{ background: #E8F1FD; color: #1D5FD1; }
        .cat-style   { background: #F3E9FD; color: #7C3AED; }
        .page-link { color: var(--brand-dark); border-color: #E5EBE7; }
        .page-item.active .page-link { background: var(--brand); border-color: var(--brand); }
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
            <a href="${pageContext.request.contextPath}/news/list" class="active"><i class="bi bi-file-earmark-text"></i> 新闻管理</a>
            <a href="${pageContext.request.contextPath}/video/manage"><i class="bi bi-play-circle"></i> 视频管理</a>
            <a href="${pageContext.request.contextPath}/topic/manage"><i class="bi bi-chat-square-text"></i> 话题管理</a>
            <a href="${pageContext.request.contextPath}/material/list"><i class="bi bi-images"></i> 素材管理</a>
            <a href="${pageContext.request.contextPath}/user/logout"><i class="bi bi-box-arrow-right"></i> 退出登录</a>
        </div>
        <!-- 主内容 -->
        <div class="col-md-10 content-area">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h3 class="mb-1">新闻管理</h3>
                    <small class="text-muted">欢迎回来，${loginUser.realName}（${loginUser.role}）</small>
                </div>
                <a href="${pageContext.request.contextPath}/news/toAdd" class="btn-publish">
                    <i class="bi bi-plus-circle me-1"></i>发布新闻
                </a>
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

            <!-- 筛选 -->
            <form class="card p-3 mb-3" action="${pageContext.request.contextPath}/news/list" method="get">
                <div class="row g-2 align-items-center">
                    <div class="col-md-4">
                        <input type="text" class="form-control" name="title" placeholder="搜索标题…" value="${fn:escapeXml(title)}">
                    </div>
                    <div class="col-md-3">
                        <select class="form-select" name="category">
                            <option value="">全部分类</option>
                            <option value="校园通知" ${category == '校园通知' ? 'selected' : ''}>校园通知</option>
                            <option value="校园活动" ${category == '校园活动' ? 'selected' : ''}>校园活动</option>
                            <option value="学术动态" ${category == '学术动态' ? 'selected' : ''}>学术动态</option>
                            <option value="校园风采" ${category == '校园风采' ? 'selected' : ''}>校园风采</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <select class="form-select" name="status">
                            <option value="">全部状态</option>
                            <option value="0" ${status == 0 ? 'selected' : ''}>草稿</option>
                            <option value="1" ${status == 1 ? 'selected' : ''}>待审核</option>
                            <option value="2" ${status == 2 ? 'selected' : ''}>已审核</option>
                            <option value="3" ${status == 3 ? 'selected' : ''}>已驳回</option>
                        </select>
                    </div>
                    <div class="col-md-2 d-grid">
                        <button type="submit" class="btn btn-filter"><i class="bi bi-funnel me-1"></i>筛选</button>
                    </div>
                </div>
            </form>

            <div class="card p-4">
                <table class="table table-hover align-middle">
                    <thead>
                        <tr>
                            <th style="width:56px">ID</th>
                            <th>标题</th>
                            <th style="width:110px">作者</th>
                            <th style="width:96px">分类</th>
                            <th style="width:86px">浏览量</th>
                            <th style="width:90px">状态</th>
                            <th style="width:130px">发布时间</th>
                            <th style="width:230px">操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="n" items="${page.records}">
                            <tr>
                                <td>${n.id}</td>
                                <td>
                                    <a class="news-title" href="${pageContext.request.contextPath}/detail?id=${n.id}" target="_blank">${fn:escapeXml(n.title)}</a>
                                </td>
                                <td>${fn:escapeXml(n.author)}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${n.category == '校园通知'}"><span class="cat-badge cat-notice">校园通知</span></c:when>
                                        <c:when test="${n.category == '校园活动'}"><span class="cat-badge cat-activity">校园活动</span></c:when>
                                        <c:when test="${n.category == '学术动态'}"><span class="cat-badge cat-academic">学术动态</span></c:when>
                                        <c:when test="${n.category == '校园风采'}"><span class="cat-badge cat-style">校园风采</span></c:when>
                                        <c:otherwise><span class="cat-badge cat-notice">${fn:escapeXml(n.category)}</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td><i class="bi bi-eye text-muted"></i> ${n.views}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${n.status == 0}"><span class="badge bg-warning text-dark">草稿</span></c:when>
                                        <c:when test="${n.status == 1}"><span class="badge bg-info text-dark">待审核</span></c:when>
                                        <c:when test="${n.status == 3}"><span class="badge bg-danger">已驳回</span></c:when>
                                        <c:otherwise><span class="badge bg-success">已审核</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td><fmt:formatDate value="${n.createTime}" pattern="yyyy-MM-dd HH:mm"/></td>
                                <td>
                                    <c:if test="${n.status == 0 || n.status == 3}">
                                        <a href="${pageContext.request.contextPath}/news/submitAudit?id=${n.id}"
                                           class="btn btn-sm btn-outline-primary" title="提交审核">
                                            <i class="bi bi-send"></i> 提交
                                        </a>
                                    </c:if>
                                    <c:if test="${n.status == 1}">
                                        <a href="${pageContext.request.contextPath}/news/auditPass?id=${n.id}"
                                           class="btn btn-sm btn-outline-success">通过</a>
                                        <a href="${pageContext.request.contextPath}/news/auditReject?id=${n.id}"
                                           class="btn btn-sm btn-outline-warning">驳回</a>
                                    </c:if>
                                    <a href="${pageContext.request.contextPath}/news/toUpdate?id=${n.id}"
                                       class="btn btn-sm btn-outline-secondary" title="编辑">
                                        <i class="bi bi-pencil"></i>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/news/delete?id=${n.id}"
                                       class="btn btn-sm btn-outline-danger" title="删除"
                                       onclick="return confirm('确定删除该新闻吗？删除后不可恢复')">
                                        <i class="bi bi-trash"></i>
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty page.records}">
                            <tr><td colspan="8" class="text-center text-muted py-4">暂无新闻</td></tr>
                        </c:if>
                    </tbody>
                </table>

                <div class="d-flex justify-content-between align-items-center mt-2">
                    <small class="text-muted">共 ${page.total} 条，当前第 ${page.current}/${page.pages == 0 ? 1 : page.pages} 页</small>
                    <c:if test="${page.pages > 1}">
                        <nav aria-label="分页导航">
                            <ul class="pagination mb-0">
                                <li class="page-item ${page.current le 1 ? 'disabled' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/news/list?current=${page.current - 1}&title=${fn:escapeXml(title)}&category=${category}&status=${status}">上一页</a>
                                </li>
                                <c:forEach begin="1" end="${page.pages}" var="i">
                                    <li class="page-item ${page.current == i ? 'active' : ''}">
                                        <a class="page-link" href="${pageContext.request.contextPath}/news/list?current=${i}&title=${fn:escapeXml(title)}&category=${category}&status=${status}">${i}</a>
                                    </li>
                                </c:forEach>
                                <li class="page-item ${page.current ge page.pages ? 'disabled' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/news/list?current=${page.current + 1}&title=${fn:escapeXml(title)}&category=${category}&status=${status}">下一页</a>
                                </li>
                            </ul>
                        </nav>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/static/js/bootstrap.bundle.min.js"></script>
</body>
</html>
