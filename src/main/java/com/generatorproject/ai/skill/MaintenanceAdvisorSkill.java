package com.generatorproject.ai.skill;

import com.generatorproject.ai.query.CustomerMaintenanceQueryService;
import com.generatorproject.ai.response.ChatCitation;
import com.generatorproject.ai.response.ChatSourceUsage;
import com.generatorproject.model.Maintenance;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

public class MaintenanceAdvisorSkill implements ChatSkill {
    private final CustomerMaintenanceQueryService queryService = new CustomerMaintenanceQueryService();
    private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("dd/MM/yyyy", Locale.ROOT);

    @Override
    public String getCode() { return "maintenance_advisor_skill"; }

    @Override
    public SkillResult execute(SkillContext context) {
        Long userId = context.getRequest().getUserId();
        String keyword = context.getParsedIntent().getEntity("serial");
        if (keyword == null || keyword.isEmpty()) {
            keyword = context.getParsedIntent().getNormalizedMessage();
        }
        List<Maintenance> items = queryService.findCompletedByCustomerAndKeyword(userId == null ? 0L : userId, keyword, 5);
        SkillResult result = new SkillResult()
                .setSourcesUsed(List.of(new ChatSourceUsage("SQL", "maintenances + products + product_models")));
        if (items.isEmpty()) {
            return result.setReply("Tôi chưa thấy lịch sử bảo trì/sửa chữa hoàn tất khớp với yêu cầu này. Bạn hãy cung cấp serial hoặc model cụ thể để tôi kiểm tra chính xác hơn.");
        }

        Maintenance latest = items.get(0);
        String when = latest.getMaintenanceDate() == null ? "không rõ ngày" : DATE_FORMAT.format(latest.getMaintenanceDate());
        String serial = latest.getProductSerialNumber() == null ? "không rõ serial" : latest.getProductSerialNumber();
        String productName = latest.getProductName() == null ? "thiết bị" : latest.getProductName();
        String actualDescription = latest.getActualDescription();
        String description = actualDescription != null && !actualDescription.trim().isEmpty() ? actualDescription : latest.getDescription();

        List<ChatCitation> citations = new ArrayList<>();
        citations.add(new ChatCitation("Lần bảo trì gần nhất", productName + " / serial " + serial + " / ngày " + when));
        if (description != null && !description.trim().isEmpty()) {
            citations.add(new ChatCitation("Mô tả công việc gần nhất", description.trim()));
        }

        String reply = "Lần bảo trì/sửa chữa hoàn tất gần nhất của " + productName + " (serial " + serial + ") là vào " + when + ". ";
        if (description != null && !description.trim().isEmpty()) {
            reply += "Ghi nhận công việc: " + description.trim() + ". ";
        }
        reply += "Để tư vấn chính xác việc cần làm tiếp theo, bạn nên cung cấp thêm số giờ chạy hiện tại hoặc serial cụ thể đang cần kiểm tra.";
        return result.setReply(reply).setCitations(citations);
    }
}
