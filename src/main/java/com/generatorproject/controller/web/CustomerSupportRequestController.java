package com.generatorproject.controller.web;

import com.generatorproject.model.SystemRequest;
import com.generatorproject.model.Users;
import com.generatorproject.services.IRequestServices;
import com.generatorproject.services.RequestServices;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet(urlPatterns = { "/customer/support-request" })
public class CustomerSupportRequestController extends HttpServlet {

    private final IRequestServices requestServices = new RequestServices();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        Users user = (Users) req.getSession().getAttribute("USERMODEL");
        if (user == null || user.getRoleId() != 5) {
            resp.sendRedirect(req.getContextPath() + "/account/login");
            return;
        }

        String requestKind = trimToNull(req.getParameter("requestKind"));
        String subject = trimToNull(req.getParameter("subject"));
        String message = trimToNull(req.getParameter("message"));

        if (requestKind == null || message == null) {
            resp.sendRedirect(req.getContextPath() + "/views/home/Support.jsp?message=missing_fields");
            return;
        }

        Map<String, String> payload = new HashMap<>();
        payload.put("requestKind", requestKind);
        payload.put("subject", subject);
        payload.put("message", message);
        payload.put("customerName", user.getFullName());
        payload.put("customerEmail", user.getEmail());
        payload.put("customerPhone", user.getPhone());

        SystemRequest request = new SystemRequest();
        request.setSenderId((long) user.getId());
        request.setReceiverRole("STAFF");
        request.setRequestType("CUSTOMER_SUPPORT");
        request.setRequestData(new Gson().toJson(payload));
        request.setStatus("NEW");

        requestServices.save(request);

        resp.sendRedirect(req.getContextPath() + "/views/home/Support.jsp?message=request_sent");
    }

    private String trimToNull(String value) {
        if (value == null) {
            return null;
        }
        String v = value.trim();
        return v.isEmpty() ? null : v;
    }
}
