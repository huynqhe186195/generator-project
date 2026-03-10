package com.generatorproject.controller.it.news;

import com.generatorproject.dao.NewsDAO;
import com.generatorproject.model.News;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(urlPatterns = {"/it/news/detail"})
public class NewsDetailController extends HttpServlet {

    private final NewsDAO newsDAO = new NewsDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String idStr = req.getParameter("id");
        Long id = null;

        try {
            id = Long.parseLong(idStr);
        } catch (Exception e) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        News news = newsDAO.findById(id);

        if (news == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        newsDAO.increaseViews(id);

        news = newsDAO.findById(id);

        req.setAttribute("news", news);

        RequestDispatcher rd = req.getRequestDispatcher("/views/it/news/detail.jsp");
        rd.forward(req, resp);
    }
}