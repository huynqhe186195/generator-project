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
