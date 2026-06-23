package com.sms.servlet;

import com.sms.dao.TeacherDAO;
import com.sms.dao.UserDAO;
import com.sms.model.Teacher;
import com.sms.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

/**
 * Controller to handle Admin CRUD operations for Faculty Teachers.
 */
@WebServlet("/admin/teachers")
public class TeacherServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private TeacherDAO teacherDAO;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        teacherDAO = new TeacherDAO();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "new":
                showNewForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteTeacher(request, response);
                break;
            case "list":
            default:
                listTeachers(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idStr = request.getParameter("id");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String department = request.getParameter("department");
        String qualification = request.getParameter("qualification");

        int teacherId = (idStr == null || idStr.isEmpty()) ? 0 : Integer.parseInt(idStr);
        Teacher existingTeacher = null;
        int existingUserId = 0;

        if (teacherId > 0) {
            existingTeacher = teacherDAO.getTeacherById(teacherId);
            if (existingTeacher != null) {
                existingUserId = existingTeacher.getUserId();
            }
        }

        // Validate unique email
        if (userDAO.isEmailExists(email, existingUserId)) {
            request.setAttribute("error", "Email address already registered in system.");
            if (teacherId > 0) {
                request.setAttribute("teacher", existingTeacher);
            }
            request.getRequestDispatcher("/views/admin/teacher-form.jsp").forward(request, response);
            return;
        }

        Teacher teacher = new Teacher();
        teacher.setDepartment(department);
        teacher.setQualification(qualification);

        User user = new User();
        user.setName(name);
        user.setEmail(email);
        user.setPasswordHash(password);

        boolean success;
        if (teacherId > 0) {
            teacher.setId(teacherId);
            teacher.setUserId(existingUserId);
            success = teacherDAO.updateTeacher(teacher, user);
        } else {
            success = teacherDAO.saveTeacher(teacher, user);
        }

        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin/teachers?msg=success");
        } else {
            request.setAttribute("error", "Failed to save teacher record to database.");
            request.getRequestDispatcher("/views/admin/teacher-form.jsp").forward(request, response);
        }
    }

    private void listTeachers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Teacher> teachers = teacherDAO.getAllTeachers();
        request.setAttribute("teachers", teachers);
        request.setAttribute("msg", request.getParameter("msg"));
        request.getRequestDispatcher("/views/admin/teachers.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/admin/teacher-form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Teacher teacher = teacherDAO.getTeacherById(id);
        if (teacher != null) {
            request.setAttribute("teacher", teacher);
            request.getRequestDispatcher("/views/admin/teacher-form.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/teachers?msg=notfound");
        }
    }

    private void deleteTeacher(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        if (teacherDAO.deleteTeacher(id)) {
            response.sendRedirect(request.getContextPath() + "/admin/teachers?msg=deleted");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/teachers?msg=deleteerror");
        }
    }
}
