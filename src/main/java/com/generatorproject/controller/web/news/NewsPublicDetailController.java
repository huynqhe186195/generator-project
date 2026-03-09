package com.generatorproject.controller.web.news;

import com.generatorproject.dao.NewsDAO;
import com.generatorproject.model.News;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/news/detail"})
public class NewsPublicDetailController extends HttpServlet {

    private final NewsDAO newsDAO = new NewsDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idStr = req.getParameter("id");
        Long id;

        try {
            id = Long.parseLong(idStr);
        } catch (Exception e) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        News news = newsDAO.findPublishedById(id);

        if (news == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        newsDAO.increaseViews(id);
        news = newsDAO.findPublishedById(id);

        List<News> relatedNews = newsDAO.findRelatedPublished(news.getId(), news.getCategory(), 4);

        req.setAttribute("news", news);
        req.setAttribute("relatedNews", relatedNews);

        RequestDispatcher rd = req.getRequestDispatcher("/views/home/news/detail.jsp");
        rd.forward(req, resp);
    }
}