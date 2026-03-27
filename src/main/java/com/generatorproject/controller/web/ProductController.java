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
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

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

        ContractDAO contractDAO = new ContractDAO();
        ProductDAO productDAO = new ProductDAO();

        List<Contract> customerContracts = contractDAO.getContractByCustomerId(user.getId());
        Map<Long, List<Product>> contractDeviceMap = new LinkedHashMap<>();

        if (customerContracts != null) {
            for (Contract contract : customerContracts) {
                if (contract == null || contract.getId() == null) {
                    continue;
                }
                List<Product> contractDevices = productDAO.findByContractId(contract.getId());
                contractDeviceMap.put(contract.getId(), contractDevices);
            }
        }

        request.setAttribute("customerContracts", customerContracts);
        request.setAttribute("contractDeviceMap", contractDeviceMap);

        request.getRequestDispatcher("/views/home/product-list.jsp").forward(request, response);
    }
}
