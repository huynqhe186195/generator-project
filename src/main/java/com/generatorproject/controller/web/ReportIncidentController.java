package com.generatorproject.controller.web;

import com.generatorproject.model.Product;
import com.generatorproject.model.SystemRequest;
import com.generatorproject.model.Users;
import com.generatorproject.services.IProductServices;
import com.generatorproject.services.IRequestServices;
import com.generatorproject.services.ProductServices;
import com.generatorproject.services.RequestServices;

import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

// URL này phải khớp với action trong form: <form action="<c:url value='/customer/incident/create.jsp'/>" ...>
@WebServlet(urlPatterns = {"/report-incident"})
public class ReportIncidentController extends HttpServlet {

    private final IRequestServices requestServices;
    private final IProductServices productServices;

    public ReportIncidentController() {
        this.requestServices = new RequestServices();
        productServices = new ProductServices();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        try {
            // 1. Kiểm tra đăng nhập
            HttpSession session = req.getSession();
            Users user = (Users) session.getAttribute("USERMODEL");

            if (user == null) {
                resp.sendRedirect(req.getContextPath() + "/account/login");
                return;
            }

            // 2. Lấy dữ liệu từ Form Modal
            String productId = req.getParameter("productId");
            String issueType = req.getParameter("issueType");
            String preferredDate = req.getParameter("preferredDate");
            String title = req.getParameter("title");
            String description = req.getParameter("description");

            // 3. Đóng gói dữ liệu vào Map để chuyển thành JSON
            // (Lưu tất cả vào JSON giúp bảng system_requests gọn gàng, không cần thêm cột)
            Map<String, String> requestDataMap = new HashMap<>();
            requestDataMap.put("productId", productId);
            requestDataMap.put("issueType", issueType);
            requestDataMap.put("preferredDate", preferredDate);
            requestDataMap.put("title", title);
            requestDataMap.put("description", description);

            // Lưu thêm thông tin người báo để tiện tra cứu nhanh
            requestDataMap.put("reporterName", user.getFullName());
            requestDataMap.put("reporterPhone", user.getPhone());
            requestDataMap.put("reporterEmail", user.getEmail());

            // Chuyển Map thành chuỗi JSON
            String jsonData = new Gson().toJson(requestDataMap);

            // 4. Tạo đối tượng SystemRequest
            SystemRequest request = new SystemRequest();
            request.setSenderId((long) user.getId());     // Người gửi là khách hàng
            request.setReceiverRole("STAFF");         // Người nhận là bộ phận Kỹ thuật (hoặc STAFF)
            request.setRequestType("INCIDENT_REPORT");    // Loại yêu cầu
            request.setRequestData(jsonData);             // Dữ liệu JSON
            request.setStatus("NEW");                 // Trạng thái ban đầu

            // 5. Lưu vào Database
            requestServices.save(request);
            int pId = Integer.parseInt(productId); // productId lấy từ form
            Product product= productServices.getProductById(pId);
            product.setStatus("MAINTENANCE");
            productServices.update(product);
            // 6. Chuyển hướng về trang danh sách với thông báo thành công
            resp.sendRedirect(req.getContextPath() + "/product-list?message=success");

        } catch (Exception e) {
            e.printStackTrace();
            // Nếu lỗi thì chuyển hướng về trang cũ kèm thông báo lỗi
            resp.sendRedirect(req.getContextPath() + "/product-list?message=error");
        }
    }
}