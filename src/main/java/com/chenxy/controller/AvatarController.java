package com.chenxy.controller;

import jakarta.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Files;
import java.util.regex.Pattern;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@Controller
public class AvatarController {
    private static final String AVATAR_DIR = System.getProperty("user.home") + File.separator + "campus_upload" + File.separator + "avatar";
    private static final String AVATAR_FALLBACK_DIR = System.getProperty("java.io.tmpdir") + File.separator + "campus_avatar";
    private static final Pattern FILE_NAME = Pattern.compile("[a-f0-9]{32}\\.(jpg|jpeg|png|gif|webp)");

    @GetMapping(value={"/avatar/{fileName:.+}"})
    public void avatar(@PathVariable String fileName, HttpServletResponse response) throws IOException {
        String ext;
        if (!FILE_NAME.matcher(fileName).matches()) {
            response.sendError(404);
            return;
        }
        File file = new File(AVATAR_DIR, fileName);
        if (!file.isFile()) {
            file = new File(AVATAR_FALLBACK_DIR, fileName);
        }
        if (!file.isFile()) {
            response.sendError(404);
            return;
        }
        switch (ext = fileName.substring(fileName.lastIndexOf(46) + 1).toLowerCase()) {
            case "png": {
                response.setContentType("image/png");
                break;
            }
            case "gif": {
                response.setContentType("image/gif");
                break;
            }
            case "webp": {
                response.setContentType("image/webp");
                break;
            }
            default: {
                response.setContentType("image/jpeg");
            }
        }
        response.setContentLengthLong(file.length());
        response.setHeader("Cache-Control", "public, max-age=86400");
        Files.copy(file.toPath(), (OutputStream)response.getOutputStream());
    }
}
