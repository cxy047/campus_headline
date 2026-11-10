<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>校园头条 - 登录</title>
    <link href="${pageContext.request.contextPath}/static/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root { --brand:#00A86B; --brand-dark:#00875A; --brand-deep:#006B4F; --brand-line:#CBEBDA; }
        body {
            background: linear-gradient(180deg, #F4F7F5 0%, #EAF3EE 100%);
            min-height: 100vh;
            display: flex; align-items: center;
            font-family: "Noto Sans SC", "Microsoft YaHei", "PingFang SC", system-ui, sans-serif;
        }
        .login-card {
            border: 0; border-radius: 22px; overflow: hidden;
            box-shadow: 0 24px 60px rgba(0,107,79,.16);
        }
        .login-left {
            position: relative; overflow: hidden;
            background: linear-gradient(150deg, #006B4F 0%, #00A86B 60%, #16A095 100%);
            padding: 52px 42px; color: #fff;
        }
        .login-left::before {
            content: ""; position: absolute; width: 220px; height: 220px; border-radius: 50%;
            right: -60px; top: -70px; background: rgba(255,255,255,.10);
        }
        .login-left::after {
            content: ""; position: absolute; width: 150px; height: 150px; border-radius: 50%;
            left: -50px; bottom: -50px; background: rgba(255,255,255,.08);
        }
        .brand-box {
            width: 52px; height: 52px; border-radius: 14px;
            background: rgba(255,255,255,.16); border: 1px solid rgba(255,255,255,.25);
            display: grid; place-items: center; font-size: 1.4rem; margin-bottom: 22px;
        }
        .login-left h1 { font-weight: 800; font-size: 1.8rem; }
        .login-left .sub { color: rgba(255,255,255,.75); font-size: .9rem; margin-bottom: 30px; }
        .feat { display: flex; align-items: center; gap: 10px; color: rgba(255,255,255,.88); font-size: .9rem; margin-bottom: 14px; }
        .feat i {
            width: 20px; height: 20px; border-radius: 50%; flex: 0 0 auto;
            background: rgba(255,255,255,.2); display: grid; place-items: center; font-size: .7rem;
        }
        .login-right { padding: 52px 46px; background: #fff; }
        .login-right h3 { font-weight: 800; }
        .login-right .tip { color: #6B7280; font-size: .85rem; margin-bottom: 28px; }
        .form-label { font-weight: 600; font-size: .85rem; }
        .form-control { border-radius: 10px; padding: 11px 15px; border-color: #DDE7E1; background: #FBFDFC; }
        .form-control:focus { border-color: #6FD3A9; box-shadow: 0 0 0 3px rgba(0,168,107,.12); background: #fff; }
        .btn-login {
            background: var(--brand); border: 0; border-radius: 10px;
            padding: 12px; font-weight: 700; color: #fff;
        }
        .btn-login:hover { background: var(--brand-dark); color: #fff; }
        .reg-link { color: var(--brand-dark); font-weight: 700; text-decoration: none; }
        .reg-link:hover { color: var(--brand); }
        .msg-error {
            background: #FEF2F2; border-left: 4px solid #DC2626; color: #B91C1C;
            padding: 11px 15px; border-radius: 10px; margin-bottom: 18px; font-size: .88rem;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="row justify-content-center">
        <div class="col-lg-9 col-xl-8">
            <div class="card login-card">
                <div class="row g-0">
                    <!-- 左侧品牌区 -->
                    <div class="col-md-5 login-left d-none d-md-block">
                        <div class="brand-box"><i class="bi bi-newspaper"></i></div>
                        <h1>校园头条</h1>
                        <p class="sub">校园新闻资讯系统</p>
                        <div class="feat"><i class="bi bi-check"></i>新闻浏览、搜索与分类</div>
                        <div class="feat"><i class="bi bi-check"></i>新闻投稿与审核发布</div>
                        <div class="feat"><i class="bi bi-check"></i>评论、点赞与个人中心</div>
                    </div>
                    <!-- 右侧登录表单 -->
                    <div class="col-md-7 login-right">
                        <h3>欢迎回来</h3>
                        <p class="tip">登录后即可评论、点赞、投稿并管理个人信息</p>

                        <c:if test="${not empty msg}">
                            <div class="msg-error"><i class="bi bi-exclamation-circle me-1"></i>${msg}</div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/user/login" method="post">
                            <div class="mb-3">
                                <label class="form-label">账号</label>
                                <input type="text" name="username" class="form-control" placeholder="请输入账号" required>
                            </div>
                            <div class="mb-4">
                                <label class="form-label">密码</label>
                                <input type="password" name="password" class="form-control" placeholder="请输入密码" required>
                            </div>
                            <button type="submit" class="btn btn-login w-100 mb-4">
                                <i class="bi bi-box-arrow-in-right me-1"></i>登 录
                            </button>
                            <div class="d-flex justify-content-between small">
                                <span class="text-muted">还没有账号？</span>
                                <a href="${pageContext.request.contextPath}/register" class="reg-link">立即注册 →</a>
                            </div>
                            <div class="mt-4 text-center">
                                <a href="${pageContext.request.contextPath}/index" class="text-muted text-decoration-none small">← 返回首页</a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="${pageContext.request.contextPath}/static/js/bootstrap.bundle.min.js"></script>
</body>
</html>
