<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AuraSMS - GPA Reports</title>
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
        .text-teal {
            color: #14b8a6;
        }
    </style>
</head>
<body>

    <!-- NAVBAR INCLUDE -->
    <jsp:include page="../common/navbar.jsp" />

    <main class="container-fluid px-5 py-4">
        
        <!-- HEADER -->
        <div class="mb-4">
            <h2 class="fw-bold mb-1" style="font-family: 'Outfit';">Gradebook Evaluation Reports</h2>
            <p class="text-muted">Analyze student GPA profiles for specific course modules.</p>
        </div>

        <!-- FILTERS PANEL -->
        <div class="glass-card mb-4">
            <form action="${pageContext.request.contextPath}/admin/marks" method="GET" class="row g-3">
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
                        Fetch Report
                    </button>
                </div>
            </form>
        </div>

        <!-- REPORT LIST -->
        <c:if test="${not empty marksReports}">
            <div class="glass-card">
                <h5 class="fw-bold mb-4" style="font-family: 'Outfit';">Academic performance sheet</h5>
                <div class="table-responsive">
                    <table class="table custom-table table-hover">
                        <thead>
                            <tr>
                                <th>Student Name</th>
                                <th>Roll Number</th>
                                <th class="text-center">Internal Score</th>
                                <th class="text-center">Midterm Exam</th>
                                <th class="text-center">Final Exam</th>
                                <th class="text-center">Cumulative Sum</th>
                                <th class="text-end">Course GPA</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="rec" items="${marksReports}">
                                <tr>
                                    <td class="text-white fw-semibold">${rec.studentName}</td>
                                    <td class="fw-bold text-gradient">${rec.rollNumber}</td>
                                    
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${not empty rec.internalMarks}">
                                                <span class="text-white">${rec.internalMarks}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted small">-</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${not empty rec.midtermMarks}">
                                                <span class="text-white">${rec.midtermMarks}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted small">-</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    
                                    <td class="text-center">
                                        <c:choose>
                                            <c:when test="${not empty rec.finalMarks}">
                                                <span class="text-white">${rec.finalMarks}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted small">-</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td class="text-center text-white-50 small">
                                        ${rec.totalObtained} / ${rec.totalMax}
                                    </td>
                                    
                                    <!-- Course GPA -->
                                    <td class="text-end fw-bold fs-5 text-teal">
                                        ${rec.gpa} / 10.0
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </c:if>

        <c:if test="${empty marksReports && not empty selectedCourseId}">
            <div class="glass-card py-5 text-center text-muted">
                <i class="bi bi-file-earmark-x fs-1 d-block mb-3"></i>
                No marks evaluations recorded for this course module yet.
            </div>
        </c:if>

    </main>

    <!-- Bootstrap 5 Bundle JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
