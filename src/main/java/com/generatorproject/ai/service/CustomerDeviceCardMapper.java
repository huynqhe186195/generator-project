package com.generatorproject.ai.service;

import com.generatorproject.model.Brand;
import com.generatorproject.model.Product;
import com.generatorproject.model.ProductModel;
import com.generatorproject.model.ai.DeviceSearchResultDto;

public final class CustomerDeviceCardMapper {
    private CustomerDeviceCardMapper() {}

    public static DeviceSearchResultDto fromOwned(Product product, String contextPath) {
        DeviceSearchResultDto dto = new DeviceSearchResultDto();
        dto.setProductId((long) product.getId());
        dto.setModelId(product.getModelId());
        dto.setModelName(product.getModelName());
        dto.setBrandName(product.getBrandName());
        dto.setSerialNumber(product.getSerialNumber());
        dto.setCurrentLocation(product.getCurrentLocation());
        dto.setStatus(product.getStatus());
        dto.setDeviceType("OWNED");
        dto.setDeviceTypeLabel("Thiết bị sở hữu");
        dto.setDetailUrl(buildModelDetailUrl(contextPath, product.getModelId()));
        dto.setDescription("Thiết bị có serial thuộc danh sách máy của bạn.");
        return dto;
    }

    public static DeviceSearchResultDto fromPublic(ProductModel model, Brand brand, String contextPath) {
        DeviceSearchResultDto dto = new DeviceSearchResultDto();
        dto.setModelId((long) model.getId());
        dto.setModelName(model.getName());
        dto.setBrandName(brand == null ? null : brand.getName());
        dto.setDeviceType("PUBLIC");
        dto.setDeviceTypeLabel("Tài liệu public");
        dto.setDetailUrl(buildModelDetailUrl(contextPath, (long) model.getId()));
        dto.setDescription("Model public để xem thông số, mô tả và manual.");
        return dto;
    }

    public static String buildModelDetailUrl(String contextPath, Long modelId) {
        String safeContextPath = contextPath == null ? "" : contextPath;
        return modelId == null ? safeContextPath + "/products" : safeContextPath + "/products/detail?id=" + modelId;
    }
}
