package com.generatorproject.controller.web;

import com.generatorproject.dao.ProductDAO;
import com.generatorproject.model.RepairRequestDTO;
import com.generatorproject.model.Product;
import com.generatorproject.model.SystemRequest;
import com.generatorproject.model.Users;
import com.generatorproject.services.ProductServices;
import com.generatorproject.dao.RequestDAO; // Chú ý: import DAO cho đúng package của bạn
import com.generatorproject.services.RepairWorkflowService; // SỬ DỤNG SERVICE CHUNG
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(urlPatterns = {"/user/view-quote", "/user/repair-quote/respond"})
public class UserQuoteController extends HttpServlet {

    private ProductServices productServices = new ProductServices();
    private RequestDAO requestDAO = new RequestDAO();

    // KHỞI TẠO SERVICE CHUNG
    private RepairWorkflowService repairWorkflowService = new RepairWorkflowService();

    // ===============================================
    // HIỂN THỊ TRANG CHI TIẾT BÁO GIÁ (GET)
    // ===============================================
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String productIdParam = req.getParameter("productId");

        if (productIdParam == null || productIdParam.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/product-list?message=missing_id");
            return;
        }

        try {
            Users currentUser = (Users) req.getSession().getAttribute("USERMODEL");
            if (currentUser == null) {
                resp.sendRedirect(req.getContextPath() + "/account/login");
                return;
            }

            int productId = Integer.parseInt(productIdParam);
            ProductDAO productDAO = new ProductDAO();
            Product product = productDAO.findCustomerProductWithContract(productId, currentUser.getId());
            SystemRequest systemReq = requestDAO.findPendingQuoteByProductId(productId);

            if (product != null && systemReq != null) {
                if ("TERMINATED".equalsIgnoreCase(product.getContractStatus())) {
                    resp.sendRedirect(req.getContextPath() + "/product-list?message=contract_terminated");
                    return;
                }
                RepairRequestDTO repairRequest = new Gson().fromJson(systemReq.getRequestData(), RepairRequestDTO.class);

                req.setAttribute("product", product);
                req.setAttribute("systemReq", systemReq);
                req.setAttribute("repairRequest", repairRequest);

                req.getRequestDispatcher("/views/home/view-quote.jsp").forward(req, resp);
            } else {
                resp.sendRedirect(req.getContextPath() + "/product-list?message=quote_not_found");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/product-list?message=error");
        }
    }

    // ===============================================
    // XỬ LÝ NÚT ĐỒNG Ý / TỪ CHỐI (POST)
    // ===============================================
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/plain; charset=UTF-8");

        try {
            Long requestId = Long.parseLong(req.getParameter("requestId"));
            String action = req.getParameter("action"); // ACCEPT hoặc REJECT

            Users currentUser = (Users) req.getSession().getAttribute("USERMODEL");
            if (currentUser == null) {
                resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                resp.getWriter().write("Vui lòng đăng nhập lại!");
                return;
            }
            Long userId = (long) currentUser.getId();

            Integer productId = requestDAO.findQuoteProductIdByRequestId(requestId);
            if (productId == null) {
                resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                resp.getWriter().write("Không tìm thấy báo giá tương ứng sản phẩm.");
                return;
            }

            ProductDAO productDAO = new ProductDAO();
            Product product = productDAO.findCustomerProductWithContract(productId, userId);
            if (product == null) {
                resp.setStatus(HttpServletResponse.SC_FORBIDDEN);
                resp.getWriter().write("Bạn không có quyền thao tác với báo giá này.");
                return;
            }
            if ("TERMINATED".equalsIgnoreCase(product.getContractStatus())) {
                resp.setStatus(HttpServletResponse.SC_FORBIDDEN);
                resp.getWriter().write("Hợp đồng đã bị chấm dứt, không thể phản hồi báo giá.");
                return;
            }

            // GỌI HÀM TỪ REPAIR_WORKFLOW_SERVICE
            if ("ACCEPT".equalsIgnoreCase(action)) {
                repairWorkflowService.acceptQuote(requestId, userId);
                resp.setStatus(HttpServletResponse.SC_OK);
                resp.getWriter().write("Xác nhận thành công!");

            } else if ("REJECT".equalsIgnoreCase(action)) {
                repairWorkflowService.rejectQuote(requestId, userId);
                resp.setStatus(HttpServletResponse.SC_OK);
                resp.getWriter().write("Đã từ chối báo giá!");

            } else {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().write("Hành động không hợp lệ.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("Lỗi hệ thống: " + e.getMessage());
        }
    }
}