package com.sms.filter;

import com.sms.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Filter to block unauthorized access to views and handle role-based routing.
 */
@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
            
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        String uri = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        
        // Extract relative path from context root
        String path = uri.substring(contextPath.length());

        // Allow static assets, welcome login paths without verification
        boolean isStaticResource = path.startsWith("/assets/") || path.startsWith("/favicon.ico");
        boolean isLoginResource = path.equals("/login") || path.equals("/views/common/login.jsp");
        boolean isErrorPage = path.equals("/views/common/error.jsp");

        if (isStaticResource || isLoginResource || isErrorPage) {
            chain.doFilter(request, response);
            return;
        }

        // Verify if session exists and user object is bound
        User loggedInUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (loggedInUser == null) {
            // User not logged in, redirect to login servlet
            httpResponse.sendRedirect(contextPath + "/login");
            return;
        }

        // Role-based authorization rules
        String role = loggedInUser.getRole();
        boolean isAuthorized = true;

        if (path.startsWith("/admin") || path.startsWith("/views/admin/")) {
            if (!"ADMIN".equals(role)) {
                isAuthorized = false;
            }
        } else if (path.startsWith("/teacher") || path.startsWith("/views/teacher/")) {
            if (!"TEACHER".equals(role)) {
                isAuthorized = false;
            }
        } else if (path.startsWith("/student") || path.startsWith("/views/student/")) {
            if (!"STUDENT".equals(role)) {
                isAuthorized = false;
            }
        }

        if (!isAuthorized) {
            // Access denied: forward to JSTL-based error page
            httpRequest.setAttribute("errorMessage", "Access Denied: You do not have permissions to view this resource.");
            httpRequest.getRequestDispatcher("/views/common/error.jsp").forward(httpRequest, httpResponse);
        } else {
            chain.doFilter(request, response);
        }
    }

    @Override
    public void destroy() {
        // Cleanup if needed
    }
}
