package com.generatorproject.services;

import com.generatorproject.model.Users;

import java.util.List;

public interface IUserServices {
    List<Users> getAllUsers();

    Users createUser(Users user);
}
