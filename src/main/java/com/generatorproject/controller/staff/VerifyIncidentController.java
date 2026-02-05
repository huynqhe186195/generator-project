
package com.generatorproject.controller.staff;
import com.generatorproject.model.Users;
import com.generatorproject.services.IRequestServices;
import com.generatorproject.services.RequestServices;


import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

// Khớp với action trong form: <form action="/staff/incident/verify-status" ...>
@WebServlet(urlPatterns = {"/staff/verify-status"})
public class VerifyIncidentController extends HttpServlet {

    private final IRequestServices requestServices;

    public VerifyIncidentController(){
        requestServices = new RequestServices();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            // 1. Kiểm tra quyền (Staff)
            HttpSession session = req.getSession();
            Users user = (Users) session.getAttribute("USERMODEL");
            if (user == null || user.getRoleId() != 3) {
                resp.sendRedirect(req.getContextPath() + "/account/login");
                return;
            }

            // 2. Lấy dữ liệu từ Form (Ẩn trong body)
            String idStr = req.getParameter("requestId");
            String newStatus = req.getParameter("newStatus");

            // 3. Gọi Service cập nhật trạng thái
            if (idStr != null && newStatus != null) {
                int requestId = Integer.parseInt(idStr);

                // Cần viết hàm updateStatus trong Service/DAO
                requestServices.updateStatus(requestId, newStatus);
            }


            resp.sendRedirect(req.getContextPath() + "/staff/incident-list?message=verified_success");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/staff/incident-list?message=error");
        }
    }
}