package com.generatorproject.controller.web;

import com.generatorproject.model.Quote;
import com.generatorproject.model.QuoteDetail;
import com.generatorproject.model.Users;
import com.generatorproject.services.IQuoteDetailService;
import com.generatorproject.services.IQuoteService;
import com.generatorproject.services.QuoteDetailService;
import com.generatorproject.services.QuoteService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/user/quote-detail"})
public class UserQuoteDetailController extends HttpServlet {

    // Khai báo Service
    private final IQuoteService quoteService;
    private final IQuoteDetailService quoteDetailService;

    // Khởi tạo Service trong Constructor để tránh lỗi NullPointerException
    public UserQuoteDetailController() {
        this.quoteService = new QuoteService();
        this.quoteDetailService = new QuoteDetailService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 1. Kiểm tra đăng nhập
        Users user = (Users) req.getSession().getAttribute("USERMODEL");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/account/login");
            return;
        }

        try {
            // 2. Lấy ID Báo giá từ URL
            String idParam = req.getParameter("id");
            if (idParam == null || idParam.isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/home?message=missing_id");
                return;
            }
            Long quoteId = Long.parseLong(idParam);

            // 3. Gọi Service lấy dữ liệu Báo giá gốc
            Quote quote = quoteService.findById(quoteId);

            // Bảo mật: Đảm bảo báo giá này thuộc về đúng user đang đăng nhập
            if (quote == null || quote.getCustomerId() != user.getId()) {
                resp.sendRedirect(req.getContextPath() + "/home?message=not_found_or_unauthorized");
                return;
            }

            // Lấy danh sách vật tư/hạng mục sửa chữa từ Service
            List<QuoteDetail> quoteDetails = quoteDetailService.findByQuoteId(quoteId);

            // 4. Gắn dữ liệu lên Request
            req.setAttribute("quote", quote);
            req.setAttribute("quoteDetails", quoteDetails);

            // 5. Chuyển hướng sang trang JSP
            req.getRequestDispatcher("/views/home/quote-detail.jsp").forward(req, resp);

        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/home?message=invalid_id");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/home?message=error");
        }
    }
}