<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container mt-4 mb-4">
    <h3 class="text-primary mb-3"><i class="fa fa-file-contract"></i> Create Contract (AI Assisted)</h3>
    <c:if test="${not empty errorMessage}"><div class="alert alert-danger">${errorMessage}</div></c:if>
    <c:if test="${not empty param.msg}"><div class="alert alert-info">${param.msg}</div></c:if>

    <div class="row g-3">
        <div class="col-lg-6">
            <div class="card">
                <div class="card-header fw-bold">Contract Header</div>
                <div class="card-body">
                    <form method="post" action="${pageContext.request.contextPath}/manager/contracts/draft">
                        <div class="mb-2">
                            <label class="form-label">Contract number</label>
                            <input class="form-control" name="contractNumber" required value="${draftContract.contractNumber}" />
                        </div>
                        <div class="mb-2">
                            <label class="form-label">Customer</label>
                            <select class="form-select" name="customerId" required>
                                <option value="">-- Select --</option>
                                <c:forEach var="cus" items="${customers}">
                                    <option value="${cus.id}" <c:if test="${draftContract.customerId == cus.id}">selected</c:if>>${cus.fullName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="row">
                            <div class="col-md-4 mb-2"><label>Signed date</label><input type="date" class="form-control" name="signedDate" value="${draftContract.signedDate}" required /></div>
                            <div class="col-md-4 mb-2"><label>Start date</label><input type="date" class="form-control" name="startDate" value="${draftContract.startDate}" required /></div>
                            <div class="col-md-4 mb-2"><label>End date</label><input type="date" class="form-control" name="endDate" value="${draftContract.endDate}" required /></div>
                        </div>
                        <button class="btn btn-primary" type="submit">Save draft</button>
                    </form>
                </div>
            </div>
        </div>

        <div class="col-lg-6">
            <div class="card">
                <div class="card-header fw-bold">AI Chat</div>
                <div class="card-body">
                    <div id="chatBox" class="border rounded p-2 mb-2" style="height: 180px; overflow:auto;"></div>
                    <c:if test="${not empty draftContract}">
                        <form id="uploadForm" enctype="multipart/form-data" class="mb-2">
                            <input type="hidden" name="contractId" value="${draftContract.id}" />
                            <input id="sourceFile" type="file" name="sourceFile" class="form-control mb-2" accept=".pdf,.png,.jpg,.jpeg" />
                            <button class="btn btn-outline-primary" type="button" onclick="uploadFile()">Upload file</button>
                        </form>
                        <div class="input-group">
                            <input id="userPrompt" class="form-control" placeholder="Hãy giúp tôi trích xuất list device có trong hợp đồng" />
                            <button class="btn btn-danger" type="button" onclick="sendChat()">Gửi</button>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <c:if test="${not empty draftContract}">
        <div class="card mt-3">
            <div class="card-header fw-bold">Extracted Device List (Editable)</div>
            <div class="card-body">
                <form method="post" action="${pageContext.request.contextPath}/manager/contracts/ai/apply">
                    <input type="hidden" name="contractId" value="${draftContract.id}" />
                    <table class="table table-bordered" id="deviceTable">
                        <thead>
                        <tr><th>Raw model</th><th>Matched model</th><th>Qty</th><th>Serial</th><th>Year</th><th>Location</th></tr>
                        </thead>
                        <tbody id="deviceTableBody">
                        <c:forEach var="item" items="${aiItems}">
                            <tr>
                                <td>${item.rawModelName}<input type="hidden" name="itemId" value="${item.id}" /></td>
                                <td>
                                    <select class="form-select" name="matchedModelId">
                                        <option value="">-- Select --</option>
                                        <c:forEach var="m" items="${models}">
                                            <option value="${m.id}" <c:if test="${item.matchedModelId == m.id}">selected</c:if>>${m.name}</option>
                                        </c:forEach>
                                    </select>
                                </td>
                                <td><input class="form-control" name="quantity" type="number" value="${item.quantity}" min="1" /></td>
                                <td><input class="form-control" name="serial" value="${item.rawSerialNumber}" /></td>
                                <td><input class="form-control" name="manufactureYear" value="${item.manufactureYear}" /></td>
                                <td><input class="form-control" name="currentLocation" value="${item.currentLocation}" /></td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                    <button class="btn btn-primary" type="submit">Apply</button>
                </form>

                <form method="post" action="${pageContext.request.contextPath}/manager/contracts/finalize" class="mt-2">
                    <input type="hidden" name="contractId" value="${draftContract.id}" />
                    <button class="btn btn-success" type="submit">Finalize Contract</button>
                </form>
            </div>
        </div>
    </c:if>
</div>

<script>
function appendChat(msg){
  const box=document.getElementById('chatBox');
  if(!box) return;
  const div=document.createElement('div');
  div.className='mb-2 p-2 bg-light rounded';
  div.textContent=msg;
  box.appendChild(div);
}

function uploadFile(){
  const form=document.getElementById('uploadForm');
  if(!form) return;
  const data=new FormData(form);
  fetch('${pageContext.request.contextPath}/manager/contracts/ai/upload?format=json',{method:'POST',body:data,headers:{'Accept':'application/json'}})
    .then(r=>r.json()).then(j=>appendChat(j.chatMessage||'Upload done')).catch(()=>appendChat('Upload thất bại'));
}

function renderItems(items){
  const tbody=document.getElementById('deviceTableBody');
  if(!tbody || !Array.isArray(items)) return;
  tbody.innerHTML='';
  items.forEach(it=>{
    const tr=document.createElement('tr');
    tr.innerHTML=`<td>${it.raw_model_name||''}<input type="hidden" name="itemId" value="" /></td>
      <td><input class="form-control" name="matchedModelId" value="" /></td>
      <td><input class="form-control" name="quantity" type="number" min="1" value="${it.quantity||1}" /></td>
      <td><input class="form-control" name="serial" value="${it.raw_serial_number||''}" /></td>
      <td><input class="form-control" name="manufactureYear" value="${it.manufacture_year||''}" /></td>
      <td><input class="form-control" name="currentLocation" value="${it.current_location||''}" /></td>`;
    tbody.appendChild(tr);
  });
}

function sendChat(){
  const prompt=document.getElementById('userPrompt')?.value || 'Hãy giúp tôi trích xuất list device có trong hợp đồng';
  const cid='${draftContract.id}';
  const data=new URLSearchParams();
  data.append('contractId', cid);
  data.append('userPrompt', prompt);

  fetch('${pageContext.request.contextPath}/manager/contracts/ai/chat',{method:'POST',body:data,headers:{'Accept':'application/json','Content-Type':'application/x-www-form-urlencoded'}})
    .then(r=>r.json())
    .then(j=>{ appendChat(j.chatMessage||'Done'); renderItems(j.items||[]); if(j.warnings){ j.warnings.forEach(w=>appendChat('⚠ '+w)); } })
    .catch(()=>appendChat('AI chat thất bại'));
}
</script>
