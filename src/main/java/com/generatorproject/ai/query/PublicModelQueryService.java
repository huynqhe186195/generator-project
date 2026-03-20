package com.generatorproject.ai.query;

import com.generatorproject.dao.ProductModelDAO;
import com.generatorproject.model.ProductModel;

import java.util.List;

public class PublicModelQueryService {
    private final ProductModelDAO productModelDAO = new ProductModelDAO();

    public List<ProductModel> search(String keyword, int limit) {
        return productModelDAO.searchPublicDeviceModels(keyword, limit);
    }

    public ProductModel findById(Long modelId) {
        if (modelId == null) {
            return null;
        }
        return productModelDAO.findById(modelId.intValue());
    }
}
