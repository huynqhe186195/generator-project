package com.generatorproject.ai.skill;

public interface ChatSkill {
    String getCode();
    SkillResult execute(SkillContext context);
}
