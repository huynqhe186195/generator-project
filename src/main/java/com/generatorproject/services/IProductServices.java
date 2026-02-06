package com.generatorproject.services;

import com.generatorproject.model.Product;

import java.util.List;

public interface IProductServices {
    Product findProductBySerial(String serialNumber);
    int countProducts();
    void update(Product product);
    List<Product> findAll();
    Long save(Product product);
    Product getProductById(int id);
    List<Product> getAllProductByCustomerId(int id);
}
