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
                handleDelete(req, resp);
                break;
            case "list":
                showList(req, resp);
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
                handleCreateManual(req, resp);
                break;
            case "update":
                handleUpdate(req, resp);
                break;
            case "request_account":
                handleRequestAccount(req, resp);
                break;
            default:
                showList(req, resp);
                break;
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
            String idStr = req.getParameter("id");
            if (idStr == null || idStr.isEmpty()) {
                resp.sendRedirect("contracts?msg=error");
                return;
            }
            Long id = Long.parseLong(idStr);

            Contract contract = contractService.findContractDetail(id);

            if (contract == null) {
                req.setAttribute("errorMessage", "Không tìm thấy hợp đồng!");
                showList(req, resp);
                return;
            }

            Product product = productServices.findProductBySerial(contract.getProductSerial());

            Users customer = userServices.findUserById(contract.getCustomerId());

            req.setAttribute("c", contract);
            req.setAttribute("p", product);
            req.setAttribute("u", customer);

            req.getRequestDispatcher("/views/manager/contract/contract-detail.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("contracts?msg=error");
        }
    }

    private void showCreateForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("customers", userServices.getUsersByRole(5));
        req.setAttribute("products", productServices.findAll());
        req.getRequestDispatcher("/views/manager/contract/contract-form.jsp").forward(req, resp);
    }

    private void showEditForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Long id = Long.parseLong(req.getParameter("id"));
        Contract c = contractService.findContractDetail(id);

        req.setAttribute("contract", c);
        req.setAttribute("customers", userServices.getUsersByRole(5));
        req.setAttribute("products", productServices.findAll());

        req.getRequestDispatcher("/views/manager/contract/contract-edit.jsp").forward(req, resp);
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

            // Sau này muốn thêm field gì cứ put vào đây, ví dụ:
            // dataPayload.put("phone", "09123...");

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
            e.printStackTrace(); // In lỗi ra console để debug

            String errorMsg = e.getMessage();

            if (errorMsg != null && errorMsg.contains("chưa có tài khoản")) {
                try {
                    int start = errorMsg.indexOf("'");
                    int end = errorMsg.lastIndexOf("'");

                    if (start != -1 && end > start) {
                        String extractedEmail = errorMsg.substring(start + 1, end);
                        req.setAttribute("missingEmail", extractedEmail);
                    }
                } catch (Exception ex) {
                }
            }

            req.setAttribute("errorMessage", errorMsg);

            showList(req, resp);
        }
    }

    private void handleCreateManual(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        try {
            String contractNumber = req.getParameter("contractNumber");

            String serialNumber = req.getParameter("serialNumber");
            if (serialNumber == null || serialNumber.trim().isEmpty()) {
                req.setAttribute("errorMessage", "Vui lòng nhập Số Serial!");
                showCreateForm(req, resp);
                return;
            }
            serialNumber = serialNumber.trim();

            Long customerId = Long.parseLong(req.getParameter("customerId"));
            Date startDate = Date.valueOf(req.getParameter("startDate"));
            Date endDate = Date.valueOf(req.getParameter("endDate"));
            String status = req.getParameter("status");

            String inputModelName = req.getParameter("inputModelName");
            if (inputModelName == null || inputModelName.trim().isEmpty()) {
                req.setAttribute("errorMessage", "Vui lòng nhập tên máy phát điện!");
                showCreateForm(req, resp);
                return;
            }

            ProductModel model = productModelServices.findByName(inputModelName);

            if (model == null) {
                req.setAttribute("errorMessage", "Lỗi: Dòng máy '" + inputModelName + "' chưa có trong danh mục! Vui lòng chọn tên chính xác từ gợi ý.");
                req.setAttribute("contract", Contract.builder()
                        .contractNumber(contractNumber)
                        .productSerial(serialNumber)
                        .startDate(startDate)
                        .endDate(endDate)
                        .build());
                showCreateForm(req, resp);
                return;
            }

            Product product = productServices.findProductBySerial(serialNumber);

            if (product == null) {
                product = new Product();
                product.setSerialNumber(serialNumber);
                product.setCustomerId(customerId);
                product.setStatus("RUNNING");

                product.setModelId((long) model.getId());
                product.setModelName(model.getName()); // Set luôn tên để hiển thị (nếu cần)

                product.setTotalRunningHours(0.0);
                product.setPurchaseDate(startDate);

                Users customer = userServices.findUserById(Math.toIntExact(customerId));
                if (customer != null) {
                    product.setCurrentLocation(customer.getFullName());
                }

                String manuYearStr = req.getParameter("manufactureYear");
                if (manuYearStr != null && !manuYearStr.isEmpty()) {
                    product.setManufactureYear(Integer.parseInt(manuYearStr));
                }

                Long newProductId = productServices.save(product);
                product.setId(Math.toIntExact(newProductId));

            } else {

                if (product.getCustomerId() != null && product.getCustomerId() > 0
                        && product.getCustomerId() != customerId) {
                    req.setAttribute("errorMessage", "XUNG ĐỘT: Máy có Serial " + serialNumber + " đang thuộc về khách hàng khác!");
                    showCreateForm(req, resp);
                    return;
                }

                product.setCustomerId(customerId);
                product.setStatus("RUNNING");
                product.setModelId((long) model.getId());
                product.setModelName(model.getName());

                productServices.update(product);
            }

            Contract c = Contract.builder()
                    .contractNumber(contractNumber)
                    .customerId(Math.toIntExact(customerId))
                    .productId(product.getId())
                    .startDate(startDate)
                    .endDate(endDate)
                    .status(status)
                    .managerId(((Users) req.getSession().getAttribute("USERMODEL")).getId())
                    .build();

            contractService.saveContract(c);

            resp.sendRedirect("contracts?msg=create_success");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("contracts?msg=error");
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

            String serialNumber = req.getParameter("serialNumber").trim();
            String inputModelName = req.getParameter("inputModelName");

            if (inputModelName == null || inputModelName.trim().isEmpty()) {
                req.setAttribute("errorMessage", "Vui lòng nhập tên máy phát điện!");
                showEditForm(req, resp);
                return;
            }

            ProductModel model = productModelServices.findByName(inputModelName);
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
            }

            product.setCustomerId(customerId);
            product.setModelId((long) model.getId());
            product.setModelName(model.getName());
            product.setStatus("RUNNING");

            String manuYearStr = req.getParameter("manufactureYear");
            if (manuYearStr != null && !manuYearStr.isEmpty()) {
                product.setManufactureYear(Integer.parseInt(manuYearStr));
            }

            if (product.getId() == 0) {
                Long newPid = productServices.save(product);
                product.setId(Math.toIntExact(newPid));
            } else {
                productServices.update(product);
            }

            Contract c = Contract.builder()
                    .id(contractId)
                    .contractNumber(contractNumber)
                    .customerId(Math.toIntExact(customerId))
                    .productId(product.getId())
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

    private void handleDelete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            Long id = Long.parseLong(req.getParameter("id"));
            contractService.deleteContract(id);
            resp.sendRedirect("contracts?msg=delete_success");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("contracts?msg=error");
        }
    }
}