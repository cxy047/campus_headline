package com.chenxy.controller;

import com.chenxy.util.CoverStorage;
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
public class CoverController {
    private static final Pattern FILE_NAME = Pattern.compile("[a-f0-9]{32}\\.(jpg|jpeg|png|gif|webp)");

    @GetMapping(value={"/cover/{fileName:.+}"})
    public void cover(@PathVariable String fileName, HttpServletResponse response) throws IOException {
        String ext;
        if (!FILE_NAME.matcher(fileName).matches()) {
            response.sendError(404);
            return;
        }
        File file = new File(CoverStorage.COVER_DIR, fileName);
        if (!file.isFile()) {
            file = new File(CoverStorage.COVER_FALLBACK_DIR, fileName);
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
