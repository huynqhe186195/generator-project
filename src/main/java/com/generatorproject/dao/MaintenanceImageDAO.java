package com.generatorproject.dao;

import com.generatorproject.model.MaintenanceImage;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class MaintenanceImageDAO extends DbContext {

    public boolean insert(int maintenanceId, String imagePath) {
        String sql = """
            INSERT INTO maintenance_images (maintenance_id, image_path)
            VALUES (?, ?)
        """;

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maintenanceId);
            ps.setString(2, imagePath);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<MaintenanceImage> getByMaintenanceId(int maintenanceId) {
        List<MaintenanceImage> list = new ArrayList<>();

        String sql = """
            SELECT id, maintenance_id, image_path, uploaded_at
            FROM maintenance_images
            WHERE maintenance_id = ?
            ORDER BY id DESC
        """;

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maintenanceId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                MaintenanceImage img = new MaintenanceImage();
                img.setId(rs.getInt("id"));
                img.setMaintenanceId(rs.getInt("maintenance_id"));
                img.setImagePath(rs.getString("image_path"));
                img.setUploadedAt(rs.getTimestamp("uploaded_at"));
                list.add(img);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM maintenance_images WHERE id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}