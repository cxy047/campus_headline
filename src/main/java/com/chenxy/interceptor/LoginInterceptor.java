package com.chenxy.interceptor;

import com.chenxy.entity.User;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

@Component
public class LoginInterceptor
implements HandlerInterceptor {
    public static final String SESSION_USER_KEY = "loginUser";

    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        User user;
        HttpSession session = request.getSession(false);
        User user2 = user = session != null ? (User)session.getAttribute(SESSION_USER_KEY) : null;
        if (user == null) {
            String accept = request.getHeader("Accept");
            if (accept != null && accept.contains("application/json")) {
                response.setStatus(401);
                return false;
            }
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        return true;
    }
}
