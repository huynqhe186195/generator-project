package com.generatorproject.dao;

import com.generatorproject.model.Brand;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class BrandDAO extends DbContext {

    public List<Brand> listBrands(String keyword, int page, int pageSize, String sort) {
        List<Brand> list = new ArrayList<>();

        if (page < 1) page = 1;
        if (pageSize <= 0) pageSize = 10;

        // sort whitelist
        String orderBy = "name ASC";
        if ("name_desc".equals(sort)) orderBy = "name DESC";
        else if ("id_asc".equals(sort)) orderBy = "id ASC";
        else if ("id_desc".equals(sort)) orderBy = "id DESC";

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT id, name, slug, logo_url FROM brands ");

        boolean hasKw = keyword != null && !keyword.trim().isEmpty();
        if (hasKw) sql.append("WHERE LOWER(name) LIKE ? OR LOWER(slug) LIKE ? ");

        sql.append("ORDER BY ").append(orderBy).append(" ");
        sql.append("LIMIT ? OFFSET ?");

        int offset = (page - 1) * pageSize;

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int idx = 1;
            if (hasKw) {
                String kw = "%" + keyword.trim().toLowerCase() + "%";
                ps.setString(idx++, kw);
                ps.setString(idx++, kw);
            }
            ps.setInt(idx++, pageSize);
            ps.setInt(idx, offset);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Brand b = new Brand();
                    b.setId(rs.getInt("id"));
                    b.setName(rs.getString("name"));
                    b.setSlug(rs.getString("slug"));
                    b.setLogoUrl(rs.getString("logo_url"));
                    list.add(b);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public int countBrands(String keyword) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) FROM brands ");

        boolean hasKw = keyword != null && !keyword.trim().isEmpty();
        if (hasKw) sql.append("WHERE LOWER(name) LIKE ? OR LOWER(slug) LIKE ?");

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            if (hasKw) {
                String kw = "%" + keyword.trim().toLowerCase() + "%";
                ps.setString(1, kw);
                ps.setString(2, kw);
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }


    // Dùng method này cho dropdown filter
    public List<Brand> getAllBrands() {
        List<Brand> list = new ArrayList<>();
        String sql = "SELECT id, name, slug, logo_url FROM brands ORDER BY name ASC";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Brand b = new Brand();
                b.setId(rs.getInt("id"));
                b.setName(rs.getString("name"));
                b.setSlug(rs.getString("slug"));
                b.setLogoUrl(rs.getString("logo_url"));
                list.add(b);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }


    public Brand findByName(String name) {
        if (name == null || name.trim().isEmpty()) return null;

        String sql = "SELECT id, name, slug, logo_url FROM brands WHERE LOWER(name) = LOWER(?) LIMIT 1";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, name.trim());

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Brand b = new Brand();
                    b.setId(rs.getInt("id"));
                    b.setName(rs.getString("name"));
                    b.setSlug(rs.getString("slug"));
                    b.setLogoUrl(rs.getString("logo_url"));
                    return b;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }


    public Brand findById(int id) {
        String sql = "SELECT id, name, slug, logo_url FROM brands WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Brand b = new Brand();
                    b.setId(rs.getInt("id"));
                    b.setName(rs.getString("name"));
                    b.setSlug(rs.getString("slug"));
                    b.setLogoUrl(rs.getString("logo_url"));
                    return b;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public int insert(Brand b) {
        String sql = "INSERT INTO brands(name, slug, logo_url) VALUES(?,?,?)";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, b.getName());
            ps.setString(2, b.getSlug());
            ps.setString(3, b.getLogoUrl());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }
    public int countBrands() {
        String sql = "SELECT COUNT(*) FROM brands";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) return rs.getInt(1);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;

    }
    public boolean existsNameExceptId(String name, int excludeId) {
        if (name == null || name.trim().isEmpty()) return false;

        String sql = "SELECT 1 FROM brands WHERE LOWER(name)=LOWER(?) AND id <> ? LIMIT 1";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, name.trim());
            ps.setInt(2, excludeId);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(Brand b) {
        String sql = "UPDATE brands SET name = ?, slug = ?, logo_url = ? WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, b.getName());
            ps.setString(2, b.getSlug());
            ps.setString(3, b.getLogoUrl());
            ps.setInt(4, b.getId());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    public boolean deleteById(int id) {
        String sql = "DELETE FROM brands WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    public boolean isBrandUsed(int brandId) {
        String sql = "SELECT 1 FROM product_models WHERE brand_id = ? LIMIT 1";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, brandId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
