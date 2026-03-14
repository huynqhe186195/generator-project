package com.generatorproject.services;

public class PromptBuilder {
    public String buildDeviceExtractionPrompt(String userPrompt, String ocrText) {
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
