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
    public void updateProfile(Users user) throws Exception {
        userDao.updateProfile(user);
    }
    @Override
    public List<Users> getAllUsers() {
        return userDao.getAllUsers();
    }

    @Override
    public void createUser(Users user) throws Exception {
        userDao.createUser(user);
    }

    @Override
    public Users findUserById(int id) {
        return userDao.findUserById(id);
    }

    @Override
    public void updateUser(Users user) throws Exception {
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
    public List<Map<String, Object>> getPendingRequests() {
        return tokenDao.getPendingRequests();
    }

    @Override
    public void activateToken(String token) {
        tokenDao.activateToken(token);
    }

    @Override
    public void deleteToken(String token) {
        tokenDao.deleteRequest(token);
    }

    public void deleteUser(int targetUserId, Users actor) throws Exception {
        if (actor != null && actor.getId() == targetUserId) {
            throw new Exception("Không thể tự xóa chính mình.");
        }

        Users target = userDao.findUserById(targetUserId);
        if (target == null) throw new Exception("User không tồn tại.");

        if (target.getRoleId() == 1) {
            throw new Exception("Không thể xóa tài khoản ADMIN.");
        }

        boolean hasContracts = userDao.hasContracts(targetUserId);
        boolean hasProducts  = userDao.hasProducts(targetUserId);

        if (!hasContracts && !hasProducts) {
            userDao.deleteUser(targetUserId);
        } else {
            userDao.anonymizeAndDeactivate(targetUserId);
        }
    }


    @Override
    public int countUsersByFilter(String keyword, Integer roleId, Integer status) {
        return userDao.countUsersByFilter(keyword, roleId, status);
    }

    @Override
    public List<Users> getUsersByFilter(String keyword, Integer roleId, Integer status, int page, int pageSize) {
        return userDao.getUsersByFilter(keyword, roleId, status, page, pageSize);
    }

    @Override
    public List<Users> findUserByRoleId(int id) {
        return userDao.findUserByRoleId(id);
    }

    @Override
    public List<Users> getUsersByRole(int roleId) {
        return userDao.findUserByRoleId(roleId);
    }

    @Override
    public int countCustomerByFilter(String keyword) {
        return userDao.countCustomerByFilter(keyword);
    }

    @Override
    public List<Users> getCustomerByFilter(String keyword, int page, int pageSize) {
        return userDao.getCustomerByFilter(keyword, page, pageSize);
    }
}
