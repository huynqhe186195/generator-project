package com.generatorproject.dao;

import com.generatorproject.mapper.RowMapper;
import com.generatorproject.mapper.UserMapper;
import com.generatorproject.model.Users;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class UserDao extends GenericDAO<Users> {

    private static final int CUSTOMER_ROLE_ID = 2;

    public List<Users> getAllUsers() {
        String sql = "select * from users";
        return query(sql, new UserMapper());
    }

    public Users findByPhone(String phone) {
        String sql = "SELECT * FROM users WHERE phone = ?";
        List<Users> users = query(sql, new UserMapper(), phone);
        return users.isEmpty() ? null : users.get(0);
    }

    public void createUser(Users user) throws Exception {
        if (user.getPhone() != null && !user.getPhone().isEmpty()) {
            Users existingUser = findByPhone(user.getPhone());
            if (existingUser != null) {
                throw new Exception("Số điện thoại " + user.getPhone() + " đã được sử dụng!");
            }
        }
        String sql = "INSERT INTO users (full_name, email, password, phone, role_id, status, avatar_url) VALUES (?, ?, ?, ?, ?, ?, ?)";
        update(sql,
                user.getFullName(),
                user.getEmail(),
                user.getPassword(),
                user.getPhone(),
                user.getRoleId(),
                user.getStatus(),
                user.getAvatarUrl());
    }

    public Users findUserById(int id) {
        String sql = "SELECT * FROM users WHERE id = ?";
        List<Users> users = query(sql, new UserMapper(), id);
        return users.isEmpty() ? null : users.get(0);
    }

    public List<Users> findUserByRoleId(int id) {
        String sql = "SELECT * FROM users WHERE role_id = ?";
        List<Users> users = query(sql, new UserMapper(), id);
        return users.isEmpty() ? null : users;
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
            }
        }, email);

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

    public void deleteUser(int id) {
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

    public void updateUser(Users user) throws Exception {
        if (user.getPhone() != null && !user.getPhone().isEmpty()) {
            Users owner = findByPhone(user.getPhone());

            if (owner != null && owner.getId() != user.getId()) {
                throw new Exception("Số điện thoại này đã thuộc về tài khoản khác!");
            }
        }
        String sql = "UPDATE users SET full_name=?, phone=?, role_id=?, status=?, avatar_url=? WHERE id=?";
        update(sql, user.getFullName(), user.getPhone(), user.getRoleId(), user.getStatus(), user.getAvatarUrl(),
                user.getId());
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
            if (rs.next())
                return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countUsersByFilter(String keyword, Integer roleId, Integer status) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM users WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (full_name LIKE ? OR email LIKE ?)");
            String searchPattern = "%" + keyword.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
        }

        if (roleId != null) {
            sql.append(" AND role_id = ?");
            params.add(roleId);
        }

        if (status != null) {
            sql.append(" AND status = ?");
            params.add(status);
        }

        return count(sql.toString(), params.toArray());
    }

    public int countCustomerByFilter(String keyword) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM users WHERE role_id = 5");
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (full_name LIKE ? OR email LIKE ?)");
            String searchPattern = "%" + keyword.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
        }

        return count(sql.toString(), params.toArray());
    }

    public List<Users> getUsersByFilter(String keyword, Integer roleId, Integer status, int page, int pageSize) {
        StringBuilder sql = new StringBuilder("SELECT * FROM users WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (full_name LIKE ? OR email LIKE ?)");
            String searchPattern = "%" + keyword.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
        }

        if (roleId != null) {
            sql.append(" AND role_id = ?");
            params.add(roleId);
        }

        if (status != null) {
            sql.append(" AND status = ?");
            params.add(status);
        }

        sql.append(" ORDER BY id DESC LIMIT ? OFFSET ?");

        int offset = (page - 1) * pageSize;
        params.add(pageSize);
        params.add(offset);

        return query(sql.toString(), new UserMapper(), params.toArray());
    }

    public List<Users> getCustomerByFilter(String keyword, int page, int pageSize) {
        StringBuilder sql = new StringBuilder("SELECT * FROM users WHERE role_id = 5");
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (full_name LIKE ? OR email LIKE ?)");
            String searchPattern = "%" + keyword.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
        }

        sql.append(" ORDER BY id DESC LIMIT ? OFFSET ?");

        int offset = (page - 1) * pageSize;
        params.add(pageSize);
        params.add(offset);

        return query(sql.toString(), new UserMapper(), params.toArray());
    }

    // =========================
    // ✅ FIX: lấy customer cho dropdown (KHÔNG PHỤ THUỘC roles.name)
    // =========================
    public List<Users> getAllCustomers() {
        String sql = "SELECT * FROM users WHERE status = 1 ORDER BY full_name";
        return query(sql, new UserMapper(), CUSTOMER_ROLE_ID);
    }

    // Nếu muốn cho chọn tất cả user active (fallback)
    public List<Users> getAllUsersActive() {
        String sql = "SELECT * FROM users WHERE status = 1 ORDER BY full_name";
        return query(sql, new UserMapper());
    }

    public boolean hasContracts(int userId) {
        String sql = "SELECT COUNT(*) FROM contracts WHERE customer_id = ?";
        return count(sql, userId) > 0;
    }

    public boolean hasProducts(int userId) {
        String sql = "SELECT COUNT(*) FROM products WHERE customer_id = ?";
        return count(sql, userId) > 0;
    }

    public void anonymizePii(int id) {
        String sql =
                "UPDATE users SET " +
                        "full_name = CONCAT('DELETED_USER_', id), " +
                        "email = CONCAT('deleted_', id, '@local'), " +
                        "phone = NULL, " +
                        "avatar_url = NULL " +
                        "WHERE id = ?";
        update(sql, id);
    }

    public void anonymizeAndDeactivate(int id) {
        String sql =
                "UPDATE users SET status = 0, " +
                        "full_name = CONCAT('DELETED_USER_', id), " +
                        "email = CONCAT('deleted_', id, '@local'), " +
                        "phone = NULL, " +
                        "avatar_url = NULL " +
                        "WHERE id = ?";
        update(sql, id);
    }

    public void updateProfile(Users user) throws Exception {
        if (user.getPhone() != null && !user.getPhone().isEmpty()) {
            Users owner = findByPhone(user.getPhone());
            if (owner != null && owner.getId() != user.getId()) {
                throw new Exception("Số điện thoại này đã thuộc về tài khoản khác!");
            }
        }

        String sql = "UPDATE users SET full_name = ?, phone = ?, avatar_url = ? WHERE id = ?";
        update(sql, user.getFullName(), user.getPhone(), user.getAvatarUrl(), user.getId());
    }
}
