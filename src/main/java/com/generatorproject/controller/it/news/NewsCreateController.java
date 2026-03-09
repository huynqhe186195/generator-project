package com.generatorproject.controller.it.news;

import com.generatorproject.dao.NewsDAO;
import com.generatorproject.model.News;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Timestamp;
import java.text.Normalizer;
import java.util.Locale;
import java.util.regex.Pattern;

@WebServlet(urlPatterns = {"/it/news/create"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class NewsCreateController extends HttpServlet {

    private final NewsDAO newsDAO = new NewsDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        RequestDispatcher rd = req.getRequestDispatcher("/views/it/news/create.jsp");
        rd.forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String title = trim(req.getParameter("title"));
        String slug = trim(req.getParameter("slug"));
        String summary = trim(req.getParameter("summary"));
        String content = req.getParameter("content");
        String seoDescription = trim(req.getParameter("seoDescription"));
        String author = trim(req.getParameter("author"));
        String category = trim(req.getParameter("category"));
        String status = trim(req.getParameter("status"));

        String publishedAtStr = trim(req.getParameter("publishedAt"));
        String isFeaturedStr = req.getParameter("isFeatured");

        if (content != null) {
            content = content.trim();
        }

        // Giữ lại dữ liệu khi validate lỗi
        req.setAttribute("title", title);
        req.setAttribute("slug", slug);
        req.setAttribute("summary", summary);
        req.setAttribute("content", content);
        req.setAttribute("seoDescription", seoDescription);
        req.setAttribute("author", author);
        req.setAttribute("category", category);
        req.setAttribute("status", status);
        req.setAttribute("publishedAt", publishedAtStr);
        req.setAttribute("isFeatured", isFeaturedStr);

        String error = null;

        if (title == null || title.isEmpty()) {
            error = "Tiêu đề không được để trống.";
        } else if (content == null || content.isEmpty()) {
            error = "Nội dung không được để trống.";
        }




        Integer isFeatured = 0;
        try {
            isFeatured = "1".equals(isFeaturedStr) ? 1 : 0;
        } catch (Exception e) {
            isFeatured = 0;
        }

        Timestamp publishedAt = null;

        if ("published".equals(status)) {
            publishedAt = new Timestamp(System.currentTimeMillis());
        }

        if (slug == null || slug.isEmpty()) {
            slug = toSlug(title);
            req.setAttribute("slug", slug);
        }

        Part filePart = req.getPart("imageFile");
        String fileName = null;

        if (error == null && filePart != null && filePart.getSize() > 0) {
            String originalName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String lowerName = originalName.toLowerCase(Locale.ROOT);

            if (!(lowerName.endsWith(".jpg")
                    || lowerName.endsWith(".jpeg")
                    || lowerName.endsWith(".png")
                    || lowerName.endsWith(".webp")
                    || lowerName.endsWith(".gif"))) {
                error = "Chỉ cho phép upload file ảnh: jpg, jpeg, png, webp, gif.";
            } else {
                fileName = System.currentTimeMillis() + "_" + originalName.replaceAll("\\s+", "_");

                String uploadPath = getServletContext().getRealPath("/uploads/news-images");
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                filePart.write(uploadPath + File.separator + fileName);
            }
        }

        if (error != null) {
            req.setAttribute("error", error);
            RequestDispatcher rd = req.getRequestDispatcher("/views/it/news/create.jsp");
            rd.forward(req, resp);
            return;
        }

        News news = new News();
        news.setTitle(title);
        news.setSlug(slug);
        news.setSummary(summary);
        news.setContent(content);
        news.setSeoDescription(seoDescription);
        news.setIsFeatured(isFeatured);
        news.setImageUrl(fileName);
        news.setAuthor(author);
        news.setCategory(category);
        news.setStatus((status == null || status.isEmpty()) ? "draft" : status);
        news.setViews(0);
        news.setPublishedAt(publishedAt);

        Long id = newsDAO.save(news);

        if (id != null && id > 0) {
            resp.sendRedirect(req.getContextPath() + "/it/news/list?msg=add_success");
        } else {
            req.setAttribute("error", "Thêm bài viết thất bại.");
            RequestDispatcher rd = req.getRequestDispatcher("/views/it/news/create.jsp");
            rd.forward(req, resp);
        }
    }

    private String trim(String value) {
        return value == null ? null : value.trim();
    }

    private String toSlug(String input) {
        if (input == null || input.trim().isEmpty()) {
            return "";
        }

        String normalized = Normalizer.normalize(input, Normalizer.Form.NFD);
        Pattern pattern = Pattern.compile("\\p{InCombiningDiacriticalMarks}+");
        String slug = pattern.matcher(normalized).replaceAll("");
        slug = slug.replaceAll("đ", "d").replaceAll("Đ", "D");
        slug = slug.toLowerCase(Locale.ROOT);
        slug = slug.replaceAll("[^a-z0-9\\s-]", "");
        slug = slug.replaceAll("[\\s-]+", "-");
        slug = slug.replaceAll("^-+|-+$", "");

        return slug;
    }
}