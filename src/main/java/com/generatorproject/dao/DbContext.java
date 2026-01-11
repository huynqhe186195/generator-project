package com.generatorproject.dao;

import java.sql.Connection;
import java.sql.DriverManager;

public class DbContext {

    /* Dùng localhost:3306 và tên DB vừa tạo */
    private final String serverName = "localhost";
    private final String dbName = "generator_cms";
    private final String portNumber = "3306";

    /* SỬA LẠI USER/PASS CỦA MÁY HUY Ở ĐÂY */
    private final String userID = "root"; // Mặc định thường là root
    private final String password = "123456";   // Nếu cài XAMPP thì để trống, nếu cài MySQL Workbench thì thường là 123456 hoặc root

    public Connection getConnection() throws Exception {
        // 1. Khai báo Driver mới (MySQL 8.0+)
        Class.forName("com.mysql.cj.jdbc.Driver");

        // 2. Tạo đường dẫn kết nối
        // useSSL=false: Tắt bảo mật SSL để đỡ lỗi local
        String url = "jdbc:mysql://" + serverName + ":" + portNumber + "/" + dbName + "?useSSL=false&allowPublicKeyRetrieval=true";

        // 3. Trả về kết nối
        return DriverManager.getConnection(url, userID, password);
    }

    // Hàm main để test thử xem kết nối được chưa
    public static void main(String[] args) {
        try {
            DbContext db = new DbContext();
            Connection conn = db.getConnection();
            if (conn != null) {
                System.out.println("Kết nối thành công! (Success)");
            } else {
                System.out.println("Kết nối thất bại!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Lỗi kết nối: " + e.getMessage());
        }
    }
}