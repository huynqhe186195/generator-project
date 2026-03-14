package com.generatorproject.model;

import java.util.List;

public class ExtractDeviceResponse {
    private String chatMessage;
    private List<DeviceItemDto> items;
    private List<String> warnings;

    public String getChatMessage() { return chatMessage; }
    public void setChatMessage(String chatMessage) { this.chatMessage = chatMessage; }
    public List<DeviceItemDto> getItems() { return items; }
    public void setItems(List<DeviceItemDto> items) { this.items = items; }
    public List<String> getWarnings() { return warnings; }
    public void setWarnings(List<String> warnings) { this.warnings = warnings; }
}
