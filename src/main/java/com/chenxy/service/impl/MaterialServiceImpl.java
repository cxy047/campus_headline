package com.chenxy.service.impl;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.chenxy.entity.Material;
import com.chenxy.mapper.MaterialMapper;
import com.chenxy.service.MaterialService;
import java.io.File;
import java.io.IOException;
import java.util.Date;
import java.util.UUID;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

@Service
public class MaterialServiceImpl
implements MaterialService {
    @Autowired
    private MaterialMapper materialMapper;
    private static final String UPLOAD_DIR = System.getProperty("user.home") + File.separator + "campus_upload" + File.separator;

    @Override
    @Transactional(rollbackFor={Exception.class})
    public Material upload(MultipartFile file, Integer uploadUserId) throws IOException {
        String contentType;
        if (file == null || file.isEmpty()) {
            throw new IllegalArgumentException("上传文件不能为空");
        }
        File dir = new File(UPLOAD_DIR);
        if (!dir.exists()) {
            dir.mkdirs();
        }
        String originalName = file.getOriginalFilename();
        String ext = "";
        if (originalName != null && originalName.contains(".")) {
            ext = originalName.substring(originalName.lastIndexOf("."));
        }
        String newFileName = UUID.randomUUID().toString().replace("-", "") + ext;
        File destFile = new File(dir, newFileName);
        file.transferTo(destFile);
        String string = contentType = file.getContentType() != null ? file.getContentType() : "application/octet-stream";
        String fileType = contentType.startsWith("image/") ? "image" : (contentType.startsWith("video/") ? "video" : (contentType.contains("pdf") || contentType.contains("word") || contentType.contains("excel") ? "doc" : "other"));
        Material material = new Material();
        material.setFileName(originalName);
        material.setFilePath("/upload/" + newFileName);
        material.setFileSize(file.getSize());
        material.setFileType(fileType);
        material.setUploadUserId(uploadUserId);
        material.setUploadTime(new Date());
        this.materialMapper.insert(material);
        return material;
    }

    @Override
    public Material findById(Integer id) {
        return (Material)this.materialMapper.selectById(id);
    }

    @Override
    public IPage<Material> pageMaterials(long current, long size) {
        Page page = new Page(current, size);
        return this.materialMapper.selectPage((IPage)page, null);
    }

    @Override
    @Transactional(rollbackFor={Exception.class})
    public boolean deleteById(Integer id) {
        Material material = (Material)this.materialMapper.selectById(id);
        if (material == null) {
            return false;
        }
        String fullPath = UPLOAD_DIR + material.getFilePath().replace("/upload/", "");
        File file = new File(fullPath);
        if (file.exists()) {
            file.delete();
        }
        return this.materialMapper.deleteById(id) > 0;
    }
}
