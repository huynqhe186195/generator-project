package com.generatorproject.dao;

import com.generatorproject.model.Brand;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import com.generatorproject.model.Brand;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BrandDAO extends DbContext {
    public List<Brand> findAll() {
        List<Brand> list = new ArrayList<>();
        String sql = "SELECT * FROM brands";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Brand b = new Brand();
                b.setId(rs.getInt("id"));
                b.setName(rs.getString("name"));
                b.setLogoUrl(rs.getString("logo_url"));
                list.add(b);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
