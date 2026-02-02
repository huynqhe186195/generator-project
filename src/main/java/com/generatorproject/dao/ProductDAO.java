package com.generatorproject.dao;

import com.generatorproject.model.Brand;
import com.generatorproject.model.Product;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO extends GenericDAO<Product> {

    public Product findBySerial(String serialNumber) {
        // Câu lệnh SQL tìm máy theo cột serial_number
        String sql = "SELECT * FROM products WHERE serial_number = ?";

        // Gọi hàm query của GenericDAO (kế thừa từ cha)
        // Lưu ý: Phải dùng đúng ProductMapper để map dữ liệu
        List<Product> results = query(sql, new com.generatorproject.mapper.ProductMapper(), serialNumber);

        // Nếu list rỗng (không tìm thấy) -> trả về null
        // Nếu có -> trả về phần tử đầu tiên
        return results.isEmpty() ? null : results.get(0);
    }
}
