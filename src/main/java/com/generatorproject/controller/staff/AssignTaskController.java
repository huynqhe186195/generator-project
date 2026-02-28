package com.generatorproject.controller.manager;

import com.generatorproject.dao.MaintenanceDAO;
import com.generatorproject.model.Maintenance;
import com.generatorproject.model.SystemRequest;
import com.generatorproject.model.Users;
import com.generatorproject.services.IRequestServices;
import com.generatorproject.services.RequestServices;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(urlPatterns = {"/staff/assign-task"})
public class AssignTaskController extends HttpServlet {

    private final IRequestServices requestServices;

    public AssignTaskController() {
        requestServices = new RequestServices();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession();
        Users user = (Users) session.getAttribute("USERMODEL");



        try {
            // 1. Lấy ID từ form (Tham số 'id' từ <input type="hidden" name="id">)
            String idStr = req.getParameter("id");
            long requestId = Long.parseLong(idStr);

            // 2. Tìm SystemRequest
            SystemRequest sysReq = requestServices.findById(requestId);

            if (sysReq != null && sysReq.getRequestData() != null) {
                // 3. Lấy JSON info (đã có đủ technicianId, maintenanceType... từ bước trước)
                String jsonInfo = sysReq.getRequestData();

                // 4. Parse JSON sang object Maintenance
                Gson gson = new Gson();
                Maintenance taskData = gson.fromJson(jsonInfo, Maintenance.class);

                if (taskData != null) {
                    // 5. Insert vào bảng maintenances
                    MaintenanceDAO maintenanceDAO = new MaintenanceDAO();
                    boolean isSuccess = maintenanceDAO.insertMaintenance(taskData);

                    if (isSuccess) {
                        // Cập nhật trạng thái SystemRequest thành DONE hoặc TASK_CREATED
                        sysReq.setStatus("TASK_CREATED");
                        requestServices.update(sysReq);

                        resp.sendRedirect(req.getContextPath() + "/staff/incident-list?message=task_created_success");
                    } else {
                        resp.sendRedirect(req.getContextPath() + "/staff/incident-list?message=insert_error");
                    }
                }
            } else {
                resp.sendRedirect(req.getContextPath() + "/staff/incident-list?message=not_found");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/staff/incident-list?message=system_error");
        }
    }

    // Nếu bạn vẫn muốn dùng thẻ <a> (GET), bạn nên copy logic sang doGet hoặc gọi doPost trong doGet
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }
}