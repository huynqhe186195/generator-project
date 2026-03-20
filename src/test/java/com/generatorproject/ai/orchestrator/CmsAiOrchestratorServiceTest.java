package com.generatorproject.ai.orchestrator;

import org.junit.Assert;
import org.junit.Test;

public class CmsAiOrchestratorServiceTest {
    private final CmsAiOrchestratorService service = new CmsAiOrchestratorService();

    @Test
    public void returnsGreetingResponseWithoutCallingDatabase() {
        ChatResponse response = service.handle(new ChatRequest(5L, 5, "xin chào", "/app"));

        Assert.assertTrue(response.isSuccess());
        Assert.assertTrue(response.getReply().contains("Xin chào"));
        Assert.assertEquals("NONE", response.getActionType());
        Assert.assertEquals(1, response.getSkillsCalled().size());
        Assert.assertEquals("greeting_handler", response.getSkillsCalled().get(0));
    }

    @Test
    public void returnsFallbackForUnknownScope() {
        ChatResponse response = service.handle(new ChatRequest(5L, 5, "Bạn có thể kể chuyện cười không", "/app"));

        Assert.assertTrue(response.isSuccess());
        Assert.assertTrue(response.getReply().contains("MVP hỗ trợ 4 nhóm việc"));
        Assert.assertEquals("fallback_handler", response.getSkillsCalled().get(0));
    }
}
