package com.generatorproject.controller.it.product;

import com.generatorproject.dao.BrandDAO;
import com.generatorproject.dao.CategoryDAO;
import com.generatorproject.dao.ProductModelDAO;
import com.generatorproject.model.Brand;
import com.generatorproject.model.Category;
import com.generatorproject.model.ProductModel;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.IOException;
import java.io.InputStream;
import java.text.Normalizer;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

@WebServlet("/it/products/import-excel")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 50 * 1024 * 1024,
        maxRequestSize = 80 * 1024 * 1024
)
public class ProductModelImportExcelController extends HttpServlet {

    private final ProductModelDAO productModelDAO = new ProductModelDAO();
    private final BrandDAO brandDAO = new BrandDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        Part excelPart = req.getPart("excelFile");
        if (excelPart == null || excelPart.getSize() == 0) {
            resp.sendRedirect(req.getContextPath() + "/it/products?msg=import_invalid_file");
            return;
        }

        String fileName = excelPart.getSubmittedFileName();
        String lower = fileName == null ? "" : fileName.toLowerCase(Locale.ROOT);
        if (!(lower.endsWith(".xlsx") || lower.endsWith(".xls"))) {
            resp.sendRedirect(req.getContextPath() + "/it/products?msg=import_invalid_file");
            return;
        }

        int createdCount = 0;
        try (InputStream is = excelPart.getInputStream();
             Workbook workbook = WorkbookFactory.create(is)) {

            Sheet sheet = workbook.getNumberOfSheets() > 0 ? workbook.getSheetAt(0) : null;
            if (sheet == null) {
                resp.sendRedirect(req.getContextPath() + "/it/products?msg=import_error");
                return;
            }

            DataFormatter formatter = new DataFormatter();
            Map<String, Integer> col = buildColumnMap(sheet, formatter);
            int startRow = hasHeaderRow(sheet, formatter) ? 1 : 0;

            for (int i = startRow; i <= sheet.getLastRowNum(); i++) {
                Row row = sheet.getRow(i);
                if (row == null) continue;

                String name = trim(readByKey(row, col, "name", 0, formatter));
                String brandRaw = trim(readByKey(row, col, "brand", 1, formatter));
                String categoryRaw = trim(readByKey(row, col, "category", 2, formatter));
                String origin = trim(readByKey(row, col, "origin", 3, formatter));
                String fuelType = normalizeFuelType(readByKey(row, col, "fueltype", 4, formatter));
                Double power = parseDouble(readByKey(row, col, "power", 5, formatter));
                String description = trim(readByKey(row, col, "description", 6, formatter));
                String specifications = trim(readByKey(row, col, "specifications", 7, formatter));
                String manualUrl = trim(readByKey(row, col, "manualurl", 8, formatter));
                String imageUrl = trim(readByKey(row, col, "imageurl", 9, formatter));
                String status = normalizeStatus(readByKey(row, col, "status", 10, formatter));

                if (name == null || brandRaw == null || categoryRaw == null || fuelType == null) {
                    continue;
                }

                Brand brand = resolveBrand(brandRaw);
                Category category = resolveCategory(categoryRaw);
                if (brand == null || category == null) {
                    continue;
                }

                ProductModel existed = productModelDAO.findByName(name);
                if (existed != null) {
                    continue;
                }

                ProductModel model = new ProductModel.Builder()
                        .setName(name)
                        .setSlug(toSlug(name))
                        .setBrandId(brand.getId())
                        .setCategoryId(category.getId())
                        .setOrigin(origin)
                        .setFuelType(fuelType)
                        .setPower(power)
                        .setDescription(description)
                        .setSpecifications(specifications)
                        .setManualUrl(manualUrl)
                        .setImageUrl(imageUrl)
                        .setStatus(status != null ? status : "COMING_SOON")
                        .build();

                Long newId = productModelDAO.insertProductModel(model);
                if (newId != null) createdCount++;
            }

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/it/products?msg=import_error");
            return;
        }

        if (createdCount == 0) {
            resp.sendRedirect(req.getContextPath() + "/it/products?msg=import_empty");
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/it/products?msg=import_success&count=" + createdCount);
    }

    private Map<String, Integer> buildColumnMap(Sheet sheet, DataFormatter formatter) {
        Map<String, Integer> map = new HashMap<>();
        Row row0 = sheet.getRow(0);
        if (row0 == null) return map;

        for (int i = 0; i < row0.getLastCellNum(); i++) {
            String key = normalizeHeader(readCell(row0, i, formatter));
            if (key == null) continue;

            if ("name".equals(key)) map.put("name", i);
            else if ("brandname".equals(key) || "brand".equals(key) || "brandid".equals(key)) map.put("brand", i);
            else if ("categoryname".equals(key) || "category".equals(key) || "categoryid".equals(key)) map.put("category", i);
            else if ("origin".equals(key)) map.put("origin", i);
            else if ("fueltype".equals(key) || "fuel".equals(key)) map.put("fueltype", i);
            else if ("power".equals(key)) map.put("power", i);
            else if ("description".equals(key)) map.put("description", i);
            else if ("specifications".equals(key) || "specification".equals(key)) map.put("specifications", i);
            else if ("manualurl".equals(key) || "manual".equals(key)) map.put("manualurl", i);
            else if ("imageurl".equals(key) || "image".equals(key)) map.put("imageurl", i);
            else if ("status".equals(key)) map.put("status", i);
        }

        return map;
    }

    private boolean hasHeaderRow(Sheet sheet, DataFormatter formatter) {
        Row row0 = sheet.getRow(0);
        if (row0 == null) return false;
        String c0 = normalizeHeader(readCell(row0, 0, formatter));
        String c1 = normalizeHeader(readCell(row0, 1, formatter));
        String c2 = normalizeHeader(readCell(row0, 2, formatter));
        return "name".equals(c0) || "brand".equals(c1) || "brandname".equals(c1) || "category".equals(c2) || "categoryname".equals(c2);
    }

    private String readByKey(Row row, Map<String, Integer> colMap, String key, int defaultIndex, DataFormatter formatter) {
        Integer idx = colMap.get(key);
        if (idx != null) return readCell(row, idx, formatter);
        return readCell(row, defaultIndex, formatter);
    }

    private Brand resolveBrand(String brandRaw) {
        Brand brand = brandDAO.findByName(brandRaw);
        if (brand != null) return brand;

        Integer id = parseInt(brandRaw);
        if (id != null) {
            return brandDAO.findById(id);
        }

        String target = normalizeForCompare(brandRaw);
        for (Brand b : brandDAO.getAllBrands()) {
            if (normalizeForCompare(b.getName()).equals(target)) return b;
        }
        return null;
    }

    private Category resolveCategory(String categoryRaw) {
        Category category = categoryDAO.findByName(categoryRaw);
        if (category != null) return category;

        Integer id = parseInt(categoryRaw);
        if (id != null) {
            return categoryDAO.findById(id);
        }

        String target = normalizeForCompare(categoryRaw);
        for (Category c : categoryDAO.getAllCategories()) {
            if (normalizeForCompare(c.getName()).equals(target)) return c;
        }
        return null;
    }

    private String readCell(Row row, int index, DataFormatter formatter) {
        Cell cell = row.getCell(index, Row.MissingCellPolicy.RETURN_BLANK_AS_NULL);
        if (cell == null) return null;
        return formatter.formatCellValue(cell);
    }

    private String normalizeHeader(String text) {
        text = trim(text);
        if (text == null) return null;
        return text.toLowerCase(Locale.ROOT).replaceAll("[^a-z0-9]", "");
    }

    private String normalizeForCompare(String value) {
        value = trim(value);
        if (value == null) return "";
        String normalized = Normalizer.normalize(value, Normalizer.Form.NFD)
                .replaceAll("\\p{InCombiningDiacriticalMarks}+", "");
        return normalized.toLowerCase(Locale.ROOT).replaceAll("\\s+", " ").trim();
    }

    private String trim(String value) {
        if (value == null) return null;
        value = value.trim();
        return value.isEmpty() ? null : value;
    }

    private String normalizeFuelType(String value) {
        String normalized = trim(value);
        if (normalized == null) return null;
        normalized = normalized.toUpperCase(Locale.ROOT);
        return ("DIESEL".equals(normalized) || "GASOLINE".equals(normalized) || "OTHER".equals(normalized)) ? normalized : null;
    }

    private String normalizeStatus(String value) {
        String normalized = trim(value);
        if (normalized == null) return null;
        normalized = normalized.toUpperCase(Locale.ROOT);
        return ("ACTIVE".equals(normalized) || "INACTIVE".equals(normalized) || "COMING_SOON".equals(normalized)) ? normalized : null;
    }

    private Integer parseInt(String value) {
        try {
            return value == null || value.isBlank() ? null : Integer.parseInt(value.trim());
        } catch (Exception e) {
            return null;
        }
    }

    private Double parseDouble(String value) {
        try {
            return value == null || value.isBlank() ? null : Double.parseDouble(value.trim());
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
