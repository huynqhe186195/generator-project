package com.generatorproject.controller.staff;

import com.generatorproject.model.Contract;
import com.generatorproject.model.Incident;
import com.generatorproject.model.Users;
import com.generatorproject.services.*;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet(urlPatterns = {"/staff/*"})
public class StaffManagementController extends HttpServlet {
    private final IIncidentServices incidentServices;
    private final IUserServices userServices;
    private final IContractServices contractServices;
    public StaffManagementController(){
        incidentServices = new IncidentServices();
        userServices = new UserServices();
        contractServices = new ContractServices();
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
                handleUserInformation(req,resp);
                break;
            case "/customer-list":
                handleCustomerList(req,resp);
                break;

        }
    }
    private void handleCustomerList(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException{
        String keyword = req.getParameter("keyword");



        int page = 1;
        int pageSize = 5;

        if (req.getParameter("page") != null) {
            try {
                page = Integer.parseInt(req.getParameter("page"));
            } catch (NumberFormatException e) {
                page = 1; // Nếu nhập bậy bạ thì về trang 1
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
    private void handleUserInformation(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException{
        String idParam = req.getParameter("id");

        if (idParam != null) {
            try {
                int userId = Integer.parseInt(idParam);

                // Gọi Service tìm User theo ID (Bạn cần đảm bảo Service có hàm này)
                Users user = userServices.findUserById(userId);
                List<Contract> listContracts = contractServices.getContractByCustomerId(userId);
                if (user != null) {
                    req.setAttribute("user", user);
                    req.setAttribute("listContracts", listContracts);
                    req.getRequestDispatcher("/views/staff/user-information.jsp").forward(req, resp);
                } else {
                    // Không tìm thấy -> Quay về trang danh sách hoặc báo lỗi
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

    private void handleIncidentList(HttpServletRequest req, HttpServletResponse resp)  throws IOException, ServletException{

        String fromDateParam = req.getParameter("fromDate");
        String toDateParam = req.getParameter("toDate");
        String status = req.getParameter("status");


        Date fromDate = null;
        Date toDate = null;
        try {
            if (fromDateParam != null && !fromDateParam.isEmpty()) fromDate = Date.valueOf(fromDateParam);
            if (toDateParam != null && !toDateParam.isEmpty()) toDate = Date.valueOf(toDateParam);
        } catch (IllegalArgumentException e) { e.printStackTrace(); }



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


        int totalIncidents = incidentServices.countIncidentByFilter(fromDate, toDate, status);

        // Tính tổng số trang: Ví dụ có 12 bản ghi. 12 / 5 = 2.4 -> Làm tròn lên là 3 trang.
        int totalPages = (int) Math.ceil((double) totalIncidents / pageSize);

        // Lấy danh sách cho trang hiện tại (Chỉ lấy 5 dòng)
        List<Incident> listIncidents = incidentServices.getIncidentByFilter(fromDate, toDate, status, page, pageSize);

//         Lấy danh sách thợ (cho Modal)
        List<Users> listTechnicians = userServices.findUserByRoleId(4);

        // 4. GỬI DỮ LIỆU SANG JSP
        req.setAttribute("listIncidents", listIncidents);
        req.setAttribute("listTechnicians", listTechnicians);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("currentPage", page);

        // Giữ lại giá trị bộ lọc
        req.setAttribute("fromDate", fromDateParam);
        req.setAttribute("toDate", toDateParam);
        req.setAttribute("status", status);

        RequestDispatcher rd = req.getRequestDispatcher("/views/staff/incident-request.jsp");
        rd.forward(req, resp);
    }


}
