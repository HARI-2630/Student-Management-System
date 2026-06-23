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
        if (session != null && session.getAttribute("user") != null) {
            // Already logged in, redirect to dashboard servlet
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
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
            // Setup session and attach user object
            HttpSession session = request.getSession(true);
            session.setAttribute("user", user);
            
            // Redirect to central dashboard routing
            response.sendRedirect(request.getContextPath() + "/dashboard");
        } else {
            // Return back with error status
            request.setAttribute("error", "Invalid email or password.");
            request.getRequestDispatcher("/views/common/login.jsp").forward(request, response);
        }
    }
}
