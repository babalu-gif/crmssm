package com.example.crm.settings.service.impl;

import com.example.crm.settings.entity.User;
import com.example.crm.settings.mapper.UserMapper;
import com.example.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;

    @Override
    public User queryUserByLogin(Map<String, Object> map) {
        return userMapper.selectUserByLogin(map);
    }

    @Override
    public List<User> queryAllUsers() {
        return userMapper.selectAllUsers();
    }

    @Override
    public int editPwd(User user) {
        return userMapper.editPwd(user);
    }
}
