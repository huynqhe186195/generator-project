package com.generatorproject.dao;

import com.generatorproject.model.Role;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class RoleDAO extends DbContext {

    public List<Role> getAll() {
        List<Role> list = new ArrayList<>();
        String sql = "SELECT * FROM roles";

        try {
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Role r = new Role();
                r.setId(rs.getInt("id"));
                r.setName(rs.getString("name"));
                r.setDescription(rs.getString("description"));
                r.setStatus(rs.getInt("status"));
                list.add(r);
            }

            rs.close();
            ps.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Role getById(int id) {
        String sql = "SELECT * FROM roles WHERE id = ?";

        try {
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Role r = new Role();
                r.setId(id);
                r.setName(rs.getString("name"));
                r.setDescription(rs.getString("description"));
                r.setStatus(rs.getInt("status"));

                rs.close();
                ps.close();
                conn.close();

                return r;
            }

            rs.close();
            ps.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void update(int id, String name, String description, int status) {
        String sql = "UPDATE roles SET name=?, description=?, status=? WHERE id=?";

        try {
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, name);
            ps.setString(2, description);
            ps.setInt(3, status);
            ps.setInt(4, id);

            ps.executeUpdate();

            ps.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateStatus(int id, int status) {
        String sql = "UPDATE roles SET status=? WHERE id=?";

        try {
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, status);
            ps.setInt(2, id);

            ps.executeUpdate();

            ps.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void toggleStatus(int roleId) {
        String sql = "UPDATE roles SET status = CASE WHEN status = 1 THEN 0 ELSE 1 END WHERE id = ?";

        try {
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, roleId);
            ps.executeUpdate();

            ps.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void insert(Role r) {
        String sql = "INSERT INTO roles(name, description, status) VALUES (?, ?, ?)";

        try {
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, r.getName());
            ps.setString(2, r.getDescription());
            ps.setInt(3, r.getStatus());

            ps.executeUpdate();

            ps.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
