package com.chenxy.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import java.util.Date;

@TableName(value="comment")
public class Comment {
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
    private String content;
    @TableField(value="create_time")
    private Date createTime;
    @TableField(exist=false)
    private String userName;
    @TableField(exist=false)
    private String userRole;
    @TableField(exist=false)
    private String userAvatar;
    @TableField(exist=false)
    private String targetTitle;
    @TableField(exist=false)
    private String targetTypeInfo;

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

    public String getContent() {
        return this.content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Date getCreateTime() {
        return this.createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public String getUserName() {
        return this.userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getUserRole() {
        return this.userRole;
    }

    public void setUserRole(String userRole) {
        this.userRole = userRole;
    }

    public String getUserAvatar() {
        return this.userAvatar;
    }

    public void setUserAvatar(String userAvatar) {
        this.userAvatar = userAvatar;
    }

    public String getTargetTitle() {
        return this.targetTitle;
    }

    public void setTargetTitle(String targetTitle) {
        this.targetTitle = targetTitle;
    }

    public String getTargetTypeInfo() {
        return this.targetTypeInfo;
    }

    public void setTargetTypeInfo(String targetTypeInfo) {
        this.targetTypeInfo = targetTypeInfo;
    }
}
