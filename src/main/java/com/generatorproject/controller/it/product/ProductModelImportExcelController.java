package com.generatorproject.controller.it.product;

import com.generatorproject.dao.BrandDAO;
import com.generatorproject.dao.CategoryDAO;
import com.generatorproject.dao.ProductModelDAO;
import com.generatorproject.dao.ProductImageDAO;
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
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URLEncoder;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.text.Normalizer;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.UUID;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@WebServlet("/it/products/import-excel")
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 50 * 1024 * 1024, maxRequestSize = 80 * 1024 * 1024)
public class ProductModelImportExcelController extends HttpServlet {

    private final ProductModelDAO productModelDAO = new ProductModelDAO();
    private final ProductImageDAO productImageDAO = new ProductImageDAO();
    private final BrandDAO brandDAO = new BrandDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    private static final Pattern IMG_SRC_PATTERN = Pattern.compile("src\\s*=\\s*[\"\']([^\"\']+)[\"\']",
            Pattern.CASE_INSENSITIVE);

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
        int invalidRequiredCount = 0;
        int invalidBrandCategoryCount = 0;
        int duplicateCount = 0;
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
                if (row == null || isRowBlank(row, formatter))
                    continue;

                String name = trim(readByKey(row, col, "name", 0, formatter));
                String brandRaw = trim(readByKey(row, col, "brand", 1, formatter));
                String categoryRaw = trim(readByKey(row, col, "category", 2, formatter));
                String origin = trim(readByKey(row, col, "origin", 3, formatter));
                String fuelType = normalizeFuelType(readByKey(row, col, "fueltype", 4, formatter));
                Double power = parseDouble(readByKey(row, col, "power", 5, formatter));
                String description = trim(readByKey(row, col, "description", 6, formatter));
                String specifications = trim(readByKey(row, col, "specifications", 7, formatter));
                String manualUrl = trim(readByKey(row, col, "manualurl", 8, formatter));
                String imageUrlRaw = trim(readByKey(row, col, "imageurl", 9, formatter));
                java.util.List<String> imageCandidates = parseImageCandidates(imageUrlRaw);
                java.util.List<String> normalizedImages = new ArrayList<>();
                for (String candidate : imageCandidates) {
                    String normalizedImage = normalizeAndPersistImageUrl(req, candidate);
                    if (normalizedImage != null && !normalizedImage.isEmpty()) {
                        normalizedImages.add(normalizedImage);
                    }
                }
                String imageUrl = normalizedImages.isEmpty() ? null : normalizedImages.get(0);
                String status = normalizeStatus(readByKey(row, col, "status", 10, formatter));

                if (name == null || brandRaw == null || categoryRaw == null) {
                    invalidRequiredCount++;
                    continue;
                }
                if (fuelType == null)
                    fuelType = "OTHER";

                Brand brand = resolveBrand(brandRaw);
                Category category = resolveCategory(categoryRaw);
                if (brand == null || category == null) {
                    invalidBrandCategoryCount++;
                    continue;
                }

                ProductModel existed = productModelDAO.findByName(name);
                if (existed != null) {
                    duplicateCount++;
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
                    int modelId = newId.intValue();
                    Set<String> inserted = new HashSet<>();
                    for (String image : normalizedImages) {
                        if (inserted.add(image)) {
                            productImageDAO.insertImage(modelId, image);
                        }
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/it/products?msg=import_error");
            return;
        }

        if (createdCount == 0) {
            String detail = "required=" + invalidRequiredCount
                    + ",brandCategory=" + invalidBrandCategoryCount
                    + ",duplicate=" + duplicateCount;
            String encoded = URLEncoder.encode(detail, StandardCharsets.UTF_8.name());
            resp.sendRedirect(req.getContextPath() + "/it/products?msg=import_empty&detail=" + encoded);
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/it/products?msg=import_success&count=" + createdCount);
    }

    private Map<String, Integer> buildColumnMap(Sheet sheet, DataFormatter formatter) {
        Map<String, Integer> map = new HashMap<>();
        Row row0 = sheet.getRow(0);
        if (row0 == null)
            return map;

        for (int i = 0; i < row0.getLastCellNum(); i++) {
            String key = normalizeHeader(readCell(row0, i, formatter));
            if (key == null)
                continue;

            if ("name".equals(key) || "ten".equals(key) || "tensanpham".equals(key))
                map.put("name", i);
            else if ("brandname".equals(key) || "brand".equals(key) || "brandid".equals(key) || "hang".equals(key)
                    || "thuonghieu".equals(key))
                map.put("brand", i);
            else if ("categoryname".equals(key) || "category".equals(key) || "categoryid".equals(key)
                    || "danhmuc".equals(key) || "loai".equals(key))
                map.put("category", i);
            else if ("origin".equals(key) || "xuatxu".equals(key))
                map.put("origin", i);
            else if ("fueltype".equals(key) || "fuel".equals(key) || "nhienlieu".equals(key))
                map.put("fueltype", i);
            else if ("power".equals(key) || "congsuat".equals(key))
                map.put("power", i);
            else if ("description".equals(key) || "mota".equals(key))
                map.put("description", i);
            else if ("specifications".equals(key) || "specification".equals(key) || "thongsokythuat".equals(key))
                map.put("specifications", i);
            else if ("manualurl".equals(key) || "manual".equals(key) || "tailieuhuongdan".equals(key))
                map.put("manualurl", i);
            else if ("imageurl".equals(key) || "image".equals(key) || "hinhanh".equals(key) || "anh".equals(key))
                map.put("imageurl", i);
            else if ("status".equals(key) || "trangthai".equals(key))
                map.put("status", i);
        }

        return map;
    }

    private boolean hasHeaderRow(Sheet sheet, DataFormatter formatter) {
        Row row0 = sheet.getRow(0);
        if (row0 == null)
            return false;
        String c0 = normalizeHeader(readCell(row0, 0, formatter));
        String c1 = normalizeHeader(readCell(row0, 1, formatter));
        String c2 = normalizeHeader(readCell(row0, 2, formatter));
        return "name".equals(c0) || "ten".equals(c0) || "brand".equals(c1) || "brandname".equals(c1)
                || "hang".equals(c1) || "category".equals(c2) || "categoryname".equals(c2) || "danhmuc".equals(c2);
    }

    private String readByKey(Row row, Map<String, Integer> colMap, String key, int defaultIndex,
            DataFormatter formatter) {
        Integer idx = colMap.get(key);
        if (idx != null)
            return readCell(row, idx, formatter);
        return readCell(row, defaultIndex, formatter);
    }

    private Brand resolveBrand(String brandRaw) {
        Brand brand = brandDAO.findByName(brandRaw);
        if (brand != null)
            return brand;

        Integer id = parseIntFlexible(brandRaw);
        if (id != null) {
            return brandDAO.findById(id);
        }

        String target = normalizeForCompare(brandRaw);
        for (Brand b : brandDAO.getAllBrands()) {
            String bn = normalizeForCompare(b.getName());
            if (bn.equals(target) || bn.contains(target) || target.contains(bn))
                return b;
        }
        return null;
    }

    private Category resolveCategory(String categoryRaw) {
        Category category = categoryDAO.findByName(categoryRaw);
        if (category != null)
            return category;

        Integer id = parseIntFlexible(categoryRaw);
        if (id != null) {
            return categoryDAO.findById(id);
        }

        String target = normalizeForCompare(categoryRaw);
        for (Category c : categoryDAO.getAllCategories()) {
            String cn = normalizeForCompare(c.getName());
            if (cn.equals(target) || cn.contains(target) || target.contains(cn))
                return c;
        }
        return null;
    }

    private String readCell(Row row, int index, DataFormatter formatter) {
        Cell cell = row.getCell(index, Row.MissingCellPolicy.RETURN_BLANK_AS_NULL);
        if (cell == null)
            return null;
        return formatter.formatCellValue(cell);
    }

    private boolean isRowBlank(Row row, DataFormatter formatter) {
        int max = Math.max(11, row.getLastCellNum());
        for (int i = 0; i < max; i++) {
            String v = trim(readCell(row, i, formatter));
            if (v != null)
                return false;
        }
        return true;
    }

    private String normalizeHeader(String text) {
        text = trim(text);
        if (text == null)
            return null;
        String normalized = Normalizer.normalize(text, Normalizer.Form.NFD)
                .replaceAll("\\p{InCombiningDiacriticalMarks}+", "");
        return normalized.toLowerCase(Locale.ROOT).replaceAll("[^a-z0-9]", "");
    }

    private String normalizeForCompare(String value) {
        value = trim(value);
        if (value == null)
            return "";
        String normalized = Normalizer.normalize(value, Normalizer.Form.NFD)
                .replaceAll("\\p{InCombiningDiacriticalMarks}+", "");
        return normalized.toLowerCase(Locale.ROOT).replaceAll("[^a-z0-9\\s]", " ").replaceAll("\\s+", " ").trim();
    }

    private String trim(String value) {
        if (value == null)
            return null;
        value = value.trim();
        return value.isEmpty() ? null : value;
    }

    private String normalizeFuelType(String value) {
        String normalized = trim(value);
        if (normalized == null)
            return null;
        normalized = normalized.toUpperCase(Locale.ROOT);
        if (normalized.contains("DIESEL") || normalized.contains("DO"))
            return "DIESEL";
        if (normalized.contains("GASOLINE") || normalized.contains("GAS") || normalized.contains("XANG"))
            return "GASOLINE";
        if (normalized.contains("OTHER") || normalized.contains("KHAC"))
            return "OTHER";
        return null;
    }

    private String normalizeStatus(String value) {
        String normalized = trim(value);
        if (normalized == null)
            return null;
        normalized = normalized.toUpperCase(Locale.ROOT);
        if ("ACTIVE".equals(normalized) || "HOATDONG".equals(normalized))
            return "ACTIVE";
        if ("INACTIVE".equals(normalized) || "NGUNGHOATDONG".equals(normalized))
            return "INACTIVE";
        if ("COMING_SOON".equals(normalized) || "COMINGSOON".equals(normalized) || "SAPRAMAT".equals(normalized))
            return "COMING_SOON";
        return null;
    }

    private java.util.List<String> parseImageCandidates(String rawImageUrl) {
        java.util.List<String> result = new ArrayList<>();
        String value = trim(rawImageUrl);
        if (value == null)
            return result;

        if (value.toLowerCase(Locale.ROOT).contains("<img")) {
            Matcher matcher = IMG_SRC_PATTERN.matcher(value);
            while (matcher.find()) {
                String src = trim(matcher.group(1));
                if (src != null) {
                    result.add(src);
                }
            }
            if (!result.isEmpty())
                return result;
        }

        String normalized = value.replace("\r", "\n");
        String[] parts = normalized.split("\n|;|\\|");
        for (String part : parts) {
            String item = trim(part);
            if (item != null) {
                result.add(item);
            }
        }

        if (result.isEmpty()) {
            result.add(value);
        }
        return result;
    }

    private String normalizeAndPersistImageUrl(HttpServletRequest req, String rawImageUrl) {
        String value = trim(rawImageUrl);
        if (value == null)
            return null;

        value = extractSrcIfHtml(value);
        value = value.replace("\\", "/").trim();

        if (value.startsWith("data:image")) {
            return value;
        }

        if (value.startsWith("http://") || value.startsWith("https://")) {
            String downloaded = downloadImageToUploads(req, value);
            return downloaded != null ? downloaded : value;
        }

        if (value.startsWith("//")) {
            String httpUrl = "https:" + value;
            String downloaded = downloadImageToUploads(req, httpUrl);
            return downloaded != null ? downloaded : httpUrl;
        }

        if (value.startsWith("/")) {
            return value.substring(1);
        }

        if (value.startsWith("uploads/")) {
            return value;
        }

        if (value.startsWith("product-images/")) {
            return "uploads/" + value;
        }

        if (isImageFileName(value)) {
            return "uploads/product-images/" + value;
        }

        return null;
    }

    private String extractSrcIfHtml(String value) {
        if (value == null)
            return null;
        if (!value.toLowerCase(Locale.ROOT).contains("<img"))
            return value;
        Matcher matcher = IMG_SRC_PATTERN.matcher(value);
        if (matcher.find()) {
            return matcher.group(1);
        }
        return value;
    }

    private boolean isImageFileName(String value) {
        String lower = value.toLowerCase(Locale.ROOT);
        return lower.endsWith(".jpg") || lower.endsWith(".jpeg") || lower.endsWith(".png")
                || lower.endsWith(".webp") || lower.endsWith(".gif") || lower.endsWith(".bmp")
                || lower.endsWith(".svg");
    }

    private String downloadImageToUploads(HttpServletRequest req, String sourceUrl) {
        HttpURLConnection connection = null;
        try {
            URL url = new URL(sourceUrl);
            connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("GET");
            connection.setConnectTimeout(8000);
            connection.setReadTimeout(8000);
            connection.setInstanceFollowRedirects(true);

            int code = connection.getResponseCode();
            if (code < 200 || code >= 300) {
                return null;
            }

            String contentType = connection.getContentType();
            if (contentType == null || !contentType.toLowerCase(Locale.ROOT).startsWith("image/")) {
                return null;
            }

            String ext = contentTypeToExt(contentType);
            String fileName = UUID.randomUUID() + ext;

            String uploadDir = req.getServletContext().getRealPath("/uploads/product-images");
            File dir = new File(uploadDir);
            if (!dir.exists() && !dir.mkdirs()) {
                return null;
            }

            File outputFile = new File(dir, fileName);
            try (InputStream in = connection.getInputStream();
                    FileOutputStream out = new FileOutputStream(outputFile)) {
                byte[] buffer = new byte[8192];
                int len;
                while ((len = in.read(buffer)) != -1) {
                    out.write(buffer, 0, len);
                }
            }

            return "uploads/product-images/" + fileName;
        } catch (Exception ignored) {
            return null;
        } finally {
            if (connection != null) {
                connection.disconnect();
            }
        }
    }

    private String contentTypeToExt(String contentType) {
        String ct = contentType.toLowerCase(Locale.ROOT);
        if (ct.contains("jpeg") || ct.contains("jpg"))
            return ".jpg";
        if (ct.contains("png"))
            return ".png";
        if (ct.contains("webp"))
            return ".webp";
        if (ct.contains("gif"))
            return ".gif";
        if (ct.contains("bmp"))
            return ".bmp";
        if (ct.contains("svg"))
            return ".svg";
        return ".img";
    }

    private Integer parseIntFlexible(String value) {
        value = trim(value);
        if (value == null)
            return null;
        try {
            return Integer.parseInt(value);
        } catch (Exception ignore) {
        }
        try {
            Double d = Double.parseDouble(value.replace(",", "."));
            return d.intValue();
        } catch (Exception e) {
            return null;
        }
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
