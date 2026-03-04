package com.generatorproject.controller.manager;

import com.generatorproject.model.Product;
import com.generatorproject.model.ProductModel;
import com.generatorproject.services.IProductModelServices;
import com.generatorproject.services.IProductServices;
import com.generatorproject.services.ProductModelServices;
import com.generatorproject.services.ProductServices;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "ManagementProductController", urlPatterns = "/manager/assets")
public class ManagementProductController extends HttpServlet {

    private final IProductServices productService;
    private final IProductModelServices productModelService;

    public ManagementProductController() {
        productService = new ProductServices();
        productModelService = new ProductModelServices();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "detail":
                showAssetDetail(req, resp);
                break;
            case "list":
            default:
                showAssetList(req, resp);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "update_hours":
                handleUpdateHours(req, resp);
                break;
            default:
                resp.sendRedirect("assets");
                break;
        }
    }

    private void handleUpdateHours(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            Long id = Long.parseLong(req.getParameter("id"));
            Double newHours = Double.parseDouble(req.getParameter("runningHours"));

            productService.updateRunningHours(id, newHours);

            resp.sendRedirect("assets?action=detail&id=" + id + "&msg=update_success");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("assets?msg=error");
        }
    }

    private void showAssetList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String keyword = req.getParameter("keyword");

        int ownershipPage = parseIntOrDefault(req.getParameter("ownershipPage"), 1);
        int ownershipPageSize = 8;

        int allProductCount = productService.countAll();
        List<Product> allProducts = productService.findAllWithPagination(0, allProductCount == 0 ? 1 : allProductCount);

        List<ProductModelOwnership> allOwnerships = buildProductModelOwnerships(productModelService.findAll(), allProducts);

        int ownershipTotalItems = allOwnerships.size();
        int ownershipTotalPages = Math.max(1, (int) Math.ceil((double) ownershipTotalItems / ownershipPageSize));
        if (ownershipPage > ownershipTotalPages) {
            ownershipPage = ownershipTotalPages;
        }

        int ownershipOffset = Math.max(0, (ownershipPage - 1) * ownershipPageSize);
        int ownershipToIndex = Math.min(ownershipOffset + ownershipPageSize, ownershipTotalItems);

        List<ProductModelOwnership> ownershipPageItems = ownershipOffset >= ownershipToIndex
                ? new ArrayList<>()
                : new ArrayList<>(allOwnerships.subList(ownershipOffset, ownershipToIndex));

        Integer selectedModelId = parseInt(req.getParameter("selectedModelId"));
        ProductModelOwnership selectedOwnership = findOwnershipByModelId(allOwnerships, selectedModelId);

        req.setAttribute("currentKeyword", keyword);
        req.setAttribute("productModelOwnerships", ownershipPageItems);
        req.setAttribute("selectedModelId", selectedModelId);
        req.setAttribute("selectedOwnership", selectedOwnership);
        req.setAttribute("ownershipCurrentPage", ownershipPage);
        req.setAttribute("ownershipTotalPages", ownershipTotalPages);
        req.setAttribute("ownershipTotalItems", ownershipTotalItems);

        req.getRequestDispatcher("/views/manager/asset/asset-list.jsp").forward(req, resp);
    }

    private ProductModelOwnership findOwnershipByModelId(List<ProductModelOwnership> ownerships, Integer selectedModelId) {
        if (selectedModelId == null) {
            return null;
        }

        for (ProductModelOwnership ownership : ownerships) {
            if (ownership.getModelId() == selectedModelId) {
                return ownership;
            }
        }
        return null;
    }

    private Integer parseInt(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private int parseIntOrDefault(String value, int defaultValue) {
        Integer parsed = parseInt(value);
        return parsed == null || parsed < 1 ? defaultValue : parsed;
    }

    private List<ProductModelOwnership> buildProductModelOwnerships(List<ProductModel> models, List<Product> products) {
        Map<Integer, ProductModelOwnership> ownershipMap = new LinkedHashMap<>();

        for (ProductModel model : models) {
            ownershipMap.put(model.getId(), new ProductModelOwnership(model.getId(), model.getName()));
        }

        ProductModelOwnership unassignedModel = new ProductModelOwnership(-1, "Chưa gán Product Model");

        for (Product product : products) {
            if (product == null) {
                continue;
            }

            Integer modelId = product.getModelId() == null ? null : product.getModelId().intValue();
            ProductModelOwnership ownership = modelId == null ? null : ownershipMap.get(modelId);

            if (ownership == null) {
                ownership = unassignedModel;
            }

            String customerName = normalizeValue(product.getCustomerName(), "Khách hàng chưa xác định");
            String customerEmail = normalizeValue(product.getCustomerEmail(), "-");
            String serialNumber = normalizeValue(product.getSerialNumber(), "-");
            String location = normalizeValue(product.getCurrentLocation(), "Chưa cập nhật");

            ownership.addAsset(new AssetOwnershipItem(product.getId(), serialNumber, customerName, customerEmail, location));
        }

        List<ProductModelOwnership> result = new ArrayList<>(ownershipMap.values());
        if (unassignedModel.getTotalAssets() > 0) {
            result.add(unassignedModel);
        }
        return result;
    }

    private String normalizeValue(String value, String fallback) {
        return (value == null || value.trim().isEmpty()) ? fallback : value.trim();
    }

    public static class ProductModelOwnership {
        private final int modelId;
        private final String modelName;
        private final Map<String, Integer> customerCounts = new LinkedHashMap<>();
        private final List<AssetOwnershipItem> assets = new ArrayList<>();

        public ProductModelOwnership(int modelId, String modelName) {
            this.modelId = modelId;
            this.modelName = modelName;
        }

        public void addAsset(AssetOwnershipItem item) {
            assets.add(item);
            customerCounts.put(item.getCustomerName(), customerCounts.getOrDefault(item.getCustomerName(), 0) + 1);
        }

        public int getModelId() {
            return modelId;
        }

        public String getModelName() {
            return modelName;
        }

        public int getTotalAssets() {
            return assets.size();
        }

        public int getOwnerCount() {
            return customerCounts.size();
        }

        public List<AssetOwnershipItem> getAssets() {
            return assets;
        }
    }

    public static class AssetOwnershipItem {
        private final int productId;
        private final String serialNumber;
        private final String customerName;
        private final String customerEmail;
        private final String location;

        public AssetOwnershipItem(int productId, String serialNumber, String customerName, String customerEmail, String location) {
            this.productId = productId;
            this.serialNumber = serialNumber;
            this.customerName = customerName;
            this.customerEmail = customerEmail;
            this.location = location;
        }

        public int getProductId() {
            return productId;
        }

        public String getSerialNumber() {
            return serialNumber;
        }

        public String getCustomerName() {
            return customerName;
        }

        public String getCustomerEmail() {
            return customerEmail;
        }

        public String getLocation() {
            return location;
        }
    }

    private void showAssetDetail(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String idStr = req.getParameter("id");
            if (idStr == null || idStr.isEmpty()) {
                resp.sendRedirect("assets?msg=missing_id");
                return;
            }

            Long id = Long.parseLong(idStr);

            Product product = productService.findByIdWithDetails(id);

            if (product == null) {
                req.setAttribute("errorMessage", "Không tìm thấy máy phát điện này!");
                showAssetList(req, resp);
                return;
            }

            req.setAttribute("p", product);

            req.getRequestDispatcher("/views/manager/asset/asset-detail.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("assets?msg=error");
        }
    }
}
