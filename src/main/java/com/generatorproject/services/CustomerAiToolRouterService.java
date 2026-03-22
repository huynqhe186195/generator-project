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
import java.util.LinkedHashMap;
import java.util.Locale;
import java.util.Map;

public class CustomerAiToolRouterService {
    private static final Gson GSON = new Gson();

    public CustomerAiToolCall route(String message) {
        String normalizedMessage = message == null ? "" : message.trim();
        if (normalizedMessage.isEmpty()) {
            return CustomerAiToolCall.none("Bạn hãy nhập câu hỏi, ví dụ: liệt kê tất cả máy tôi đang sở hữu hoặc tìm tài liệu public theo model/thông số.");
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

        JsonObject json = JsonParser.parseString(response.body()).getAsJsonObject();JsonArray candidates = json.getAsJsonArray("candidates");
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
        if ("searchOwnedDevices".equals(tool) || "searchPublicDevices".equals(tool)) {
            String keyword = safe(toolCall.getArg("keyword"));
            if (keyword == null) {
                return fallbackRoute(originalMessage);
            }
            return createSearchToolCall(tool, keyword);
        }

        if ("none".equals(tool)) {
            String reply = safe(toolCall.getArg("reply"));
            if (reply == null) {
                reply = "Xin chào, tôi có thể giúp bạn tìm máy sở hữu, liệt kê toàn bộ máy của bạn, hoặc tra tài liệu public theo model/thông số.";
            }
            return CustomerAiToolCall.none(reply);
        }

        return fallbackRoute(originalMessage);
    }

    private CustomerAiToolCall fallbackRoute(String message) {
        String normalized = message.toLowerCase(Locale.ROOT);
        if (looksLikeOwnedDeviceSearch(normalized)) {
            return createSearchToolCall("searchOwnedDevices", message.trim());
        }
        if (looksLikePublicDeviceSearch(normalized)) {
            return createSearchToolCall("searchPublicDevices", message.trim());
        }
        if (normalized.contains("tìm") || normalized.contains("máy") || normalized.contains("model")
                || normalized.contains("thiết bị") || normalized.contains("generator") || normalized.contains("máy phát")) {
            if (normalized.contains("của tôi") || normalized.contains("đang sở hữu") || normalized.contains("đang dùng")) {
                return createSearchToolCall("searchOwnedDevices", message.trim());
            }
            return createSearchToolCall("searchPublicDevices", message.trim());
        }return CustomerAiToolCall.none("Xin chào, tôi có thể giúp bạn tìm 2 loại device: máy sở hữu có serial hoặc tài liệu public theo model.");
    }

    private boolean looksLikeOwnedDeviceSearch(String normalized) {
        return normalized.contains("serial")
                || normalized.contains("sở hữu")
                || normalized.contains("của tôi")
                || normalized.contains("máy của tôi")
                || normalized.contains("thiết bị của tôi")
                || normalized.contains("đang dùng")
                || normalized.contains("đang sở hữu")
                || normalized.contains("vị trí")
                || normalized.contains("nhà máy")
                || normalized.contains("kho")
                || normalized.contains("trạng thái")
                || normalized.contains("maintenance")
                || normalized.contains("bảo trì")
                || normalized.contains("repair")
                || normalized.contains("sửa chữa")
                || normalized.contains("contract")
                || normalized.contains("hợp đồng")
                || normalized.contains("danh sách máy")
                || normalized.contains("liệt kê máy")
                || normalized.contains("tất cả máy")
                || normalized.contains("toàn bộ máy");
    }

    private boolean looksLikePublicDeviceSearch(String normalized) {
        return normalized.contains("public")
                || normalized.contains("tài liệu")
                || normalized.contains("manual")
                || normalized.contains("catalog")
                || normalized.contains("catalogue")
                || normalized.contains("thông số")
                || normalized.contains("spec")
                || normalized.contains("mẫu")
                || normalized.contains("sản phẩm mẫu")
                || normalized.contains("model public")
                || normalized.contains("catalog máy")
                || normalized.contains("fuel")
                || normalized.contains("origin")
                || normalized.contains("xuất xứ");
    }

    private CustomerAiToolCall createSearchToolCall(String tool, String keyword) {
        Map<String, String> args = new LinkedHashMap<String, String>();
        args.put("keyword", keyword);
        return new CustomerAiToolCall(tool, args);
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

    private String buildSystemPrompt() {return "Bạn là AI assistant cho web app hỗ trợ khách hàng. "
            + "Hệ thống có 2 loại device: "
            + "(1) device sở hữu của customer: có serial_number, thuộc danh sách máy của customer; "
            + "(2) device tài liệu public: là model public để xem thông số/tài liệu, không có serial_number. "
            + "Nhiệm vụ của bạn là chọn internal tool phù hợp. "
            + "Bạn phải chỉ trả về JSON. Không markdown. Không giải thích. "
            + "Allowed tools: "
            + "1. searchOwnedDevices args: keyword(string). "
            + "2. searchPublicDevices args: keyword(string). "
            + "3. none args: reply(string). "
            + "Rules: nếu người dùng nhắc serial, máy của tôi, thiết bị của tôi, vị trí máy, trạng thái, bảo trì, sửa chữa, hợp đồng, danh sách máy hoặc tất cả máy thì chọn searchOwnedDevices; "
            + "nếu người dùng nhắc tài liệu, model public, manual, catalogue, thông số, sản phẩm mẫu, xuất xứ, nhiên liệu hoặc đặc tả kỹ thuật thì chọn searchPublicDevices; "
            + "nếu chỉ chào hỏi hoặc chưa rõ thì chọn none; không tự tạo URL; không tự tạo ID; không nói về kỹ thuật nội bộ. "
            + "Output ví dụ 1: {\"tool\":\"searchOwnedDevices\",\"args\":{\"keyword\":\"serial abc123\"}} "
            + "Output ví dụ 2: {\"tool\":\"searchPublicDevices\",\"args\":{\"keyword\":\"manual cummins c220\"}}";
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