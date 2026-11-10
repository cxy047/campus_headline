package com.chenxy.controller;

import com.chenxy.util.MaterialStorage;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.ResourceRegion;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpRange;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.MediaTypeFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestHeader;

/**
 * 上传文件访问控制器（对应报告核心代码 6-5）。
 * 支持 HTTP Range 分段请求：浏览器播放在线视频时会带 Range 头，
 * 返回 206 Partial Content 实现拖动进度条与分段加载。
 */
@Controller
public class UploadController {
    /** 单个分段最大 1MB */
    private static final long CHUNK_SIZE = 1048576L;

    @GetMapping(value={"/upload/{fileName:.+}"})
    public ResponseEntity<ResourceRegion> serve(@PathVariable String fileName, @RequestHeader(value="Range", required=false) String rangeHeader) throws IOException {
        File file = MaterialStorage.find(fileName);
        if (file == null) {
            return ResponseEntity.notFound().build();
        }
        FileSystemResource resource = new FileSystemResource(file);
        long contentLength = resource.contentLength();
        MediaType mediaType = MediaTypeFactory.getMediaType(resource).orElse(MediaType.APPLICATION_OCTET_STREAM);
        // 无 Range 头：返回完整文件（200 OK）
        if (rangeHeader == null || rangeHeader.isEmpty()) {
            ResourceRegion region = new ResourceRegion(resource, 0L, contentLength);
            return ResponseEntity.status(HttpStatus.OK)
                    .contentType(mediaType)
                    .body(region);
        }
        // 有 Range 头：返回请求的分段（206 Partial Content）
        HttpRange range;
        try {
            range = HttpRange.parseRanges(rangeHeader).get(0);
        }
        catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.REQUESTED_RANGE_NOT_SATISFIABLE)
                    .header(HttpHeaders.CONTENT_RANGE, "bytes */" + contentLength)
                    .build();
        }
        long start = range.getRangeStart(contentLength);
        long end = range.getRangeEnd(contentLength);
        long rangeLength = Math.min(CHUNK_SIZE, end - start + 1L);
        ResourceRegion region = new ResourceRegion(resource, start, rangeLength);
        return ResponseEntity.status(HttpStatus.PARTIAL_CONTENT)
                .contentType(mediaType)
                .body(region);
    }
}
