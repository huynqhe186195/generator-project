package com.generatorproject.ai.orchestrator;

import com.generatorproject.ai.response.ChatAction;
import com.generatorproject.ai.response.ChatCitation;
import com.generatorproject.ai.response.ChatSourceUsage;
import com.generatorproject.model.ai.DeviceSearchResultDto;

import java.util.ArrayList;
import java.util.List;

public class ChatResponse {
    private boolean success = true;
    private String reply;
    private String actionType = "NONE";
    private String redirectUrl;
    private List<DeviceSearchResultDto> results = new ArrayList<>();
    private List<ChatCitation> citations = new ArrayList<>();
    private List<ChatSourceUsage> sourcesUsed = new ArrayList<>();
    private List<String> skillsCalled = new ArrayList<>();
    private List<ChatAction> actions = new ArrayList<>();

    public boolean isSuccess() { return success; }
    public void setSuccess(boolean success) { this.success = success; }
    public String getReply() { return reply; }
    public void setReply(String reply) { this.reply = reply; }
    public String getActionType() { return actionType; }
    public void setActionType(String actionType) { this.actionType = actionType; }
    public String getRedirectUrl() { return redirectUrl; }
    public void setRedirectUrl(String redirectUrl) { this.redirectUrl = redirectUrl; }
    public List<DeviceSearchResultDto> getResults() { return results; }
    public void setResults(List<DeviceSearchResultDto> results) { this.results = results == null ? new ArrayList<>() : results; }
    public List<ChatCitation> getCitations() { return citations; }
    public void setCitations(List<ChatCitation> citations) { this.citations = citations == null ? new ArrayList<>() : citations; }
    public List<ChatSourceUsage> getSourcesUsed() { return sourcesUsed; }
    public void setSourcesUsed(List<ChatSourceUsage> sourcesUsed) { this.sourcesUsed = sourcesUsed == null ? new ArrayList<>() : sourcesUsed; }
    public List<String> getSkillsCalled() { return skillsCalled; }
    public void setSkillsCalled(List<String> skillsCalled) { this.skillsCalled = skillsCalled == null ? new ArrayList<>() : skillsCalled; }
    public List<ChatAction> getActions() { return actions; }
    public void setActions(List<ChatAction> actions) { this.actions = actions == null ? new ArrayList<>() : actions; }
}
