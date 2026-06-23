<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AuraSMS - Manage Courses</title>
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

    <main class="container-fluid px-5 py-4">
        
        <!-- HEADER -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="fw-bold mb-1" style="font-family: 'Outfit';">Manage Courses</h2>
                <p class="text-muted">Setup course parameters and assign module instructors.</p>
            </div>
            <a href="${pageContext.request.contextPath}/admin/courses?action=new" class="btn btn-primary" style="background: linear-gradient(135deg, #6366f1 0%, #a855f7 100%); border: none; border-radius: 10px; font-weight: 600; padding: 10px 20px;">
                <i class="bi bi-plus-circle-fill"></i> Add Course
            </a>
        </div>

        <!-- NOTIFICATION ALERTS -->
        <c:if test="${param.msg == 'success'}">
            <div class="alert alert-success alert-dismissible fade show" role="alert" style="border-radius: 12px;">
                <i class="bi bi-check-circle-fill"></i> Course configurations saved successfully.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        <c:if test="${param.msg == 'deleted'}">
            <div class="alert alert-warning alert-dismissible fade show" role="alert" style="border-radius: 12px;">
                <i class="bi bi-trash-fill"></i> Course record deleted successfully.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <!-- COURSES TABLE -->
        <div class="glass-card">
            <div class="table-responsive">
                <table class="table custom-table table-hover">
                    <thead>
                        <tr>
                            <th>Code</th>
                            <th>Course Name</th>
                            <th>Department</th>
                            <th>Credits</th>
                            <th>Assigned Faculty</th>
                            <th class="text-end">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty courses}">
                                <tr>
                                    <td colspan="6" class="text-center py-4 text-muted">
                                        No academic modules registered in system.
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="course" items="${courses}">
                                    <tr>
                                        <td class="fw-bold text-gradient">${course.code}</td>
                                        <td class="text-white fw-semibold">${course.name}</td>
                                        <td><span class="badge bg-dark border border-secondary">${course.department}</span></td>
                                        <td>${course.credits} Credits</td>
                                        <td class="text-white-50">
                                            <c:choose>
                                                <c:when test="${not empty course.teacherName}">
                                                    <i class="bi bi-person-badge-fill text-primary"></i> ${course.teacherName}
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-danger small"><i class="bi bi-x-circle"></i> Unassigned</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-end">
                                            <a href="${pageContext.request.contextPath}/admin/courses?action=enroll&id=${course.id}" class="btn btn-sm btn-outline-primary me-2">
                                                <i class="bi bi-person-plus-fill"></i> Enroll Students
                                            </a>
                                            <a href="${pageContext.request.contextPath}/admin/courses?action=edit&id=${course.id}" class="btn btn-sm btn-outline-light me-2">
                                                <i class="bi bi-pencil-fill text-warning"></i> Edit
                                            </a>
                                            <a href="${pageContext.request.contextPath}/admin/courses?action=delete&id=${course.id}" class="btn btn-sm btn-outline-light" onclick="return confirm('Are you sure you want to delete this course? All student enrollments, marks, and attendance for this course will be permanently deleted.');">
                                                <i class="bi bi-trash-fill text-danger"></i> Delete
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
