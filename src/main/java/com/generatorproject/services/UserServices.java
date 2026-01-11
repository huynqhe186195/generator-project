package com.generatorproject.services;

import com.generatorproject.dao.UserDao;
import com.generatorproject.model.Users;

import java.util.Collections;
import java.util.List;

public class UserServices implements IUserServices{
    private final UserDao userDao;

    public UserServices(){
        this.userDao = new UserDao();
    }

    @Override
    public List<Users> getAllUsers() {
        return userDao.getAllUsers();
    }

    @Override
    public Users createUser(Users user) {
        return null;
    }
}
