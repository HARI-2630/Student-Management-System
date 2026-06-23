package com.sms.servlet;

import com.sms.dao.UserDAO;
import com.sms.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Controller to handle user login verification and session creation.
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            if (session.getAttribute("user") != null) {
                // Already logged in, redirect to dashboard servlet
                response.sendRedirect(request.getContextPath() + "/dashboard");
                return;
            } else if (session.getAttribute("pendingOtpUser") != null) {
                // Pending OTP, redirect to OTP verification page
                response.sendRedirect(request.getContextPath() + "/login-otp");
                return;
            }
        }
        // Forward to the JSP login view
        request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        User user = userDAO.authenticate(email, password);

        if (user != null) {
            // Generate a secure 6-digit OTP
            java.security.SecureRandom rand = new java.security.SecureRandom();
            String otp = String.format("%06d", rand.nextInt(1000000));

            // Setup session and attach pending authentication details
            HttpSession session = request.getSession(true);
            session.setAttribute("pendingOtpUser", user);
            session.setAttribute("otpCode", otp);
            session.setAttribute("otpExpiry", System.currentTimeMillis() + (5 * 60 * 1000)); // 5 minutes
            
            // Send OTP email asynchronously
            com.sms.util.EmailUtil.sendOtpEmailAsync(user.getEmail(), otp);
            
            // Redirect to OTP verification page
            response.sendRedirect(request.getContextPath() + "/login-otp");
        } else {
            // Return back with error status
            request.setAttribute("error", "Invalid email or password.");
            request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
        }
    }
}
