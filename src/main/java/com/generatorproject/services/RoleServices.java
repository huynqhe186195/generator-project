package com.generatorproject.services;

import com.generatorproject.dao.RoleDAO;
import com.generatorproject.model.Permission;
import com.generatorproject.model.Role;

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

    @Override
    public void deleteRoleById(int id) {roleDAO.delete(id);}

    @Override
    public void toggleStatus(int id) {
        roleDAO.toggleStatus(id);
    }

    @Override
    public Role getById(int id) {
        return roleDAO.getById(id);
    }

    @Override
    public List<Permission> getAllSystemPermissions() {
        return roleDAO.getAllSystemPermissions();
    }

    @Override
    public List<Integer> getPermissionIdsByRole(int roleId) {
        return roleDAO.getPermissionIdsByRole(roleId);
    }

    @Override
    public void updateRolePermissions(int roleId, String[] permissionIds) {
        roleDAO.updateRolePermissions(roleId, permissionIds);
    }
}
