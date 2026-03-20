package com.generatorproject.ai.skill;

import com.generatorproject.ai.response.ChatAction;
import com.generatorproject.ai.response.ChatCitation;
import com.generatorproject.ai.response.ChatSourceUsage;
import com.generatorproject.model.ai.DeviceSearchResultDto;

import java.util.ArrayList;
import java.util.List;

public class SkillResult {
    private String reply;
    private String actionType = "NONE";
    private String redirectUrl;
    private List<DeviceSearchResultDto> results = new ArrayList<>();
    private List<ChatCitation> citations = new ArrayList<>();
    private List<ChatSourceUsage> sourcesUsed = new ArrayList<>();
    private List<ChatAction> actions = new ArrayList<>();

    public String getReply() { return reply; }
    public SkillResult setReply(String reply) { this.reply = reply; return this; }
    public String getActionType() { return actionType; }
    public SkillResult setActionType(String actionType) { this.actionType = actionType; return this; }
    public String getRedirectUrl() { return redirectUrl; }
    public SkillResult setRedirectUrl(String redirectUrl) { this.redirectUrl = redirectUrl; return this; }
    public List<DeviceSearchResultDto> getResults() { return results; }
    public SkillResult setResults(List<DeviceSearchResultDto> results) { this.results = results == null ? new ArrayList<>() : results; return this; }
    public List<ChatCitation> getCitations() { return citations; }
    public SkillResult setCitations(List<ChatCitation> citations) { this.citations = citations == null ? new ArrayList<>() : citations; return this; }
    public List<ChatSourceUsage> getSourcesUsed() { return sourcesUsed; }
    public SkillResult setSourcesUsed(List<ChatSourceUsage> sourcesUsed) { this.sourcesUsed = sourcesUsed == null ? new ArrayList<>() : sourcesUsed; return this; }
    public List<ChatAction> getActions() { return actions; }
    public SkillResult setActions(List<ChatAction> actions) { this.actions = actions == null ? new ArrayList<>() : actions; return this; }
}
