<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AuraSMS - Enroll Students</title>
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

    <main class="container py-4">
        
        <!-- HEADER -->
        <div class="mb-4">
            <a href="${pageContext.request.contextPath}/admin/courses" class="btn btn-sm btn-outline-light mb-3">
                <i class="bi bi-arrow-left"></i> Back to Course List
            </a>
            <h2 class="fw-bold" style="font-family: 'Outfit';">Enrollment Management</h2>
            <p class="text-muted">Module: <span class="text-gradient fw-bold">${course.code}</span> - ${course.name}</p>
        </div>

        <!-- NOTIFICATION ALERTS -->
        <c:if test="${param.msg == 'enrolled'}">
            <div class="alert alert-success alert-dismissible fade show" role="alert" style="border-radius: 12px;">
                <i class="bi bi-check-circle-fill"></i> Student enrolled successfully.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        <c:if test="${param.msg == 'unenrolled'}">
            <div class="alert alert-warning alert-dismissible fade show" role="alert" style="border-radius: 12px;">
                <i class="bi bi-trash-fill"></i> Student unenrolled successfully.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <div class="row g-4">
            <!-- ENROLL FORM -->
            <div class="col-md-4">
                <div class="glass-card">
                    <h5 class="fw-bold mb-4" style="font-family: 'Outfit';">Enroll Student</h5>
                    <form action="${pageContext.request.contextPath}/admin/courses" method="POST" class="needs-validation" novalidate>
                        <input type="hidden" name="action" value="enroll">
                        <input type="hidden" name="courseId" value="${course.id}">
                        
                        <div class="mb-4">
                            <label for="studentId" class="form-label text-muted small fw-semibold">Select Student</label>
                            <select class="form-select border-secondary" id="studentId" name="studentId" required>
                                <option value="">-- Choose Student --</option>
                                <c:forEach var="student" items="${allStudents}">
                                    <option value="${student.id}">
                                        ${student.name} (${student.rollNumber})
                                    </option>
                                </c:forEach>
                            </select>
                            <div class="invalid-feedback">Please choose a student to enroll.</div>
                        </div>

                        <button type="submit" class="btn btn-primary w-100 py-2 fw-semibold" style="background: linear-gradient(135deg, #6366f1 0%, #a855f7 100%); border: none; border-radius: 10px;">
                            <i class="bi bi-person-plus-fill"></i> Add to Course
                        </button>
                    </form>
                </div>
            </div>

            <!-- ENROLLED STUDENTS LIST -->
            <div class="col-md-8">
                <div class="glass-card">
                    <h5 class="fw-bold mb-4" style="font-family: 'Outfit';">Enrolled Registry</h5>
                    <div class="table-responsive">
                        <table class="table custom-table table-hover">
                            <thead>
                                <tr>
                                    <th>Roll Number</th>
                                    <th>Name</th>
                                    <th>Department</th>
                                    <th class="text-end">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty enrolledStudents}">
                                        <tr>
                                            <td colspan="4" class="text-center py-4 text-muted">
                                                No students enrolled in this course module yet.
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="student" items="${enrolledStudents}">
                                            <tr>
                                                <td class="fw-bold text-gradient">${student.rollNumber}</td>
                                                <td class="text-white fw-semibold">${student.name}</td>
                                                <td><span class="badge bg-dark border border-secondary">${student.department}</span></td>
                                                <td class="text-end">
                                                    <a href="${pageContext.request.contextPath}/admin/courses?action=unenroll&courseId=${course.id}&studentId=${student.id}" class="btn btn-sm btn-outline-danger" onclick="return confirm('Are you sure you want to unenroll this student? All attendance logs and exam marks for this student under this course will be deleted.');">
                                                        <i class="bi bi-trash-fill"></i> Unenroll
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
            </div>
        </div>

    </main>

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
