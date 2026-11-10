package com.chenxy.util;

import java.io.File;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;
import java.util.UUID;
import org.springframework.web.multipart.MultipartFile;

public final class CoverStorage {
    public static final String COVER_DIR = System.getProperty("user.home") + File.separator + "campus_upload" + File.separator + "cover";
    public static final String COVER_FALLBACK_DIR = System.getProperty("java.io.tmpdir") + File.separator + "campus_cover";
    private static final long MAX_COVER_SIZE = 0x500000L;
    private static final Set<String> ALLOWED_EXT = new HashSet<String>(Arrays.asList("jpg", "jpeg", "png", "gif", "webp"));

    private CoverStorage() {
    }

    public static String save(MultipartFile file) throws Exception {
        if (file == null || file.isEmpty()) {
            throw new IllegalArgumentException("请选择要上传的封面图片");
        }
        if (file.getSize() > 0x500000L) {
            throw new IllegalArgumentException("封面图不能超过 5MB");
        }
        String contentType = file.getContentType();
        if (contentType == null || !contentType.startsWith("image/")) {
            throw new IllegalArgumentException("只能上传图片文件");
        }
        String originalName = file.getOriginalFilename();
        String ext = "";
        if (originalName != null && originalName.contains(".")) {
            ext = originalName.substring(originalName.lastIndexOf(".") + 1).toLowerCase();
        }
        if (!ALLOWED_EXT.contains(ext)) {
            throw new IllegalArgumentException("仅支持 jpg / jpeg / png / gif / webp 格式");
        }
        String fileName = UUID.randomUUID().toString().replace("-", "") + "." + ext;
        try {
            File dir = new File(COVER_DIR);
            if (!dir.exists() && !dir.mkdirs()) {
                throw new IllegalStateException("无法创建封面目录");
            }
            file.transferTo(new File(dir, fileName));
        }
        catch (Exception primaryError) {
            File fallbackDir = new File(COVER_FALLBACK_DIR);
            if (!fallbackDir.exists() && !fallbackDir.mkdirs()) {
                throw new IllegalStateException("封面目录不可写：" + primaryError.getMessage());
            }
            file.transferTo(new File(fallbackDir, fileName));
        }
        return "/cover/" + fileName;
    }
}
