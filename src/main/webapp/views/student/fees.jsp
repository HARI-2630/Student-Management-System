<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AuraSMS - My Invoices</title>
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
    </style>
</head>
<body>

    <!-- NAVBAR INCLUDE -->
    <jsp:include page="../common/navbar.jsp" />

    <main class="container py-4" style="max-width: 900px;">
        
        <!-- HEADER -->
        <div class="mb-4">
            <h2 class="fw-bold mb-1" style="font-family: 'Outfit';">My Fee Statement Invoices</h2>
            <p class="text-muted">Review payment statuses and deadlines for academic tuition fees.</p>
        </div>

        <!-- FEES LEDGER CARD -->
        <div class="glass-card">
            <h5 class="fw-bold mb-4" style="font-family: 'Outfit';">Tuition Invoices</h5>
            <div class="table-responsive">
                <table class="table custom-table table-hover mb-0">
                    <thead>
                        <tr>
                            <th>Semester</th>
                            <th>Billing Amount</th>
                            <th>Due Date</th>
                            <th>Paid Date</th>
                            <th class="text-end">Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty fees}">
                                <tr>
                                    <td colspan="5" class="text-center py-4 text-muted">
                                        No tuition fee invoices issued for your account.
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="fee" items="${fees}">
                                    <tr>
                                        <td class="text-white fw-semibold">Semester ${fee.semester}</td>
                                        <td class="fw-bold text-gradient">
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
                                        <td class="text-end">
                                            <span class="badge-status badge-${fee.status.toLowerCase()}">
                                                ${fee.status}
                                            </span>
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

    <!-- Bootstrap 5 Bundle JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
