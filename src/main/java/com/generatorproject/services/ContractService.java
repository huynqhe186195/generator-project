package com.generatorproject.services;

import com.generatorproject.dao.*;
import com.generatorproject.model.Contract;
import com.generatorproject.model.ContractAiExtractedItem;
import com.generatorproject.model.Product;
import com.google.gson.Gson;

import java.sql.Connection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ContractService {
    private final DbContext dbContext = new DbContext();
    private final ContractDAO contractDAO = new ContractDAO();
    private final ContractAiExtractedItemDAO extractedItemDAO = new ContractAiExtractedItemDAO();
    private final ProductDAO productDAO = new ProductDAO();
    private final ProductModelDAO productModelDAO = new ProductModelDAO();
    private final ContractEventDAO contractEventDAO = new ContractEventDAO();

    public Long createDraft(Contract contract) {
        contract.setStatus("PENDING_SERIAL");
        return contractDAO.save(contract);
    }

    public Contract findById(Long id) {
        return contractDAO.findById(id);
    }

    public List<ContractAiExtractedItem> findExtractedItems(Long contractId) {
        return extractedItemDAO.findByContractId(contractId);
    }

    public void finalizeContract(Long contractId, Long actorId) throws Exception {
        Contract contract = contractDAO.findById(contractId);
        if (contract == null) throw new IllegalArgumentException("Không tìm thấy hợp đồng.");
        if (contract.getStartDate() == null || contract.getEndDate() == null || contract.getStartDate().after(contract.getEndDate())) {
            throw new IllegalArgumentException("Ngày hiệu lực và ngày hết hạn không hợp lệ.");
        }

        List<ContractAiExtractedItem> items = extractedItemDAO.findByContractId(contractId);
        if (items == null || items.isEmpty()) throw new IllegalArgumentException("Chưa có danh sách thiết bị để finalize.");

        try (Connection conn = dbContext.getConnection()) {
            conn.setAutoCommit(false);

            for (ContractAiExtractedItem item : items) {
                if (item.getQuantity() == null || item.getQuantity() < 1) {
                    throw new IllegalArgumentException("Quantity phải >= 1.");
                }
                if (item.getMatchedModelId() == null || productModelDAO.findById(item.getMatchedModelId().intValue()) == null) {
                    throw new IllegalArgumentException("Matched model chưa hợp lệ cho dòng: " + item.getRawModelName());
                }
                for (int i = 0; i < item.getQuantity(); i++) {
                    String serial = item.getRawSerialNumber();
                    if (serial != null && !serial.trim().isEmpty() && item.getQuantity() > 1) {
                        serial = serial.trim() + "-" + (i + 1);
                    }
                    if (serial != null && !serial.trim().isEmpty() && productDAO.findBySerial(serial.trim()) != null) {
                        throw new IllegalArgumentException("Serial bị trùng: " + serial);
                    }

                    Product p = new Product();
                    p.setContractId(contractId);
                    p.setCustomerId((long) contract.getCustomerId());
                    p.setModelId(item.getMatchedModelId());
                    p.setSerialNumber(serial == null || serial.trim().isEmpty() ? null : serial.trim());
                    p.setManufactureYear(item.getManufactureYear());
                    p.setCurrentLocation(item.getCurrentLocation());
                    p.setPurchaseDate(contract.getStartDate());
                    p.setStatus("READY");
                    p.setTotalRunningHours(0.0);
                    productDAO.save(conn, p);
                }
            }

            try (java.sql.PreparedStatement ps = conn.prepareStatement("UPDATE contracts SET status = 'ACTIVE' WHERE id = ?")) {
                ps.setLong(1, contractId);
                ps.executeUpdate();
            }

            Map<String, Object> meta = new HashMap<>();
            meta.put("total_items", items.size());
            contractEventDAO.insertEvent(conn, contractId, "FINALIZED", "CONTRACT_FINALIZED", null, null,
                    "Finalize contract from AI reviewed items", actorId, "PENDING_SERIAL", "ACTIVE", new Gson().toJson(meta));

            conn.commit();
        }
    }
}
