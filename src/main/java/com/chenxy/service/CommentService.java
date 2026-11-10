package com.chenxy.service;

import com.chenxy.entity.Comment;
import java.util.List;

public interface CommentService {
    public List<Comment> listByNews(Integer var1);

    public List<Comment> listByTarget(Integer var1, String var2);

    public long countByTarget(Integer var1, String var2);

    public List<Comment> listByUser(Integer var1);

    public void addNewsComment(Integer var1, Integer var2, String var3);

    public void addTargetComment(Integer var1, Integer var2, String var3, String var4);

    public boolean delete(Integer var1, Integer var2, boolean var3);

    public int deleteByTarget(Integer var1, String var2);
}
