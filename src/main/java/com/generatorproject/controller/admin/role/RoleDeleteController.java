package com.generatorproject.controller.admin.role;
import com.generatorproject.dao.RoleDAO;
import com.generatorproject.model.Role;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
@WebServlet("/admin/role-delete")
public class RoleDeleteController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int id = Integer.parseInt(req.getParameter("id"));

        RoleDAO dao = new RoleDAO();
        dao.delete(id); // hoặc updateStatus(id,0)

        resp.sendRedirect(req.getContextPath() + "/admin/role-list");
    }
}
