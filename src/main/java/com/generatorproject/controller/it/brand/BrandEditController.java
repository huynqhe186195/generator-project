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

@WebServlet("/it/brands/edit")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 10 * 1024 * 1024,
        maxRequestSize = 20 * 1024 * 1024
)
public class BrandEditController extends HttpServlet {

    private final BrandDAO brandDAO = new BrandDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        int id = parseInt(req.getParameter("id"), -1);
        if (id <= 0) {
            resp.sendRedirect(req.getContextPath() + "/it/brands?msg=invalid_id");
            return;
        }

        Brand brand = brandDAO.findById(id);
        if (brand == null) {
            resp.sendRedirect(req.getContextPath() + "/it/brands?msg=not_found");
            return;
        }

        req.setAttribute("brand", brand);
        req.getRequestDispatcher("/views/it/brand/edit.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        int id = parseInt(req.getParameter("id"), -1);
        if (id <= 0) {
            resp.sendRedirect(req.getContextPath() + "/it/brands?msg=invalid_id");
            return;
        }

        Brand old = brandDAO.findById(id);
        if (old == null) {
            resp.sendRedirect(req.getContextPath() + "/it/brands?msg=not_found");
            return;
        }

        String name = trim(req.getParameter("name"));
        String slug = trim(req.getParameter("slug"));
        String logoUrlInput = trim(req.getParameter("logoUrl")); // link (optional)
        String keepLogo = trim(req.getParameter("keepLogo"));    // "1" nếu muốn giữ

        if (name == null) {
            resp.sendRedirect(req.getContextPath() + "/it/brands/edit?id=" + id + "&msg=name_required");
            return;
        }

        if (brandDAO.existsNameExceptId(name, id)) {
            resp.sendRedirect(req.getContextPath() + "/it/brands/edit?id=" + id + "&msg=exists");
            return;
        }

        if (slug == null) slug = toSlug(name);

        // ===== Upload logo nếu có =====
        String finalLogo = old.getLogoUrl(); // mặc định giữ logo cũ

        Part logoFilePart = null;
        try { logoFilePart = req.getPart("logoFile"); } catch (Exception ignore) {}

        if (logoFilePart != null && logoFilePart.getSize() > 0) {
            String submitted = Paths.get(logoFilePart.getSubmittedFileName()).getFileName().toString();
            String ext = getFileExt(submitted);

            if (!isAllowedImageExt(ext)) {
                resp.sendRedirect(req.getContextPath() + "/it/brands/edit?id=" + id + "&msg=invalid_image");
                return;
            }

            String uploadDirAbs = req.getServletContext().getRealPath("/uploads/brands");
            File dir = new File(uploadDirAbs);
            if (!dir.exists()) dir.mkdirs();

            String safeBase = toSlug(removeExt(submitted));
            if (safeBase == null) safeBase = "brand";
            String fileName = safeBase + "-" + UUID.randomUUID().toString().replace("-", "") + "." + ext;

            File saved = new File(dir, fileName);
            logoFilePart.write(saved.getAbsolutePath());

            finalLogo = "uploads/brands/" + fileName;
        } else {
            // không upload file
            // clear logo
            if ("1".equals(keepLogo)) {
                finalLogo = old.getLogoUrl(); // giữ
            } else finalLogo = logoUrlInput;     // đổi sang link / path nhập tay
        }

        Brand updated = new Brand();
        updated.setId(id);
        updated.setName(name);
        updated.setSlug(slug);
        updated.setLogoUrl(finalLogo);

        boolean ok = brandDAO.update(updated);
        if (!ok) {
            resp.sendRedirect(req.getContextPath() + "/it/brands/edit?id=" + id + "&msg=failed");
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/it/brands/detail?id=" + id + "&msg=updated");
    }

    // ===== helpers =====
    private String trim(String s) {
        if (s == null) return null;
        s = s.trim();
        return s.isEmpty() ? null : s;
    }

    private int parseInt(String s, int def) {
        try { return Integer.parseInt(s); } catch (Exception e) { return def; }
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