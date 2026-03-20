package com.generatorproject.ai.query;

import com.generatorproject.dao.ProductDAO;
import com.generatorproject.model.Product;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

public class OwnedDeviceQueryService {
    private static final int DEFAULT_SEARCH_LIMIT = 12;
    private static final int LIST_ALL_LIMIT = 50;
    private final ProductDAO productDAO = new ProductDAO();

    public List<Product> search(long customerId, String keyword) {
        String normalizedKeyword = keyword == null ? "" : keyword.trim();
        if (normalizedKeyword.isEmpty()) {
            return new ArrayList<>();
        }
        if (isListAllIntent(normalizedKeyword)) {
            List<Product> all = productDAO.getAllProductByCustomerId((int) customerId);
            return all.size() <= LIST_ALL_LIMIT ? all : new ArrayList<>(all.subList(0, LIST_ALL_LIMIT));
        }
        return productDAO.searchCustomerDevices(customerId, stripNoise(normalizedKeyword), DEFAULT_SEARCH_LIMIT);
    }

    private boolean isListAllIntent(String keyword) {
        String normalized = keyword.toLowerCase(Locale.ROOT);
        return normalized.contains("tất cả") || normalized.contains("toàn bộ") || normalized.contains("danh sách")
                || normalized.contains("liệt kê") || normalized.contains("all");
    }

    private String stripNoise(String keyword) {
        return keyword.toLowerCase(Locale.ROOT)
                .replace("thiết bị", " ")
                .replace("máy", " ")
                .replace("của tôi", " ")
                .replace("serial", " ")
                .replaceAll("\\s+", " ")
                .trim();
    }
}
