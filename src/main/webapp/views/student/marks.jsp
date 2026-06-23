<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AuraSMS - My Grades</title>
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
        .text-teal {
            color: #14b8a6;
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
        
        <!-- CUMULATIVE GPA CARD -->
        <div class="glass-card d-flex align-items-center justify-content-between">
            <div>
                <h2 class="fw-bold mb-1" style="font-family: 'Outfit';">My Evaluation Report Card</h2>
                <p class="text-muted mb-0">Overview of academic scores and marks breakdown.</p>
            </div>
            <div class="text-end">
                <span class="text-muted small fw-semibold d-block mb-1">CUMULATIVE GPA</span>
                <h1 class="fw-bold text-gradient m-0" style="font-family: 'Outfit';">${overallGpa} / 10.0</h1>
            </div>
        </div>

        <div class="row g-4">
            
            <!-- COURSE WISE GPAS -->
            <div class="col-md-5">
                <div class="glass-card h-100">
                    <h5 class="fw-bold mb-4" style="font-family: 'Outfit';">Subject GPA Metrics</h5>
                    <div class="table-responsive">
                        <table class="table custom-table">
                            <thead>
                                <tr>
                                    <th>Code</th>
                                    <th>Course Name</th>
                                    <th class="text-end">GPA</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty enrolledCourses}">
                                        <tr>
                                            <td colspan="3" class="text-center py-4 text-muted">
                                                No enrolled courses found.
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="course" items="${enrolledCourses}">
                                            <tr>
                                                <td class="fw-bold text-gradient">${course.code}</td>
                                                <td class="text-white">${course.name}</td>
                                                <td class="text-end fw-bold text-teal">${courseGpaMap[course.id]} / 10.0</td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- DETAILED INDIVIDUAL EXAM SCORES -->
            <div class="col-md-7">
                <div class="glass-card h-100">
                    <h5 class="fw-bold mb-4" style="font-family: 'Outfit';">Detailed Exam Scores</h5>
                    <div class="table-responsive">
                        <table class="table custom-table table-hover">
                            <thead>
                                <tr>
                                    <th>Course</th>
                                    <th>Exam Category</th>
                                    <th class="text-center">Marks Obtained</th>
                                    <th class="text-center">Maximum Marks</th>
                                    <th class="text-end">GPA</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty marksList}">
                                        <tr>
                                            <td colspan="5" class="text-center py-4 text-muted">
                                                No evaluated grades recorded yet.
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="m" items="${marksList}">
                                            <tr>
                                                <td>
                                                    <div class="fw-bold text-gradient">${m.courseCode}</div>
                                                    <small class="text-muted">${m.courseName}</small>
                                                </td>
                                                <td class="text-white fw-semibold">${m.examType}</td>
                                                <td class="text-center text-white">${m.marksObtained}</td>
                                                <td class="text-center text-white-50">${m.maxMarks}</td>
                                                <td class="text-end fw-semibold text-teal">${m.gpa}</td>
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
</body>
</html>
