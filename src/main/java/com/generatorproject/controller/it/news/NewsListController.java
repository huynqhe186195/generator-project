package com.generatorproject.controller.it.news;

import com.generatorproject.dao.NewsDAO;
import com.generatorproject.model.News;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/it/news/list"})
public class NewsListController extends HttpServlet {

    private final NewsDAO newsDAO = new NewsDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String keyword = req.getParameter("keyword");
        String category = req.getParameter("category");
        String status = req.getParameter("status");
        String pageStr = req.getParameter("page");

        int page = 1;
        int limit = 5;

        try {
            if (pageStr != null) {
                page = Integer.parseInt(pageStr);
            }
        } catch (Exception e) {
            page = 1;
        }

        if (page < 1) {
            page = 1;
        }

        int offset = (page - 1) * limit;

        int totalItems = newsDAO.countFilteredNews(category, status, keyword);
        int totalPages = (int) Math.ceil((double) totalItems / limit);

        if (totalPages > 0 && page > totalPages) {
            page = totalPages;
            offset = (page - 1) * limit;
        }

        List<News> newsList = newsDAO.filterNewsPaged(category, status, keyword, limit, offset);

        req.setAttribute("newsList", newsList);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalItems", totalItems);
        req.setAttribute("pageSize", limit);
        req.setAttribute("keyword", keyword);
        req.setAttribute("category", category);
        req.setAttribute("status", status);

        RequestDispatcher rd = req.getRequestDispatcher("/views/it/news/list.jsp");
        rd.forward(req, resp);
    }
}