package com.generatorproject.services;

import com.generatorproject.dao.BrandDAO;
import com.generatorproject.dao.NewsDAO;
import com.generatorproject.dao.ProductDAO;
import com.generatorproject.dao.ProductModelDAO;
import com.generatorproject.model.Brand;
import com.generatorproject.model.News;
import com.generatorproject.model.Product;
import com.generatorproject.model.ProductModel;
import com.generatorproject.model.ai.DeviceSearchResultDto;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.regex.Pattern;

public class CustomerAiToolService {
    public static final String DEVICE_TYPE_OWNED = "OWNED";
    public static final String DEVICE_TYPE_PUBLIC = "PUBLIC";
    public static final String DEVICE_TYPE_NEWS = "NEWS";
    private static final int DEFAULT_SEARCH_LIMIT = 12;
    private static final int LIST_ALL_LIMIT = 50;
    private static final int PUBLIC_LIST_ALL_LIMIT = 24;
    private static final int NEWS_LIST_ALL_LIMIT = 12;
    private static final Pattern MULTIPLE_SPACES = Pattern.compile("\\s+");

    private final ProductDAO productDAO;
    private final ProductModelDAO productModelDAO;
    private final BrandDAO brandDAO;
    private final NewsDAO newsDAO;

    public CustomerAiToolService() {
        this(new ProductDAO(), new ProductModelDAO(), new BrandDAO(), new NewsDAO());
    }

    public CustomerAiToolService(ProductDAO productDAO, ProductModelDAO productModelDAO, BrandDAO brandDAO, NewsDAO newsDAO) {
        this.productDAO = productDAO;
        this.productModelDAO = productModelDAO;
        this.brandDAO = brandDAO;
        this.newsDAO = newsDAO;
    }

    public List<DeviceSearchResultDto> searchOwnedDevices(long customerId, String keyword, String contextPath) {
        String normalizedKeyword = normalizeKeyword(keyword);
        List<Product> products;
        if (isListAllIntent(normalizedKeyword)) {
            List<Product> allProducts = productDAO.getAllProductByCustomerId((int) customerId);
            products = limitProducts(allProducts, LIST_ALL_LIMIT);
        } else {
            String searchableKeyword = stripNoise(normalizedKeyword);
            if (searchableKeyword == null) {
                return new ArrayList<DeviceSearchResultDto>();
            }
            products = productDAO.searchCustomerDevices(customerId, searchableKeyword, DEFAULT_SEARCH_LIMIT);
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

    public boolean shouldPreferShowingResults(String keyword) {
        String normalizedKeyword = normalizeKeyword(keyword);
        if (normalizedKeyword == null) {
            return false;
        }

        String normalized = normalizedKeyword.toLowerCase(Locale.ROOT);
        return isListAllIntent(normalizedKeyword)
                || normalized.contains("danh sách")
                || normalized.contains("liệt kê")
                || normalized.contains("vị trí")
                || normalized.contains("ở ")
                || normalized.startsWith("ở")
                || normalized.contains("tại ")
                || normalized.startsWith("tại")
                || normalized.contains("trong ")
                || normalized.startsWith("trong")
                || normalized.contains("kho")
                || normalized.contains("nhà máy")
                || normalized.contains("location");
    }

    public List<DeviceSearchResultDto> searchPublicDevices(String keyword, String contextPath) {
        String normalizedKeyword = normalizeKeyword(keyword);
        String searchableKeyword = stripNoise(normalizedKeyword);
        List<ProductModel> models;
        if (isListAllIntent(normalizedKeyword) && searchableKeyword == null) {
            models = productModelDAO.searchPublicDeviceModels(null, PUBLIC_LIST_ALL_LIMIT);
        } else {
            if (searchableKeyword == null) {
                return new ArrayList<DeviceSearchResultDto>();
            }
            models = productModelDAO.searchPublicDeviceModels(searchableKeyword, DEFAULT_SEARCH_LIMIT);
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

    public List<DeviceSearchResultDto> searchNews(String keyword, String contextPath) {
        String normalizedKeyword = normalizeKeyword(keyword);
        String searchableKeyword = stripNoise(normalizedKeyword);
        int limit = (isListAllIntent(normalizedKeyword) && searchableKeyword == null) ? NEWS_LIST_ALL_LIMIT : DEFAULT_SEARCH_LIMIT;
        List<News> newsList = newsDAO.searchPublishedForChatbot(searchableKeyword, limit);
        List<DeviceSearchResultDto> results = new ArrayList<DeviceSearchResultDto>();
        for (News news : newsList) {
            DeviceSearchResultDto dto = new DeviceSearchResultDto();
            dto.setModelId(news.getId());
            dto.setModelName(news.getTitle());
            dto.setBrandName(news.getCategory());
            dto.setCurrentLocation(news.getAuthor());
            dto.setStatus(formatNewsDate(news.getPublishedAt(), news.getCreatedAt()));
            dto.setDetailUrl(buildNewsDetailUrl(contextPath, news.getId()));
            dto.setDeviceType(DEVICE_TYPE_NEWS);
            dto.setDeviceTypeLabel("Tin tức");
            dto.setDescription(news.getSummary());
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
                "tin tức", "bài viết", "news",
                "của tôi", "máy của tôi", "thiết bị của tôi", "đang sở hữu",
                "sở hữu", "đang dùng", "cho tôi", "giúp tôi", "hãy", "vui lòng",
                "ở", "tại", "trong", "khu vực", "vị trí", "location", "nơi"
        );
        for (String token : noiseTokens) {
            normalized = normalized.replace(token, " ");
        }
        normalized = MULTIPLE_SPACES.matcher(normalized).replaceAll(" ").trim();
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

    private String buildNewsDetailUrl(String contextPath, Long newsId) {
        String safeContextPath = contextPath == null ? "" : contextPath;
        if (newsId == null) {
            return safeContextPath + "/news";
        }
        return safeContextPath + "/news/detail?id=" + newsId;
    }

    private String formatNewsDate(Date publishedAt, Date createdAt) {
        Date value = publishedAt == null ? createdAt : publishedAt;
        return value == null ? null : value.toString();
    }
}
