package com.generatorproject.controller.admin.product;

import com.generatorproject.dao.BrandDAO;
import com.generatorproject.dao.CategoryDAO;
import com.generatorproject.dao.ProductDAO;
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

@WebServlet(urlPatterns = "/admin/product-update")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,      // 1MB
        maxFileSize = 5 * 1024 * 1024,        // 5MB
        maxRequestSize = 10 * 1024 * 1024     // 10MB
)
public class ProductUpdateController extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();
    private final BrandDAO brandDAO = new BrandDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    private static final Set<String> ALLOWED_FUEL = new HashSet<>(Arrays.asList("DIESEL", "GASOLINE"));
    private static final Set<String> ALLOWED_STATUS = new HashSet<>(Arrays.asList("READY", "RUNNING", "MAINTENANCE", "BROKEN"));
    private static final Set<String> ALLOWED_EXT = new HashSet<>(Arrays.asList(".png", ".jpg", ".jpeg", ".webp", ".gif"));

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Integer id = parseIntNullable(req.getParameter("id"));
        if (id == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/product/product-list");
            return;
        }

        Product product = productDAO.findByIdAdmin(id);
        if (product == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        req.setAttribute("p", product);
        loadDropdowns(req);

        req.getRequestDispatcher("/views/admin/Product/product-edit.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        Integer id = parseIntNullable(req.getParameter("id"));
        if (id == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/product/product-list");
            return;
        }

        Product old = productDAO.findByIdAdmin(id);
        if (old == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // ===== Read form =====
        Product p = new Product();
        p.setId(id);

        p.setSerialNumber(trim(req.getParameter("serialNumber")));
        p.setName(trim(req.getParameter("name")));
        p.setModel(trim(req.getParameter("model")));
        p.setOrigin(trim(req.getParameter("origin")));
        p.setManufactureYear(parseIntNullable(req.getParameter("manufactureYear")));

        Integer brandId = parseIntNullable(req.getParameter("brandId"));
        Integer categoryId = parseIntNullable(req.getParameter("categoryId"));
        p.setBrandId(brandId);
        p.setCategoryId(categoryId);

        p.setPowerPrime(parseDoubleNullable(req.getParameter("powerPrime")));
        p.setPowerStandby(parseDoubleNullable(req.getParameter("powerStandby")));
        p.setVoltage(trim(req.getParameter("voltage")));
        p.setFuelTankCapacity(parseDoubleNullable(req.getParameter("fuelTankCapacity")));
        p.setFuelType(trim(req.getParameter("fuelType")));
        p.setCurrentLocation(trim(req.getParameter("currentLocation")));
        p.setStatus(trim(req.getParameter("status")));
        p.setTotalRunningHours(parseDoubleNullable(req.getParameter("totalRunningHours")));
        p.setCustomerId(parseIntNullable(req.getParameter("customerId")));

        // ===== Validate =====
        Map<String, String> errors = new LinkedHashMap<>();

        if (isBlank(p.getName())) errors.put("name", "Tên sản phẩm không được để trống.");
        else if (p.getName().length() > 200) errors.put("name", "Tên sản phẩm tối đa 200 ký tự.");

        if (!isBlank(p.getSerialNumber()) && p.getSerialNumber().length() > 100)
            errors.put("serialNumber", "Số serial tối đa 100 ký tự.");

        if (!isBlank(p.getModel()) && p.getModel().length() > 100)
            errors.put("model", "Model tối đa 100 ký tự.");
        if (!isBlank(p.getOrigin()) && p.getOrigin().length() > 100)
            errors.put("origin", "Xuất xứ tối đa 100 ký tự.");

        if (p.getManufactureYear() != null) {
            int currentYear = Year.now().getValue();
            if (p.getManufactureYear() < 1900 || p.getManufactureYear() > currentYear + 1)
                errors.put("manufactureYear", "Năm sản xuất không hợp lệ.");
        }

        if (p.getBrandId() == null) errors.put("brandId", "Vui lòng chọn Hãng (Brand).");
        if (p.getCategoryId() == null) errors.put("categoryId", "Vui lòng chọn Danh mục.");

        if (isBlank(p.getFuelType())) errors.put("fuelType", "Vui lòng chọn Loại nhiên liệu.");
        else if (!ALLOWED_FUEL.contains(p.getFuelType())) errors.put("fuelType", "Loại nhiên liệu không hợp lệ.");

        if (isBlank(p.getStatus())) errors.put("status", "Vui lòng chọn Trạng thái.");
        else if (!ALLOWED_STATUS.contains(p.getStatus())) errors.put("status", "Trạng thái không hợp lệ.");

        if (p.getPowerPrime() != null && p.getPowerPrime() < 0) errors.put("powerPrime", "Công suất Prime không được âm.");
        if (p.getPowerStandby() != null && p.getPowerStandby() < 0) errors.put("powerStandby", "Công suất Standby không được âm.");
        if (p.getFuelTankCapacity() != null && p.getFuelTankCapacity() < 0) errors.put("fuelTankCapacity", "Dung tích bình nhiên liệu không được âm.");
        if (p.getTotalRunningHours() != null && p.getTotalRunningHours() < 0) errors.put("totalRunningHours", "Tổng giờ vận hành không được âm.");

        if (p.getPowerPrime() != null && p.getPowerStandby() != null && p.getPowerStandby() < p.getPowerPrime()) {
            errors.put("powerStandby", "Công suất Standby phải lớn hơn hoặc bằng Prime.");
        }

        if (!isBlank(p.getVoltage()) && p.getVoltage().length() > 50)
            errors.put("voltage", "Điện áp tối đa 50 ký tự.");

        if (!isBlank(p.getCurrentLocation()) && p.getCurrentLocation().length() > 255)
            errors.put("currentLocation", "Vị trí hiện tại tối đa 255 ký tự.");

        if (p.getCustomerId() != null && p.getCustomerId() <= 0)
            errors.put("customerId", "Khách hàng không hợp lệ.");

        // ===== Upload image =====
        String imageUrl = old.getImageUrl(); // default giữ ảnh cũ
        UploadResult upload = saveUploadedImage(req, id);
        if (upload.error != null) {
            errors.put("imageFile", upload.error);
        } else if (upload.path != null) {
            imageUrl = upload.path; // có ảnh mới
        }
        p.setImageUrl(imageUrl);

        if (!errors.isEmpty()) {
            req.setAttribute("errors", errors);
            req.setAttribute("error", "Vui lòng kiểm tra lại dữ liệu.");
            req.setAttribute("p", p);
            loadDropdowns(req);
            req.getRequestDispatcher("/views/admin/Product/product-edit.jsp").forward(req, resp);
            return;
        }

        boolean ok = productDAO.update(p);
        if (ok) {
            resp.sendRedirect(req.getContextPath() + "/admin/product/detail?id=" + id);
        } else {
            req.setAttribute("error", "Cập nhật thất bại. Vui lòng thử lại.");
            req.setAttribute("p", p);
            loadDropdowns(req);
            req.getRequestDispatcher("/views/admin/Product/product-edit.jsp").forward(req, resp);
        }
    }

    private void loadDropdowns(HttpServletRequest req) {
        req.setAttribute("brands", brandDAO.getAllBrands());
        req.setAttribute("categories", categoryDAO.getAllCategories());
        req.setAttribute("fuelOptions", new String[]{"DIESEL", "GASOLINE"});
        req.setAttribute("statusOptions", new String[]{"READY", "RUNNING", "MAINTENANCE", "BROKEN"});
    }

    private UploadResult saveUploadedImage(HttpServletRequest req, int id) {
        try {
            Part imagePart = req.getPart("imageFile");
            if (imagePart == null || imagePart.getSize() <= 0) return UploadResult.ok(null);

            String submitted = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
            if (isBlank(submitted)) return UploadResult.ok(null);

            String ext = "";
            int dot = submitted.lastIndexOf('.');
            if (dot >= 0) ext = submitted.substring(dot).toLowerCase();

            if (!ALLOWED_EXT.contains(ext)) {
                return UploadResult.fail("File ảnh không hợp lệ (chỉ png/jpg/jpeg/webp/gif).");
            }

            String uploadDirPath = getServletContext().getRealPath("/uploads/products");
            File uploadDir = new File(uploadDirPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            String newFileName = "p_" + id + "_" + UUID.randomUUID() + ext;
            File saved = new File(uploadDir, newFileName);
            imagePart.write(saved.getAbsolutePath());

            // lưu DB dạng relative path
            return UploadResult.ok("/uploads/products/" + newFileName);

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
