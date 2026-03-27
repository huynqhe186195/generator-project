package com.generatorproject.controller.technical;

import com.generatorproject.dao.*;
import com.generatorproject.model.Maintenance;
import com.generatorproject.model.MaintenanceSparePart;
import com.generatorproject.model.SparePart;
import com.generatorproject.model.Users;
import com.generatorproject.dao.TechnicalStatsDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
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
        "/technical/spare-part-create",
        "/technical/spare-part-update",
        "/technical/spare-part-delete",
        "/technical/delete-material",
        "/technical/history",
        "/technical/stats",
        "/technical/save-after-images",

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
            case "/technical/stats": {
                TechnicalStatsDAO statsDAO = new TechnicalStatsDAO();

                req.setAttribute("stats", statsDAO.getOverview(currentUser.getId()));
                req.setAttribute("topParts", statsDAO.getTopUsedSpareParts(currentUser.getId(), 5));
                req.setAttribute("recentCompleted", statsDAO.getRecentCompletedTasks(currentUser.getId(), 5));

                req.getRequestDispatcher("/views/Technical/stats.jsp").forward(req, resp);
                break;
            }



            // =========================
            // Chi tiết task
            // =========================
            case "/technical/task-detail": {
                int id = Integer.parseInt(req.getParameter("id"));
                Maintenance task = maintenanceDAO.getById(id);

                if (task == null || task.getTechnicianId() != currentUser.getId()) {
                    resp.sendRedirect(req.getContextPath() + "/technical/my-tasks");
                    return;
                }

                MaintenanceSparePartDAO mspDAO = new MaintenanceSparePartDAO();
                req.setAttribute("materials", mspDAO.getByMaintenanceId(id));

                req.setAttribute("task", task);

                MaintenanceImageDAO imgDAO = new MaintenanceImageDAO();
                req.setAttribute("beforeImages", imgDAO.getByMaintenanceIdAndType(id, "BEFORE"));
                req.setAttribute("afterImages", imgDAO.getByMaintenanceIdAndType(id, "AFTER"));

                req.getRequestDispatcher("/views/Technical/task-detail.jsp")
                        .forward(req, resp);
                break;
            }
            case "/technical/repair-report": {
                int id = Integer.parseInt(req.getParameter("id"));
                Maintenance task = maintenanceDAO.getById(id);

                if (task == null
                        || task.getTechnicianId() != currentUser.getId()
                        ) {

                    resp.sendRedirect(req.getContextPath() + "/technical/my-tasks");
                    return;
                }

                SparePartDAO sparePartDAO = new SparePartDAO();
                List<SparePart> parts = sparePartDAO.getAll();

                MaintenanceSparePartDAO mspDAO = new MaintenanceSparePartDAO();
                List<MaintenanceSparePart> materials = mspDAO.getByMaintenanceId(id);

                MaintenanceImageDAO imgDAO = new MaintenanceImageDAO();

                req.setAttribute("task", task);
                req.setAttribute("parts", parts);
                req.setAttribute("materials", materials);
                req.setAttribute("afterImages", imgDAO.getByMaintenanceIdAndType(id, "AFTER"));

                SystemRequestDAO srDAO = new SystemRequestDAO();
                String quoteStatus = srDAO.getQuoteStatus(id);
                req.setAttribute("quoteStatus", quoteStatus);

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



            case "/technical/history": {

                String serial = req.getParameter("serial");
                String customer = req.getParameter("customer");
                String dateFrom = req.getParameter("dateFrom");
                String dateTo = req.getParameter("dateTo");

                int page = 1;
                int pageSize = 10;

                String pageRaw = req.getParameter("page");
                if (pageRaw != null) page = Integer.parseInt(pageRaw);

                // chỉ lịch sử của technician hiện tại
                List<Maintenance> list = maintenanceDAO.getHistoryCompletedPaging(
                        currentUser.getId(),
                        serial, customer, dateFrom, dateTo,
                        page, pageSize
                );

                int totalRecords = maintenanceDAO.countHistoryCompleted(
                        currentUser.getId(),
                        serial, customer, dateFrom, dateTo
                );

                int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

                req.setAttribute("tasks", list);
                req.setAttribute("currentPage", page);
                req.setAttribute("totalPages", totalPages);

                req.getRequestDispatcher("/views/Technical/history.jsp").forward(req, resp);
                break;
            }
            // =========================
// Kho vật tư
// =========================
            case "/technical/materials": {

                final SparePartDAO sparePartDAO = new SparePartDAO();

                String keyword = req.getParameter("keyword");

                int page = 1;
                int pageSize = 10;

                try {
                    page = Integer.parseInt(req.getParameter("page"));
                } catch (Exception ignored) {}

                List<SparePart> parts;
                int total;

                if (keyword != null && !keyword.trim().isEmpty()) {

                    parts = sparePartDAO.searchPaging(keyword, page, pageSize);
                    total = sparePartDAO.countSearch(keyword);

                } else {

                    parts = sparePartDAO.getPaging(page, pageSize);
                    total = sparePartDAO.countAll();

                }

                int totalPages = (int) Math.ceil((double) total / pageSize);

                req.setAttribute("parts", parts);
                req.setAttribute("currentPage", page);
                req.setAttribute("totalPages", totalPages);
                req.setAttribute("keyword", keyword);

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
                imgDAO.insert(id, relativePath, "BEFORE");
            }

            resp.sendRedirect(req.getContextPath() + "/technical/task-detail?id=" + id + "&msg=saved");
            return;
        }
        if ("/technical/add-material".equals(path)) {

            String mIdRaw = req.getParameter("maintenanceId");
            String spIdRaw = req.getParameter("sparePartId");
            String qtyRaw  = req.getParameter("quantityUsed");
            String laborCostRaw = req.getParameter("laborCost");

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

            String redirectUrl = req.getContextPath()
                    + "/technical/repair-report?id=" + maintenanceId;

            if (laborCostRaw != null && !laborCostRaw.trim().isEmpty()) {
                redirectUrl += "&laborCost=" + java.net.URLEncoder.encode(laborCostRaw, StandardCharsets.UTF_8);
            }

            resp.sendRedirect(redirectUrl);
            return;
        }

        if ("/technical/send-quote".equals(path)) {
            int id = Integer.parseInt(req.getParameter("id"));

            double laborCost = 0;
            try {
                laborCost = Double.parseDouble(req.getParameter("laborCost"));
            } catch (Exception ignored) {}

            if (laborCost < 0) laborCost = 0;

            Maintenance task = maintenanceDAO.getById(id);

            if (task == null || task.getTechnicianId() != currentUser.getId()) {
                resp.sendRedirect(req.getContextPath() + "/technical/my-tasks");
                return;
            }

            if (!"SCHEDULED".equals(task.getStatus())) {
                resp.sendRedirect(req.getContextPath() + "/technical/repair-report?id=" + id);
                return;
            }

            MaintenanceSparePartDAO mspDAO = new MaintenanceSparePartDAO();
            List<MaintenanceSparePart> materials = mspDAO.getByMaintenanceId(id);

            if (materials == null || materials.isEmpty()) {
                resp.sendRedirect(req.getContextPath()
                        + "/technical/repair-report?id=" + id + "&error=nomaterial");
                return;
            }

            double partsTotal = 0;
            for (MaintenanceSparePart m : materials) {
                partsTotal += m.getCostAtTime();
            }

            double grandTotal = partsTotal + laborCost;

            // lưu labor cost vào maintenance
            maintenanceDAO.updateLaborCost(id, laborCost);

            // update total_cost = labor + parts
            maintenanceDAO.updateTotalCost(id, grandTotal);

            StringBuilder json = new StringBuilder();
            json.append("{");
            json.append("\"maintenanceId\":").append(id).append(",");
            json.append("\"technicianId\":").append(currentUser.getId()).append(",");
            json.append("\"actualDescription\":").append(toJsonString(task.getActualDescription())).append(",");
            json.append("\"laborCost\":").append(laborCost).append(",");
            json.append("\"partsTotal\":").append(partsTotal).append(",");
            json.append("\"grandTotal\":").append(grandTotal).append(",");
            json.append("\"materials\":[");

            for (int i = 0; i < materials.size(); i++) {
                MaintenanceSparePart m = materials.get(i);

                double unitPrice = 0;
                if (m.getQuantityUsed() > 0) {
                    unitPrice = m.getCostAtTime() / m.getQuantityUsed();
                }

                json.append("{")
                        .append("\"sparePartId\":").append(m.getSparePartId()).append(",")
                        .append("\"quantityUsed\":").append(m.getQuantityUsed()).append(",")
                        .append("\"unitPrice\":").append(unitPrice).append(",")
                        .append("\"costAtTime\":").append(m.getCostAtTime())
                        .append("}");

                if (i < materials.size() - 1) json.append(",");
            }
            json.append("]}");

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
        if ("/technical/spare-part-create".equals(path)) {

            SparePartDAO spareDAO = new SparePartDAO();

            SparePart p = new SparePart();
            p.setName(req.getParameter("name"));
            p.setPartCode(req.getParameter("partCode"));
            p.setUnit(req.getParameter("unit"));
            p.setQuantityInStock(Integer.parseInt(req.getParameter("quantityInStock")));
            p.setMinStockAlert(Integer.parseInt(req.getParameter("minStockAlert")));
            p.setPrice(Double.parseDouble(req.getParameter("price")));
            p.setDescription(req.getParameter("description"));

            boolean ok = spareDAO.insert(p);

            if (!ok) {
                resp.sendRedirect(req.getContextPath()
                        + "/technical/materials?error=duplicate_code");
                return;
            }

            resp.sendRedirect(req.getContextPath() + "/technical/materials?msg=created");
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


        if ("/technical/save-after-images".equals(path)) {

            int id = Integer.parseInt(req.getParameter("id"));
            Maintenance task = maintenanceDAO.getById(id);

            if (task == null
                    || task.getTechnicianId() != currentUser.getId()
                    || !"SCHEDULED".equals(task.getStatus())
                    ) {

                resp.sendRedirect(req.getContextPath() + "/technical/my-tasks");
                return;
            }

            SystemRequestDAO srDAO = new SystemRequestDAO();
            String quoteStatus = srDAO.getQuoteStatus(id);

            if (!"APPROVED_BY_CUSTOMER".equals(quoteStatus)) {
                resp.sendRedirect(req.getContextPath()
                        + "/technical/repair-report?id=" + id + "&error=customer_not_approved");
                return;
            }

            Collection<Part> parts = req.getParts();
            List<Part> validAfterImages = new java.util.ArrayList<>();

            for (Part part : parts) {
                if (!"afterImages".equals(part.getName())) continue;
                if (part.getSize() <= 0) continue;

                String ct = part.getContentType();
                if (ct == null || !ct.startsWith("image/")) continue;

                String submitted = part.getSubmittedFileName();
                if (submitted == null || submitted.trim().isEmpty()) continue;

                validAfterImages.add(part);
            }

            if (validAfterImages.isEmpty()) {
                resp.sendRedirect(req.getContextPath()
                        + "/technical/repair-report?id=" + id + "&error=noafterimage");
                return;
            }

            String uploadDir = getServletContext().getRealPath("/")
                    + "uploads" + File.separator + "maintenance";
            File dir = new File(uploadDir);
            if (!dir.exists()) dir.mkdirs();

            MaintenanceImageDAO imgDAO = new MaintenanceImageDAO();

            for (Part part : validAfterImages) {
                String submitted = Paths.get(part.getSubmittedFileName())
                        .getFileName().toString();

                String ext = "";
                int dot = submitted.lastIndexOf('.');
                if (dot >= 0) ext = submitted.substring(dot);

                String fileName = "m" + id + "_after_" + System.currentTimeMillis()
                        + "_" + java.util.UUID.randomUUID() + ext;

                String fullPath = uploadDir + File.separator + fileName;
                part.write(fullPath);

                String relativePath = "uploads/maintenance/" + fileName;
                imgDAO.insert(id, relativePath, "AFTER");
            }

            resp.sendRedirect(req.getContextPath()
                    + "/technical/repair-report?id=" + id + "&msg=after_saved");
            return;
        }
        if ("/technical/task-complete".equals(path)) {

            int id = Integer.parseInt(req.getParameter("id"));
            Maintenance task = maintenanceDAO.getById(id);

            if (task == null
                    || task.getTechnicianId() != currentUser.getId()
                    || !"SCHEDULED".equals(task.getStatus())) {

                resp.sendRedirect(req.getContextPath() + "/technical/my-tasks");
                return;
            }

            String actualDescription = task.getActualDescription();

            if (actualDescription == null || actualDescription.trim().isEmpty()) {
                if ("REPAIR".equals(task.getType())) {
                    resp.sendRedirect(req.getContextPath()
                            + "/technical/repair-report?id=" + id + "&error=noreport");
                } else {
                    resp.sendRedirect(req.getContextPath()
                            + "/technical/task-detail?id=" + id + "&error=noreport");
                }
                return;
            }

            if ("REPAIR".equals(task.getType())) {

                MaintenanceSparePartDAO mspDAO = new MaintenanceSparePartDAO();
                if (!mspDAO.hasMaterials(id)) {
                    resp.sendRedirect(req.getContextPath()
                            + "/technical/repair-report?id=" + id + "&error=nomaterial");
                    return;
                }

                SystemRequestDAO srDAO = new SystemRequestDAO();
                String quoteStatus = srDAO.getQuoteStatus(id);

                if (!"APPROVED_BY_CUSTOMER".equals(quoteStatus)) {
                    resp.sendRedirect(req.getContextPath()
                            + "/technical/repair-report?id=" + id + "&error=customer_not_approved");
                    return;
                }

                MaintenanceImageDAO imgDAO = new MaintenanceImageDAO();
                if (!imgDAO.hasImageByType(id, "AFTER")) {
                    resp.sendRedirect(req.getContextPath()
                            + "/technical/repair-report?id=" + id + "&error=noafterimage");
                    return;
                }
            }

            maintenanceDAO.markCompleted(id);

            ProductDAO productDAO = new ProductDAO();
            productDAO.updateStatus(task.getProductId(), "READY");

            SystemRequestDAO srDAO = new SystemRequestDAO();
            srDAO.markCompletedForCustomer(id);

            resp.sendRedirect(req.getContextPath()
                    + "/technical/repair-report?id=" + id + "&msg=completed");
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
