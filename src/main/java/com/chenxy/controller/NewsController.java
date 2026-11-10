package com.chenxy.controller;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.chenxy.entity.News;
import com.chenxy.service.NewsService;
import com.chenxy.util.CoverStorage;
import java.util.HashMap;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/news")
public class NewsController {

    @Autowired
    private NewsService newsService;

    @GetMapping("/list")
    public String list(@RequestParam(defaultValue = "1") long current,
                       @RequestParam(defaultValue = "10") long size,
                       @RequestParam(required = false) String title,
                       @RequestParam(required = false) String category,
                       @RequestParam(required = false) Integer status,
                       @RequestParam(required = false) String orderBy,
                       Model model) {
        Map<String, Object> params = new HashMap<>();
        if (title != null && !title.isEmpty()) {
            params.put("title", title);
        }
        if (category != null && !category.isEmpty()) {
            params.put("category", category);
        }
        if (status != null) {
            params.put("status", status);
        }
        if (orderBy != null) {
            params.put("orderBy", orderBy);
        }
        IPage<News> page = newsService.pageNews(current, size, params);
        model.addAttribute("page", page);
        model.addAttribute("title", title);
        model.addAttribute("category", category);
        model.addAttribute("status", status);
        model.addAttribute("orderBy", orderBy);
        return "newsList";
    }

    @GetMapping("/toAdd")
    public String toAdd() {
        return "newsAdd";
    }

    @PostMapping("/add")
    public String add(News news,
                      @RequestParam(required = false) String action,
                      @RequestParam(required = false) MultipartFile coverFile,
                      RedirectAttributes ra) {
        if (!saveCover(news, coverFile, ra)) {
            return "redirect:/news/toAdd";
        }
        news.setViews(0);
        if ("publish".equals(action)) {
            news.setStatus(News.STATUS_PUBLISHED);
        } else {
            news.setStatus(News.STATUS_DRAFT);
        }
        newsService.add(news);
        ra.addFlashAttribute("successMsg", "publish".equals(action) ? "已提交审核" : "草稿已保存");
        return "redirect:/news/list";
    }

    @GetMapping("/toUpdate")
    public String toUpdate(Integer id, Model model) {
        model.addAttribute("news", newsService.findById(id));
        return "newsUpdate";
    }

    @PostMapping("/update")
    public String update(News news,
                         @RequestParam(required = false) MultipartFile coverFile,
                         RedirectAttributes ra) {
        if (!saveCover(news, coverFile, ra)) {
            return "redirect:/news/toUpdate?id=" + news.getId();
        }
        newsService.update(news);
        ra.addFlashAttribute("successMsg", "新闻已更新");
        return "redirect:/news/list";
    }

    private boolean saveCover(News news, MultipartFile coverFile, RedirectAttributes ra) {
        if (coverFile == null || coverFile.isEmpty()) {
            return true;
        }
        try {
            news.setCover(CoverStorage.save(coverFile));
            return true;
        } catch (IllegalArgumentException e) {
            ra.addFlashAttribute("errorMsg", e.getMessage());
            return false;
        } catch (Exception e) {
            ra.addFlashAttribute("errorMsg", "封面上传失败：" + e.getMessage());
            return false;
        }
    }

    @GetMapping("/delete")
    public String delete(Integer id, RedirectAttributes ra) {
        newsService.deleteById(id);
        ra.addFlashAttribute("successMsg", "新闻已删除");
        return "redirect:/news/list";
    }

    @GetMapping("/submitAudit")
    public String submitAudit(Integer id) {
        newsService.submitAudit(id);
        return "redirect:/news/list";
    }

    @GetMapping("/auditPass")
    public String auditPass(Integer id) {
        newsService.auditPass(id);
        return "redirect:/news/list";
    }

    @GetMapping("/auditReject")
    public String auditReject(Integer id) {
        newsService.auditReject(id);
        return "redirect:/news/list";
    }

    @GetMapping("/detail")
    public String detail(Integer id) {
        return "redirect:/detail?id=" + id;
    }
}
