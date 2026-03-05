package com.generatorproject.controller.web;

import com.generatorproject.model.SystemRequest;
import com.generatorproject.model.Users;
import com.generatorproject.services.IRequestServices;
import com.generatorproject.services.RequestServices;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(urlPatterns = { "/customer/support-requests" })
public class CustomerSupportRequestHistoryController extends HttpServlet {

    private final IRequestServices requestServices = new RequestServices();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Users user = (Users) req.getSession().getAttribute("USERMODEL");
        if (user == null || user.getRoleId() != 5) {
            resp.sendRedirect(req.getContextPath() + "/account/login");
            return;
        }

        List<SystemRequest> allRequests = requestServices.findBySenderId((long) user.getId());
        List<SystemRequest> supportRequests = new ArrayList<>();

        for (SystemRequest request : allRequests) {
            if ("CUSTOMER_SUPPORT".equalsIgnoreCase(request.getRequestType())) {
                supportRequests.add(request);
            }
        }

        req.setAttribute("supportRequests", supportRequests);
        req.getRequestDispatcher("/views/home/support-request-history.jsp").forward(req, resp);
    }
}
