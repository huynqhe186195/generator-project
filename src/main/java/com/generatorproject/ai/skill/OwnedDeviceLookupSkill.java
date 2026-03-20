package com.generatorproject.ai.skill;

import com.generatorproject.ai.query.OwnedDeviceQueryService;
import com.generatorproject.ai.response.ChatAction;
import com.generatorproject.ai.response.ChatSourceUsage;
import com.generatorproject.ai.service.CustomerDeviceCardMapper;
import com.generatorproject.model.Product;
import com.generatorproject.model.ai.DeviceSearchResultDto;

import java.util.ArrayList;
import java.util.List;

public class OwnedDeviceLookupSkill implements ChatSkill {
    private final OwnedDeviceQueryService queryService = new OwnedDeviceQueryService();

    @Override
    public String getCode() { return "owned_device_lookup_skill"; }

    @Override
    public SkillResult execute(SkillContext context) {
        Long userId = context.getRequest().getUserId();
        String message = context.getParsedIntent().getNormalizedMessage();
        List<Product> products = queryService.search(userId == null ? 0L : userId, message);
        List<DeviceSearchResultDto> results = new ArrayList<>();
        for (Product product : products) {
            results.add(CustomerDeviceCardMapper.fromOwned(product, context.getRequest().getContextPath()));
        }

        SkillResult result = new SkillResult()
                .setResults(results)
                .setSourcesUsed(List.of(new ChatSourceUsage("SQL", "products + product_models")));
        if (results.isEmpty()) {
            return result.setReply("Tôi chưa tìm thấy thiết bị sở hữu phù hợp. Bạn hãy thử lại bằng serial, vị trí, trạng thái hoặc yêu cầu liệt kê tất cả máy.");
        }
        if (results.size() == 1) {
            DeviceSearchResultDto item = results.get(0);
            return result.setReply("Tôi đã tìm thấy đúng 1 thiết bị sở hữu phù hợp và có thể mở nhanh trang chi tiết model liên quan.")
                    .setActionType("REDIRECT")
                    .setRedirectUrl(item.getDetailUrl())
                    .setActions(List.of(new ChatAction("OPEN_DEVICE_DETAIL", "Mở chi tiết máy", item.getDetailUrl())));
        }
        return result.setReply("Tôi tìm thấy " + results.size() + " thiết bị sở hữu phù hợp. Bạn hãy chọn đúng máy theo serial hoặc vị trí.")
                .setActionType("SHOW_RESULTS");
    }
}
