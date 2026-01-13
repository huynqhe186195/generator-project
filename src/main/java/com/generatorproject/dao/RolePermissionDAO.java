package com.generatorproject.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;

public class RolePermissionDAO extends DbContext {

    public void updatePermissions(int roleId, String[] permissionIds) {
        String deleteSql = "DELETE FROM role_permissions WHERE role_id = ?";
        String insertSql = "INSERT INTO role_permissions (role_id, permission_id) VALUES (?, ?)";

        Connection conn = null;
        PreparedStatement del = null;
        PreparedStatement ins = null;

        try {
            conn = getConnection();
            conn.setAutoCommit(false);

            del = conn.prepareStatement(deleteSql);
            del.setInt(1, roleId);
            del.executeUpdate();

            if (permissionIds != null && permissionIds.length > 0) {
                ins = conn.prepareStatement(insertSql);
                for (String pid : permissionIds) {
                    ins.setInt(1, roleId);
                    ins.setInt(2, Integer.parseInt(pid));
                    ins.addBatch();
                }
                ins.executeBatch();
            }

            conn.commit();

        } catch (Exception e) {
            try {
                if (conn != null) conn.rollback();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();

        } finally {
            try {
                if (del != null) del.close();
                if (ins != null) ins.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
