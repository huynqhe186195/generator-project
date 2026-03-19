package com.generatorproject.services;

import com.generatorproject.config.AppConfig;
import com.generatorproject.model.ai.CustomerAiToolCall;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.util.Collections;
import java.util.Locale;

public class CustomerAiToolRouterService {
    private static final Gson GSON = new Gson();

    public CustomerAiToolCall route(String message) {
        String normalizedMessage = message == null ? "" : message.trim();
        if (normalizedMessage.isEmpty()) {
            return CustomerAiToolCall.none("Bạn hãy nhập câu hỏi, ví dụ: tìm máy theo serial hoặc model.");
        }

        String apiKey = resolveApiKey();
        if (apiKey == null) {
            return fallbackRoute(normalizedMessage);
        }

        try {
            String raw = callGemini(normalizedMessage, apiKey);
            CustomerAiToolCall toolCall = parseToolCall(raw);
            return validateToolCall(toolCall, normalizedMessage);
        } catch (Exception ex) {
            return fallbackRoute(normalizedMessage);
        }
    }

    private String callGemini(String message, String apiKey) throws IOException, InterruptedException {
        JsonObject root = new JsonObject();
        JsonArray contents = new JsonArray();
        contents.add(makeTextContent("user", buildSystemPrompt()));
        contents.add(makeTextContent("user", message));
        root.add("contents", contents);

        JsonObject generationConfig = new JsonObject();
        generationConfig.addProperty("temperature", 0.1);
        root.add("generationConfig", generationConfig);

        String endpoint = "https://generativelanguage.googleapis.com/v1beta/models/"
                + AppConfig.getOrDefault("gemini.model", "gemini-2.5-flash")
                + ":generateContent?key=" + apiKey;

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(endpoint))
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(root.toString(), StandardCharsets.UTF_8))
                .build();

        HttpResponse<String> response = HttpClient.newHttpClient().send(request, HttpResponse.BodyHandlers.ofString());
        if (response.statusCode() < 200 || response.statusCode() >= 300) {
            throw new IllegalStateException("Gemini API failed: HTTP " + response.statusCode());
        }

        JsonObject json = JsonParser.parseString(response.body()).getAsJsonObject();
        JsonArray candidates = json.getAsJsonArray("candidates");
        if (candidates == null || candidates.size() == 0) {
            throw new IllegalStateException("Gemini returned no candidates");
        }

        JsonObject content = candidates.get(0).getAsJsonObject().getAsJsonObject("content");
        JsonArray parts = content.getAsJsonArray("parts");
        if (parts == null || parts.size() == 0) {
            throw new IllegalStateException("Gemini returned no parts");
        }

        return parts.get(0).getAsJsonObject().get("text").getAsString();
    }

    private CustomerAiToolCall parseToolCall(String raw) {
        String cleaned = raw == null ? "" : raw.trim();
        if (cleaned.startsWith("```")) {
            cleaned = cleaned.replaceAll("^```(?:json)?\\s*", "").replaceAll("\\s*```$", "");
        }
        return GSON.fromJson(cleaned, CustomerAiToolCall.class);
    }

    private CustomerAiToolCall validateToolCall(CustomerAiToolCall toolCall, String originalMessage) {
        if (toolCall == null || toolCall.getTool() == null) {
            return fallbackRoute(originalMessage);
        }

        String tool = toolCall.getTool().trim();
        if ("searchDevices".equals(tool)) {
            String keyword = safe(toolCall.getArg("keyword"));
            if (keyword == null) {
                return fallbackRoute(originalMessage);
            }
            return new CustomerAiToolCall("searchDevices", Collections.singletonMap("keyword", keyword));
        }

        if ("none".equals(tool)) {
            String reply = safe(toolCall.getArg("reply"));
            if (reply == null) {
                reply = "Xin chào, tôi có thể giúp bạn tìm thiết bị theo model hoặc serial.";
            }
            return CustomerAiToolCall.none(reply);
        }

        return fallbackRoute(originalMessage);
    }

    private CustomerAiToolCall fallbackRoute(String message) {
        String normalized = message.toLowerCase(Locale.ROOT);
        if (normalized.contains("tìm") || normalized.contains("máy") || normalized.contains("model")
                || normalized.contains("serial") || normalized.contains("thiết bị") || normalized.contains("generator")) {
            return new CustomerAiToolCall("searchDevices", Collections.singletonMap("keyword", message.trim()));
        }
        return CustomerAiToolCall.none("Xin chào, tôi có thể giúp bạn tìm thiết bị theo model hoặc serial.");
    }

    private JsonObject makeTextContent(String role, String text) {
        JsonObject textPart = new JsonObject();
        textPart.addProperty("text", text);

        JsonArray parts = new JsonArray();
        parts.add(textPart);

        JsonObject content = new JsonObject();
        content.addProperty("role", role);
        content.add("parts", parts);
        return content;
    }

    private String buildSystemPrompt() {
        return "Bạn là AI assistant cho web app hỗ trợ khách hàng. "
                + "Nhiệm vụ của bạn là chọn internal tool phù hợp. "
                + "Bạn phải chỉ trả về JSON. Không markdown. Không giải thích. "
                + "Allowed tools: "
                + "1. searchDevices args: keyword(string). "
                + "2. none args: reply(string). "
                + "Rules: chỉ chọn searchDevices khi người dùng muốn tìm thiết bị, máy, model, serial, generator; "
                + "nếu chào hỏi hoặc chưa rõ thì chọn none; không tự tạo URL; không tự tạo ID; không nói về kỹ thuật nội bộ. "
                + "Output ví dụ: {\"tool\":\"searchDevices\",\"args\":{\"keyword\":\"abc\"}}";
    }

    private String resolveApiKey() {
        String fromEnv = safe(System.getenv("GEMINI_API_KEY"));
        if (fromEnv != null) {
            return fromEnv;
        }
        return safe(AppConfig.get("gemini.api.key"));
    }

    private String safe(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }
}
