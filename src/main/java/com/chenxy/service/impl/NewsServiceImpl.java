package com.chenxy.service.impl;

import com.baomidou.mybatisplus.core.conditions.Wrapper;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.chenxy.entity.News;
import com.chenxy.mapper.NewsMapper;
import com.chenxy.service.CommentService;
import com.chenxy.service.NewsLikeService;
import com.chenxy.service.NewsService;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class NewsServiceImpl
implements NewsService {
    @Autowired
    private NewsMapper newsMapper;
    @Autowired
    private CommentService commentService;
    @Autowired
    private NewsLikeService newsLikeService;

    @Override
    public List<News> listPublished() {
        QueryWrapper wrapper = new QueryWrapper();
        ((QueryWrapper)wrapper.eq((Object)"status", (Object)2)).orderByDesc((Object)"create_time");
        return this.newsMapper.selectList((Wrapper)wrapper);
    }

    @Override
    public News findById(Integer id) {
        return (News)this.newsMapper.selectById(id);
    }

    @Override
    public List<News> listByUser(Integer userId) {
        if (userId == null) {
            return Collections.emptyList();
        }
        QueryWrapper wrapper = new QueryWrapper();
        ((QueryWrapper)wrapper.eq((Object)"user_id", (Object)userId)).orderByDesc((Object)"create_time");
        return this.newsMapper.selectList((Wrapper)wrapper);
    }

    @Override
    public List<News> listHot(int limit) {
        QueryWrapper wrapper = new QueryWrapper();
        ((QueryWrapper)((QueryWrapper)wrapper.eq((Object)"status", (Object)2)).orderByDesc((Object)"views")).orderByDesc((Object)"create_time");
        return ((Page)this.newsMapper.selectPage((IPage)new Page(1L, (long)limit), (Wrapper)wrapper)).getRecords();
    }

    @Override
    public List<News> listLatest(int limit) {
        QueryWrapper wrapper = new QueryWrapper();
        ((QueryWrapper)wrapper.eq((Object)"status", (Object)2)).orderByDesc((Object)"create_time");
        return ((Page)this.newsMapper.selectPage((IPage)new Page(1L, (long)limit), (Wrapper)wrapper)).getRecords();
    }

    @Override
    public IPage<News> pageNews(long current, long size, Map<String, Object> params) {
        Page page = new Page(current, size);
        Map<String, Object> safeParams = params != null ? params : new HashMap<String, Object>();
        return this.newsMapper.selectNewsPage((IPage<News>)page, safeParams);
    }

    @Override
    @Transactional(rollbackFor={Exception.class})
    public void add(News news) {
        if (news.getStatus() == null) {
            news.setStatus(0);
        }
        if (news.getViews() == null) {
            news.setViews(0);
        }
        this.newsMapper.insert(news);
    }

    @Override
    @Transactional(rollbackFor={Exception.class})
    public void update(News news) {
        this.newsMapper.updateById(news);
    }

    @Override
    @Transactional(rollbackFor={Exception.class})
    public void deleteById(Integer id) {
        if (id == null) {
            return;
        }
        this.commentService.deleteByTarget(id, "news");
        this.newsLikeService.deleteByTarget(id, "news");
        this.newsMapper.deleteById(id);
    }

    @Override
    public void incrementViews(Integer id) {
        this.newsMapper.incrementViews(id);
    }

    @Override
    @Transactional(rollbackFor={Exception.class})
    public void submitAudit(Integer id) {
        News news = new News();
        news.setId(id);
        news.setStatus(1);
        this.newsMapper.updateById(news);
    }

    @Override
    @Transactional(rollbackFor={Exception.class})
    public void auditPass(Integer id) {
        News news = new News();
        news.setId(id);
        news.setStatus(2);
        this.newsMapper.updateById(news);
    }

    @Override
    @Transactional(rollbackFor={Exception.class})
    public void auditReject(Integer id) {
        News news = new News();
        news.setId(id);
        news.setStatus(3);
        this.newsMapper.updateById(news);
    }
}
