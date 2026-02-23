package com.generatorproject.controller.it;

import com.generatorproject.dao.ProductModelDAO;
import com.generatorproject.dao.RequestDAO;
import com.generatorproject.model.ProductModel;
import com.generatorproject.model.SystemRequest;
import com.generatorproject.model.Users;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
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
        if (data == null)
            data = new HashMap<>();

        String name = trim(asText(data.get("name")));
        Integer brandId = parseInt(asText(data.get("brandId")));
        Integer categoryId = parseInt(asText(data.get("categoryId")));
        String fuelType = normalizeFuelType(asText(data.get("fuelType")));
        String status = normalizeStatus(asText(data.get("status")));

        if (name == null || brandId == null || categoryId == null || fuelType == null) {
            throw new IllegalArgumentException("Thiếu dữ liệu bắt buộc để tạo mẫu sản phẩm mới");
        }

        ProductModel existed = productModelDAO.findByName(name);
        if (existed != null) {
            request.setStatus("REJECTED");
            request.setResponseMessage("Mẫu sản phẩm đã tồn tại: " + name);
            requestDAO.update(request);
            return;
        }

        ProductModel model = new ProductModel.Builder()
                .setName(name)
                .setSlug(toSlug(name))
                .setBrandId(brandId)
                .setCategoryId(categoryId)
                .setOrigin(trim(asText(data.get("origin"))))
                .setFuelType(fuelType)
                .setPower(parseDouble(asText(data.get("power"))))
                .setDescription(trim(asText(data.get("description"))))
                .setSpecifications(trim(asText(data.get("specifications"))))
                .setManualUrl(trim(asText(data.get("manualUrl"))))
                .setImageUrl(trim(asText(data.get("imageUrl"))))
                .setStatus(status != null ? status : "COMING_SOON")
                .build();

        Long newId = productModelDAO.insertProductModel(model);
        if (newId == null) {
            throw new IllegalStateException("Không tạo được product model mới");
        }

        request.setStatus("APPROVED");
        request.setResponseMessage("IT đã thêm sản phẩm mới thành công. ProductModel ID: " + newId);
        requestDAO.update(request);
    }

    private String asText(Object value) {
        return value == null ? null : String.valueOf(value);
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
        return ALLOWED_FUEL_TYPES.contains(normalized) ? normalized : null;
    }

    private String normalizeStatus(String value) {
        String normalized = trim(value);
        if (normalized == null)
            return null;
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
