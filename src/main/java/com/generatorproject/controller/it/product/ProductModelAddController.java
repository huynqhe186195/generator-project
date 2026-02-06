package com.generatorproject.controller.it.product;

import com.generatorproject.dao.BrandDAO;
import com.generatorproject.dao.CategoryDAO;
import com.generatorproject.dao.ProductImageDAO;
import com.generatorproject.dao.ProductModelDAO;
import com.generatorproject.model.Brand;
import com.generatorproject.model.Category;
import com.generatorproject.model.ProductModel;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.text.Normalizer;
import java.util.*;
import java.util.Locale;
import java.util.UUID;

@WebServlet("/it/products/add")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 15 * 1024 * 1024,
        maxRequestSize = 25 * 1024 * 1024
)
public class ProductModelAddController extends HttpServlet {

    private final ProductModelDAO productModelDAO = new ProductModelDAO();
    private final BrandDAO brandDAO = new BrandDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final ProductImageDAO productImageDAO = new ProductImageDAO(); // ✅ thêm

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        List<Brand> brands = brandDAO.getAllBrands();
        List<Category> categories = categoryDAO.getAllCategories();

        Integer preBrandId = parseIntOrNull(req.getParameter("brandId"));
        req.setAttribute("brands", brands);
        req.setAttribute("categories", categories);
        req.setAttribute("preBrandId", preBrandId);

        req.getRequestDispatcher("/views/it/product/add.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String name = trim(req.getParameter("name"));
        String slug = trim(req.getParameter("slug"));
        Integer brandId = parseIntOrNull(req.getParameter("brandId"));
        Integer categoryId = parseIntOrNull(req.getParameter("categoryId"));
        String origin = trim(req.getParameter("origin"));
        String fuelType = trim(req.getParameter("fuelType"));
        Double power = parseDoubleOrNull(req.getParameter("power"));
        String status = trim(req.getParameter("status"));
        String description = trim(req.getParameter("description"));
        String specifications = trim(req.getParameter("specifications"));

        if (slug == null && name != null) slug = toSlug(name);

        // ✅ Upload NHIỀU ảnh (optional) - name="imageFiles" multiple
        List<String> imageUrls = saveUploadFiles(req, "imageFiles", "/uploads/product-models");

        // ✅ ảnh đại diện lưu vào product_models.image_url (lấy ảnh đầu tiên)
        String thumbnail = (imageUrls != null && !imageUrls.isEmpty()) ? imageUrls.get(0) : null;

        // validate
        String error = null;
        if (name == null) error = "Tên không được để trống";
        else if (brandId == null) error = "Vui lòng chọn Brand";
        else if (categoryId == null) error = "Vui lòng chọn Category";
        else if (fuelType == null) error = "Vui lòng chọn Fuel type";
        else if (status == null) error = "Vui lòng chọn Status";

        if (error != null) {
            req.setAttribute("error", error);
            req.setAttribute("brands", brandDAO.getAllBrands());
            req.setAttribute("categories", categoryDAO.getAllCategories());
            req.setAttribute("preBrandId", brandId);
            req.getRequestDispatcher("/views/it/product/add.jsp").forward(req, resp);
            return;
        }

        // check trùng tên
        ProductModel existed = productModelDAO.findByName(name);
        if (existed != null) {
            req.setAttribute("error", "Tên mẫu đã tồn tại!");
            req.setAttribute("brands", brandDAO.getAllBrands());
            req.setAttribute("categories", categoryDAO.getAllCategories());
            req.setAttribute("preBrandId", brandId);
            req.getRequestDispatcher("/views/it/product/add.jsp").forward(req, resp);
            return;
        }

        ProductModel pm = new ProductModel.Builder()
                .setName(name)
                .setSlug(slug)
                .setBrandId(brandId)
                .setCategoryId(categoryId)
                .setOrigin(origin)
                .setFuelType(fuelType)
                .setPower(power)
                .setDescription(description)
                .setSpecifications(specifications)
                .setManualUrl(null)
                .setImageUrl(thumbnail)   // ✅ ảnh đại diện (optional)
                .setStatus(status)
                .build();

        // ✅ insert product_models, lấy id
        Long newId = productModelDAO.insertProductModel(pm);
        if (newId == null) {
            req.setAttribute("error", "Lỗi khi lưu sản phẩm (không lấy được ID)!");
            req.setAttribute("brands", brandDAO.getAllBrands());
            req.setAttribute("categories", categoryDAO.getAllCategories());
            req.setAttribute("preBrandId", brandId);
            req.getRequestDispatcher("/views/it/product/add.jsp").forward(req, resp);
            return;
        }

        int modelId = newId.intValue();

        // ✅ lưu N ảnh vào product_images
        if (imageUrls != null) {
            for (String url : imageUrls) {
                productImageDAO.insertImage(modelId, url);
            }
        }

        resp.sendRedirect(req.getContextPath() + "/it/products");
    }

    // ================= helpers =================

    // ✅ upload nhiều file ảnh
    private List<String> saveUploadFiles(HttpServletRequest req, String partName, String folder)
            throws IOException, ServletException {

        List<String> urls = new ArrayList<>();

        for (Part part : req.getParts()) {
            if (!partName.equals(part.getName())) continue;
            if (part.getSize() == 0) continue;

            String original = Paths.get(part.getSubmittedFileName()).getFileName().toString();
            String ext = "";
            int dot = original.lastIndexOf('.');
            if (dot >= 0) ext = original.substring(dot).toLowerCase();

            // ✅ chỉ nhận ảnh
            if (!(ext.equals(".png") || ext.equals(".jpg") || ext.equals(".jpeg") || ext.equals(".webp"))) {
                continue;
            }

            String newName = UUID.randomUUID() + ext;

            String uploadDir = req.getServletContext().getRealPath(folder);
            File dir = new File(uploadDir);
            if (!dir.exists()) dir.mkdirs();

            part.write(uploadDir + File.separator + newName);

            // path tương đối lưu DB
            urls.add(folder.substring(1) + "/" + newName); // bỏ dấu "/" đầu
        }

        return urls.isEmpty() ? null : urls;
    }

    private String trim(String s) {
        if (s == null) return null;
        s = s.trim();
        return s.isEmpty() ? null : s;
    }

    private Integer parseIntOrNull(String s) {
        try {
            if (s == null || s.trim().isEmpty()) return null;
            return Integer.parseInt(s.trim());
        } catch (Exception e) {
            return null;
        }
    }

    private Double parseDoubleOrNull(String s) {
        try {
            if (s == null || s.trim().isEmpty()) return null;
            return Double.parseDouble(s.trim());
        } catch (Exception e) {
            return null;
        }
    }

    private String toSlug(String input) {
        String nowhitespace = input.trim().replaceAll("\\s+", "-");
        String normalized = Normalizer.normalize(nowhitespace, Normalizer.Form.NFD)
                .replaceAll("\\p{InCombiningDiacriticalMarks}+", "");
        return normalized.toLowerCase(Locale.ROOT).replaceAll("[^a-z0-9\\-]", "");
    }
}
