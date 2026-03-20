package com.generatorproject.ai.skill;

import com.generatorproject.ai.query.PublicModelQueryService;
import com.generatorproject.ai.response.ChatCitation;
import com.generatorproject.ai.response.ChatSourceUsage;
import com.generatorproject.model.ProductModel;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

public class TechnicalDocumentSupportSkill implements ChatSkill {
    private final PublicModelQueryService queryService = new PublicModelQueryService();

    @Override
    public String getCode() { return "technical_document_support_skill"; }

    @Override
    public SkillResult execute(SkillContext context) {
        String message = context.getParsedIntent().getNormalizedMessage();
        List<ProductModel> models = queryService.search(message, 3);
        SkillResult result = new SkillResult()
                .setSourcesUsed(List.of(new ChatSourceUsage("MODEL_DOC", "description + specifications + manual_url trong product_models")));
        if (models.isEmpty()) {
            return result.setReply("Tôi chưa tìm thấy model/tài liệu kỹ thuật đủ gần với câu hỏi này. Bạn hãy thêm tên model hoặc serial để tôi bám đúng tài liệu hơn.");
        }

        ProductModel best = models.get(0);
        List<ChatCitation> citations = new ArrayList<>();
        if (best.getSpecifications() != null && !best.getSpecifications().trim().isEmpty()) {
            citations.add(new ChatCitation("Thông số kỹ thuật", trim(best.getSpecifications(), 240)));
        }
        if (best.getDescription() != null && !best.getDescription().trim().isEmpty()) {
            citations.add(new ChatCitation("Mô tả model", trim(best.getDescription(), 220)));
        }
        if (best.getManualUrl() != null && !best.getManualUrl().trim().isEmpty()) {
            citations.add(new ChatCitation("Manual URL", best.getManualUrl().trim()));
        }

        String reply;
        String lower = message.toLowerCase(Locale.ROOT);
        if (lower.contains("low oil") || lower.contains("áp suất dầu") || lower.contains("oil pressure")) {
            reply = "Với lỗi liên quan áp suất dầu thấp, bước kiểm tra đầu tiên nên là mức dầu, rò rỉ quanh hệ bôi trơn và cảm biến/công tắc áp suất dầu. ";
        } else if (lower.contains("ats")) {
            reply = "Với ATS, bạn nên kiểm tra nguồn lưới vào, tín hiệu chuyển nguồn và trạng thái liên động trước khi kết luận lỗi cơ khí/điện sâu hơn. ";
        } else {
            reply = "Tôi đã tìm được model gần nhất để tham chiếu tài liệu kỹ thuật. ";
        }
        reply += "Model đang tham chiếu: " + best.getName() + ". Nếu cần chẩn đoán chính xác hơn, bạn hãy cung cấp serial hoặc model đầy đủ để tôi bám đúng manual.";
        return result.setReply(reply).setCitations(citations);
    }

    private String trim(String text, int maxLen) {
        String normalized = text.replaceAll("\\s+", " ").trim();
        return normalized.length() <= maxLen ? normalized : normalized.substring(0, maxLen - 3) + "...";
    }
}
