package com.generatorproject.services;

import com.generatorproject.dao.TokenDao;
import com.generatorproject.dao.UserDao;
import com.generatorproject.model.Users;

import java.util.Collections;
import java.util.List;
import java.util.Map;

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
    public void createUser(Users user) {
         userDao.createUser(user);
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
    public void markTokenAsUsed(String token) {
        tokenDao.markAsUsed(token);
    }

    @Override
    public boolean changeStatus(int userId, int newStatus) {
        return userDao.changeStatus(userId, newStatus);
    }

    @Override
    public List<Map<String, Object>> getPendingRequests(){
        return tokenDao.getPendingRequests();
    }

    @Override
    public void activateToken(String token){
        tokenDao.activateToken(token);
    }

    @Override
    public void deleteToken(String token){
        tokenDao.deleteRequest(token);
    }

    @Override
    public void deleteUser(int id){ userDao.deleteUser(id);}

    @Override
    public int getTotalUsers() {
        return userDao.countUsers();
    }

    @Override
    public List<Users> getUsersPaging(int page, int pageSize) {
        return userDao.getUsersPaging(page, pageSize);
    }
}
