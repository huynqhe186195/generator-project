package com.generatorproject.mapper;

import com.generatorproject.model.ContractAiExtractedItem;

import java.sql.ResultSet;

public class ContractAiExtractedItemMapper implements RowMapper<ContractAiExtractedItem> {
    @Override
    public ContractAiExtractedItem mapRow(ResultSet rs) {
        try {
            ContractAiExtractedItem item = new ContractAiExtractedItem();
            item.setId(rs.getLong("id"));
            item.setContractId(rs.getLong("contract_id"));
            item.setSourceFilePath(rs.getString("source_file_path"));
            item.setRawModelName(rs.getString("raw_model_name"));
            item.setRawBrand(rs.getString("raw_brand"));
            item.setRawPower(rs.getString("raw_power"));
            item.setQuantity(rs.getInt("quantity"));
            item.setRawSerialNumber(rs.getString("raw_serial_number"));
            item.setManufactureYear((Integer) rs.getObject("manufacture_year"));
            item.setCurrentLocation(rs.getString("current_location"));
            item.setMatchedModelId((Long) rs.getObject("matched_model_id"));
            item.setMatchedModelName(rs.getString("matched_model_name"));
            item.setConfidenceScore((Double) rs.getObject("confidence_score"));
            item.setReviewStatus(rs.getString("review_status"));
            item.setUserEdited(rs.getBoolean("is_user_edited"));
            return item;
        } catch (Exception e) {
            return null;
        }
    }
}
