package com.chenxy.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.chenxy.entity.News;
import java.util.Map;
import org.apache.ibatis.annotations.Param;

public interface NewsMapper
extends BaseMapper<News> {
    public IPage<News> selectNewsPage(IPage<News> var1, @Param(value="params") Map<String, Object> var2);

    public int incrementViews(@Param(value="id") Integer var1);
}
