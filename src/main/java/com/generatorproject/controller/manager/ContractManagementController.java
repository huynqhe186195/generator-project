package com.generatorproject.controller.manager;

import com.generatorproject.model.Contract;
import com.generatorproject.model.Users;
import com.generatorproject.services.ContractServices;
import com.generatorproject.services.IContractServices;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/manager/contracts"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10,      // 10MB
        maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class ContractManagementController extends HttpServlet {

    // Gọi Service thông qua Interface (Dependency Injection thủ công)
    private IContractServices contractService;

    public ContractManagementController() {
        contractService = new ContractServices();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "create":
                showCreateForm(req, resp);
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
                handleCreateManual(req, resp); // Nếu bạn làm thêm tạo thủ công
                break;
            default:
                showList(req, resp);
                break;
        }
    }

    // --- CÁC HÀM XỬ LÝ (HANDLER) ---

    // 1. Hiển thị danh sách (Có tìm kiếm & Lọc)
    private void showList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String keyword = req.getParameter("keyword");
        String status = req.getParameter("status");

        // Gọi Service tìm kiếm
        List<Contract> contracts = contractService.searchAndFilterContracts(keyword, status);

        // Đẩy dữ liệu sang JSP
        req.setAttribute("contracts", contracts);
        req.setAttribute("currentKeyword", keyword); // Giữ lại từ khóa ở ô input
        req.setAttribute("currentStatus", status);   // Giữ lại lựa chọn combobox

        req.getRequestDispatcher("/views/manager/contract-list.jsp").forward(req, resp);
    }

    // 2. Hiển thị form tạo mới (Thủ công)
    private void showCreateForm(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Có thể cần load danh sách Khách hàng/Máy để hiển thị dropdown nếu muốn
        req.getRequestDispatcher("/views/manager/contract-form.jsp").forward(req, resp);
    }

    // 3. Xử lý IMPORT FILE WORD (Quan trọng)
    private void handleImportFile(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            // Lấy User đang đăng nhập (Manager)
            Users manager = (Users) req.getSession().getAttribute("USERMODEL");
            if (manager == null) {
                resp.sendRedirect(req.getContextPath() + "/login"); // Đá về login nếu hết phiên
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
            resp.sendRedirect(req.getContextPath() + "/manager/contracts?msg=success&id=" + newContractId);

        } catch (Exception e) {
            e.printStackTrace();
            // Thất bại -> Forward lại trang list để hiện lỗi (Giữ nguyên trang để User biết sai ở đâu)
            req.setAttribute("errorMessage", "Lỗi Import: " + e.getMessage());
            showList(req, resp); // Load lại danh sách kèm thông báo lỗi
        }
    }

    // 4. Xử lý tạo thủ công (Để placeholder)
    private void handleCreateManual(HttpServletRequest req, HttpServletResponse resp) {
        // Logic lấy parameter từ form -> gọi service.createContract -> redirect
    }
}