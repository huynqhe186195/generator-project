package com.generatorproject.model;

public class TechnicianSuggestion {
    private final int technicianId;
    private final String technicianName;
    private final int matchScore;
    private final boolean unavailable;
    private final boolean outOfWorkingHours;
    private final boolean overloaded;
    private final boolean missingRequiredSkill;
    private final String summary;

    public TechnicianSuggestion(int technicianId,
                                String technicianName,
                                int matchScore,
                                boolean unavailable,
                                boolean outOfWorkingHours,
                                boolean overloaded,
                                boolean missingRequiredSkill,
                                String summary) {
        this.technicianId = technicianId;
        this.technicianName = technicianName;
        this.matchScore = matchScore;
        this.unavailable = unavailable;
        this.outOfWorkingHours = outOfWorkingHours;
        this.overloaded = overloaded;
        this.missingRequiredSkill = missingRequiredSkill;
        this.summary = summary;
    }

    public int getTechnicianId() {
        return technicianId;
    }

    public String getTechnicianName() {
        return technicianName;
    }

    public int getMatchScore() {
        return matchScore;
    }

    public boolean isUnavailable() {
        return unavailable;
    }

    public boolean isOutOfWorkingHours() {
        return outOfWorkingHours;
    }

    public boolean isOverloaded() {
        return overloaded;
    }

    public boolean isMissingRequiredSkill() {
        return missingRequiredSkill;
    }

    public String getSummary() {
        return summary;
    }
}
