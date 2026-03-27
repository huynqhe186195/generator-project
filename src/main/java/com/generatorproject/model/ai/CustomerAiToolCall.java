package com.generatorproject.model.ai;

import lombok.Getter;
import lombok.Setter;

import java.util.Collections;
import java.util.Map;

@Setter
public class CustomerAiToolCall {
    @Getter
    private String tool;
    private Map<String, String> args;

    public CustomerAiToolCall() {
        this.args = Collections.emptyMap();
    }

    public CustomerAiToolCall(String tool, Map<String, String> args) {
        this.tool = tool;
        this.args = args == null ? Collections.emptyMap() : args;
    }

    public static CustomerAiToolCall none(String reply) {
        return new CustomerAiToolCall("none", Collections.singletonMap("reply", reply));
    }

    public Map<String, String> getArgs() {
        return args == null ? Collections.emptyMap() : args;
    }

    public String getArg(String key) {
        return getArgs().get(key);
    }
}