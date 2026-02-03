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

    public Contract findByContractNumber(String contractNumber) {
        String sql = "SELECT * FROM contracts WHERE contract_number = ?";

        List<Contract> results = query(sql, new ContractMapper(), contractNumber);
        return results.isEmpty() ? null : results.get(0);
    }

    public List<Contract> findAll() {
        return searchAndFilter(null, null);
    }

    public Long importContractFromDocx(InputStream fileContent, Users manager) throws Exception {

        // 1. Khởi tạo biến (Để null để dễ kiểm tra xem đã tìm thấy chưa)
        String contractNum = null;
        String emailCustomer = null;
        String serialNumber = null;
        int warrantyMonths = 12; // Mặc định 12 tháng

        // Mở file Word
        XWPFDocument document = new XWPFDocument(fileContent);
        List<XWPFParagraph> paragraphs = document.getParagraphs();

        // 2. Quét từng dòng trong file
        for (XWPFParagraph para : paragraphs) {
            String text = para.getText();

            // Bỏ qua dòng trống để tăng tốc độ
            if (text == null || text.trim().isEmpty()) continue;

            // --- A. BẮT SỐ HỢP ĐỒNG ---
            // Logic: Tìm chữ "Số" ... "/HĐMB"
            if (contractNum == null && text.contains("HĐMB")) {
                Pattern pContract = Pattern.compile("Số\\s*[:.]?\\s*(.*?)\\s*/HĐMB", Pattern.CASE_INSENSITIVE);
                Matcher mContract = pContract.matcher(text);
                if (mContract.find()) {
                    contractNum = mContract.group(1).trim();
                }
            }

            // --- B. BẮT EMAIL KHÁCH HÀNG ---
            // Logic: Tìm dòng có chữ "Email" và chứa ký tự @
            if (emailCustomer == null && (text.contains("Email") || text.contains("email"))) {
                // Regex này tìm một chuỗi email chuẩn (vd: abc@gmail.com) trong dòng text
                Pattern pEmail = Pattern.compile("([a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,6})");
                Matcher mEmail = pEmail.matcher(text);
                if (mEmail.find()) {
                    emailCustomer = mEmail.group(1).trim();
                }
            }

            // --- C. BẮT SERIAL MÁY (Đã fix theo file mẫu của bạn) ---
            if (serialNumber == null) {
                // Cập nhật Regex: Thêm "Số Serial máy" vào đầu danh sách tìm kiếm
                // Regex này chấp nhận: "Số Serial máy:", "Serial:", "Số máy:", "S/N:"
                Pattern pSerial = Pattern.compile("(Số Serial máy|Serial|Số máy|Số khung|S/N)\\s*[:.]?\\s*([A-Za-z0-9-]+)", Pattern.CASE_INSENSITIVE | Pattern.UNICODE_CASE);
                Matcher mSerial = pSerial.matcher(text);

                if (mSerial.find()) {
                    String potentialSerial = mSerial.group(2).trim();

                    // Xử lý phụ: Trong file của bạn dòng 18 có dấu gạch ngang ở cuối "SN-2026-8888-"
                    // Nếu bắt dính dấu gạch ngang ở cuối thì cắt bỏ đi
                    if (potentialSerial.endsWith("-")) {
                        potentialSerial = potentialSerial.substring(0, potentialSerial.length() - 1);
                    }

                    // Kiểm tra độ dài >= 3 để tránh bắt nhầm rác
                    if (potentialSerial.length() >= 3) {
                        serialNumber = potentialSerial;
                        System.out.println("DEBUG FOUND SERIAL: " + serialNumber);
                    }
                }
            }

            // --- D. BẮT THỜI GIAN BẢO HÀNH ---
            if (text.contains("Thời gian bảo hành") && text.contains("tháng")) {
                Pattern pWarranty = Pattern.compile("(\\d+)\\s*tháng");
                Matcher mWarranty = pWarranty.matcher(text);
                if (mWarranty.find()) {
                    try {
                        warrantyMonths = Integer.parseInt(mWarranty.group(1));
                    } catch (NumberFormatException e) {
                        warrantyMonths = 12;
                    }
                }
            }

            // Tối ưu: Nếu tìm đủ 3 thông tin chính rồi thì dừng vòng lặp luôn
            if (contractNum != null && emailCustomer != null && serialNumber != null) {
                break;
            }
        }

        // 3. VALIDATE DỮ LIỆU (Kiểm tra null thay vì isEmpty để an toàn hơn)
        if (contractNum == null || emailCustomer == null || serialNumber == null) {
            // In ra console để debug xem thiếu cái gì
            System.out.println("DEBUG ERROR: Thiếu thông tin -> Contract: " + contractNum + ", Email: " + emailCustomer + ", Serial: " + serialNumber);
            throw new Exception("File thiếu thông tin! Vui lòng kiểm tra lại file Word (Cần có: Số HĐ, Email, Serial/Số máy).");
        }

        // 4. KIỂM TRA NGHIỆP VỤ DATABASE
        // Check trùng số HĐ
        if (findByContractNumber(contractNum) != null) { // Giả sử bạn có hàm này, hoặc dùng hàm check exist cũ
            throw new Exception("Số hợp đồng '" + contractNum + "' đã tồn tại trong hệ thống!");
        }

        // Check User (Khách hàng)
        Users customer = userDao.findByEmail(emailCustomer);
        if (customer == null) {
            throw new Exception("Email khách hàng '" + emailCustomer + "' chưa có tài khoản. Vui lòng tạo User trước.");
        }

        // Check Máy (Product)
        Product product = productDAO.findBySerial(serialNumber);
        if (product == null) {
            throw new Exception("Máy có Serial '" + serialNumber + "' chưa có trong kho. Vui lòng nhập Product trước.");
        }

        // 5. CẬP NHẬT TRẠNG THÁI MÁY (Logic After-Sales)
        // Chuyển máy sang cho khách hàng sở hữu
        product.setCustomerId((long) customer.getId());
        product.setStatus("RUNNING"); // Hoặc trạng thái khác tùy quy ước
        product.setCurrentLocation("Khách hàng: " + customer.getFullName()); // Cập nhật vị trí
        productDAO.update(product); // Lưu vào DB

        // 6. TÍNH TOÁN NGÀY BẢO HÀNH
        Date startDate = new java.sql.Date(System.currentTimeMillis()); // Ngày ký = Hôm nay

        Calendar cal = Calendar.getInstance();
        cal.setTime(startDate);
        cal.add(Calendar.MONTH, warrantyMonths);
        java.sql.Date endDate = new java.sql.Date(cal.getTimeInMillis());

        // 7. LƯU HỢP ĐỒNG
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
