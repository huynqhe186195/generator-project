package com.generatorproject.services;

import com.generatorproject.dao.BrandDAO;
import com.generatorproject.dao.ProductDAO;
import com.generatorproject.dao.ProductModelDAO;
import com.generatorproject.model.Brand;
import com.generatorproject.model.Product;
import com.generatorproject.model.ProductModel;
import com.generatorproject.model.ai.DeviceSearchResultDto;

import java.util.ArrayList;
import java.util.List;

public class CustomerAiToolService {
    public static final String DEVICE_TYPE_OWNED = "OWNED";
    public static final String DEVICE_TYPE_PUBLIC = "PUBLIC";

    private final ProductDAO productDAO;
    private final ProductModelDAO productModelDAO;
    private final BrandDAO brandDAO;

    public CustomerAiToolService() {
        this(new ProductDAO(), new ProductModelDAO(), new BrandDAO());
    }

    public CustomerAiToolService(ProductDAO productDAO, ProductModelDAO productModelDAO, BrandDAO brandDAO) {
        this.productDAO = productDAO;
        this.productModelDAO = productModelDAO;
        this.brandDAO = brandDAO;
    }

    public List<DeviceSearchResultDto> searchOwnedDevices(long customerId, String keyword, String contextPath) {
        String normalizedKeyword = normalizeKeyword(keyword);
        if (normalizedKeyword == null) {
            return new ArrayList<DeviceSearchResultDto>();
        }

        List<Product> products = productDAO.searchCustomerDevices(customerId, normalizedKeyword, 6);
        List<DeviceSearchResultDto> results = new ArrayList<DeviceSearchResultDto>();
        for (Product product : products) {
            DeviceSearchResultDto dto = new DeviceSearchResultDto();
            dto.setProductId((long) product.getId());
            dto.setModelId(product.getModelId());
            dto.setModelName(product.getModelName());
            dto.setBrandName(product.getBrandName());
            dto.setSerialNumber(product.getSerialNumber());
            dto.setCurrentLocation(product.getCurrentLocation());
            dto.setStatus(product.getStatus());
            dto.setDetailUrl(buildModelDetailUrl(contextPath, product.getModelId()));
            dto.setDeviceType(DEVICE_TYPE_OWNED);
            dto.setDeviceTypeLabel("Thiết bị sở hữu");
            dto.setDescription("Thiết bị thuộc danh sách máy của bạn, có serial để theo dõi vận hành và lịch sử sử dụng.");
            results.add(dto);
        }
        return results;
    }

    public List<DeviceSearchResultDto> searchPublicDevices(String keyword, String contextPath) {
        String normalizedKeyword = normalizeKeyword(keyword);
        if (normalizedKeyword == null) {
            return new ArrayList<DeviceSearchResultDto>();
        }

        List<ProductModel> models = productModelDAO.searchPublicDeviceModels(normalizedKeyword, 6);
        List<DeviceSearchResultDto> results = new ArrayList<DeviceSearchResultDto>();
        for (ProductModel model : models) {
            DeviceSearchResultDto dto = new DeviceSearchResultDto();
            dto.setModelId((long) model.getId());
            dto.setModelName(model.getName());
            dto.setBrandName(resolveBrandName(model.getBrandId()));
            dto.setDetailUrl(buildModelDetailUrl(contextPath, (long) model.getId()));
            dto.setDeviceType(DEVICE_TYPE_PUBLIC);
            dto.setDeviceTypeLabel("Tài liệu public");
            dto.setDescription("Mẫu máy public để xem thông tin catalogue, thông số và tài liệu; không có serial number.");
            results.add(dto);
        }
        return results;
    }

    private String normalizeKeyword(String keyword) {
        String normalizedKeyword = keyword == null ? "" : keyword.trim();
        return normalizedKeyword.isEmpty() ? null : normalizedKeyword;
    }

    private String resolveBrandName(int brandId) {
        if (brandId <= 0) {
            return null;
        }
        Brand brand = brandDAO.findById(brandId);
        return brand == null ? null : brand.getName();
    }

    private String buildModelDetailUrl(String contextPath, Long modelId) {
        String safeContextPath = contextPath == null ? "" : contextPath;
        if (modelId == null) {
            return safeContextPath + "/products";
        }
        return safeContextPath + "/products/detail?id=" + modelId;
    }
}
