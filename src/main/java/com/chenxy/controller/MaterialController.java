package com.chenxy.controller;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.chenxy.entity.Material;
import com.chenxy.entity.User;
import com.chenxy.service.MaterialService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

@Controller
@RequestMapping(value={"/material"})
public class MaterialController {
    @Autowired
    private MaterialService materialService;

    @GetMapping(value={"/list"})
    public String list(@RequestParam(defaultValue="1") long current, @RequestParam(defaultValue="10") long size, Model model) {
        IPage<Material> page = this.materialService.pageMaterials(current, size);
        model.addAttribute("page", page);
        return "materialList";
    }

    @GetMapping(value={"/toUpload"})
    public String toUpload() {
        return "materialUpload";
    }

    @PostMapping(value={"/upload"})
    public String upload(@RequestParam(value="file") MultipartFile file, HttpSession session, Model model) {
        try {
            User user = (User)session.getAttribute("loginUser");
            Integer userId = user != null ? user.getId() : null;
            this.materialService.upload(file, userId);
            return "redirect:/material/list";
        }
        catch (Exception e) {
            model.addAttribute("msg", (Object)("上传失败：" + e.getMessage()));
            return "materialUpload";
        }
    }

    @GetMapping(value={"/delete"})
    public String delete(Integer id) {
        this.materialService.deleteById(id);
        return "redirect:/material/list";
    }
}
