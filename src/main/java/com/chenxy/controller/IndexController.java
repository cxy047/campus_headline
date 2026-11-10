package com.chenxy.controller;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.chenxy.entity.Comment;
import com.chenxy.entity.News;
import com.chenxy.entity.User;
import com.chenxy.service.CommentService;
import com.chenxy.service.NewsLikeService;
import com.chenxy.service.NewsService;
import com.chenxy.service.TopicService;
import com.chenxy.service.VideoService;
import jakarta.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class IndexController {
    @Autowired
    private NewsService newsService;
    @Autowired
    private CommentService commentService;
    @Autowired
    private NewsLikeService newsLikeService;
    @Autowired
    private VideoService videoService;
    @Autowired
    private TopicService topicService;

    @GetMapping(value={"/index"})
    public String index(@RequestParam(defaultValue="1") long current, @RequestParam(defaultValue="10") long size, @RequestParam(required=false) String keyword, @RequestParam(required=false) String category, Model model) {
        HashMap<String, Object> params = new HashMap<String, Object>();
        params.put("status", 2);
        if (keyword != null && !keyword.isEmpty()) {
            params.put("title", keyword);
        }
        if (category != null && !category.isEmpty()) {
            params.put("category", category);
        }
        IPage<News> page = this.newsService.pageNews(current, size, params);
        model.addAttribute("page", page);
        model.addAttribute("hotNews", this.newsService.listHot(5));
        model.addAttribute("latestNews", this.newsService.listLatest(5));
        model.addAttribute("videoTotal", (Object)this.videoService.countAll());
        model.addAttribute("topicTotal", (Object)this.topicService.countAll());
        model.addAttribute("keyword", (Object)keyword);
        model.addAttribute("category", (Object)category);
        return "index";
    }

    @GetMapping(value={"/detail"})
    public String detail(Integer id, Model model, HttpSession session) {
        boolean owner;
        if (id == null) {
            return "redirect:/index";
        }
        News news = this.newsService.findById(id);
        if (news == null) {
            return "redirect:/index";
        }
        User loginUser = (User)session.getAttribute("loginUser");
        boolean admin = loginUser != null && "admin".equals(loginUser.getRole());
        boolean bl = owner = loginUser != null && news.getUserId() != null && news.getUserId().equals(loginUser.getId());
        if (news.getStatus() != 2 && !owner && !admin) {
            return "redirect:/index";
        }
        this.newsService.incrementViews(id);
        news = this.newsService.findById(id);
        model.addAttribute("news", (Object)news);
        List<Comment> comments = this.commentService.listByNews(id);
        model.addAttribute("comments", comments);
        model.addAttribute("commentCount", (Object)comments.size());
        model.addAttribute("likeCount", (Object)this.newsLikeService.countByNews(id));
        model.addAttribute("liked", (Object)(loginUser != null && this.newsLikeService.isLiked(id, loginUser.getId()) ? 1 : 0));
        return "detail";
    }

    @GetMapping(value={"/"})
    public String root() {
        return "redirect:/index";
    }

    @GetMapping(value={"/login"})
    public String loginPage() {
        return "login";
    }

    @GetMapping(value={"/register"})
    public String registerPage() {
        return "register";
    }
}
