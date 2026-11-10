<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>校园头条 - 注册</title>
    <link href="${pageContext.request.contextPath}/static/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root { --brand:#00A86B; --brand-dark:#00875A; }
        body {
            background: linear-gradient(180deg, #F4F7F5 0%, #EAF3EE 100%);
            min-height: 100vh;
            display: flex; align-items: center;
            font-family: "Noto Sans SC", "Microsoft YaHei", "PingFang SC", system-ui, sans-serif;
        }
        .register-card {
            border: 0; border-radius: 22px;
            box-shadow: 0 24px 60px rgba(0,107,79,.16);
            padding: 46px 44px;
        }
        .reg-icon {
            width: 58px; height: 58px; border-radius: 16px; margin: 0 auto 16px;
            background: linear-gradient(135deg, #00A86B, #16A095); color: #fff;
            display: grid; place-items: center; font-size: 1.6rem;
            box-shadow: 0 8px 20px rgba(0,168,107,.3);
        }
        .register-card h3 { font-weight: 800; }
        .form-label { font-weight: 600; font-size: .85rem; }
        .form-control { border-radius: 10px; padding: 11px 15px; border-color: #DDE7E1; background: #FBFDFC; }
        .form-control:focus { border-color: #6FD3A9; box-shadow: 0 0 0 3px rgba(0,168,107,.12); background: #fff; }
        .btn-register {
            background: var(--brand); border: 0; border-radius: 10px;
            padding: 12px; font-weight: 700; color: #fff;
        }
        .btn-register:hover { background: var(--brand-dark); color: #fff; }
        .login-link { color: var(--brand-dark); font-weight: 700; text-decoration: none; }
        .login-link:hover { color: var(--brand); }
    </style>
</head>
<body>
<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-7 col-lg-5">
            <div class="card register-card">
                <div class="text-center mb-4">
                    <div class="reg-icon"><i class="bi bi-person-plus"></i></div>
                    <h3>注册新账号</h3>
                    <p class="text-muted small">加入校园头条，第一时间获取校园资讯</p>
                </div>

                <c:if test="${not empty msg}">
                    <div class="alert alert-warning"><i class="bi bi-exclamation-triangle me-1"></i>${msg}</div>
                </c:if>

                <form action="${pageContext.request.contextPath}/user/register" method="post">
                    <div class="mb-3">
                        <label class="form-label">账号</label>
                        <input type="text" name="username" class="form-control" placeholder="4-20位字母或数字" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">密码</label>
                        <input type="password" name="password" class="form-control" placeholder="至少6位" required>
                    </div>
                    <div class="mb-4">
                        <label class="form-label">真实姓名</label>
                        <input type="text" name="realName" class="form-control" placeholder="请输入真实姓名" required>
                    </div>
                    <button type="submit" class="btn btn-register w-100 mb-3">
                        <i class="bi bi-person-plus-fill me-1"></i>立即注册
                    </button>
                    <div class="text-center text-muted small">
                        已有账号？
                        <a href="${pageContext.request.contextPath}/login" class="login-link">立即登录 →</a>
                    </div>
                    <div class="mt-3 text-center">
                        <a href="${pageContext.request.contextPath}/index" class="text-muted text-decoration-none small">← 返回首页</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<script src="${pageContext.request.contextPath}/static/js/bootstrap.bundle.min.js"></script>
</body>
</html>
