package com.generatorproject.services;

import com.generatorproject.model.Users;

import java.util.List;
import java.util.Map;

public interface IUserServices {
    List<Users> getAllUsers();

    void createUser(Users user);

    Users findUserById(int id);

    void updateUser(Users user);

    Users findByEmailAndPassword(String email, String password);

    Users findByEmail(String email);

    String generatePasswordResetToken(String email);

    Integer getUserIdByValidToken(String token);

    void markTokenAsUsed(String token);

    boolean changeStatus(int userId, int newStatus);

    List<Map<String, Object>> getPendingRequests();

    void activateToken(String token);

    void deleteToken(String token);

    void deleteUser(int id);

    int countUsersByFilter(String keyword, Integer roleId, Integer status);

    int countCustomerByFilter(String keyword);

    List<Users> getUsersByFilter(String keyword, Integer roleId, Integer status, int page, int pageSize);

    List<Users> getCustomerByFilter(String keyword, int page, int pageSize);

    List<Users> findUserByRoleId(int id);
}
