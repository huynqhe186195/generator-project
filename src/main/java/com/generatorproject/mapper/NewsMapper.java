package com.generatorproject.mapper;

import com.generatorproject.model.News;

import java.sql.ResultSet;
import java.sql.SQLException;

public class NewsMapper implements RowMapper<News> {

    @Override
    public News mapRow(ResultSet rs) {
        try {
            News news = new News();

            news.setId(rs.getLong("id"));
            news.setTitle(rs.getString("title"));
            news.setSlug(rs.getString("slug"));
            news.setSummary(rs.getString("summary"));
            news.setContent(rs.getString("content"));
            news.setSeoDescription(rs.getString("seo_description"));
            news.setIsFeatured(rs.getInt("is_featured"));
            news.setImageUrl(rs.getString("image_url"));
            news.setAuthor(rs.getString("author"));
            news.setCategory(rs.getString("category"));
            news.setStatus(rs.getString("status"));
            news.setViews(rs.getInt("views"));
            news.setPublishedAt(rs.getTimestamp("published_at"));
            news.setCreatedAt(rs.getTimestamp("created_at"));
            news.setUpdatedAt(rs.getTimestamp("updated_at"));

            return news;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
}