package com.generatorproject.services;

import com.generatorproject.model.Permission;
import com.generatorproject.model.Role;

import java.util.List;

public interface IRoleServices {
    List<Role> getAllRoles();

    boolean createRole(Role role);

    boolean updateRole(Role role);

    Role getRoleById(int id);

    void deleteRoleById(int id);

    void toggleStatus(int id);

    Role getById(int id);

    List<Permission> getAllSystemPermissions();

    List<Integer> getPermissionIdsByRole(int roleId);

    void updateRolePermissions(int roleId, String[] permissionIds);
}
