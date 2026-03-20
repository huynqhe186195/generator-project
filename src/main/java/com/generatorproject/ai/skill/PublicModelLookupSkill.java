package com.generatorproject.ai.skill;

import com.generatorproject.ai.query.PublicModelQueryService;
import com.generatorproject.ai.response.ChatAction;
import com.generatorproject.ai.response.ChatCitation;
import com.generatorproject.ai.response.ChatSourceUsage;
import com.generatorproject.ai.service.CustomerDeviceCardMapper;
import com.generatorproject.dao.BrandDAO;
import com.generatorproject.model.Brand;
import com.generatorproject.model.ProductModel;
import com.generatorproject.model.ai.DeviceSearchResultDto;

import java.util.ArrayList;
import java.util.List;

public class PublicModelLookupSkill implements ChatSkill {
    private final PublicModelQueryService queryService = new PublicModelQueryService();
    private final BrandDAO brandDAO = new BrandDAO();

    @Override
    public String getCode() { return "public_model_lookup_skill"; }

    @Override
    public SkillResult execute(SkillContext context) {
        List<ProductModel> models = queryService.search(context.getParsedIntent().getNormalizedMessage(), 12);
        List<DeviceSearchResultDto> results = new ArrayList<>();
        for (ProductModel model : models) {
            Brand brand = model.getBrandId() > 0 ? brandDAO.findById(model.getBrandId()) : null;
            results.add(CustomerDeviceCardMapper.fromPublic(model, brand, context.getRequest().getContextPath()));
        }

        SkillResult result = new SkillResult()
                .setResults(results)
                .setSourcesUsed(List.of(new ChatSourceUsage("SQL", "product_models + brands")));
        if (results.isEmpty()) {
            return result.setReply("Tôi chưa tìm thấy model public phù hợp. Bạn có thể thử lại bằng tên model, thương hiệu, nhiên liệu hoặc từ khóa manual/thông số.");
        }
        if (results.size() == 1) {
            DeviceSearchResultDto item = results.get(0);
            return result.setReply("Tôi đã tìm thấy đúng 1 model public phù hợp và có thể mở trang thông tin chi tiết ngay.")
                    .setActionType("REDIRECT")
                    .setRedirectUrl(item.getDetailUrl())
                    .setActions(List.of(new ChatAction("OPEN_MODEL_DETAIL", "Mở chi tiết model", item.getDetailUrl())));
        }
        return result.setReply("Tôi tìm thấy " + results.size() + " model public phù hợp. Bạn hãy chọn đúng model để xem thông tin và tài liệu.")
                .setActionType("SHOW_RESULTS")
                .setCitations(List.of(new ChatCitation("Dữ liệu model", "Kết quả được lấy từ bảng product_models hiện có trong CMS.")));
    }
}
