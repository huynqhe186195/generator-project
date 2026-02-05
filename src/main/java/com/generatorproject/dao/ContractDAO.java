package com.generatorproject.dao;

import com.generatorproject.mapper.ContractMapper;
import com.generatorproject.mapper.ProductMapper;
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

    private UserDao userDao;
    private ProductDAO productDAO;
    private ProductModelDAO productModelDAO;

    public ContractDAO(){
        userDao = new UserDao();
        productDAO = new ProductDAO();
        productModelDAO = new ProductModelDAO();
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
        int warrantyMonths = 12;
        String generatorName = null;
        String buyerName = null;
        Integer manufactureYear = null;
        Date purchaseDate = null;

        //Read file word
        XWPFDocument document = new XWPFDocument(fileContent);
        List<XWPFParagraph> paragraphs = document.getParagraphs();

        //Note reading buyer
        boolean isSectionA = false;

        for (XWPFParagraph para : paragraphs) {
            String text = para.getText();

            if (text.isEmpty()) continue;

            // Xác định vùng Bên A / Bên B để lấy tên đại diện cho đúng
            String lowerText = text.toLowerCase();
            if (lowerText.contains("bên a") || lowerText.contains("bên mua")) {
                isSectionA = true;
            } else if (lowerText.contains("bên b") || lowerText.contains("bên bán")) {
                isSectionA = false;
            }

            // A. SỐ HỢP ĐỒNG (Pattern: Số : HD-2026...)
            if (contractNum == null && (text.contains("Số") || text.contains("No"))) {
                // Regex mới: Chỉ lấy chữ, số và dấu gạch ngang (Bỏ \\/ đi)
                Pattern p = Pattern.compile("Số\\s*[:.]?\\s*([A-Za-z0-9\\-]+)", Pattern.CASE_INSENSITIVE | Pattern.UNICODE_CASE);
                Matcher m = p.matcher(text);
                if (m.find()) {
                    contractNum = m.group(1).trim();
                }
            }

            // B. TÊN NGƯỜI MUA (Chỉ lấy trong vùng Bên A)
            // Pattern: "Đại diện: ông huy., giám đốc." -> Lấy "huy"
            if (isSectionA && buyerName == null && text.contains("Đại diện")) {
                Pattern p = Pattern.compile("Đại diện\\s*[:.]?\\s*(?:ông|bà)?\\s*([^.,\\-]+)", Pattern.CASE_INSENSITIVE | Pattern.UNICODE_CASE);
                Matcher m = p.matcher(text);
                if (m.find()) {
                    buyerName = m.group(1).trim();
                    // Xử lý sạch tên (viết hoa chữ cái đầu)
                    buyerName = buyerName.substring(0, 1).toUpperCase() + buyerName.substring(1);
                }
            }

            // C. EMAIL (Lấy email đầu tiên tìm thấy trong phần Bên A)
            if (emailCustomer == null && isSectionA && (text.contains("@"))) {
                Pattern p = Pattern.compile("([a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,6})");
                Matcher m = p.matcher(text);
                if (m.find()) emailCustomer = m.group(1).trim();
            }

            // D. TÊN MÁY PHÁT ĐIỆN
            // Pattern: "-Tên máy phát điện: Denyo DCA-25ESK"
            if (generatorName == null && text.toLowerCase().contains("tên máy")) {
                Pattern p = Pattern.compile("Tên máy.*?[:.]\\s*(.*)", Pattern.CASE_INSENSITIVE | Pattern.UNICODE_CASE);
                Matcher m = p.matcher(text);
                if (m.find()) generatorName = m.group(1).trim();
            }

            // E. SỐ SERIAL
            if (serialNumber == null) {
                Pattern p = Pattern.compile("(Số Serial|Serial|Số máy|S/N).*?[:.]\\s*([A-Za-z0-9\\-]+)", Pattern.CASE_INSENSITIVE | Pattern.UNICODE_CASE);
                Matcher m = p.matcher(text);
                if (m.find()) {
                    serialNumber = m.group(2).trim();
                    if (serialNumber.endsWith("-")) serialNumber = serialNumber.substring(0, serialNumber.length() - 1);
                }
            }

            // F. NGÀY MUA (Format yyyy-mm-dd trong file của bạn)
            if (purchaseDate == null && text.toLowerCase().contains("ngày mua")) {
                // Regex bắt format: 2026-12-07
                Pattern p = Pattern.compile("(\\d{4}-\\d{1,2}-\\d{1,2})");
                Matcher m = p.matcher(text);
                if (m.find()) {
                    try {
                        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                        java.util.Date parsed = sdf.parse(m.group(1));
                        purchaseDate = new java.sql.Date(parsed.getTime());
                    } catch (Exception e) { System.out.println("Lỗi ngày tháng: " + e.getMessage()); }
                }
            }

            // G. NĂM SẢN XUẤT
            if (manufactureYear == null && text.toLowerCase().contains("năm sản xuất")) {
                Pattern p = Pattern.compile("(\\d{4})");
                Matcher m = p.matcher(text);
                if (m.find()) manufactureYear = Integer.parseInt(m.group(1));
            }
        }

        // --- 3. VALIDATE DỮ LIỆU ---
        if (contractNum == null || emailCustomer == null || serialNumber == null || generatorName == null) {
            throw new Exception("File thiếu thông tin! Cần có: Số HĐ, Email, Tên máy và Serial.");
        }

        ProductModel model = productModelDAO.findByName(generatorName);

        if (model == null) {
            throw new Exception("Lỗi Import: Dòng máy '" + generatorName + "' chưa có trong danh mục hệ thống. Vui lòng tạo Model này trước!");
        }

        // In ra console để debug xem lấy đúng chưa
        System.out.println("--- KẾT QUẢ IMPORT DOCX ---");
        System.out.println("HĐ: " + contractNum);
        System.out.println("Khách: " + buyerName + " (" + emailCustomer + ")");
        System.out.println("Máy: " + generatorName + " - SerialNumber: " + serialNumber);
        System.out.println("Mua ngày: " + purchaseDate);

        // --- 4. XỬ LÝ DATABASE ---

        // Check trùng số HĐ
        if (findByContractNumber(contractNum) != null) {
            throw new Exception("Số hợp đồng '" + contractNum + "' đã tồn tại!");
        }

        // Check User (Nếu chưa có thì báo lỗi hoặc tự tạo tùy nghiệp vụ)
        Users customer = userDao.findByEmail(emailCustomer);
        if (customer == null) {
            // Gợi ý: Có thể throw Exception báo user tạo tài khoản trước
            throw new Exception("Email '" + emailCustomer + "' chưa có tài khoản hệ thống.");
        }
        // Nếu muốn update tên thật cho khách dựa trên hợp đồng:
        else if (buyerName != null && !buyerName.isEmpty()) {
            // customer.setFullName(buyerName);
            // userDao.update(customer); // Uncomment nếu muốn update tên
        }

        // Check Product
        Product product = productDAO.findBySerial(serialNumber);
        if (product == null) {
            // Máy mới -> Tạo mới
            product = new Product();
            product.setSerialNumber(serialNumber);
            product.setTotalRunningHours(0.0);
            product.setModelName(generatorName != null ? generatorName : "Máy phát điện (Import)");
        } else {
            // Máy cũ -> Check quyền sở hữu
            if (product.getCustomerId() != null && product.getCustomerId() > 0 && product.getCustomerId() != customer.getId()) {
                throw new Exception("XUNG ĐỘT: Máy " + serialNumber + " đang thuộc về khách hàng khác!");
            }
            // Update lại tên model nếu trong file có thông tin chi tiết hơn
            if (generatorName != null) {
                product.setModelName(generatorName);
            }
        }

        product.setModelId((long) model.getId());
        product.setModelName(model.getName());

        // Cập nhật thông tin máy
        product.setCustomerId((long) customer.getId());
        product.setStatus("RUNNING");
        product.setCurrentLocation(customer.getFullName()); // Gán vị trí máy theo tên khách
        if (manufactureYear != null) product.setManufactureYear(manufactureYear);
        if (purchaseDate != null) product.setPurchaseDate(purchaseDate);

        // Lưu máy
        if (product.getId() == 0) {
            Long newPid = productDAO.save(product);
            product.setId(Math.toIntExact(newPid));
        } else {
            productDAO.update(product);
        }

        // Tạo Hợp đồng
        Date startDate = new java.sql.Date(System.currentTimeMillis());
        Calendar cal = Calendar.getInstance();
        cal.setTime(startDate);
        cal.add(Calendar.MONTH, warrantyMonths); // Cộng thời gian bảo hành
        java.sql.Date endDate = new java.sql.Date(cal.getTimeInMillis());

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

    public List<Contract> findByProductId(Long productId) {
        String sql = "SELECT * FROM contracts WHERE product_id = ?";
        return query(sql, new ContractMapper(), productId);
    }
}
