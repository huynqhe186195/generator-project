package com.generatorproject.controller.manager;

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

@WebServlet(urlPatterns = {"/manager/contracts/ai-extract"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 15, maxRequestSize = 1024 * 1024 * 20)
public class AiDeviceExtractionController extends HttpServlet {

    private static final String GEMINI_MODEL = "gemini-1.5-flash";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json; charset=UTF-8");

        JsonObject result = new JsonObject();

        try {
            String apiKey = System.getenv("GEMINI_API_KEY");
            if (apiKey == null || apiKey.trim().isEmpty()) {
                throw new IllegalStateException("Thiếu biến môi trường GEMINI_API_KEY.");
            }

            Part filePart = req.getPart("sourceFile");
            if (filePart == null || filePart.getSize() == 0) {
                throw new IllegalArgumentException("Vui lòng chọn file PDF hoặc ảnh hợp đồng.");
            }

            String contentType = filePart.getContentType();
            if (contentType == null ||
                    !(contentType.equalsIgnoreCase("application/pdf") || contentType.startsWith("image/"))) {
                throw new IllegalArgumentException("File chưa đúng định dạng. Chỉ hỗ trợ PDF hoặc ảnh (png/jpg/webp).");
            }

            byte[] fileBytes = filePart.getInputStream().readAllBytes();
            String base64Content = Base64.getEncoder().encodeToString(fileBytes);
            String userPrompt = req.getParameter("prompt");
            if (userPrompt == null || userPrompt.trim().isEmpty()) {
                userPrompt = "Trích xuất danh sách thiết bị từ hợp đồng.";
            }

            JsonObject requestBody = buildGeminiRequest(contentType, base64Content, userPrompt.trim());
            String rawGeminiText = callGemini(requestBody, apiKey);
            JsonObject parsed = extractDevicesJson(rawGeminiText);

            result.addProperty("success", true);
            result.add("data", parsed);
            result.addProperty("raw", rawGeminiText);

            resp.setStatus(HttpServletResponse.SC_OK);
            resp.getWriter().write(result.toString());
        } catch (Exception e) {
            result.addProperty("success", false);
            result.addProperty("message", e.getMessage());
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write(result.toString());
        }
    }

    private JsonObject buildGeminiRequest(String contentType, String base64Content, String userPrompt) {
        String systemPrompt = "Bạn là trợ lý bóc tách dữ liệu hợp đồng. " +
                "Hãy đọc nội dung hợp đồng và chỉ trả về JSON hợp lệ (không markdown) với schema: " +
                "{\"devices\":[{\"serialNumber\":\"\",\"modelName\":\"\",\"manufactureYear\":null,\"currentLocation\":\"\"}]," +
                "\"contract\":{\"contractNumber\":\"\",\"purchaseDate\":\"\",\"signedDate\":\"\",\"effectiveDate\":\"\",\"endDate\":\"\",\"buyerName\":\"\"}}. " +
                "Nếu thiếu dữ liệu thì để chuỗi rỗng hoặc null.";

        JsonObject inlineData = new JsonObject();
        inlineData.addProperty("mime_type", contentType);
        inlineData.addProperty("data", base64Content);

        JsonObject filePart = new JsonObject();
        filePart.add("inline_data", inlineData);

        JsonObject textPart = new JsonObject();
        textPart.addProperty("text", systemPrompt + "\nYêu cầu người dùng: " + userPrompt);

        JsonArray parts = new JsonArray();
        parts.add(textPart);
        parts.add(filePart);

        JsonObject content = new JsonObject();
        content.add("parts", parts);

        JsonArray contents = new JsonArray();
        contents.add(content);

        JsonObject root = new JsonObject();
        root.add("contents", contents);

        JsonObject config = new JsonObject();
        config.addProperty("temperature", 0.2);
        root.add("generationConfig", config);

        return root;
    }

    private String callGemini(JsonObject requestBody, String apiKey) throws IOException, InterruptedException {
        String endpoint = "https://generativelanguage.googleapis.com/v1beta/models/" +
                GEMINI_MODEL + ":generateContent?key=" + apiKey;

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

    private JsonObject extractDevicesJson(String rawText) {
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
            throw new IllegalStateException("AI trả về dữ liệu không phải JSON object.");
        }

        JsonObject obj = element.getAsJsonObject();
        if (!obj.has("devices") || !obj.get("devices").isJsonArray()) {
            JsonArray devices = new JsonArray();
            obj.add("devices", devices);
        }

        if (!obj.has("contract") || !obj.get("contract").isJsonObject()) {
            obj.add("contract", new JsonObject());
        }

        return obj;
    }
}
