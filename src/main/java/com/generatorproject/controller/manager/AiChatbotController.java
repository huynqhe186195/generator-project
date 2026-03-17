package com.generatorproject.controller.manager;

import com.generatorproject.config.AppConfig;
import com.google.gson.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@WebServlet(urlPatterns = { "/manager/contracts/ai-chat" })
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 15, maxRequestSize = 1024 * 1024 * 25)
public class AiChatbotController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json; charset=UTF-8");

        JsonObject result = new JsonObject();

        try {
            String apiKey = resolveApiKey(req);
            if (apiKey == null || apiKey.trim().isEmpty()) {
                throw new IllegalStateException("Thiếu API key Gemini. Hãy cấu hình gemini.api.key trong application.properties (root project hoặc src/main/resources), hoặc set APP_CONFIG_FILE / GEMINI_API_KEY.");
            }

            String message = req.getParameter("message");
            if (message == null || message.trim().isEmpty()) {
                throw new IllegalArgumentException("Vui lòng nhập nội dung chat.");
            }

            boolean extractionMode = "true".equalsIgnoreCase(req.getParameter("extractionMode"));
            String historyJson = req.getParameter("history");
            Part filePart = req.getPart("sourceFile");

            JsonObject body = buildGeminiRequest(message.trim(), historyJson, filePart, extractionMode);
            String rawReply = callGemini(body, apiKey);

            result.addProperty("success", true);
            result.addProperty("reply", rawReply);

            if (extractionMode) {
                JsonObject extracted = tryParseExtraction(rawReply);
                if (extracted != null) {
                    result.addProperty("structured", true);
                    result.add("data", extracted);
                } else {
                    result.addProperty("structured", false);
                }
            }

            resp.setStatus(HttpServletResponse.SC_OK);
            resp.getWriter().write(result.toString());
        } catch (Exception e) {
            result.addProperty("success", false);
            result.addProperty("message", e.getMessage());
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write(result.toString());
        }
    }

    private JsonObject buildGeminiRequest(String message, String historyJson, Part filePart, boolean extractionMode)
            throws IOException {
        JsonArray contents = new JsonArray();

        String systemPrompt;
        if (extractionMode) {
            systemPrompt = "Bạn là chatbot AI trợ lý hợp đồng. "
                    + "Hãy trả về JSON hợp lệ duy nhất (không markdown) theo schema: "
                    + "{\"answer\":\"...\",\"devices\":[{\"serialNumber\":\"\",\"modelName\":\"\",\"manufactureYear\":null,\"currentLocation\":\"\"}],"
                    + "\"contract\":{\"contractNumber\":\"\",\"purchaseDate\":\"\",\"signedDate\":\"\",\"effectiveDate\":\"\",\"endDate\":\"\",\"buyerName\":\"\"}}. "
                    + "Nếu thiếu dữ liệu thì dùng chuỗi rỗng hoặc null.";
        } else {
            systemPrompt = "Bạn là chatbot AI hỗ trợ nghiệp vụ hợp đồng và thiết bị máy phát điện. "
                    + "Trả lời rõ ràng, ngắn gọn, đúng nghiệp vụ. Nếu người dùng hỏi ngoài nghiệp vụ vẫn hỗ trợ như chatbot thông thường.";
        }

        contents.add(makeTextContent("user", systemPrompt));

        if (historyJson != null && !historyJson.trim().isEmpty()) {
            JsonElement historyElement = JsonParser.parseString(historyJson);
            if (historyElement.isJsonArray()) {
                JsonArray history = historyElement.getAsJsonArray();
                for (JsonElement e : history) {
                    if (!e.isJsonObject())
                        continue;
                    JsonObject msg = e.getAsJsonObject();
                    String role = msg.has("role") ? msg.get("role").getAsString() : "user";
                    String content = msg.has("content") ? msg.get("content").getAsString() : "";
                    if (content == null || content.trim().isEmpty())
                        continue;
                    contents.add(makeTextContent("assistant".equalsIgnoreCase(role) ? "model" : "user", content));
                }
            }
        }

        JsonArray currentParts = new JsonArray();
        JsonObject currentText = new JsonObject();
        currentText.addProperty("text", message);
        currentParts.add(currentText);

        if (filePart != null && filePart.getSize() > 0) {
            String contentType = filePart.getContentType();
            if (contentType == null ||
                    !(contentType.equalsIgnoreCase("application/pdf") || contentType.startsWith("image/"))) {
                throw new IllegalArgumentException("File chưa đúng định dạng. Chỉ hỗ trợ PDF hoặc ảnh (png/jpg/webp).");
            }

            byte[] fileBytes = filePart.getInputStream().readAllBytes();
            String base64Content = Base64.getEncoder().encodeToString(fileBytes);

            JsonObject inlineData = new JsonObject();
            inlineData.addProperty("mime_type", contentType);
            inlineData.addProperty("data", base64Content);

            JsonObject fileInlinePart = new JsonObject();
            fileInlinePart.add("inline_data", inlineData);
            currentParts.add(fileInlinePart);
        }

        JsonObject currentContent = new JsonObject();
        currentContent.addProperty("role", "user");
        currentContent.add("parts", currentParts);
        contents.add(currentContent);

        JsonObject root = new JsonObject();
        root.add("contents", contents);

        JsonObject config = new JsonObject();
        config.addProperty("temperature", extractionMode ? 0.2 : 0.7);
        root.add("generationConfig", config);

        return root;
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

    private String callGemini(JsonObject requestBody, String apiKey) throws IOException, InterruptedException {
        String endpoint = "https://generativelanguage.googleapis.com/v1beta/models/"
                + AppConfig.getOrDefault("gemini.model", "gemini-2.5-flash") + ":generateContent?key=" + apiKey;

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(endpoint))
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(requestBody.toString(), StandardCharsets.UTF_8))
                .build();

        HttpClient client = HttpClient.newHttpClient();
        HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

        if (response.statusCode() < 200 || response.statusCode() >= 300) {
            throw new IllegalStateException("Gemini API lỗi: HTTP " + response.statusCode() + " - " + response.body());
        }

        JsonObject json = JsonParser.parseString(response.body()).getAsJsonObject();
        JsonArray candidates = json.getAsJsonArray("candidates");
        if (candidates == null || candidates.size() == 0) {
            throw new IllegalStateException("Gemini không trả về candidates.");
        }

        JsonObject first = candidates.get(0).getAsJsonObject();
        JsonObject content = first.getAsJsonObject("content");
        JsonArray parts = content.getAsJsonArray("parts");
        if (parts == null || parts.size() == 0) {
            throw new IllegalStateException("Gemini không có nội dung trả lời.");
        }

        return parts.get(0).getAsJsonObject().get("text").getAsString();
    }

    private JsonObject tryParseExtraction(String rawText) {
        try {
            String cleaned = rawText == null ? "" : rawText.trim();
            if (cleaned.startsWith("```") || cleaned.contains("```json")) {
                Pattern pattern = Pattern.compile("```(?:json)?\\s*(\\{[\\s\\S]*})\\s*```");
                Matcher matcher = pattern.matcher(cleaned);
                if (matcher.find()) {
                    cleaned = matcher.group(1);
                }
            }

            JsonElement element = JsonParser.parseString(cleaned);
            if (!element.isJsonObject()) {
                return null;
            }

            JsonObject obj = element.getAsJsonObject();
            if (!obj.has("devices") || !obj.get("devices").isJsonArray()) {
                obj.add("devices", new JsonArray());
            }
            if (!obj.has("contract") || !obj.get("contract").isJsonObject()) {
                obj.add("contract", new JsonObject());
            }
            if (!obj.has("answer")) {
                obj.addProperty("answer", "Đã trích xuất dữ liệu từ file hợp đồng.");
            }
            return obj;
        } catch (Exception ignore) {
            return null;
        }
    }

    private String resolveApiKey(HttpServletRequest req) {
        String apiKeyFromRequest = normalizeApiKey(req.getParameter("apiKey"));
        if (apiKeyFromRequest != null) {
            return apiKeyFromRequest;
        }

        String apiKeyFromProperties = normalizeApiKey(AppConfig.get("gemini.api.key"));
        if (apiKeyFromProperties == null) {
            AppConfig.reload();
            apiKeyFromProperties = normalizeApiKey(AppConfig.get("gemini.api.key"));
        }
        if (apiKeyFromProperties != null) {
            return apiKeyFromProperties;
        }

        String apiKeyFromContextParam = normalizeApiKey(getServletContext().getInitParameter("GEMINI_API_KEY"));
        if (apiKeyFromContextParam != null) {
            return apiKeyFromContextParam;
        }

        String apiKeyFromEnv = normalizeApiKey(System.getenv("GEMINI_API_KEY"));
        if (apiKeyFromEnv != null) {
            return apiKeyFromEnv;
        }

        String apiKeyFromSystemProp = normalizeApiKey(System.getProperty("GEMINI_API_KEY"));
        if (apiKeyFromSystemProp != null) {
            return apiKeyFromSystemProp;
        }

        return null;
    }

    private String normalizeApiKey(String value) {
        if (value == null) {
            return null;
        }
        String normalized = value.trim();
        if (normalized.isEmpty() || "__GEMINI_API_KEY__".equals(normalized)) {
            return null;
        }
        return normalized;
    }
}
