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
import java.util.List;

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

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        List<Brand> brands = brandDAO.getAllBrands();
        List<Category> categories = categoryDAO.getAllCategories();

        req.setAttribute("brands", brands);
        req.setAttribute("categories", categories);

        // customer dropdown
        req.setAttribute("customers", userDAO.getAllCustomers());

        // enum options (Java 8)
        req.setAttribute("fuelTypes", new String[]{"DIESEL", "GASOLINE"});
        req.setAttribute("statuses", new String[]{"READY", "RUNNING", "MAINTENANCE", "BROKEN"});

        req.getRequestDispatcher("/views/admin/Product/product-create.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

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

        // ✅ customer chọn từ dropdown (có thể null)
        Integer customerId = parseIntNullable(req.getParameter("customerId"));

        // ✅ upload image từ ổ cứng
        String imageUrl = saveUploadedImage(req);

        // validate tối thiểu
        String error = null;
        if (name == null || name.trim().isEmpty()) error = "Tên sản phẩm không được để trống.";
        else if (brandId == null) error = "Vui lòng chọn Brand.";
        else if (categoryId == null) error = "Vui lòng chọn Category.";
        else if (fuelType == null || fuelType.trim().isEmpty()) error = "Vui lòng chọn Fuel type.";
        else if (status == null || status.trim().isEmpty()) error = "Vui lòng chọn Status.";

        if (error != null) {
            req.setAttribute("error", error);

            // load lại dropdown
            req.setAttribute("brands", brandDAO.getAllBrands());
            req.setAttribute("categories", categoryDAO.getAllCategories());
            req.setAttribute("customers", userDAO.getAllCustomers());
            req.setAttribute("fuelTypes", new String[]{"DIESEL", "GASOLINE"});
            req.setAttribute("statuses", new String[]{"READY", "RUNNING", "MAINTENANCE", "BROKEN"});

            req.getRequestDispatcher("/views/admin/Product/product-create.jsp").forward(req, resp);
            return;
        }

        // build product
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

        // ✅ imageUrl từ upload
        p.setImageUrl(imageUrl);

        p.setCustomerId(customerId);

        int newId = productDAO.insert(p);

        if (newId > 0) {
            resp.sendRedirect(req.getContextPath() + "/admin/product/product-list");
        } else {
            req.setAttribute("error", "Không thể thêm sản phẩm. Vui lòng thử lại!");

            req.setAttribute("brands", brandDAO.getAllBrands());
            req.setAttribute("categories", categoryDAO.getAllCategories());
            req.setAttribute("customers", userDAO.getAllCustomers());
            req.setAttribute("fuelTypes", new String[]{"DIESEL", "GASOLINE"});
            req.setAttribute("statuses", new String[]{"READY", "RUNNING", "MAINTENANCE", "BROKEN"});

            req.getRequestDispatcher("/views/admin/Product/product-create.jsp").forward(req, resp);
        }
    }

    // ======================
    // ✅ Upload helper
    // ======================
    private String saveUploadedImage(HttpServletRequest req) {
        try {
            Part imagePart = req.getPart("imageFile");
            if (imagePart == null || imagePart.getSize() <= 0) return null;

            String fileName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
            if (fileName == null || fileName.trim().isEmpty()) return null;

            // folder /uploads trong webapp
            String uploadDirPath = getServletContext().getRealPath("/uploads");
            File uploadDir = new File(uploadDirPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            // tránh trùng tên
            String savedName = System.currentTimeMillis() + "_" + fileName;

            imagePart.write(uploadDirPath + File.separator + savedName);

            // return path relative để lưu DB
            return "/uploads/" + savedName;

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // ===== helpers Java 8 =====
    private String trim(String s) { return s == null ? null : s.trim(); }

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
