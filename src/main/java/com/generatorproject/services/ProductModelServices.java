package com.generatorproject.services;

import com.generatorproject.dao.ProductModelDAO;
import com.generatorproject.model.ProductModel;

import java.util.List;

public class ProductModelServices implements IProductModelServices{
    private final ProductModelDAO productModelDAO;

    public ProductModelServices() {
        productModelDAO = new ProductModelDAO();
    }
    @Override
    public ProductModel findByName(String name) {
        return productModelDAO.findByName(name);
    }

    @Override
    public List<ProductModel> findAll() {
        return productModelDAO.findAll();
    }

    @Override
    public ProductModel findById(int id) {
        return productModelDAO.findById(id);
    }

    @Override
    public Long save(ProductModel model) {
        return productModelDAO.save(model);
    }
}
