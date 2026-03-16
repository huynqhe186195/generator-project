package com.generatorproject.controller.staff;

import com.generatorproject.model.SystemRequest;
import com.generatorproject.model.Users;
import com.generatorproject.services.IRequestServices;
import com.generatorproject.services.RequestServices;
import com.google.gson.Gson;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Map;

// Khớp với action: <form action="/staff/request-manager" ...>
@WebServlet(urlPatterns = {"/staff/request-manager"})
public class RequestManagerController extends HttpServlet {

    private final IRequestServices requestServices;

    public RequestManagerController(){
        requestServices = new RequestServices();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8"); // Để đọc được tiếng Việt trong Ghi chú
        HttpSession session = req.getSession();
        Users user = (Users) session.getAttribute("USERMODEL");
        if (user == null || user.getRoleId() != 3) {
            resp.sendRedirect(req.getContextPath() + "/account/login");
            return;
        }
        try {
            // 1. Lấy dữ liệu từ Form
            String idStr = req.getParameter("incident_id");
            String technicianId = req.getParameter("technician_id");
            String priority = req.getParameter("priority");
            String type = req.getParameter("type");
            String staffNote = req.getParameter("staff_note");
            String preferredDate = req.getParameter("preferredDate");
            String startTime = req.getParameter("startTime");
            String endTime = req.getParameter("endTime");

            long requestId = Long.parseLong(idStr);

            if (startTime != null && !startTime.isBlank() && endTime != null && !endTime.isBlank()
                    && endTime.compareTo(startTime) <= 0) {
                resp.sendRedirect(req.getContextPath() + "/staff/incident-list?message=invalid_time_range");
                return;
            }

            // 2. Lấy Request cũ từ DB để cập nhật thêm thông tin vào JSON
            SystemRequest sysReq = requestServices.findById(requestId);

            // Lấy Map dữ liệu cũ ra (Thông tin khách báo)
            Map<String, Object> info = sysReq.getInfo();

            // Chèn thêm thông tin xử lý của Staff vào Map đó
            info.put("technicianId", technicianId);
            info.put("priority", priority);
            info.put("maintenanceType", type);
            info.put("staffNote", staffNote);
            info.put("preferredDate", preferredDate);
            info.put("startTime", startTime);
            info.put("endTime", endTime);


            // Đóng gói lại thành JSON
            String updatedJsonData = new Gson().toJson(info);

            // 3. Cập nhật vào DB
            sysReq.setRequestData(updatedJsonData);
            sysReq.setStatus("WAITING_MANAGER"); // Chuyển trạng thái sang Chờ Manager duyệt
            sysReq.setReceiverRole("MANAGER");
            sysReq.setSenderId((long)user.getId());




            // Gọi hàm update toàn bộ đối tượng (bao gồm data mới và status mới)
            requestServices.update(sysReq);

            // 4. Redirect về danh sách
            resp.sendRedirect(req.getContextPath() + "/staff/incident-list?message=escalated_success");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/staff/incident-list?message=error");
        }
    }
}