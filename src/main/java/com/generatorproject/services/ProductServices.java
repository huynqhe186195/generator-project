package com.generatorproject.services;

import com.generatorproject.dao.GenericDAO;
import com.generatorproject.dao.ProductDAO;
import com.generatorproject.model.Product;

import java.util.List;

public class ProductServices implements IProductServices {
    private ProductDAO productDAO;

    public ProductServices() {
        productDAO = new ProductDAO();
    }

    @Override
    public Product findProductBySerial(String serialNumber) {
        return productDAO.findBySerial(serialNumber);
    }

    @Override
    public int countProducts() {
        return productDAO.countProducts();
    }

    @Override
    public void update(Product product) {
        productDAO.update(product);
    }

    @Override
    public List<Product> findAll() {
        return  productDAO.findAll();
    }

    @Override
    public Long save(Product product) {
        return  productDAO.save(product);
    }

    @Override
    public Product getProductById(int id) {
        return productDAO.getProductById(id);
    }

    @Override
    public List<Product> getAllProductByCustomerId(int id) {
        return productDAO.getAllProductByCustomerId(id);
    }

    @Override
    public int countAll() {
        return productDAO.countAll();
    }

    @Override
    public List<Product> findAllWithPagination(int offset, int limit) {
        return productDAO.findAllWithPagination(offset, limit);
    }

    @Override
    public Product findByIdWithDetails(Long id) {
        return productDAO.findByIdWithDetails(id);
    }

    @Override
    public void updateRunningHours(Long id, Double newHours) {
        productDAO.updateRunningHours(id, newHours);
    }

    @Override
    public List<Product> findAllWithPagination(int offset, int limit, String keyword) {
        if (keyword != null && !keyword.trim().isEmpty()) {
            return productDAO.findByKeywordWithPagination(keyword.trim(), offset, limit);
        }
        return productDAO.findAllWithPagination(offset, limit);
    }

    @Override
    public int countAll(String keyword) {
        if (keyword != null && !keyword.trim().isEmpty()) {
            return productDAO.countByKeyword(keyword.trim());
        }
        return productDAO.countAll();
    }
}
