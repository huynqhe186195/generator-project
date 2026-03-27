package com.generatorproject.model;

import java.util.List;

public class IncidentPlanRecommendationView {
    private final String recommendationCode;
    private final String title;
    private final String recommendedWorkType;
    private final String recommendedPriority;
    private final int recommendedDurationMinutes;
    private final int recommendedTechnicianCount;
    private final boolean requiresPartsPreparation;
    private final String recommendedServiceLocation;
    private final String recommendedPartsNote;
    private final String reasonSummary;
    private final int confidenceScore;
    private final List<RequiredSkillSuggestion> requiredSkills;
    private final List<TechnicianSuggestion> technicianSuggestions;

    public IncidentPlanRecommendationView(String recommendationCode,
                                          String title,
                                          String recommendedWorkType,
                                          String recommendedPriority,
                                          int recommendedDurationMinutes,
                                          int recommendedTechnicianCount,
                                          boolean requiresPartsPreparation,
                                          String recommendedServiceLocation,
                                          String recommendedPartsNote,
                                          String reasonSummary,
                                          int confidenceScore,
                                          List<RequiredSkillSuggestion> requiredSkills,
                                          List<TechnicianSuggestion> technicianSuggestions) {
        this.recommendationCode = recommendationCode;
        this.title = title;
        this.recommendedWorkType = recommendedWorkType;
        this.recommendedPriority = recommendedPriority;
        this.recommendedDurationMinutes = recommendedDurationMinutes;
        this.recommendedTechnicianCount = recommendedTechnicianCount;
        this.requiresPartsPreparation = requiresPartsPreparation;
        this.recommendedServiceLocation = recommendedServiceLocation;
        this.recommendedPartsNote = recommendedPartsNote;
        this.reasonSummary = reasonSummary;
        this.confidenceScore = confidenceScore;
        this.requiredSkills = requiredSkills;
        this.technicianSuggestions = technicianSuggestions;
    }

    public String getRecommendationCode() {
        return recommendationCode;
    }

    public String getTitle() {
        return title;
    }

    public String getRecommendedWorkType() {
        return recommendedWorkType;
    }

    public String getRecommendedPriority() {
        return recommendedPriority;
    }

    public int getRecommendedDurationMinutes() {
        return recommendedDurationMinutes;
    }

    public int getRecommendedTechnicianCount() {
        return recommendedTechnicianCount;
    }

    public boolean isRequiresPartsPreparation() {
        return requiresPartsPreparation;
    }

    public String getRecommendedServiceLocation() {
        return recommendedServiceLocation;
    }

    public String getRecommendedPartsNote() {
        return recommendedPartsNote;
    }

    public String getReasonSummary() {
        return reasonSummary;
    }

    public int getConfidenceScore() {
        return confidenceScore;
    }

    public List<RequiredSkillSuggestion> getRequiredSkills() {
        return requiredSkills;
    }

    public List<TechnicianSuggestion> getTechnicianSuggestions() {
        return technicianSuggestions;
    }
}
