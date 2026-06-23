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
        .form-select {
            background-color: rgba(255, 255, 255, 0.04);
            border: 1px solid rgba(255, 255, 255, 0.08);
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
        .text-teal {
            color: #14b8a6;
        }
        .text-gradient {
            background: linear-gradient(135deg, #6366f1 0%, #a855f7 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        .badge-count {
            padding: 6px 10px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 0.8rem;
        }
        .badge-present {
            background-color: rgba(20, 184, 166, 0.1);
            color: #14b8a6;
        }
        .badge-absent {
            background-color: rgba(244, 63, 94, 0.1);
            color: #f43f5e;
        }
        .badge-late {
            background-color: rgba(245, 158, 11, 0.1);
            color: #f59e0b;
        }
    </style>
</head>
<body>

    <!-- NAVBAR INCLUDE -->
    <jsp:include page="../common/navbar.jsp" />

    <main class="container-fluid px-5 py-4">
        
        <!-- HEADER -->
        <div class="mb-4">
            <h2 class="fw-bold mb-1" style="font-family: 'Outfit';">Attendance Aggregate Reports</h2>
            <p class="text-muted">Analyze overall student attendance rates per course. Attendance under 75% will be flagged in red.</p>
        </div>

        <!-- FILTERS PANEL -->
        <div class="glass-card mb-4">
            <form action="${pageContext.request.contextPath}/admin/attendance" method="GET" class="row g-3">
                <div class="col-md-10">
                    <label for="courseId" class="text-muted small fw-semibold d-block mb-2">Select Course Module</label>
                    <select class="form-select border-secondary" id="courseId" name="courseId" required>
                        <option value="">-- Select Course --</option>
                        <c:forEach var="course" items="${courses}">
                            <option value="${course.id}" <c:if test="${selectedCourseId == course.id}">selected</c:if>>
                                ${course.code} - ${course.name}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-2 d-flex align-items-end">
                    <button type="submit" class="btn btn-primary w-100 py-2 fw-semibold" style="background: linear-gradient(135deg, #6366f1 0%, #a855f7 100%); border: none; border-radius: 10px;">
                        Fetch Metrics
                    </button>
                </div>
            </form>
        </div>

        <!-- REPORT LIST -->
        <c:if test="${not empty attendanceReports}">
            <div class="glass-card">
                <h5 class="fw-bold mb-4" style="font-family: 'Outfit';">Performance Metrics</h5>
                <div class="table-responsive">
                    <table class="table custom-table table-hover">
                        <thead>
                            <tr>
                                <th>Student Name</th>
                                <th>Roll Number</th>
                                <th class="text-center">Present</th>
                                <th class="text-center">Absent</th>
                                <th class="text-center">Late</th>
                                <th class="text-center">Total classes</th>
                                <th class="text-end">Attendance Rate</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="report" items="${attendanceReports}">
                                <tr>
                                    <td class="text-white fw-semibold">${report.studentName}</td>
                                    <td class="fw-bold text-gradient">${report.rollNumber}</td>
                                    <td class="text-center">
                                        <span class="badge-count badge-present">${report.presentCount}</span>
                                    </td>
                                    <td class="text-center">
                                        <span class="badge-count badge-absent">${report.absentCount}</span>
                                    </td>
                                    <td class="text-center">
                                        <span class="badge-count badge-late">${report.lateCount}</span>
                                    </td>
                                    <td class="text-center text-white fw-semibold">${report.totalCount}</td>
                                    <!-- Business Logic: < 75% Attendance flagged in red -->
                                    <td class="text-end fw-bold fs-5 ${report.percentage < 75.0 ? 'text-danger' : 'text-teal'}">
                                        ${report.percentage}%
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </c:if>

        <c:if test="${empty attendanceReports && not empty selectedCourseId}">
            <div class="glass-card py-5 text-center text-muted">
                <i class="bi bi-calendar-x fs-1 d-block mb-3"></i>
                No attendance logs found for this course module.
            </div>
        </c:if>

    </main>

    <!-- Bootstrap 5 Bundle JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
