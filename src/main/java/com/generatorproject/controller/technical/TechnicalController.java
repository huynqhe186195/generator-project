package com.generatorproject.controller.technical;

import com.generatorproject.dao.MaintenanceDAO;
import com.generatorproject.dao.MaintenanceSparePartDAO;
import com.generatorproject.dao.SparePartDAO;
import com.generatorproject.model.Maintenance;
import com.generatorproject.model.MaintenanceSparePart;
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
        "/technical/repair-report",
        "/technical/add-material",
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

                int page = 1;
                int pageSize = 5;

                String pageRaw = req.getParameter("page");
                if (pageRaw != null) {
                    page = Integer.parseInt(pageRaw);
                }

                List<Maintenance> tasks =
                        maintenanceDAO.getByTechnicianFilteredPaging(
                                currentUser.getId(),
                                status,
                                type,
                                page,
                                pageSize
                        );

                int totalRecords =
                        maintenanceDAO.countByTechnicianFiltered(
                                currentUser.getId(),
                                status,
                                type
                        );

                int totalPages =
                        (int) Math.ceil((double) totalRecords / pageSize);

                req.setAttribute("tasks", tasks);
                req.setAttribute("currentPage", page);
                req.setAttribute("totalPages", totalPages);

                req.getRequestDispatcher("/views/Technical/task-list.jsp")
                        .forward(req, resp);
                break;
            }
            case "/technical/task-complete": {
                int id = Integer.parseInt(req.getParameter("id"));
                Maintenance task = maintenanceDAO.getById(id);

                if (task == null || task.getTechnicianId() != currentUser.getId()) {
                    resp.sendRedirect(req.getContextPath() + "/technical/my-tasks");
                    return;
                }

                // 🔒 chỉ SCHEDULED mới được complete
                if (!"SCHEDULED".equals(task.getStatus())) {
                    resp.sendRedirect(req.getContextPath() + "/technical/task-detail?id=" + id);
                    return;
                }

                // 🔥 nếu là REPAIR thì BẮT BUỘC phải có vật tư
                if ("REPAIR".equals(task.getType())) {
                    MaintenanceSparePartDAO mspDAO = new MaintenanceSparePartDAO();
                    if (!mspDAO.hasMaterials(id)) {
                        resp.sendRedirect(req.getContextPath()
                                + "/technical/repair-report?id=" + id + "&error=nomaterial");
                        return;
                    }
                }

                maintenanceDAO.updateStatus(id, "COMPLETED");
                resp.sendRedirect(req.getContextPath() + "/technical/my-tasks");
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
                MaintenanceSparePartDAO mspDAO = new MaintenanceSparePartDAO();
                req.setAttribute("materials",
                        mspDAO.getByMaintenanceId(id));

                req.setAttribute("task", task);
                req.getRequestDispatcher("/views/Technical/task-detail.jsp")
                        .forward(req, resp);
                break;
            }
            case "/technical/repair-report": {
                int id = Integer.parseInt(req.getParameter("id"));
                Maintenance task = maintenanceDAO.getById(id);

                if (task == null
                        || task.getTechnicianId() != currentUser.getId()
                        || !"REPAIR".equals(task.getType())) {

                    resp.sendRedirect(req.getContextPath() + "/technical/my-tasks");
                    return;
                }

                // 🔧 Danh sách vật tư để CHỌN
                SparePartDAO sparePartDAO = new SparePartDAO();
                List<SparePart> parts = sparePartDAO.getAll();

                // 🔥🔥🔥 THÊM ĐOẠN NÀY
                MaintenanceSparePartDAO mspDAO = new MaintenanceSparePartDAO();
                List<MaintenanceSparePart> materials =
                        mspDAO.getByMaintenanceId(id);

                // ===== SET ATTRIBUTE =====
                req.setAttribute("task", task);
                req.setAttribute("parts", parts);
                req.setAttribute("materials", materials); // 👈 QUAN TRỌNG

                req.getRequestDispatcher("/views/Technical/repair-report.jsp")
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

            int id = Integer.parseInt(req.getParameter("id"));
            String actualReport = req.getParameter("actualDescription");

            Maintenance task = maintenanceDAO.getById(id);

            // bảo vệ nghiệp vụ
            if (task == null || task.getTechnicianId() != currentUser.getId()) {
                resp.sendRedirect(req.getContextPath() + "/technical/my-tasks");
                return;
            }
            // KHÓA NGHIỆP VỤ
            if ("COMPLETED".equals(task.getStatus())
                    || "CANCELLED".equals(task.getStatus())) {

                resp.sendRedirect(req.getContextPath()
                        + "/technical/task-detail?id=" + id);
                return;
            }

            // CHỈ cập nhật báo cáo hiện trường
            maintenanceDAO.updateActualReport(id, actualReport);

            resp.sendRedirect(req.getContextPath()
                    + "/technical/task-detail?id=" + id);
            return;
        }
        if ("/technical/add-material".equals(path)) {

            String mIdRaw = req.getParameter("maintenanceId");
            String spIdRaw = req.getParameter("sparePartId");
            String qtyRaw  = req.getParameter("quantityUsed");

            if (mIdRaw == null || spIdRaw == null || qtyRaw == null) {
                resp.sendRedirect(req.getContextPath()
                        + "/technical/repair-report?id=" + mIdRaw);
                return;
            }

            int maintenanceId = Integer.parseInt(mIdRaw);
            int sparePartId   = Integer.parseInt(spIdRaw);
            int quantityUsed  = Integer.parseInt(qtyRaw);

            Maintenance task = maintenanceDAO.getById(maintenanceId);

            if (task == null
                    || task.getTechnicianId() != currentUser.getId()
                    || !"SCHEDULED".equals(task.getStatus())) {

                resp.sendRedirect(req.getContextPath() + "/technical/my-tasks");
                return;
            }

            MaintenanceSparePartDAO mspDAO = new MaintenanceSparePartDAO();

            try {
                mspDAO.insert(maintenanceId, sparePartId, quantityUsed);
            } catch (Exception e) {
                e.printStackTrace();
                resp.sendRedirect(req.getContextPath()
                        + "/technical/repair-report?id=" + maintenanceId + "&error=stock");
                return;
            }

            // ✅ QUAY LẠI ĐÚNG MÀN
            resp.sendRedirect(req.getContextPath()
                    + "/technical/repair-report?id=" + maintenanceId);
            return;
        }

        if ("/technical/task-complete".equals(path)) {

            int id = Integer.parseInt(req.getParameter("id"));
            String actualDescription = req.getParameter("actualDescription");

            Maintenance task = maintenanceDAO.getById(id);

            if (task == null
                    || task.getTechnicianId() != currentUser.getId()
                    || !"SCHEDULED".equals(task.getStatus())) {

                resp.sendRedirect(req.getContextPath() + "/technical/my-tasks");
                return;
            }

            // 🔒 BẮT BUỘC có báo cáo
            if (actualDescription == null || actualDescription.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath()
                        + "/technical/repair-report?id=" + id + "&error=noreport");
                return;
            }

            // 🔥 LƯU BÁO CÁO
            maintenanceDAO.updateActualReport(id, actualDescription);

            // 🔥 NẾU REPAIR → PHẢI CÓ VẬT TƯ
            if ("REPAIR".equals(task.getType())) {
                MaintenanceSparePartDAO mspDAO = new MaintenanceSparePartDAO();
                if (!mspDAO.hasMaterials(id)) {
                    resp.sendRedirect(req.getContextPath()
                            + "/technical/repair-report?id=" + id + "&error=nomaterial");
                    return;
                }
            }

            maintenanceDAO.updateStatus(id, "COMPLETED");

            resp.sendRedirect(req.getContextPath()
                    + "/technical/repair-report?id=" + id);
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
                    && !"CANCELLED".equals(status)
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
