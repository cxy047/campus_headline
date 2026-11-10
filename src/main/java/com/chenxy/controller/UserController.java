package com.chenxy.controller;

import com.chenxy.entity.User;
import com.chenxy.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping(value={"/user"})
public class UserController {
    @Autowired
    private UserService userService;

    @GetMapping(value={"/login"})
    public String loginPage() {
        return "login";
    }

    @PostMapping(value={"/login"})
    public String login(String username, String password, HttpSession session, Model model) {
        User user = this.userService.login(username, password);
        if (user != null) {
            session.setAttribute("loginUser", (Object)user);
            return "redirect:/index";
        }
        model.addAttribute("msg", (Object)"账号或密码错误！");
        return "login";
    }

    @GetMapping(value={"/register"})
    public String registerPage() {
        return "register";
    }

    @PostMapping(value={"/register"})
    public String register(User user, Model model) {
        boolean success = this.userService.register(user);
        if (success) {
            model.addAttribute("msg", (Object)"注册成功，请登录！");
            return "login";
        }
        model.addAttribute("msg", (Object)"注册失败：用户名已存在！");
        return "register";
    }

    @GetMapping(value={"/logout"})
    public String logout(HttpSession session) {
        session.removeAttribute("loginUser");
        session.invalidate();
        return "redirect:/login";
    }
}
