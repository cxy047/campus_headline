package com.chenxy.interceptor;

import com.chenxy.entity.User;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

@Component
public class RoleInterceptor
implements HandlerInterceptor {
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        User user;
        HttpSession session = request.getSession(false);
        User user2 = user = session != null ? (User)session.getAttribute("loginUser") : null;
        if (user == null || !"admin".equals(user.getRole())) {
            response.setStatus(403);
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().write("<h3>无权访问：仅管理员可执行此操作</h3><a href=\"" + request.getContextPath() + "/index\">返回首页</a>");
            return false;
        }
        return true;
    }
}
