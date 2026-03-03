<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<title>Chi tiết Báo giá Sửa chữa</title>

<div class="container-fluid">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="text-secondary">
            <i class="fas fa-file-invoice-dollar me-2"></i> Chi tiết Báo giá Sửa chữa
        </h3>
        <a href="<c:url value='/staff/repair-request-list'/>" class="btn btn-outline-secondary">
            <i class="fas fa-arrow-left me-1"></i> Quay lại danh sách
        </a>
    </div>

    <div class="row">
        <div class="col-lg-8">
            <div class="card shadow mb-4 border-0">
                <div class="card-header bg-white py-3">
                    <h6 class="m-0 font-weight-bold text-primary">
                        <i class="fas fa-info-circle me-1"></i> Thông tin Yêu cầu
                    </h6>
                </div>
                <div class="card-body bg-light rounded-bottom">
                    <div class="row mb-3">
                        <div class="col-sm-6">
                            <p class="mb-1 text-muted small">Mã phiếu bảo trì (Maintenance ID)</p>
                            <h5 class="text-dark fw-bold">#${repairRequest.maintenanceId}</h5>
                        </div>
                        <div class="col-sm-6">
                            <p class="mb-1 text-muted small">Mã Kỹ thuật viên (Technician ID)</p>
                            <h5 class="text-dark fw-bold">NV-${repairRequest.technicianId}</h5>
                        </div>
                    </div>
                    <hr>
                    <div>
                        <p class="mb-1 text-muted small">Ghi chú thực tế từ Kỹ thuật viên:</p>
                        <div class="p-3 bg-white border rounded">
                            <c:choose>
                                <c:when test="${empty repairRequest.actualDescription}">
                                    <span class="text-muted fst-italic">Không có ghi chú thêm.</span>
                                </c:when>
                                <c:otherwise>
                                    ${repairRequest.actualDescription}
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card shadow mb-4 border-0">
                <div class="card-header bg-white py-3">
                    <h6 class="m-0 font-weight-bold text-primary">
                        <i class="fas fa-tools me-1"></i> Chi tiết Vật tư đề xuất thay thế
                    </h6>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="bg-light text-secondary">
                            <tr>
                                <th class="py-3 ps-4 text-center">STT</th>
                                <th class="py-3">Tên Vật tư</th>
                                <th class="py-3 text-center">Số lượng</th>

                                <th class="py-3 text-end pe-4">Thành tiền</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:choose>
                                <c:when test="${empty repairRequest.materials}">
                                    <tr>
                                        <td colspan="5" class="text-center py-4 text-muted">Không có vật tư nào được đề xuất.</td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                <c:forEach items="${repairRequest.materials}" var="mat" varStatus="loop">
                                    <tr>
                                        <td class="ps-4 text-center fw-bold text-secondary">${loop.index + 1}</td>
                                        <td>
                                            <div class="fw-bold text-dark">${mat.partName}</div>
                                            <div class="small text-muted">Mã ID: ${mat.sparePartId}</div>
                                        </td>
                                        <td class="text-center">
                                            <span class="badge bg-secondary rounded-pill px-3">${mat.quantityUsed}</span>
                                        </td>

                                        <td class="text-end pe-4 fw-bold text-primary">
                                            <fmt:formatNumber value="${mat.costAtTime}" pattern="#,###"/> đ
                                        </td>
                                    </tr>
                                </c:forEach>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-4">
            <div class="card shadow mb-4 border-0 position-sticky" style="top: 20px;">
                <div class="card-header bg-white py-3 text-center">
                    <h6 class="m-0 font-weight-bold text-primary">
                        <i class="fas fa-calculator me-1"></i> Tổng cộng Chi phí
                    </h6>
                </div>
                <div class="card-body bg-light">
                    <div class="d-flex justify-content-between mb-3">
                        <span class="text-muted">Tổng tiền vật tư:</span>
                        <span class="fw-bold text-dark">
                            <fmt:formatNumber value="${repairRequest.partsTotal}" pattern="#,###"/> VNĐ
                        </span>
                    </div>
                    <div class="d-flex justify-content-between mb-3">
                        <span class="text-muted">Phí nhân công:</span>
                        <span class="fw-bold text-dark">
                            <fmt:formatNumber value="${repairRequest.laborCost}" pattern="#,###"/> VNĐ
                        </span>
                    </div>
                    <hr>
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <span class="text-uppercase fw-bold text-secondary">Thành tiền:</span>
                        <h4 class="fw-bold text-danger mb-0">
                            <fmt:formatNumber value="${repairRequest.grandTotal}" pattern="#,###"/> VNĐ
                        </h4>
                    </div>

                    <div class="d-grid gap-2">
                        <button type="button" class="btn btn-success btn-lg" onclick="submitToManager()">
                            <i class="fas fa-check-circle me-1"></i> Tạo Báo Giá & Trình Manager
                        </button>
                        <button type="button" class="btn btn-outline-danger" onclick="rejectRequest()">
                            <i class="fas fa-times-circle me-1"></i> Từ chối / Báo lại KTV
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // Hàm xử lý gửi yêu cầu tạo Báo giá lên Manager (APPROVE)
    function submitToManager() {
        if(confirm("Bạn có chắc chắn muốn TẠO BÁO GIÁ và trình Sếp (Manager) duyệt chi phí này không?")) {

            const rawJsonPayload = ${rawJsonData};

            // Gắn thêm action=APPROVE và requestId lấy từ tham số URL
            fetch('<c:url value="/staff/repair-request/submit"/>?action=APPROVE&requestId=${param.requestId}', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'text/plain'
                },
                body: JSON.stringify(rawJsonPayload)
            })
                .then(response => {
                    if(!response.ok) throw new Error('Lỗi khi gửi yêu cầu lên server');
                    return response.text();
                })
                .then(data => {
                    alert(data);
                    window.location.href = '<c:url value="/staff/repair-request-list"/>';
                })
                .catch(error => alert("Đã xảy ra lỗi: " + error.message));
        }
    }

    // Hàm xử lý khi Staff TỪ CHỐI (REJECT)
    function rejectRequest() {
        if(confirm("Bạn có chắc chắn muốn TỪ CHỐI yêu cầu báo giá này và yêu cầu Kỹ thuật viên kiểm tra lại?")) {

            // Gắn thêm action=REJECT và requestId. Không cần gửi body JSON.
            fetch('<c:url value="/staff/repair-request/submit"/>?action=REJECT&requestId=${param.requestId}', {
                method: 'POST',
                headers: { 'Accept': 'text/plain' }
            })
                .then(response => {
                    if(!response.ok) throw new Error('Lỗi khi từ chối yêu cầu');
                    return response.text();
                })
                .then(data => {
                    alert(data);
                    window.location.href = '<c:url value="/staff/repair-request-list"/>';
                })
                .catch(error => alert("Đã xảy ra lỗi: " + error.message));
        }
    }
</script>