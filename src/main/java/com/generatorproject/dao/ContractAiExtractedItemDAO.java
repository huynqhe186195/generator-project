package com.generatorproject.dao;

import com.generatorproject.mapper.ContractAiExtractedItemMapper;
import com.generatorproject.model.ContractAiExtractedItem;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;

public class ContractAiExtractedItemDAO extends GenericDAO<ContractAiExtractedItem> {

    public void deleteByContractId(Connection conn, Long contractId) throws Exception {
        try (PreparedStatement ps = conn.prepareStatement("DELETE FROM contract_ai_extracted_items WHERE contract_id = ?")) {
            ps.setLong(1, contractId);
            ps.executeUpdate();
        }
    }

    public void insert(Connection conn, ContractAiExtractedItem item) throws Exception {
        String sqlWithStatus = "INSERT INTO contract_ai_extracted_items (contract_id, source_file_path, raw_model_name, raw_brand, raw_power, quantity, raw_serial_number, manufacture_year, current_location, matched_model_id, confidence_score, review_status, is_user_edited, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW())";
        String sqlWithDefaultStatus = "INSERT INTO contract_ai_extracted_items (contract_id, source_file_path, raw_model_name, raw_brand, raw_power, quantity, raw_serial_number, manufacture_year, current_location, matched_model_id, confidence_score, is_user_edited, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW())";

        try {
            try (PreparedStatement ps = conn.prepareStatement(sqlWithStatus)) {
                bindInsertFields(ps, item);
                ps.setString(12, item.getReviewStatus() == null ? "EXTRACTED" : item.getReviewStatus());
                ps.setBoolean(13, item.isUserEdited());
                ps.executeUpdate();
            }
        } catch (SQLException ex) {
            if (!isReviewStatusDataTruncation(ex)) {
                throw ex;
            }
            try (PreparedStatement ps = conn.prepareStatement(sqlWithDefaultStatus)) {
                bindInsertFields(ps, item);
                ps.setBoolean(12, item.isUserEdited());
                ps.executeUpdate();
            }
        }
    }

    public List<ContractAiExtractedItem> findByContractId(Long contractId) {
        String sql = "SELECT i.*, pm.name AS matched_model_name FROM contract_ai_extracted_items i LEFT JOIN product_models pm ON i.matched_model_id = pm.id WHERE i.contract_id = ? ORDER BY i.id ASC";
        return query(sql, new ContractAiExtractedItemMapper(), contractId);
    }

    public String findLatestSourceFilePath(Long contractId) {
        String sql = "SELECT source_file_path FROM contract_ai_extracted_items WHERE contract_id = ? AND source_file_path IS NOT NULL ORDER BY id DESC LIMIT 1";
        List<String> rows = queryString(sql, contractId);
        return rows == null || rows.isEmpty() ? null : rows.get(0);
    }

    public void updateReviewData(Long id, Long matchedModelId, Integer quantity, String serial, Integer year, String location) {
        String sql = "UPDATE contract_ai_extracted_items SET matched_model_id = ?, quantity = ?, raw_serial_number = ?, manufacture_year = ?, current_location = ?, review_status = 'APPLIED', is_user_edited = 1, updated_at = NOW() WHERE id = ?";
        try {
            update(sql, matchedModelId, quantity, serial, year, location, id);
        } catch (RuntimeException ex) {
            if (!isReviewStatusDataTruncation(ex)) {
                throw ex;
            }
            String fallbackSql = "UPDATE contract_ai_extracted_items SET matched_model_id = ?, quantity = ?, raw_serial_number = ?, manufacture_year = ?, current_location = ?, is_user_edited = 1, updated_at = NOW() WHERE id = ?";
            update(fallbackSql, matchedModelId, quantity, serial, year, location, id);
        }
    }

    private void bindInsertFields(PreparedStatement ps, ContractAiExtractedItem item) throws SQLException {
        ps.setLong(1, item.getContractId());
        ps.setString(2, item.getSourceFilePath());
        ps.setString(3, item.getRawModelName());
        ps.setString(4, item.getRawBrand());
        ps.setString(5, item.getRawPower());
        ps.setInt(6, item.getQuantity() == null ? 1 : item.getQuantity());
        ps.setString(7, item.getRawSerialNumber());
        ps.setObject(8, item.getManufactureYear());
        ps.setString(9, item.getCurrentLocation());
        ps.setObject(10, item.getMatchedModelId());
        ps.setObject(11, item.getConfidenceScore());
    }

    private boolean isReviewStatusDataTruncation(Throwable ex) {
        Throwable cur = ex;
        while (cur != null) {
            String msg = cur.getMessage();
            if (msg != null) {
                String lower = msg.toLowerCase();
                if (lower.contains("review_status") &&
                        (lower.contains("data truncated") || lower.contains("value too long") || lower.contains("out of range"))) {
                    return true;
                }
            }
            if (cur instanceof SQLException) {
                String state = ((SQLException) cur).getSQLState();
                if ("01000".equalsIgnoreCase(state) || "22001".equalsIgnoreCase(state) || "22003".equalsIgnoreCase(state)) {
                    return true;
                }
            }
            cur = cur.getCause();
        }
        return false;
    }

}
