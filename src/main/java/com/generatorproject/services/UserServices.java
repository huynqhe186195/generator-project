package com.generatorproject.services;

import com.generatorproject.dao.TokenDao;
import com.generatorproject.dao.UserDao;
import com.generatorproject.model.Users;

import java.util.Collections;
import java.util.List;

public class UserServices implements IUserServices {
    private final UserDao userDao;
    private final TokenDao tokenDao;

    public UserServices() {
        this.userDao = new UserDao();
        this.tokenDao = new TokenDao();
    }

    @Override
    public List<Users> getAllUsers() {
        return userDao.getAllUsers();
    }

    @Override
    public Users createUser(Users user) {
        return userDao.createUser(user);
    }

    @Override
    public Users findUserById(int id) {
        return userDao.findUserById(id);
    }

    @Override
    public void updateUser(Users user) {
        userDao.updateUser(user);
    }

    @Override
    public Users findByEmailAndPassword(String email, String password) {
        return userDao.checkLogin(email, password);
    }

    @Override
    public String generatePasswordResetToken(String email) {
        Users user = userDao.findByEmail(email);
        if (user != null) {
            String token = java.util.UUID.randomUUID().toString();
            tokenDao.saveToken(user.getId(), token); // Lưu vào DB thông qua TokenDao
            return token;
        }
        return null;
    }

    @Override
    public Users findByEmail(String email) {
        return userDao.findByEmail(email);
    }

    @Override
    public Integer getUserIdByValidToken(String token) {
        return tokenDao.getUserIdByValidToken(token);
    }

    @Override
    public void updatePassword(int userId, String newPassword) {
        userDao.updatePassword(userId, newPassword);
    }

    @Override
    public void markTokenAsUsed(String token) {
        tokenDao.markAsUsed(token);
    }
}
