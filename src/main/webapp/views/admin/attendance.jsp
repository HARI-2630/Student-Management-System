<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AuraSMS - Attendance Reports</title>
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
        .form-select {
            background-color: rgba(255, 255, 255, 0.04);
            border: 1px solid rgba(255, 255, 255, 0.07);
            border-radius: 10px;
            color: #f8fafc;
            padding: 10px 14px;
        }
        .form-select:focus {
            background-color: rgba(255, 255, 255, 0.02);
            border-color: #6366f1;
            box-shadow: 0 0 10px rgba(99, 102, 241, 0.2);
            color: #f8fafc;
        }
        .form-select option {
            background-color: #111422;
            color: #f8fafc;
        }
        .badge-present {
            background-color: rgba(16, 185, 129, 0.15);
            color: #10b981;
        }
        .badge-absent {
            background-color: rgba(244, 63, 94, 0.15);
            color: #f43f5e;
        }
        .badge-late {
            background-color: rgba(245, 158, 11, 0.15);
            color: #f59e0b;
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
                    <a href="${pageContext.request.contextPath}/admin/dashboard">
                        <i class="bi bi-grid-1x2-fill"></i>
                        <span>Dashboard</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="${pageContext.request.contextPath}/admin/students">
                        <i class="bi bi-people-fill"></i>
                        <span>Students</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="${pageContext.request.contextPath}/admin/teachers">
                        <i class="bi bi-person-badge-fill"></i>
                        <span>Teachers</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="${pageContext.request.contextPath}/admin/courses">
                        <i class="bi bi-book-fill"></i>
                        <span>Courses</span>
                    </a>
                </li>
                <li class="menu-item active">
                    <a href="${pageContext.request.contextPath}/admin/attendance">
                        <i class="bi bi-calendar-check-fill"></i>
                        <span>Attendance Logs</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="${pageContext.request.contextPath}/admin/attendance-report">
                        <i class="bi bi-graph-up-arrow"></i>
                        <span>Attendance Reports</span>
                    </a>
                </li>
                <li class="menu-item">
                    <a href="${pageContext.request.contextPath}/admin/fees">
                        <i class="bi bi-credit-card-fill"></i>
                        <span>Fees</span>
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
                    <h2 class="header-title mb-1">Attendance Register Reports</h2>
                    <p class="text-muted mb-0">Audit daily attendance logs filtered by course or student profiles.</p>
                </div>
            </div>

            <!-- FILTERS PANEL -->
            <div class="glass-card mb-4">
                <h5 class="fw-semibold mb-3" style="font-family: 'Outfit';">Query Reports Filter</h5>
                <form action="${pageContext.request.contextPath}/admin/attendance" method="GET" class="row g-3">
                    
                    <div class="col-md-5">
                        <label for="courseId" class="text-muted small fw-semibold d-block mb-2">Filter By Course</label>
                        <select class="form-select w-100" id="courseId" name="courseId" onchange="resetStudentFilter()">
                            <option value="All">-- Choose Course --</option>
                            <c:forEach var="course" items="${courses}">
                                <option value="${course.id}" <c:if test="${selectedCourseId == course.id}">selected</c:if>>
                                    ${course.code} - ${course.name}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="col-md-5">
                        <label for="studentId" class="text-muted small fw-semibold d-block mb-2">Or Filter By Student</label>
                        <select class="form-select w-100" id="studentId" name="studentId" onchange="resetCourseFilter()">
                            <option value="All">-- Choose Student --</option>
                            <c:forEach var="student" items="${students}">
                                <option value="${student.id}" <c:if test="${selectedStudentId == student.id}">selected</c:if>>
                                    ${student.name} (${student.rollNumber})
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="col-md-2 d-flex align-items-end">
                        <button type="submit" class="btn btn-primary w-100" style="background: linear-gradient(135deg, #6366f1 0%, #a855f7 100%); border: none; border-radius: 10px; font-weight: 600; padding: 10px;">
                            Search Logs
                        </button>
                    </div>
                </form>
            </div>

            <!-- LOGS TABLE -->
            <div class="glass-card">
                <h5 class="fw-semibold mb-3" style="font-family: 'Outfit';">Attendance Entries</h5>
                <div class="table-responsive">
                    <table class="table custom-table table-hover">
                        <thead>
                            <tr>
                                <th>Student</th>
                                <th>Roll Number</th>
                                <th>Course Code</th>
                                <th>Date</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty attendanceLogs}">
                                    <tr>
                                        <td colspan="5" class="text-center py-4 text-muted">
                                            No attendance logs query matches. Apply filters and search.
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="log" items="${attendanceLogs}">
                                        <tr>
                                            <td class="fw-semibold text-white">${log.studentName}</td>
                                            <td>${log.rollNumber}</td>
                                            <td class="fw-bold" style="color: #cbd5e1;">${log.courseCode}</td>
                                            <td>${log.date}</td>
                                            <td>
                                                <span class="badge badge-${log.status.toLowerCase()} p-2" style="border-radius: 6px; font-size: 0.75rem;">
                                                    ${log.status}
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
    </div>

    <!-- Bootstrap 5 Bundle JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function resetStudentFilter() {
            const studentSelect = document.getElementById('studentId');
            if (studentSelect) {
                studentSelect.value = 'All';
            }
        }
        function resetCourseFilter() {
            const courseSelect = document.getElementById('courseId');
            if (courseSelect) {
                courseSelect.value = 'All';
            }
        }
    </script>
</body>
</html>
