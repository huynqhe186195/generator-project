//package com.generatorproject.controller.admin.brand;
//
//import com.generatorproject.dao.BrandDAO;
//import com.generatorproject.model.Brand;
//
//import javax.servlet.ServletException;
//import javax.servlet.annotation.MultipartConfig;
//import javax.servlet.annotation.WebServlet;
//import javax.servlet.http.*;
//import java.io.File;
//import java.io.IOException;
//import java.nio.file.Paths;
//
//@MultipartConfig(
//        fileSizeThreshold = 1024 * 1024,
//        maxFileSize = 10 * 1024 * 1024,
//        maxRequestSize = 20 * 1024 * 1024
//)
//@WebServlet(urlPatterns = "/admin/brand/create-ajax")
//public class BrandCreateAjaxController extends HttpServlet {
//
//    private final BrandDAO brandDAO = new BrandDAO();
//
//    @Override
//    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
//            throws ServletException, IOException {
//
//        req.setCharacterEncoding("UTF-8");
//        resp.setContentType("application/json; charset=UTF-8");
//
//        String name = trim(req.getParameter("name"));
//        String slug = trim(req.getParameter("slug"));
//
//        String error = null;
//        if (name == null || name.isEmpty()) error = "Tên brand không được để trống.";
//
//        if (error != null) {
//            resp.getWriter().write("{\"success\":false,\"message\":\"" + escapeJson(error) + "\"}");
//            return;
//        }
//
//        String logoUrl = saveUploadedLogo(req);
//
//        Brand b = new Brand();
//        b.setName(name);
//        b.setSlug(slug);
//        b.setLogoUrl(logoUrl);
//
//        int newId = brandDAO.insert(b);
//        if (newId > 0) {
//            // trả về để JS add vào dropdown và auto-select
//            resp.getWriter().write("{\"success\":true,\"id\":" + newId +
//                    ",\"name\":\"" + escapeJson(name) + "\"}");
//        } else {
//            resp.getWriter().write("{\"success\":false,\"message\":\"Không thể thêm brand.\"}");
//        }
//    }
//
//    private String saveUploadedLogo(HttpServletRequest req) {
//        try {
//            Part filePart = req.getPart("logoFile");
//            if (filePart == null || filePart.getSize() <= 0) return null;
//
//            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
//            if (fileName == null || fileName.trim().isEmpty()) return null;
//
//            String uploadDirPath = getServletContext().getRealPath("/uploads/brands");
//            File uploadDir = new File(uploadDirPath);
//            if (!uploadDir.exists()) uploadDir.mkdirs();
//
//            String savedName = System.currentTimeMillis() + "_" + fileName;
//            filePart.write(uploadDirPath + File.separator + savedName);
//
//            return "/uploads/brands/" + savedName;
//        } catch (Exception e) {
//            e.printStackTrace();
//            return null;
//        }
//    }
//
//    private String trim(String s) { return s == null ? null : s.trim(); }
//
//    private String escapeJson(String s) {
//        if (s == null) return "";
//        return s.replace("\\", "\\\\").replace("\"", "\\\"");
//    }
//}
