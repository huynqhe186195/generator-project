package com.generatorproject.validation;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import com.generatorproject.dao.DbContext;

public class UserValidate extends DbContext{
    // Kiểm tra email đã tồn tại chưa (True = Đã có, False = Chưa có)
    public boolean checkEmailExist(String email) {
        String sql = "SELECT COUNT(*) FROM users WHERE email = ?";
        try {
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0; // Nếu đếm > 0 tức là đã tồn tại
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
