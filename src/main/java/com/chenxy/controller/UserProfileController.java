package com.chenxy.controller;

import com.chenxy.entity.Comment;
import com.chenxy.entity.News;
import com.chenxy.entity.Topic;
import com.chenxy.entity.User;
import com.chenxy.entity.Video;
import com.chenxy.service.CommentService;
import com.chenxy.service.NewsLikeService;
import com.chenxy.service.NewsService;
import com.chenxy.service.TopicService;
import com.chenxy.service.UserService;
import com.chenxy.service.VideoService;
import com.chenxy.util.CoverStorage;
import com.chenxy.util.MaterialStorage;
import jakarta.servlet.http.HttpSession;
import java.io.File;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.UUID;
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
@RequestMapping(value={"/user/profile"})
public class UserProfileController {
    private static final String AVATAR_DIR = System.getProperty("user.home") + File.separator + "campus_upload" + File.separator + "avatar";
    private static final String AVATAR_FALLBACK_DIR = System.getProperty("java.io.tmpdir") + File.separator + "campus_avatar";
    private static final long MAX_AVATAR_SIZE = 0x200000L;
    private static final Set<String> ALLOWED_EXT = new HashSet<String>(Arrays.asList("jpg", "jpeg", "png", "gif", "webp"));
    @Autowired
    private UserService userService;
    @Autowired
    private CommentService commentService;
    @Autowired
    private NewsLikeService newsLikeService;
    @Autowired
    private NewsService newsService;
    @Autowired
    private TopicService topicService;
    @Autowired
    private VideoService videoService;

    @GetMapping(value={""})
    public String profile(HttpSession session, Model model) {
        User loginUser = this.currentUser(session);
        if (loginUser == null) {
            return "redirect:/login";
        }
        List<Comment> myComments = this.commentService.listByUser(loginUser.getId());
        List<News> likedNews = this.newsLikeService.listLikedNews(loginUser.getId());
        List<News> myNews = this.newsService.listByUser(loginUser.getId());
        List<Topic> myTopics = this.topicService.listByUser(loginUser.getId());
        List<Video> myVideos = this.videoService.listByUser(loginUser.getId());
        model.addAttribute("myComments", myComments);
        model.addAttribute("likedNews", likedNews);
        model.addAttribute("myNews", myNews);
        model.addAttribute("myTopics", myTopics);
        model.addAttribute("myVideos", myVideos);
        model.addAttribute("commentTotal", (Object)myComments.size());
        model.addAttribute("likeTotal", (Object)likedNews.size());
        model.addAttribute("newsTotal", (Object)myNews.size());
        model.addAttribute("topicTotal", (Object)myTopics.size());
        model.addAttribute("videoTotal", (Object)myVideos.size());
        model.addAttribute("publishTotal", (Object)(myNews.size() + myTopics.size() + myVideos.size()));
        return "profile";
    }

    @PostMapping(value={"/update"})
    public String updateProfile(String realName, HttpSession session, RedirectAttributes ra) {
        User loginUser = this.currentUser(session);
        if (loginUser == null) {
            return "redirect:/login";
        }
        if (realName == null || realName.trim().isEmpty()) {
            ra.addFlashAttribute("error", (Object)"姓名不能为空");
            return "redirect:/user/profile";
        }
        if (realName.trim().length() > 50) {
            ra.addFlashAttribute("error", (Object)"姓名不能超过 50 个字符");
            return "redirect:/user/profile";
        }
        if (this.userService.updateRealName(loginUser.getId(), realName)) {
            this.refreshSession(session, loginUser.getId());
            ra.addFlashAttribute("msg", (Object)"个人信息已更新");
        } else {
            ra.addFlashAttribute("error", (Object)"更新失败，请稍后重试");
        }
        return "redirect:/user/profile";
    }

    @PostMapping(value={"/avatar"})
    public String uploadAvatar(@RequestParam(value="avatarFile") MultipartFile file, HttpSession session, RedirectAttributes ra) {
        User loginUser = this.currentUser(session);
        if (loginUser == null) {
            return "redirect:/login";
        }
        if (file == null || file.isEmpty()) {
            ra.addFlashAttribute("error", (Object)"请选择要上传的头像图片");
            return "redirect:/user/profile";
        }
        if (file.getSize() > 0x200000L) {
            ra.addFlashAttribute("error", (Object)"头像不能超过 2MB");
            return "redirect:/user/profile";
        }
        String contentType = file.getContentType();
        if (contentType == null || !contentType.startsWith("image/")) {
            ra.addFlashAttribute("error", (Object)"只能上传图片文件");
            return "redirect:/user/profile";
        }
        String originalName = file.getOriginalFilename();
        String ext = "";
        if (originalName != null && originalName.contains(".")) {
            ext = originalName.substring(originalName.lastIndexOf(".") + 1).toLowerCase();
        }
        if (!ALLOWED_EXT.contains(ext)) {
            ra.addFlashAttribute("error", (Object)"仅支持 jpg / jpeg / png / gif / webp 格式");
            return "redirect:/user/profile";
        }
        try {
            String fileName = UUID.randomUUID().toString().replace("-", "") + "." + ext;
            this.saveAvatarFile(file, fileName);
            String avatarPath = "/avatar/" + fileName;
            if (this.userService.updateAvatar(loginUser.getId(), avatarPath)) {
                this.refreshSession(session, loginUser.getId());
                ra.addFlashAttribute("msg", (Object)"头像已更新");
            } else {
                ra.addFlashAttribute("error", (Object)"头像保存失败，请稍后重试");
            }
        }
        catch (Exception e) {
            ra.addFlashAttribute("error", (Object)("头像上传失败：" + e.getMessage()));
        }
        return "redirect:/user/profile";
    }

    private void saveAvatarFile(MultipartFile file, String fileName) throws Exception {
        try {
            File dir = new File(AVATAR_DIR);
            if (!dir.exists() && !dir.mkdirs()) {
                throw new IllegalStateException("无法创建头像目录");
            }
            file.transferTo(new File(dir, fileName));
            return;
        }
        catch (Exception primaryError) {
            File fallbackDir = new File(AVATAR_FALLBACK_DIR);
            if (!fallbackDir.exists() && !fallbackDir.mkdirs()) {
                throw new IllegalStateException("头像目录不可写：" + primaryError.getMessage());
            }
            file.transferTo(new File(fallbackDir, fileName));
            return;
        }
    }

    @PostMapping(value={"/password"})
    public String changePassword(String oldPassword, String newPassword, String confirmPassword, HttpSession session, RedirectAttributes ra) {
        User loginUser = this.currentUser(session);
        if (loginUser == null) {
            return "redirect:/login";
        }
        if (oldPassword == null || oldPassword.isEmpty()) {
            ra.addFlashAttribute("error", (Object)"请输入原密码");
            return "redirect:/user/profile";
        }
        if (newPassword == null || newPassword.trim().length() < 6) {
            ra.addFlashAttribute("error", (Object)"新密码至少 6 位");
            return "redirect:/user/profile";
        }
        if (!newPassword.equals(confirmPassword)) {
            ra.addFlashAttribute("error", (Object)"两次输入的新密码不一致");
            return "redirect:/user/profile";
        }
        if (this.userService.updatePassword(loginUser.getId(), oldPassword, newPassword)) {
            ra.addFlashAttribute("msg", (Object)"密码修改成功，下次登录请使用新密码");
        } else {
            ra.addFlashAttribute("error", (Object)"原密码不正确，密码未修改");
        }
        return "redirect:/user/profile";
    }

    @GetMapping(value={"/publish"})
    public String publishPage() {
        return "newsPublish";
    }

    @PostMapping(value={"/publish"})
    public String publish(String title, String category, String content, @RequestParam(required=false) MultipartFile coverFile, HttpSession session, RedirectAttributes ra) {
        User loginUser = this.currentUser(session);
        if (loginUser == null) {
            return "redirect:/login";
        }
        if (title == null || title.trim().isEmpty() || content == null || content.trim().isEmpty()) {
            ra.addFlashAttribute("error", (Object)"标题和正文不能为空");
            return "redirect:/user/profile/publish";
        }
        if (title.trim().length() > 200) {
            ra.addFlashAttribute("error", (Object)"标题不能超过 200 个字符");
            return "redirect:/user/profile/publish";
        }
        News news = new News();
        news.setTitle(title.trim());
        news.setContent(content.trim());
        news.setAuthor(loginUser.getRealName());
        news.setUserId(loginUser.getId());
        news.setCategory(category == null || category.trim().isEmpty() ? "校园通知" : category.trim());
        news.setViews(0);
        news.setStatus(1);
        if (coverFile != null && !coverFile.isEmpty()) {
            try {
                news.setCover(CoverStorage.save(coverFile));
            }
            catch (IllegalArgumentException e) {
                ra.addFlashAttribute("error", (Object)e.getMessage());
                return "redirect:/user/profile/publish";
            }
            catch (Exception e) {
                ra.addFlashAttribute("error", (Object)("封面上传失败：" + e.getMessage()));
                return "redirect:/user/profile/publish";
            }
        }
        this.newsService.add(news);
        ra.addFlashAttribute("msg", (Object)"投稿已提交，管理员审核通过后将展示在首页");
        return "redirect:/user/profile";
    }

    @PostMapping(value={"/video"})
    public String publishVideo(String title, String url, String description, String duration, @RequestParam(required=false) String cover, @RequestParam(required=false) MultipartFile coverFile, @RequestParam(required=false) MultipartFile videoFile, HttpSession session, RedirectAttributes ra) {
        User loginUser = this.currentUser(session);
        if (loginUser == null) {
            return "redirect:/login";
        }
        title = title == null ? "" : title.trim();
        url = url == null ? "" : url.trim();
        if (title.isEmpty() || title.length() > 200) {
            ra.addFlashAttribute("error", (Object)"视频标题必填且不超过 200 字");
            return "redirect:/user/profile";
        }
        Video video = new Video();
        if (videoFile != null && !videoFile.isEmpty()) {
            try {
                url = MaterialStorage.save(videoFile);
            }
            catch (IllegalArgumentException e) {
                ra.addFlashAttribute("error", (Object)e.getMessage());
                return "redirect:/user/profile";
            }
            catch (Exception e) {
                ra.addFlashAttribute("error", (Object)("视频上传失败：" + e.getMessage()));
                return "redirect:/user/profile";
            }
        }
        if (url.isEmpty() || url.length() > 500) {
            ra.addFlashAttribute("error", (Object)"请填写视频地址或上传本地视频文件");
            return "redirect:/user/profile";
        }
        video.setTitle(title);
        video.setUrl(url);
        video.setDescription(description);
        video.setAuthor(loginUser.getRealName());
        video.setUserId(loginUser.getId());
        video.setDuration(duration);
        if (coverFile != null && !coverFile.isEmpty()) {
            try {
                video.setCover(CoverStorage.save(coverFile));
            }
            catch (IllegalArgumentException e) {
                ra.addFlashAttribute("error", (Object)e.getMessage());
                return "redirect:/user/profile";
            }
            catch (Exception e) {
                ra.addFlashAttribute("error", (Object)("封面上传失败：" + e.getMessage()));
                return "redirect:/user/profile";
            }
        } else {
            video.setCover(cover);
        }
        // 普通用户投稿的视频进入待审核状态，管理员审核通过后才在前台展示
        video.setStatus(Video.STATUS_PENDING);
        this.videoService.add(video);
        ra.addFlashAttribute("msg", (Object)"视频已提交，管理员审核通过后展示");
        return "redirect:/user/profile";
    }

    @GetMapping(value={"/news/delete"})
    public String deleteMyNews(Integer id, HttpSession session, RedirectAttributes ra) {
        News news;
        User loginUser = this.currentUser(session);
        if (loginUser == null) {
            return "redirect:/login";
        }
        News news2 = news = id == null ? null : this.newsService.findById(id);
        if (news == null) {
            ra.addFlashAttribute("error", (Object)"新闻不存在或已被删除");
            return "redirect:/user/profile";
        }
        if (!this.canManage(news.getUserId(), loginUser)) {
            ra.addFlashAttribute("error", (Object)"只能删除自己发布的新闻");
            return "redirect:/user/profile";
        }
        this.newsService.deleteById(id);
        ra.addFlashAttribute("msg", (Object)"新闻已删除");
        return "redirect:/user/profile";
    }

    @GetMapping(value={"/topic/delete"})
    public String deleteMyTopic(Integer id, HttpSession session, RedirectAttributes ra) {
        Topic topic;
        User loginUser = this.currentUser(session);
        if (loginUser == null) {
            return "redirect:/login";
        }
        Topic topic2 = topic = id == null ? null : this.topicService.findById(id);
        if (topic == null) {
            ra.addFlashAttribute("error", (Object)"话题不存在或已被删除");
            return "redirect:/user/profile";
        }
        if (!this.canManage(topic.getUserId(), loginUser)) {
            ra.addFlashAttribute("error", (Object)"只能删除自己发起的话题");
            return "redirect:/user/profile";
        }
        this.topicService.deleteById(id);
        ra.addFlashAttribute("msg", (Object)"话题已删除");
        return "redirect:/user/profile";
    }

    @GetMapping(value={"/video/delete"})
    public String deleteMyVideo(Integer id, HttpSession session, RedirectAttributes ra) {
        Video video;
        User loginUser = this.currentUser(session);
        if (loginUser == null) {
            return "redirect:/login";
        }
        Video video2 = video = id == null ? null : this.videoService.findById(id);
        if (video == null) {
            ra.addFlashAttribute("error", (Object)"视频不存在或已被删除");
            return "redirect:/user/profile";
        }
        if (!this.canManage(video.getUserId(), loginUser)) {
            ra.addFlashAttribute("error", (Object)"只能删除自己发布的视频");
            return "redirect:/user/profile";
        }
        this.videoService.deleteById(id);
        ra.addFlashAttribute("msg", (Object)"视频已删除");
        return "redirect:/user/profile";
    }

    private boolean canManage(Integer ownerId, User loginUser) {
        return "admin".equals(loginUser.getRole()) || ownerId != null && ownerId.equals(loginUser.getId());
    }

    private User currentUser(HttpSession session) {
        return (User)session.getAttribute("loginUser");
    }

    private void refreshSession(HttpSession session, Integer userId) {
        User latest = this.userService.findById(userId);
        if (latest != null) {
            session.setAttribute("loginUser", (Object)latest);
        }
    }
}
