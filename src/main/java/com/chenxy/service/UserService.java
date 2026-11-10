package com.chenxy.service;

import com.chenxy.entity.User;

public interface UserService {
    public User login(String var1, String var2);

    public boolean register(User var1);

    public User findByUsername(String var1);

    public User findById(Integer var1);

    public boolean updateRealName(Integer var1, String var2);

    public boolean updateAvatar(Integer var1, String var2);

    public boolean updatePassword(Integer var1, String var2, String var3);
}
