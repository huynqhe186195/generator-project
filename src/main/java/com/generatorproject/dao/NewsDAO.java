package com.generatorproject.dao;

import com.generatorproject.mapper.NewsMapper;
import com.generatorproject.model.News;

import java.util.ArrayList;
import java.util.List;

public class NewsDAO extends GenericDAO<News> {

    public List<News> findAll() {
        String sql = "SELECT * FROM news ORDER BY id DESC";
        return query(sql, new NewsMapper());
    }

    public News findById(Long id) {
        String sql = "SELECT * FROM news WHERE id = ?";
        List<News> results = query(sql, new NewsMapper(), id);
        return results.isEmpty() ? null : results.get(0);
    }

    public Long save(News news) {
        String sql = "INSERT INTO news " +
                "(title, slug, summary, content, seo_description, is_featured, image_url, author, category, status, views, published_at, created_at, updated_at) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)";

        return insert(sql,
                news.getTitle(),
                news.getSlug(),
                news.getSummary(),
                news.getContent(),
                news.getSeoDescription(),
                news.getIsFeatured() == null ? 0 : news.getIsFeatured(),
                news.getImageUrl(),
                news.getAuthor(),
                news.getCategory(),
                news.getStatus(),
                news.getViews() == null ? 0 : news.getViews(),
                news.getPublishedAt()
        );
    }

    public void updateNews(News news) {
        String sql = "UPDATE news SET " +
                "title = ?, " +
                "slug = ?, " +
                "summary = ?, " +
                "content = ?, " +
                "seo_description = ?, " +
                "is_featured = ?, " +
                "image_url = ?, " +
                "author = ?, " +
                "category = ?, " +
                "status = ?, " +
                "published_at = ?, " +
                "updated_at = CURRENT_TIMESTAMP " +
                "WHERE id = ?";

        update(sql,
                news.getTitle(),
                news.getSlug(),
                news.getSummary(),
                news.getContent(),
                news.getSeoDescription(),
                news.getIsFeatured(),
                news.getImageUrl(),
                news.getAuthor(),
                news.getCategory(),
                news.getStatus(),
                news.getPublishedAt(),
                news.getId()
        );
    }

    public void deleteById(Long id) {
        String sql = "DELETE FROM news WHERE id = ?";
        update(sql, id);
    }

    public int countAll() {
        String sql = "SELECT COUNT(*) FROM news";
        return count(sql);
    }

    public int countByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM news WHERE status = ?";
        return count(sql, status);
    }

    public List<News> findPaged(int limit, int offset) {
        String sql = "SELECT * FROM news ORDER BY id DESC LIMIT ? OFFSET ?";
        return query(sql, new NewsMapper(), limit, offset);
    }

    public int countFilteredNews(String category, String status, String keyword) {
        StringBuilder sql = new StringBuilder();
        List<Object> params = new ArrayList<>();

        sql.append("SELECT COUNT(1) FROM news WHERE 1=1 ");

        if (category != null && !category.trim().isEmpty()) {
            sql.append(" AND category = ? ");
            params.add(category.trim());
        }

        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND status = ? ");
            params.add(status.trim());
        }

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (LOWER(title) LIKE ? OR LOWER(author) LIKE ? OR LOWER(slug) LIKE ?) ");
            String kw = "%" + keyword.trim().toLowerCase() + "%";
            params.add(kw);
            params.add(kw);
            params.add(kw);
        }

        return count(sql.toString(), params.toArray());
    }

    public List<News> filterNewsPaged(String category, String status, String keyword, int limit, int offset) {
        StringBuilder sql = new StringBuilder();
        List<Object> params = new ArrayList<>();

        sql.append("SELECT * FROM news WHERE 1=1 ");

        if (category != null && !category.trim().isEmpty()) {
            sql.append(" AND category = ? ");
            params.add(category.trim());
        }

        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND status = ? ");
            params.add(status.trim());
        }

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (LOWER(title) LIKE ? OR LOWER(author) LIKE ? OR LOWER(slug) LIKE ?) ");
            String kw = "%" + keyword.trim().toLowerCase() + "%";
            params.add(kw);
            params.add(kw);
            params.add(kw);
        }

        sql.append(" ORDER BY id DESC LIMIT ? OFFSET ? ");
        params.add(limit);
        params.add(offset);

        return query(sql.toString(), new NewsMapper(), params.toArray());
    }

    public void increaseViews(Long id) {
        String sql = "UPDATE news SET views = views + 1 WHERE id = ?";
        update(sql, id);
    }

    public List<News> findPublishedFeatured(int limit) {
        String sql = "SELECT * FROM news " +
                "WHERE status = 'published' " +
                "AND is_featured = 1 " +
                "ORDER BY published_at DESC, id DESC " +
                "LIMIT ?";
        return query(sql, new NewsMapper(), limit);
    }

    public List<News> findLatestPublished(int limit) {
        String sql = "SELECT * FROM news " +
                "WHERE status = 'published' " +
                "ORDER BY published_at DESC, id DESC " +
                "LIMIT ?";
        return query(sql, new NewsMapper(), limit);
    }

    public List<News> findLatestPublishedExceptFeatured(int limit) {
        String sql = "SELECT * FROM news " +
                "WHERE status = 'published' " +
                "AND (is_featured = 0 OR is_featured IS NULL) " +
                "ORDER BY published_at DESC, id DESC " +
                "LIMIT ?";
        return query(sql, new NewsMapper(), limit);
    }

    public List<News> findRelatedPublishedByCategory(String category, Long excludeId, int limit) {
        String sql = "SELECT * FROM news " +
                "WHERE status = 'published' " +
                "AND category = ? " +
                "AND id <> ? " +
                "ORDER BY published_at DESC, id DESC " +
                "LIMIT ?";
        return query(sql, new NewsMapper(), category, excludeId, limit);
    }

    /**
     * Public page:
     * keyword dùng chung để tìm theo title hoặc author
     * category lọc riêng
     */
    public List<News> findPublishedPaged(String keyword, String category, int limit, int offset) {
        StringBuilder sql = new StringBuilder();
        List<Object> params = new ArrayList<>();

        sql.append("SELECT * FROM news WHERE status = 'published' ");

        if (category != null && !category.trim().isEmpty()) {
            sql.append(" AND category = ? ");
            params.add(category.trim());
        }

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (LOWER(title) LIKE ? OR LOWER(author) LIKE ?) ");
            String kw = "%" + keyword.trim().toLowerCase() + "%";
            params.add(kw);
            params.add(kw);
        }

        sql.append(" ORDER BY CASE WHEN published_at IS NULL THEN created_at ELSE published_at END DESC, id DESC ");
        sql.append(" LIMIT ? OFFSET ? ");

        params.add(limit);
        params.add(offset);

        return query(sql.toString(), new NewsMapper(), params.toArray());
    }

    /**
     * Public page:
     * keyword dùng chung để tìm theo title hoặc author
     * category lọc riêng
     */
    public int countPublished(String keyword, String category) {
        StringBuilder sql = new StringBuilder();
        List<Object> params = new ArrayList<>();

        sql.append("SELECT COUNT(1) FROM news WHERE status = 'published' ");

        if (category != null && !category.trim().isEmpty()) {
            sql.append(" AND category = ? ");
            params.add(category.trim());
        }

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (LOWER(title) LIKE ? OR LOWER(author) LIKE ?) ");
            String kw = "%" + keyword.trim().toLowerCase() + "%";
            params.add(kw);
            params.add(kw);
        }

        return count(sql.toString(), params.toArray());
    }

    public List<String> findAllPublishedCategories() {
        String sql = "SELECT DISTINCT category FROM news " +
                "WHERE status = 'published' AND category IS NOT NULL AND TRIM(category) <> '' " +
                "ORDER BY category ASC";
        return queryString(sql);
    }

    public List<News> findFeaturedPublished(int limit) {
        String sql = "SELECT * FROM news " +
                "WHERE status = 'published' AND is_featured = 1 " +
                "ORDER BY CASE WHEN published_at IS NULL THEN created_at ELSE published_at END DESC, id DESC " +
                "LIMIT ?";
        return query(sql, new NewsMapper(), limit);
    }

    public News findPublishedById(Long id) {
        String sql = "SELECT * FROM news WHERE id = ? AND status = 'published'";
        List<News> results = query(sql, new NewsMapper(), id);
        return results == null || results.isEmpty() ? null : results.get(0);
    }

    public List<News> findRelatedPublished(Long currentId, String category, int limit) {
        String sql;
        if (category != null && !category.trim().isEmpty()) {
            sql = "SELECT * FROM news " +
                    "WHERE status = 'published' AND id <> ? AND category = ? " +
                    "ORDER BY CASE WHEN published_at IS NULL THEN created_at ELSE published_at END DESC, id DESC " +
                    "LIMIT ?";
            return query(sql, new NewsMapper(), currentId, category.trim(), limit);
        } else {
            sql = "SELECT * FROM news " +
                    "WHERE status = 'published' AND id <> ? " +
                    "ORDER BY CASE WHEN published_at IS NULL THEN created_at ELSE published_at END DESC, id DESC " +
                    "LIMIT ?";
            return query(sql, new NewsMapper(), currentId, limit);
        }
    }

    public List<News> searchPublishedForChatbot(String keyword, int limit) {
        StringBuilder sql = new StringBuilder();
        List<Object> params = new ArrayList<Object>();

        sql.append("SELECT * FROM news WHERE status = 'published' ");
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (")
                    .append("LOWER(title) LIKE ? ")
                    .append("OR LOWER(summary) LIKE ? ")
                    .append("OR LOWER(content) LIKE ? ")
                    .append("OR LOWER(author) LIKE ? ")
                    .append("OR LOWER(category) LIKE ?")
                    .append(") ");
            String likeKeyword = "%" + keyword.trim().toLowerCase() + "%";
            params.add(likeKeyword);
            params.add(likeKeyword);
            params.add(likeKeyword);
            params.add(likeKeyword);
            params.add(likeKeyword);
        }
        sql.append(" ORDER BY CASE WHEN published_at IS NULL THEN created_at ELSE published_at END DESC, id DESC LIMIT ? ");
        params.add(limit);

        return query(sql.toString(), new NewsMapper(), params.toArray());
    }
}
