package com.generatorproject.dao;

import org.mindrot.jbcrypt.BCrypt;

import java.sql.Connection;
import java.sql.PreparedStatement;

public class AccountDao extends DbContext{
    public boolean changePassword(int userId, String newPassword) {
        String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt(12));

        String sql = "UPDATE users SET password = ? WHERE id = ?";
        try {
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, hashedPassword); // Lưu bản mã hóa
            ps.setInt(2, userId);

            int rowAffected = ps.executeUpdate();
            conn.close();
            return rowAffected > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
