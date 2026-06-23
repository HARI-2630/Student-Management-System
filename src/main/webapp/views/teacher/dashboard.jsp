<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AuraSMS - Teacher Dashboard</title>
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
    </style>
</head>
<body>

    <!-- NAVBAR INCLUDE -->
    <jsp:include page="../common/navbar.jsp" />

    <main class="container-fluid px-5 py-4">
        
        <!-- PROFILE SECTION -->
        <div class="glass-card">
            <div class="d-flex align-items-center gap-4">
                <div class="rounded-circle d-flex align-items-center justify-content-center bg-primary text-white" style="width: 70px; height: 70px; font-size: 2rem;">
                    <i class="bi bi-person-badge"></i>
                </div>
                <div>
                    <h3 class="fw-bold mb-1" style="font-family: 'Outfit';">${teacher.name}</h3>
                    <p class="text-muted m-0">
                        <span class="badge bg-secondary me-2">${teacher.department} Department</span> 
                        <i class="bi bi-mortarboard-fill text-primary"></i> ${teacher.qualification}
                    </p>
                </div>
            </div>
        </div>

        <!-- ASSIGNED COURSES -->
        <div class="glass-card">
            <h4 class="fw-bold mb-4" style="font-family: 'Outfit';">Assigned Courses</h4>
            <div class="table-responsive">
                <table class="table custom-table table-hover mb-0">
                    <thead>
                        <tr>
                            <th>Code</th>
                            <th>Course Name</th>
                            <th>Credits</th>
                            <th class="text-end">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty assignedCourses}">
                                <tr>
                                    <td colspan="4" class="text-center py-4 text-muted">
                                        No courses assigned yet. Contact Admin.
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="course" items="${assignedCourses}">
                                    <tr>
                                        <td class="fw-bold text-gradient">${course.code}</td>
                                        <td class="text-white">${course.name}</td>
                                        <td>${course.credits} Credits</td>
                                        <td class="text-end">
                                            <a href="${pageContext.request.contextPath}/teacher/attendance?courseId=${course.id}" class="btn btn-sm btn-outline-primary me-2">
                                                <i class="bi bi-calendar-check"></i> Record Attendance
                                            </a>
                                            <a href="${pageContext.request.contextPath}/teacher/marks?courseId=${course.id}" class="btn btn-sm btn-outline-success">
                                                <i class="bi bi-input-cursor-text"></i> Grade Marks
                                            </a>
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
