package com.generatorproject.controller.staff;

import com.generatorproject.dao.MaintenanceAssignmentDAO;
import com.generatorproject.dao.MaintenanceDAO;
import com.generatorproject.model.*;
import com.generatorproject.services.*;
import com.google.gson.Gson;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(urlPatterns = { "/staff/*" })
public class StaffManagementController extends HttpServlet {
    private final IRequestServices requestServices;
    private final IUserServices userServices;
    private final IContractServices contractServices;
    private final IProductServices productServices;
    private final IRepairWorkflowService repairWorkflowService;
    private final IInvoiceService invoiceService;
    private final MaintenanceDAO maintenanceDAO;
    private final MaintenanceAssignmentDAO maintenanceAssignmentDAO;
    private final IProductModelServices productModelServices;
    private final IIncidentServices incidentServices;
    private final IIncidentPlanService incidentPlanService;
    private final IncidentPlanRecommendationService incidentPlanRecommendationService;

    public StaffManagementController() {
        userServices = new UserServices();
        contractServices = new ContractServices();
        requestServices = new RequestServices();
        productServices = new ProductServices();
        repairWorkflowService = new RepairWorkflowService();
        invoiceService = new InvoiceService();
        maintenanceDAO = new MaintenanceDAO();
        maintenanceAssignmentDAO = new MaintenanceAssignmentDAO();
        productModelServices = new ProductModelServices();
        incidentServices = new IncidentServices();
        incidentPlanService = new IncidentPlanService();
        incidentPlanRecommendationService = new IncidentPlanRecommendationService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String path = req.getPathInfo();
        if (path == null || path.equals("/")) {
            path = "/incident-list";
        }
        switch (path) {
            case "/incident-list":
                handleIncidentList(req, resp);
                break;
            case "/user-information":
                handleUserInformation(req, resp);
                break;
            case "/customer-list":
                handleCustomerList(req, resp);
                break;
            case "/incident/verify":
                handleIncidentVerify(req, resp);
                break;
            case "/incident/escalate":
                handleIncidentEscalate(req, resp);
                break;
            case "/repair-request-list":
                handleRepairRequestList(req, resp);
                break;
            case "/repair-request/view":
                handleViewRepairRequest(req, resp);
                break;
            case "/repair-request/send-quote":
                handleSendQuoteToCustomer(req, resp);
                break;
            case "/customer-requests":
                handleCustomerRequestList(req, resp);
                break;
            case "/contracts":
                handleContractList(req, resp);
                break;
            case "/contract/detail":
                handleContractDetail(req, resp);
                break;
            case "/incident-view":
                showIncidentDetail(req, resp);
                break;
            case "/incident/work-order":
                handleIncidentWorkOrder(req, resp);
                break;
            case "/technician-availability":
                handleTechnicianAvailability(req, resp);
                break;
            case "/invoice-list":
                listInvoices(req, resp);
                break;
            case "/product/detail":
                handleProductDetail(req, resp);
                break;
        }
    }

    private void handleProductDetail(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String idParam = req.getParameter("id");

        if (idParam == null || idParam.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/staff/incident-list?message=missing_product_id");
            return;
        }

        try {
            int productId = Integer.parseInt(idParam);

            // 1. Lấy thông tin Máy cụ thể (Product thuần)
            Product product = productServices.getProductById(productId);

            if (product == null) {
                resp.sendRedirect(req.getContextPath() + "/staff/incident-listv?message=product_not_found");
                return;
            }

            // 2. Lấy thông tin Dòng máy (ProductModel) dựa vào modelId của Product
            if (product.getModelId() != null) {
                ProductModel productModel = productModelServices.findById(product.getModelId().intValue());
                req.setAttribute("productModel", productModel); // Đẩy riêng object này sang JSP
            }

            // 3. Lấy thông tin Hợp đồng (Contract)
            if (product.getContractId() != null && product.getContractId() > 0) {
                Contract contract = contractServices.findContractById(product.getContractId().longValue());
                req.setAttribute("contract", contract);
            }

            // 4. Đẩy Product sang JSP
            req.setAttribute("product", product);

            req.getRequestDispatcher("/views/staff/product-detail.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/staff/incident-list?message=error");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String path = req.getPathInfo();
        if ("/customer-request/respond".equals(path)) {
            handleCustomerRequestResponse(req, resp);
            return;
        }
        resp.sendError(HttpServletResponse.SC_NOT_FOUND);
    }

    private void showIncidentDetail(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            // 1. Lấy ID từ URL
            String idParam = req.getParameter("id");
            if (idParam == null || idParam.isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/staff/incident-list");
                return;
            }
            int incidentId = Integer.parseInt(idParam);

            SystemRequest incident = requestServices.findById((long) incidentId);

            if (incident == null) {
                resp.sendRedirect(req.getContextPath() + "/staff/incident-list?error=notfound");
                return;
            }

            Product product = null;
            Product requestProduct = getProductFromRequest(incident);
            if (requestProduct != null && requestProduct.getId() > 0) {
                product = productServices.getProductById(requestProduct.getId());
            }

            Incident incidentEntity = null;
            Long incidentEntityId = extractIdFromRequestInfo(incident, "incidentId");
            if (incidentEntityId != null) {
                incidentEntity = incidentServices.findById(incidentEntityId);
            }

            // 4. Truyền ra JSP
            req.setAttribute("incident", incident);
            req.setAttribute("incidentEntity", incidentEntity);
            req.setAttribute("product", product);

            req.getRequestDispatcher("/views/staff/incident-detail.jsp").forward(req, resp);

        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/staff/incident-list");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/staff/incident-list");
        }

    }

    private void listInvoices(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 1. Lấy tham số lọc
        String keyword = req.getParameter("keyword");
        String status = req.getParameter("status");

        // 2. Xử lý Page
        int page = 1;
        try {
            String pageParam = req.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty())
                page = Integer.parseInt(pageParam);
        } catch (NumberFormatException e) {
            page = 1;
        }

        // 3. Xử lý PageSize
        int pageSize = 10;
        try {
            String pageSizeParam = req.getParameter("pageSize");
            if (pageSizeParam != null && !pageSizeParam.isEmpty())
                pageSize = Integer.parseInt(pageSizeParam);
        } catch (NumberFormatException e) {
            pageSize = 10;
        }

        // 4. Gọi Service
        int totalRecords = invoiceService.countInvoices(keyword, status);
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

        if (page > totalPages && totalPages > 0)
            page = 1;

        List<Invoice> invoices = invoiceService.getAllInvoices(keyword, status, page, pageSize);

        // 5. Đẩy dữ liệu ra JSP
        req.setAttribute("invoices", invoices);

        // Truyền lại các biến để giữ trạng thái trên giao diện
        req.setAttribute("currentPage", page);
        req.setAttribute("pageSize", pageSize);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalRecords", totalRecords);
        req.setAttribute("keyword", keyword);
        req.setAttribute("status", status);

        // Forward về đúng file JSP cũ
        req.getRequestDispatcher("/views/staff/invoice-list.jsp").forward(req, resp);
    }

    private void handleSendQuoteToCustomer(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String reqIdParam = req.getParameter("requestId");

        if (reqIdParam == null || reqIdParam.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/staff/repair-request-list?message=missing_id");
            return;
        }

        try {
            Long requestId = Long.parseLong(reqIdParam);

            // TODO: Lấy staffId từ session người dùng đang đăng nhập
            Long staffId = 10L; // Mock ID tạm thời

            // Gọi service để đổi trạng thái và chuyển Request cho Khách hàng
            repairWorkflowService.processStaffSendToCustomer(requestId, staffId);

            // Xử lý xong thì quay ngược lại trang Danh sách kèm thông báo thành công trên
            // URL
            resp.sendRedirect(req.getContextPath() + "/staff/repair-request-list?message=send_success");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/staff/repair-request-list?message=error");
        }
    }

    private void handleViewRepairRequest(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String reqIdParam = req.getParameter("requestId");

        if (reqIdParam == null || reqIdParam.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/staff/repair-request-list?message=missing_id");
            return;
        }

        try {
            Long requestId = Long.parseLong(reqIdParam);

            // Gọi Service để lấy dữ liệu DTO đã được map tên vật tư
            SystemRequest sysReq = requestServices.findById(requestId);
            req.setAttribute("currentStatus", sysReq != null ? sysReq.getStatus() : "");
            RepairRequestDTO dto = repairWorkflowService.getRepairRequestDetails(requestId);

            // ==========================================
            // BỔ SUNG: LẤY TÊN KỸ THUẬT VIÊN TỪ DB
            // ==========================================
            String technicianName = "Không xác định";
            if (dto != null && dto.getTechnicianId() != null) {
                // Khởi tạo DAO (Đổi tên UserDAO cho khớp với class thực tế của bạn nếu cần)

                Users technician = userServices.findUserById(dto.getTechnicianId());

                if (technician != null && technician.getFullName() != null) {
                    technicianName = technician.getFullName();
                }
            }
            // Đẩy biến tên KTV sang JSP độc lập với DTO
            req.setAttribute("technicianName", technicianName);
            // ==========================================

            // Đẩy DTO sang JSP để in ra màn hình
            req.setAttribute("repairRequest", dto);

            // Ép DTO thành chuỗi JSON thô đẩy sang JSP để dùng cho Javascript khi submit
            // (Approve)
            req.setAttribute("rawJsonData", new Gson().toJson(dto));

            // Chuyển hướng sang trang chi tiết
            req.getRequestDispatcher("/views/staff/view-repair-request.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/staff/repair-request-list?message=error");
        }
    }

    private void handleRepairRequestList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // 1. Lấy tham số bộ lọc từ URL
        String fromDateParam = req.getParameter("fromDate");
        String toDateParam = req.getParameter("toDate");
        String status = req.getParameter("status");

        // 2. Xử lý chuỗi Date
        Date fromDate = null;
        Date toDate = null;
        try {
            if (fromDateParam != null && !fromDateParam.isEmpty())
                fromDate = Date.valueOf(fromDateParam);
            if (toDateParam != null && !toDateParam.isEmpty())
                toDate = Date.valueOf(toDateParam);
        } catch (IllegalArgumentException e) {
            e.printStackTrace();
        }

        // 3. Xử lý Phân trang
        int page = 1;
        int pageSize = 5;
        if (req.getParameter("page") != null) {
            try {
                page = Integer.parseInt(req.getParameter("page"));
                if (page < 1)
                    page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        try {
            String requestType = "REPAIR_QUOTE";

            // Lấy tổng số lượng và tính toán trang
            int totalRequests = requestServices.countByFilter(fromDate, toDate, status, requestType);
            int totalPages = (int) Math.ceil((double) totalRequests / pageSize);

            if (page > totalPages && totalPages > 0)
                page = 1;

            // Lấy danh sách Request từ DB
            List<SystemRequest> listRequests = requestServices.getByFilter(fromDate, toDate, status, requestType, page,
                    pageSize);

            Map<Long, Product> relatedProducts = new HashMap<>();
            Map<Long, String> technicianNames = new HashMap<>();

            // 4. DUYỆT DANH SÁCH 1 LẦN DUY NHẤT ĐỂ TỐI ƯU HIỆU NĂNG
            for (SystemRequest sysReq : listRequests) {

                // --- A. CẬP NHẬT TRẠNG THÁI COMPLETED TỪ MAINTENANCE ---
                Long maintenanceId = extractIdFromRequestInfo(sysReq, "maintenanceId");
                if (maintenanceId != null) {
                    Maintenance maintenance = maintenanceDAO.getById(maintenanceId.intValue());

                    if (maintenance != null && "COMPLETED".equalsIgnoreCase(maintenance.getStatus())) {
                        String currentStatus = sysReq.getStatus();
                        // ĐIỂM SỬA QUAN TRỌNG:
                        // Chỉ tự động chuyển sang COMPLETED nếu nó chưa bị đổi thành INVOICED
                        if (!"COMPLETED".equalsIgnoreCase(currentStatus)
                                && !"INVOICED".equalsIgnoreCase(currentStatus)) {
                            requestServices.updateStatus(sysReq.getId().intValue(), "COMPLETED");
                            sysReq.setStatus("COMPLETED"); // Cập nhật trên UI
                        }
                    }
                }

                // --- B. LẤY THÔNG TIN SẢN PHẨM ---
                Product p = getProductFromRequest(sysReq);
                if (p != null) {
                    relatedProducts.put(sysReq.getId(), p);
                }

                // --- C. LẤY TÊN KỸ THUẬT VIÊN TỪ CHUỖI JSON ---
                Long ktvId = extractIdFromRequestInfo(sysReq, "technicianId");
                if (ktvId != null) {
                    Users ktv = userServices.findUserById(ktvId.intValue());
                    if (ktv != null) {
                        technicianNames.put(sysReq.getId(), ktv.getFullName());
                    } else {
                        technicianNames.put(sysReq.getId(), "KTV không tồn tại");
                    }
                } else {
                    technicianNames.put(sysReq.getId(), "Chưa có KTV");
                }
            }

            // 5. Gửi toàn bộ dữ liệu sang JSP
            req.setAttribute("technicianNames", technicianNames);
            req.setAttribute("listRequests", listRequests);
            req.setAttribute("relatedProducts", relatedProducts);

            req.setAttribute("totalPages", totalPages);
            req.setAttribute("currentPage", page);

            req.setAttribute("fromDate", fromDateParam);
            req.setAttribute("toDate", toDateParam);
            req.setAttribute("status", status);

            req.getRequestDispatcher("/views/staff/repair-request-list.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/staff/incident-list?message=error");
        }
    }

    private void handleCustomerList(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {
        String keyword = req.getParameter("keyword");

        int page = 1;
        int pageSize = 5;

        if (req.getParameter("page") != null) {
            try {
                page = Integer.parseInt(req.getParameter("page"));
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        int totalUsers = userServices.countCustomerByFilter(keyword);
        int totalPages = (int) Math.ceil((double) totalUsers / pageSize);
        List<Users> listUsers = userServices.getCustomerByFilter(keyword, page, pageSize);

        req.setAttribute("listUsers", listUsers);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("currentPage", page);

        RequestDispatcher rd = req.getRequestDispatcher("/views/staff/customer-list.jsp");
        rd.forward(req, resp);
    }

    private void handleUserInformation(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {
        String idParam = req.getParameter("id");

        if (idParam != null) {
            try {
                int userId = Integer.parseInt(idParam);
                Users user = userServices.findUserById(userId);
                List<Contract> listContracts = contractServices.getContractByCustomerId(userId);

                // THÊM MỚI: Lấy danh sách máy phát điện (Products) của khách hàng này
                // Giả sử bạn đã khởi tạo productServices ở đầu class Controller
                List<Product> listProducts = productServices.getAllProductByCustomerId(userId);

                if (user != null) {
                    req.setAttribute("user", user);
                    req.setAttribute("listContracts", listContracts);

                    // THÊM MỚI: Đẩy danh sách máy ra JSP
                    req.setAttribute("listProducts", listProducts);

                    req.getRequestDispatcher("/views/staff/user-information.jsp").forward(req, resp);
                } else {
                    req.setAttribute("errorMessage", "Không tìm thấy người dùng này!");
                    req.getRequestDispatcher("/views/error/404.jsp").forward(req, resp);
                }
            } catch (NumberFormatException e) {
                resp.sendRedirect(req.getContextPath() + "/staff/incident-list");
            }
        } else {
            resp.sendRedirect(req.getContextPath() + "/staff/incident-list");
        }
    }

    private void handleIncidentList(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {
        // 1. Lấy tham số từ URL
        String fromDateParam = req.getParameter("fromDate");
        String toDateParam = req.getParameter("toDate");
        String status = req.getParameter("status");

        // 2. Xử lý Date
        Date fromDate = null;
        Date toDate = null;
        try {
            if (fromDateParam != null && !fromDateParam.isEmpty())
                fromDate = Date.valueOf(fromDateParam);
            if (toDateParam != null && !toDateParam.isEmpty())
                toDate = Date.valueOf(toDateParam);
        } catch (IllegalArgumentException e) {
            e.printStackTrace();
        }

        // 3. Xử lý Phân trang
        int page = 1;
        int pageSize = 5;
        if (req.getParameter("page") != null) {
            try {
                page = Integer.parseInt(req.getParameter("page"));
                if (page < 1)
                    page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        // 4. GỌI SERVICE
        String requestType = "INCIDENT_REPORT";
        int totalRequests = requestServices.countByFilter(fromDate, toDate, status, requestType);
        int totalPages = (int) Math.ceil((double) totalRequests / pageSize);

        List<SystemRequest> listRequests = requestServices.getByFilter(fromDate, toDate, status, requestType, page,
                pageSize);

        Map<Long, Product> relatedProducts = new HashMap<>();

        for (SystemRequest sysReq : listRequests) {
            // Tận dụng hàm phụ trợ getProductFromRequest thay vì viết lại logic parse JSON
            Product p = getProductFromRequest(sysReq);
            if (p != null) {
                relatedProducts.put(sysReq.getId(), p);
            }
        }
        // -----------------------------------------------------

        req.setAttribute("relatedProducts", relatedProducts);
        List<Users> listTechnicians = userServices.findUserByRoleId(4);

        req.setAttribute("listRequests", listRequests);
        req.setAttribute("listTechnicians", listTechnicians);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("currentPage", page);
        req.setAttribute("fromDate", fromDateParam);
        req.setAttribute("toDate", toDateParam);
        req.setAttribute("status", status);

        // Chú ý: Đảm bảo tên file JSP khớp với file bạn đã tạo (incident-list.jsp hoặc
        // incident-request.jsp)
        RequestDispatcher rd = req.getRequestDispatcher("/views/staff/incident-request.jsp");
        rd.forward(req, resp);
    }

    private void handleIncidentVerify(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            long requestId = Long.parseLong(req.getParameter("id"));
            SystemRequest sysReq = requestServices.findById(requestId);

            if (sysReq == null) {
                resp.sendRedirect(req.getContextPath() + "/staff/incident-list?message=not_found");
                return;
            }

            // 1. Lấy sản phẩm trong Request
            Product requestedProduct = getProductFromRequest(sysReq);

            // 2. Lấy danh sách TẤT CẢ sản phẩm của khách hàng này
            int customerId = Math.toIntExact(sysReq.getSenderId());
            List<Product> customerAssets = productServices.getAllProductByCustomerId(customerId);

            // 3. Gửi dữ liệu sang JSP
            req.setAttribute("req", sysReq);
            req.setAttribute("requestedProduct", requestedProduct);
            req.setAttribute("customerAssets", customerAssets);

            req.getRequestDispatcher("/views/staff/incident-verify.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/staff/incident-list?message=error");
        }
    }

    private void handleIncidentEscalate(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            // 1. Lấy ID từ URL
            long requestId = Long.parseLong(req.getParameter("id"));

            // 2. Tìm Request
            SystemRequest sysReq = requestServices.findById(requestId);

            if (sysReq == null) {
                resp.sendRedirect(req.getContextPath() + "/staff/incident-list?message=not_found");
                return;
            }

            // 3. Lấy thông tin máy (Product)
            Product product = getProductFromRequest(sysReq);

            Incident incident = null;
            if (sysReq.getInfo() != null && sysReq.getInfo().get("incidentId") != null) {
                Long incidentId = parseLongValue(sysReq.getInfo().get("incidentId"));
                if (incidentId != null) {
                    incident = incidentServices.findById(incidentId);
                }
            }

            // 4. Gửi dữ liệu sang JSP
            req.setAttribute("req", sysReq);
            req.setAttribute("prod", product);
            req.setAttribute("incidentEntity", incident);
            req.setAttribute("planRecommendations",
                    incidentPlanRecommendationService.buildRecommendations(incident, product));

            req.getRequestDispatcher("/views/staff/incident-escalate.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/staff/incident-list?message=error");
        }
    }

    private void handleIncidentWorkOrder(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            long requestId = Long.parseLong(req.getParameter("id"));
            SystemRequest sysReq = requestServices.findById(requestId);
            if (sysReq == null || sysReq.getInfo() == null) {
                resp.sendRedirect(req.getContextPath() + "/staff/incident-list?message=not_found");
                return;
            }

            Long incidentId = parseLongValue(sysReq.getInfo().get("incidentId"));
            Long incidentPlanId = parseLongValue(sysReq.getInfo().get("incidentPlanId"));
            if (incidentId == null || incidentPlanId == null) {
                resp.sendRedirect(req.getContextPath() + "/staff/incident-list?message=not_found");
                return;
            }

            Incident incident = incidentServices.findById(incidentId);
            IncidentPlan incidentPlan = incidentPlanService.findById(incidentPlanId);
            Product product = incident != null ? productServices.getProductById(incident.getProductId()) : null;
            List<Users> listTechnicians = userServices.findUserByRoleId(4);

            Long recommendedTechnicianId = parseLongValue(sysReq.getInfo().get("technicianId"));
            Timestamp preferredStart = resolvePreferredStart(incident);
            Timestamp preferredEnd = resolvePreferredEnd(incident, incidentPlan, preferredStart);

            req.setAttribute("req", sysReq);
            req.setAttribute("incidentEntity", incident);
            req.setAttribute("incidentPlan", incidentPlan);
            req.setAttribute("prod", product);
            req.setAttribute("listTechnicians", listTechnicians);
            req.setAttribute("recommendedTechnicianId", recommendedTechnicianId);
            req.setAttribute("preferredScheduledStart", formatDateTimeLocal(preferredStart));
            req.setAttribute("preferredScheduledEnd", formatDateTimeLocal(preferredEnd));
            req.getRequestDispatcher("/views/staff/incident-work-order.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/staff/incident-list?message=error");
        }
    }

    private void handleTechnicianAvailability(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");

        Map<String, Object> payload = new HashMap<>();
        try {
            String technicianIdRaw = req.getParameter("technicianId");
            if (technicianIdRaw == null || technicianIdRaw.trim().isEmpty()) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                payload.put("message", "Thiếu technicianId");
                resp.getWriter().write(new Gson().toJson(payload));
                return;
            }

            int technicianId = Integer.parseInt(technicianIdRaw.trim());
            Timestamp selectedStart = parseDateTimeLocal(req.getParameter("scheduledStart"));
            Timestamp selectedEnd = parseDateTimeLocal(req.getParameter("scheduledEnd"));

            Timestamp windowStart = selectedStart != null
                    ? Timestamp.valueOf(selectedStart.toLocalDateTime().toLocalDate().atStartOfDay())
                    : new Timestamp(System.currentTimeMillis());
            Timestamp windowEnd = selectedEnd != null
                    ? Timestamp.valueOf(selectedEnd.toLocalDateTime().toLocalDate().plusDays(1).atStartOfDay())
                    : new Timestamp(windowStart.getTime() + 7L * 24 * 60 * 60 * 1000);

            Users technician = userServices.findUserById(technicianId);
            boolean hasConflict = selectedStart != null && selectedEnd != null
                    && maintenanceAssignmentDAO.hasScheduleConflict(technicianId, selectedStart, selectedEnd);

            payload.put("technicianId", technicianId);
            payload.put("technicianName",
                    technician == null ? "Kỹ thuật viên #" + technicianId : technician.getFullName());
            payload.put("hasConflict", hasConflict);
            payload.put("windowStart", windowStart);
            payload.put("windowEnd", windowEnd);
            payload.put("schedules",
                    maintenanceAssignmentDAO.findSchedulesForTechnician(technicianId, windowStart, windowEnd));
            resp.getWriter().write(new Gson().toJson(payload));
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            payload.put("message", "Không thể tải lịch kỹ thuật viên");
            resp.getWriter().write(new Gson().toJson(payload));
        }
    }


    private Timestamp resolvePreferredStart(Incident incident) {
        if (incident == null || incident.getPreferredDate() == null) {
            return null;
        }
        Time preferredFrom = incident.getPreferredTimeFrom();
        if (preferredFrom != null) {
            return Timestamp.valueOf(incident.getPreferredDate().toLocalDate().atTime(preferredFrom.toLocalTime()));
        }
        return Timestamp.valueOf(incident.getPreferredDate().toLocalDate().atTime(8, 0));
    }

    private Timestamp resolvePreferredEnd(Incident incident, IncidentPlan incidentPlan, Timestamp preferredStart) {
        if (preferredStart == null) {
            return null;
        }
        if (incident != null && incident.getPreferredTimeTo() != null) {
            return Timestamp.valueOf(incident.getPreferredDate().toLocalDate().atTime(incident.getPreferredTimeTo().toLocalTime()));
        }
        int durationMinutes = incidentPlan != null && incidentPlan.getEstimatedDurationMinutes() > 0
                ? incidentPlan.getEstimatedDurationMinutes()
                : 120;
        return new Timestamp(preferredStart.getTime() + durationMinutes * 60L * 1000L);
    }

    private String formatDateTimeLocal(Timestamp timestamp) {
        if (timestamp == null) {
            return null;
        }
        return new SimpleDateFormat("yyyy-MM-dd'T'HH:mm").format(timestamp);
    }

    private Timestamp parseDateTimeLocal(String rawValue) {
        try {
            if (rawValue == null || rawValue.trim().isEmpty()) {
                return null;
            }
            return Timestamp.valueOf(rawValue.trim().replace("T", " ") + ":00");
        } catch (Exception e) {
            return null;
        }
    }

    private void handleCustomerRequestList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<SystemRequest> requests = requestServices.findByRoleAndType("STAFF", "CUSTOMER_SUPPORT");

        Map<Long, Users> senders = new HashMap<>();
        Map<Long, Map<String, Object>> requestPayloads = new HashMap<>();

        for (SystemRequest systemRequest : requests) {
            Users sender = userServices.findUserById(Math.toIntExact(systemRequest.getSenderId()));
            if (sender != null) {
                senders.put(systemRequest.getId(), sender);
            }
            requestPayloads.put(systemRequest.getId(), systemRequest.getInfo());
        }

        req.setAttribute("customerRequests", requests);
        req.setAttribute("requestSenders", senders);
        req.setAttribute("requestPayloads", requestPayloads);

        req.getRequestDispatcher("/views/staff/customer-request-list.jsp").forward(req, resp);
    }

    private void handleCustomerRequestResponse(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            Users staff = (Users) req.getSession().getAttribute("USERMODEL");
            if (staff == null || (staff.getRoleId() != 3 && staff.getRoleId() != 1)) {
                resp.sendRedirect(req.getContextPath() + "/account/login");
                return;
            }

            long requestId = Long.parseLong(req.getParameter("requestId"));
            String responseMessage = req.getParameter("responseMessage");
            String action = req.getParameter("action");

            SystemRequest systemRequest = requestServices.findById(requestId);
            if (systemRequest == null || !"CUSTOMER_SUPPORT".equals(systemRequest.getRequestType())) {
                resp.sendRedirect(req.getContextPath() + "/staff/customer-requests?message=not_found");
                return;
            }

            if (responseMessage == null || responseMessage.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/staff/customer-requests?message=missing_response");
                return;
            }

            String newStatus = "RESPONDED";
            if ("REJECT".equalsIgnoreCase(action)) {
                newStatus = "REJECTED";
            }

            systemRequest.setStatus(newStatus);
            systemRequest.setResponseMessage(responseMessage.trim());
            systemRequest.setReceiverRole("USER");
            requestServices.update(systemRequest);

            resp.sendRedirect(req.getContextPath() + "/staff/customer-requests?message=responded");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/staff/customer-requests?message=error");
        }
    }

    private void handleContractList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String keyword = req.getParameter("keyword");
        String status = req.getParameter("status");

        List<Contract> contracts = contractServices.searchAndFilterContracts(keyword, status);
        req.setAttribute("contracts", contracts);
        req.setAttribute("keyword", keyword);
        req.setAttribute("status", status);

        req.getRequestDispatcher("/views/staff/contract-list.jsp").forward(req, resp);
    }

    private void handleContractDetail(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            Long contractId = Long.parseLong(req.getParameter("id"));
            Contract contract = contractServices.findContractDetail(contractId);
            if (contract == null) {
                resp.sendRedirect(req.getContextPath() + "/staff/contracts?message=not_found");
                return;
            }

            Users customer = userServices.findUserById(contract.getCustomerId());
            List<Product> products = productServices.findByContractId(contractId);
            List<ContractEvent> contractEvents = contractServices.findEventsByContractId(contractId);

            req.setAttribute("c", contract);
            req.setAttribute("u", customer);
            req.setAttribute("products", products);
            req.setAttribute("contractEvents", contractEvents);

            req.getRequestDispatcher("/views/staff/contract-detail.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/staff/contracts?message=error");
        }
    }

    // --- HÀM PHỤ TRỢ ---
    private Product getProductFromRequest(SystemRequest sysReq) {
        if (sysReq == null)
            return null;

        Map<String, Object> info = sysReq.getInfo();
        if (info != null && info.containsKey("productId")) {
            try {
                String pIdStr = String.valueOf(info.get("productId"));
                if (pIdStr.contains(".")) {
                    pIdStr = pIdStr.substring(0, pIdStr.indexOf("."));
                }
                int pId = Integer.parseInt(pIdStr);
                return productServices.getProductById(pId);
            } catch (Exception e) {
                System.err.println("Error parsing Product ID for Request ID: " + sysReq.getId());
            }
        }
        return null;
    }

    private Long extractIdFromRequestInfo(SystemRequest sysReq, String keyName) {
        if (sysReq == null || sysReq.getInfo() == null) {
            return null;
        }

        Map<String, Object> info = sysReq.getInfo();
        if (info.containsKey(keyName) && info.get(keyName) != null) {
            try {
                String idStr = String.valueOf(info.get(keyName));
                // Xử lý trường hợp Gson/Jackson tự động parse số thành Double (VD: "1.0")
                if (idStr.contains(".")) {
                    idStr = idStr.substring(0, idStr.indexOf("."));
                }
                return Long.parseLong(idStr);
            } catch (Exception e) {
                System.err.println("Lỗi khi parse key '" + keyName + "' cho Request ID: " + sysReq.getId());
            }
        }
        return null;
    }

    private Long parseLongValue(Object raw) {
        if (raw == null) {
            return null;
        }
        if (raw instanceof Number) {
            return ((Number) raw).longValue();
        }
        try {
            String value = String.valueOf(raw).trim();
            if (value.isEmpty()) {
                return null;
            }
            if (value.contains(".")) {
                return (long) Double.parseDouble(value);
            }
            return Long.parseLong(value);
        } catch (Exception e) {
            return null;
        }
    }
}
