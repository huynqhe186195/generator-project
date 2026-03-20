package com.generatorproject.ai.intent;

import java.util.LinkedHashMap;
import java.util.Locale;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class IntentClassifierService {
    private static final Pattern SERIAL_PATTERN = Pattern.compile("(?:serial|sn|s\\/n)\\s*[:#-]?\\s*([a-z0-9._/-]{3,})", Pattern.CASE_INSENSITIVE);
    private static final Pattern MODEL_PATTERN = Pattern.compile("(?:model|máy|generator|máy phát)\\s+([a-z0-9][a-z0-9 ._-]{1,40})", Pattern.CASE_INSENSITIVE);

    public ParsedIntent classify(String message) {
        String normalized = message == null ? "" : message.trim();
        String lower = normalized.toLowerCase(Locale.ROOT);
        Map<String, String> entities = new LinkedHashMap<>();
        extractEntity(entities, "serial", SERIAL_PATTERN, normalized);
        extractEntity(entities, "model", MODEL_PATTERN, normalized);

        if (lower.isEmpty() || isGreeting(lower)) {
            return new ParsedIntent(ChatIntent.GREETING, entities, normalized);
        }
        if (looksLikeMaintenance(lower)) {
            return new ParsedIntent(ChatIntent.MAINTENANCE_SUPPORT, entities, normalized);
        }
        if (looksLikeTechnicalDoc(lower)) {
            return new ParsedIntent(ChatIntent.TECHNICAL_DOCUMENT_SUPPORT, entities, normalized);
        }
        if (looksLikeOwnedDevice(lower)) {
            return new ParsedIntent(ChatIntent.OWNED_DEVICE_LOOKUP, entities, normalized);
        }
        if (looksLikePublicModel(lower)) {
            return new ParsedIntent(ChatIntent.PUBLIC_MODEL_LOOKUP, entities, normalized);
        }
        if (entities.containsKey("serial")) {
            return new ParsedIntent(ChatIntent.OWNED_DEVICE_LOOKUP, entities, normalized);
        }
        if (entities.containsKey("model")) {
            return new ParsedIntent(ChatIntent.PUBLIC_MODEL_LOOKUP, entities, normalized);
        }
        return new ParsedIntent(ChatIntent.UNKNOWN, entities, normalized);
    }

    private void extractEntity(Map<String, String> entities, String key, Pattern pattern, String text) {
        Matcher matcher = pattern.matcher(text == null ? "" : text);
        if (matcher.find()) {
            String value = matcher.group(1);
            if (value != null && !value.trim().isEmpty()) {
                entities.put(key, value.trim());
            }
        }
    }

    private boolean isGreeting(String lower) {
        return lower.matches("^(hi|hello|xin chào|chào|alo|hey)(.*)$");
    }

    private boolean looksLikeOwnedDevice(String lower) {
        return lower.contains("serial") || lower.contains("sở hữu") || lower.contains("của tôi")
                || lower.contains("máy của tôi") || lower.contains("thiết bị của tôi") || lower.contains("vị trí")
                || lower.contains("trạng thái") || lower.contains("danh sách máy") || lower.contains("liệt kê máy");
    }

    private boolean looksLikePublicModel(String lower) {
        return lower.contains("public") || lower.contains("tài liệu") || lower.contains("manual")
                || lower.contains("catalog") || lower.contains("catalogue") || lower.contains("thông số")
                || lower.contains("spec") || lower.contains("model");
    }

    private boolean looksLikeMaintenance(String lower) {
        return lower.contains("bảo trì") || lower.contains("bảo dưỡng") || lower.contains("maintenance")
                || lower.contains("sửa chữa") || lower.contains("repair") || lower.contains("thay dầu")
                || lower.contains("kiểm tra định kỳ") || lower.contains("lịch sử sửa chữa");
    }

    private boolean looksLikeTechnicalDoc(String lower) {
        return lower.contains("alarm") || lower.contains("lỗi") || lower.contains("cảnh báo")
                || lower.contains("ats") || lower.contains("quy trình") || lower.contains("troubleshooting")
                || lower.contains("low oil") || lower.contains("áp suất dầu") || lower.contains("manual");
    }
}
