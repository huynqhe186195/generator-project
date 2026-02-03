package com.generatorproject.mapper;

import com.generatorproject.model.SystemRequest;

import java.sql.ResultSet;
import java.sql.SQLException;

public class SystemRequestMapper implements RowMapper<SystemRequest> {
    @Override
    public SystemRequest mapRow(ResultSet rs) {
        try {
            SystemRequest request = SystemRequest.builder()
                    .id(rs.getLong("id"))
                    .senderId(rs.getLong("sender_id"))
                    .receiverRole(rs.getString("receiver_role"))
                    .requestType(rs.getString("request_type"))
                    .requestData(rs.getString("request_data"))
                    .status(rs.getString("status"))
                    .responseMessage(rs.getString("response_message"))
                    .build();

            request.setCreatedAt(rs.getTimestamp("created_at"));
            request.setUpdatedAt(rs.getTimestamp("updated_at"));

            return request;
        } catch (SQLException e) {
            return null;
        }
    }
}
