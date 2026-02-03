package com.generatorproject.controller.manager;

import com.generatorproject.model.Contract;
import com.generatorproject.model.Users;
import com.generatorproject.services.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.IOException;
import java.sql.Date;

@WebServlet(urlPatterns = {"/manager/contracts"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 50)
public class ManagementContractController extends HttpServlet {

    private IContractServices contractService;
    private IUserServices userServices;
    private ProductServices productServices;

    public ManagementContractController() {
        contractService = new ContractServices();
        userServices = new UserServices();
        productServices = new ProductServices();
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
            default:
                showList(req, resp);
                break;
        }
    }

    // --- CÁC HÀM HIỂN THỊ (VIEW) ---

    private void showList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String keyword = req.getParameter("keyword");
        String status = req.getParameter("status");
        req.setAttribute("contracts", contractService.searchAndFilterContracts(keyword, status));
        req.getRequestDispatcher("/views/manager/contract/contract-list.jsp").forward(req, resp);
    }

    private void showCreateForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Load danh sách khách hàng & Máy để chọn
        req.setAttribute("customers", userServices.getAllUsers()); // Bạn cần đảm bảo UserDAO có hàm findAll()
        req.setAttribute("products", productServices.findAll()); // Bạn cần đảm bảo ProductDAO có hàm findAll()
        req.getRequestDispatcher("/views/manager/contract/contract-form.jsp").forward(req, resp);
    }

    private void showEditForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Long id = Long.parseLong(req.getParameter("id"));
        Contract c = contractService.findContractById(id);

        req.setAttribute("contract", c);
        req.setAttribute("customers", userServices.getAllUsers());
        req.setAttribute("products", productServices.findAll());

        req.getRequestDispatcher("/views/manager/contract/contract-form.jsp").forward(req, resp);
    }

    // --- CÁC HÀM XỬ LÝ (HANDLE) ---

    private void handleImportFile(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            // Lấy User đang đăng nhập (Manager)
            Users manager = (Users) req.getSession().getAttribute("USERMODEL");
            if (manager == null) {
                resp.sendRedirect(req.getContextPath() + "/account/login"); // Đá về login nếu hết phiên
                return;
            }

            // Lấy file từ form (name="contractFile" phải khớp với file JSP)
            Part filePart = req.getPart("contractFile");
            if (filePart == null || filePart.getSize() == 0) {
                throw new Exception("Vui lòng chọn file hợp đồng (.docx)!");
            }

            // GỌI SERVICE XỬ LÝ
            // Service sẽ ném Exception nếu file lỗi, thiếu serial, sai email...
            Long newContractId = contractService.importContractFromDocx(filePart.getInputStream(), manager);

            // Thành công -> Redirect về trang list kèm thông báo
            resp.sendRedirect("contracts?msg=success&id=" + newContractId);

        } catch (Throwable e) {
            // Bắt lỗi Throwable để bắt cả các lỗi thiếu thư viện (NoClassDefFoundError)
            e.printStackTrace();

            // Set thông báo lỗi để hiển thị ra màn hình
            req.setAttribute("errorMessage", "Lỗi Import: " + e.getMessage());

            // Forward lại trang danh sách để người dùng thấy lỗi (Không redirect)
            showList(req, resp);
        }
    }

    private void handleCreateManual(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            // Lấy dữ liệu từ Form
            Contract c = Contract.builder()
                    .contractNumber(req.getParameter("contractNumber"))
                    .customerId((int) Long.parseLong(req.getParameter("customerId")))
                    .productId((int) Long.parseLong(req.getParameter("productId")))
                    .startDate(Date.valueOf(req.getParameter("startDate")))
                    .endDate(Date.valueOf(req.getParameter("endDate")))
                    .status(req.getParameter("status"))
                    .managerId(((Users) req.getSession().getAttribute("USERMODEL")).getId())
                    .build();

            contractService.saveContract(c);
            resp.sendRedirect("contracts?msg=create_success");
        } catch (Exception e) {
            e.printStackTrace();
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