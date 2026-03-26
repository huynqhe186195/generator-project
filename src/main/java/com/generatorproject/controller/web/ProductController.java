package com.generatorproject.controller.web;

import com.generatorproject.dao.ContractDAO;
import com.generatorproject.dao.ProductDAO;
import com.generatorproject.model.Contract;
import com.generatorproject.model.Product;
import com.generatorproject.model.Users;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/product-list")
public class ProductController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Users user = (Users) request.getSession().getAttribute("USERMODEL");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String contractNumber = trimToNull(request.getParameter("contractNumber"));
        boolean lookupPerformed = contractNumber != null;

        request.setAttribute("contractNumber", contractNumber);
        request.setAttribute("lookupPerformed", lookupPerformed);

        if (lookupPerformed) {
            ContractDAO contractDAO = new ContractDAO();
            ProductDAO productDAO = new ProductDAO();

            Contract contract = contractDAO.findByContractNumber(contractNumber);
            if (contract == null) {
                request.setAttribute("lookupError", "Không tìm thấy hợp đồng với mã bạn đã nhập.");
            } else if (contract.getCustomerId() != user.getId()) {
                request.setAttribute("lookupError", "Bạn không có quyền xem hợp đồng này.");
            } else {
                Contract contractDetail = contractDAO.findByIdWithDetails(contract.getId());
                List<Product> contractDevices = productDAO.findByContractId(contract.getId());

                request.setAttribute("contract", contractDetail != null ? contractDetail : contract);
                request.setAttribute("contractDevices", contractDevices);
            }
        }

        request.getRequestDispatcher("/views/home/product-list.jsp").forward(request, response);
    }

    private String trimToNull(String s) {
        if (s == null) {
            return null;
        }
        s = s.trim();
        return s.isEmpty() ? null : s;
    }
}
