package com.generatorproject.controller.staff;

import com.generatorproject.model.SystemRequest;
import com.generatorproject.model.Users;
import com.generatorproject.services.IInvoiceService;
import com.generatorproject.services.IRequestServices;
import com.generatorproject.services.InvoiceService;
import com.generatorproject.services.RequestServices;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet(urlPatterns = {"/staff/invoice/create"})
public class CreateInvoiceController extends HttpServlet {

    private final IRequestServices requestServices;
    private final IInvoiceService invoiceService;

    public CreateInvoiceController() {
        requestServices = new RequestServices();
        invoiceService = new InvoiceService();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String reqIdParam = req.getParameter("requestId");

        // 1. Kiểm tra tham số đầu vào
        if (reqIdParam == null || reqIdParam.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/staff/repair-request-list?message=missing_id");
            return;
        }

        try {
            Long requestId = Long.parseLong(reqIdParam);

            // 2. Kiểm tra Yêu cầu có tồn tại không
            SystemRequest sysReq = requestServices.findById(requestId);
            if (sysReq == null) {
                resp.sendRedirect(req.getContextPath() + "/staff/repair-request-list?message=not_found");
                return;
            }

            // 3. Lấy thông tin nhân viên đang đăng nhập
            Users staff = (Users) req.getSession().getAttribute("USERMODEL");
            if (staff == null) {
                resp.sendRedirect(req.getContextPath() + "/account/login");
                return;
            }

            // 4. Gọi Service tạo hóa đơn (Chốt thuế VAT = 8%)
            double taxRate = 8.0;
            boolean isCreated = invoiceService.createInvoiceFromRequest(requestId, staff.getId(), taxRate);

            if (isCreated) {
                // Đổi trạng thái Yêu cầu thành INVOICED (Đã xuất HĐ) để ẩn nút "Tạo hóa đơn" đi
                requestServices.updateStatus(sysReq.getId().intValue(), "INVOICED");
                System.out.println(sysReq.getId().intValue());
                // Thành công -> Chuyển hướng sang trang danh sách yêu cầu (hoặc danh sách hóa đơn)
                resp.sendRedirect(req.getContextPath() + "/staff/repair-request-list?message=invoice_created_success");
            } else {
                resp.sendRedirect(req.getContextPath() + "/staff/repair-request-list?message=create_invoice_failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            // Bắt lỗi từ Service (nếu có ném Exception) và hiển thị lên URL
            String errorMsg = URLEncoder.encode(e.getMessage() != null ? e.getMessage() : "Lỗi hệ thống", StandardCharsets.UTF_8);
            resp.sendRedirect(req.getContextPath() + "/staff/repair-request-list?message=error&detail=" + errorMsg);
        }
    }
}