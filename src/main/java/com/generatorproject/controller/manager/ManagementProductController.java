package com.generatorproject.controller.manager;

import com.generatorproject.model.Product;
import com.generatorproject.services.IProductServices;
import com.generatorproject.services.ProductServices;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "ManagementProductController", urlPatterns = "/manager/assets")
public class ManagementProductController extends HttpServlet {

    private final IProductServices productService;

    public ManagementProductController() {
        productService = new ProductServices();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "detail":
                showAssetDetail(req, resp);
                break;
            case "list":
            default:
                showAssetList(req, resp);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "update_hours":
                handleUpdateHours(req, resp);
                break;
            default:
                // Nếu không có action khớp thì quay về danh sách
                resp.sendRedirect("assets");
                break;
        }
    }

    private void handleUpdateHours(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            Long id = Long.parseLong(req.getParameter("id"));
            Double newHours = Double.parseDouble(req.getParameter("runningHours"));

            productService.updateRunningHours(id, newHours);

            resp.sendRedirect("assets?action=detail&id=" + id + "&msg=update_success");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("assets?msg=error");
        }
    }

    private void showAssetList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String keyword = req.getParameter("keyword");

        int page = 1;
        int pageSize = 10;

        if (req.getParameter("page") != null) {
            try {
                page = Integer.parseInt(req.getParameter("page"));
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        int offset = (page - 1) * pageSize;

        List<Product> products = productService.findAllWithPagination(offset, pageSize, keyword);
        int totalItems = productService.countAll(keyword);

        int totalPages = (int) Math.ceil((double) totalItems / pageSize);

        req.setAttribute("products", products);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);

        req.setAttribute("currentKeyword", keyword);

        req.getRequestDispatcher("/views/manager/asset/asset-list.jsp").forward(req, resp);
    }

    private void showAssetDetail(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String idStr = req.getParameter("id");
            if (idStr == null || idStr.isEmpty()) {
                resp.sendRedirect("assets?msg=missing_id");
                return;
            }

            Long id = Long.parseLong(idStr);

            Product product = productService.findByIdWithDetails(id);

            if (product == null) {
                req.setAttribute("errorMessage", "Không tìm thấy máy phát điện này!");
                showAssetList(req, resp);
                return;
            }

            req.setAttribute("p", product);

            req.getRequestDispatcher("/views/manager/asset/asset-detail.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("assets?msg=error");
        }
    }
}