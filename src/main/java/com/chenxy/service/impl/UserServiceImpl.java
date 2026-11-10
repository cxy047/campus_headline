package com.chenxy.service.impl;

import com.baomidou.mybatisplus.core.conditions.Wrapper;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.chenxy.entity.User;
import com.chenxy.mapper.UserMapper;
import com.chenxy.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class UserServiceImpl
implements UserService {
    @Autowired
    private UserMapper userMapper;

    @Override
    public User login(String username, String password) {
        User user = this.userMapper.login(username, password);
        if (user != null) {
            return user;
        }
        QueryWrapper wrapper = new QueryWrapper();
        ((QueryWrapper)wrapper.eq((Object)"username", (Object)username)).eq((Object)"password", (Object)password);
        return (User)this.userMapper.selectOne((Wrapper)wrapper);
    }

    @Override
    @Transactional(rollbackFor={Exception.class})
    public boolean register(User user) {
        User exist = this.findByUsername(user.getUsername());
        if (exist != null) {
            return false;
        }
        if (user.getRole() == null) {
            user.setRole("user");
        }
        return this.userMapper.insert(user) > 0;
    }

    @Override
    public User findByUsername(String username) {
        QueryWrapper wrapper = new QueryWrapper();
        wrapper.eq((Object)"username", (Object)username);
        return (User)this.userMapper.selectOne((Wrapper)wrapper);
    }

    @Override
    public User findById(Integer id) {
        return (User)this.userMapper.selectById(id);
    }

    @Override
    @Transactional(rollbackFor={Exception.class})
    public boolean updateRealName(Integer userId, String realName) {
        if (userId == null || realName == null || realName.trim().isEmpty()) {
            return false;
        }
        User user = new User();
        user.setId(userId);
        user.setRealName(realName.trim());
        return this.userMapper.updateById(user) > 0;
    }

    @Override
    @Transactional(rollbackFor={Exception.class})
    public boolean updateAvatar(Integer userId, String avatar) {
        if (userId == null || avatar == null) {
            return false;
        }
        User user = new User();
        user.setId(userId);
        user.setAvatar(avatar);
        return this.userMapper.updateById(user) > 0;
    }

    @Override
    @Transactional(rollbackFor={Exception.class})
    public boolean updatePassword(Integer userId, String oldPassword, String newPassword) {
        if (userId == null || oldPassword == null || newPassword == null) {
            return false;
        }
        String newPwd = newPassword.trim();
        if (newPwd.length() < 6) {
            return false;
        }
        User user = (User)this.userMapper.selectById(userId);
        if (user == null || !oldPassword.equals(user.getPassword())) {
            return false;
        }
        User update = new User();
        update.setId(userId);
        update.setPassword(newPwd);
        return this.userMapper.updateById(update) > 0;
    }
}
