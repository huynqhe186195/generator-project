package com.generatorproject.model.ai;

import java.util.Collections;
import java.util.Map;

public class CustomerAiToolCall {
    private String tool;
    private Map<String, String> args;

    public CustomerAiToolCall() {
        this.args = Collections.emptyMap();
    }

    public CustomerAiToolCall(String tool, Map<String, String> args) {
        this.tool = tool;
        this.args = args == null ? Collections.<String, String>emptyMap() : args;
    }

    public static CustomerAiToolCall none(String reply) {
        return new CustomerAiToolCall("none", Collections.singletonMap("reply", reply));
    }

    public String getTool() {
        return tool;
    }

    public void setTool(String tool) {
        this.tool = tool;
    }

    public Map<String, String> getArgs() {
        return args == null ? Collections.<String, String>emptyMap() : args;
    }

    public void setArgs(Map<String, String> args) {
        this.args = args;
    }

    public String getArg(String key) {
        return getArgs().get(key);
    }
}
