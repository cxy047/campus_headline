<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>话题管理 - 校园头条后台</title>
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
        .topic-content-cell {
            max-width: 320px; color: #6B7280; font-size: .84rem;
            white-space: nowrap; overflow: hidden; text-overflow: ellipsis;
        }
        .btn-outline-primary {
            --bs-btn-color: var(--brand-dark); --bs-btn-border-color: var(--brand-line);
            --bs-btn-hover-bg: var(--brand); --bs-btn-hover-border-color: var(--brand); --bs-btn-hover-color: #fff;
            font-weight: 600;
        }
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
            <a href="${pageContext.request.contextPath}/news/list"><i class="bi bi-file-earmark-text"></i> 新闻管理</a>
            <a href="${pageContext.request.contextPath}/video/manage"><i class="bi bi-play-circle"></i> 视频管理</a>
            <a href="${pageContext.request.contextPath}/topic/manage" class="active"><i class="bi bi-chat-square-text"></i> 话题管理</a>
            <a href="${pageContext.request.contextPath}/material/list"><i class="bi bi-images"></i> 素材管理</a>
            <a href="${pageContext.request.contextPath}/user/logout"><i class="bi bi-box-arrow-right"></i> 退出登录</a>
        </div>
        <!-- 主内容 -->
        <div class="col-md-10 content-area">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h3 class="mb-1">话题管理</h3>
                    <small class="text-muted">欢迎回来，${loginUser.realName}（${loginUser.role}）</small>
                </div>
                <a href="${pageContext.request.contextPath}/topic" target="_blank" class="btn btn-outline-primary">
                    <i class="bi bi-box-arrow-up-right"></i> 查看话题广场
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

            <div class="card p-4">
                <table class="table table-hover align-middle">
                    <thead>
                        <tr>
                            <th style="width:60px">ID</th>
                            <th style="width:220px">话题</th>
                            <th>内容摘要</th>
                            <th style="width:90px">状态</th>
                            <th style="width:100px">发起者</th>
                            <th style="width:90px">浏览量</th>
                            <th style="width:120px">发起时间</th>
                            <th style="width:280px">操作</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="t" items="${page.records}">
                            <tr>
                                <td>${t.id}</td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/topic/detail?id=${t.id}" target="_blank">#${fn:escapeXml(t.title)}#</a>
                                </td>
                                <td class="topic-content-cell">${fn:escapeXml(t.content)}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${t.status == 1}"><span class="badge bg-warning text-dark">待审核</span></c:when>
                                        <c:when test="${t.status == 3}"><span class="badge bg-danger">已驳回</span></c:when>
                                        <c:otherwise><span class="badge bg-success">已审核</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${fn:escapeXml(t.author)}</td>
                                <td>${t.views}</td>
                                <td><fmt:formatDate value="${t.createTime}" pattern="yyyy-MM-dd"/></td>
                                <td>
                                    <c:if test="${t.status == 1 || t.status == 3}">
                                        <a href="${pageContext.request.contextPath}/topic/auditPass?id=${t.id}"
                                           class="btn btn-sm btn-outline-success">通过</a>
                                    </c:if>
                                    <c:if test="${t.status == 1 || t.status == 2}">
                                        <a href="${pageContext.request.contextPath}/topic/auditReject?id=${t.id}"
                                           class="btn btn-sm btn-outline-primary">驳回</a>
                                    </c:if>
                                    <a href="${pageContext.request.contextPath}/topic/detail?id=${t.id}" target="_blank"
                                       class="btn btn-sm btn-outline-secondary">查看</a>
                                    <button type="button" class="btn btn-sm btn-outline-warning btn-edit-topic"
                                            data-id="${t.id}"
                                            data-title="${fn:escapeXml(t.title)}"
                                            data-content="${fn:escapeXml(t.content)}">编辑</button>
                                    <a href="${pageContext.request.contextPath}/topic/delete?id=${t.id}"
                                       class="btn btn-sm btn-outline-danger"
                                       onclick="return confirm('确定删除该话题吗？删除后不可恢复')">删除</a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty page.records}">
                            <tr><td colspan="8" class="text-center text-muted py-4">暂无话题</td></tr>
                        </c:if>
                    </tbody>
                </table>

                <c:if test="${page.pages > 1}">
                    <nav class="mt-3" aria-label="分页导航">
                        <ul class="pagination justify-content-center mb-0">
                            <li class="page-item ${page.current le 1 ? 'disabled' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/topic/manage?current=${page.current - 1}">上一页</a>
                            </li>
                            <c:forEach begin="1" end="${page.pages}" var="i">
                                <li class="page-item ${page.current == i ? 'active' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/topic/manage?current=${i}">${i}</a>
                                </li>
                            </c:forEach>
                            <li class="page-item ${page.current ge page.pages ? 'disabled' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/topic/manage?current=${page.current + 1}">下一页</a>
                            </li>
                        </ul>
                    </nav>
                </c:if>
            </div>
        </div>
    </div>
</div>

<!-- 编辑话题弹窗 -->
<div class="modal fade" id="editTopicModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content" style="border:0;border-radius:16px">
            <div class="modal-header" style="background:linear-gradient(135deg,#006B4F,#00A86B);color:#fff;border:0">
                <h5 class="modal-title fw-bold"><i class="bi bi-pencil-square me-2"></i>编辑话题</h5>
                <button type="button" class="btn-close" style="filter:brightness(0) invert(1)" data-bs-dismiss="modal" aria-label="关闭"></button>
            </div>
            <form action="${pageContext.request.contextPath}/topic/edit" method="post">
                <input type="hidden" name="id" id="et_id">
                <div class="modal-body p-4">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">话题标题 <span class="text-danger">*</span></label>
                        <input type="text" name="title" id="et_title" class="form-control" maxlength="100" required>
                    </div>
                    <div class="mb-1">
                        <label class="form-label fw-semibold">话题内容 <span class="text-danger">*</span></label>
                        <textarea name="content" id="et_content" class="form-control" rows="4" maxlength="1000" required></textarea>
                    </div>
                </div>
                <div class="modal-footer" style="border-top:1px solid #EEF2F0">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">取消</button>
                    <button type="submit" class="btn btn-primary" style="--bs-btn-bg:#00A86B;--bs-btn-border-color:#00A86B;">
                        <i class="bi bi-check2 me-1"></i>保存修改
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/static/js/bootstrap.bundle.min.js"></script>
<script>
    // 编辑按钮：把当前行数据填充进编辑弹窗
    document.querySelectorAll('.btn-edit-topic').forEach(function (btn) {
        btn.addEventListener('click', function () {
            document.getElementById('et_id').value = this.dataset.id;
            document.getElementById('et_title').value = this.dataset.title;
            document.getElementById('et_content').value = this.dataset.content;
            new bootstrap.Modal(document.getElementById('editTopicModal')).show();
        });
    });
</script>
</body>
</html>
