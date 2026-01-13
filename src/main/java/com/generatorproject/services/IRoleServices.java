package com.generatorproject.services;

import com.generatorproject.model.Role;

import java.util.List;

public interface IRoleServices {
    List<Role> getAllRoles();

    boolean createRole(Role role);

    boolean updateRole(Role role);

    Role getRoleById(int id);
}
