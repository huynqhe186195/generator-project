package com.generatorproject.services;

import com.generatorproject.dao.ProductModelDAO;
import com.generatorproject.model.ProductModel;

import java.util.List;

public class ProductModelMatcherService {
    private final ProductModelDAO productModelDAO = new ProductModelDAO();

    public ProductModel matchByName(String rawModel) {
        if (rawModel == null || rawModel.trim().isEmpty()) return null;
        String target = rawModel.trim().toLowerCase();
        List<ProductModel> models = productModelDAO.findAll();
        ProductModel best = null;
        int bestScore = Integer.MAX_VALUE;
        for (ProductModel model : models) {
            String name = model.getName() == null ? "" : model.getName().toLowerCase();
            int score = Math.abs(name.length() - target.length());
            if (name.contains(target) || target.contains(name)) score = 0;
            if (score < bestScore) {
                best = model;
                bestScore = score;
            }
        }
        return best;
    }
}
