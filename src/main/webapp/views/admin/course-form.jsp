<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AuraSMS - Course Form</title>
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
            padding: 40px;
            max-width: 650px;
            margin: 0 auto;
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
    </style>
</head>
<body>

    <!-- NAVBAR INCLUDE -->
    <jsp:include page="../common/navbar.jsp" />

    <main class="container py-4">
        
        <div class="glass-card">
            <div class="mb-4">
                <a href="${pageContext.request.contextPath}/admin/courses" class="btn btn-sm btn-outline-light mb-3">
                    <i class="bi bi-arrow-left"></i> Back to Course List
                </a>
                <h2 class="fw-bold" style="font-family: 'Outfit';">
                    <c:choose>
                        <c:when test="${not empty course}">
                            Edit Course: ${course.code}
                        </c:when>
                        <c:otherwise>
                            Setup New Course
                        </c:otherwise>
                    </c:choose>
                </h2>
                <p class="text-muted">Configure module code, credits, and instructor assignment.</p>
            </div>

            <!-- Error Notifications -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger d-flex align-items-center gap-2" role="alert" style="border-radius: 10px;">
                    <i class="bi bi-exclamation-triangle-fill"></i>
                    <div>${error}</div>
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/admin/courses" method="POST" class="needs-validation" novalidate>
                <input type="hidden" name="id" value="${course.id}">
                
                <div class="row g-3 mb-4">
                    <div class="col-md-8">
                        <label for="name" class="form-label text-muted small fw-semibold">Course Name</label>
                        <input type="text" class="form-control border-secondary" id="name" name="name" value="${course.name}" placeholder="e.g. Introduction to Programming" required>
                        <div class="invalid-feedback">Please enter the course name.</div>
                    </div>
                    
                    <div class="col-md-4">
                        <label for="code" class="form-label text-muted small fw-semibold">Course Code</label>
                        <input type="text" class="form-control border-secondary" id="code" name="code" value="${course.code}" placeholder="e.g. CS-101" required>
                        <div class="invalid-feedback">Please enter a unique course code.</div>
                    </div>

                    <div class="col-md-6">
                        <label for="department" class="form-label text-muted small fw-semibold">Department Branch</label>
                        <select class="form-select border-secondary" id="department" name="department" required>
                            <option value="">-- Choose Branch --</option>
                            <option value="Computer Science" <c:if test="${course.department == 'Computer Science'}">selected</c:if>>Computer Science</option>
                            <option value="Data Science" <c:if test="${course.department == 'Data Science'}">selected</c:if>>Data Science</option>
                            <option value="Electrical Engineering" <c:if test="${course.department == 'Electrical Engineering'}">selected</c:if>>Electrical Engineering</option>
                            <option value="Mechanical Engineering" <c:if test="${course.department == 'Mechanical Engineering'}">selected</c:if>>Mechanical Engineering</option>
                        </select>
                        <div class="invalid-feedback">Please select a department branch.</div>
                    </div>

                    <div class="col-md-6">
                        <label for="credits" class="form-label text-muted small fw-semibold">Course Credits</label>
                        <input type="number" class="form-control border-secondary" id="credits" name="credits" value="${course.credits > 0 ? course.credits : ''}" min="1" max="8" placeholder="e.g. 4" required>
                        <div class="invalid-feedback">Please specify course credits (1 to 8).</div>
                    </div>

                    <div class="col-md-12">
                        <label for="teacherId" class="form-label text-muted small fw-semibold">Assigned Module Instructor</label>
                        <select class="form-select border-secondary" id="teacherId" name="teacherId">
                            <option value="None">-- Unassigned --</option>
                            <c:forEach var="teacher" items="${teachers}">
                                <option value="${teacher.id}" <c:if test="${course.teacherId == teacher.id}">selected</c:if>>
                                    ${teacher.name} (${teacher.department})
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary w-100 py-3 fw-bold" style="background: linear-gradient(135deg, #6366f1 0%, #a855f7 100%); border: none; border-radius: 12px;">
                    <c:choose>
                        <c:when test="${not empty course}">
                            Save Course Details
                        </c:when>
                        <c:otherwise>
                            Complete Registration
                        </c:otherwise>
                    </c:choose>
                </button>
            </form>
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
