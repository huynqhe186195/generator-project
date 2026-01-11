package com.generatorproject.dao;

import com.generatorproject.model.Permission;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class PermissionDAO extends DbContext {

    public List<Permission> getAll() {
        List<Permission> list = new ArrayList<>();
        String sql = "SELECT * FROM permissions";

        try {
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Permission p = new Permission();
                p.setId(rs.getInt("id"));
                p.setName(rs.getString("name"));
                p.setCode(rs.getString("code"));
                p.setModule(rs.getString("module"));
                list.add(p);
            }

            rs.close();
            ps.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Permission> getByRole(int roleId) {
        List<Permission> list = new ArrayList<>();
        String sql =
                "SELECT p.* " +
                        "FROM permissions p " +
                        "JOIN role_permissions rp ON p.id = rp.permission_id " +
                        "WHERE rp.role_id = ?";

        try {
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, roleId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Permission p = new Permission();
                p.setId(rs.getInt("id"));
                p.setName(rs.getString("name"));
                p.setCode(rs.getString("code"));
                p.setModule(rs.getString("module"));
                list.add(p);
            }

            rs.close();
            ps.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
