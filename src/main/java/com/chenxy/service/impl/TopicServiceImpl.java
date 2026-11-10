package com.chenxy.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.chenxy.entity.Topic;
import com.chenxy.mapper.TopicMapper;
import com.chenxy.service.CommentService;
import com.chenxy.service.NewsLikeService;
import com.chenxy.service.TopicService;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class TopicServiceImpl implements TopicService {
    @Autowired
    private TopicMapper topicMapper;
    @Autowired
    private CommentService commentService;
    @Autowired
    private NewsLikeService newsLikeService;

    @Override
    public IPage<Topic> pageTopics(long current, long size) {
        QueryWrapper<Topic> wrapper = new QueryWrapper<>();
        wrapper.eq("status", Topic.STATUS_APPROVED).orderByDesc("create_time");
        return topicMapper.selectPage(new Page<>(current, size), wrapper);
    }

    @Override
    public IPage<Topic> pageManage(long current, long size) {
        QueryWrapper<Topic> wrapper = new QueryWrapper<>();
        wrapper.orderByDesc("create_time");
        return topicMapper.selectPage(new Page<>(current, size), wrapper);
    }

    @Override
    public Topic findById(Integer id) {
        return topicMapper.selectById(id);
    }

    @Override
    public void incrementViews(Integer id) {
        topicMapper.incrementViews(id);
    }

    @Override
    public List<Topic> listHot(int limit) {
        QueryWrapper<Topic> wrapper = new QueryWrapper<>();
        wrapper.eq("status", Topic.STATUS_APPROVED)
               .orderByDesc("views")
               .orderByDesc("create_time");
        return topicMapper.selectPage(new Page<>(1, limit), wrapper).getRecords();
    }

    @Override
    public List<Topic> listByUser(Integer userId) {
        if (userId == null) {
            return Collections.emptyList();
        }
        QueryWrapper<Topic> wrapper = new QueryWrapper<>();
        wrapper.eq("user_id", userId).orderByDesc("create_time");
        return topicMapper.selectList(wrapper);
    }

    @Override
    public long countAll() {
        return topicMapper.selectCount(null);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Topic add(Topic topic) {
        topic.setViews(0);
        topic.setCreateTime(new Date());
        if (topic.getStatus() == null) {
            topic.setStatus(Topic.STATUS_PENDING);
        }
        topicMapper.insert(topic);
        return topic;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void update(Topic topic) {
        topicMapper.updateById(topic);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean deleteById(Integer id) {
        if (id == null) {
            return false;
        }
        // 级联清理该话题下的评论与点赞，避免脏数据
        commentService.deleteByTarget(id, "topic");
        newsLikeService.deleteByTarget(id, "topic");
        return topicMapper.deleteById(id) > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void auditPass(Integer id) {
        Topic topic = new Topic();
        topic.setId(id);
        topic.setStatus(Topic.STATUS_APPROVED);
        topicMapper.updateById(topic);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void auditReject(Integer id) {
        Topic topic = new Topic();
        topic.setId(id);
        topic.setStatus(Topic.STATUS_REJECTED);
        topicMapper.updateById(topic);
    }
}
