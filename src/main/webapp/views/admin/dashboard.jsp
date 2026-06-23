<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AuraSMS - Admin Dashboard</title>
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
        .text-gradient {
            background: linear-gradient(135deg, #6366f1 0%, #a855f7 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        .glass-card {
            background: rgba(17, 20, 34, 0.65);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
            padding: 30px;
            transition: all 0.3s;
        }
        .glass-card:hover {
            transform: translateY(-5px);
            border-color: rgba(99, 102, 241, 0.4);
        }
        .stat-icon {
            width: 60px;
            height: 60px;
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.75rem;
            color: #fff;
            margin-bottom: 20px;
        }
        .icon-students { background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%); }
        .icon-teachers { background: linear-gradient(135deg, #10b981 0%, #047857 100%); }
        .icon-courses { background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%); }
        .icon-fees { background: linear-gradient(135deg, #ef4444 0%, #b91c1c 100%); }
    </style>
</head>
<body>

    <!-- NAVBAR INCLUDE -->
    <jsp:include page="../common/navbar.jsp" />

    <main class="container-fluid px-5 py-4">
        <div class="mb-5">
            <h2 class="fw-bold mb-1" style="font-family: 'Outfit', sans-serif;">System Overview</h2>
            <p class="text-muted">Welcome, Admin. Here are the core statistics for AuraSMS.</p>
        </div>

        <!-- STATS ROW -->
        <div class="row g-4 mb-5">
            
            <div class="col-md-3">
                <div class="glass-card">
                    <div class="stat-icon icon-students">
                        <i class="bi bi-people-fill"></i>
                    </div>
                    <span class="text-muted d-block mb-1 small fw-semibold">Total Students</span>
                    <h2 class="fw-bold m-0" style="font-family: 'Outfit';">${studentCount}</h2>
                </div>
            </div>

            <div class="col-md-3">
                <div class="glass-card">
                    <div class="stat-icon icon-teachers">
                        <i class="bi bi-person-badge-fill"></i>
                    </div>
                    <span class="text-muted d-block mb-1 small fw-semibold">Total Faculty</span>
                    <h2 class="fw-bold m-0" style="font-family: 'Outfit';">${teacherCount}</h2>
                </div>
            </div>

            <div class="col-md-3">
                <div class="glass-card">
                    <div class="stat-icon icon-courses">
                        <i class="bi bi-book-fill"></i>
                    </div>
                    <span class="text-muted d-block mb-1 small fw-semibold">Active Courses</span>
                    <h2 class="fw-bold m-0" style="font-family: 'Outfit';">${courseCount}</h2>
                </div>
            </div>

            <div class="col-md-3">
                <div class="glass-card">
                    <div class="stat-icon icon-fees">
                        <i class="bi bi-credit-card-fill"></i>
                    </div>
                    <span class="text-muted d-block mb-1 small fw-semibold">Unpaid Invoice Sum</span>
                    <h2 class="fw-bold m-0" style="font-family: 'Outfit';">
                        <fmt:formatNumber value="${unpaidFees}" type="currency" currencySymbol="$" />
                    </h2>
                </div>
            </div>

        </div>

        <!-- QUICK LINKS -->
        <div class="glass-card">
            <h4 class="fw-bold mb-4" style="font-family: 'Outfit';">Quick Operations</h4>
            <div class="row g-3">
                <div class="col-md-4">
                    <a href="${pageContext.request.contextPath}/admin/students?action=new" class="btn btn-outline-primary w-100 py-3 rounded-3 fw-semibold">
                        <i class="bi bi-person-plus-fill"></i> Register New Student
                    </a>
                </div>
                <div class="col-md-4">
                    <a href="${pageContext.request.contextPath}/admin/teachers?action=new" class="btn btn-outline-success w-100 py-3 rounded-3 fw-semibold">
                        <i class="bi bi-person-plus-fill"></i> Hire New Teacher
                    </a>
                </div>
                <div class="col-md-4">
                    <a href="${pageContext.request.contextPath}/admin/courses?action=new" class="btn btn-outline-warning w-100 py-3 rounded-3 fw-semibold">
                        <i class="bi bi-plus-circle-fill"></i> Setup New Course
                    </a>
                </div>
            </div>
        </div>
    </main>

    <!-- Bootstrap 5 Bundle JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
