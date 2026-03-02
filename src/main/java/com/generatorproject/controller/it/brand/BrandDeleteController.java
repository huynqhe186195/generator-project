package com.generatorproject.controller.it.brand;

import com.generatorproject.dao.BrandDAO;
import com.generatorproject.model.Brand;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.sql.SQLIntegrityConstraintViolationException;

@WebServlet("/it/brands/delete")
public class BrandDeleteController extends HttpServlet {

    private final BrandDAO brandDAO = new BrandDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        int id = parseInt(req.getParameter("id"), -1);
        if (id <= 0) {
            resp.sendRedirect(req.getContextPath() + "/it/brands?msg=invalid_id");
            return;
        }

        Brand brand = brandDAO.findById(id);
        if (brand == null) {
            resp.sendRedirect(req.getContextPath() + "/it/brands?msg=not_found");
            return;
        }

        try {

            // ====== Nếu bạn có bảng product_models dùng brand_id thì bật check này ======
            // (Đảm bảo bạn đã có method isBrandUsed trong DAO)

            if (brandDAO.isBrandUsed(id)) {
                resp.sendRedirect(req.getContextPath() + "/it/brands?msg=brand_in_use");
                return;
            }
            // ====== Xóa file logo local (nếu có) ======
            String logoUrl = brand.getLogoUrl();
            if (logoUrl != null && !logoUrl.startsWith("http")) {
                if (logoUrl.startsWith("uploads/brands/")) {
                    String absPath = req.getServletContext().getRealPath("/" + logoUrl);
                    if (absPath != null) {
                        File f = new File(absPath);
                        if (f.exists() && f.isFile()) {
                            f.delete(); // không cần check result
                        }
                    }
                }
            }

            boolean deleted = brandDAO.deleteById(id);
            if (!deleted) {
                resp.sendRedirect(req.getContextPath() + "/it/brands?msg=delete_failed");
                return;
            }

            resp.sendRedirect(req.getContextPath() + "/it/brands?msg=delete_success");

        } catch (Exception e) {

            // Nếu DB có foreign key constraint
            if (e.getCause() instanceof SQLIntegrityConstraintViolationException) {
                resp.sendRedirect(req.getContextPath() + "/it/brands?msg=brand_in_use");
            } else {
                e.printStackTrace();
                resp.sendRedirect(req.getContextPath() + "/it/brands?msg=delete_failed");
            }
        }
    }

    private int parseInt(String s, int def) {
        try { return Integer.parseInt(s); } catch (Exception e) { return def; }
    }
}