package com.generatorproject.controller.admin.user;

import com.generatorproject.dao.RequestDAO;
import com.generatorproject.model.SystemRequest;
import com.generatorproject.model.Users;
import com.generatorproject.services.IUserServices;
import com.generatorproject.services.UserServices;
import com.generatorproject.utils.EmailServices;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.mindrot.jbcrypt.BCrypt;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.lang.reflect.Type;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@WebServlet(urlPatterns = {"/admin/requests"})
public class AdminRequestController extends HttpServlet {

    private final IUserServices userServices;
    private final RequestDAO requestDAO;
    private final Gson gson;

    public AdminRequestController() {
        this.userServices = new UserServices();
        this.requestDAO = new RequestDAO();
        this.gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("download".equalsIgnoreCase(action)) {
            handleDownload(req, resp);
            return;
        }

        HttpSession session = req.getSession(false);
        if (session != null) {
            Object flashError = session.getAttribute("flashError");
            if (flashError != null) {
                req.setAttribute("flashError", flashError.toString());
                session.removeAttribute("flashError");
            }
        }

        List<SystemRequest> pendingRequests = requestDAO.findByReceiverRole("ADMIN", "PENDING");
        Map<Long, Map<String, Object>> requestPayloads = new HashMap<>();
        for (SystemRequest pendingRequest : pendingRequests) {
            requestPayloads.put(pendingRequest.getId(), parseRequestData(pendingRequest));
        }
        req.setAttribute("requests", pendingRequests);
        req.setAttribute("requestPayloads", requestPayloads);
        req.getRequestDispatcher("/views/admin/request/request-list.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        try {
            String action = req.getParameter("action");
            Long requestId = parseLong(req.getParameter("requestId"));
            String adminNote = firstNonBlank(req.getParameter("responseMessage"), req.getParameter("adminNote"));

            if (requestId == null) {
                resp.sendRedirect(req.getContextPath() + "/admin/requests?msg=not_found");
                return;
            }

            SystemRequest request = requestDAO.findById(requestId);
            if (request == null) {
                resp.sendRedirect(req.getContextPath() + "/admin/requests?msg=not_found");
                return;
            }

            if ("approve".equals(action)) {
                String responseMessage = appendManagerResponse(handleApprove(request), adminNote);
                request.setStatus("APPROVED");
                request.setResponseMessage(responseMessage);
            } else if ("reject".equals(action)) {
                request.setStatus("REJECTED");
                request.setResponseMessage((adminNote == null || adminNote.trim().isEmpty())
                        ? "Admin từ chối yêu cầu."
                        : adminNote.trim());
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/requests?msg=error");
                return;
            }

            requestDAO.update(request);
            resp.sendRedirect(req.getContextPath() + "/admin/requests?msg=success");

        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("flashError", safeMessage(e));
            resp.sendRedirect(req.getContextPath() + "/admin/requests?msg=error");
        }
    }

    private String handleApprove(SystemRequest request) throws Exception {
        if ("CREATE_USER".equalsIgnoreCase(request.getRequestType())) {
            return approveSingleCreateUserRequest(request);
        }

        if ("NEW_USER".equalsIgnoreCase(request.getRequestType())) {
            return approveNewUserExcelRequest(request);
        }

        return "Đã duyệt yêu cầu.";
    }

    private String approveSingleCreateUserRequest(SystemRequest request) throws Exception {
        Type type = new TypeToken<Map<String, String>>() {
        }.getType();
        Map<String, String> data = gson.fromJson(request.getRequestData(), type);

        String email = data.get("email");
        String fullName = data.get("fullName");
        String phone = data.get("phone");

        if (email == null || email.trim().isEmpty() || fullName == null || fullName.trim().isEmpty()) {
            return "Duyệt yêu cầu nhưng dữ liệu email/họ tên không hợp lệ.";
        }

        if (userServices.findByEmail(email.trim()) != null) {
            return "Email đã tồn tại, hệ thống bỏ qua tạo mới.";
        }

        String randomPassword = generateRandomPassword();
        String hashedPassword = BCrypt.hashpw(randomPassword, BCrypt.gensalt(12));

        Users newUser = new Users();
        newUser.setEmail(email.trim());
        newUser.setFullName(fullName.trim());
        newUser.setPassword(hashedPassword);
        newUser.setRoleId(5);
        newUser.setStatus(1);
        newUser.setPhone(phone);

        userServices.createUser(newUser);
        boolean emailSent = sendAccountInformationEmail(email.trim(), fullName.trim(), randomPassword);

        if (emailSent) {
            return "Đã duyệt, tạo tài khoản và gửi email thông tin đăng nhập thành công!";
        }
        return "Đã duyệt và tạo tài khoản thành công, nhưng gửi email thông tin đăng nhập thất bại.";
    }

    private String approveNewUserExcelRequest(SystemRequest request) throws Exception {
        Map<String, Object> data = parseRequestData(request);
        String excelFileUrl = asText(data.get("excelFileUrl"));

        if (excelFileUrl == null || excelFileUrl.trim().isEmpty()) {
            throw new Exception("Thiếu đường dẫn file Excel trong request.");
        }

        String absolutePath = getServletContext().getRealPath("/" + excelFileUrl);
        File file = new File(absolutePath);
        if (!file.exists()) {
            throw new Exception("Không tìm thấy file Excel đã upload.");
        }

        int created = 0;
        int skipped = 0;

        try (InputStream is = new FileInputStream(file);
             Workbook workbook = WorkbookFactory.create(is)) {

            Sheet sheet = workbook.getNumberOfSheets() > 0 ? workbook.getSheetAt(0) : null;
            if (sheet == null) {
                throw new Exception("File Excel không có sheet dữ liệu.");
            }

            DataFormatter formatter = new DataFormatter();
            int first = sheet.getFirstRowNum() + 1;
            int last = sheet.getLastRowNum();

            for (int rowIndex = first; rowIndex <= last; rowIndex++) {
                Row row = sheet.getRow(rowIndex);
                if (row == null) {
                    continue;
                }

                String email = formatter.formatCellValue(row.getCell(1)).trim();
                String fullName = formatter.formatCellValue(row.getCell(2)).trim();
                String phone = formatter.formatCellValue(row.getCell(3)).trim();

                if (email.isEmpty() && fullName.isEmpty() && phone.isEmpty()) {
                    continue;
                }

                if (email.isEmpty() || fullName.isEmpty()) {
                    skipped++;
                    continue;
                }

                if (userServices.findByEmail(email) != null) {
                    skipped++;
                    continue;
                }

                String rawRoleId = formatter.formatCellValue(row.getCell(0)).trim();
                String rawStatus = formatter.formatCellValue(row.getCell(5)).trim();
                String avatarUrl = formatter.formatCellValue(row.getCell(4)).trim();

                int roleId = parseIntegerOrDefault(rawRoleId, 5);
                int status = parseIntegerOrDefault(rawStatus, 1);

                String randomPassword = generateRandomPassword();
                String hashedPassword = BCrypt.hashpw(randomPassword, BCrypt.gensalt(12));

                Users newUser = new Users();
                newUser.setEmail(email);
                newUser.setFullName(fullName);
                newUser.setPhone(phone.isEmpty() ? null : phone);
                newUser.setPassword(hashedPassword);
                newUser.setRoleId(roleId);
                newUser.setStatus(status);
                newUser.setAvatarUrl(avatarUrl);

                userServices.createUser(newUser);
                sendAccountInformationEmail(email, fullName, randomPassword);
                created++;
            }
        }

        return "Đã import user từ Excel. Thành công: " + created + ", bỏ qua: " + skipped + ".";
    }

    private void handleDownload(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Long requestId = parseLong(req.getParameter("id"));
        if (requestId == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/requests?msg=not_found");
            return;
        }

        SystemRequest request = requestDAO.findById(requestId);
        if (request == null || !"NEW_USER".equalsIgnoreCase(request.getRequestType())) {
            resp.sendRedirect(req.getContextPath() + "/admin/requests?msg=not_found");
            return;
        }

        Map<String, Object> data = parseRequestData(request);
        String excelFileUrl = asText(data.get("excelFileUrl"));
        String excelFileName = asText(data.get("excelFileName"));

        if (excelFileUrl == null || excelFileUrl.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/admin/requests?msg=not_found");
            return;
        }

        String absolutePath = getServletContext().getRealPath("/" + excelFileUrl);
        File file = new File(absolutePath);
        if (!file.exists()) {
            resp.sendRedirect(req.getContextPath() + "/admin/requests?msg=not_found");
            return;
        }

        String downloadName = (excelFileName == null || excelFileName.trim().isEmpty()) ? file.getName() : excelFileName.trim();
        String encodedName = URLEncoder.encode(downloadName, StandardCharsets.UTF_8).replace("+", "%20");

        resp.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        resp.setHeader("Content-Disposition", "attachment; filename*=UTF-8''" + encodedName);
        resp.setContentLengthLong(file.length());

        try (FileInputStream fis = new FileInputStream(file);
             OutputStream os = resp.getOutputStream()) {
            byte[] buffer = new byte[8192];
            int len;
            while ((len = fis.read(buffer)) != -1) {
                os.write(buffer, 0, len);
            }
            os.flush();
        }
    }

    private Map<String, Object> parseRequestData(SystemRequest request) {
        Type type = new TypeToken<Map<String, Object>>() {
        }.getType();
        Map<String, Object> data = gson.fromJson(request.getRequestData(), type);
        return data == null ? new HashMap<String, Object>() : data;
    }

    private String generateRandomPassword() {
        return UUID.randomUUID().toString().replace("-", "").substring(0, 10);
    }

    private boolean sendAccountInformationEmail(String email, String fullName, String rawPassword) {
        return EmailServices.sendWelcomeEmail(email, fullName, rawPassword);
    }

    private String asText(Object value) {
        return value == null ? null : String.valueOf(value);
    }

    private Long parseLong(String value) {
        try {
            return value == null || value.trim().isEmpty() ? null : Long.parseLong(value.trim());
        } catch (Exception e) {
            return null;
        }
    }


    private String safeMessage(Exception e) {
        if (e == null || e.getMessage() == null || e.getMessage().trim().isEmpty()) {
            return "Có lỗi xảy ra trong quá trình xử lý yêu cầu.";
        }
        return e.getMessage().trim();
    }

    private String appendManagerResponse(String systemMessage, String adminNote) {
        if (adminNote == null || adminNote.trim().isEmpty()) {
            return systemMessage;
        }
        if (systemMessage == null || systemMessage.trim().isEmpty()) {
            return adminNote.trim();
        }
        return systemMessage + " | Phản hồi Admin: " + adminNote.trim();
    }

    private String firstNonBlank(String... values) {
        if (values == null) {
            return null;
        }
        for (String value : values) {
            if (value != null && !value.trim().isEmpty()) {
                return value;
            }
        }
        return null;
    }

    private int parseIntegerOrDefault(String value, int defaultValue) {
        try {
            return value == null || value.trim().isEmpty() ? defaultValue : Integer.parseInt(value.trim());
        } catch (Exception e) {
            return defaultValue;
        }
    }
}
