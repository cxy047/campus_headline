package com.chenxy.controller;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.chenxy.entity.Topic;
import com.chenxy.entity.User;
import com.chenxy.service.CommentService;
import com.chenxy.service.NewsLikeService;
import com.chenxy.service.TopicService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping(value={"/topic"})
public class TopicController {
    @Autowired
    private TopicService topicService;
    @Autowired
    private CommentService commentService;
    @Autowired
    private NewsLikeService newsLikeService;

    @GetMapping(value={""})
    public String list(@RequestParam(defaultValue="1") long current, @RequestParam(defaultValue="10") long size, Model model) {
        IPage<Topic> page = this.topicService.pageTopics(current, size);
        model.addAttribute("page", page);
        model.addAttribute("hotTopics", this.topicService.listHot(5));
        return "topic";
    }

    @GetMapping(value={"/detail"})
    public String detail(Integer id, Model model, HttpSession session) {
        if (id == null) {
            return "redirect:/topic";
        }
        Topic topic = this.topicService.findById(id);
        if (topic == null) {
            return "redirect:/topic";
        }
        this.topicService.incrementViews(id);
        model.addAttribute("topic", (Object)this.topicService.findById(id));
        model.addAttribute("hotTopics", this.topicService.listHot(5));
        model.addAttribute("comments", this.commentService.listByTarget(id, "topic"));
        model.addAttribute("commentCount", (Object)this.commentService.countByTarget(id, "topic"));
        model.addAttribute("likeCount", (Object)this.newsLikeService.countByTarget(id, "topic"));
        User loginUser = (User)session.getAttribute("loginUser");
        if (loginUser != null) {
            model.addAttribute("liked", (Object)this.newsLikeService.isLiked(id, loginUser.getId(), "topic"));
        } else {
            model.addAttribute("liked", (Object)false);
        }
        return "topicDetail";
    }

    @PostMapping(value={"/add"})
    public String add(@RequestParam String title, @RequestParam String content, HttpSession session, RedirectAttributes ra) {
        User loginUser = (User)session.getAttribute("loginUser");
        if (loginUser == null) {
            return "redirect:/login";
        }
        title = title == null ? "" : title.trim();
        String string = content = content == null ? "" : content.trim();
        if (title.isEmpty() || title.length() > 100) {
            ra.addFlashAttribute("errorMsg", (Object)"话题标题必填且不超过 100 字");
            return "redirect:/topic";
        }
        if (content.isEmpty() || content.length() > 1000) {
            ra.addFlashAttribute("errorMsg", (Object)"话题内容必填且不超过 1000 字");
            return "redirect:/topic";
        }
        Topic topic = new Topic();
        topic.setTitle(title);
        topic.setContent(content);
        topic.setUserId(loginUser.getId());
        topic.setAuthor(loginUser.getRealName());
        // 普通用户发起的话题进入待审核；管理员直接通过
        boolean isAdmin = "admin".equals(loginUser.getRole());
        topic.setStatus(isAdmin ? Topic.STATUS_APPROVED : Topic.STATUS_PENDING);
        this.topicService.add(topic);
        if (isAdmin) {
            ra.addFlashAttribute("successMsg", (Object)"话题发布成功");
        } else {
            ra.addFlashAttribute("successMsg", (Object)"话题已提交，管理员审核通过后展示");
        }
        return "redirect:/topic";
    }

    @GetMapping(value={"/manage"})
    public String manage(@RequestParam(defaultValue="1") long current, @RequestParam(defaultValue="10") long size, Model model) {
        model.addAttribute("page", this.topicService.pageManage(current, size));
        return "topicManage";
    }

    @GetMapping(value={"/auditPass"})
    public String auditPass(Integer id, RedirectAttributes ra) {
        this.topicService.auditPass(id);
        ra.addFlashAttribute("successMsg", (Object)"话题已通过审核");
        return "redirect:/topic/manage";
    }

    @GetMapping(value={"/auditReject"})
    public String auditReject(Integer id, RedirectAttributes ra) {
        this.topicService.auditReject(id);
        ra.addFlashAttribute("successMsg", (Object)"话题已驳回");
        return "redirect:/topic/manage";
    }

    @PostMapping(value={"/edit"})
    public String edit(@RequestParam Integer id, @RequestParam String title, @RequestParam String content, RedirectAttributes ra) {
        title = title == null ? "" : title.trim();
        content = content == null ? "" : content.trim();
        if (title.isEmpty() || title.length() > 100) {
            ra.addFlashAttribute("errorMsg", (Object)"话题标题必填且不超过 100 字");
            return "redirect:/topic/manage";
        }
        if (content.isEmpty() || content.length() > 1000) {
            ra.addFlashAttribute("errorMsg", (Object)"话题内容必填且不超过 1000 字");
            return "redirect:/topic/manage";
        }
        Topic topic = new Topic();
        topic.setId(id);
        topic.setTitle(title);
        topic.setContent(content);
        this.topicService.update(topic);
        ra.addFlashAttribute("successMsg", (Object)"话题已更新");
        return "redirect:/topic/manage";
    }

    @GetMapping(value={"/delete"})
    public String delete(Integer id, RedirectAttributes ra) {
        if (id == null || !this.topicService.deleteById(id)) {
            ra.addFlashAttribute("errorMsg", (Object)"话题不存在或已被删除");
        } else {
            ra.addFlashAttribute("successMsg", (Object)"话题已删除");
        }
        return "redirect:/topic/manage";
    }
}
