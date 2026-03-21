package com.generatorproject.services;

import com.generatorproject.model.IncidentPlan;

public interface IIncidentPlanService {
    Long createDraft(IncidentPlan plan);
    IncidentPlan findById(Long id);
    IncidentPlan findLatestByIncidentId(int incidentId);
    void approve(Long id, int approvedBy);
    void reject(Long id, String reason);
}
