package com.generatorproject.controller.admin.role;

import com.generatorproject.dao.RoleDAO;
import com.generatorproject.model.Role;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/role-create")
public class RoleCreateController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // mở form tạo role
        req.getRequestDispatcher("/views/admin/Role-create.jsp")
                .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String name = req.getParameter("name");
        String description = req.getParameter("description");

        Role r = new Role();
        r.setName(name);
        r.setDescription(description);
        r.setStatus(1);

        RoleDAO dao = new RoleDAO();
        dao.insert(r);

        resp.sendRedirect(req.getContextPath() + "/admin/role-list");
    }
}
