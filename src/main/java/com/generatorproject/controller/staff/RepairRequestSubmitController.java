package com.generatorproject.controller.staff;

import com.generatorproject.model.RepairRequestDTO;
import com.generatorproject.services.RepairWorkflowService;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

// Map thẳng đường dẫn này để khớp với hàm fetch() ở dưới giao diện
@WebServlet(urlPatterns = {"/staff/repair-request/submit"})
public class RepairRequestSubmitController extends HttpServlet {

    private final RepairWorkflowService repairWorkflowService;

    public RepairRequestSubmitController() {
        this.repairWorkflowService = new RepairWorkflowService();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/plain; charset=UTF-8");

        try {
            // 1. Lấy ID và Action từ tham số URL
            Long requestId = Long.parseLong(req.getParameter("requestId"));
            String action = req.getParameter("action");

            // 2. TODO: Lấy staffId từ session người dùng đang đăng nhập
            // Users currentUser = (Users) req.getSession().getAttribute("user");
            // Long staffId = (long) currentUser.getId();
            Long staffId = 10L; // Tạm fix cứng để test

            // 3. Xử lý theo Action
            if ("APPROVE".equalsIgnoreCase(action)) {

                // Parse JSON vật tư từ request body
                Gson gson = new Gson();
                RepairRequestDTO dto = gson.fromJson(req.getReader(), RepairRequestDTO.class);

                // Gọi service duyệt (Cập nhật SystemRequest)
                repairWorkflowService.processStaffApprove(requestId, dto, staffId);

                resp.setStatus(HttpServletResponse.SC_OK);
                resp.getWriter().write("Đã xác nhận chi phí và chuyển lên Manager duyệt thành công!");

            } else if ("REJECT".equalsIgnoreCase(action)) {

                // Từ chối thì không cần quan tâm body (JSON)
                repairWorkflowService.processStaffReject(requestId, staffId);

                resp.setStatus(HttpServletResponse.SC_OK);
                resp.getWriter().write("Đã TỪ CHỐI phiếu đề xuất của Kỹ thuật viên!");

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