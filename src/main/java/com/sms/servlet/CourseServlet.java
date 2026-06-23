package com.sms.servlet;

import com.sms.dao.CourseDAO;
import com.sms.dao.StudentDAO;
import com.sms.dao.TeacherDAO;
import com.sms.model.Course;
import com.sms.model.Student;
import com.sms.model.Teacher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

/**
 * Controller to handle Admin Course setups and Course Enrollments.
 */
@WebServlet("/admin/courses")
public class CourseServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CourseDAO courseDAO;
    private TeacherDAO teacherDAO;
    private StudentDAO studentDAO;

    @Override
    public void init() throws ServletException {
        courseDAO = new CourseDAO();
        teacherDAO = new TeacherDAO();
        studentDAO = new StudentDAO();
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
                deleteCourse(request, response);
                break;
            case "enroll":
                showEnrollForm(request, response);
                break;
            case "unenroll":
                unenrollStudent(request, response);
                break;
            case "list":
            default:
                listCourses(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("enroll".equals(action)) {
            enrollStudent(request, response);
        } else {
            saveOrUpdateCourse(request, response);
        }
    }

    private void listCourses(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Course> courses = courseDAO.getAllCourses();
        request.setAttribute("courses", courses);
        request.setAttribute("msg", request.getParameter("msg"));
        request.getRequestDispatcher("/views/admin/courses.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Teacher> teachers = teacherDAO.getAllTeachers();
        request.setAttribute("teachers", teachers);
        request.getRequestDispatcher("/views/admin/course-form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Course course = courseDAO.getCourseById(id);
        if (course != null) {
            List<Teacher> teachers = teacherDAO.getAllTeachers();
            request.setAttribute("course", course);
            request.setAttribute("teachers", teachers);
            request.getRequestDispatcher("/views/admin/course-form.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/courses?msg=notfound");
        }
    }

    private void deleteCourse(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        if (courseDAO.deleteCourse(id)) {
            response.sendRedirect(request.getContextPath() + "/admin/courses?msg=deleted");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/courses?msg=deleteerror");
        }
    }

    private void showEnrollForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int courseId = Integer.parseInt(request.getParameter("id"));
        Course course = courseDAO.getCourseById(courseId);
        if (course != null) {
            List<Student> enrolledStudents = courseDAO.getEnrolledStudentsForCourse(courseId);
            List<Student> allStudents = studentDAO.getAllStudents();
            
            request.setAttribute("course", course);
            request.setAttribute("enrolledStudents", enrolledStudents);
            request.setAttribute("allStudents", allStudents);
            request.setAttribute("msg", request.getParameter("msg"));
            
            request.getRequestDispatcher("/views/admin/enroll.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/courses?msg=notfound");
        }
    }

    private void enrollStudent(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int courseId = Integer.parseInt(request.getParameter("courseId"));
        int studentId = Integer.parseInt(request.getParameter("studentId"));
        
        if (courseDAO.enrollStudent(studentId, courseId)) {
            response.sendRedirect(request.getContextPath() + "/admin/courses?action=enroll&id=" + courseId + "&msg=enrolled");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/courses?action=enroll&id=" + courseId + "&msg=enrollerror");
        }
    }

    private void unenrollStudent(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int courseId = Integer.parseInt(request.getParameter("courseId"));
        int studentId = Integer.parseInt(request.getParameter("studentId"));
        
        if (courseDAO.unenrollStudent(studentId, courseId)) {
            response.sendRedirect(request.getContextPath() + "/admin/courses?action=enroll&id=" + courseId + "&msg=unenrolled");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/courses?action=enroll&id=" + courseId + "&msg=unenrollerror");
        }
    }

    private void saveOrUpdateCourse(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idStr = request.getParameter("id");
        String name = request.getParameter("name");
        String code = request.getParameter("code");
        String department = request.getParameter("department");
        int credits = Integer.parseInt(request.getParameter("credits"));
        String teacherIdStr = request.getParameter("teacherId");
        
        Integer teacherId = null;
        if (teacherIdStr != null && !teacherIdStr.isEmpty() && !"None".equals(teacherIdStr)) {
            teacherId = Integer.parseInt(teacherIdStr);
        }

        int courseId = (idStr == null || idStr.isEmpty()) ? 0 : Integer.parseInt(idStr);

        // Validate unique code
        Course existingCourse = courseDAO.getCourseByCode(code);
        if (existingCourse != null && existingCourse.getId() != courseId) {
            request.setAttribute("error", "Course code '" + code + "' is already registered in system.");
            List<Teacher> teachers = teacherDAO.getAllTeachers();
            request.setAttribute("teachers", teachers);
            if (courseId > 0) {
                Course course = courseDAO.getCourseById(courseId);
                request.setAttribute("course", course);
            }
            request.getRequestDispatcher("/views/admin/course-form.jsp").forward(request, response);
            return;
        }

        Course course = new Course();
        course.setName(name);
        course.setCode(code);
        course.setDepartment(department);
        course.setCredits(credits);
        course.setTeacherId(teacherId);

        boolean success;
        if (courseId > 0) {
            course.setId(courseId);
            success = courseDAO.updateCourse(course);
        } else {
            success = courseDAO.saveCourse(course);
        }

        if (success) {
            response.sendRedirect(request.getContextPath() + "/admin/courses?msg=success");
        } else {
            request.setAttribute("error", "Failed to save course details to database.");
            List<Teacher> teachers = teacherDAO.getAllTeachers();
            request.setAttribute("teachers", teachers);
            request.getRequestDispatcher("/views/admin/course-form.jsp").forward(request, response);
        }
    }
}
