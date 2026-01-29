package com.generatorproject.services;

import com.generatorproject.dao.IncidentDAO;
import com.generatorproject.model.Incident;

import java.sql.Date;
import java.util.List;

public class IncidentServices implements IIncidentServices{
    private final IncidentDAO incidentDAO;
    public IncidentServices(){
        this.incidentDAO = new IncidentDAO();
    }
    @Override
    public List<Incident> getAllIncidents() {
        return incidentDAO.getAllIncident();
    }

    @Override
    public int countIncidentByFilter(Date fromDate, Date toDate, String status) {
        return incidentDAO.countIncidentsByFilter(fromDate,toDate,status);
    }

    @Override
    public List<Incident> getIncidentByFilter(Date fromDate, Date toDate, String status, int page, int pageSize) {
        return incidentDAO.getIncidentByFilter(fromDate,toDate,status,page,pageSize);
    }
}
