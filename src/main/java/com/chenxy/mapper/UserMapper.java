package com.chenxy.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.chenxy.entity.User;
import org.apache.ibatis.annotations.Param;

public interface UserMapper
extends BaseMapper<User> {
    public User login(@Param(value="username") String var1, @Param(value="password") String var2);
}
