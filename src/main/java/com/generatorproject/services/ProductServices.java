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
}
