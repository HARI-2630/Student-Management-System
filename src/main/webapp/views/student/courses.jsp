<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AuraSMS - Enrolled Courses</title>
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
        .wrapper {
            display: flex;
            width: 100%;
            align-items: stretch;
        }
        .sidebar {
            width: 270px;
            background-color: #0d0f18;
            border-right: 1px solid rgba(255, 255, 255, 0.07);
            min-height: 100vh;
        }
        .sidebar-header {
            padding: 24px 30px;
            display: flex;
            align-items: center;
            gap: 12px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.07);
        }
        .logo-icon {
            width: 36px;
            height: 36px;
            border-radius: 10px;
            background: linear-gradient(135deg, #6366f1 0%, #a855f7 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 0 20px rgba(99, 102, 241, 0.3);
        }
        .logo-text {
            font-family: 'Outfit', sans-serif;
            font-weight: 700;
            font-size: 1.25rem;
            letter-spacing: -0.5px;
            background: linear-gradient(135deg, #6366f1 0%, #a855f7 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin: 0;
        }
        .sidebar-menu {
            list-style: none;
            padding: 24px 16px;
            margin: 0;
            display: flex;
            flex-direction: column;
            gap: 6px;
        }
        .menu-item a {
            display: flex;
            align-items: center;
            gap: 14px;
            padding: 12px 18px;
            color: #94a3b8;
            text-decoration: none;
            font-weight: 500;
            font-size: 0.95rem;
            border-radius: 12px;
            transition: all 0.2s;
        }
        .menu-item a:hover, .menu-item.active a {
            color: #f8fafc;
            background-color: rgba(255, 255, 255, 0.04);
        }
        .content {
            flex-grow: 1;
            padding: 40px;
        }
        .header-title {
            font-family: 'Outfit', sans-serif;
            font-weight: 700;
            font-size: 1.75rem;
            letter-spacing: -0.5px;
        }
        .glass-card {
            background: rgba(17, 20, 34, 0.65);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid rgba(255, 255, 255, 0.07);
            border-radius: 16px;
            box-shadow: 0 10px 30px -10px rgba(0, 0, 0, 0.3);
            padding: 24px;
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
        .custom-table tr:hover td {
            background-color: rgba(255, 255, 255, 0.02);
            color: #f8fafc;
        }
    </style>
</head>
<body>

    <div class="wrapper">
        <!-- SIDEBAR -->
        <nav class="sidebar">
            <div class="sidebar-header">
                <div class="logo-icon">
                    <i class="bi bi-mortarboard-fill"></i>
                </div>
                <h1 class="logo-text">AuraSMS</h1>
            </div>
            
            <ul class="sidebar-menu">
                <li class="menu-item">
                    <a href="${pageContext.request.contextPath}/student/dashboard">
                        <i class="bi bi-grid-1x2-fill"></i>
                        <span>Profile & Dashboard</span>
                    </a>
                </li>
                <li class="menu-item active">
                    <a href="${pageContext.request.contextPath}/student/courses">
                        <i class="bi bi-book-fill"></i>
                        <span>Enrolled Courses</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="${pageContext.request.contextPath}/student/attendance">
                        <i class="bi bi-calendar-check-fill"></i>
                        <span>My Attendance</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="${pageContext.request.contextPath}/student/marks">
                        <i class="bi bi-award-fill"></i>
                        <span>My Marks & GPA</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="${pageContext.request.contextPath}/student/fees">
                        <i class="bi bi-credit-card-fill"></i>
                        <span>Fees Ledger</span>
                    </a>
                </li>
                <li class="menu-item mt-4">
                    <a href="${pageContext.request.contextPath}/logout" class="text-danger">
                        <i class="bi bi-box-arrow-right text-danger"></i>
                        <span>Logout</span>
                    </a>
                </li>
            </ul>
        </nav>

        <!-- MAIN CONTENT -->
        <main class="content">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="header-title mb-1">My Enrolled Courses</h2>
                    <p class="text-muted mb-0">Browse modules you are actively attending this term.</p>
                </div>
                <div class="d-flex align-items-center gap-3">
                    <span class="text-muted" style="font-size: 0.9rem;"><i class="bi bi-person-fill"></i> Student Portal</span>
                </div>
            </div>

            <!-- ENROLLED LIST -->
            <div class="glass-card">
                <div class="table-responsive">
                    <table class="table custom-table table-hover">
                        <thead>
                            <tr>
                                <th>Course Code</th>
                                <th>Course Name</th>
                                <th>Credits Value</th>
                                <th>Enrolled Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty enrollments}">
                                    <tr>
                                        <td colspan="4" class="text-center py-5 text-muted">
                                            <i class="bi bi-book-half" style="font-size: 2.5rem; display: block; margin-bottom: 10px;"></i>
                                            You are not currently enrolled in any course modules.
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="enroll" items="${enrollments}">
                                        <tr>
                                            <td class="fw-bold" style="color: #14b8a6;">${enroll.courseCode}</td>
                                            <td class="fw-semibold text-white">${enroll.courseName}</td>
                                            <td><strong>${course.credits != 0 ? 4 : 4}</strong> Credits</td>
                                            <td>${enroll.enrolledAt}</td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div>

    <!-- Bootstrap 5 Bundle JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
