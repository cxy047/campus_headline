package com.chenxy.controller;

import com.chenxy.entity.User;
import com.chenxy.service.CommentService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping(value={"/comment"})
public class CommentController {
    @Autowired
    private CommentService commentService;

    @PostMapping(value={"/add"})
    public String add(@RequestParam(required=false) Integer targetId, @RequestParam(required=false) Integer newsId, @RequestParam(required=false, defaultValue="news") String targetType, @RequestParam String content, HttpSession session) {
        Integer realTargetId;
        Integer n = realTargetId = targetId != null ? targetId : newsId;
        if (realTargetId == null) {
            return "redirect:/login";
        }
        User user = (User)session.getAttribute("loginUser");
        if (user == null) {
            return "redirect:/login";
        }
        this.commentService.addTargetComment(realTargetId, user.getId(), content, targetType);
        return this.redirectToDetail(realTargetId, targetType);
    }

    @GetMapping(value={"/delete"})
    public String delete(@RequestParam Integer id, @RequestParam(required=false) Integer targetId, @RequestParam(required=false) Integer newsId, @RequestParam(required=false, defaultValue="news") String targetType, HttpSession session) {
        Integer realTargetId = targetId != null ? targetId : newsId;
        User user = (User)session.getAttribute("loginUser");
        if (user == null || realTargetId == null) {
            return "redirect:/login";
        }
        boolean admin = "admin".equals(user.getRole());
        this.commentService.delete(id, user.getId(), admin);
        return this.redirectToDetail(realTargetId, targetType);
    }

    private String redirectToDetail(Integer targetId, String targetType) {
        String hash = "#comments";
        switch (targetType) {
            case "video": {
                return "redirect:/video/detail?id=" + targetId + hash;
            }
            case "topic": {
                return "redirect:/topic/detail?id=" + targetId + hash;
            }
        }
        return "redirect:/detail?id=" + targetId + hash;
    }
}
