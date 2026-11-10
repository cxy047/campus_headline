package com.chenxy.util;

import java.io.File;
import java.util.UUID;
import org.springframework.web.multipart.MultipartFile;

/**
 * 素材文件存储工具类（对应报告 6.5 节）。
 * 文件统一落盘到 user.home/campus_upload 外部目录，与项目目录解耦；
 * 文件名使用 UUID 重命名，防止重名覆盖与路径穿越。
 */
public final class MaterialStorage {
    /** 主存储目录：用户主目录下的 campus_upload */
    public static final String UPLOAD_DIR = System.getProperty("user.home") + File.separator + "campus_upload";
    /** 主目录不可写时的回退目录 */
    public static final String FALLBACK_DIR = System.getProperty("java.io.tmpdir") + File.separator + "campus_upload";
    /** 单文件最大 200MB，与 web.xml multipart-config 保持一致 */
    private static final long MAX_FILE_SIZE = 209715200L;

    private MaterialStorage() {
    }

    /**
     * 保存上传文件，返回可访问的相对 URL（/upload/UUID.ext）。
     */
    public static String save(MultipartFile file) throws Exception {
        if (file == null || file.isEmpty()) {
            throw new IllegalArgumentException("请选择要上传的文件");
        }
        if (file.getSize() > MAX_FILE_SIZE) {
            throw new IllegalArgumentException("单个文件不能超过 200MB");
        }
        String originalName = file.getOriginalFilename();
        String ext = "";
        if (originalName != null && originalName.contains(".")) {
            ext = originalName.substring(originalName.lastIndexOf(".") + 1).toLowerCase();
        }
        String fileName = UUID.randomUUID().toString().replace("-", "") + (ext.isEmpty() ? "" : "." + ext);
        try {
            File dir = new File(UPLOAD_DIR);
            if (!dir.exists() && !dir.mkdirs()) {
                throw new IllegalStateException("无法创建上传目录");
            }
            file.transferTo(new File(dir, fileName));
        }
        catch (Exception primaryError) {
            File fallbackDir = new File(FALLBACK_DIR);
            if (!fallbackDir.exists() && !fallbackDir.mkdirs()) {
                throw new IllegalStateException("上传目录不可写：" + primaryError.getMessage());
            }
            file.transferTo(new File(fallbackDir, fileName));
        }
        return "/upload/" + fileName;
    }

    /**
     * 根据文件名定位磁盘文件，供在线播放/下载使用。
     * 拒绝包含路径分隔符或 .. 的文件名，防止目录穿越攻击。
     */
    public static File find(String fileName) {
        if (fileName == null || fileName.contains("/") || fileName.contains("\\") || fileName.contains("..")) {
            return null;
        }
        File primary = new File(UPLOAD_DIR, fileName);
        if (primary.isFile()) {
            return primary;
        }
        File fallback = new File(FALLBACK_DIR, fileName);
        return fallback.isFile() ? fallback : null;
    }
}
