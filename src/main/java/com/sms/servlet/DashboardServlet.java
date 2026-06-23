package com.sms.servlet;

import com.sms.dao.*;
import com.sms.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

/**
 * Controller to route users to their appropriate dashboards and load stats.
 */
@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private StudentDAO studentDAO;
    private TeacherDAO teacherDAO;
    private CourseDAO courseDAO;
    private FeeDAO feeDAO;

    @Override
    public void init() throws ServletException {
        studentDAO = new StudentDAO();
        teacherDAO = new TeacherDAO();
        courseDAO = new CourseDAO();
        feeDAO = new FeeDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User loggedInUser = (User) session.getAttribute("user");
        String role = loggedInUser.getRole();

        if ("ADMIN".equals(role)) {
            // Load metrics for admin dashboard
            int studentCount = studentDAO.getStudentCountFiltered(null, null, null);
            int teacherCount = teacherDAO.getAllTeachers().size();
            int courseCount = courseDAO.getAllCourses().size();
            double unpaidFees = feeDAO.getTotalUnpaidFees();

            request.setAttribute("studentCount", studentCount);
            request.setAttribute("teacherCount", teacherCount);
            request.setAttribute("courseCount", courseCount);
            request.setAttribute("unpaidFees", unpaidFees);

            request.getRequestDispatcher("/views/admin/dashboard.jsp").forward(request, response);
            
        } else if ("TEACHER".equals(role)) {
            // Load assigned courses for teacher
            Teacher teacher = teacherDAO.getTeacherByUserId(loggedInUser.getId());
            if (teacher != null) {
                List<Course> assignedCourses = courseDAO.getCoursesByTeacher(loggedInUser.getId());
                request.setAttribute("teacher", teacher);
                request.setAttribute("assignedCourses", assignedCourses);
            }
            request.getRequestDispatcher("/views/teacher/dashboard.jsp").forward(request, response);
            
        } else if ("STUDENT".equals(role)) {
            // Load profile and enrolled courses for student
            Student student = studentDAO.getStudentByUserId(loggedInUser.getId());
            if (student != null) {
                List<Course> enrolledCourses = courseDAO.getCoursesForStudent(student.getId());
                request.setAttribute("student", student);
                request.setAttribute("enrolledCourses", enrolledCourses);
            }
            request.getRequestDispatcher("/views/student/dashboard.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/login");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
