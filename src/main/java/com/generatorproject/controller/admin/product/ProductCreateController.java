package com.generatorproject.controller.admin.product;

import com.generatorproject.dao.BrandDAO;
import com.generatorproject.dao.CategoryDAO;
import com.generatorproject.dao.ProductDAO;
import com.generatorproject.dao.UserDao;
import com.generatorproject.model.Brand;
import com.generatorproject.model.Category;
import com.generatorproject.model.Product;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.time.Year;
import java.util.*;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,      // 1MB
        maxFileSize = 10 * 1024 * 1024,       // 10MB
        maxRequestSize = 20 * 1024 * 1024     // 20MB
)
@WebServlet(urlPatterns = "/admin/product/create")
public class ProductCreateController extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();
    private final BrandDAO brandDAO = new BrandDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final UserDao userDAO = new UserDao();

    private static final Set<String> ALLOWED_FUEL = new HashSet<>(Arrays.asList("DIESEL", "GASOLINE"));
    private static final Set<String> ALLOWED_STATUS = new HashSet<>(Arrays.asList("READY", "RUNNING", "MAINTENANCE", "BROKEN"));
    private static final Set<String> ALLOWED_EXT = new HashSet<>(Arrays.asList(".png", ".jpg", ".jpeg", ".webp", ".gif"));

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        loadDropdowns(req);
        req.getRequestDispatcher("/views/admin/Product/product-create.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        // ===== Read form =====
        String serialNumber = trim(req.getParameter("serialNumber"));
        String name = trim(req.getParameter("name"));
        String model = trim(req.getParameter("model"));
        String origin = trim(req.getParameter("origin"));

        Integer manufactureYear = parseIntNullable(req.getParameter("manufactureYear"));
        Integer brandId = parseIntNullable(req.getParameter("brandId"));
        Integer categoryId = parseIntNullable(req.getParameter("categoryId"));

        Double powerPrime = parseDoubleNullable(req.getParameter("powerPrime"));
        Double powerStandby = parseDoubleNullable(req.getParameter("powerStandby"));

        String voltage = trim(req.getParameter("voltage"));
        Double fuelTankCapacity = parseDoubleNullable(req.getParameter("fuelTankCapacity"));

        String fuelType = trim(req.getParameter("fuelType"));
        String currentLocation = trim(req.getParameter("currentLocation"));
        String status = trim(req.getParameter("status"));

        Double totalRunningHours = parseDoubleNullable(req.getParameter("totalRunningHours"));
        Integer customerId = parseIntNullable(req.getParameter("customerId"));

        // ===== Validate =====
        Map<String, String> errors = new LinkedHashMap<>();

        // name
        if (isBlank(name)) errors.put("name", "Tên sản phẩm không được để trống.");
        else if (name.length() > 200) errors.put("name", "Tên sản phẩm tối đa 200 ký tự.");

        // serial
        if (!isBlank(serialNumber) && serialNumber.length() > 100)
            errors.put("serialNumber", "Số serial tối đa 100 ký tự.");

        // model/origin
        if (!isBlank(model) && model.length() > 100)
            errors.put("model", "Model tối đa 100 ký tự.");
        if (!isBlank(origin) && origin.length() > 100)
            errors.put("origin", "Xuất xứ tối đa 100 ký tự.");

        // year
        if (manufactureYear != null) {
            int currentYear = Year.now().getValue();
            if (manufactureYear < 1900 || manufactureYear > currentYear + 1)
                errors.put("manufactureYear", "Năm sản xuất không hợp lệ.");
        }

        // required ids
        if (brandId == null) errors.put("brandId", "Vui lòng chọn Hãng (Brand).");
        if (categoryId == null) errors.put("categoryId", "Vui lòng chọn Danh mục.");

        // enum fuel/status
        if (isBlank(fuelType)) errors.put("fuelType", "Vui lòng chọn Loại nhiên liệu.");
        else if (!ALLOWED_FUEL.contains(fuelType)) errors.put("fuelType", "Loại nhiên liệu không hợp lệ.");

        if (isBlank(status)) errors.put("status", "Vui lòng chọn Trạng thái.");
        else if (!ALLOWED_STATUS.contains(status)) errors.put("status", "Trạng thái không hợp lệ.");

        // numbers non-negative
        if (powerPrime != null && powerPrime < 0) errors.put("powerPrime", "Công suất Prime không được âm.");
        if (powerStandby != null && powerStandby < 0) errors.put("powerStandby", "Công suất Standby không được âm.");
        if (fuelTankCapacity != null && fuelTankCapacity < 0) errors.put("fuelTankCapacity", "Dung tích bình nhiên liệu không được âm.");
        if (totalRunningHours != null && totalRunningHours < 0) errors.put("totalRunningHours", "Tổng giờ vận hành không được âm.");

        // optional: standby >= prime (nếu cả 2 có)
        if (powerPrime != null && powerStandby != null && powerStandby < powerPrime) {
            errors.put("powerStandby", "Công suất Standby phải lớn hơn hoặc bằng Prime.");
        }

        // voltage length
        if (!isBlank(voltage) && voltage.length() > 50)
            errors.put("voltage", "Điện áp tối đa 50 ký tự.");

        // location length
        if (!isBlank(currentLocation) && currentLocation.length() > 255)
            errors.put("currentLocation", "Vị trí hiện tại tối đa 255 ký tự.");

        // customerId if provided must be >0
        if (customerId != null && customerId <= 0)
            errors.put("customerId", "Khách hàng không hợp lệ.");

        // ===== Upload image (validate file) =====
        UploadResult upload = saveUploadedImage(req);
        if (upload.error != null) {
            errors.put("imageFile", upload.error);
        }
        String imageUrl = upload.path; // có thể null

        if (!errors.isEmpty()) {
            req.setAttribute("errors", errors);
            req.setAttribute("error", "Vui lòng kiểm tra lại dữ liệu.");
            loadDropdowns(req);
            req.getRequestDispatcher("/views/admin/Product/product-create.jsp").forward(req, resp);
            return;
        }

        // ===== Build product =====
        Product p = new Product();
        p.setSerialNumber(serialNumber);
        p.setName(name);
        p.setModel(model);
        p.setOrigin(origin);

        p.setManufactureYear(manufactureYear);
        p.setBrandId(brandId);
        p.setCategoryId(categoryId);

        p.setPowerPrime(powerPrime);
        p.setPowerStandby(powerStandby);
        p.setVoltage(voltage);

        p.setFuelTankCapacity(fuelTankCapacity);
        p.setFuelType(fuelType);

        p.setCurrentLocation(currentLocation);
        p.setStatus(status);

        p.setTotalRunningHours(totalRunningHours);
        p.setImageUrl(imageUrl);
        p.setCustomerId(customerId);

        int newId = productDAO.insert(p);

        if (newId > 0) {
            resp.sendRedirect(req.getContextPath() + "/admin/product/product-list");
        } else {
            req.setAttribute("error", "Không thể thêm sản phẩm. Vui lòng thử lại!");
            loadDropdowns(req);
            req.getRequestDispatcher("/views/admin/Product/product-create.jsp").forward(req, resp);
        }
    }

    // ======================
    // Dropdown loader
    // ======================
    private void loadDropdowns(HttpServletRequest req) {
        List<Brand> brands = brandDAO.getAllBrands();
        List<Category> categories = categoryDAO.getAllCategories();

        req.setAttribute("brands", brands);
        req.setAttribute("categories", categories);
        req.setAttribute("customers", userDAO.getAllCustomers());

        req.setAttribute("fuelTypes", new String[]{"DIESEL", "GASOLINE"});
        req.setAttribute("statuses", new String[]{"READY", "RUNNING", "MAINTENANCE", "BROKEN"});
    }

    // ======================
    // Upload helper (save to /uploads/products)
    // ======================
    private UploadResult saveUploadedImage(HttpServletRequest req) {
        try {
            Part imagePart = req.getPart("imageFile");
            if (imagePart == null || imagePart.getSize() <= 0) return UploadResult.ok(null);

            String fileName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
            if (isBlank(fileName)) return UploadResult.ok(null);

            String ext = "";
            int dot = fileName.lastIndexOf('.');
            if (dot >= 0) ext = fileName.substring(dot).toLowerCase();

            if (!ALLOWED_EXT.contains(ext)) {
                return UploadResult.fail("File ảnh không hợp lệ (chỉ png/jpg/jpeg/webp/gif).");
            }

            // folder /uploads/products trong webapp
            String uploadDirPath = getServletContext().getRealPath("/uploads/products");
            File uploadDir = new File(uploadDirPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            String savedName = "p_new_" + System.currentTimeMillis() + "_" + UUID.randomUUID() + ext;
            File saved = new File(uploadDir, savedName);

            imagePart.write(saved.getAbsolutePath());

            // lưu DB dạng relative path (khuyên dùng)
            return UploadResult.ok("/uploads/products/" + savedName);

        } catch (Exception e) {
            e.printStackTrace();
            return UploadResult.fail("Tải ảnh lên thất bại. Vui lòng thử lại.");
        }
    }

    private static class UploadResult {
        final String path;
        final String error;

        private UploadResult(String path, String error) {
            this.path = path;
            this.error = error;
        }

        static UploadResult ok(String path) { return new UploadResult(path, null); }
        static UploadResult fail(String error) { return new UploadResult(null, error); }
    }

    // ===== helpers =====
    private String trim(String s) { return s == null ? null : s.trim(); }
    private boolean isBlank(String s) { return s == null || s.trim().isEmpty(); }

    private Integer parseIntNullable(String v) {
        try {
            if (v == null || v.trim().isEmpty()) return null;
            return Integer.parseInt(v.trim());
        } catch (Exception e) {
            return null;
        }
    }

    private Double parseDoubleNullable(String v) {
        try {
            if (v == null || v.trim().isEmpty()) return null;
            return Double.parseDouble(v.trim());
        } catch (Exception e) {
            return null;
        }
    }
}
