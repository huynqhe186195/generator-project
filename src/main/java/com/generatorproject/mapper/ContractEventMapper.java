package com.generatorproject.mapper;

import com.generatorproject.model.ContractEvent;

import java.sql.ResultSet;
import java.sql.SQLException;

public class ContractEventMapper implements RowMapper<ContractEvent> {
    @Override
    public ContractEvent mapRow(ResultSet rs) {
        try {
            ContractEvent event = new ContractEvent();
            event.setId(rs.getLong("id"));
            event.setContractId(rs.getLong("contract_id"));
            event.setEventType(rs.getString("event_type"));
            event.setReasonCode(rs.getString("reason_code"));
            event.setTerminatedReason(rs.getString("terminated_reason"));
            event.setDecisionDoc(rs.getString("decision_doc"));
            event.setNote(rs.getString("note"));
            if (rs.getObject("actor_id") != null) {
                event.setActorId(rs.getLong("actor_id"));
            }
            event.setOldStatus(rs.getString("old_status"));
            event.setNewStatus(rs.getString("new_status"));
            event.setMeta(rs.getString("meta"));
            event.setCreatedAt(rs.getTimestamp("created_at"));
            return event;
        } catch (SQLException e) {
            return null;
        }
    }
}
