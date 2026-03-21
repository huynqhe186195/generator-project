package com.generatorproject.services;

import com.generatorproject.model.Incident;

import java.sql.Date;
import java.util.List;

public interface IIncidentServices {
    Long createIncident(Incident incident);

    Incident findById(long id);

    void updateStatus(long id, String status);

    List<Incident> getAllIncidents();

    int countIncidentByFilter(Date fromDate, Date toDate, String status);

    List<Incident> getIncidentByFilter(Date fromDate, Date toDate, String status, int page, int pageSize);
}
