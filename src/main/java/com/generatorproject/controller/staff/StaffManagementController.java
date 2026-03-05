package com.generatorproject.controller.staff;

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

    public StaffManagementController() {
        userServices = new UserServices();
        contractServices = new ContractServices();
        requestServices = new RequestServices();
        productServices = new ProductServices();
        repairWorkflowService = new RepairWorkflowService();
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

            // Xử lý xong thì quay ngược lại trang Danh sách kèm thông báo thành công trên URL
            resp.sendRedirect(req.getContextPath() + "/staff/repair-request-list?message=send_success");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/staff/repair-request-list?message=error");
        }
    }
    private void handleViewRepairRequest(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String reqIdParam = req.getParameter("requestId");

        if (reqIdParam == null || reqIdParam.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/staff/repair-request-list?message=missing_id");
            return;
        }

        try {
            Long requestId = Long.parseLong(reqIdParam);

            // Gọi Service để lấy dữ liệu DTO đã được map tên vật tư
            RepairRequestDTO dto = repairWorkflowService.getRepairRequestDetails(requestId);

            // Đẩy DTO sang JSP để in ra màn hình
            req.setAttribute("repairRequest", dto);
            // Ép DTO thành chuỗi JSON thô đẩy sang JSP để dùng cho Javascript khi submit (Approve)
            req.setAttribute("rawJsonData", new Gson().toJson(dto));

            // Chuyển hướng sang trang chi tiết
            req.getRequestDispatcher("/views/staff/view-repair-request.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/staff/repair-request-list?message=error");
        }
    }
    private void handleRepairRequestList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {


        try {
            // Giả sử requestServices của bạn có gọi xuống hàm findInboxByRole của RequestDAO
            // Lấy tất cả các Request được gửi cho STAFF
            List<SystemRequest> listRequests = requestServices.findByRoleAndType("STAFF", "REPAIR_QUOTE");

            // Gửi dữ liệu sang JSP
            req.setAttribute("listRequests", listRequests);


            // Chuyển hướng sang trang giao diện hiển thị bảng (danh sách)
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

                if (user != null) {
                    req.setAttribute("user", user);
                    req.setAttribute("listContracts", listContracts);
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

    private void handleIncidentList(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
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
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        // 4. GỌI SERVICE
        String requestType = "INCIDENT_REPORT";
        int totalRequests = requestServices.countByFilter(fromDate, toDate, status, requestType);
        int totalPages = (int) Math.ceil((double) totalRequests / pageSize);

        List<SystemRequest> listRequests = requestServices.getByFilter(fromDate, toDate, status, requestType, page, pageSize);

        // --- ĐOẠN CODE BẠN BỊ THIẾU ĐÃ ĐƯỢC THÊM LẠI Ở ĐÂY ---
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

        // Chú ý: Đảm bảo tên file JSP khớp với file bạn đã tạo (incident-list.jsp hoặc incident-request.jsp)
        RequestDispatcher rd = req.getRequestDispatcher("/views/staff/incident-request.jsp");
        rd.forward(req, resp);
    }

    private void handleIncidentVerify(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
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

    private void handleIncidentEscalate(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
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

            // 4. Lấy danh sách Kỹ thuật viên
            List<Users> listTechnicians = userServices.findUserByRoleId(4);

            // 5. Gửi dữ liệu sang JSP
            req.setAttribute("req", sysReq);
            req.setAttribute("prod", product);
            req.setAttribute("listTechnicians", listTechnicians);

            req.getRequestDispatcher("/views/staff/incident-escalate.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/staff/incident-list?message=error");
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
            systemRequest.setSenderId((long) staff.getId());
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
}