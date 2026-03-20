<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 3/20/2026
  Time: 1:10 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="row g-3 mb-4">
    <div class="col-md-2">
        <div class="card chart-card p-3 h-100">
            <div class="small text-muted">Tổng khách hàng</div>
            <div class="fs-3 fw-bold">${invTotalCustomers}</div>
        </div>
    </div>

    <div class="col-md-2">
        <div class="card chart-card p-3 h-100">
            <div class="small text-muted">Tổng thiết bị</div>
            <div class="fs-3 fw-bold">${invTotalDevices}</div>
        </div>
    </div>

    <div class="col-md-2">
        <div class="card chart-card p-3 h-100">
            <div class="small text-muted">Hợp đồng Active</div>
            <div class="fs-3 fw-bold">${invActiveContracts}</div>
        </div>
    </div>

    <div class="col-md-2">
        <div class="card chart-card p-3 h-100">
            <div class="small text-muted">RUNNING</div>
            <div class="fs-3 fw-bold">${invDevicesRunning}</div>
        </div>
    </div>

    <div class="col-md-2">
        <div class="card chart-card p-3 h-100">
            <div class="small text-muted">MAINTENANCE</div>
            <div class="fs-3 fw-bold">${invDevicesMaintenance}</div>
        </div>
    </div>

    <div class="col-md-2">
        <div class="card chart-card p-3 h-100">
            <div class="small text-muted">BROKEN/REPAIRING</div>
            <div class="fs-3 fw-bold">${invDevicesBroken}</div>
        </div>
    </div>
</div>

<div class="row g-3 mb-3">
    <div class="col-md-6">
        <div class="card chart-card h-100">
            <div class="card-header py-3 px-4">
                Thiết bị theo thương hiệu
            </div>
            <div class="card-body px-4 pb-4">
                <canvas id="chartDevicesByBrand" height="140"></canvas>
            </div>
        </div>
    </div>

    <div class="col-md-6">
        <div class="card chart-card h-100">
            <div class="card-header py-3 px-4">
                Thiết bị theo phân khúc
            </div>
            <div class="card-body px-4 pb-4">
                <canvas id="chartDevicesByCategory" height="140"></canvas>
            </div>
        </div>
    </div>
</div>

<div class="row g-3 mb-3">
    <div class="col-md-6">
        <div class="card chart-card h-100">
            <div class="card-header py-3 px-4">
                Thiết bị theo công suất (kVA)
            </div>
            <div class="card-body px-4 pb-4">
                <canvas id="chartDevicesByKva" height="140"></canvas>
            </div>
        </div>
    </div>

    <div class="col-md-6">
        <div class="card chart-card h-100">
            <div class="card-header py-3 px-4">
                Top model phổ biến
            </div>
            <div class="card-body px-4 pb-4">
                <div class="table-responsive">
                    <table class="table table-sm align-middle">
                        <thead>
                        <tr>
                            <th>Model</th>
                            <th>Brand</th>
                            <th>kVA</th>
                            <th class="text-end">Số máy</th>
                        </tr>
                        </thead>
                        <tbody id="topModelsBody"></tbody>
                    </table>
                </div>
                <small class="text-muted">
                    Ghi chú: Location sẽ bổ sung chuẩn hoá sau.
                </small>
            </div>
        </div>
    </div>
</div>

<script>
    (function () {
        const byBrand = ${devicesByBrandJson};
        const byCat = ${devicesByCategoryJson};
        const byKva = ${devicesByKvaBucketJson};
        const topModels = ${topModelsJson};

        function toLabels(data) {
            return (data || []).map(x => x.label);
        }

        function toValues(data) {
            return (data || []).map(x => x.value);
        }

        // Brand
        new Chart(document.getElementById('chartDevicesByBrand'), {
            type: 'bar',
            data: {
                labels: toLabels(byBrand),
                datasets: [{
                    label: 'Số thiết bị',
                    data: toValues(byBrand),
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

        // Category
        new Chart(document.getElementById('chartDevicesByCategory'), {
            type: 'pie',
            data: {
                labels: toLabels(byCat),
                datasets: [{
                    data: toValues(byCat),
                    backgroundColor: ['#198754', '#ffc107', '#0dcaf0', '#dc3545',
                        '#6f42c1', '#fd7e14']
                }]
            },
            options: {
                responsive: true,
                plugins: { legend: { position: 'bottom' } }
            }
        });

        // kVA
        new Chart(document.getElementById('chartDevicesByKva'), {
            type: 'bar',
            data: {
                labels: toLabels(byKva),
                datasets: [{
                    label: 'Số thiết bị',
                    data: toValues(byKva),
                    backgroundColor: 'rgba(25,135,84,0.75)',
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

        // Table top models
        const body = document.getElementById('topModelsBody');
        if (!topModels || topModels.length === 0) {
            body.innerHTML = '<tr><td colspan="4" class="text-muted">' +
                'Không có dữ liệu</td></tr>';
            return;
        }

        body.innerHTML = topModels.map(r => {
            const kva = (r.kva === null || r.kva === undefined) ? '' : r.kva;
            const brand = r.brandName || '';
            return '<tr>' +
                '<td>' + (r.modelName || '') + '</td>' +
                '<td>' + brand + '</td>' +
                '<td>' + kva + '</td>' +
                '<td class="text-end">' + (r.totalDevices || 0) + '</td>' +
                '</tr>';
        }).join('');
    })();
</script>
