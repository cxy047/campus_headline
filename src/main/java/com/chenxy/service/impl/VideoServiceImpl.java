package com.chenxy.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.chenxy.entity.Video;
import com.chenxy.mapper.VideoMapper;
import com.chenxy.service.CommentService;
import com.chenxy.service.NewsLikeService;
import com.chenxy.service.VideoService;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class VideoServiceImpl implements VideoService {
    @Autowired
    private VideoMapper videoMapper;
    @Autowired
    private CommentService commentService;
    @Autowired
    private NewsLikeService newsLikeService;

    @Override
    public IPage<Video> pageVideos(long current, long size) {
        QueryWrapper<Video> wrapper = new QueryWrapper<>();
        wrapper.eq("status", Video.STATUS_APPROVED).orderByDesc("create_time");
        return videoMapper.selectPage(new Page<>(current, size), wrapper);
    }

    @Override
    public IPage<Video> pageManage(long current, long size) {
        QueryWrapper<Video> wrapper = new QueryWrapper<>();
        wrapper.orderByDesc("create_time");
        return videoMapper.selectPage(new Page<>(current, size), wrapper);
    }

    @Override
    public Video findById(Integer id) {
        return videoMapper.selectById(id);
    }

    @Override
    public void incrementViews(Integer id) {
        videoMapper.incrementViews(id);
    }

    @Override
    public List<Video> listLatest(int limit) {
        QueryWrapper<Video> wrapper = new QueryWrapper<>();
        wrapper.eq("status", Video.STATUS_APPROVED).orderByDesc("create_time");
        return videoMapper.selectPage(new Page<>(1, limit), wrapper).getRecords();
    }

    @Override
    public List<Video> listByUser(Integer userId) {
        if (userId == null) {
            return Collections.emptyList();
        }
        QueryWrapper<Video> wrapper = new QueryWrapper<>();
        wrapper.eq("user_id", userId).orderByDesc("create_time");
        return videoMapper.selectList(wrapper);
    }

    @Override
    public long countAll() {
        return videoMapper.selectCount(null);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Video add(Video video) {
        video.setViews(0);
        video.setCreateTime(new Date());
        if (video.getStatus() == null) {
            video.setStatus(Video.STATUS_PENDING);
        }
        videoMapper.insert(video);
        return video;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void update(Video video) {
        videoMapper.updateById(video);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean deleteById(Integer id) {
        if (id == null) {
            return false;
        }
        // 级联清理该视频下的评论与点赞，避免脏数据
        commentService.deleteByTarget(id, "video");
        newsLikeService.deleteByTarget(id, "video");
        return videoMapper.deleteById(id) > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void auditPass(Integer id) {
        Video video = new Video();
        video.setId(id);
        video.setStatus(Video.STATUS_APPROVED);
        videoMapper.updateById(video);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void auditReject(Integer id) {
        Video video = new Video();
        video.setId(id);
        video.setStatus(Video.STATUS_REJECTED);
        videoMapper.updateById(video);
    }
}
