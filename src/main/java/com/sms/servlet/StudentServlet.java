package com.sms.servlet;

import com.sms.dao.StudentDAO;
import com.sms.dao.UserDAO;
import com.sms.model.Student;
import com.sms.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

/**
 * Controller to handle Admin CRUD operations for Students.
 */
@WebServlet("/admin/students")
public class StudentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private StudentDAO studentDAO;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        studentDAO = new StudentDAO();
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
                deleteStudent(request, response);
                break;
            case "list":
            default:
                listStudents(request, response);
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
        String rollNumber = request.getParameter("rollNumber");
        String department = request.getParameter("department");
        String yearStr = request.getParameter("year");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        int year = Integer.parseInt(yearStr);

        // Validation: check unique email
        int studentId = (idStr == null || idStr.isEmpty()) ? 0 : Integer.parseInt(idStr);
        Student existingStudent = null;
        int existingUserId = 0;
        
        if (studentId > 0) {
            existingStudent = studentDAO.getStudentById(studentId);
            if (existingStudent != null) {
                existingUserId = existingStudent.getUserId();
            }
        }

        if (userDAO.isEmailExists(email, existingUserId)) {
            request.setAttribute("error", "Email address already registered in system.");
            // Send back to correct form
            if (studentId > 0) {
                request.setAttribute("student", existingStudent);
                request.getRequestDispatcher("/views/admin/student-form.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/views/admin/student-form.jsp").forward(request, response);
            }
            return;
        }

        Student student = new Student();
        student.setRollNumber(rollNumber);
        student.setDepartment(department);
        student.setYear(year);
        student.setPhone(phone);
        student.setAddress(address);

        User user = new User();
        user.setName(name);
        user.setEmail(email);
        user.setPasswordHash(password);

        boolean success;
        if (studentId > 0) {
            // Edit Student
            student.setId(studentId);
            student.setUserId(existingUserId);
            success = studentDAO.updateStudent(student, user);
        } else {
            // Create Student
            success = studentDAO.saveStudent(student, user);
        }

        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin/students?msg=success");
        } else {
            request.setAttribute("error", "Failed to save student record to database.");
            request.getRequestDispatcher("/views/admin/student-form.jsp").forward(request, response);
        }
    }

    private void listStudents(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int page = 1;
        int size = 10;
        
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            page = Integer.parseInt(pageStr);
        }

        String search = request.getParameter("search");
        String department = request.getParameter("department");
        String yearStr = request.getParameter("year");
        Integer year = null;
        
        if (yearStr != null && !yearStr.isEmpty() && !"All".equals(yearStr)) {
            year = Integer.parseInt(yearStr);
        }

        List<Student> students = studentDAO.getStudentsPaginated(page, size, search, department, year);
        int totalRecords = studentDAO.getStudentCountFiltered(search, department, year);
        int totalPages = (int) Math.ceil((double) totalRecords / size);
        if (totalPages == 0) totalPages = 1;

        request.setAttribute("students", students);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("search", search);
        request.setAttribute("selectedDept", department);
        request.setAttribute("selectedYear", yearStr);
        request.setAttribute("msg", request.getParameter("msg"));

        request.getRequestDispatcher("/views/admin/students.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/admin/student-form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Student student = studentDAO.getStudentById(id);
        if (student != null) {
            request.setAttribute("student", student);
            request.getRequestDispatcher("/views/admin/student-form.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/students?msg=notfound");
        }
    }

    private void deleteStudent(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        if (studentDAO.deleteStudent(id)) {
            response.sendRedirect(request.getContextPath() + "/admin/students?msg=deleted");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/students?msg=deleteerror");
        }
    }
}
