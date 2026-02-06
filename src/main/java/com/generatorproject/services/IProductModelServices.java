package com.generatorproject.services;

import com.generatorproject.model.ProductModel;

import java.util.List;

public interface IProductModelServices {
    ProductModel findByName(String name);
    List<ProductModel> findAll();
    ProductModel findById(int id);
    Long save(ProductModel model);
}
