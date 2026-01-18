package com.generatorproject.services;

import com.generatorproject.model.Users;

import java.util.List;
import java.util.Map;

public interface IUserServices {
    List<Users> getAllUsers();

    Users createUser(Users user);

    Users findUserById(int id);

    void updateUser(Users user);

    Users findByEmailAndPassword(String email, String password);

    Users findByEmail(String email);

    String generatePasswordResetToken(String email);

    Integer getUserIdByValidToken(String token);

    void updatePassword(int userId, String newPassword);

    void markTokenAsUsed(String token);

    boolean changeStatus(int userId, int newStatus);

    List<Map<String, Object>> getPendingRequests();

    void activateToken(String token);

    void deleteToken(String token);
}
