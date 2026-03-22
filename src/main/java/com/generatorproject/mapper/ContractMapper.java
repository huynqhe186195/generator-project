package com.generatorproject.mapper;

import com.generatorproject.model.Contract;

import java.sql.ResultSet;
import java.sql.SQLException;

public class ContractMapper implements RowMapper<Contract> {

    @Override
    public Contract mapRow(ResultSet rs) {
        try {
            Contract.Builder builder = Contract.builder()
                    .id(rs.getLong("id"))
                    .contractNumber(rs.getString("contract_number"))
                    .customerId(rs.getInt("customer_id"))
                    .startDate(rs.getDate("start_date"))
                    .endDate(rs.getDate("end_date"))
                    .status(rs.getString("status"))
                    .managerId(rs.getInt("manager_id"))
                    .createdAt(rs.getTimestamp("created_at"))
                    .signedDate(rs.getDate("signed_date"));
            try {
                builder.terminatedAt(rs.getTimestamp("terminated_at"));
            } catch (SQLException ignored) {
            }

            try {
                builder.productId(rs.getInt("product_id"));
            } catch (SQLException ignored) {
            }

            try {
                builder.customerName(rs.getString("full_name"));
            } catch (SQLException ignored) {
            }

            try {
                builder.productSerial(rs.getString("serial_number"));
            } catch (SQLException ignored) {
            }

            try {
                String mName = rs.getString("model_name");
                builder.productModelName(mName != null ? mName : "");
            } catch (SQLException ignored) {
            }

            try {
                if (rs.getObject("manufacture_year") != null) {
                    builder.productManufactureYear(rs.getInt("manufacture_year"));
                }
            } catch (SQLException ignored) {
            }

            return builder.build();

        } catch (SQLException e) {
            return null;
        }
    }

}
