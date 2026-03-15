package com.generatorproject.dao;

import com.generatorproject.model.MaintenanceImage;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class MaintenanceImageDAO extends DbContext {

    public boolean insert(int maintenanceId, String imagePath, String imageType) {
        String sql = """
        INSERT INTO maintenance_images(maintenance_id, image_path, image_type)
        VALUES(?, ?, ?)
    """;

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maintenanceId);
            ps.setString(2, imagePath);
            ps.setString(3, imageType);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<MaintenanceImage> getByMaintenanceIdAndType(int maintenanceId, String imageType) {
        List<MaintenanceImage> list = new ArrayList<>();

        String sql = """
        SELECT *
        FROM maintenance_images
        WHERE maintenance_id = ? AND image_type = ?
        ORDER BY id DESC
    """;

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maintenanceId);
            ps.setString(2, imageType);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                MaintenanceImage img = new MaintenanceImage();
                img.setId(rs.getInt("id"));
                img.setMaintenanceId(rs.getInt("maintenance_id"));
                img.setImagePath(rs.getString("image_path"));
                img.setImageType(rs.getString("image_type"));
                img.setUploadedAt(rs.getTimestamp("uploaded_at"));
                list.add(img);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<MaintenanceImage> getByMaintenanceId(int maintenanceId) {
        List<MaintenanceImage> list = new ArrayList<>();

        String sql = """
        SELECT id, maintenance_id, image_path, image_type, uploaded_at
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
                img.setImageType(rs.getString("image_type"));
                img.setUploadedAt(rs.getTimestamp("uploaded_at"));
                list.add(img);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public boolean hasImageByType(int maintenanceId, String imageType) {
        String sql = """
        SELECT 1
        FROM maintenance_images
        WHERE maintenance_id = ? AND image_type = ?
        LIMIT 1
    """;

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, maintenanceId);
            ps.setString(2, imageType);

            ResultSet rs = ps.executeQuery();
            return rs.next();

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
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