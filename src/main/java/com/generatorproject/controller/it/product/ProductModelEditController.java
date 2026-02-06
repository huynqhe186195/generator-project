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
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.UUID;

@WebServlet(urlPatterns = {"/it/products/edit"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 15 * 1024 * 1024,
        maxRequestSize = 25 * 1024 * 1024
)
public class ProductModelEditController extends HttpServlet {

    private final ProductModelDAO productModelDAO = new ProductModelDAO();
    private final BrandDAO brandDAO = new BrandDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final ProductImageDAO productImageDAO = new ProductImageDAO(); // ✅ thêm

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        Integer id = parseIntOrNull(req.getParameter("id"));
        if (id == null) {
            resp.sendRedirect(req.getContextPath() + "/it/products");
            return;
        }

        ProductModel pm = productModelDAO.findById(id);
        if (pm == null) {
            resp.sendRedirect(req.getContextPath() + "/it/products");
            return;
        }

        List<Brand> brands = brandDAO.getAllBrands();
        List<Category> categories = categoryDAO.getAllCategories();

        req.setAttribute("pm", pm);
        req.setAttribute("brands", brands);
        req.setAttribute("categories", categories);

        // ✅ load gallery images
        req.setAttribute("images", productImageDAO.findByModelId(id));

        req.getRequestDispatcher("/views/it/product/edit.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        Integer id = parseIntOrNull(req.getParameter("id"));
        if (id == null) {
            resp.sendRedirect(req.getContextPath() + "/it/products");
            return;
        }

        ProductModel old = productModelDAO.findById(id);
        if (old == null) {
            resp.sendRedirect(req.getContextPath() + "/it/products");
            return;
        }

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

        // ✅ validate tối thiểu
        String error = null;
        if (name == null) error = "Tên không được để trống";
        else if (brandId == null) error = "Vui lòng chọn Brand";
        else if (categoryId == null) error = "Vui lòng chọn Category";
        else if (fuelType == null) error = "Vui lòng chọn Fuel type";
        else if (status == null) error = "Vui lòng chọn Status";

        if (error != null) {
            req.setAttribute("error", error);
            req.setAttribute("pm", old);
            req.setAttribute("brands", brandDAO.getAllBrands());
            req.setAttribute("categories", categoryDAO.getAllCategories());
            req.setAttribute("images", productImageDAO.findByModelId(id));
            req.getRequestDispatcher("/views/it/product/edit.jsp").forward(req, resp);
            return;
        }

        // ✅ ảnh đại diện: nếu không upload mới thì giữ cũ
        String newThumb = saveUploadFile(req, "imageFile", "/uploads/product-models", false);
        String imageUrl = (newThumb != null) ? newThumb : old.getImageUrl();

        // ✅ update product_models
        ProductModel updated = new ProductModel.Builder()
                .setId(id)
                .setName(name)
                .setSlug(slug)
                .setBrandId(brandId)
                .setCategoryId(categoryId)
                .setOrigin(origin)
                .setFuelType(fuelType)
                .setPower(power)
                .setDescription(description)
                .setSpecifications(specifications)
                .setManualUrl(old.getManualUrl()) // PDF xuất động => giữ nguyên hoặc null tuỳ bạn
                .setImageUrl(imageUrl)           // thumbnail
                .setStatus(status)
                .build();

        productModelDAO.updateProductModel(updated);

        // ✅ xoá ảnh gallery được tick
        String[] deleteIds = req.getParameterValues("deleteImageIds");
        if (deleteIds != null) {
            for (String s : deleteIds) {
                Integer imgId = parseIntOrNull(s);
                if (imgId != null) {
                    productImageDAO.deleteByIdAndModelId(imgId, id);
                }
            }
        }

        // ✅ upload thêm nhiều ảnh gallery
        List<String> newGalleryUrls = saveUploadFiles(req, "imageFiles", "/uploads/product-models");
        if (newGalleryUrls != null) {
            for (String url : newGalleryUrls) {
                productImageDAO.insertImage(id, url);
            }
        }

        // quay lại edit để thấy ảnh mới/xoá ngay
        resp.sendRedirect(req.getContextPath() + "/it/products/edit?id=" + id);
    }

    // ================= helpers =================

    private String saveUploadFile(HttpServletRequest req, String partName, String folder, boolean pdfOnly)
            throws IOException, ServletException {

        Part part = req.getPart(partName);
        if (part == null || part.getSize() == 0) return null;

        String original = Paths.get(part.getSubmittedFileName()).getFileName().toString();
        String ext = "";
        int dot = original.lastIndexOf('.');
        if (dot >= 0) ext = original.substring(dot).toLowerCase();

        if (pdfOnly && !".pdf".equals(ext)) return null;

        // ✅ nếu là ảnh đại diện thì cũng chặn định dạng ảnh cơ bản
        if (!pdfOnly) {
            if (!(ext.equals(".png") || ext.equals(".jpg") || ext.equals(".jpeg") || ext.equals(".webp"))) return null;
        }

        String newName = UUID.randomUUID() + ext;

        String uploadDir = req.getServletContext().getRealPath(folder);
        File dir = new File(uploadDir);
        if (!dir.exists()) dir.mkdirs();

        part.write(uploadDir + File.separator + newName);

        return folder.substring(1) + "/" + newName; // uploads/...
    }

    // ✅ upload nhiều ảnh
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
            if (!(ext.equals(".png") || ext.equals(".jpg") || ext.equals(".jpeg") || ext.equals(".webp"))) continue;

            String newName = UUID.randomUUID() + ext;

            String uploadDir = req.getServletContext().getRealPath(folder);
            File dir = new File(uploadDir);
            if (!dir.exists()) dir.mkdirs();

            part.write(uploadDir + File.separator + newName);

            urls.add(folder.substring(1) + "/" + newName);
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
