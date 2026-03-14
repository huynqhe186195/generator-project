package com.generatorproject.services;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;

public class GeminiGatewayService {

    private final Gson gson = new Gson();
    private final String model = "gemini-2.5-flash";

    public String extractDeviceList(String userPrompt, String ocrText) {
        String apiKey = System.getenv("GEMINI_API_KEY");
        if (apiKey == null || apiKey.trim().isEmpty()) {
            throw new IllegalStateException("Missing GEMINI_API_KEY");
        }

        String endpoint = "https://generativelanguage.googleapis.com/v1beta/models/"
                + model + ":generateContent?key=" + apiKey;

        String finalPrompt = buildPrompt(userPrompt, ocrText);

        JsonObject part = new JsonObject();
        part.addProperty("text", finalPrompt);

        JsonObject content = new JsonObject();
        content.addProperty("role", "user");
        JsonArray parts = new JsonArray();
        parts.add(part);
        content.add("parts", parts);

        JsonArray contents = new JsonArray();
        contents.add(content);

        JsonObject body = new JsonObject();
        body.add("contents", contents);

        try {
            URL url = new URL(endpoint);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);

            try (OutputStream os = conn.getOutputStream()) {
                os.write(gson.toJson(body).getBytes(StandardCharsets.UTF_8));
            }

            int status = conn.getResponseCode();
            if (status < 200 || status >= 300) {
                String err = readAll(conn.getErrorStream() == null
                        ? new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8))
                        : new BufferedReader(new InputStreamReader(conn.getErrorStream(), StandardCharsets.UTF_8)));
                throw new RuntimeException("Gemini HTTP " + status + ": " + err);
            }

            String respText = readAll(new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8)));
            JsonObject root = JsonParser.parseString(respText).getAsJsonObject();
            JsonArray candidates = root.has("candidates") ? root.getAsJsonArray("candidates") : new JsonArray();
            if (candidates.size() == 0) {
                throw new RuntimeException("Gemini returned empty candidates");
            }

            JsonObject first = candidates.get(0).getAsJsonObject();
            JsonObject firstContent = first.getAsJsonObject("content");
            JsonArray firstParts = firstContent.getAsJsonArray("parts");
            if (firstParts.size() == 0) {
                throw new RuntimeException("Gemini returned empty parts");
            }

            String text = firstParts.get(0).getAsJsonObject().get("text").getAsString();
            return stripMarkdownCodeFence(text);
        } catch (Exception e) {
            throw new RuntimeException("Gemini call failed: " + e.getMessage(), e);
        }
    }

    private String readAll(BufferedReader br) throws Exception {
        if (br == null) return "";
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = br.readLine()) != null) {
            sb.append(line);
        }
        return sb.toString();
    }

    private String stripMarkdownCodeFence(String text) {
        if (text == null) return "";
        String t = text.trim();
        if (t.startsWith("```")) {
            t = t.replaceFirst("^```[a-zA-Z]*", "").replaceFirst("```$", "").trim();
        }
        return t;
    }

    private String buildPrompt(String userPrompt, String ocrText) {
        return String.format("Bạn là trợ lý trích xuất dữ liệu hợp đồng.\\n\\n"
                        + "Nhiệm vụ:\\n"
                        + "- Đọc nội dung hợp đồng bên dưới\\n"
                        + "- Chỉ trích xuất danh sách thiết bị có trong hợp đồng\\n"
                        + "- Không lấy bên mua, bên bán, ngày ký\\n"
                        + "- Không tự suy đoán nếu không chắc\\n"
                        + "- Nếu không đọc rõ thì để null\\n"
                        + "- Trả về JSON hợp lệ, không giải thích thêm\\n\\n"
                        + "JSON schema:\\n"
                        + "{\\n"
                        + "  \"chatMessage\": \"string\",\\n"
                        + "  \"items\": [\\n"
                        + "    {\\n"
                        + "      \"rawModelName\": \"string|null\",\\n"
                        + "      \"rawBrand\": \"string|null\",\\n"
                        + "      \"rawPower\": \"string|null\",\\n"
                        + "      \"quantity\": 1,\\n"
                        + "      \"rawSerialNumber\": \"string|null\",\\n"
                        + "      \"manufactureYear\": null,\\n"
                        + "      \"currentLocation\": \"string|null\",\\n"
                        + "      \"confidenceScore\": 0.95\\n"
                        + "    }\\n"
                        + "  ],\\n"
                        + "  \"warnings\": [\"string\"]\\n"
                        + "}\\n\\n"
                        + "Yêu cầu người dùng:\\n%s\\n\\n"
                        + "Nội dung OCR:\\n%s", userPrompt == null ? "" : userPrompt, ocrText == null ? "" : ocrText);
    }
}
