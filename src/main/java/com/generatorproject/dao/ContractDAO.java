package com.generatorproject.dao;

import com.generatorproject.mapper.ContractMapper;
import com.generatorproject.model.Contract;
import com.generatorproject.model.Product;
import com.generatorproject.model.ProductModel;
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

    private final UserDao userDao;
    private final ProductDAO productDAO;
    private final ProductModelDAO productModelDAO;
    private final ContractEventDAO contractEventDAO;

    public ContractDAO() {
        userDao = new UserDao();
        productDAO = new ProductDAO();
        productModelDAO = new ProductModelDAO();
        contractEventDAO = new ContractEventDAO();
    }

    public Long save(Contract contract) {
        String sql = "INSERT INTO contracts (contract_number, customer_id, start_date, end_date, status, manager_id, created_at) " +
                "VALUES (?, ?, ?, ?, ?, ?, NOW())";
        return insert(sql,
                contract.getContractNumber(),
                contract.getCustomerId(),
                contract.getStartDate(),
                contract.getEndDate(),
                contract.getStatus(),
                contract.getManagerId()
        );
    }


    public void update(Contract contract) {
        String sql = "UPDATE contracts SET contract_number = ?, customer_id = ?, " +
                "start_date = ?, end_date = ?, status = ?, manager_id = ? WHERE id = ?";

        update(sql,
                contract.getContractNumber(),
                contract.getCustomerId(),
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



    public Contract findByIdWithDetails(Long id) {
        String sql = "SELECT c.*, u.full_name " +
                "FROM contracts c " +
                "JOIN users u ON c.customer_id = u.id " +
                "WHERE c.id = ?";

        List<Contract> results = query(sql, new ContractMapper(), id);
        return results.isEmpty() ? null : results.get(0);
    }

    public Contract findContractByProductId(Long productId) {
        String sql = "SELECT c.* FROM contracts c " +
                "JOIN products p ON p.contract_id = c.id " +
                "WHERE p.id = ?";
        List<Contract> results = query(sql, new ContractMapper(), productId);
        return results.isEmpty() ? null : results.get(0);
    }


    public List<Contract> searchAndFilter(String keyword, String status) {
        StringBuilder sql = new StringBuilder(
                "SELECT c.*, u.full_name, " +
                        " (SELECT p.serial_number " +
                        "  FROM products p " +
                        "  WHERE p.contract_id = c.id " +
                        "  ORDER BY p.created_at DESC " +
                        "  LIMIT 1) AS serial_number " +
                        "FROM contracts c " +
                        "JOIN users u ON c.customer_id = u.id " +
                        "WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (c.contract_number LIKE ? OR u.full_name LIKE ? ");
            sql.append("OR EXISTS (SELECT 1 FROM products p WHERE p.contract_id = c.id AND p.serial_number LIKE ?)) ");
            String like = "%" + keyword.trim() + "%";
            params.add(like);
            params.add(like);
            params.add(like);
        }

        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND c.status = ? ");
            params.add(status);
        }

        sql.append("ORDER BY c.created_at DESC");

        return query(sql.toString(), new ContractMapper(), params.toArray());
    }


    public boolean isContractNumberExists(String contractNumber) {
        String sql = "SELECT count(*) FROM contracts WHERE contract_number = ? AND status <> 'DELETED'";
        int count = count(sql, contractNumber);
        return count > 0;
    }

    public Contract findByContractNumber(String contractNumber) {
        String sql = "SELECT * FROM contracts WHERE contract_number = ? AND status <> 'DELETED'";

        List<Contract> results = query(sql, new ContractMapper(), contractNumber);
        return results.isEmpty() ? null : results.get(0);
    }

    public List<Contract> findAll() {
        return searchAndFilter(null, null);
    }

    public Long assignSerialToContract(Long contractId,
                                       String serialNumber,
                                       Long modelId,
                                       Date purchaseDate,
                                       Integer manufactureYear,
                                       String currentLocation) throws Exception {

        if (contractId == null) throw new IllegalArgumentException("contractId không được null");
        if (serialNumber == null || serialNumber.trim().isEmpty()) {
            throw new IllegalArgumentException("Serial number không được để trống");
        }
        serialNumber = serialNumber.trim();

        // 1) Check contract tồn tại
        Contract contract = findById(contractId);
        if (contract == null) {
            throw new Exception("Hợp đồng không tồn tại (id=" + contractId + ")");
        }

        // (optional) Không cho gán nếu đã terminated/expired
        if ("TERMINATED".equalsIgnoreCase(contract.getStatus())) {
            throw new Exception("Hợp đồng đã TERMINATED nên không thể gán máy.");
        }
        if ("EXPIRED".equalsIgnoreCase(contract.getStatus())) {
            throw new Exception("Hợp đồng đã EXPIRED nên không thể gán máy.");
        }

        // 2) Check user/customer tồn tại
        Users customer = userDao.findUserById(contract.getCustomerId());
        if (customer == null) {
            throw new Exception("Không tìm thấy khách hàng của hợp đồng (customer_id=" + contract.getCustomerId() + ")");
        }

        // 3) Check serial đã tồn tại chưa (unique toàn hệ thống)
        Product existed = productDAO.findBySerial(serialNumber);
        if (existed != null) {
            // Vì rule của bạn: mỗi serial chỉ thuộc 1 hợp đồng bán
            throw new Exception("Serial '" + serialNumber + "' đã tồn tại trong hệ thống (đã thuộc một hợp đồng khác).");
        }

        // 4) (optional) validate modelId nếu bạn muốn bắt buộc model
        if (modelId != null && modelId > 0) {
            ProductModel model = productModelDAO.findById(modelId.intValue());
            if (model == null) {
                throw new Exception("Model không tồn tại (model_id=" + modelId + ")");
            }
        }

        // 5) Tạo Product mới (vì product chỉ sinh ra sau khi có hợp đồng)
        Product p = new Product();
        p.setSerialNumber(serialNumber);
        p.setContractId(contractId);                 // QUAN TRỌNG (NOT NULL)
        p.setCustomerId((long) customer.getId());           // nếu bạn vẫn lưu customer_id trong products
        p.setModelId(modelId);                       // có thể null nếu chưa chọn
        p.setPurchaseDate(purchaseDate);             // có thể null
        p.setManufactureYear(manufactureYear);       // có thể null
        p.setCurrentLocation(
                (currentLocation != null && !currentLocation.trim().isEmpty())
                        ? currentLocation.trim()
                        : customer.getFullName()
        );

        p.setStatus("READY");                        // hoặc RUNNING tuỳ bạn
        p.setTotalRunningHours(0.0);

        Long newProductId = productDAO.save(p);

        // 6) Update contract status: PENDING_SERIAL -> ACTIVE
        update("UPDATE contracts SET status = 'ACTIVE' WHERE id = ? AND status = 'PENDING_SERIAL'", contractId);

        return newProductId;
    }


    public Long importContractFromDocx(InputStream fileContent, Users manager) throws Exception {

        String contractNum = null;
        String emailCustomer = null;
        String buyerName = null;
        String phoneNumber = null;

        int warrantyMonths = 12; // default

        // Read file word (auto close)
        try (XWPFDocument document = new XWPFDocument(fileContent)) {
            List<XWPFParagraph> paragraphs = document.getParagraphs();

            boolean isSectionA = false; // Bên A / Bên mua

            for (XWPFParagraph para : paragraphs) {
                String text = para.getText();
                if (text == null) continue;

                text = text.trim();
                if (text.isEmpty()) continue;

                String lowerText = text.toLowerCase();

                // Detect section buyer/seller
                if (lowerText.contains("bên a") || lowerText.contains("bên mua")) {
                    isSectionA = true;
                } else if (lowerText.contains("bên b") || lowerText.contains("bên bán")) {
                    isSectionA = false;
                }

                // Contract number (allow "/" etc.)
                if (contractNum == null && (text.contains("Số") || text.toLowerCase().contains("no"))) {
                    Pattern p = Pattern.compile("(?i)Số\\s*[:.]?\\s*([^\\r\\n]+)");
                    Matcher m = p.matcher(text);
                    if (m.find()) {
                        contractNum = m.group(1).trim();
                        contractNum = contractNum.replaceAll("[\\s\\t]+$", "");
                    }
                }

                // Buyer representative name
                if (isSectionA && buyerName == null && text.contains("Đại diện")) {
                    Pattern p = Pattern.compile(
                            "Đại diện\\s*(?:là)?\\s*[:.]?\\s*(?:ông|bà)?\\s*(.+?)(?=\\s{2,}|\\t|\\s*Chức\\s*vụ|$)",
                            Pattern.CASE_INSENSITIVE | Pattern.UNICODE_CASE
                    );
                    Matcher m = p.matcher(text);
                    if (m.find()) {
                        buyerName = m.group(1).trim();
                        buyerName = buyerName.replaceAll("\\s+", " ");
                    }
                }

                // Email customer
                if (emailCustomer == null && isSectionA && text.contains("@")) {
                    // widen TLD length
                    Pattern p = Pattern.compile("([a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,63})");
                    Matcher m = p.matcher(text);
                    if (m.find()) {
                        emailCustomer = m.group(1).trim();
                    }
                }

                // Warranty months (optional) - e.g. "Thời gian bảo hành ... 12 tháng"
                if (lowerText.contains("bảo hành") && lowerText.contains("tháng")) {
                    Pattern p = Pattern.compile("(?i)\\b(\\d{1,2})\\s*tháng\\b");
                    Matcher m = p.matcher(text);
                    if (m.find()) {
                        try {
                            warrantyMonths = Integer.parseInt(m.group(1));
                        } catch (Exception ignored) {}
                    }
                }

                // Phone number
                if (phoneNumber == null && isSectionA && lowerText.contains("điện thoại")) {
                    Pattern p = Pattern.compile("điện\\s*thoại\\s*[:.]?\\s*([+]?\\d[\\d\\s.\\-()]{7,})",
                            Pattern.CASE_INSENSITIVE | Pattern.UNICODE_CASE);
                    Matcher m = p.matcher(text);
                    if (m.find()) {
                        String raw = m.group(1);

                        String cleaned = raw.replaceAll("[^0-9+]", "");

                        if (cleaned.startsWith("+84")) cleaned = "0" + cleaned.substring(3);

                        phoneNumber = cleaned.trim();
                    }
                }
            }
        }

        // Validate required fields (new flow)
        if (contractNum == null || contractNum.trim().isEmpty() ||
                emailCustomer == null || emailCustomer.trim().isEmpty()) {
            throw new Exception("File thiếu thông tin! Cần có: Số HĐ và Email bên mua.");
        }

        // Check duplicate contract number
        if (findByContractNumber(contractNum) != null) {
            throw new Exception("Số hợp đồng '" + contractNum + "' đã tồn tại!");
        }



        // Check user exists
        Users customer = userDao.findByEmail(emailCustomer);
        if (customer == null) {
            String safeName = (buyerName == null || buyerName.isBlank()) ? "Khách hàng mới" : buyerName.trim();
            throw new Exception("MISSING_USER|email=" + emailCustomer + "|fullName=" + safeName + "|phoneNumber=" + phoneNumber);
        }

        // Nếu muốn cập nhật tên từ hợp đồng
        if (buyerName != null && !buyerName.isEmpty()) {
             customer.setFullName(buyerName);
             userDao.update(customer.getFullName());
        }

        // Create contract: PENDING_SERIAL (not ACTIVE yet)
        Date startDate = new java.sql.Date(System.currentTimeMillis());
        Calendar cal = Calendar.getInstance();
        cal.setTime(startDate);
        cal.add(Calendar.MONTH, warrantyMonths);
        Date endDate = new java.sql.Date(cal.getTimeInMillis());

        Contract newContract = Contract.builder()
                .contractNumber(contractNum)
                .customerId(customer.getId())
                .startDate(startDate)
                .endDate(endDate)
                .status("PENDING_SERIAL")
                .managerId(manager.getId())
                .build();

        return save(newContract);
    }

    public void delete(Long id) {
        terminateContract(id, null, null, null, null, null);
    }

    public void terminateContract(Long contractId,
                                  String reasonCode,
                                  String terminatedReason,
                                  String decisionDoc,
                                  String note,
                                  Long actorId) {
        Contract current = findById(contractId);
        if (current == null) {
            throw new RuntimeException("Không tìm thấy hợp đồng để chấm dứt");
        }

        String oldStatus = current.getStatus();
        String sql = "UPDATE contracts SET status = 'TERMINATED', terminated_at = NOW(), terminated_reason = ?, decision_doc = ?, note = ? WHERE id = ?";
        update(sql, terminatedReason, decisionDoc, note, contractId);

        String safeReasonCode = (reasonCode == null || reasonCode.trim().isEmpty())
                ? "CONTRACT_VIOLATION"
                : reasonCode.trim();
        String meta = "{\"terminated_reason\":\"" + escapeJson(terminatedReason)
                + "\",\"decision_doc\":\"" + escapeJson(decisionDoc)
                + "\"}";

        contractEventDAO.insertEvent(contractId, "TERMINATED", safeReasonCode, note, actorId, oldStatus, "TERMINATED", meta);
    }

    private String escapeJson(String value) {
        if (value == null) {
            return "";
        }
        return value
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r");
    }

    public List<Contract> findByProductId(Long productId) {
        String sql = "SELECT * FROM contracts WHERE product_id = ?";
        return query(sql, new ContractMapper(), productId);
    }

    public List<Contract> getContractByCustomerId(int id) {
        String sql = "SELECT * FROM contracts WHERE customer_id = ?";
        return query(sql, new ContractMapper(), id);
    }

    // Phần tổng quan
    public int countByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM contracts WHERE status = ? AND status <> 'DELETED'";
        return count(sql, status);
    }

    // 2. Đếm hợp đồng sắp hết hạn trong X ngày
    public int countExpiringSoon(int days) {
        // Logic: Ngày kết thúc nằm trong khoảng từ (Hôm nay) đến (Hôm nay + days)
        String sql = "SELECT COUNT(*) FROM contracts " +
                "WHERE status = 'ACTIVE' AND status <> 'DELETED' " +
                "AND end_date BETWEEN CURRENT_DATE AND DATE_ADD(CURRENT_DATE, INTERVAL ? DAY)";
        return count(sql, days);
    }

    public List<Contract> findRecent(int limit) {
        String sql = "SELECT c.*, u.full_name, " +
                "(SELECT p.serial_number FROM products p WHERE p.contract_id = c.id ORDER BY p.created_at DESC LIMIT 1) AS serial_number " +
                "FROM contracts c " +
                "JOIN users u ON c.customer_id = u.id " +
                "ORDER BY c.created_at DESC LIMIT ?";
        return query(sql, new ContractMapper(), limit);
    }
}
