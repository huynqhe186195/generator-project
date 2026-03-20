package com.generatorproject.ai.orchestrator;

import com.generatorproject.ai.intent.ChatIntent;
import com.generatorproject.ai.intent.IntentClassifierService;
import com.generatorproject.ai.intent.ParsedIntent;
import com.generatorproject.ai.skill.ChatSkill;
import com.generatorproject.ai.skill.MaintenanceAdvisorSkill;
import com.generatorproject.ai.skill.OwnedDeviceLookupSkill;
import com.generatorproject.ai.skill.PublicModelLookupSkill;
import com.generatorproject.ai.skill.SkillContext;
import com.generatorproject.ai.skill.SkillResult;
import com.generatorproject.ai.skill.TechnicalDocumentSupportSkill;

import java.util.LinkedHashMap;
import java.util.Map;

public class CmsAiOrchestratorService {
    private final IntentClassifierService intentClassifierService = new IntentClassifierService();
    private final Map<ChatIntent, ChatSkill> skillRegistry = new LinkedHashMap<>();

    public CmsAiOrchestratorService() {
        skillRegistry.put(ChatIntent.OWNED_DEVICE_LOOKUP, new OwnedDeviceLookupSkill());
        skillRegistry.put(ChatIntent.PUBLIC_MODEL_LOOKUP, new PublicModelLookupSkill());
        skillRegistry.put(ChatIntent.MAINTENANCE_SUPPORT, new MaintenanceAdvisorSkill());
        skillRegistry.put(ChatIntent.TECHNICAL_DOCUMENT_SUPPORT, new TechnicalDocumentSupportSkill());
    }

    public ChatResponse handle(ChatRequest request) {
        ParsedIntent parsedIntent = intentClassifierService.classify(request == null ? null : request.getMessage());
        if (parsedIntent.getIntent() == ChatIntent.GREETING) {
            ChatResponse response = new ChatResponse();
            response.setReply("Xin chào! Tôi có thể hỗ trợ tra thiết bị sở hữu, model public, lịch sử bảo trì gần nhất và hướng dẫn kỹ thuật bám theo dữ liệu/manual hiện có.");
            response.setSkillsCalled(java.util.List.of("greeting_handler"));
            return response;
        }

        ChatSkill skill = skillRegistry.get(parsedIntent.getIntent());
        if (skill == null) {
            ChatResponse response = new ChatResponse();
            response.setReply("Hiện MVP hỗ trợ 4 nhóm việc: tra thiết bị sở hữu, tra model public, xem bảo trì gần nhất và hỏi kỹ thuật dựa trên thông tin/manual của model.");
            response.setSkillsCalled(java.util.List.of("fallback_handler"));
            return response;
        }

        SkillResult skillResult = skill.execute(new SkillContext(request, parsedIntent));
        ChatResponse response = new ChatResponse();
        response.setReply(skillResult.getReply());
        response.setActionType(skillResult.getActionType());
        response.setRedirectUrl(skillResult.getRedirectUrl());
        response.setResults(skillResult.getResults());
        response.setCitations(skillResult.getCitations());
        response.setSourcesUsed(skillResult.getSourcesUsed());
        response.setActions(skillResult.getActions());
        response.setSkillsCalled(java.util.List.of(skill.getCode()));
        return response;
    }
}
