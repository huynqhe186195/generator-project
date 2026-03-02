package com.generatorproject.dao;

import com.generatorproject.model.Category;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO extends DbContext {

    // Lấy tất cả category (dùng cho dropdown)
    public List<Category> getAllCategories() {
        List<Category> list = new ArrayList<Category>();
        String sql = "SELECT id, name FROM categories ORDER BY name ASC";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Category c = new Category();
                c.setId(rs.getInt("id"));
                c.setName(rs.getString("name"));
                list.add(c);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }


    public Category findByName(String name) {
        if (name == null || name.trim().isEmpty()) return null;

        String sql = "SELECT id, name FROM categories WHERE LOWER(name) = LOWER(?) LIMIT 1";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, name.trim());

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Category c = new Category();
                    c.setId(rs.getInt("id"));
                    c.setName(rs.getString("name"));
                    return c;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Lấy 1 category theo id (nếu bạn cần)
    public Category findById(int id) {
        String sql = "SELECT id, name FROM categories WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Category c = new Category();
                    c.setId(rs.getInt("id"));
                    c.setName(rs.getString("name"));
                    return c;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public int countCategories() {
        String sql = "SELECT COUNT(*) FROM categories";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) return rs.getInt(1);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
    // Lấy danh sách category (dùng cho trang list)
    public List<Category> list() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT id, name FROM categories ORDER BY id DESC";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Category c = new Category();
                c.setId(rs.getInt("id"));
                c.setName(rs.getString("name"));
                list.add(c);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    public List<Category> filter(String keyword) {
        List<Category> list = new ArrayList<>();

        String sql =
                "SELECT id, name FROM categories " +
                        "WHERE (? IS NULL OR ? = '' " +
                        "   OR name LIKE ? " +
                        "   OR CAST(id AS CHAR) LIKE ?) " +
                        "ORDER BY id DESC";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            String k = (keyword == null) ? "" : keyword.trim();
            String like = "%" + k + "%";

            ps.setString(1, k);
            ps.setString(2, k);
            ps.setString(3, like);
            ps.setString(4, like);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Category c = new Category();
                    c.setId(rs.getInt("id"));
                    c.setName(rs.getString("name"));
                    list.add(c);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    public boolean insert(String name) {
        if (name == null) return false;

        String n = name.trim();
        if (n.isEmpty()) return false;

        String slug = n.toLowerCase()
                .replaceAll("[^a-z0-9\\s-]", "")
                .replaceAll("\\s+", "-");

        String sql = "INSERT INTO categories(name, slug, parent_id) VALUES(?, ?, NULL)";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, n);
            ps.setString(2, slug);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
    public boolean update(int id, String name) {
        if (name == null) return false;
        String n = name.trim();
        if (n.isEmpty()) return false;

        String sql = "UPDATE categories SET name = ? WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, n);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    public Category findByNameExceptId(String name, int exceptId) {
        if (name == null || name.trim().isEmpty()) return null;

        String sql = "SELECT id, name FROM categories WHERE LOWER(name) = LOWER(?) AND id <> ? LIMIT 1";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, name.trim());
            ps.setInt(2, exceptId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Category c = new Category();
                    c.setId(rs.getInt("id"));
                    c.setName(rs.getString("name"));
                    return c;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    public int countProductModelsUsingCategory(int categoryId) {
        // TODO: nếu cột khác tên category_id thì đổi ở đây
        String sql = "SELECT COUNT(*) FROM product_models WHERE category_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, categoryId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
    public boolean delete(int id) {
        String sql = "DELETE FROM categories WHERE id = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
