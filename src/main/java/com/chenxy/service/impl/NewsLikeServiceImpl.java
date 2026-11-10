package com.chenxy.service.impl;

import com.baomidou.mybatisplus.core.conditions.Wrapper;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.chenxy.entity.News;
import com.chenxy.entity.NewsLike;
import com.chenxy.mapper.NewsLikeMapper;
import com.chenxy.service.NewsLikeService;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class NewsLikeServiceImpl
implements NewsLikeService {
    @Autowired
    private NewsLikeMapper newsLikeMapper;

    @Override
    public long countByNews(Integer newsId) {
        return this.countByTarget(newsId, "news");
    }

    @Override
    public boolean isLiked(Integer newsId, Integer userId) {
        return this.isLiked(newsId, userId, "news");
    }

    @Override
    @Transactional(rollbackFor={Exception.class})
    public long toggle(Integer newsId, Integer userId) {
        return this.toggle(newsId, userId, "news");
    }

    @Override
    public List<News> listLikedNews(Integer userId) {
        if (userId == null) {
            return Collections.emptyList();
        }
        return this.newsLikeMapper.findLikedNewsByUserId(userId);
    }

    @Override
    public long countByTarget(Integer targetId, String targetType) {
        if (targetId == null || targetType == null) {
            return 0L;
        }
        QueryWrapper wrapper = new QueryWrapper();
        ((QueryWrapper)wrapper.eq((Object)"news_id", (Object)targetId)).eq((Object)"target_type", (Object)targetType);
        return this.newsLikeMapper.selectCount((Wrapper)wrapper);
    }

    @Override
    public boolean isLiked(Integer targetId, Integer userId, String targetType) {
        if (targetId == null || userId == null || targetType == null) {
            return false;
        }
        QueryWrapper wrapper = new QueryWrapper();
        ((QueryWrapper)((QueryWrapper)wrapper.eq((Object)"news_id", (Object)targetId)).eq((Object)"user_id", (Object)userId)).eq((Object)"target_type", (Object)targetType);
        return this.newsLikeMapper.selectCount((Wrapper)wrapper) > 0L;
    }

    @Override
    @Transactional(rollbackFor={Exception.class})
    public long toggle(Integer targetId, Integer userId, String targetType) {
        QueryWrapper wrapper = new QueryWrapper();
        ((QueryWrapper)((QueryWrapper)wrapper.eq((Object)"news_id", (Object)targetId)).eq((Object)"user_id", (Object)userId)).eq((Object)"target_type", (Object)targetType);
        if (this.newsLikeMapper.selectCount((Wrapper)wrapper) > 0L) {
            this.newsLikeMapper.delete((Wrapper)wrapper);
        } else {
            NewsLike like = new NewsLike();
            like.setNewsId(targetId);
            like.setUserId(userId);
            like.setTargetType(targetType);
            like.setCreateTime(new Date());
            this.newsLikeMapper.insert(like);
        }
        return this.countByTarget(targetId, targetType);
    }

    @Override
    @Transactional(rollbackFor={Exception.class})
    public int deleteByTarget(Integer targetId, String targetType) {
        if (targetId == null || targetType == null) {
            return 0;
        }
        QueryWrapper wrapper = new QueryWrapper();
        ((QueryWrapper)wrapper.eq((Object)"news_id", (Object)targetId)).eq((Object)"target_type", (Object)targetType);
        return this.newsLikeMapper.delete((Wrapper)wrapper);
    }
}
