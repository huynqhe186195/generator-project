package com.generatorproject.dao;

public class ContractEventDAO extends GenericDAO<Object> {

    public void insertEvent(Long contractId,
                            String eventType,
                            String reasonCode,
                            String note,
                            Long actorId,
                            String oldStatus,
                            String newStatus,
                            String meta) {
        String sql = "INSERT INTO contract_events (contract_id, event_type, reason_code, note, actor_id, old_status, new_status, meta, created_at) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW())";
        insert(sql, contractId, eventType, reasonCode, note, actorId, oldStatus, newStatus, meta);
    }
}
