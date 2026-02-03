package com.generatorproject.dao;

import com.generatorproject.mapper.ProductMapper;
import com.generatorproject.mapper.RowMapper;
import com.generatorproject.model.Brand;
import com.generatorproject.model.Product;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO extends GenericDAO<Product> {

    public Long save(Product product) {
        StringBuilder sql = new StringBuilder("INSERT INTO products (");
        sql.append("serial_number, customer_id, status, total_running_hours, ");
        sql.append("manufacture_year, purchase_date, current_location, model_id, created_at");
        sql.append(") VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW())");

        return insert(sql.toString(),
                product.getSerialNumber(),
                product.getCustomerId(),      // Có thể null nếu chưa gán khách
                product.getStatus(),          // VD: "RUNNING", "READY"
                product.getTotalRunningHours(), // Mặc định 0.0
                product.getManufactureYear(), // Lấy từ file docx hoặc form nhập tay
                product.getPurchaseDate(),    // Lấy từ file docx hoặc form nhập tay
                product.getCurrentLocation(),
                product.getModelId()          // Có thể null
        );
    }

    public Product findBySerial(String serialNumber) {
        String sql = "SELECT * FROM products WHERE serial_number = ?";

        List<Product> results = query(sql, new ProductMapper(), serialNumber);

        return results.isEmpty() ? null : results.get(0);
    }

    public int countProducts() {
        String sql = "SELECT COUNT(*) FROM products";

        return count(sql, null);
    }

    public double sumRunningHours() {
        String sql = "SELECT SUM(total_running_hours) FROM products";

        return count(sql, null);
    }

    public void update(Product product) {
        String sql = "UPDATE products SET customer_id = ?, status = ?, current_location = ?, updated_at = NOW() WHERE id = ?";

        update(sql,
                product.getCustomerId(),
                product.getStatus(),
                product.getCurrentLocation(),
                product.getId()
        );
    }

    public List<Product> findAll() {
        String sql = "SELECT * FROM products";
        return query(sql, new ProductMapper());
    }
}
