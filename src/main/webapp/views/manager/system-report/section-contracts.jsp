<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 3/23/2026
  Time: 7:41 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<div class="row g-3 mb-4">
    <div class="col-md-2">
        <div class="card chart-card p-3 h-100">
            <div class="small text-muted">Active</div>
            <div class="fs-3 fw-bold">${ctrActive}</div>
        </div>
    </div>
    <div class="col-md-2">
        <div class="card chart-card p-3 h-100">
            <div class="small text-muted">Chưa kích hoạt (thiếu serial)</div>
            <div class="fs-3 fw-bold">${ctrPending}</div>
        </div>
    </div>
    <div class="col-md-2">
        <div class="card chart-card p-3 h-100">
            <div class="small text-muted">Expired</div>
            <div class="fs-3 fw-bold">${ctrExpired}</div>
        </div>
    </div>
    <div class="col-md-2">
        <div class="card chart-card p-3 h-100">
            <div class="small text-muted">Terminated</div>
            <div class="fs-3 fw-bold">${ctrTerminated}</div>
        </div>
    </div>
    <div class="col-md-2">
        <div class="card chart-card p-3 h-100">
            <div class="small text-muted">Sắp hết hạn (30 ngày)</div>
            <div class="fs-3 fw-bold">${ctrExpiring30Days}</div>
        </div>
    </div>
    <div class="col-md-2">
        <div class="card chart-card p-3 h-100">
            <div class="small text-muted">Mismatch dữ liệu</div>
            <div class="fs-3 fw-bold">${ctrDataMismatch}</div>
        </div>
    </div>
</div>

<div class="row g-3 mb-3">
    <div class="col-md-5">
        <div class="card chart-card h-100">
            <div class="card-header py-3 px-4">
                Phân bổ trạng thái hợp đồng
            </div>
            <div class="card-body px-4 pb-4">
                <canvas id="chartCtrStatus" height="170"></canvas>
            </div>
        </div>
    </div>

    <div class="col-md-7">
        <div class="card chart-card h-100">
            <div class="card-header py-3 px-4">
                Hợp đồng kết thúc theo tháng (theo end_date)
            </div>
            <div class="card-body px-4 pb-4">
                <canvas id="chartCtrEnding" height="120"></canvas>
            </div>
        </div>
    </div>
</div>

<div class="row g-3 mb-3">
    <div class="col-md-7">
        <div class="card chart-card h-100">
            <div class="card-header py-3 px-4">
                Danh sách hợp đồng sắp hết hạn (30 ngày)
            </div>
            <div class="card-body px-4 pb-4">
                <div class="table-responsive">
                    <table class="table table-sm align-middle">
                        <thead>
                        <tr>
                            <th>Mã HĐ</th>
                            <th>Khách hàng</th>
                            <th>End date</th>
                            <th class="text-end">Days left</th>
                            <th>Status</th>
                        </tr>
                        </thead>
                        <tbody id="ctrExpiringBody"></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <div class="col-md-5">
        <div class="card chart-card h-100">
            <div class="card-header py-3 px-4">
                Hợp đồng Pending serial (Top)
            </div>
            <div class="card-body px-4 pb-4">
                <div class="table-responsive">
                    <table class="table table-sm align-middle">
                        <thead>
                        <tr>
                            <th>Mã HĐ</th>
                            <th>Khách hàng</th>
                            <th>Created</th>
                        </tr>
                        </thead>
                        <tbody id="ctrPendingBody"></tbody>
                    </table>
                </div>
                <small class="text-muted">
                    Pending serial = hợp đồng đã tạo nhưng chưa đủ serial để kích hoạt.
                </small>
            </div>
        </div>
    </div>
</div>

<script>
    (function () {
        const statusData = ${ctrStatusJson};
        const endingByMonth = ${ctrExpiringByMonthJson};
        const expiringList = ${ctrExpiringListJson};
        const pendingList = ${ctrPendingListJson};

        // Pie: status distribution
        new Chart(document.getElementById('chartCtrStatus'), {
            type: 'pie',
            data: {
                labels: (statusData || []).map(x => x.label),
                datasets: [{
                    data: (statusData || []).map(x => x.value || 0),
                    backgroundColor: ['#0d6efd', '#198754', '#ffc107', '#dc3545', '#6f42c1']
                }]
            },
            options: {
                responsive: true,
                plugins: { legend: { position: 'bottom' } }
            }
        });

        // Bar: ending by month
        const monthLabels = ['T1','T2','T3','T4','T5','T6','T7','T8','T9','T10','T11','T12'];
        const endingVals = (endingByMonth || []).map(x => x.value || 0);

        new Chart(document.getElementById('chartCtrEnding'), {
            type: 'bar',
            data: {
                labels: monthLabels,
                datasets: [{
                    label: 'Số hợp đồng kết thúc',
                    data: endingVals,
                    backgroundColor: 'rgba(13,110,253,0.75)',
                    borderRadius: 6,
                    borderSkipped: false
                }]
            },
            options: {
                responsive: true,
                plugins: { legend: { display: false } },
                scales: {
                    y: { beginAtZero: true, grid: { color: '#f0f0f0' } },
                    x: { grid: { display: false } }
                }
            }
        });

        // Table: expiring
        const expBody = document.getElementById('ctrExpiringBody');
        if (!expiringList || expiringList.length === 0) {
            expBody.innerHTML = '<tr><td colspan="5" class="text-muted">Không có dữ liệu</td></tr>';
        } else {
            expBody.innerHTML = expiringList.map(r => {
                return '<tr>' +
                    '<td>' + (r.contractNumber || '') + '</td>' +
                    '<td>' + (r.customerName || '') + '</td>' +
                    '<td>' + (r.endDate || '') + '</td>' +
                    '<td class="text-end">' + (r.daysLeft ?? '') + '</td>' +
                    '<td>' + (r.status || '') + '</td>' +
                    '</tr>';
            }).join('');
        }

        // Table: pending
        const penBody = document.getElementById('ctrPendingBody');
        if (!pendingList || pendingList.length === 0) {
            penBody.innerHTML = '<tr><td colspan="3" class="text-muted">Không có dữ liệu</td></tr>';
        } else {
            penBody.innerHTML = pendingList.map(r => {
                return '<tr>' +
                    '<td>' + (r.contractNumber || '') + '</td>' +
                    '<td>' + (r.customerName || '') + '</td>' +
                    '<td>' + (r.createdAt || '') + '</td>' +
                    '</tr>';
            }).join('');
        }
    })();
</script>
