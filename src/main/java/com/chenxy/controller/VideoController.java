package com.chenxy.controller;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.chenxy.entity.User;
import com.chenxy.entity.Video;
import com.chenxy.service.CommentService;
import com.chenxy.service.NewsLikeService;
import com.chenxy.service.VideoService;
import com.chenxy.util.CoverStorage;
import com.chenxy.util.MaterialStorage;
import jakarta.servlet.http.HttpSession;
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
@RequestMapping(value={"/video"})
public class VideoController {
    @Autowired
    private VideoService videoService;
    @Autowired
    private CommentService commentService;
    @Autowired
    private NewsLikeService newsLikeService;

    @GetMapping(value={""})
    public String list(@RequestParam(defaultValue="1") long current, @RequestParam(defaultValue="8") long size, Model model) {
        IPage<Video> page = this.videoService.pageVideos(current, size);
        model.addAttribute("page", page);
        return "video";
    }

    @GetMapping(value={"/detail"})
    public String detail(Integer id, Model model, HttpSession session) {
        if (id == null) {
            return "redirect:/video";
        }
        Video video = this.videoService.findById(id);
        if (video == null) {
            return "redirect:/video";
        }
        this.videoService.incrementViews(id);
        video = this.videoService.findById(id);
        model.addAttribute("video", (Object)video);
        model.addAttribute("latestVideos", this.videoService.listLatest(5));
        model.addAttribute("comments", this.commentService.listByTarget(id, "video"));
        model.addAttribute("commentCount", (Object)this.commentService.countByTarget(id, "video"));
        model.addAttribute("likeCount", (Object)this.newsLikeService.countByTarget(id, "video"));
        User loginUser = (User)session.getAttribute("loginUser");
        if (loginUser != null) {
            model.addAttribute("liked", (Object)this.newsLikeService.isLiked(id, loginUser.getId(), "video"));
        } else {
            model.addAttribute("liked", (Object)false);
        }
        return "videoPlay";
    }

    @GetMapping(value={"/manage"})
    public String manage(@RequestParam(defaultValue="1") long current, @RequestParam(defaultValue="10") long size, Model model) {
        model.addAttribute("page", this.videoService.pageManage(current, size));
        return "videoManage";
    }

    @PostMapping(value={"/add"})
    public String add(@RequestParam String title, @RequestParam(required=false) String url, @RequestParam(required=false) String description, @RequestParam(required=false) String cover, @RequestParam(required=false) MultipartFile coverFile, @RequestParam(required=false) MultipartFile videoFile, @RequestParam(required=false) String author, @RequestParam(required=false) String duration, RedirectAttributes ra) {
        title = title == null ? "" : title.trim();
        url = url == null ? "" : url.trim();
        if (title.isEmpty() || title.length() > 200) {
            ra.addFlashAttribute("errorMsg", (Object)"视频标题必填且不超过 200 字");
            return "redirect:/video/manage";
        }
        // 本地上传的视频文件优先于手动填写的地址
        if (videoFile != null && !videoFile.isEmpty()) {
            try {
                url = MaterialStorage.save(videoFile);
            }
            catch (IllegalArgumentException e) {
                ra.addFlashAttribute("errorMsg", (Object)e.getMessage());
                return "redirect:/video/manage";
            }
            catch (Exception e) {
                ra.addFlashAttribute("errorMsg", (Object)("视频上传失败：" + e.getMessage()));
                return "redirect:/video/manage";
            }
        }
        if (url.isEmpty() || url.length() > 500) {
            ra.addFlashAttribute("errorMsg", (Object)"请填写视频地址或上传本地视频文件");
            return "redirect:/video/manage";
        }
        Video video = new Video();
        video.setTitle(title);
        video.setUrl(url);
        video.setDescription(description);
        if (coverFile != null && !coverFile.isEmpty()) {
            try {
                video.setCover(CoverStorage.save(coverFile));
            }
            catch (IllegalArgumentException e) {
                ra.addFlashAttribute("errorMsg", (Object)e.getMessage());
                return "redirect:/video/manage";
            }
            catch (Exception e) {
                ra.addFlashAttribute("errorMsg", (Object)("封面上传失败：" + e.getMessage()));
                return "redirect:/video/manage";
            }
        } else {
            video.setCover(cover);
        }
        video.setAuthor(author == null || author.trim().isEmpty() ? "校园头条" : author.trim());
        video.setDuration(duration);
        // 管理员后台发布的视频直接进入已审核状态
        video.setStatus(Video.STATUS_APPROVED);
        this.videoService.add(video);
        ra.addFlashAttribute("successMsg", (Object)"视频添加成功");
        return "redirect:/video/manage";
    }

    @PostMapping(value={"/edit"})
    public String edit(@RequestParam Integer id, @RequestParam String title, @RequestParam(required=false) String url, @RequestParam(required=false) String description, @RequestParam(required=false) String cover, @RequestParam(required=false) MultipartFile coverFile, @RequestParam(required=false) MultipartFile videoFile, @RequestParam(required=false) String author, @RequestParam(required=false) String duration, RedirectAttributes ra) {
        Video existing = this.videoService.findById(id);
        if (existing == null) {
            ra.addFlashAttribute("errorMsg", (Object)"视频不存在");
            return "redirect:/video/manage";
        }
        title = title == null ? "" : title.trim();
        url = url == null ? "" : url.trim();
        if (title.isEmpty() || title.length() > 200) {
            ra.addFlashAttribute("errorMsg", (Object)"视频标题必填且不超过 200 字");
            return "redirect:/video/manage";
        }
        // 重新上传了视频文件则替换原地址，否则保持表单中的地址
        if (videoFile != null && !videoFile.isEmpty()) {
            try {
                url = MaterialStorage.save(videoFile);
            }
            catch (IllegalArgumentException e) {
                ra.addFlashAttribute("errorMsg", (Object)e.getMessage());
                return "redirect:/video/manage";
            }
            catch (Exception e) {
                ra.addFlashAttribute("errorMsg", (Object)("视频上传失败：" + e.getMessage()));
                return "redirect:/video/manage";
            }
        }
        if (url.isEmpty() || url.length() > 500) {
            ra.addFlashAttribute("errorMsg", (Object)"请填写视频地址或上传本地视频文件");
            return "redirect:/video/manage";
        }
        Video video = new Video();
        video.setId(id);
        video.setTitle(title);
        video.setUrl(url);
        video.setDescription(description);
        if (coverFile != null && !coverFile.isEmpty()) {
            try {
                video.setCover(CoverStorage.save(coverFile));
            }
            catch (IllegalArgumentException e) {
                ra.addFlashAttribute("errorMsg", (Object)e.getMessage());
                return "redirect:/video/manage";
            }
            catch (Exception e) {
                ra.addFlashAttribute("errorMsg", (Object)("封面上传失败：" + e.getMessage()));
                return "redirect:/video/manage";
            }
        } else {
            video.setCover(cover);
        }
        video.setAuthor(author == null || author.trim().isEmpty() ? "校园头条" : author.trim());
        video.setDuration(duration);
        this.videoService.update(video);
        ra.addFlashAttribute("successMsg", (Object)"视频已更新");
        return "redirect:/video/manage";
    }

    @GetMapping(value={"/delete"})
    public String delete(Integer id, RedirectAttributes ra) {
        if (id == null || !this.videoService.deleteById(id)) {
            ra.addFlashAttribute("errorMsg", (Object)"视频不存在或已被删除");
        } else {
            ra.addFlashAttribute("successMsg", (Object)"视频已删除");
        }
        return "redirect:/video/manage";
    }

    @GetMapping(value={"/auditPass"})
    public String auditPass(Integer id, RedirectAttributes ra) {
        if (id == null) {
            ra.addFlashAttribute("errorMsg", (Object)"视频不存在");
            return "redirect:/video/manage";
        }
        this.videoService.auditPass(id);
        ra.addFlashAttribute("successMsg", (Object)"视频审核通过，已在前台展示");
        return "redirect:/video/manage";
    }

    @GetMapping(value={"/auditReject"})
    public String auditReject(Integer id, RedirectAttributes ra) {
        if (id == null) {
            ra.addFlashAttribute("errorMsg", (Object)"视频不存在");
            return "redirect:/video/manage";
        }
        this.videoService.auditReject(id);
        ra.addFlashAttribute("successMsg", (Object)"视频已驳回");
        return "redirect:/video/manage";
    }
}
