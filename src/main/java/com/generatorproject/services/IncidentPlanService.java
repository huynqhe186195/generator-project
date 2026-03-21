package com.generatorproject.services;

import com.generatorproject.dao.IncidentPlanDAO;
import com.generatorproject.model.IncidentPlan;

public class IncidentPlanService implements IIncidentPlanService {
    private final IncidentPlanDAO incidentPlanDAO;

    public IncidentPlanService() {
        this.incidentPlanDAO = new IncidentPlanDAO();
    }

    @Override
    public Long createDraft(IncidentPlan plan) {
        int nextVersion = incidentPlanDAO.getNextVersion(plan.getIncidentId());
        IncidentPlan previous = incidentPlanDAO.findLatestByIncidentId(plan.getIncidentId());
        incidentPlanDAO.markNonCurrentByIncidentId(plan.getIncidentId());
        plan.setPlanVersion(nextVersion);
        plan.setCurrent(true);
        if (previous != null) {
            plan.setPreviousPlanId(previous.getId());
        }
        return incidentPlanDAO.insert(plan);
    }

    @Override
    public IncidentPlan findById(Long id) {
        return incidentPlanDAO.findById(id);
    }

    @Override
    public IncidentPlan findLatestByIncidentId(int incidentId) {
        return incidentPlanDAO.findLatestByIncidentId(incidentId);
    }

    @Override
    public void approve(Long id, int approvedBy) {
        incidentPlanDAO.updateApproval(id, "APPROVED", approvedBy, null);
    }

    @Override
    public void reject(Long id, String reason) {
        incidentPlanDAO.updateApproval(id, "REJECTED", null, reason);
    }
}
