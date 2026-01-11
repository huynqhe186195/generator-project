package com.generatorproject.dao;

import com.generatorproject.dao.DbContext;
import com.generatorproject.model.Users;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import static java.sql.DriverManager.getConnection;

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
}