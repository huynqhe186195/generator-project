package com.generatorproject.mapper;

import com.generatorproject.model.Users;

import java.sql.ResultSet;
import java.sql.SQLException;

public class UserMapper implements RowMapper<Users>{

    @Override
    public Users mapRow(ResultSet rs) {
        try {
            return new Users.Builder()
                    .setId(rs.getInt("id"))
                    .setFullName(rs.getString("full_name"))
                    .setEmail(rs.getString("email"))
                    .setPassword(rs.getString("password"))
                    .setPhone(rs.getString("phone"))
                    .setRoleId(rs.getInt("role_id"))
                    .setStatus(rs.getInt("status"))
                    .setAvatarUrl(rs.getString("avatar_url"))
                    .setCreatedAt(rs.getTimestamp("created_at")) // Nếu có
                    .build();
        } catch (SQLException e) {
            return null;
        }
    }
}
