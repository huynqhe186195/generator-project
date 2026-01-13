package com.generatorproject.dao;

import com.generatorproject.model.Permission;
import com.generatorproject.model.Role;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
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
        // 1. Nhớ chọn đủ cột (tốt nhất là dùng SELECT *)
        String sql = "SELECT * FROM roles WHERE id = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return new Role.Builder()
                        .id(rs.getInt("id"))
                        .name(rs.getString("name"))
                        .description(rs.getString("description"))
                        .status(rs.getInt("status"))
                        .redirectUrl(rs.getString("redirect_url"))
                        .build();
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return null;
    }

    public void delete(int id) {
        String sql = "DELETE FROM roles WHERE id=?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    public boolean update(Role r) {
        // Nhớ thêm redirect_url = ? vào câu lệnh SQL
        String sql = "UPDATE roles SET name = ?, description = ?, status = ?, redirect_url = ? WHERE id = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, r.getName());
            ps.setString(2, r.getDescription());
            ps.setInt(3, r.getStatus());
            ps.setString(4, r.getRedirectUrl()); // Set giá trị mới
            ps.setInt(5, r.getId());             // ID để tìm dòng cần sửa

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
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

    public boolean insert(Role r) {
        // 🆕 Thêm cột redirect_url vào câu lệnh SQL
        String sql = "INSERT INTO roles(name, description, status, redirect_url) VALUES (?, ?, ?, ?)";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, r.getName());
            ps.setString(2, r.getDescription());
            ps.setInt(3, r.getStatus());
            ps.setString(4, r.getRedirectUrl());

            int rowsAffected = ps.executeUpdate();

            return rowsAffected > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Permission> getAllSystemPermissions() {
        List<Permission> list = new ArrayList<>();
        // Sắp xếp theo module để hiển thị nhóm cho đẹp
        String sql = "SELECT * FROM permissions ORDER BY module, code";

        try {
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                // Tạo đối tượng Permission từ DB
                Permission p = new Permission();
                p.setId(rs.getInt("id"));
                p.setName(rs.getString("name"));
                p.setCode(rs.getString("code"));
                p.setModule(rs.getString("module"));
                // p.setDescription(rs.getString("description")); // Nếu có

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

    public List<Integer> getPermissionIdsByRole(int roleId) {
        List<Integer> list = new ArrayList<>();
        String sql = "SELECT permission_id FROM role_permissions WHERE role_id = ?";

        try {
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, roleId);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(rs.getInt("permission_id"));
            }

            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public void updateRolePermissions(int roleId, String[] permissionIds) {
        String deleteSql = "DELETE FROM role_permissions WHERE role_id = ?";
        String insertSql = "INSERT INTO role_permissions (role_id, permission_id) VALUES (?, ?)";

        Connection conn = null;
        try {
            conn = getConnection();
            conn.setAutoCommit(false); // BẮT ĐẦU TRANSACTION (Khóa DB lại)

            PreparedStatement psDel = conn.prepareStatement(deleteSql);
            psDel.setInt(1, roleId);
            psDel.executeUpdate();
            psDel.close();

            if (permissionIds != null && permissionIds.length > 0) {
                PreparedStatement psIns = conn.prepareStatement(insertSql);
                for (String permId : permissionIds) {
                    psIns.setInt(1, roleId);
                    psIns.setInt(2, Integer.parseInt(permId));
                    psIns.addBatch(); // Gom lại chạy 1 lần cho nhanh
                }
                psIns.executeBatch(); // Thực thi insert hàng loạt
                psIns.close();
            }

            conn.commit(); // CHỐT ĐƠN! Lưu thay đổi vào DB thật

        } catch (Exception e) {
            // Nếu có lỗi thì hoàn tác (Rollback) để không bị mất dữ liệu
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            // Luôn đóng kết nối dù thành công hay thất bại
            try {
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
