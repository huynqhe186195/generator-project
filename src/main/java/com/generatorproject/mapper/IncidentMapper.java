package com.generatorproject.mapper;

import com.generatorproject.model.Incident;
import com.generatorproject.model.Users;

import java.sql.ResultSet;
import java.sql.SQLException;

public class IncidentMapper implements RowMapper<Incident> {

    @Override
    public Incident mapRow(ResultSet rs) {
        try {
            Incident.Builder builder = new Incident.Builder();

            // 1. Map các trường CỐT LÕI (Có trong bảng incidents)
            builder.setId(rs.getInt("id"))
                    .setProductId(rs.getInt("product_id"))
                    .setReportedBy(rs.getInt("reported_by"))
                    .setTitle(rs.getString("title"))
                    .setDescription(rs.getString("description"))
                    .setImageEvidence(rs.getString("image_evidence"))
                    .setPriority(rs.getString("priority"))
                    .setStatus(rs.getString("status"))
                    .setTechnicianId(rs.getInt("technician_id")) // Trả về 0 nếu null
                    .setCreatedAt(rs.getTimestamp("created_at"))
                    .setResolvedAt(rs.getTimestamp("resolved_at"))

                    // --- CÁC TRƯỜNG MỚI BỔ SUNG ---
                    .setInputContractNumber(rs.getString("input_contract_number"))
                    .setInputSerialNumber(rs.getString("input_serial_number"))
                    .setContractId(rs.getInt("contract_id")); // Trả về 0 nếu null

            // 2. Map các trường PHỤ (Do JOIN bảng khác mới có)
            // Dùng try-catch riêng lẻ để nếu câu Query không JOIN cũng không bị lỗi chết chương trình
            try { builder.setProductName(rs.getString("product_name")); } catch (SQLException e) {}
            try { builder.setReporterName(rs.getString("reporter_name")); } catch (SQLException e) {}
            try { builder.setTechnicianName(rs.getString("technician_name")); } catch (SQLException e) {}

            return builder.build();

        } catch (SQLException e) {
            e.printStackTrace(); // In lỗi ra console để dễ debug nếu sai tên cột
            return null;
        }
    }
}