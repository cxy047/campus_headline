package com.chenxy.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.chenxy.entity.Material;
import org.springframework.web.multipart.MultipartFile;

public interface MaterialService {
    public Material upload(MultipartFile var1, Integer var2) throws Exception;

    public Material findById(Integer var1);

    public IPage<Material> pageMaterials(long var1, long var3);

    public boolean deleteById(Integer var1);
}
