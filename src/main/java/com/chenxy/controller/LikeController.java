package com.chenxy.controller;

import com.chenxy.entity.User;
import com.chenxy.service.NewsLikeService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping(value={"/like"})
public class LikeController {
    @Autowired
    private NewsLikeService newsLikeService;

    @GetMapping(value={"/toggle"})
    public String toggle(@RequestParam(required=false) Integer targetId, @RequestParam(required=false) Integer newsId, @RequestParam(required=false, defaultValue="news") String targetType, HttpSession session) {
        Integer realTargetId = targetId != null ? targetId : newsId;
        User user = (User)session.getAttribute("loginUser");
        if (user == null || realTargetId == null) {
            return "redirect:/login";
        }
        this.newsLikeService.toggle(realTargetId, user.getId(), targetType);
        return this.redirectToDetail(realTargetId, targetType);
    }

    private String redirectToDetail(Integer targetId, String targetType) {
        switch (targetType) {
            case "video": {
                return "redirect:/video/detail?id=" + targetId;
            }
            case "topic": {
                return "redirect:/topic/detail?id=" + targetId;
            }
        }
        return "redirect:/detail?id=" + targetId;
    }
}
