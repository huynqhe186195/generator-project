package com.generatorproject.model.ai;

import java.util.ArrayList;
import java.util.List;

public class CustomerAiResponse {
    public static final String ACTION_NONE = "NONE";
    public static final String ACTION_REDIRECT = "REDIRECT";
    public static final String ACTION_SHOW_RESULTS = "SHOW_RESULTS";

    private boolean success;
    private String reply;
    private String actionType;
    private String redirectUrl;
    private List<DeviceSearchResultDto> results;

    public CustomerAiResponse() {
        this.success = true;
        this.actionType = ACTION_NONE;
        this.results = new ArrayList<>();
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public String getReply() {
        return reply;
    }

    public void setReply(String reply) {
        this.reply = reply;
    }

    public String getActionType() {
        return actionType;
    }

    public void setActionType(String actionType) {
        this.actionType = actionType;
    }

    public String getRedirectUrl() {
        return redirectUrl;
    }

    public void setRedirectUrl(String redirectUrl) {
        this.redirectUrl = redirectUrl;
    }

    public List<DeviceSearchResultDto> getResults() {
        return results;
    }

    public void setResults(List<DeviceSearchResultDto> results) {
        this.results = results == null ? new ArrayList<DeviceSearchResultDto>() : results;
    }
}
