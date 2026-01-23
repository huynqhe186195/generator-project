package com.generatorproject.dao;

import com.generatorproject.mapper.RowMapper;
import com.generatorproject.mapper.UserMapper;
import com.generatorproject.model.Users;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public class UserDao extends GenericDAO<Users> {

    public List<Users> getAllUsers() {
        String sql = "select * from users";
        return query(sql, new UserMapper());
    }

    public void createUser(Users user) {
        String sql = "INSERT INTO users (full_name, email, password, phone, role_id, status, avatar_url) VALUES (?, ?, ?, ?, ?, ?, ?)";
        update(sql,
                user.getFullName(),
                user.getEmail(),
                user.getPassword(),
                user.getPhone(),
                user.getRoleId(),
                user.getStatus(),
                user.getAvatarUrl()
        );
    }

    public Users findUserById(int id) {
        String sql = "SELECT * FROM users WHERE id = ?";
        List<Users> users = query(sql, new UserMapper(), id);
        return users.isEmpty() ? null : users.get(0);
    }

    public Users checkLogin(String email, String password) {
        String sql = "SELECT u.*, r.name as role_name, r.redirect_url " +
                "FROM users u " +
                "JOIN roles r ON u.role_id = r.id " +
                "WHERE u.email = ? AND u.status = 1";

        List<Users> users = query(sql, new RowMapper<Users>() {
            @Override
            public Users mapRow(ResultSet rs) {
                Users u = new UserMapper().mapRow(rs);
                try {
                    u.setRoleName(rs.getString("role_name"));
                    u.setRoleUrl(rs.getString("redirect_url"));
                } catch (SQLException e) {
                    e.printStackTrace();
                }
                return u;
            }}, email);

        if (users == null || users.isEmpty()) {
            return null;
        }

        Users user = users.get(0);

        String storedHash = user.getPassword();

        if (BCrypt.checkpw(password, storedHash)) {
            List<String> permissions = getPermissionsByRoleId(user.getRoleId());
            user.setPermissions(permissions);
            return user;
        }
        return null;
    }

    public void deleteUser(int id){
        String sql = "DELETE FROM users WHERE id = ?";
        update(sql, id);
    }

    public List<String> getPermissionsByRoleId(int roleId) {
        String sql = "SELECT p.code FROM permissions p " +
                "JOIN role_permissions rp ON p.id = rp.permission_id " +
                "WHERE rp.role_id = ?";
        return query(sql, new RowMapper<String>() {
            @Override
            public String mapRow(ResultSet rs) {
                try {
                    return rs.getString("code");
                } catch (SQLException e) {
                    return null;
                }
            }
        }, roleId);
    }

    public Users findByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = ? AND status = 1";

        List<Users> users = query(sql, new UserMapper(), email);

        return users.isEmpty() ? null : users.get(0);
    }

    public void updateUser(Users user) {
        String sql = "UPDATE users SET full_name=?, phone=?, role_id=?, status=?, avatar_url=? WHERE id=?";
        update(sql, user.getFullName(), user.getPhone(), user.getRoleId(), user.getStatus(), user.getAvatarUrl(), user.getId());
    }

    public boolean changeStatus(int userId, int newStatus) {
        String sql = "UPDATE users SET status = ? WHERE id = ?";
        update(sql, newStatus, userId);
        return true;
    }
    public int countUsers() {
        String sql = "SELECT COUNT(*) FROM users";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }
}