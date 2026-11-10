package com.chenxy.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.chenxy.entity.News;
import java.util.List;
import java.util.Map;

public interface NewsService {
    public List<News> listPublished();

    public News findById(Integer var1);

    public List<News> listByUser(Integer var1);

    public List<News> listHot(int var1);

    public List<News> listLatest(int var1);

    public IPage<News> pageNews(long var1, long var3, Map<String, Object> var5);

    public void add(News var1);

    public void update(News var1);

    public void deleteById(Integer var1);

    public void incrementViews(Integer var1);

    public void submitAudit(Integer var1);

    public void auditPass(Integer var1);

    public void auditReject(Integer var1);
}
