package com.generatorproject.dao;

import com.generatorproject.mapper.ContractEventMapper;
import com.generatorproject.model.ContractEvent;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.List;

public class ContractEventDAO extends GenericDAO<ContractEvent> {

    public void insertEvent(Long contractId,
            String eventType,
            String reasonCode,
            String terminatedReason,
            String decisionDoc,
            String note,
            Long actorId,
            String oldStatus,
            String newStatus,
            String meta) {
        String sql = "INSERT INTO contract_events (contract_id, event_type, reason_code, terminated_reason, decision_doc, note, actor_id, old_status, new_status, meta, created_at) "
                +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())";
        insert(sql, contractId, eventType, reasonCode, terminatedReason, decisionDoc, note, actorId, oldStatus,
                newStatus, meta);
    }

    public void insertEvent(Connection conn,
            Long contractId,
            String eventType,
            String reasonCode,
            String terminatedReason,
            String decisionDoc,
            String note,
            Long actorId,
            String oldStatus,
            String newStatus,
            String meta) throws Exception {
        String sql = "INSERT INTO contract_events (contract_id, event_type, reason_code, terminated_reason, decision_doc, note, actor_id, old_status, new_status, meta, created_at) "
                +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, contractId);
            ps.setString(2, eventType);
            ps.setString(3, reasonCode);
            ps.setString(4, terminatedReason);
            ps.setString(5, decisionDoc);
            ps.setString(6, note);
            if (actorId == null) {
                ps.setObject(7, null);
            } else {
                ps.setLong(7, actorId);
            }
            ps.setString(8, oldStatus);
            ps.setString(9, newStatus);
            ps.setString(10, meta);
            ps.executeUpdate();
        }
    }

    public ContractEvent findLatestTerminatedEvent(Long contractId) {
        String sql = "SELECT * FROM contract_events WHERE contract_id = ? AND event_type = 'TERMINATED' ORDER BY created_at DESC, id DESC LIMIT 1";
        List<ContractEvent> events = query(sql, new ContractEventMapper(), contractId);
        return events == null || events.isEmpty() ? null : events.get(0);
    }

    public List<ContractEvent> findByContractId(Long contractId) {
        String sql = "SELECT * FROM contract_events WHERE contract_id = ? ORDER BY created_at DESC, id DESC";
        return query(sql, new ContractEventMapper(), contractId);
    }
}
