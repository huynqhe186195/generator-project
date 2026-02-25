package com.generatorproject.controller.it;

import com.generatorproject.dao.RequestDAO;
import com.generatorproject.model.SystemRequest;
import com.generatorproject.model.Users;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.lang.reflect.Type;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

@WebServlet(urlPatterns = {"/it/requests"})
public class ITProductRequestController extends HttpServlet {

    private final RequestDAO requestDAO = new RequestDAO();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Users user = (Users) req.getSession().getAttribute("USERMODEL");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/account/login");
            return;
        }

        String action = req.getParameter("action");
        if ("download".equalsIgnoreCase(action)) {
            handleDownload(req, resp);
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
                request.setStatus("APPROVED");
                request.setResponseMessage("Yêu cầu thêm sản phẩm vào hệ thống đã được xử lý thành công!");
                requestDAO.update(request);
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

    private void handleDownload(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Long requestId = parseLong(req.getParameter("id"));
        if (requestId == null) {
            resp.sendRedirect(req.getContextPath() + "/it/requests?msg=not_found");
            return;
        }

        SystemRequest request = requestDAO.findById(requestId);
        if (request == null || !"NEW_PRODUCT".equalsIgnoreCase(request.getRequestType())) {
            resp.sendRedirect(req.getContextPath() + "/it/requests?msg=not_found");
            return;
        }

        Type type = new TypeToken<Map<String, Object>>() {}.getType();
        Map<String, Object> data = gson.fromJson(request.getRequestData(), type);
        if (data == null) data = new HashMap<>();

        String excelFileUrl = asText(data.get("excelFileUrl"));
        String excelFileName = asText(data.get("excelFileName"));
        if (excelFileUrl == null || excelFileUrl.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/it/requests?msg=not_found");
            return;
        }

        String absolutePath = getServletContext().getRealPath("/" + excelFileUrl);
        File file = new File(absolutePath);
        if (!file.exists()) {
            resp.sendRedirect(req.getContextPath() + "/it/requests?msg=not_found");
            return;
        }

        String downloadName = (excelFileName == null || excelFileName.trim().isEmpty()) ? file.getName() : excelFileName.trim();
        String encodedName = URLEncoder.encode(downloadName, StandardCharsets.UTF_8).replace("+", "%20");

        resp.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        resp.setHeader("Content-Disposition", "attachment; filename*=UTF-8''" + encodedName);
        resp.setContentLengthLong(file.length());

        try (FileInputStream fis = new FileInputStream(file);
             OutputStream os = resp.getOutputStream()) {
            byte[] buffer = new byte[8192];
            int len;
            while ((len = fis.read(buffer)) != -1) {
                os.write(buffer, 0, len);
            }
            os.flush();
        }
    }

    private String asText(Object value) {
        return value == null ? null : String.valueOf(value);
    }

    private Long parseLong(String value) {
        try {
            return value == null || value.isBlank() ? null : Long.parseLong(value.trim());
        } catch (Exception e) {
            return null;
        }
    }
}
