package com.generatorproject.controller.it.brand;

import com.generatorproject.dao.BrandDAO;
import com.generatorproject.model.Brand;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.text.Normalizer;
import java.util.Locale;
import java.util.UUID;

@WebServlet("/it/brands/create.jsp")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,      // 1MB
        maxFileSize = 10 * 1024 * 1024,       // 10MB
        maxRequestSize = 20 * 1024 * 1024     // 20MB
)
public class BrandAddController extends HttpServlet {

    private final BrandDAO brandDAO = new BrandDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        req.getRequestDispatcher("/views/it/brand/create.jsp.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String name = trim(req.getParameter("name"));
        String slug = trim(req.getParameter("slug"));
        String logoUrlInput = trim(req.getParameter("logoUrl")); // link (optional)

        if (name == null) {
            resp.sendRedirect(req.getContextPath() + "/it/brands/create.jsp?msg=name_required");
            return;
        }

        if (brandDAO.findByName(name) != null) {
            resp.sendRedirect(req.getContextPath() + "/it/brands/create.jsp?msg=exists");
            return;
        }

        if (slug == null) slug = toSlug(name);

        // ====== handle upload file ======
        String logoPathToSave = null; // lưu vào DB (relative path)
        Part logoFilePart = null;
        try {
            logoFilePart = req.getPart("logoFile");
        } catch (Exception ignore) {}

        if (logoFilePart != null && logoFilePart.getSize() > 0) {
            String submitted = Paths.get(logoFilePart.getSubmittedFileName()).getFileName().toString();
            String ext = getFileExt(submitted);

            if (!isAllowedImageExt(ext)) {
                resp.sendRedirect(req.getContextPath() + "/it/brands/create.jsp?msg=invalid_image");
                return;
            }

            // folder uploads/brands trong webapp
            String uploadDirAbs = req.getServletContext().getRealPath("/uploads/brands");
            File dir = new File(uploadDirAbs);
            if (!dir.exists()) dir.mkdirs();

            String safeBase = toSlug(removeExt(submitted));
            if (safeBase == null) safeBase = "brand";
            String fileName = safeBase + "-" + UUID.randomUUID().toString().replace("-", "") + "." + ext;

            File saved = new File(dir, fileName);
            logoFilePart.write(saved.getAbsolutePath());

            // đường dẫn lưu DB (để JSP <img src="${ctx}/${logo_url}">)
            logoPathToSave = "uploads/brands/" + fileName;
        } else if (logoUrlInput != null) {
            // nếu không upload file thì dùng link nhập tay
            logoPathToSave = logoUrlInput;
        }

        Brand b = new Brand();
        b.setName(name);
        b.setSlug(slug);
        b.setLogoUrl(logoPathToSave);

        int newId = brandDAO.insert(b);
        if (newId <= 0) {
            resp.sendRedirect(req.getContextPath() + "/it/brands/create.jsp?msg=failed");
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/it/brands?msg=brand_add_success");
    }

    // ===== helpers =====
    private String trim(String s) {
        if (s == null) return null;
        s = s.trim();
        return s.isEmpty() ? null : s;
    }

    private String toSlug(String input) {
        if (input == null) return null;
        String nowhitespace = input.trim().replaceAll("\\s+", "-");
        String normalized = Normalizer.normalize(nowhitespace, Normalizer.Form.NFD)
                .replaceAll("\\p{InCombiningDiacriticalMarks}+", "");
        return normalized.toLowerCase(Locale.ROOT).replaceAll("[^a-z0-9\\-]", "");
    }

    private String getFileExt(String filename) {
        if (filename == null) return "";
        int dot = filename.lastIndexOf('.');
        if (dot < 0) return "";
        return filename.substring(dot + 1).toLowerCase(Locale.ROOT);
    }

    private String removeExt(String filename) {
        if (filename == null) return null;
        int dot = filename.lastIndexOf('.');
        if (dot < 0) return filename;
        return filename.substring(0, dot);
    }

    private boolean isAllowedImageExt(String ext) {
        return "png".equals(ext) || "jpg".equals(ext) || "jpeg".equals(ext) || "webp".equals(ext);
    }
}