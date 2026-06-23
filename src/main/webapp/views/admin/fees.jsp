<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AuraSMS - Manage Fees</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Google Fonts & Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Outfit:wght@500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #090b11;
            color: #f8fafc;
            min-height: 100vh;
        }
        .glass-card {
            background: rgba(17, 20, 34, 0.65);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
            padding: 30px;
            margin-bottom: 24px;
        }
        .form-control, .form-select {
            background-color: rgba(255, 255, 255, 0.04);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 10px;
            color: #f8fafc;
            padding: 10px 14px;
        }
        .form-control:focus, .form-select:focus {
            background-color: rgba(255, 255, 255, 0.02);
            border-color: #6366f1;
            box-shadow: 0 0 10px rgba(99, 102, 241, 0.2);
            color: #f8fafc;
        }
        .form-select option {
            background-color: #111422;
            color: #f8fafc;
        }
        .custom-table {
            color: #cbd5e1;
            margin-bottom: 0;
        }
        .custom-table th {
            text-transform: uppercase;
            font-size: 0.75rem;
            letter-spacing: 0.5px;
            color: #64748b;
            border-bottom: 1px solid rgba(255, 255, 255, 0.08);
            padding: 16px;
        }
        .custom-table td {
            padding: 16px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
            vertical-align: middle;
        }
        .badge-status {
            padding: 6px 12px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 0.75rem;
        }
        .badge-paid {
            background-color: rgba(20, 184, 166, 0.1);
            color: #14b8a6;
        }
        .badge-unpaid {
            background-color: rgba(245, 158, 11, 0.1);
            color: #f59e0b;
        }
        .badge-overdue {
            background-color: rgba(244, 63, 94, 0.1);
            color: #f43f5e;
        }
        .text-gradient {
            background: linear-gradient(135deg, #6366f1 0%, #a855f7 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        /* Modal customizations */
        .modal-content {
            background-color: #111422;
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 20px;
            color: #f8fafc;
        }
        .modal-header {
            border-bottom: 1px solid rgba(255, 255, 255, 0.08);
        }
        .modal-footer {
            border-top: 1px solid rgba(255, 255, 255, 0.08);
        }
    </style>
</head>
<body>

    <!-- NAVBAR INCLUDE -->
    <jsp:include page="../common/navbar.jsp" />

    <main class="container-fluid px-5 py-4">
        
        <!-- HEADER -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="fw-bold mb-1" style="font-family: 'Outfit';">Fees Billing Ledger</h2>
                <p class="text-muted">Issue invoice statements and record tuition payments.</p>
            </div>
            <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#invoiceModal" style="background: linear-gradient(135deg, #6366f1 0%, #a855f7 100%); border: none; border-radius: 10px; font-weight: 600; padding: 10px 20px;">
                <i class="bi bi-file-earmark-plus-fill"></i> Create Invoice
            </button>
        </div>

        <!-- NOTIFICATION ALERTS -->
        <c:if test="${param.msg == 'success'}">
            <div class="alert alert-success alert-dismissible fade show" role="alert" style="border-radius: 12px;">
                <i class="bi bi-check-circle-fill"></i> Invoice generated and posted successfully.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        <c:if test="${param.msg == 'paid'}">
            <div class="alert alert-success alert-dismissible fade show" role="alert" style="border-radius: 12px;">
                <i class="bi bi-check-circle-fill"></i> Invoice payment successfully recorded in ledgers.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        <c:if test="${param.msg == 'error'}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert" style="border-radius: 12px;">
                <i class="bi bi-exclamation-triangle-fill"></i> Operation failed. Review ledger parameters.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <!-- FEES TABLE -->
        <div class="glass-card">
            <div class="table-responsive">
                <table class="table custom-table table-hover">
                    <thead>
                        <tr>
                            <th>Student Name</th>
                            <th>Roll Number</th>
                            <th>Semester</th>
                            <th>Billing Amount</th>
                            <th>Due Date</th>
                            <th>Paid Date</th>
                            <th>Status</th>
                            <th class="text-end">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty fees}">
                                <tr>
                                    <td colspan="8" class="text-center py-4 text-muted">
                                        No billing records found in system.
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="fee" items="${fees}">
                                    <tr>
                                        <td class="text-white fw-semibold">${fee.studentName}</td>
                                        <td class="fw-bold text-gradient">${fee.rollNumber}</td>
                                        <td>Semester ${fee.semester}</td>
                                        <td class="fw-bold text-white">
                                            <fmt:formatNumber value="${fee.amount}" type="currency" currencySymbol="$" />
                                        </td>
                                        <td>${fee.dueDate}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty fee.paidDate}">
                                                    ${fee.paidDate}
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted small">-</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <span class="badge-status badge-${fee.status.toLowerCase()}">
                                                ${fee.status}
                                            </span>
                                        </td>
                                        <td class="text-end">
                                            <c:choose>
                                                <c:when test="${fee.status != 'PAID'}">
                                                    <form action="${pageContext.request.contextPath}/admin/fees" method="POST" style="display:inline;">
                                                        <input type="hidden" name="action" value="pay">
                                                        <input type="hidden" name="feeId" value="${fee.id}">
                                                        <button type="submit" class="btn btn-sm btn-outline-success">
                                                            <i class="bi bi-cash-coin"></i> Mark PAID
                                                        </button>
                                                    </form>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted small text-success"><i class="bi bi-check-lg"></i> Paid</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>

    </main>

    <!-- CREATE INVOICE MODAL -->
    <div class="modal fade" id="invoiceModal" tabindex="-1" aria-labelledby="invoiceModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold" id="invoiceModalLabel" style="font-family: 'Outfit';">Create Semester Invoice</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                
                <form action="${pageContext.request.contextPath}/admin/fees" method="POST" class="needs-validation" novalidate>
                    <div class="modal-body">
                        
                        <div class="mb-3">
                            <label for="studentId" class="form-label text-muted small fw-semibold">Select Student</label>
                            <select class="form-select border-secondary" id="studentId" name="studentId" required>
                                <option value="">-- Choose Student --</option>
                                <c:forEach var="student" items="${students}">
                                    <option value="${student.id}">${student.name} (${student.rollNumber})</option>
                                </c:forEach>
                            </select>
                            <div class="invalid-feedback">Choose a student for billing.</div>
                        </div>

                        <div class="mb-3">
                            <label for="semester" class="form-label text-muted small fw-semibold">Target Academic Semester</label>
                            <select class="form-select border-secondary" id="semester" name="semester" required>
                                <option value="">-- Choose Semester --</option>
                                <option value="1">Semester 1</option>
                                <option value="2">Semester 2</option>
                                <option value="3">Semester 3</option>
                                <option value="4">Semester 4</option>
                                <option value="5">Semester 5</option>
                                <option value="6">Semester 6</option>
                                <option value="7">Semester 7</option>
                                <option value="8">Semester 8</option>
                            </select>
                            <div class="invalid-feedback">Select an academic semester.</div>
                        </div>

                        <div class="mb-3">
                            <label for="amount" class="form-label text-muted small fw-semibold">Tuition Bill Amount ($)</label>
                            <input type="number" step="0.01" class="form-control border-secondary" id="amount" name="amount" min="1" placeholder="e.g. 2500" required>
                            <div class="invalid-feedback">Please enter a billing amount &ge; 1.</div>
                        </div>

                        <div class="mb-3">
                            <label for="dueDate" class="form-label text-muted small fw-semibold">Due Payment Date</label>
                            <input type="date" class="form-control border-secondary" id="dueDate" name="dueDate" required>
                            <div class="invalid-feedback">Please choose a valid payment due date.</div>
                        </div>

                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="submit" class="btn btn-primary" style="background: linear-gradient(135deg, #6366f1 0%, #a855f7 100%); border: none; border-radius: 10px; font-weight: 600;">
                            Post Invoice
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Bootstrap 5 Bundle JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Form Validation Bootstrap Helper
        (() => {
            'use strict'
            const forms = document.querySelectorAll('.needs-validation')
            Array.from(forms).forEach(form => {
                form.addEventListener('submit', event => {
                    if (!form.checkValidity()) {
                        event.preventDefault()
                        event.stopPropagation()
                    }
                    form.classList.add('was-validated')
                }, false)
            })
        })()
    </script>
</body>
</html>
