package com.generatorproject.controller.it;

import com.generatorproject.dao.BrandDAO;
import com.generatorproject.dao.CategoryDAO;
import com.generatorproject.dao.ProductModelDAO;
import com.generatorproject.dao.RequestDAO;
import com.generatorproject.model.Brand;
import com.generatorproject.model.Category;
import com.generatorproject.model.ProductModel;
import com.generatorproject.model.SystemRequest;
import com.generatorproject.model.Users;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.lang.reflect.Type;
import java.text.Normalizer;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet(urlPatterns = {"/it/requests"})
public class ITProductRequestController extends HttpServlet {

    private static final List<String> ALLOWED_FUEL_TYPES = Arrays.asList("DIESEL", "GASOLINE", "OTHER");
    private static final List<String> ALLOWED_STATUSES = Arrays.asList("ACTIVE", "INACTIVE", "COMING_SOON");

    private final RequestDAO requestDAO = new RequestDAO();
    private final ProductModelDAO productModelDAO = new ProductModelDAO();
    private final BrandDAO brandDAO = new BrandDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Users user = (Users) req.getSession().getAttribute("USERMODEL");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/account/login");
            return;
        }

        List<SystemRequest> requests = requestDAO.findByReceiverRole("IT", "PENDING")
                .stream()
                .filter(r -> "NEW_PRODUCT".equalsIgnoreCase(r.getRequestType()))
                .collect(Collectors.toList());
        req.setAttribute("requests", requests);
        req.getRequestDispatcher("/views/it/request-list.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.setCharacterEncoding("UTF-8");

        Users user = (Users) req.getSession().getAttribute("USERMODEL");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/account/login");
            return;
        }

        String action = req.getParameter("action");
        Long requestId = parseLong(req.getParameter("requestId"));
        if (requestId == null) {
            resp.sendRedirect(req.getContextPath() + "/it/requests?msg=error");
            return;
        }

        SystemRequest request = requestDAO.findById(requestId);
        if (request == null || !"NEW_PRODUCT".equalsIgnoreCase(request.getRequestType())) {
            resp.sendRedirect(req.getContextPath() + "/it/requests?msg=not_found");
            return;
        }

        try {
            if ("approve".equalsIgnoreCase(action)) {
                handleApprove(request);
            } else if ("reject".equalsIgnoreCase(action)) {
                String reason = req.getParameter("responseMessage");
                if (reason == null || reason.isBlank()) {
                    reason = "IT từ chối thêm sản phẩm.";
                }
                request.setStatus("REJECTED");
                request.setResponseMessage(reason.trim());
                requestDAO.update(request);
            } else {
                resp.sendRedirect(req.getContextPath() + "/it/requests?msg=error");
                return;
            }

            resp.sendRedirect(req.getContextPath() + "/it/requests?msg=success");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/it/requests?msg=error");
        }
    }

    private void handleApprove(SystemRequest request) {
        Type type = new TypeToken<Map<String, Object>>() {
        }.getType();
        Map<String, Object> data = gson.fromJson(request.getRequestData(), type);
        if (data == null) data = new HashMap<>();

        String excelFileUrl = trim(asText(data.get("excelFileUrl")));
        if (excelFileUrl == null) {
            throw new IllegalArgumentException("Thiếu file excel của request NEW_PRODUCT");
        }

        String excelAbsolutePath = getServletContext().getRealPath("/" + excelFileUrl);
        File excelFile = new File(excelAbsolutePath);
        if (!excelFile.exists()) {
            throw new IllegalArgumentException("Không tìm thấy file excel: " + excelFileUrl);
        }

        int createdCount = 0;
        DataFormatter formatter = new DataFormatter();

        try (FileInputStream fis = new FileInputStream(excelFile);
             Workbook workbook = WorkbookFactory.create(fis)) {

            Sheet sheet = workbook.getNumberOfSheets() > 0 ? workbook.getSheetAt(0) : null;
            if (sheet == null) {
                throw new IllegalArgumentException("File excel không có sheet dữ liệu");
            }

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
                if (newId != null) {
                    createdCount++;
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Không đọc được file excel để tạo product", e);
        }

        if (createdCount == 0) {
            request.setStatus("REJECTED");
            request.setResponseMessage("Không tạo được product nào từ file excel (kiểm tra cột dữ liệu/hệ thống brand/category)");
            requestDAO.update(request);
            return;
        }

        request.setStatus("APPROVED");
        request.setResponseMessage("IT đã tạo " + createdCount + " product từ file excel.");
        requestDAO.update(request);
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
        if (idx != null) {
            return readCell(row, idx, formatter);
        }
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
            if (normalizeForCompare(b.getName()).equals(target)) {
                return b;
            }
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
            if (normalizeForCompare(c.getName()).equals(target)) {
                return c;
            }
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

    private String asText(Object value) {
        return value == null ? null : String.valueOf(value);
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
        return ALLOWED_FUEL_TYPES.contains(normalized) ? normalized : null;
    }

    private String normalizeStatus(String value) {
        String normalized = trim(value);
        if (normalized == null) return null;
        normalized = normalized.toUpperCase(Locale.ROOT);
        return ALLOWED_STATUSES.contains(normalized) ? normalized : null;
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

    private Long parseLong(String value) {
        try {
            return value == null || value.isBlank() ? null : Long.parseLong(value.trim());
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
