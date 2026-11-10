package com.chenxy.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.chenxy.entity.News;
import com.chenxy.entity.NewsLike;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface NewsLikeMapper
extends BaseMapper<NewsLike> {
    public List<News> findLikedNewsByUserId(@Param(value="userId") Integer var1);
}
