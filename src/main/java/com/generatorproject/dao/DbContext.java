package com.generatorproject.dao;

import java.sql.Connection;
import java.sql.DriverManager;

public class DbContext {

    private static final String DEFAULT_URL =
            "jdbc:mysql://localhost:3306/generator_cms?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String DEFAULT_USER = "root";
    private static final String DEFAULT_PASS = "123456789";

    public Connection getConnection() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");

        String url  = System.getenv().getOrDefault("DB_URL", DEFAULT_URL);
        String user = System.getenv().getOrDefault("DB_USER", DEFAULT_USER);
        String pass = System.getenv().getOrDefault("DB_PASS", DEFAULT_PASS);

        return DriverManager.getConnection(url, user, pass);
    }

    public static void main(String[] args) {
        try {
            DbContext db = new DbContext();
            Connection conn = db.getConnection();
            System.out.println(conn != null ? "Kết nối thành công! (Success)" : "Kết nối thất bại!");
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Lỗi kết nối: " + e.getMessage());
        }
    }
}