package com.generatorproject.controller.manager;

import com.generatorproject.model.*;
import com.generatorproject.services.*;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.IOException;
import java.sql.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(urlPatterns = {"/manager/contracts"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 50)
public class ManagementContractController extends HttpServlet {

    private final IContractServices contractService;
    private final IUserServices userServices;
    private final ProductServices productServices;
    private final IRequestServices requestServices;
    private final IProductModelServices  productModelServices;

    public ManagementContractController() {
        contractService = new ContractServices();
        userServices = new UserServices();
        productServices = new ProductServices();
        requestServices = new RequestServices();
        productModelServices = new ProductModelServices();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "create_view":
                showCreateForm(req, resp);
                break;
            case "edit_view":
                showEditForm(req, resp);
                break;
            case "delete":
                resp.sendRedirect("contracts?msg=invalid_action");
                break;
            case "list":
                showList(req, resp);
                break;
            case "assignSerialForm":
                showAssignSerialForm(req, resp);
                break;
            case "detail":
                showDetail(req, resp); break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "import":
                handleImportFile(req, resp);
                break;
            case "create":
            case "create.jsp":
                handleCreateManual(req, resp);
                break;
            case "update":
                handleUpdate(req, resp);
                break;
            case "request_account":
                handleRequestAccount(req, resp);
                break;
            case "assignSerialSubmit":
                submitAssignSerial(req, resp);
                break;
            case "terminate":
                handleTerminate(req, resp);
                break;
            default:
                showList(req, resp);
                break;
        }
    }

    private void showAssignSerialForm(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            Long contractId = Long.parseLong(req.getParameter("id"));

            Contract contract = contractService.findContractById(contractId);
            if (contract == null) {
                resp.sendError(404, "Không tìm thấy hợp đồng");
                return;
            }

            req.setAttribute("contract", contract);
            req.setAttribute("models", productModelServices.findAll()); // dropdown model

            req.getRequestDispatcher("/views/manager/contract/assign_serial.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/views/manager/contract/assign_serial.jsp").forward(req, resp);
        }
    }


    private void showList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String keyword = req.getParameter("keyword");
        String status = req.getParameter("status");
        req.setAttribute("contracts", contractService.searchAndFilterContracts(keyword, status));
        req.getRequestDispatcher("/views/manager/contract/contract-list.jsp").forward(req, resp);
    }

    private void showDetail(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            Long contractId = Long.parseLong(req.getParameter("id"));

            Contract contract = contractService.findContractDetail(contractId);
            if (contract == null) {
                req.setAttribute("errorMessage", "Không tìm thấy hợp đồng!");
                showList(req, resp);
                return;
            }

            Users customer = userServices.findUserById(contract.getCustomerId());

            List<Product> products = productServices.findByContractId(contractId);

            String selectedSerial = req.getParameter("serial");
            if ((selectedSerial == null || selectedSerial.isBlank()) && products != null && !products.isEmpty()) {
                selectedSerial = products.get(0).getSerialNumber();
            }

            Product selectedProduct = null;
            if (selectedSerial != null && !selectedSerial.isBlank()) {
                selectedProduct = productServices.findProductDetailBySerial(selectedSerial);
            }

            ContractEvent latestTerminatedEvent = contractService.findLatestTerminatedEvent(contractId);
            List<ContractEvent> contractEvents = contractService.findEventsByContractId(contractId);

            req.setAttribute("c", contract);
            req.setAttribute("u", customer);
            req.setAttribute("products", products);
            req.setAttribute("p", selectedProduct);
            req.setAttribute("selectedSerial", selectedSerial);
            req.setAttribute("terminatedEvent", latestTerminatedEvent);
            req.setAttribute("contractEvents", contractEvents);

            req.getRequestDispatcher("/views/manager/contract/contract-detail.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("contracts?msg=error");
        }
    }


    private void showCreateForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("customers", userServices.getUsersByRole(5));
        req.getRequestDispatcher("/views/manager/contract/contract-form.jsp").forward(req, resp);
    }

    private void showEditForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Long id = Long.parseLong(req.getParameter("id"));
        Contract c = contractService.findContractDetail(id);

        if (c == null) {
            resp.sendRedirect("contracts?msg=not_found");
            return;
        }

        if ("TERMINATED".equalsIgnoreCase(c.getStatus())) {
            resp.sendRedirect("contracts?msg=terminated_no_actions");
            return;
        }

        req.setAttribute("contract", c);
        req.setAttribute("customers", userServices.getUsersByRole(5));
        req.setAttribute("models", productModelServices.findAll());
        req.setAttribute("contractProducts", productServices.findByContractId(id));

        req.getRequestDispatcher("/views/manager/contract/contract-edit.jsp").forward(req, resp);
    }

    private void submitAssignSerial(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            Long contractId = Long.parseLong(req.getParameter("contractId"));
            String serialNumber = req.getParameter("serialNumber");

            String modelIdStr = req.getParameter("modelId");
            Long modelId = (modelIdStr == null || modelIdStr.isBlank()) ? null : Long.parseLong(modelIdStr);

            String purchaseDateStr = req.getParameter("purchaseDate");
            java.sql.Date purchaseDate = (purchaseDateStr == null || purchaseDateStr.isBlank())
                    ? null : java.sql.Date.valueOf(purchaseDateStr.trim());

            String manufactureYearStr = req.getParameter("manufactureYear");
            Integer manufactureYear = (manufactureYearStr == null || manufactureYearStr.isBlank())
                    ? null : Integer.parseInt(manufactureYearStr.trim());

            String currentLocation = req.getParameter("currentLocation");

            Long newProductId = contractService.assignSerialToContract(
                    contractId, serialNumber, modelId, purchaseDate, manufactureYear, currentLocation
            );

            resp.sendRedirect(req.getContextPath()
                    + "/manager/contracts?action=detail&id=" + contractId
                    + "&assignedProductId=" + newProductId);
        } catch (Exception e) {
            try {
                Long contractId = Long.parseLong(req.getParameter("contractId"));
                req.setAttribute("contract", contractService.findContractById(contractId));
                req.setAttribute("models", productModelServices.findAll());
            } catch (Exception ignored) {}

            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/contracts/assign_serial.jsp").forward(req, resp);
        }
    }


    private void handleRequestAccount(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            String email = req.getParameter("email");
            String fullName = req.getParameter("fullName");
            String phone  = req.getParameter("phone");

            Users manager = (Users) req.getSession().getAttribute("USERMODEL");


            if (requestServices.isRequestPending(email)) {
                resp.sendRedirect("contracts?msg=request_duplicate");
                return;
            }

            Map<String, String> dataPayload = new HashMap<>();
            dataPayload.put("email", email);
            dataPayload.put("fullName", fullName);
            dataPayload.put("phone", phone);

            // 2. Biến Map thành chuỗi JSON
            Gson gson = new Gson();
            String jsonData = gson.toJson(dataPayload);
            // Kết quả tự động sinh ra: {"email":"abc@gmail.com","fullName":"Nguyen Van A"}

            SystemRequest request = SystemRequest.builder()
                    .senderId((long) manager.getId())
                    .receiverRole("ADMIN")
                    .requestType("CREATE_USER")
                    .requestData(jsonData)
                    .status("PENDING")
                    .build();

            requestServices.save(request);
            resp.sendRedirect("contracts?msg=request_success");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("contracts?msg=error");
        }
    }

    private void handleImportFile(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            Users manager = (Users) req.getSession().getAttribute("USERMODEL");
            if (manager == null) {
                resp.sendRedirect(req.getContextPath() + "/account/login");
                return;
            }

            Part filePart = req.getPart("contractFile");
            if (filePart == null || filePart.getSize() == 0) {
                throw new Exception("Vui lòng chọn file hợp đồng (.docx)!");
            }

            Long newContractId = contractService.importContractFromDocx(filePart.getInputStream(), manager);

            resp.sendRedirect("contracts?msg=success&id=" + newContractId);

        } catch (Exception e) {
            String msg = e.getMessage();

            if (msg != null && msg.startsWith("MISSING_USER|")) {
                String email = "";
                String fullName = "Khách hàng mới";
                String phone = "";

                String[] parts = msg.split("\\|");
                for (String part : parts) {
                    if (part.startsWith("email=")) email = part.substring("email=".length());
                    if (part.startsWith("fullName=")) fullName = part.substring("fullName=".length());
                    if (part.startsWith("phoneNumber=")) phone = part.substring("phoneNumber=".length());
                }

                req.setAttribute("missingEmail", email);
                req.setAttribute("missingFullName", fullName);
                req.setAttribute("missingPhone", phone);

                req.setAttribute("errorMessage",
                        "Email '" + email + "' chưa có tài khoản hệ thống. Bạn có muốn gửi yêu cầu Admin tạo mới không?");
                showList(req, resp);
                return;
            }

            // Lỗi thật sự mới in stacktrace
            e.printStackTrace();
            req.setAttribute("errorMessage", msg);
            showList(req, resp);
        }
    }

    private void handleCreateManual(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        try {
            String contractNumber = req.getParameter("contractNumber");
            if (contractNumber == null || contractNumber.trim().isEmpty()) {
                req.setAttribute("errorMessage", "Vui lòng nhập Số hợp đồng!");
                showCreateForm(req, resp);
                return;
            }
            contractNumber = contractNumber.trim();

            String customerIdStr = req.getParameter("customerId");
            if (customerIdStr == null || customerIdStr.trim().isEmpty()) {
                req.setAttribute("errorMessage", "Vui lòng chọn Khách hàng!");
                showCreateForm(req, resp);
                return;
            }
            Long customerId = Long.parseLong(customerIdStr);

            String startDateStr = req.getParameter("startDate");
            String endDateStr = req.getParameter("endDate");
            if (startDateStr == null || endDateStr == null || startDateStr.isEmpty() || endDateStr.isEmpty()) {
                req.setAttribute("errorMessage", "Vui lòng chọn Ngày bắt đầu và Ngày kết thúc!");
                showCreateForm(req, resp);
                return;
            }

            Date startDate = Date.valueOf(startDateStr);
            Date endDate = Date.valueOf(endDateStr);

            // (optional) validate ngày
            if (endDate.before(startDate)) {
                req.setAttribute("errorMessage", "Ngày kết thúc phải >= ngày bắt đầu!");
                showCreateForm(req, resp);
                return;
            }

            Users manager = (Users) req.getSession().getAttribute("USERMODEL");
            if (manager == null) {
                resp.sendRedirect(req.getContextPath() + "/account/login");
                return;
            }

            Contract c = Contract.builder()
                    .contractNumber(contractNumber)
                    .customerId(Math.toIntExact(customerId))
                    .startDate(startDate)
                    .endDate(endDate)
                    .status("PENDING_SERIAL")
                    .managerId(manager.getId())
                    .build();

            Long newContractId = contractService.saveContract(c);

            // Redirect sang màn gán serial
            resp.sendRedirect(req.getContextPath()
                    + "/manager/contracts?action=assignSerialForm&id=" + newContractId);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", e.getMessage());
            showCreateForm(req, resp);
        }
    }

    private void handleUpdate(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        System.out.println(">>> Content-Type: " + req.getContentType());
        System.out.println(">>> ID Parameter: " + req.getParameter("id"));

        try {
            String idStr = req.getParameter("id");
            if (idStr == null || idStr.trim().isEmpty()) {
                req.setAttribute("errorMessage", "Lỗi: Không tìm thấy ID hợp đồng!");
                showEditForm(req, resp);
                return;
            }
            Long contractId = Long.parseLong(idStr);

            String contractNumber = req.getParameter("contractNumber");
            Long customerId = Long.parseLong(req.getParameter("customerId"));
            Date startDate = Date.valueOf(req.getParameter("startDate"));
            Date endDate = Date.valueOf(req.getParameter("endDate"));
            String status = req.getParameter("status");

            int mainProductId = 0;

            String[] serialNumbers = req.getParameterValues("serialNumbers");
            String[] inputModelNames = req.getParameterValues("inputModelNames");
            String[] manufactureYears = req.getParameterValues("manufactureYears");
            String[] currentLocations = req.getParameterValues("currentLocations");

            if (serialNumbers != null && serialNumbers.length > 0) {
                for (int i = 0; i < serialNumbers.length; i++) {
                    String serialNumber = serialNumbers[i] == null ? null : serialNumbers[i].trim();
                    if (serialNumber == null || serialNumber.isEmpty()) {
                        continue;
                    }

                    String inputModelName = (inputModelNames != null && i < inputModelNames.length)
                            ? inputModelNames[i]
                            : null;
                    if (inputModelName == null || inputModelName.trim().isEmpty()) {
                        req.setAttribute("errorMessage", "Vui lòng nhập tên máy phát điện cho serial " + serialNumber + "!");
                        showEditForm(req, resp);
                        return;
                    }

                    ProductModel model = productModelServices.findByName(inputModelName.trim());
                    if (model == null) {
                        req.setAttribute("errorMessage", "Lỗi: Dòng máy '" + inputModelName + "' chưa có trong hệ thống! (Serial " + serialNumber + ")");
                        showEditForm(req, resp);
                        return;
                    }

                    Product product = productServices.findProductBySerial(serialNumber);
                    if (product == null) {
                        product = new Product();
                        product.setSerialNumber(serialNumber);
                        product.setTotalRunningHours(0.0);
                        product.setPurchaseDate(startDate);
                        product.setContractId(contractId);
                    }

                    product.setCustomerId(customerId);
                    product.setContractId(contractId);
                    product.setModelId((long) model.getId());
                    product.setModelName(model.getName());
                    product.setStatus("RUNNING");

                    String manuYearStr = (manufactureYears != null && i < manufactureYears.length)
                            ? manufactureYears[i]
                            : null;
                    if (manuYearStr != null && !manuYearStr.trim().isEmpty()) {
                        product.setManufactureYear(Integer.parseInt(manuYearStr.trim()));
                    }

                    String currentLocation = (currentLocations != null && i < currentLocations.length)
                            ? currentLocations[i]
                            : null;
                    if (currentLocation != null && !currentLocation.trim().isEmpty()) {
                        product.setCurrentLocation(currentLocation.trim());
                    }

                    if (product.getId() == 0) {
                        Long newPid = productServices.save(product);
                        product.setId(Math.toIntExact(newPid));
                    } else {
                        productServices.update(product);
                    }

                    if (mainProductId == 0) {
                        mainProductId = product.getId();
                    }
                }
            } else {
                String serialNumber = req.getParameter("serialNumber");
                String inputModelName = req.getParameter("inputModelName");

                if (serialNumber == null || serialNumber.trim().isEmpty()) {
                    req.setAttribute("errorMessage", "Vui lòng nhập serial máy phát điện!");
                    showEditForm(req, resp);
                    return;
                }
                serialNumber = serialNumber.trim();

                if (inputModelName == null || inputModelName.trim().isEmpty()) {
                    req.setAttribute("errorMessage", "Vui lòng nhập tên máy phát điện!");
                    showEditForm(req, resp);
                    return;
                }

                ProductModel model = productModelServices.findByName(inputModelName.trim());
                if (model == null) {
                    req.setAttribute("errorMessage", "Lỗi: Dòng máy '" + inputModelName + "' chưa có trong hệ thống! Vui lòng chọn từ gợi ý.");
                    showEditForm(req, resp);
                    return;
                }

                Product product = productServices.findProductBySerial(serialNumber);
                if (product == null) {
                    product = new Product();
                    product.setSerialNumber(serialNumber);
                    product.setTotalRunningHours(0.0);
                    product.setPurchaseDate(startDate);
                    product.setContractId(contractId);
                }

                product.setCustomerId(customerId);
                product.setContractId(contractId);
                product.setModelId((long) model.getId());
                product.setModelName(model.getName());
                product.setStatus("RUNNING");

                String manuYearStr = req.getParameter("manufactureYear");
                if (manuYearStr != null && !manuYearStr.isEmpty()) {
                    product.setManufactureYear(Integer.parseInt(manuYearStr));
                }

                String currentLocation = req.getParameter("currentLocation");
                if (currentLocation != null && !currentLocation.trim().isEmpty()) {
                    product.setCurrentLocation(currentLocation.trim());
                }

                if (product.getId() == 0) {
                    Long newPid = productServices.save(product);
                    product.setId(Math.toIntExact(newPid));
                } else {
                    productServices.update(product);
                }

                mainProductId = product.getId();
            }

            if (mainProductId == 0) {
                Contract existing = contractService.findContractById(contractId);
                if (existing != null) {
                    mainProductId = existing.getProductId();
                }
            }

            Contract c = Contract.builder()
                    .id(contractId)
                    .contractNumber(contractNumber)
                    .customerId(Math.toIntExact(customerId))
                    .productId(mainProductId)
                    .startDate(startDate)
                    .endDate(endDate)
                    .status(status)
                    .managerId(((Users) req.getSession().getAttribute("USERMODEL")).getId())
                    .build();

            contractService.updateContract(c);

            resp.sendRedirect("contracts?msg=update_success");

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Lỗi tại handleUpdate: " + e.getMessage());
            resp.sendRedirect("contracts?msg=error");
        }
    }


    private void handleTerminate(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            Long id = Long.parseLong(req.getParameter("id"));

            Contract contract = contractService.findContractById(id);
            if (contract == null) {
                resp.sendRedirect("contracts?msg=not_found");
                return;
            }

            String reasonCode = req.getParameter("reasonCode");
            if (reasonCode == null || reasonCode.trim().isEmpty()) {
                reasonCode = "OTHER";
            }

            String terminatedReason = req.getParameter("terminatedReason");
            String decisionDoc = req.getParameter("decisionDoc");
            String note = req.getParameter("note");

            if ("OTHER".equalsIgnoreCase(reasonCode)
                    && (note == null || note.trim().isEmpty())) {
                resp.sendRedirect("contracts?action=detail&id=" + id + "&msg=terminate_note_required");
                return;
            }

            Users actor = (Users) req.getSession().getAttribute("USERMODEL");
            Long actorId = actor != null ? (long) actor.getId() : null;

            Map<String, String> extraMeta = new HashMap<>();
            String source = req.getParameter("source");
            if (source != null && !source.trim().isEmpty()) {
                extraMeta.put("source", source.trim());
            }
            extraMeta.put("ip", req.getRemoteAddr());
            String metaJson = extraMeta.isEmpty() ? null : new Gson().toJson(extraMeta);

            boolean terminated = contractService.terminateContract(
                    id,
                    reasonCode,
                    terminatedReason,
                    decisionDoc,
                    note,
                    actorId,
                    metaJson
            );

            if (!terminated) {
                resp.sendRedirect("contracts?msg=already_terminated");
                return;
            }

            resp.sendRedirect("contracts?action=detail&id=" + id + "&msg=terminated_success");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("contracts?msg=error");
        }
    }
}
