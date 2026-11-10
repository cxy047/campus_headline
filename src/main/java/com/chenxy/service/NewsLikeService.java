package com.chenxy.service;

import com.chenxy.entity.News;
import java.util.List;

public interface NewsLikeService {
    public long countByNews(Integer var1);

    public boolean isLiked(Integer var1, Integer var2);

    public long toggle(Integer var1, Integer var2);

    public List<News> listLikedNews(Integer var1);

    public long countByTarget(Integer var1, String var2);

    public boolean isLiked(Integer var1, Integer var2, String var3);

    public long toggle(Integer var1, Integer var2, String var3);

    public int deleteByTarget(Integer var1, String var2);
}
