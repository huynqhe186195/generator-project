package com.generatorproject.controller.technical;

import com.generatorproject.dao.*;
import com.generatorproject.model.Maintenance;
import com.generatorproject.model.MaintenanceSparePart;
import com.generatorproject.model.SparePart;
import com.generatorproject.model.Users;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.Collection;
import java.util.List;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.Part;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 10 * 1024 * 1024,
        maxRequestSize = 50 * 1024 * 1024
)

@WebServlet(urlPatterns = {
        "/technical/my-tasks",
        "/technical/task-detail",
        "/technical/task-report",
        "/technical/task-complete",
        "/technical/task-status",
        "/technical/materials",
        "/technical/repair-report",
        "/technical/add-material",
        "/technical/profile",
        "/technical/send-quote",
        "/technical/spare-part-create.jsp",
        "/technical/spare-part-update",
        "/technical/spare-part-delete",
        "/technical/delete-material",

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
                if ("REPAIR".equals(task.getType())) {

                    // bắt buộc có vật tư (bạn đã check ở trên rồi thì đoạn này có thể bỏ, nhưng giữ cũng ok)
                    MaintenanceSparePartDAO mspDAO = new MaintenanceSparePartDAO();
                    if (!mspDAO.hasMaterials(id)) {
                        resp.sendRedirect(req.getContextPath()
                                + "/technical/repair-report?id=" + id + "&error=nomaterial");
                        return;
                    }

                    SystemRequestDAO srDAO = new SystemRequestDAO();
                    String customerQuoteStatus = srDAO.getCustomerResponseStatus(id);

                    if (!"APPROVED_BY_CUSTOMER".equals(customerQuoteStatus)) {
                        resp.sendRedirect(req.getContextPath()
                                + "/technical/repair-report?id=" + id + "&error=customer_not_approved");
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
                MaintenanceImageDAO imgDAO = new MaintenanceImageDAO();
                req.setAttribute("images", imgDAO.getByMaintenanceId(id));
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


                SystemRequestDAO srDAO = new SystemRequestDAO();
                String staffQuoteStatus = srDAO.getStaffQuoteStatus(id);
                String customerQuoteStatus = srDAO.getCustomerResponseStatus(id);

                req.setAttribute("staffQuoteStatus", staffQuoteStatus);
                req.setAttribute("customerQuoteStatus", customerQuoteStatus);

                MaintenanceImageDAO imgDAO = new MaintenanceImageDAO();
                req.setAttribute("images", imgDAO.getByMaintenanceId(id));

                req.getRequestDispatcher("/views/Technical/repair-report.jsp")
                        .forward(req, resp);
                break;
            }

            case "/technical/spare-part-update": {

                String editIdRaw = req.getParameter("editId");

                SparePartDAO spareDAO = new SparePartDAO();

                if (editIdRaw != null) {
                    int editId = Integer.parseInt(editIdRaw);
                    SparePart editPart = spareDAO.getById(editId);
                    req.setAttribute("editPart", editPart);
                }

                // load lại danh sách
                List<SparePart> parts = spareDAO.getAll();
                req.setAttribute("parts", parts);

                req.getRequestDispatcher("/views/Technical/materials.jsp")
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

            if (task == null || task.getTechnicianId() != currentUser.getId()) {
                resp.sendRedirect(req.getContextPath() + "/technical/my-tasks");
                return;
            }

            if ("COMPLETED".equals(task.getStatus()) || "CANCELLED".equals(task.getStatus())) {
                resp.sendRedirect(req.getContextPath() + "/technical/task-detail?id=" + id);
                return;
            }

            // 1) update report
            maintenanceDAO.updateActualReport(id, actualReport);

            // 2) upload images
            String uploadDir = getServletContext().getRealPath("/") + "uploads" + File.separator + "maintenance";
            File dir = new File(uploadDir);
            if (!dir.exists()) dir.mkdirs();

            MaintenanceImageDAO imgDAO = new MaintenanceImageDAO();

            Collection<Part> parts = req.getParts();
            for (Part part : parts) {
                if (!"siteImages".equals(part.getName())) continue;
                if (part.getSize() <= 0) continue;

                String ct = part.getContentType();
                if (ct == null || !ct.startsWith("image/")) continue;

                String submitted = Paths.get(part.getSubmittedFileName()).getFileName().toString();
                if (submitted == null || submitted.trim().isEmpty()) continue;

                String ext = "";
                int dot = submitted.lastIndexOf('.');
                if (dot >= 0) ext = submitted.substring(dot);

                String fileName = "m" + id + "_" + System.currentTimeMillis() + ext;
                String fullPath = uploadDir + File.separator + fileName;

                part.write(fullPath);

                // LƯU ĐÚNG DB: image_path
                String relativePath = "uploads/maintenance/" + fileName;
                imgDAO.insert(id, relativePath);
            }

            resp.sendRedirect(req.getContextPath() + "/technical/task-detail?id=" + id + "&msg=saved");
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

        if ("/technical/send-quote".equals(path)) {
            int id = Integer.parseInt(req.getParameter("id"));


            Maintenance task = maintenanceDAO.getById(id);

            // bảo vệ nghiệp vụ
            if (task == null || task.getTechnicianId() != currentUser.getId()) {
                resp.sendRedirect(req.getContextPath() + "/technical/my-tasks");
                return;
            }
            // chỉ cho gửi khi đang làm
            if (!"SCHEDULED".equals(task.getStatus())) {
                resp.sendRedirect(req.getContextPath() + "/technical/repair-report?id=" + id);
                return;
            }

            MaintenanceSparePartDAO mspDAO = new MaintenanceSparePartDAO();
            List<MaintenanceSparePart> materials = mspDAO.getByMaintenanceId(id); // nếu DAO bạn khác tên thì đổi lại

            if (materials == null || materials.isEmpty()) {
                resp.sendRedirect(req.getContextPath()
                        + "/technical/repair-report?id=" + id + "&error=nomaterial");
                return;
            }

            double partsTotal = 0;
            for (MaintenanceSparePart m : materials) {
                partsTotal += m.getCostAtTime(); // KHÔNG nhân lại
            }



            // Tạo JSON request_data (không phụ thuộc lib)
            StringBuilder json = new StringBuilder();
            json.append("{");
            json.append("\"maintenanceId\":").append(id).append(",");
            json.append("\"technicianId\":").append(currentUser.getId()).append(",");
            json.append("\"actualDescription\":").append(toJsonString(task.getActualDescription())).append(",");

            json.append("\"partsTotal\":").append(partsTotal).append(",");

            json.append("\"materials\":[");
            for (int i = 0; i < materials.size(); i++) {
                MaintenanceSparePart m = materials.get(i);
                json.append("{")
                        .append("\"sparePartId\":").append(m.getSparePartId()).append(",")
                        .append("\"quantityUsed\":").append(m.getQuantityUsed()).append(",")
                        .append("\"costAtTime\":").append(m.getCostAtTime())
                        .append("}");
                if (i < materials.size() - 1) json.append(",");
            }
            json.append("]}");

            // Insert vào system_requests
            // ==> Bạn cần SystemRequestDAO (mình đưa mẫu bên dưới)
            SystemRequestDAO srDAO = new SystemRequestDAO();
            srDAO.createRequest(
                    currentUser.getId(),
                    "STAFF",
                    "REPAIR_QUOTE",
                    json.toString()
            );



            resp.sendRedirect(req.getContextPath()
                    + "/technical/repair-report?id=" + id + "&msg=quote_sent");
            return;
        }

        // =========================
// CRUD SPARE PART
// =========================
        if ("/technical/spare-part-create.jsp".equals(path)) {

            SparePartDAO spareDAO = new SparePartDAO();

            SparePart p = new SparePart();
            p.setName(req.getParameter("name"));
            p.setPartCode(req.getParameter("partCode"));
            p.setUnit(req.getParameter("unit"));
            p.setQuantityInStock(Integer.parseInt(req.getParameter("quantityInStock")));
            p.setMinStockAlert(Integer.parseInt(req.getParameter("minStockAlert")));
            p.setPrice(Double.parseDouble(req.getParameter("price")));
            p.setDescription(req.getParameter("description"));

            spareDAO.insert(p);

            resp.sendRedirect(req.getContextPath() + "/technical/materials");
            return;
        }

        if ("/technical/spare-part-update".equals(path)) {

            SparePartDAO spareDAO = new SparePartDAO();

            SparePart p = new SparePart();
            p.setId(Integer.parseInt(req.getParameter("id")));
            p.setName(req.getParameter("name"));
            p.setPartCode(req.getParameter("partCode"));
            p.setUnit(req.getParameter("unit"));
            p.setQuantityInStock(Integer.parseInt(req.getParameter("quantityInStock")));
            p.setMinStockAlert(Integer.parseInt(req.getParameter("minStockAlert")));
            p.setPrice(Double.parseDouble(req.getParameter("price")));
            p.setDescription(req.getParameter("description"));

            spareDAO.update(p);

            resp.sendRedirect(req.getContextPath() + "/technical/materials");
            return;
        }

        if ("/technical/spare-part-delete".equals(path)) {

            int id = Integer.parseInt(req.getParameter("id"));

            SparePartDAO spareDAO = new SparePartDAO();
            spareDAO.delete(id);

            resp.sendRedirect(req.getContextPath() + "/technical/materials");
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


            if ("REPAIR".equals(task.getType())) {

                // bắt buộc có vật tư (bạn đã check ở trên rồi thì đoạn này có thể bỏ, nhưng giữ cũng ok)
                MaintenanceSparePartDAO mspDAO = new MaintenanceSparePartDAO();
                if (!mspDAO.hasMaterials(id)) {
                    resp.sendRedirect(req.getContextPath()
                            + "/technical/repair-report?id=" + id + "&error=nomaterial");
                    return;
                }

                SystemRequestDAO srDAO = new SystemRequestDAO();
                String customerQuoteStatus = srDAO.getCustomerResponseStatus(id);

                if (!"APPROVED_BY_CUSTOMER".equals(customerQuoteStatus)) {
                    resp.sendRedirect(req.getContextPath()
                            + "/technical/repair-report?id=" + id + "&error=customer_not_approved");
                    return;
                }
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
        if ("/technical/delete-material".equals(path)) {

            int maintenanceId = Integer.parseInt(req.getParameter("maintenanceId"));
            int sparePartId   = Integer.parseInt(req.getParameter("sparePartId"));

            Maintenance task = maintenanceDAO.getById(maintenanceId);

            if (task == null
                    || task.getTechnicianId() != currentUser.getId()
                    || !"SCHEDULED".equals(task.getStatus())) {
                resp.sendRedirect(req.getContextPath() + "/technical/my-tasks");
                return;
            }

            MaintenanceSparePartDAO mspDAO = new MaintenanceSparePartDAO();
            try {
                mspDAO.deleteMaterial(maintenanceId, sparePartId);
            } catch (Exception e) {
                e.printStackTrace();
                resp.sendRedirect(req.getContextPath()
                        + "/technical/repair-report?id=" + maintenanceId + "&error=delete_material");
                return;
            }

            resp.sendRedirect(req.getContextPath()
                    + "/technical/repair-report?id=" + maintenanceId);
            return;
        }
    }



    private String toJsonString(String s) {
        if (s == null) return "null";
        String escaped = s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
        return "\"" + escaped + "\"";
    }

}
