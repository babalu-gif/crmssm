package com.example.crm.settings.service;

import com.example.crm.settings.entity.User;

import java.util.List;
import java.util.Map;

public interface UserService {
    User queryUserByLogin(Map<String, Object> map);

    List<User> queryAllUsers();

    int editPwd(User user);
}
