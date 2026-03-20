package com.generatorproject.ai.skill;

import com.generatorproject.ai.intent.ParsedIntent;
import com.generatorproject.ai.orchestrator.ChatRequest;

public class SkillContext {
    private final ChatRequest request;
    private final ParsedIntent parsedIntent;

    public SkillContext(ChatRequest request, ParsedIntent parsedIntent) {
        this.request = request;
        this.parsedIntent = parsedIntent;
    }

    public ChatRequest getRequest() { return request; }
    public ParsedIntent getParsedIntent() { return parsedIntent; }
}
