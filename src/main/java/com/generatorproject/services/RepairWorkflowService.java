package com.generatorproject.services;

import com.generatorproject.dao.*;
import com.generatorproject.model.RepairRequestDTO;
import com.generatorproject.model.SystemRequest;
import com.google.gson.Gson;

public class RepairWorkflowService implements IRepairWorkflowService {

    private RequestDAO requestDAO = new RequestDAO();
    private SparePartDAO sparePartDAO = new SparePartDAO();
    private ProductDAO productDAO = new ProductDAO();
    private QuoteDAO quoteDAO = new QuoteDAO();

    // ==========================================
    // LẤY DỮ LIỆU BÁO GIÁ ĐỂ HIỂN THỊ
    // ==========================================
    @Override
    public RepairRequestDTO getRepairRequestDetails(Long requestId) {
        SystemRequest req = requestDAO.findById(requestId);
        if (req == null) return null;

        RepairRequestDTO dto = new Gson().fromJson(req.getRequestData(), RepairRequestDTO.class);

        // Map tên vật tư
        if (dto.getMaterials() != null) {
            for (RepairRequestDTO.MaterialDTO mat : dto.getMaterials()) {
                mat.setPartName(sparePartDAO.getPartNameById(mat.getSparePartId()));
            }
        }
        return dto;
    }

    // ==========================================
    // KHI STAFF DUYỆT (APPROVE) -> CHUYỂN MANAGER
    // ==========================================
    @Override
    public void processStaffApprove(Long requestId, RepairRequestDTO dto, Long staffId) throws Exception {
        SystemRequest req = requestDAO.findById(requestId);

        if (req != null) {
            req.setStatus("WAITING_MANAGER"); // Đổi trạng thái chờ Manager duyệt
            req.setReceiverRole("MANAGER");   // Người nhận tiếp theo là Manager
            req.setSenderId(staffId);         // Người gửi giờ là Staff

            // Cập nhật lại chuỗi JSON
            String updatedJsonData = new Gson().toJson(dto);
            req.setRequestData(updatedJsonData);

            requestDAO.update(req);
        } else {
            throw new Exception("Không tìm thấy System Request để cập nhật!");
        }
    }

    // ==========================================
    // KHI STAFF TỪ CHỐI (REJECT)
    // ==========================================
    @Override
    public void processStaffReject(Long requestId, Long staffId) throws Exception {
        SystemRequest req = requestDAO.findById(requestId);

        if (req != null) {
            req.setStatus("REJECTED");
            req.setSenderId(staffId);
            req.setResponseMessage("Nhân viên Staff đã từ chối báo giá vật tư này.");

            requestDAO.update(req);
        } else {
            throw new Exception("Không tìm thấy System Request để cập nhật!");
        }
    }

    // ==========================================
    // KHI STAFF GỬI BÁO GIÁ CHO KHÁCH HÀNG (USER)
    // ==========================================
    @Override
    public void processStaffSendToCustomer(Long requestId, Long staffId) throws Exception {
        SystemRequest req = requestDAO.findById(requestId);

        if (req == null) {
            throw new Exception("Không tìm thấy System Request để cập nhật!");
        }

        // 1. Luân chuyển tờ trình
        req.setStatus("WAITING_CUSTOMER");
        req.setReceiverRole("USER");
        req.setSenderId(staffId);
        requestDAO.update(req);

        // 2. Parse JSON để lấy maintenanceId và cập nhật trạng thái máy
        RepairRequestDTO dto = new Gson().fromJson(req.getRequestData(), RepairRequestDTO.class);

        if (dto != null && dto.getMaintenanceId() > 0) {
            productDAO.updateStatusByMaintenanceId(dto.getMaintenanceId(), "RECEIVED_QUOTE");
        }
    }

    // ==========================================
    // KHI KHÁCH HÀNG BẤM ĐỒNG Ý BÁO GIÁ
    // ==========================================
    @Override
    public void acceptQuote(Long requestId, Long userId) throws Exception {
        SystemRequest req = requestDAO.findById(requestId);

        if (req != null) {
            // Bước 1: Luân chuyển tờ trình về cho Staff để tạo công việc
            req.setStatus("APPROVED_BY_CUSTOMER");
            req.setReceiverRole("TECH");
            req.setSenderId(userId);
            req.setResponseMessage("Khách hàng đã ĐỒNG Ý chi phí. Vui lòng tiến hành sửa chữa.");
            requestDAO.update(req);

            // Bước 2: Bóc tách dữ liệu từ JSON
            RepairRequestDTO dto = new Gson().fromJson(req.getRequestData(), RepairRequestDTO.class);
            System.out.println("====> [DEBUG JSON] Chuỗi JSON trong DB là: " + req.getRequestData());
            System.out.println("====> [DEBUG DTO] Maintenance ID lấy ra được là: " + (dto != null ? dto.getMaintenanceId() : "DTO NULL"));
            if (dto != null && dto.getMaintenanceId() != null && dto.getMaintenanceId() > 0) {

                // Bước 3: Đổi trạng thái máy thành ĐANG SỬA CHỮA
                productDAO.updateStatusByMaintenanceId(dto.getMaintenanceId(), "MAINTENANCE");

                // ====================================================
                // BƯỚC 4: LƯU CHÍNH THỨC VÀO BẢNG BÁO GIÁ
                // ====================================================

                // 4.1 Lưu thông tin tổng quan vào bảng 'quotes' và lấy ID
                // (userId ở đây chính là customer_id của người đang đăng nhập)
                Long newQuoteId = quoteDAO.insertQuote(
                        dto.getMaintenanceId(),
                        userId,
                        dto.getGrandTotal().doubleValue()
                );

                // 4.2 Lấy danh sách vật tư lưu vào bảng 'quote_details'
                if (newQuoteId != null && newQuoteId > 0) {
                    quoteDAO.insertQuoteDetails(newQuoteId, dto.getMaterials());
                    System.out.println("--> [THÀNH CÔNG] Đã lưu báo giá chính thức vào DB. Quote ID = " + newQuoteId);
                }
            }
        } else {
            throw new Exception("Không tìm thấy báo giá!");
        }
    }

    // ==========================================
    // KHI KHÁCH HÀNG BẤM TỪ CHỐI BÁO GIÁ
    // ==========================================
    @Override
    public void rejectQuote(Long requestId, Long userId) throws Exception {
        SystemRequest req = requestDAO.findById(requestId);

        if (req != null) {
            // 1. Đẩy tờ trình lại cho STAFF báo hủy
            req.setStatus("REJECTED_BY_CUSTOMER");
            req.setReceiverRole("TECH");
            req.setSenderId(userId);
            req.setResponseMessage("Khách hàng TỪ CHỐI mức phí báo giá. Yêu cầu hủy bỏ bảo trì.");
            requestDAO.update(req);

            // 2. Parse JSON để lấy DTO (ĐÃ FIX LỖI Ở ĐÂY)
            RepairRequestDTO dto = new Gson().fromJson(req.getRequestData(), RepairRequestDTO.class);
            if (dto != null && dto.getMaintenanceId() > 0) {
                // Đổi trạng thái máy về HỎNG HÓC
                productDAO.updateStatusByMaintenanceId(dto.getMaintenanceId(), "BROKEN");
            }
        } else {
            throw new Exception("Không tìm thấy báo giá!");
        }
    }
}