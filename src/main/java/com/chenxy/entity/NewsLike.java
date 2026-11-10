package com.chenxy.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.util.Date;

@TableName(value="news_like")
public class NewsLike {
    public static final String TYPE_NEWS = "news";
    public static final String TYPE_VIDEO = "video";
    public static final String TYPE_TOPIC = "topic";
    @TableId(type=IdType.AUTO)
    private Integer id;
    @TableField(value="news_id")
    private Integer newsId;
    @TableField(value="target_type")
    private String targetType;
    @TableField(value="user_id")
    private Integer userId;
    @TableField(value="create_time")
    private Date createTime;

    public Integer getId() {
        return this.id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getNewsId() {
        return this.newsId;
    }

    public void setNewsId(Integer newsId) {
        this.newsId = newsId;
    }

    public String getTargetType() {
        return this.targetType;
    }

    public void setTargetType(String targetType) {
        this.targetType = targetType;
    }

    public Integer getUserId() {
        return this.userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public Date getCreateTime() {
        return this.createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }
}
