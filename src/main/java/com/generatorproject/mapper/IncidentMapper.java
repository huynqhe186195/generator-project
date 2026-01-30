package com.generatorproject.mapper;

import com.generatorproject.model.Incident;
import com.generatorproject.model.Users;

import java.sql.ResultSet;
import java.sql.SQLException;

public class IncidentMapper implements RowMapper<Incident> {

    @Override
    public Incident mapRow(ResultSet rs) {
        try {
            return new Incident.Builder()
                    .setId(rs.getInt("id"))
                    .setProductId(rs.getInt("product_id"))
                    .setReportedBy(rs.getInt("reported_by"))
                    .setTitle(rs.getString("title"))
                    .setDescription(rs.getString("description"))
                    .setImageEvidence(rs.getString("image_evidence"))
                    .setPriority(rs.getString("priority"))
                    .setStatus(rs.getString("status"))
                    .setTechnicianId(rs.getInt("technician_id")) // Nếu null trong DB -> trả về 0
                    .setCreatedAt(rs.getTimestamp("created_at"))
                    .setResolvedAt(rs.getTimestamp("resolved_at"))
                    .setProductName(rs.getString("product_name"))
                    .setReporterName(rs.getString("reporter_name"))
                    .setTechnicianName(rs.getString("technician_name"))
                    .build();
        } catch (SQLException e) {
            return null;
        }

    }
}
