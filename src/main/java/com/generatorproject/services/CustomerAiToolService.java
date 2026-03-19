package com.generatorproject.services;

import com.generatorproject.dao.ProductDAO;
import com.generatorproject.model.Product;
import com.generatorproject.model.ai.DeviceSearchResultDto;

import java.util.ArrayList;
import java.util.List;

public class CustomerAiToolService {
    private final ProductDAO productDAO;

    public CustomerAiToolService() {
        this(new ProductDAO());
    }

    public CustomerAiToolService(ProductDAO productDAO) {
        this.productDAO = productDAO;
    }

    public List<DeviceSearchResultDto> searchDevices(long customerId, String keyword, String contextPath) {
        String normalizedKeyword = keyword == null ? "" : keyword.trim();
        if (normalizedKeyword.isEmpty()) {
            return new ArrayList<DeviceSearchResultDto>();
        }

        List<Product> products = productDAO.searchCustomerDevices(customerId, normalizedKeyword, 6);
        List<DeviceSearchResultDto> results = new ArrayList<DeviceSearchResultDto>();
        for (Product product : products) {
            DeviceSearchResultDto dto = new DeviceSearchResultDto();
            dto.setProductId(product.getId() == null ? null : product.getId().longValue());
            dto.setModelId(product.getModelId());
            dto.setModelName(product.getModelName());
            dto.setBrandName(product.getBrandName());
            dto.setSerialNumber(product.getSerialNumber());
            dto.setCurrentLocation(product.getCurrentLocation());
            dto.setStatus(product.getStatus());
            dto.setDetailUrl(buildDetailUrl(contextPath, product.getModelId()));
            results.add(dto);
        }
        return results;
    }

    private String buildDetailUrl(String contextPath, Long modelId) {
        String safeContextPath = contextPath == null ? "" : contextPath;
        if (modelId == null) {
            return safeContextPath + "/product-list";
        }
        return safeContextPath + "/products/detail?id=" + modelId;
    }
}
