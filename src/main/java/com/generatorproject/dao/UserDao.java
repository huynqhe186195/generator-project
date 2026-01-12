package com.generatorproject.dao;

import com.generatorproject.model.Users;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;


public class UserDao extends DbContext {

    public List<Users> getAllUsers() {
        List<Users> list = new ArrayList<>();
        // Select đủ các cột cần thiết
        String sql = "SELECT * FROM users";

        try {
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            // Trong vòng lặp while (rs.next())
            while (rs.next()) {
                Users u = new Users.Builder()
                        .setId(rs.getInt("id"))
                        .setFullName(rs.getString("full_name"))
                        .setEmail(rs.getString("email"))
                        .setRoleId(rs.getInt("role_id"))
                        .setPhone(rs.getString("phone"))
                        .setStatus(rs.getInt("status"))
                        .setCreatedAt(rs.getTimestamp("created_at"))
                        // Xử lý avatar thông minh ngay tại đây
                        .setAvatarUrl(
                                (rs.getString("avatar_url") == null || rs.getString("avatar_url").isEmpty())
                                        ? "https://ui-avatars.com/api/?name=" + rs.getString("full_name")
                                        : rs.getString("avatar_url")
                        )
                        .build();

                list.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Users createUser(Users user) {
        Users newUser = new Users();
        String sql = "INSERT INTO users (full_name, email, password, phone, role_id, status, avatar_url) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try {
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword()); // Lưu ý: Dự án thật thì phải mã hóa MD5/BCrypt
            ps.setString(4, user.getPhone());
            ps.setInt(5, user.getRoleId());
            ps.setInt(6, user.getStatus());
            ps.setString(7, user.getAvatarUrl());

            ps.executeUpdate();

            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return newUser;
    }

    public Users findUserById(int id) {
        String sql = "SELECT * FROM users WHERE id = ?";
        try {
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // Dùng Builder để map dữ liệu
                return new Users.Builder()
                        .setId(rs.getInt("id"))
                        .setFullName(rs.getString("full_name"))
                        .setEmail(rs.getString("email"))
                        .setPassword(rs.getString("password"))
                        .setPhone(rs.getString("phone"))
                        .setRoleId(rs.getInt("role_id"))
                        .setStatus(rs.getInt("status"))
                        .setCreatedAt(rs.getTimestamp("created_at"))
                        .setAvatarUrl(rs.getString("avatar_url"))
                        .build();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

        public Users findByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = ? AND status = 1"; // Chỉ lấy user đang hoạt động (status=1)


        try {
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // SỬ DỤNG BUILDER ĐỂ MAP DỮ LIỆU TỪ DB VÀO OBJECT
                return new Users.Builder()
                        .setId(rs.getInt("id"))
                        .setRoleId(rs.getInt("role_id"))
                        .setEmail(rs.getString("email"))
                        .setPassword(rs.getString("password")) // Password này thường đã mã hóa
                        .setFullName(rs.getString("full_name"))
                        .setPhone(rs.getString("phone"))
                        .setAvatarUrl(rs.getString("avatar_url"))
                        .setStatus(rs.getInt("status"))
                        .setCreatedAt(rs.getTimestamp("created_at"))
                        .build();

            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void updateUser(Users user) {
        String sql = "UPDATE users SET full_name=?, phone=?, role_id=?, status=?, avatar_url=? WHERE id=?";

        try {
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, user.getFullName());
            ps.setString(2, user.getPhone());
            ps.setInt(3, user.getRoleId());
            ps.setInt(4, user.getStatus());
            ps.setString(5, user.getAvatarUrl());
            ps.setInt(6, user.getId());

            ps.executeUpdate();

            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public boolean updatePassword(int userId, String newPassword) {
        String sql = "UPDATE users SET password = ? WHERE id = ?";

        try {
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            // Lưu ý: newPassword nên được mã hóa (MD5/BCrypt) trước khi truyền vào đây
            ps.setString(1, newPassword);
            ps.setInt(2, userId);

            int rowsUpdated = ps.executeUpdate();
            return rowsUpdated > 0; // Trả về true nếu cập nhật thành công ít nhất 1 dòng

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}