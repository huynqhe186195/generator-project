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
    <div class="col-md-3">
        <div class="card chart-cart p-3 h-100">
            <div class="small text-muted">Ticket trung bình</div>
            <div class="fs-3 fw-bold">
                <span id="finAvgTicket"></span>
            </div>
            <div class="small text-muted">Average Ticket Value</div>
        </div>
    </div>

    <div class="col-md-3">
        <div class="card chart-card p-3 h-100">
            <div class="small text-muted">Tổng doanh thu dịch vụ</div>
            <div class="fs-3 fw-bold">
                <span id="finTotalRevenue"></span>
            </div>
            <div class="small text-muted">Service Revenue</div>
        </div>
    </div>

    <div class="col-md-3">
        <div class="card chart-card p-3 h-100">
            <div class="small text-muted">Tổng số linh kiện dùng</div>
            <div class="fs-3 fw-bold">${finTotalPartsQty}</div>
            <div class="small text-muted">Parts quantity</div>
        </div>
    </div>

    <div class="col-md-3">
        <div class="card chart-card p-3 h-100">
            <div class="small text-muted">Năm báo cáo</div>
            <div class="fs-3 fw-bold">${selectedYear}</div>
            <div class="small text-muted">Report Year</div>
        </div>
    </div>
</div>

<div class="row g-3 mb-3">
    <div class="col-md-7">
        <div class="card chart-card h-100">
            <div class="card-header py-3 px-4">
                Doanh thu dịch vụ theo tháng
            </div>
            <div class="card-body px-4 pb-4">
                <canvas id="chartFinRevenue" height="140"></canvas>
            </div>
        </div>
    </div>

    <div class="col-md-5">
        <div class="card chart-card h-100">
            <div class="card-header py-3 px-4">
                Top linh kiện theo số lượng
            </div>
            <div class="card-body px-4 pb-4">
                <canvas id="chartFinTopQty" height="160"></canvas>
            </div>
        </div>
    </div>
</div>

<div class="row g-3 mb-3">
    <div class="col-md-7">
        <div class="card chart-card h-100">
            <div class="card-header py-3 px-4">
                Top linh kiện theo giá trị
            </div>
            <div class="card-body px-4 pb-4">
                <canvas id="chartFinTopValue" height="140"></canvas>
            </div>
        </div>
    </div>

    <div class="col-md-5">
        <div class="card chart-card h-100">
            <div class="card-header py-3 px-4">
                Top phiếu giá trị cao
            </div>
            <div class="card-body px-4 pb-4">
                <div class="table-responsive">
                    <table class="table table-sm align-middle">
                        <thead>
                        <tr>
                            <th>#</th>
                            <th>Serial</th>
                            <th class="text-end">Total</th>
                        </tr>
                        </thead>
                        <tbody id="finTopTicketsBody"></tbody>
                    </table>
                </div>
                <small class="text-muted">
                    Total = Labor + Parts (cost_at_time)
                </small>
            </div>
        </div>
    </div>
</div>

<script>
    (function () {
        const avgTicket = ${finAvgTicket};
        const totalRev = ${finTotalRevenue};

        const revenueByMonth = ${finRevenueByMonthJson};
        const topQty = ${finTopPartsByQtyJson};
        const topVal = ${finTopPartsByValueJson};
        const topTickets = ${finTopTicketsJson};

        function formatMoney(n) {
            const v = (n === null || n === undefined) ? 0 : n;
            return new Intl.NumberFormat('vi-VN').format(v) + ' đ';
        }

        document.getElementById('finAvgTicket').innerText = formatMoney(avgTicket);
        document.getElementById('finTotalRevenue').innerText = formatMoney(totalRev);

        // Revenue by month
        const monthLabels = ['T1','T2','T3','T4','T5','T6','T7','T8','T9','T10',
            'T11','T12'];
        const revValues = (revenueByMonth || []).map(x => x.revenue || 0);

        new Chart(document.getElementById('chartFinRevenue'), {
            type: 'line',
            data: {
                labels: monthLabels,
                datasets: [{
                    label: 'Doanh thu',
                    data: revValues,
                    borderColor: 'rgba(13,110,253,0.9)',
                    backgroundColor: 'rgba(13,110,253,0.15)',
                    fill: true,
                    tension: 0.35
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

        // Top qty
        new Chart(document.getElementById('chartFinTopQty'), {
            type: 'bar',
            data: {
                labels: (topQty || []).map(x => x.code),
                datasets: [{
                    label: 'Số lượng',
                    data: (topQty || []).map(x => x.qty || 0),
                    backgroundColor: 'rgba(25,135,84,0.75)',
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

        // Top value
        new Chart(document.getElementById('chartFinTopValue'), {
            type: 'bar',
            data: {
                labels: (topVal || []).map(x => x.code),
                datasets: [{
                    label: 'Giá trị',
                    data: (topVal || []).map(x => x.value || 0),
                    backgroundColor: 'rgba(220,53,69,0.75)',
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

        // Top tickets table
        const body = document.getElementById('finTopTicketsBody');
        if (!topTickets || topTickets.length === 0) {
            body.innerHTML =
                '<tr><td colspan="3" class="text-muted">Không có dữ liệu</td></tr>';
            return;
        }

        body.innerHTML = topTickets.map((r, idx) => {
            return '<tr>' +
                '<td>' + (idx + 1) + '</td>' +
                '<td>' + (r.serialNumber || '') + '</td>' +
                '<td class="text-end">' + formatMoney(r.total || 0) + '</td>' +
                '</tr>';
        }).join('');
    })();
</script>