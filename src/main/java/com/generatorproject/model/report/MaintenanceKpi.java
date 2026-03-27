package com.generatorproject.model.report;

public class MaintenanceKpi {
    private int planned;
    private int done;
    private int overdue;
    private int cancelledOrRescheduled;

    private double onTimeRate; // %
    private String onTimeRateNote; // giải thích mẫu số

    public int getPlanned() { return planned; }
    public void setPlanned(int planned) { this.planned = planned; }

    public int getDone() { return done; }
    public void setDone(int done) { this.done = done; }

    public int getOverdue() { return overdue; }
    public void setOverdue(int overdue) { this.overdue = overdue; }

    public int getCancelledOrRescheduled() { return cancelledOrRescheduled; }
    public void setCancelledOrRescheduled(int cancelledOrRescheduled) { this.cancelledOrRescheduled = cancelledOrRescheduled; }

    public double getOnTimeRate() { return onTimeRate; }
    public void setOnTimeRate(double onTimeRate) { this.onTimeRate = onTimeRate; }

    public String getOnTimeRateNote() { return onTimeRateNote; }
    public void setOnTimeRateNote(String onTimeRateNote) { this.onTimeRateNote = onTimeRateNote; }
}