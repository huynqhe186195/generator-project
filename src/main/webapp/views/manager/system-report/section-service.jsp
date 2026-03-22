<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<div class="row g-3 mb-4">
    <div class="col-md-2">
        <div class="card chart-card p-3 h-100">
            <div class="small text-muted">Sự cố chưa xử lý</div>
            <div class="fs-3 fw-bold">${svcPendingIncidents}</div>
        </div>
    </div>

    <div class="col-md-2">
        <div class="card chart-card p-3 h-100">
            <div class="small text-muted">Sự cố trong BH</div>
            <div class="fs-3 fw-bold">${svcIncidentsInWarranty}</div>
            <div class="small text-muted">In-warranty</div>
        </div>
    </div>

    <div class="col-md-2">
        <div class="card chart-card p-3 h-100">
            <div class="small text-muted">Sự cố ngoài BH</div>
            <div class="fs-3 fw-bold">${svcIncidentsOutWarranty}</div>
            <div class="small text-muted">Out-of-warranty</div>
        </div>
    </div>

    <div class="col-md-3">
        <div class="card chart-card p-3 h-100">
            <div class="small text-muted">Phiếu bảo trì trong BH</div>
            <div class="fs-3 fw-bold">${svcMaintInWarranty}</div>
            <div class="small text-muted">Work orders (warranty)</div>
        </div>
    </div>

    <div class="col-md-3">
        <div class="card chart-card p-3 h-100">
            <div class="small text-muted">Phiếu bảo trì ngoài BH</div>
            <div class="fs-3 fw-bold">${svcMaintOutWarranty}</div>
            <div class="small text-muted">Work orders (paid)</div>
        </div>
    </div>
</div>

<div class="row g-3 mb-3">
    <div class="col-md-7">
        <div class="card chart-card h-100">
            <div class="card-header py-3 px-4">
                Sự cố theo tháng: Trong BH vs Ngoài BH
            </div>
            <div class="card-body px-4 pb-4">
                <canvas id="chartSvcIncWarranty" height="140"></canvas>
            </div>
        </div>
    </div>

    <div class="col-md-5">
        <div class="card chart-card h-100">
            <div class="card-header py-3 px-4">
                Sự cố theo mức độ ưu tiên
            </div>
            <div class="card-body px-4 pb-4">
                <canvas id="chartSvcPriority" height="160"></canvas>
            </div>
        </div>
    </div>
</div>

<div class="row g-3 mb-3">
    <div class="col-md-12">
        <div class="card chart-card h-100">
            <div class="card-header py-3 px-4">
                Phiếu bảo trì theo tháng: Trong BH vs Ngoài BH
            </div>
            <div class="card-body px-4 pb-4">
                <canvas id="chartSvcMaintWarranty" height="120"></canvas>
            </div>
        </div>
    </div>
</div>

<script>
    (function () {
        const monthLabels = ['T1','T2','T3','T4','T5','T6','T7','T8','T9','T10',
            'T11','T12'];

        const incByMonth = ${svcIncidentsWarrantyByMonthJson};
        const maintByMonth = ${svcMaintWarrantyByMonthJson};
        const prio = ${svcIncidentPriorityJson};

        const incIn = (incByMonth || []).map(x => x.in || 0);
        const incOut = (incByMonth || []).map(x => x.out || 0);

        const mIn = (maintByMonth || []).map(x => x.in || 0);
        const mOut = (maintByMonth || []).map(x => x.out || 0);

        new Chart(document.getElementById('chartSvcIncWarranty'), {
            type: 'bar',
            data: {
                labels: monthLabels,
                datasets: [
                    {
                        label: 'Trong bảo hành',
                        data: incIn,
                        backgroundColor: 'rgba(25,135,84,0.75)',
                        borderRadius: 6,
                        borderSkipped: false
                    },
                    {
                        label: 'Ngoài bảo hành',
                        data: incOut,
                        backgroundColor: 'rgba(220,53,69,0.75)',
                        borderRadius: 6,
                        borderSkipped: false
                    }
                ]
            },
            options: {
                responsive: true,
                plugins: { legend: { position: 'bottom' } },
                scales: {
                    y: { beginAtZero: true, grid: { color: '#f0f0f0' } },
                    x: { stacked: false, grid: { display: false } }
                }
            }
        });

        new Chart(document.getElementById('chartSvcMaintWarranty'), {
            type: 'bar',
            data: {
                labels: monthLabels,
                datasets: [
                    {
                        label: 'Trong bảo hành',
                        data: mIn,
                        backgroundColor: 'rgba(13,110,253,0.75)',
                        borderRadius: 6,
                        borderSkipped: false
                    },
                    {
                        label: 'Ngoài bảo hành',
                        data: mOut,
                        backgroundColor: 'rgba(255,193,7,0.75)',
                        borderRadius: 6,
                        borderSkipped: false
                    }
                ]
            },
            options: {
                responsive: true,
                plugins: { legend: { position: 'bottom' } },
                scales: {
                    y: { beginAtZero: true, grid: { color: '#f0f0f0' } },
                    x: { grid: { display: false } }
                }
            }
        });

        // Priority chart
        new Chart(document.getElementById('chartSvcPriority'), {
            type: 'bar',
            data: {
                labels: ['Thấp', 'Trung bình', 'Cao', 'Nghiêm trọng'],
                datasets: [{
                    label: 'Số sự cố',
                    data: [
                        (prio.LOW || 0),
                        (prio.MEDIUM || 0),
                        (prio.HIGH || 0),
                        (prio.CRITICAL || 0)
                    ],
                    backgroundColor: ['#6ea8fe', '#ffc107', '#fd7e14', '#dc3545'],
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
    })();
</script>