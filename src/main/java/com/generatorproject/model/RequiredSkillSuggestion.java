package com.generatorproject.model;

public class RequiredSkillSuggestion {
    private final String skillCode;
    private final String skillName;
    private final String importanceLevel;
    private final String reason;

    public RequiredSkillSuggestion(String skillCode, String skillName, String importanceLevel, String reason) {
        this.skillCode = skillCode;
        this.skillName = skillName;
        this.importanceLevel = importanceLevel;
        this.reason = reason;
    }

    public String getSkillCode() {
        return skillCode;
    }

    public String getSkillName() {
        return skillName;
    }

    public String getImportanceLevel() {
        return importanceLevel;
    }

    public String getReason() {
        return reason;
    }
}
