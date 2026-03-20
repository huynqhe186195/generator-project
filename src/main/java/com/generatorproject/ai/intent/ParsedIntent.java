package com.generatorproject.ai.intent;

import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.Map;

public class ParsedIntent {
    private final ChatIntent intent;
    private final Map<String, String> entities;
    private final String normalizedMessage;

    public ParsedIntent(ChatIntent intent, Map<String, String> entities, String normalizedMessage) {
        this.intent = intent == null ? ChatIntent.UNKNOWN : intent;
        this.entities = entities == null ? Collections.emptyMap() : Collections.unmodifiableMap(new LinkedHashMap<>(entities));
        this.normalizedMessage = normalizedMessage == null ? "" : normalizedMessage;
    }

    public ChatIntent getIntent() { return intent; }
    public Map<String, String> getEntities() { return entities; }
    public String getEntity(String key) { return entities.get(key); }
    public String getNormalizedMessage() { return normalizedMessage; }
}
