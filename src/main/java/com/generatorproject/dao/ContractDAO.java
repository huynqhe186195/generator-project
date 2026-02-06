package com.generatorproject.dao;

import com.generatorproject.mapper.ContractMapper;
import com.generatorproject.mapper.ProductMapper;
import com.generatorproject.model.Contract;
import com.generatorproject.model.Product;
import com.generatorproject.model.Users;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.apache.poi.xwpf.usermodel.XWPFParagraph;

import java.io.InputStream;
import java.sql.Date;
import java.text.SimpleDateFormat;
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

        String contractNum = null;
        String emailCustomer = null;
        String serialNumber = null;
        int warrantyMonths = 12; // Mặc định 12 tháng

        Integer manufactureYear = null;
        java.sql.Date purchaseDate = null;

        XWPFDocument document = new XWPFDocument(fileContent);
        List<XWPFParagraph> paragraphs = document.getParagraphs();

        for (XWPFParagraph para : paragraphs) {
            String text = para.getText();

            if (text == null || text.trim().isEmpty()) continue;

            if (contractNum == null && text.contains("HĐMB")) {
                Pattern pContract = Pattern.compile("Số\\s*[:.]?\\s*(.*?)\\s*/HĐMB", Pattern.CASE_INSENSITIVE);
                Matcher mContract = pContract.matcher(text);
                if (mContract.find()) {
                    contractNum = mContract.group(1).trim();
                }
            }

            // Regex: Tìm số có 4 chữ số sau cụm "Năm sản xuất"
            if (text.contains("Năm sản xuất")) {
                Pattern pYear = Pattern.compile("Năm sản xuất\\s*[:.]?\\s*(\\d{4})");
                Matcher mYear = pYear.matcher(text);
                if (mYear.find()) {
                    manufactureYear = Integer.parseInt(mYear.group(1));
                }
            }

            // Regex: dd-MM-yyyy
            if (text.contains("Ngày mua")) {
                Pattern pDate = Pattern.compile("Ngày mua\\s*[:.]?\\s*([0-9]{1,2}-[0-9]{1,2}-[0-9]{4})");
                Matcher mDate = pDate.matcher(text);
                if (mDate.find()) {
                    try {
                        SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
                        java.util.Date parsed = sdf.parse(mDate.group(1));
                        purchaseDate = new java.sql.Date(parsed.getTime());
                    } catch (Exception e) {
                        System.out.println("Lỗi parse ngày mua: " + e.getMessage());
                    }
                }
            }

            if (emailCustomer == null && (text.contains("Email") || text.contains("email"))) {
                Pattern pEmail = Pattern.compile("([a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,6})");
                Matcher mEmail = pEmail.matcher(text);
                if (mEmail.find()) {
                    emailCustomer = mEmail.group(1).trim();
                }
            }

            if (serialNumber == null) {
                Pattern pSerial = Pattern.compile("(Số Serial máy|Serial|Số máy|Số khung|S/N)\\s*[:.]?\\s*([A-Za-z0-9-]+)", Pattern.CASE_INSENSITIVE | Pattern.UNICODE_CASE);
                Matcher mSerial = pSerial.matcher(text);

                if (mSerial.find()) {
                    String potentialSerial = mSerial.group(2).trim();
                    // Cắt dấu gạch ngang thừa ở cuối nếu có (Do lỗi nhập liệu file word)
                    if (potentialSerial.endsWith("-")) {
                        potentialSerial = potentialSerial.substring(0, potentialSerial.length() - 1);
                    }
                    // Check độ dài để tránh rác
                    if (potentialSerial.length() >= 3) {
                        serialNumber = potentialSerial;
                    }
                }
            }

            if (text.contains("Thời gian bảo hành") && text.contains("tháng")) {
                Pattern pWarranty = Pattern.compile("(\\d+)\\s*tháng");
                Matcher mWarranty = pWarranty.matcher(text);
                if (mWarranty.find()) {
                    try {
                        warrantyMonths = Integer.parseInt(mWarranty.group(1));
                    } catch (NumberFormatException e) { warrantyMonths = 12; }
                }
            }

            if (contractNum != null && emailCustomer != null && serialNumber != null) {
                break;
            }
        }

        if (contractNum == null || emailCustomer == null || serialNumber == null) {
            throw new Exception("File thiếu thông tin! Cần có: Số HĐ, Email, và Serial/Số máy.");
        }


        if (findByContractNumber(contractNum) != null) {
            throw new Exception("Số hợp đồng '" + contractNum + "' đã tồn tại trong hệ thống!");
        }

        Users customer = userDao.findByEmail(emailCustomer);
        if (customer == null) {
            throw new Exception("Email '" + emailCustomer + "' chưa có tài khoản. Vui lòng tạo User trước.");
        }

        Product product = productDAO.findBySerial(serialNumber);

        if (product == null) {
            // Máy mới tinh -> Tự động tạo mới
            product = new Product();
            product.setSerialNumber(serialNumber);
            product.setTotalRunningHours(0.0);
            product.setModelName("Máy in mã vạch công nghiệp"); // Set tạm hoặc lấy từ file nếu có logic
        }else {
            if (product.getCustomerId() != null && product.getCustomerId() > 0) {
                if (product.getCustomerId() != customer.getId()) {
                    throw new Exception("XUNG ĐỘT: Máy '" + serialNumber + "' đang thuộc về khách hàng khác!");
                }
            }

            // Kiểm tra xem máy này ĐÃ CÓ hợp đồng nào trong hệ thống chưa?
            List<Contract> existingContracts = findByProductId((long) product.getId());

            if (existingContracts != null && !existingContracts.isEmpty()) {
                String oldContractNum = existingContracts.get(0).getContractNumber();
                throw new Exception("TRÙNG SERIAL: Máy '" + serialNumber + "' đã có Hợp đồng (" + oldContractNum + ") trong hệ thống. Một máy chỉ được bán 1 lần!");
            }
        }

        product.setCustomerId((long) customer.getId());
        product.setStatus("RUNNING");
        product.setCurrentLocation(customer.getFullName());

        if (manufactureYear != null) {
            product.setManufactureYear(manufactureYear);
        }
        if (purchaseDate != null) {
            product.setPurchaseDate(purchaseDate);
        }

        if (product.getId() == 0 || product.getId() == 0) {
            // Máy mới -> Insert
            Long newId = productDAO.save(product);
            product.setId(Math.toIntExact(newId));
        } else {
            // Máy cũ -> Update
            productDAO.update(product);
        }

        Date startDate = new java.sql.Date(System.currentTimeMillis());

        Calendar cal = Calendar.getInstance();
        cal.setTime(startDate);
        cal.add(Calendar.MONTH, warrantyMonths);
        java.sql.Date endDate = new java.sql.Date(cal.getTimeInMillis());

        Contract newContract = Contract.builder()
                .contractNumber(contractNum)
                .customerId(customer.getId())
                .productId(product.getId()) // Liên kết với ID máy vừa xử lý
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

    public List<Contract> findByProductId(Long productId) {
        String sql = "SELECT * FROM contracts WHERE product_id = ?";
        return query(sql, new ContractMapper(), productId);
    }
    public List<Contract> getContractByCustomerId(int id){
        String sql = "SELECT * FROM contracts WHERE customer_id = ?";
        return query(sql, new ContractMapper(), id);
    }
}
