package com.sms.servlet;

import com.sms.dao.CourseDAO;
import com.sms.dao.MarksDAO;
import com.sms.dao.StudentDAO;
import com.sms.dao.TeacherDAO;
import com.sms.model.Course;
import com.sms.model.Marks;
import com.sms.model.Student;
import com.sms.model.Teacher;
import com.sms.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Controller to handle entering grades and aggregate GPA reports.
 */
@WebServlet(urlPatterns = {"/admin/marks", "/teacher/marks", "/student/marks"})
public class MarkServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private MarksDAO marksDAO;
    private CourseDAO courseDAO;
    private StudentDAO studentDAO;
    private TeacherDAO teacherDAO;

    @Override
    public void init() throws ServletException {
        marksDAO = new MarksDAO();
        courseDAO = new CourseDAO();
        studentDAO = new StudentDAO();
        teacherDAO = new TeacherDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User loggedInUser = (User) session.getAttribute("user");
        String role = loggedInUser.getRole();
        String servletPath = request.getServletPath();

        if ("ADMIN".equals(role)) {
            handleAdminMarks(request, response);
        } else if ("TEACHER".equals(role)) {
            handleTeacherMarksGet(request, response, loggedInUser);
        } else if ("STUDENT".equals(role)) {
            handleStudentMarks(request, response, loggedInUser);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User loggedInUser = (User) session.getAttribute("user");
        String role = loggedInUser.getRole();

        if ("TEACHER".equals(role)) {
            handleTeacherMarksPost(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    // ADMIN VIEW: View aggregate Marks and Course GPA list
    private void handleAdminMarks(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String courseIdStr = request.getParameter("courseId");
        List<Course> courses = courseDAO.getAllCourses();
        request.setAttribute("courses", courses);

        if (courseIdStr != null && !courseIdStr.isEmpty() && !"All".equals(courseIdStr)) {
            int courseId = Integer.parseInt(courseIdStr);
            List<MarksDAO.CourseMarksReportRecord> reports = marksDAO.getMarksReportByCourse(courseId);
            request.setAttribute("selectedCourseId", courseId);
            request.setAttribute("marksReports", reports);
        }

        request.getRequestDispatcher("/views/admin/marks-report.jsp").forward(request, response);
    }

    // TEACHER VIEW: Select course and exam type to insert grades
    private void handleTeacherMarksGet(HttpServletRequest request, HttpServletResponse response, User teacherUser)
            throws ServletException, IOException {
        
        String courseIdStr = request.getParameter("courseId");
        String examType = request.getParameter("examType");
        if (examType == null || examType.isEmpty()) {
            examType = "Internal";
        }

        List<Course> assignedCourses = courseDAO.getCoursesByTeacher(teacherUser.getId());
        request.setAttribute("assignedCourses", assignedCourses);
        request.setAttribute("selectedExamType", examType);

        if (courseIdStr != null && !courseIdStr.isEmpty()) {
            int courseId = Integer.parseInt(courseIdStr);
            Course course = courseDAO.getCourseById(courseId);
            
            // Security Check
            Teacher teacher = teacherDAO.getTeacherByUserId(teacherUser.getId());
            if (course != null && teacher != null && course.getTeacherId() != null && course.getTeacherId().intValue() == teacher.getId()) {
                request.setAttribute("selectedCourse", course);

                List<Student> enrolledStudents = courseDAO.getEnrolledStudentsForCourse(courseId);
                request.setAttribute("enrolledStudents", enrolledStudents);

                // Fetch existing marks for this course
                Map<Integer, Double> marksMap = new HashMap<>();
                Map<Integer, Double> maxMarksMap = new HashMap<>();
                for (Student student : enrolledStudents) {
                    List<Marks> stdMarksList = marksDAO.getMarksByStudentAndCourse(student.getId(), courseId);
                    for (Marks m : stdMarksList) {
                        if (examType.equalsIgnoreCase(m.getExamType())) {
                            marksMap.put(student.getId(), m.getMarksObtained());
                            maxMarksMap.put(student.getId(), m.getMaxMarks());
                        }
                    }
                }
                request.setAttribute("marksMap", marksMap);
                request.setAttribute("maxMarksMap", maxMarksMap);
            }
        }

        request.getRequestDispatcher("/views/teacher/marks.jsp").forward(request, response);
    }

    private void handleTeacherMarksPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int courseId = Integer.parseInt(request.getParameter("courseId"));
        String examType = request.getParameter("examType");
        
        List<Student> enrolledStudents = courseDAO.getEnrolledStudentsForCourse(courseId);
        
        boolean allSuccess = true;
        for (Student student : enrolledStudents) {
            String obtStr = request.getParameter("obtained_" + student.getId());
            String maxStr = request.getParameter("max_" + student.getId());
            
            if (obtStr != null && !obtStr.isEmpty() && maxStr != null && !maxStr.isEmpty()) {
                double obt = Double.parseDouble(obtStr);
                double max = Double.parseDouble(maxStr);
                
                if (max > 0) {
                    Marks record = new Marks();
                    record.setStudentId(student.getId());
                    record.setCourseId(courseId);
                    record.setExamType(examType);
                    record.setMarksObtained(obt);
                    record.setMaxMarks(max);
                    
                    boolean success = marksDAO.saveMarks(record);
                    if (!success) {
                        allSuccess = false;
                    }
                }
            }
        }

        if (allSuccess) {
            response.sendRedirect(request.getContextPath() + "/teacher/marks?courseId=" + courseId + "&examType=" + examType + "&msg=success");
        } else {
            response.sendRedirect(request.getContextPath() + "/teacher/marks?courseId=" + courseId + "&examType=" + examType + "&msg=error");
        }
    }

    // STUDENT VIEW: View report card and overall GPA
    private void handleStudentMarks(HttpServletRequest request, HttpServletResponse response, User studentUser)
            throws ServletException, IOException {
        
        Student student = studentDAO.getStudentByUserId(studentUser.getId());
        if (student != null) {
            List<Course> enrolledCourses = courseDAO.getCoursesForStudent(student.getId());
            List<Marks> marksList = marksDAO.getMarksByStudent(student.getId());

            // Compute cumulative GPAs per course dynamically
            Map<Integer, Double> courseGpaMap = new HashMap<>();
            double totalGpaSum = 0.0;
            int coursesWithGrades = 0;

            for (Course course : enrolledCourses) {
                double courseObt = 0.0;
                double courseMax = 0.0;
                boolean hasMarks = false;

                for (Marks m : marksList) {
                    if (m.getCourseId() == course.getId()) {
                        courseObt += m.getMarksObtained();
                        courseMax += m.getMaxMarks();
                        hasMarks = true;
                    }
                }

                if (hasMarks && courseMax > 0) {
                    double courseGpa = (courseObt / courseMax) * 10.0;
                    double roundedGpa = Math.round(courseGpa * 100.0) / 100.0;
                    courseGpaMap.put(course.getId(), roundedGpa);
                    totalGpaSum += roundedGpa;
                    coursesWithGrades++;
                } else {
                    courseGpaMap.put(course.getId(), 0.0);
                }
            }

            double overallGpa = 0.0;
            if (coursesWithGrades > 0) {
                overallGpa = totalGpaSum / coursesWithGrades;
            }
            overallGpa = Math.round(overallGpa * 100.0) / 100.0;

            request.setAttribute("enrolledCourses", enrolledCourses);
            request.setAttribute("marksList", marksList);
            request.setAttribute("courseGpaMap", courseGpaMap);
            request.setAttribute("overallGpa", overallGpa);
        }

        request.getRequestDispatcher("/views/student/marks.jsp").forward(request, response);
    }
}
