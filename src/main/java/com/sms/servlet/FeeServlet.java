package com.sms.servlet;

import com.sms.dao.FeeDAO;
import com.sms.dao.StudentDAO;
import com.sms.model.Fee;
import com.sms.model.Student;
import com.sms.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

/**
 * Controller to handle role-based semester fee collection and invoice queries.
 */
@WebServlet(urlPatterns = {"/admin/fees", "/student/fees"})
public class FeeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private FeeDAO feeDAO;
    private StudentDAO studentDAO;

    @Override
    public void init() throws ServletException {
        feeDAO = new FeeDAO();
        studentDAO = new StudentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User loggedInUser = (User) session.getAttribute("user");
        String role = loggedInUser.getRole();

        if ("ADMIN".equals(role)) {
            handleAdminFees(request, response);
        } else if ("STUDENT".equals(role)) {
            handleStudentFees(request, response, loggedInUser);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User loggedInUser = (User) session.getAttribute("user");
        String role = loggedInUser.getRole();

        if ("ADMIN".equals(role)) {
            handleAdminFeesPost(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    // ADMIN VIEW: View bills ledger and create invoice statements
    private void handleAdminFees(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Fee> fees = feeDAO.getAllFees();
        List<Student> students = studentDAO.getAllStudents();

        request.setAttribute("fees", fees);
        request.setAttribute("students", students);
        request.setAttribute("msg", request.getParameter("msg"));

        request.getRequestDispatcher("/views/admin/fees.jsp").forward(request, response);
    }

    private void handleAdminFeesPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");

        if ("pay".equals(action)) {
            int feeId = Integer.parseInt(request.getParameter("feeId"));
            if (feeDAO.markAsPaid(feeId)) {
                response.sendRedirect(request.getContextPath() + "/admin/fees?msg=paid");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/fees?msg=error");
            }
        } else {
            // Create Invoice
            int studentId = Integer.parseInt(request.getParameter("studentId"));
            int semester = Integer.parseInt(request.getParameter("semester"));
            double amount = Double.parseDouble(request.getParameter("amount"));
            Date dueDate = Date.valueOf(request.getParameter("dueDate"));

            Fee fee = new Fee();
            fee.setStudentId(studentId);
            fee.setSemester(semester);
            fee.setAmount(amount);
            fee.setDueDate(dueDate);

            if (feeDAO.saveFee(fee)) {
                response.sendRedirect(request.getContextPath() + "/admin/fees?msg=success");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/fees?msg=error");
            }
        }
    }

    // STUDENT VIEW: View invoice balances
    private void handleStudentFees(HttpServletRequest request, HttpServletResponse response, User studentUser)
            throws ServletException, IOException {
        
        Student student = studentDAO.getStudentByUserId(studentUser.getId());
        if (student != null) {
            List<Fee> fees = feeDAO.getFeesByStudent(student.getId());
            request.setAttribute("fees", fees);
        }
        request.getRequestDispatcher("/views/student/fees.jsp").forward(request, response);
    }
}
