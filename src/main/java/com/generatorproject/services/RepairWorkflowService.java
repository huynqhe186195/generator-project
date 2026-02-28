package com.generatorproject.services;

import com.generatorproject.dao.MaintenanceDAO;
import com.generatorproject.dao.RequestDAO;
import com.generatorproject.dao.SparePartDAO;
import com.generatorproject.model.RepairRequestDTO;
import com.generatorproject.model.SystemRequest;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

public class RepairWorkflowService implements IRepairWorkflowService{
    private RequestDAO requestDAO = new RequestDAO();
    private SparePartDAO sparePartDAO = new SparePartDAO();
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
    public void processStaffApprove(Long requestId, RepairRequestDTO dto, Long staffId) throws Exception {
        SystemRequest req = requestDAO.findById(requestId);

        if (req != null) {
            // 1. Cập nhật các trường theo đúng yêu cầu của bạn
            req.setStatus("WAITING_MANAGER"); // Đổi trạng thái chờ Manager duyệt
            req.setReceiverRole("MANAGER");   // Người nhận tiếp theo là Manager
            req.setSenderId(staffId);         // Người gửi giờ là Staff (không còn là Technician nữa)

            // 2. Cập nhật lại chuỗi JSON
            // Đề phòng trường hợp tương lai Staff có quyền sửa giá trên giao diện trước khi gửi Sếp,
            // ta lấy luôn cục DTO từ giao diện ném xuống ghi đè lại JSON cũ cho chắc chắn.
            String updatedJsonData = new Gson().toJson(dto);
            req.setRequestData(updatedJsonData);

            // 3. Lưu xuống DB
            requestDAO.update(req);
        } else {
            throw new Exception("Không tìm thấy System Request để cập nhật!");
        }
    }

    // ==========================================
    // KHI STAFF TỪ CHỐI (REJECT)
    // ==========================================
    public void processStaffReject(Long requestId, Long staffId) throws Exception {
        SystemRequest req = requestDAO.findById(requestId);

        if (req != null) {
            // Chỉ cần đổi trạng thái thành REJECTED
            req.setStatus("REJECTED");
            req.setSenderId(staffId); // Ghi nhận Staff là người đã thực hiện thao tác từ chối
            req.setResponseMessage("Nhân viên Staff đã từ chối báo giá vật tư này.");

            // Lưu xuống DB
            requestDAO.update(req);
        } else {
            throw new Exception("Không tìm thấy System Request để cập nhật!");
        }
    }
}
