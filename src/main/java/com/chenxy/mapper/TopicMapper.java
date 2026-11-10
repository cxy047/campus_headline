package com.chenxy.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.chenxy.entity.Topic;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Update;

@Mapper
public interface TopicMapper
extends BaseMapper<Topic> {
    @Update(value={"UPDATE topic SET views = views + 1 WHERE id = #{id}"})
    public int incrementViews(Integer var1);
}
