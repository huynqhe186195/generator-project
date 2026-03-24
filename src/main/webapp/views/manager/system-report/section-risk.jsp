<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 3/20/2026
  Time: 1:11 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<div class="row g-3 mb-4">
    <div class="col-md-4">
        <div class="card chart-card p-3 h-100">
            <div class="small text-muted">Vùng đỏ (12 tháng)</div>
            <div class="fs-3 fw-bold">${riskRedZoneDevices}</div>
            <div class="small text-muted">No maintenance > 12 months</div>
        </div>
    </div>

    <div class="col-md-4">
        <div class="card chart-card p-3 h-100">
            <div class="small text-muted">Tỷ lệ bao phủ dịch vụ</div>
            <div class="fs-3 fw-bold"><span id="riskPenRate"></span>%</div>
            <div class="small text-muted">Service Penetration Rate</div>
        </div>
    </div>

    <div class="col-md-4">
        <div class="card chart-card p-3 h-100">
            <div class="small text-muted">Tỷ lệ xử lý dứt điểm</div>
            <div class="fs-3 fw-bold"><span id="riskFtfRate"></span>%</div>
            <div class="small text-muted">First-Time Fix Rate (30 days)</div>
        </div>
    </div>
</div>

<div class="row g-3 mb-3">
    <div class="col-md-5">
        <div class="card chart-card h-100">
            <div class="card-header py-3 px-4">
                Vùng đỏ theo phân khúc
            </div>
            <div class="card-body px-4 pb-4">
                <canvas id="chartRiskRedByCat" height="170"></canvas>
            </div>
        </div>
    </div>

    <div class="col-md-7">
        <div class="card chart-card h-100">
            <div class="card-header py-3 px-4">
                Danh sách máy vùng đỏ (Top 20)
            </div>
            <div class="card-body px-4 pb-4">
                <div class="table-responsive">
                    <table class="table table-sm align-middle">
                        <thead>
                        <tr>
                            <th>Serial</th>
                            <th>Khách hàng</th>
                            <th>Địa điểm</th>
                            <th>Last maintenance</th>
                        </tr>
                        </thead>
                        <tbody id="riskRedListBody"></tbody>
                    </table>
                </div>
                <small class="text-muted">
                    Ghi chú: Địa điểm hiện lấy theo current_location (text).
                </small>
            </div>
        </div>
    </div>
</div>

<script>
    (function () {
        const penRate = ${riskServicePenetrationRate};
        const ftfRate = ${riskFirstTimeFixRate};

        const redByCat = ${riskRedZoneByCategoryJson};
        const redList = ${riskRedZoneListJson};

        document.getElementById('riskPenRate').innerText =
            (penRate || 0).toFixed ? penRate.toFixed(1) : (penRate || 0);

        document.getElementById('riskFtfRate').innerText =
            (ftfRate || 0).toFixed ? ftfRate.toFixed(1) : (ftfRate || 0);

        new Chart(document.getElementById('chartRiskRedByCat'), {
            type: 'bar',
            data: {
                labels: (redByCat || []).map(x => x.label),
                datasets: [{
                    label: 'Số máy',
                    data: (redByCat || []).map(x => x.value || 0),
                    backgroundColor: 'rgba(255,193,7,0.85)',
                    borderRadius: 6,
                    borderSkipped: false
                }]
            },
            options: {
                indexAxis: 'y',
                responsive: true,
                plugins: { legend: { display: false } },
                scales: {
                    x: { beginAtZero: true, grid: { color: '#f0f0f0' } },
                    y: { grid: { display: false } }
                }
            }
        });

        const body = document.getElementById('riskRedListBody');
        if (!redList || redList.length === 0) {
            body.innerHTML =
                '<tr><td colspan="4" class="text-muted">Không có dữ liệu</td></tr>';
            return;
        }

        body.innerHTML = redList.map(r => {
            const d = r.lastMaintenanceDate ? String(r.lastMaintenanceDate) : '-';
            return '<tr>' +
                '<td>' + (r.serialNumber || '') + '</td>' +
                '<td>' + (r.customerName || '') + '</td>' +
                '<td>' + (r.location || '') + '</td>' +
                '<td>' + d + '</td>' +
                '</tr>';
        }).join('');
    })();
</script>