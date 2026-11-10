package com.chenxy.service.impl;

import com.baomidou.mybatisplus.core.conditions.Wrapper;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.chenxy.entity.Comment;
import com.chenxy.mapper.CommentMapper;
import com.chenxy.service.CommentService;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class CommentServiceImpl
implements CommentService {
    private static final int MAX_LENGTH = 500;
    @Autowired
    private CommentMapper commentMapper;

    @Override
    public List<Comment> listByNews(Integer newsId) {
        return this.listByTarget(newsId, "news");
    }

    @Override
    public List<Comment> listByTarget(Integer targetId, String targetType) {
        if (targetId == null || targetType == null) {
            return Collections.emptyList();
        }
        return this.commentMapper.findByTargetId(targetId, targetType);
    }

    @Override
    public long countByTarget(Integer targetId, String targetType) {
        if (targetId == null || targetType == null) {
            return 0L;
        }
        return this.commentMapper.countByTarget(targetId, targetType);
    }

    @Override
    public List<Comment> listByUser(Integer userId) {
        if (userId == null) {
            return Collections.emptyList();
        }
        return this.commentMapper.findByUserId(userId);
    }

    @Override
    @Transactional(rollbackFor={Exception.class})
    public void addNewsComment(Integer newsId, Integer userId, String content) {
        this.addTargetComment(newsId, userId, content, "news");
    }

    @Override
    @Transactional(rollbackFor={Exception.class})
    public void addTargetComment(Integer targetId, Integer userId, String content, String targetType) {
        String text;
        if (targetId == null || userId == null) {
            throw new IllegalArgumentException("目标或用户不能为空");
        }
        String string = text = content == null ? "" : content.trim();
        if (text.isEmpty()) {
            throw new IllegalArgumentException("评论内容不能为空");
        }
        if (text.length() > 500) {
            text = text.substring(0, 500);
        }
        Comment comment = new Comment();
        comment.setNewsId(targetId);
        comment.setTargetType(targetType == null ? "news" : targetType);
        comment.setUserId(userId);
        comment.setContent(text);
        comment.setCreateTime(new Date());
        this.commentMapper.insert(comment);
    }

    @Override
    @Transactional(rollbackFor={Exception.class})
    public boolean delete(Integer id, Integer userId, boolean admin) {
        Comment comment = (Comment)this.commentMapper.selectById(id);
        if (comment == null) {
            return false;
        }
        if (!admin && !comment.getUserId().equals(userId)) {
            return false;
        }
        return this.commentMapper.deleteById(id) > 0;
    }

    @Override
    @Transactional(rollbackFor={Exception.class})
    public int deleteByTarget(Integer targetId, String targetType) {
        if (targetId == null || targetType == null) {
            return 0;
        }
        QueryWrapper wrapper = new QueryWrapper();
        ((QueryWrapper)wrapper.eq((Object)"news_id", (Object)targetId)).eq((Object)"target_type", (Object)targetType);
        return this.commentMapper.delete((Wrapper)wrapper);
    }
}
