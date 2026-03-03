package com.generatorproject.controller.web;

import com.generatorproject.dao.ProductDAO;
import com.generatorproject.dao.QuoteDAO;
import com.generatorproject.model.Product;
import com.generatorproject.model.Quote;
import com.generatorproject.model.Users;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/user/quote-history"})
public class QuoteHistoryController extends HttpServlet {

    private QuoteDAO quoteDAO = new QuoteDAO();
    private ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        // 1. Kiểm tra đăng nhập (Bảo vệ Route)
        Users currentUser = (Users) req.getSession().getAttribute("USERMODEL");
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/account/login");
            return;
        }

        try {
            // 2. Lấy ID máy từ URL
            String productIdStr = req.getParameter("productId");
            if (productIdStr == null || productIdStr.isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/product-list");
                return;
            }
            int productId = Integer.parseInt(productIdStr);

            // 3. Lấy thông tin máy để hiển thị trên tiêu đề
            Product product = productDAO.getProductById(productId);
            if (product == null) {
                resp.sendRedirect(req.getContextPath() + "/product-list");
                return;
            }

            // 4. Lấy danh sách lịch sử báo giá
            List<Quote> quoteHistory = quoteDAO.findQuotesByProductId(productId);

            // 5. Đẩy dữ liệu sang JSP
            req.setAttribute("product", product);
            req.setAttribute("quoteHistory", quoteHistory);

            req.getRequestDispatcher("/views/home/quote-history.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/product-list?error=true");
        }
    }
}