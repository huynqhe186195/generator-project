package com.generatorproject.controller.technical;

import com.generatorproject.dao.MaintenanceDAO;
import com.generatorproject.dao.SparePartDAO;
import com.generatorproject.model.Maintenance;
import com.generatorproject.model.SparePart;
import com.generatorproject.model.Users;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {
        "/technical/my-tasks",
        "/technical/task-detail",
        "/technical/task-report",
        "/technical/task-complete",
        "/technical/task-status",
        "/technical/materials",
        "/technical/profile"
})
public class TechnicalController extends HttpServlet {

    private final MaintenanceDAO maintenanceDAO = new MaintenanceDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");
        String path = req.getServletPath();
        Users currentUser = (Users) req.getSession().getAttribute("USERMODEL");


        // ===== CHECK LOGIN =====
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        switch (path) {

            // =========================
            // Danh sách task của kỹ thuật
            // =========================
            case "/technical/my-tasks": {

                String status = req.getParameter("status");
                String type = req.getParameter("type");

                List<Maintenance> tasks =
                        maintenanceDAO.getByTechnicianFiltered(
                                currentUser.getId(),
                                status,
                                type
                        );

                req.setAttribute("tasks", tasks);
                req.getRequestDispatcher("/views/Technical/task-list.jsp")
                        .forward(req, resp);
                break;
            }


            // =========================
            // Chi tiết task
            // =========================
            case "/technical/task-detail": {
                int id = Integer.parseInt(req.getParameter("id"));
                Maintenance task = maintenanceDAO.getById(id);

                // bảo vệ: không cho xem task của người khác
                if (task == null || task.getTechnicianId() != currentUser.getId()) {
                    resp.sendRedirect(req.getContextPath() + "/technical/my-tasks");
                    return;
                }

                req.setAttribute("task", task);
                req.getRequestDispatcher("/views/Technical/task-detail.jsp")
                        .forward(req, resp);
                break;
            }

            // =========================
            // Form ghi báo cáo
            // =========================
            case "/technical/task-report": {
                int id = Integer.parseInt(req.getParameter("id"));
                Maintenance task = maintenanceDAO.getById(id);

                if (task == null || task.getTechnicianId() != currentUser.getId()) {
                    resp.sendRedirect(req.getContextPath() + "/technical/my-tasks");
                    return;
                }

                req.setAttribute("task", task);
                req.getRequestDispatcher("/views/Technical/task-report.jsp")
                        .forward(req, resp);
                break;
            }

            // =========================
// Kho vật tư
// =========================
            case "/technical/materials": {
                final SparePartDAO sparePartDAO = new SparePartDAO();


                String keyword = req.getParameter("keyword");

                List<SparePart> parts;
                if (keyword != null && !keyword.trim().isEmpty()) {
                    parts = sparePartDAO.search(keyword);
                } else {
                    parts = sparePartDAO.getAll();
                }

                req.setAttribute("parts", parts);
                req.getRequestDispatcher("/views/Technical/materials.jsp")
                        .forward(req, resp);
                break;
            }





        }
    }

    // =========================
    // Ghi báo cáo kỹ thuật
    // =========================
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");

        Users currentUser = (Users) req.getSession().getAttribute("USERMODEL");
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String path = req.getServletPath();

        // =========================
        // GHI BÁO CÁO
        // =========================
        if ("/technical/task-report".equals(path)) {

            String idRaw = req.getParameter("id");
            if (idRaw == null) {
                resp.sendRedirect(req.getContextPath() + "/technical/my-tasks");
                return;
            }

            int id = Integer.parseInt(idRaw);
            String report = req.getParameter("description");

            Maintenance task = maintenanceDAO.getById(id);

            // bảo vệ
            if (task == null || task.getTechnicianId() != currentUser.getId()) {
                resp.sendRedirect(req.getContextPath() + "/technical/my-tasks");
                return;
            }

            maintenanceDAO.updateReport(id, report);

            resp.sendRedirect(req.getContextPath()
                    + "/technical/task-detail?id=" + id);
            return;
        }

        // =========================
        // ĐỔI TRẠNG THÁI TASK
        // =========================
        if ("/technical/task-status".equals(path)) {

            int id = Integer.parseInt(req.getParameter("id"));
            String status = req.getParameter("status");

            // CHỈ 3 TRẠNG THÁI NHƯ MÀY NÓI
            if (!"SCHEDULED".equals(status)
                    && !"IN_PROGRESS".equals(status)
                    && !"COMPLETED".equals(status)) {

                resp.sendRedirect(req.getContextPath() + "/technical/my-tasks");
                return;
            }

            Maintenance task = maintenanceDAO.getById(id);

            if (task == null || task.getTechnicianId() != currentUser.getId()) {
                resp.sendRedirect(req.getContextPath() + "/technical/my-tasks");
                return;
            }

            maintenanceDAO.updateStatus(id, status);
            resp.sendRedirect(req.getContextPath() + "/technical/my-tasks");
        }
    }



}
