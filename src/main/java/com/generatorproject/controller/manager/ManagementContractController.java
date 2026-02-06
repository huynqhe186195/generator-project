package com.generatorproject.controller.manager;

import com.generatorproject.model.Contract;
import com.generatorproject.model.Product;
import com.generatorproject.model.SystemRequest;
import com.generatorproject.model.Users;
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

    private IContractServices contractService;
    private IUserServices userServices;
    private ProductServices productServices;
    private IRequestServices requestServices;

    public ManagementContractController() {
        contractService = new ContractServices();
        userServices = new UserServices();
        productServices = new ProductServices();
        requestServices = new RequestServices();
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
            default:
                showList(req, resp);
                break;
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

    private void showCreateForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("customers", userServices.getUsersByRole(5));
        req.setAttribute("products", productServices.findAll());
        req.getRequestDispatcher("/views/manager/contract/contract-form.jsp").forward(req, resp);
    }

    private void showEditForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Long id = Long.parseLong(req.getParameter("id"));
        Contract c = contractService.findContractById(id);

        req.setAttribute("contract", c);
        req.setAttribute("customers", userServices.getUsersByRole(5));
        req.setAttribute("products", productServices.findAll());

        req.getRequestDispatcher("/views/manager/contract/contract-form.jsp").forward(req, resp);
    }

    // --- CÁC HÀM XỬ LÝ (HANDLE) ---

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

            // 1. Tạo một Map để chứa dữ liệu (Thay vì nối chuỗi)
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

            // 3. Tạo Object Request (Dùng Builder)
            SystemRequest request = SystemRequest.builder()
                    .senderId((long) manager.getId())
                    .receiverRole("ADMIN")
                    .requestType("CREATE_USER")
                    .requestData(jsonData) // <--- Truyền chuỗi JSON sạch đẹp vào đây
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

    private void handleCreateManual(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            // 1. Lấy dữ liệu từ Form
            String contractNumber = req.getParameter("contractNumber");
            String serialNumber = req.getParameter("serialNumber").trim();
            // Lưu ý: Nên check null hoặc empty cho serialNumber ở đây
            if (serialNumber.isEmpty()) {
                throw new Exception("Serial Number không được để trống");
            }

            Long customerId = Long.parseLong(req.getParameter("customerId"));
            Date startDate = Date.valueOf(req.getParameter("startDate"));
            Date endDate = Date.valueOf(req.getParameter("endDate"));
            String status = req.getParameter("status");

            // 2. XỬ LÝ PRODUCT
            Product product = productServices.findProductBySerial(serialNumber);

            if (product == null) {
                // A. MÁY MỚI TINH -> Tự động tạo và điền dữ liệu mặc định
                product = new Product();
                product.setSerialNumber(serialNumber);
                product.setCustomerId(customerId);
                product.setStatus("RUNNING");
                product.setModelName("Chưa cập nhật");

                // --- BỔ SUNG CÁC TRƯỜNG CÒN THIẾU ---
                product.setTotalRunningHours(0.0); // Mặc định máy mới là 0 giờ
                product.setPurchaseDate(startDate); // Lấy tạm ngày HĐ làm ngày mua

                // Lấy địa chỉ khách để set vị trí (Optional)
                Users customer = userServices.findUserById(Math.toIntExact(customerId));
                if (customer != null) {
                    product.setCurrentLocation(customer.getFullName());
                }

                // Lưu và lấy ID
                Long newProductId = productServices.save(product);
                product.setId(Math.toIntExact(newProductId)); // Ép kiểu Long -> Int (Cẩn thận chỗ này)

            } else {
                // B. MÁY ĐÃ CÓ TRONG KHO

                // --- KIỂM TRA QUYỀN SỞ HỮU (CHỐNG GHI ĐÈ) ---
                // Nếu máy đã có chủ (ID > 0) VÀ chủ đó KHÔNG PHẢI là khách hàng hiện tại
                if (product.getCustomerId() != null && product.getCustomerId() > 0
                        && product.getCustomerId() != customerId) {

                    // Báo lỗi ngay: Không được bán máy của người này cho người kia
                    req.setAttribute("errorMessage", "Lỗi: Máy có Serial " + serialNumber + " đang thuộc về khách hàng khác! Vui lòng kiểm tra lại.");
                    showCreateForm(req, resp); // Quay lại form
                    return; // Dừng xử lý
                }

                // Nếu hợp lệ (Máy chưa ai sở hữu HOẶC Của chính khách này gia hạn) -> Update
                product.setCustomerId(customerId);
                product.setStatus("RUNNING"); // Đảm bảo trạng thái được kích hoạt
                productServices.update(product);
            }

            // 3. LƯU HỢP ĐỒNG
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

            // Redirect kèm thông báo thành công
            resp.sendRedirect("contracts?msg=create_success");

        } catch (Exception e) {
            e.printStackTrace();
            // Redirect kèm thông báo lỗi
            resp.sendRedirect("contracts?msg=error");
        }
    }

    private void handleUpdate(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            Long id = Long.parseLong(req.getParameter("id"));
            Contract c = Contract.builder()
                    .id(id) // Quan trọng: Phải có ID để biết sửa dòng nào
                    .contractNumber(req.getParameter("contractNumber"))
                    .customerId((int) Long.parseLong(req.getParameter("customerId")))
                    .productId((int) Long.parseLong(req.getParameter("productId")))
                    .startDate(Date.valueOf(req.getParameter("startDate")))
                    .endDate(Date.valueOf(req.getParameter("endDate")))
                    .status(req.getParameter("status"))
                    .managerId(((Users) req.getSession().getAttribute("USERMODEL")).getId())
                    .build();

            contractService.updateContract(c);
            resp.sendRedirect("contracts?msg=update_success");
        } catch (Exception e) {
            e.printStackTrace();
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