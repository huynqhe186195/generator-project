package com.generatorproject.model.ai;

import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

@Getter
public class CustomerAiResponse {
    public static final String ACTION_NONE = "NONE";
    public static final String ACTION_REDIRECT = "REDIRECT";
    public static final String ACTION_SHOW_RESULTS = "SHOW_RESULTS";

    @Setter
    private boolean success;
    @Setter
    private String reply;
    @Setter
    private String actionType;
    @Setter
    private String redirectUrl;
    private List<DeviceSearchResultDto> results;

    public CustomerAiResponse() {
        this.success = true;
        this.actionType = ACTION_NONE;
        this.results = new ArrayList<>();
    }

    public void setResults(List<DeviceSearchResultDto> results) {
        this.results = results == null ? new ArrayList<DeviceSearchResultDto>() : results;
    }
}