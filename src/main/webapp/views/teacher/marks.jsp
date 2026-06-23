<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AuraSMS - Grade Marks</title>
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
        .form-select, .form-control {
            background-color: rgba(255, 255, 255, 0.04);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 10px;
            color: #f8fafc;
            padding: 10px 14px;
        }
        .form-select:focus, .form-control:focus {
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
        .btn-submit {
            background: linear-gradient(135deg, #6366f1 0%, #a855f7 100%);
            border: none;
            border-radius: 12px;
            font-weight: 600;
            padding: 12px;
            transition: all 0.2s;
        }
        .btn-submit:hover {
            opacity: 0.9;
            transform: translateY(-1px);
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
        <div class="mb-4">
            <h2 class="fw-bold mb-1" style="font-family: 'Outfit';">Record Student Marks</h2>
            <p class="text-muted">Select course and exam category type, then assign marks.</p>
        </div>

        <!-- NOTIFICATION ALERTS -->
        <c:if test="${param.msg == 'success'}">
            <div class="alert alert-success alert-dismissible fade show" role="alert" style="border-radius: 12px;">
                <i class="bi bi-check-circle-fill"></i> Marks saved successfully.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        <c:if test="${param.msg == 'error'}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert" style="border-radius: 12px;">
                <i class="bi bi-exclamation-triangle-fill"></i> Failed to submit student marks. Check parameters.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <div class="row g-4">
            
            <!-- COURSE SELECTION FILTER -->
            <div class="col-md-12">
                <div class="glass-card">
                    <form action="${pageContext.request.contextPath}/teacher/marks" method="GET" class="row g-3">
                        <div class="col-md-5">
                            <label for="courseId" class="text-muted small fw-semibold d-block mb-2">Assigned Academic Course</label>
                            <select class="form-select border-secondary" id="courseId" name="courseId" required>
                                <option value="">-- Select Course --</option>
                                <c:forEach var="crs" items="${assignedCourses}">
                                    <option value="${crs.id}" <c:if test="${param.courseId == crs.id}">selected</c:if>>
                                        ${crs.code} - ${crs.name}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-5">
                            <label for="examType" class="text-muted small fw-semibold d-block mb-2">Exam Category Type</label>
                            <select class="form-select border-secondary" id="examType" name="examType" required>
                                <option value="Internal" <c:if test="${selectedExamType == 'Internal'}">selected</c:if>>Internal Assessment</option>
                                <option value="Midterm" <c:if test="${selectedExamType == 'Midterm'}">selected</c:if>>Midterm Exam</option>
                                <option value="Final" <c:if test="${selectedExamType == 'Final'}">selected</c:if>>Final Semester Exam</option>
                            </select>
                        </div>
                        <div class="col-md-2 d-flex align-items-end">
                            <button type="submit" class="btn btn-primary w-100 py-2 fw-semibold" style="background: linear-gradient(135deg, #6366f1 0%, #a855f7 100%); border: none; border-radius: 10px;">
                                Load Grade sheet
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- ROLL CALL TABLE -->
            <c:if test="${not empty selectedCourse}">
                <div class="col-md-12">
                    <div class="glass-card">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h4 class="fw-bold" style="font-family: 'Outfit';">Gradebook: ${selectedCourse.code}</h4>
                            <span class="text-muted"><i class="bi bi-bookmark-fill text-primary"></i> Category: ${selectedExamType}</span>
                        </div>
                        
                        <form action="${pageContext.request.contextPath}/teacher/marks" method="POST" class="needs-validation" novalidate>
                            <input type="hidden" name="courseId" value="${selectedCourse.id}">
                            <input type="hidden" name="examType" value="${selectedExamType}">

                            <div class="table-responsive mb-4">
                                <table class="table custom-table table-hover">
                                    <thead>
                                        <tr>
                                            <th>Roll Number</th>
                                            <th>Student Name</th>
                                            <th>Department</th>
                                            <th class="text-center" style="width: 220px;">Marks Obtained</th>
                                            <th class="text-center" style="width: 220px;">Maximum Marks</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${empty enrolledStudents}">
                                                <tr>
                                                    <td colspan="5" class="text-center py-4 text-muted">
                                                        No students are currently enrolled in this course module.
                                                    </td>
                                                </tr>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="std" items="${enrolledStudents}">
                                                    <tr>
                                                        <td class="fw-bold text-white">${std.rollNumber}</td>
                                                        <td>${std.name}</td>
                                                        <td><span class="badge bg-dark border border-secondary">${std.department}</span></td>
                                                        <td>
                                                            <input type="number" step="0.01" class="form-control border-secondary text-center" 
                                                                   name="obtained_${std.id}" id="obt_${std.id}" min="0" max="100" 
                                                                   value="${marksMap[std.id]}" placeholder="Obtained Score" required>
                                                            <div class="invalid-feedback text-center">Enter a valid score.</div>
                                                        </td>
                                                        <td>
                                                            <input type="number" step="0.01" class="form-control border-secondary text-center" 
                                                                   name="max_${std.id}" id="max_${std.id}" min="1" max="100" 
                                                                   value="${maxMarksMap[std.id] != null ? maxMarksMap[std.id] : 100}" placeholder="Max Score" required>
                                                            <div class="invalid-feedback text-center">Max score must be &ge; 1.</div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>

                            <c:if test="${not empty enrolledStudents}">
                                <button type="submit" class="btn btn-primary btn-submit w-100 fw-bold">
                                    <i class="bi bi-cloud-arrow-up-fill"></i> Save Evaluation Grades
                                </button>
                            </c:if>
                        </form>
                    </div>
                </div>
            </c:if>

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
                    
                    // Business check: obtained marks cannot exceed max marks
                    let hasErrors = false;
                    const maxInputs = document.querySelectorAll('input[name^="max_"]');
                    maxInputs.forEach(maxInp => {
                        const stdId = maxInp.id.split('_')[1];
                        const obtInp = document.getElementById('obtained_' + stdId) || document.getElementById('obt_' + stdId);
                        if (obtInp && parseFloat(obtInp.value) > parseFloat(maxInp.value)) {
                            obtInp.setCustomValidity('Obtained marks cannot exceed max marks');
                            form.classList.add('was-validated');
                            hasErrors = true;
                        } else if (obtInp) {
                            obtInp.setCustomValidity('');
                        }
                    });

                    if (hasErrors) {
                        event.preventDefault();
                        event.stopPropagation();
                    }
                    
                    form.classList.add('was-validated');
                }, false)
            })
        })()
    </script>
</body>
</html>
