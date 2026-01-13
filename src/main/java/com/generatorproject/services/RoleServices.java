package com.generatorproject.services;

import com.generatorproject.dao.RoleDAO;
import com.generatorproject.model.Role;

import java.util.Collections;
import java.util.List;

public class RoleServices implements IRoleServices{
    private final RoleDAO roleDAO;

    public RoleServices() {
        this.roleDAO = new RoleDAO();
    }
    @Override
    public List<Role> getAllRoles() {
        return roleDAO.getAll();
    }

    @Override
    public boolean createRole(Role role) {
        return roleDAO.insert(role);
    }

    @Override
    public boolean updateRole(Role role) {
        return roleDAO.update(role);
    }

    @Override
    public Role getRoleById(int id) {
        return roleDAO.getById(id);
    }
}
