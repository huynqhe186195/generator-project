package com.generatorproject.controller.it.product;

import com.generatorproject.dao.BrandDAO;
import com.generatorproject.dao.CategoryDAO;
import com.generatorproject.dao.ProductModelDAO;
import com.generatorproject.model.Brand;
import com.generatorproject.model.Category;
import com.generatorproject.model.ProductModel;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.InputStream;
import java.text.Normalizer;
import java.util.List;

import org.apache.pdfbox.pdmodel.*;
import org.apache.pdfbox.pdmodel.common.PDRectangle;
import org.apache.pdfbox.pdmodel.font.PDType0Font;
import org.apache.pdfbox.pdmodel.font.PDType1Font;
import org.apache.pdfbox.pdmodel.font.PDFont;
import org.apache.pdfbox.pdmodel.PDPageContentStream;

@WebServlet("/it/products/pdf")
public class ProductModelPdfController extends HttpServlet {

    private final ProductModelDAO productModelDAO = new ProductModelDAO();
    private final BrandDAO brandDAO = new BrandDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        Integer id = parseIntOrNull(req.getParameter("id"));
        if (id == null) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing id");
            return;
        }

        ProductModel pm = productModelDAO.findById(id);
        if (pm == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Product model not found");
            return;
        }

        String brandName = lookupBrandName(pm.getBrandId());
        String categoryName = lookupCategoryName(pm.getCategoryId());

        resp.setContentType("application/pdf");
        resp.setCharacterEncoding("UTF-8");
        resp.setHeader("Content-Disposition",
                "inline; filename=\"product-model-" + pm.getId() + ".pdf\"");

        try (PDDocument doc = new PDDocument()) {
            PDPage page = new PDPage(PDRectangle.A4);
            doc.addPage(page);

            FontPack fonts = loadFontPack(req, doc); // ✅ quan trọng

            try (PDPageContentStream cs = new PDPageContentStream(doc, page)) {

                float margin = 50;
                float y = page.getMediaBox().getHeight() - margin;
                float leading = 16;

                y = writeLine(cs, fonts, true, 18, margin, y, 24, "PRODUCT MODEL INFORMATION");

                y = writeLine(cs, fonts, false, 12, margin, y, leading, "ID: " + pm.getId());
                y = writeLine(cs, fonts, false, 12, margin, y, leading, "Name: " + safe(pm.getName()));
                y = writeLine(cs, fonts, false, 12, margin, y, leading, "Slug: " + safe(pm.getSlug()));
                y = writeLine(cs, fonts, false, 12, margin, y, leading, "Brand: " + safe(brandName));
                y = writeLine(cs, fonts, false, 12, margin, y, leading, "Category: " + safe(categoryName));
                y = writeLine(cs, fonts, false, 12, margin, y, leading, "Origin: " + safe(pm.getOrigin()));
                y = writeLine(cs, fonts, false, 12, margin, y, leading, "Fuel type: " + safe(pm.getFuelType()));
                y = writeLine(cs, fonts, false, 12, margin, y, leading, "Power: " + (pm.getPower() == null ? "-" : pm.getPower().toString()));
                y = writeLine(cs, fonts, false, 12, margin, y, leading, "Status: " + safe(pm.getStatus()));
                y = writeLine(cs, fonts, false, 12, margin, y, leading, "Created at: " + (pm.getCreatedAt() == null ? "-" : pm.getCreatedAt().toString()));

                y -= 10;
                y = writeBlock(cs, fonts, 12, margin, y, leading, "Description:", safe(pm.getDescription()));
                y -= 10;
                y = writeBlock(cs, fonts, 12, margin, y, leading, "Specifications:", safe(pm.getSpecifications()));
            }

            doc.save(resp.getOutputStream());
        } catch (Exception e) {
            e.printStackTrace();
            if (!resp.isCommitted()) {
                resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "PDF generation failed: " + e.getMessage());
            }
        }
    }

    // ================= FONT =================

    private static class FontPack {
        PDFont font;
        PDFont fontBold;
        boolean supportsUnicode; // true nếu dùng TTF
    }

    private FontPack loadFontPack(HttpServletRequest req, PDDocument doc) {
        FontPack fp = new FontPack();

        // Ưu tiên Roboto (có tiếng Việt)
        PDFont ttf = tryLoadTTF(req, doc, "/assets/fonts/Roboto-Regular.ttf");
        if (ttf == null) {
            // hoặc bạn đổi sang NotoSans nếu thích
            ttf = tryLoadTTF(req, doc, "/assets/fonts/NotoSans-Regular.ttf");
        }

        if (ttf != null) {
            fp.font = ttf;
            fp.fontBold = ttf; // muốn bold đẹp thì add thêm Roboto-Bold.ttf
            fp.supportsUnicode = true;
            return fp;
        }

        // Fallback: Helvetica (không có tiếng Việt) -> phải strip dấu trước khi ghi
        fp.font = PDType1Font.HELVETICA;
        fp.fontBold = PDType1Font.HELVETICA_BOLD;
        fp.supportsUnicode = false;
        return fp;
    }

    private PDFont tryLoadTTF(HttpServletRequest req, PDDocument doc, String path) {
        try (InputStream is = req.getServletContext().getResourceAsStream(path)) {
            if (is == null) return null;
            return PDType0Font.load(doc, is);
        } catch (Exception e) {
            return null;
        }
    }

    // ================= PDF helpers =================

    private float writeLine(PDPageContentStream cs, FontPack fonts, boolean bold, int size,
                            float x, float y, float leading, String text) throws IOException {
        String out = fonts.supportsUnicode ? text : stripVietnamese(text);

        cs.beginText();
        cs.setFont(bold ? fonts.fontBold : fonts.font, size);
        cs.newLineAtOffset(x, y);
        cs.showText(out);
        cs.endText();
        return y - leading;
    }

    private float writeBlock(PDPageContentStream cs, FontPack fonts, int size,
                             float x, float y, float leading,
                             String title, String content) throws IOException {
        y = writeLine(cs, fonts, true, size, x, y, leading, title);
        String[] lines = splitRough(content, 95);
        for (String line : lines) {
            y = writeLine(cs, fonts, false, size, x + 12, y, leading, line);
        }
        return y;
    }

    private String[] splitRough(String s, int maxLen) {
        if (s == null || s.trim().isEmpty()) return new String[]{"-"};
        s = s.trim();
        java.util.List<String> out = new java.util.ArrayList<>();
        while (s.length() > maxLen) {
            out.add(s.substring(0, maxLen));
            s = s.substring(maxLen);
        }
        out.add(s);
        return out.toArray(new String[0]);
    }

    private String stripVietnamese(String s) {
        if (s == null) return "-";
        String normalized = Normalizer.normalize(s, Normalizer.Form.NFD);
        normalized = normalized.replaceAll("\\p{InCombiningDiacriticalMarks}+", "");
        normalized = normalized.replace("đ", "d").replace("Đ", "D");
        // loại ký tự lạ không thuộc WinAnsi để chắc ăn
        return normalized.replaceAll("[^\\x00-\\x7F]", "");
    }

    private String safe(String s) {
        return (s == null || s.trim().isEmpty()) ? "-" : s.trim();
    }

    // ================= Lookup helpers =================

    private String lookupBrandName(int brandId) {
        List<Brand> brands = brandDAO.getAllBrands();
        for (Brand b : brands) if (b.getId() == brandId) return b.getName();
        return "-";
    }

    private String lookupCategoryName(int categoryId) {
        List<Category> categories = categoryDAO.getAllCategories();
        for (Category c : categories) if (c.getId() == categoryId) return c.getName();
        return "-";
    }

    private Integer parseIntOrNull(String s) {
        try {
            if (s == null || s.trim().isEmpty()) return null;
            return Integer.parseInt(s.trim());
        } catch (Exception e) {
            return null;
        }
    }
}
