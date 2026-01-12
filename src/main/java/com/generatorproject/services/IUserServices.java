package com.generatorproject.services;

import com.generatorproject.model.Users;

import java.util.List;

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
}
