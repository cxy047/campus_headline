package com.chenxy.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.chenxy.entity.Video;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Update;

@Mapper
public interface VideoMapper
extends BaseMapper<Video> {
    @Update(value={"UPDATE video SET views = views + 1 WHERE id = #{id}"})
    public int incrementViews(Integer var1);
}
