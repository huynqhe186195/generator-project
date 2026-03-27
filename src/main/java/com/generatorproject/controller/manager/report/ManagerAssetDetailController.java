package com.generatorproject.controller.manager.report;

import com.generatorproject.model.Users;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(urlPatterns = {"/manager/reports/assets/detail"})
public class ManagerAssetDetailController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Users manager = (Users) req.getSession().getAttribute("USERMODEL");
        if (manager == null) {
            resp.sendRedirect(req.getContextPath() + "/account/login");
            return;
        }

        // Phase 1: chỉ để không 404 + debug id
        String id = req.getParameter("id");
        req.setAttribute("productId", id);
        req.getRequestDispatcher("/views/manager/reports/assets-detail.jsp").forward(req, resp);
    }
}