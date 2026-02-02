package com.generatorproject.dao;

import com.generatorproject.mapper.ContractMapper;
import com.generatorproject.model.Contract;
import com.generatorproject.model.Product;
import com.generatorproject.model.Users;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.apache.poi.xwpf.usermodel.XWPFParagraph;

import java.io.InputStream;
import java.sql.Date;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class ContractDAO extends GenericDAO<Contract> {

    private UserDao userDao;
    private ProductDAO productDAO;

    public ContractDAO(){
        userDao = new UserDao();
        productDAO = new ProductDAO();
    }

    public Long save(Contract contract) {
        String sql = "INSERT INTO contracts (contract_number, customer_id, product_id, start_date, end_date, status, manager_id, created_at) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, NOW())";
        return insert(sql,
                contract.getContractNumber(),
                contract.getCustomerId(),
                contract.getProductId(),
                contract.getStartDate(),
                contract.getEndDate(),
                contract.getStatus(),
                contract.getManagerId()
        );
    }

    public void update(Contract contract) {
        String sql = "UPDATE contracts SET contract_number = ?, customer_id = ?, product_id = ?, " +
                "start_date = ?, end_date = ?, status = ?, manager_id = ? WHERE id = ?";

        update(sql,
                contract.getContractNumber(),
                contract.getCustomerId(),
                contract.getProductId(),
                contract.getStartDate(),
                contract.getEndDate(),
                contract.getStatus(),
                contract.getManagerId(),
                contract.getId()
        );
    }

    public Contract findById(Long id) {
        String sql = "SELECT * FROM contracts WHERE id = ?";
        List<Contract> results = query(sql, new ContractMapper(), id);
        return results.isEmpty() ? null : results.get(0);
    }

    //Tìm kiếm theo ID nhưng có JOIN để lấy Tên khách & Serial (Dùng cho trang chi tiết)
    public Contract findByIdWithDetails(Long id) {
        String sql = "SELECT c.*, u.full_name, p.serial_number " +
                "FROM contracts c " +
                "JOIN users u ON c.customer_id = u.id " +
                "JOIN products p ON c.product_id = p.id " +
                "WHERE c.id = ?";
        List<Contract> results = query(sql, new ContractMapper(), id);
        return results.isEmpty() ? null : results.get(0);
    }

    public List<Contract> searchAndFilter(String keyword, String status) {
        StringBuilder sql = new StringBuilder(
                "SELECT c.*, u.full_name, p.serial_number " +
                        "FROM contracts c " +
                        "JOIN users u ON c.customer_id = u.id " +
                        "JOIN products p ON c.product_id = p.id " +
                        "WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        // Logic tìm kiếm theo từ khóa (Số HĐ hoặc Tên khách hoặc Serial máy)
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (c.contract_number LIKE ? OR u.full_name LIKE ? OR p.serial_number LIKE ?) ");
            String likeQuery = "%" + keyword.trim() + "%";
            params.add(likeQuery);
            params.add(likeQuery);
            params.add(likeQuery);
        }

        // Logic lọc theo trạng thái (ACTIVE, EXPIRED...)
        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND c.status = ? ");
            params.add(status);
        }

        sql.append("ORDER BY c.created_at DESC");

        // Chuyển List params thành mảng Object[] để truyền vào GenericDAO
        return query(sql.toString(), new ContractMapper(), params.toArray());
    }

    // 6. Kiểm tra số hợp đồng đã tồn tại chưa (Dùng cho Import)
    public boolean isContractNumberExists(String contractNumber) {
        String sql = "SELECT count(*) FROM contracts WHERE contract_number = ?";
        int count = count(sql, contractNumber);
        return count > 0;
    }

    public List<Contract> findAll() {
        return searchAndFilter(null, null);
    }

    public Long importContractFromDocx(InputStream fileContent, Users manager) throws Exception {

        // Biến hứng dữ liệu
        String contractNum = "";
        String emailCustomer = "";
        String serialNummber = "";
        int warrantyMonths = 12; // Mặc định 12 nếu không tìm thấy

        // Mở file
        XWPFDocument document = new XWPFDocument(fileContent);
        List<XWPFParagraph> paragraphs = document.getParagraphs();

        // Quét từng dòng trong file docx
        boolean isUserBuy = false; // Tạo biến để biết đang đọc phần Bên mua

        for (XWPFParagraph para : paragraphs) {
            String text = para.getText();

            // 1. Bắt Số HĐ (Dựa trên cite: 2)
            if (text.contains("Số :") && text.contains("/HĐMB")) {
                // Cắt chuỗi xử lý logic...
                contractNum = text.substring(text.indexOf(":") + 1, text.indexOf("/")).trim();
            }

            // 2. Xác định vùng Bên A (Dựa trên cite: 6)
            if (text.contains("Bên A") || text.contains("Bên mua hàng")) {
                isUserBuy = true;
            }
            if (text.contains("Bên B")) {
                isUserBuy = false; // Hết vùng bên A
            }

            // 3. Bắt Email Khách
            if (isUserBuy && text.contains("Email:")) {
                emailCustomer = text.split(":")[1].trim();
                // Nếu dòng đó là "Email: nguyenA@gmail.com" -> Lấy "nguyenA@gmail.com"
            }

            // 4. Bắt Serial Máy (Bạn phải thêm dòng này vào hợp đồng thực tế)
            // File mẫu gốc cite: 14 chỉ có "Quy cách:", cần sửa thành "Serial:" để code bắt chuẩn
            if (text.contains("Serial:") || text.contains("Số khung:")) {
                serialNummber = text.split(":")[1].trim();
            }

            // 5. Bắt thời gian bảo hành (Dựa trên cite: 18)
            if (text.contains("Thời gian bảo hành kỹ thuật") && text.contains("tháng")) {
                // Logic: Tìm một con số (\\d+) nằm trước chữ "tháng"
                Pattern pattern = Pattern.compile("(\\d+)\\s*tháng");
                Matcher matcher = pattern.matcher(text);
                if (matcher.find()) {
                    try {
                        // Lấy con số tìm được và ép kiểu sang int
                        warrantyMonths = Integer.parseInt(matcher.group(1));
                    } catch (NumberFormatException e) {
                        warrantyMonths = 12; // Nếu lỗi thì mặc định 12
                    }
                }
            }
        }

        // validate
        // Nếu thiếu 1 trong 3 thông tin quan trọng -> Báo lỗi file sai mẫu
        if (contractNum.isEmpty() || emailCustomer.isEmpty() || serialNummber.isEmpty()) {
            throw new Exception("File thiếu thông tin! Vui lòng điền đủ: Số HĐ, Email Bên A, và Số Serial.");
        }

        // Check xem hợp đồng đã tồn tại trong hệ thống chưa
        if (isContractNumberExists(contractNum)) {
            throw new Exception("Số hợp đồng '" + contractNum + "' đã tồn tại trong hệ thống!");
        }

        // Check user
        Users customer = userDao.findByEmail(emailCustomer);
        if (customer == null) {
            throw new Exception("Email khách hàng '" + emailCustomer + "' chưa có tài khoản trong hệ thống. Vui lòng tạo User trước.");
        }
        // Check máy
        Product product = productDAO.findBySerial(serialNummber);
        if (product == null) {
            throw new Exception("Máy có Serial '" + serialNummber + "' chưa được nhập vào hệ thống. Vui lòng nhập Product trước.");
        }
        product.setCustomerId((long)customer.getId());
        product.setStatus("RUNNING");
        product.setCurrentLocation("Tại địa chỉ khách hàng: " + customer.getFullName());
        productDAO.update(product);
        // 4. TÍNH TOÁN NGÀY
        Date startDate = new java.sql.Date(System.currentTimeMillis()); // Ngày hiện tại

        // Tính EndDate = StartDate + warrantyMonths
        Calendar cal = Calendar.getInstance();
        cal.setTime(startDate);
        cal.add(Calendar.MONTH, warrantyMonths);
        java.sql.Date endDate = new java.sql.Date(cal.getTimeInMillis());

        // 5. TẠO MODEL & LƯU
        Contract newContract = Contract.builder()
                .contractNumber(contractNum)
                .customerId(customer.getId())
                .productId(product.getId())
                .startDate(startDate)
                .endDate(endDate)
                .status("ACTIVE")
                .managerId(manager.getId())
                .build();

        return save(newContract);
    }

    public void delete(Long id) {
        String sql = "DELETE FROM contracts WHERE id = ?";
        update(sql, id); // Sử dụng hàm update() của GenericDAO
    }
}
