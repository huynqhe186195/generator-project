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
                    .productId(rs.getInt("product_id"))
                    .startDate(rs.getDate("start_date"))
                    .endDate(rs.getDate("end_date"))
                    .status(rs.getString("status"))
                    .managerId(rs.getInt("manager_id"))
                    .createdAt(rs.getTimestamp("created_at"));

            try {
                builder.customerName(rs.getString("full_name"));
            } catch (SQLException e) { }

            try {
                builder.productSerial(rs.getString("serial_number"));

                String mName = rs.getString("model_name");
                builder.productModelName(mName != null ? mName : "");

                if (rs.getObject("manufacture_year") != null) {
                    builder.productManufactureYear(rs.getInt("manufacture_year"));
                }
            } catch (SQLException e) {
            }

            return builder.build();

        } catch (SQLException e) {
            return null;
        }
    }
}