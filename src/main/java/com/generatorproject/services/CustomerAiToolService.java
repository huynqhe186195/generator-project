package com.generatorproject.services;

import com.generatorproject.dao.BrandDAO;
import com.generatorproject.dao.ProductDAO;
import com.generatorproject.dao.ProductModelDAO;
import com.generatorproject.model.Brand;
import com.generatorproject.model.Product;
import com.generatorproject.model.ProductModel;
import com.generatorproject.model.ai.DeviceSearchResultDto;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Locale;

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
        List<Product> products;
        if (isListAllIntent(normalizedKeyword)) {
            List<Product> allProducts = productDAO.getAllProductByCustomerId((int) customerId);
            products = limitProducts(allProducts, 6);
        } else {
            String searchableKeyword = stripNoise(normalizedKeyword);
            if (searchableKeyword == null) {
                return new ArrayList<DeviceSearchResultDto>();
            }
            products = productDAO.searchCustomerDevices(customerId, searchableKeyword, 6);
        }
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
        String searchableKeyword = stripNoise(normalizedKeyword);
        List<ProductModel> models;
        if (isListAllIntent(normalizedKeyword) && searchableKeyword == null) {
            models = productModelDAO.searchPublicDeviceModels(null, 6);
        } else {
            if (searchableKeyword == null) {
                return new ArrayList<DeviceSearchResultDto>();
            }
            models = productModelDAO.searchPublicDeviceModels(searchableKeyword, 6);
        }
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

    private boolean isListAllIntent(String keyword) {
        if (keyword == null) {
            return false;
        }
        String normalized = keyword.toLowerCase(Locale.ROOT);
        return normalized.contains("tất cả")
                || normalized.contains("toàn bộ")
                || normalized.contains("danh sách")
                || normalized.contains("liệt kê")
                || normalized.contains("bao nhiêu")
                || normalized.contains("all ")
                || normalized.startsWith("all");
    }

    private String stripNoise(String keyword) {
        if (keyword == null) {
            return null;
        }

        String normalized = keyword.toLowerCase(Locale.ROOT);
        List<String> noiseTokens = Arrays.asList(
                "tất cả", "toàn bộ", "danh sách", "liệt kê", "bao nhiêu",
                "thiết bị", "device", "máy", "model", "public", "tài liệu",
                "manual", "catalog", "catalogue", "thông số", "spec",
                "của tôi", "máy của tôi", "thiết bị của tôi", "đang sở hữu",
                "sở hữu", "đang dùng", "cho tôi", "giúp tôi", "hãy", "vui lòng"
        );
        for (String token : noiseTokens) {
            normalized = normalized.replace(token, " ");
        }
        normalized = normalized.replaceAll("\\s+", " ").trim();
        return normalized.isEmpty() ? null : normalized;
    }

    private List<Product> limitProducts(List<Product> products, int limit) {
        if (products == null || products.isEmpty()) {
            return new ArrayList<Product>();
        }
        if (products.size() <= limit) {
            return products;
        }
        return new ArrayList<Product>(products.subList(0, limit));
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
