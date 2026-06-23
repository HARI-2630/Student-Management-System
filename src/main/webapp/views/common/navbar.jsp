<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<header class="mb-4">
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark border-bottom border-secondary py-3">
        <div class="container-fluid px-4">
            <a class="navbar-brand fw-bold text-gradient fs-4 d-flex align-items-center gap-2" href="${pageContext.request.contextPath}/dashboard">
                <i class="bi bi-mortarboard-fill text-primary"></i>
                <span style="font-family: 'Outfit', sans-serif;">AuraSMS</span>
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarText" aria-controls="navbarText" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarText">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                    <!-- Navigation based on logged-in User Role -->
                    <c:choose>
                        <c:when test="${sessionScope.user.role == 'ADMIN'}">
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/dashboard"><i class="bi bi-grid-1x2-fill"></i> Dashboard</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/admin/students"><i class="bi bi-people-fill"></i> Students</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/admin/teachers"><i class="bi bi-person-badge-fill"></i> Teachers</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/admin/courses"><i class="bi bi-book-fill"></i> Courses</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/admin/attendance"><i class="bi bi-calendar-check-fill"></i> Attendance</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/admin/marks"><i class="bi bi-graph-up-arrow"></i> Marks</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/admin/fees"><i class="bi bi-credit-card-fill"></i> Fees</a>
                            </li>
                        </c:when>
                        
                        <c:when test="${sessionScope.user.role == 'TEACHER'}">
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/dashboard"><i class="bi bi-grid-1x2-fill"></i> Dashboard</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/teacher/attendance"><i class="bi bi-calendar-check-fill"></i> Record Attendance</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/teacher/marks"><i class="bi bi-input-cursor-text"></i> Grade Marks</a>
                            </li>
                        </c:when>
                        
                        <c:when test="${sessionScope.user.role == 'STUDENT'}">
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/dashboard"><i class="bi bi-grid-1x2-fill"></i> Profile Dashboard</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/student/attendance"><i class="bi bi-calendar-check-fill"></i> Attendance</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/student/marks"><i class="bi bi-bookmark-star-fill"></i> Course Marks</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/student/fees"><i class="bi bi-credit-card-fill"></i> Invoices</a>
                            </li>
                        </c:when>
                    </c:choose>
                </ul>
                <div class="d-flex align-items-center gap-3">
                    <span class="navbar-text text-white-50 small">
                        <i class="bi bi-person-fill text-primary"></i> ${sessionScope.user.name} (${sessionScope.user.role})
                    </span>
                    <a class="btn btn-outline-danger btn-sm px-3 rounded-pill" href="${pageContext.request.contextPath}/logout">
                        <i class="bi bi-box-arrow-right"></i> Logout
                    </a>
                </div>
            </div>
        </div>
    </nav>
</header>
