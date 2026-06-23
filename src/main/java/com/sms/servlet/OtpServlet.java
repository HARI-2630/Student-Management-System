package com.sms.servlet;

import com.sms.model.User;
import com.sms.util.EmailUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.security.SecureRandom;

/**
 * Controller to handle verification of email OTP code.
 */
@WebServlet("/login-otp")
public class OtpServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("pendingOtpUser") == null) {
            // No pending authentication, redirect to login
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if ("resend".equalsIgnoreCase(action)) {
            User pendingUser = (User) session.getAttribute("pendingOtpUser");
            
            // Generate a new secure 6-digit OTP
            SecureRandom rand = new SecureRandom();
            String newOtp = String.format("%06d", rand.nextInt(1000000));
            
            // Update session values
            session.setAttribute("otpCode", newOtp);
            session.setAttribute("otpExpiry", System.currentTimeMillis() + (5 * 60 * 1000)); // 5 minutes
            
            // Send email asynchronously
            EmailUtil.sendOtpEmailAsync(pendingUser.getEmail(), newOtp);
            
            request.setAttribute("success", "A new verification code has been sent to your email.");
        }

        request.getRequestDispatcher("/views/common/otp.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("pendingOtpUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User pendingUser = (User) session.getAttribute("pendingOtpUser");
        String correctOtp = (String) session.getAttribute("otpCode");
        Long expiry = (Long) session.getAttribute("otpExpiry");

        String enteredOtp = request.getParameter("otpCode");

        if (enteredOtp == null || enteredOtp.trim().isEmpty()) {
            request.setAttribute("error", "Please enter the verification code.");
            request.getRequestDispatcher("/views/common/otp.jsp").forward(request, response);
            return;
        }

        // Check if OTP is expired
        if (expiry == null || System.currentTimeMillis() > expiry) {
            request.setAttribute("error", "The verification code has expired. Please request a new one.");
            request.getRequestDispatcher("/views/common/otp.jsp").forward(request, response);
            return;
        }

        // Compare OTP
        if (enteredOtp.trim().equals(correctOtp)) {
            // Successful validation, bind user to active session
            session.setAttribute("user", pendingUser);
            
            // Clean up temporary OTP session attributes
            session.removeAttribute("pendingOtpUser");
            session.removeAttribute("otpCode");
            session.removeAttribute("otpExpiry");

            response.sendRedirect(request.getContextPath() + "/dashboard");
        } else {
            // Invalid OTP
            request.setAttribute("error", "Invalid verification code. Please check your mail and try again.");
            request.getRequestDispatcher("/views/common/otp.jsp").forward(request, response);
        }
    }
}
