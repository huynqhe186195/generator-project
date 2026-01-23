package com.generatorproject.validation;

import com.generatorproject.dao.DbContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class GenericValidation extends DbContext {

    /**
     * Hàm kiểm tra giá trị đã tồn tại trong bảng chưa (Dùng cho chức năng ADD)
     * @param tableName Tên bảng trong DB (vd: "users")
     * @param columnName Tên cột muốn check (vd: "email" hoặc "phone")
     * @param value Giá trị muốn check (vd: "huy@gmail.com")
     */
    public boolean isValueExist(String tableName, String columnName, Object value) {
        String sql = "SELECT COUNT(*) FROM " + tableName + " WHERE " + columnName + " = ?";

        try {
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);

            if (value instanceof String) {
                ps.setString(1, (String) value);
            } else if (value instanceof Integer) {
                ps.setInt(1, (Integer) value);
            }

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                boolean exists = rs.getInt(1) > 0;
                conn.close();
                return exists;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Hàm kiểm tra tồn tại nhưng LOẠI TRỪ ID hiện tại (Dùng cho chức năng UPDATE)
     * Ví dụ: Khi sửa User A, không báo lỗi trùng email nếu email đó là của chính A.
     */
    public boolean isValueExistExceptId(String tableName, String columnName, Object value, int idToExclude) {
        String sql = "SELECT COUNT(*) FROM " + tableName + " WHERE " + columnName + " = ? AND id != ?";

        try {
            Connection conn = getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);

            if (value instanceof String) {
                ps.setString(1, (String) value);
            } else {
                ps.setObject(1, value);
            }
            ps.setInt(2, idToExclude);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                boolean exists = rs.getInt(1) > 0;
                conn.close();
                return exists;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}