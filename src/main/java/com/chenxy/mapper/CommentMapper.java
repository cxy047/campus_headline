package com.chenxy.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.chenxy.entity.Comment;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface CommentMapper
extends BaseMapper<Comment> {
    public List<Comment> findByTargetId(@Param(value="targetId") Integer var1, @Param(value="targetType") String var2);

    public long countByTarget(@Param(value="targetId") Integer var1, @Param(value="targetType") String var2);

    public List<Comment> findByUserId(@Param(value="userId") Integer var1);
}
