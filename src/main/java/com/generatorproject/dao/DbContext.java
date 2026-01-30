package com.generatorproject.dao;

import java.sql.Connection;
import java.sql.DriverManager;

public class DbContext {

    private final String serverName = "localhost";
    private final String dbName = "generator_cms";
    private final String portNumber = "3306";

    private final String userID = "root";
    private final String password = "123456";

    public Connection getConnection() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");

        String url = "jdbc:mysql://" + serverName + ":" + portNumber + "/" + dbName + "?useSSL=false&allowPublicKeyRetrieval=true";

        return DriverManager.getConnection(url, userID, password);
    }

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