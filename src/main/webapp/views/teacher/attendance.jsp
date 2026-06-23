<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AuraSMS - Record Attendance</title>
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
    </style>
</head>
<body>

    <!-- NAVBAR INCLUDE -->
    <jsp:include page="../common/navbar.jsp" />

    <main class="container-fluid px-5 py-4">
        
        <!-- HEADER -->
        <div class="mb-4">
            <h2 class="fw-bold mb-1" style="font-family: 'Outfit';">Class Attendance Registry</h2>
            <p class="text-muted">Select an assigned course and date, then mark student attendance status.</p>
        </div>

        <!-- NOTIFICATION ALERTS -->
        <c:if test="${param.msg == 'success'}">
            <div class="alert alert-success alert-dismissible fade show" role="alert" style="border-radius: 12px;">
                <i class="bi bi-check-circle-fill"></i> Attendance logs saved successfully.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        <c:if test="${param.msg == 'error'}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert" style="border-radius: 12px;">
                <i class="bi bi-exclamation-triangle-fill"></i> Failed to submit class attendance. Check log details.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <div class="row g-4">
            
            <!-- COURSE SELECTION FILTER -->
            <div class="col-md-12">
                <div class="glass-card">
                    <form action="${pageContext.request.contextPath}/teacher/attendance" method="GET" class="row g-3">
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
                            <label for="date" class="text-muted small fw-semibold d-block mb-2">Log Date</label>
                            <input type="date" class="form-control border-secondary" id="date" name="date" value="${selectedDate}" required>
                        </div>
                        <div class="col-md-2 d-flex align-items-end">
                            <button type="submit" class="btn btn-primary w-100 py-2 fw-semibold" style="background: linear-gradient(135deg, #6366f1 0%, #a855f7 100%); border: none; border-radius: 10px;">
                                Load Roll Call
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
                            <h4 class="fw-bold" style="font-family: 'Outfit';">Roll Call: ${selectedCourse.code}</h4>
                            <span class="text-muted"><i class="bi bi-calendar3"></i> Date: ${selectedDate}</span>
                        </div>
                        
                        <form action="${pageContext.request.contextPath}/teacher/attendance" method="POST">
                            <input type="hidden" name="courseId" value="${selectedCourse.id}">
                            <input type="hidden" name="date" value="${selectedDate}">

                            <div class="table-responsive mb-4">
                                <table class="table custom-table table-hover">
                                    <thead>
                                        <tr>
                                            <th>Roll Number</th>
                                            <th>Student Name</th>
                                            <th>Department</th>
                                            <th class="text-center" style="width: 350px;">Status Registry</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${empty enrolledStudents}">
                                                <tr>
                                                    <td colspan="4" class="text-center py-4 text-muted">
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
                                                        <td class="text-center">
                                                            <div class="d-flex justify-content-around">
                                                                <div class="form-check form-check-inline">
                                                                    <input class="form-check-input" type="radio" name="status_${std.id}" id="p_${std.id}" value="PRESENT" 
                                                                           <c:if test="${attendanceMap[std.id] == 'PRESENT' || empty attendanceMap[std.id]}">checked</c:if>>
                                                                    <label class="form-check-label text-success" for="p_${std.id}">Present</label>
                                                                </div>
                                                                <div class="form-check form-check-inline">
                                                                    <input class="form-check-input" type="radio" name="status_${std.id}" id="a_${std.id}" value="ABSENT" 
                                                                           <c:if test="${attendanceMap[std.id] == 'ABSENT'}">checked</c:if>>
                                                                    <label class="form-check-label text-danger" for="a_${std.id}">Absent</label>
                                                                </div>
                                                                <div class="form-check form-check-inline">
                                                                    <input class="form-check-input" type="radio" name="status_${std.id}" id="l_${std.id}" value="LATE" 
                                                                           <c:if test="${attendanceMap[std.id] == 'LATE'}">checked</c:if>>
                                                                    <label class="form-check-label text-warning" for="l_${std.id}">Late</label>
                                                                </div>
                                                            </div>
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
                                    <i class="bi bi-cloud-arrow-up-fill"></i> Save Attendance Logs
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
</body>
</html>
