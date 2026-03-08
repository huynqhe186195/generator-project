package com.generatorproject.controller.it.news;

import com.generatorproject.dao.NewsDAO;
import com.generatorproject.model.News;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(urlPatterns = {"/it/news/delete"})
public class NewsDeleteController extends HttpServlet {

    private final NewsDAO newsDAO = new NewsDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String idStr = req.getParameter("id");
        Long id;

        try {
            id = Long.parseLong(idStr);
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/it/news/list?msg=invalid_id");
            return;
        }

        News news = newsDAO.findById(id);

        if (news == null) {
            resp.sendRedirect(req.getContextPath() + "/it/news/list?msg=not_found");
            return;
        }

        newsDAO.deleteById(id);
        resp.sendRedirect(req.getContextPath() + "/it/news/list?msg=delete_success");
    }
}