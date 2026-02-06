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
    int countAll();
    List<Product> findAllWithPagination(int offset, int limit);
    Product findByIdWithDetails(Long id);
    void updateRunningHours(Long id, Double newHours);
    List<Product> findAllWithPagination(int offset, int limit, String keyword);
    int countAll(String keyword);
}
