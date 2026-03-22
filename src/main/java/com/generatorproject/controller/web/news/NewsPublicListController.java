package com.generatorproject.controller.web.news;

import com.generatorproject.dao.NewsDAO;
import com.generatorproject.model.News;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/news"})
public class NewsPublicListController extends HttpServlet {

    private final NewsDAO newsDAO = new NewsDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String pageStr = req.getParameter("page");
        String keyword = req.getParameter("keyword");
        String category = req.getParameter("category");

        int page = 1;
        int limit = 6;

        try {
            if (pageStr != null && !pageStr.trim().isEmpty()) {
                page = Integer.parseInt(pageStr);
            }
        } catch (Exception e) {
            page = 1;
        }

        if (page < 1) {
            page = 1;
        }

        int offset = (page - 1) * limit;

        int totalItems = newsDAO.countPublished(keyword, category);
        int totalPages = (int) Math.ceil((double) totalItems / limit);

        if (totalPages > 0 && page > totalPages) {
            page = totalPages;
            offset = (page - 1) * limit;
        }

        List<News> newsList = newsDAO.findPublishedPaged(keyword, category, limit, offset);

        req.setAttribute("newsList", newsList);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("categoryList", newsDAO.findAllPublishedCategories());

        RequestDispatcher rd = req.getRequestDispatcher("/views/home/news/list.jsp");
        rd.forward(req, resp);
    }
}