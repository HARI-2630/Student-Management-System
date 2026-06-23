package com.sms.servlet;

import com.sms.dao.AttendanceDAO;
import com.sms.dao.CourseDAO;
import com.sms.dao.StudentDAO;
import com.sms.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.sms.dao.TeacherDAO;

/**
 * Controller to handle role-based attendance recording and reporting.
 */
@WebServlet(urlPatterns = {"/admin/attendance", "/teacher/attendance", "/student/attendance"})
public class AttendanceServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AttendanceDAO attendanceDAO;
    private CourseDAO courseDAO;
    private StudentDAO studentDAO;
    private TeacherDAO teacherDAO;

    @Override
    public void init() throws ServletException {
        attendanceDAO = new AttendanceDAO();
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
            handleAdminAttendance(request, response);
        } else if ("TEACHER".equals(role)) {
            handleTeacherAttendanceGet(request, response, loggedInUser);
        } else if ("STUDENT".equals(role)) {
            handleStudentAttendance(request, response, loggedInUser);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User loggedInUser = (User) session.getAttribute("user");
        String role = loggedInUser.getRole();

        if ("TEACHER".equals(role)) {
            handleTeacherAttendancePost(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    // ADMIN VIEW: View aggregate attendance metrics filtered by course
    private void handleAdminAttendance(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String courseIdStr = request.getParameter("courseId");
        List<Course> courses = courseDAO.getAllCourses();
        request.setAttribute("courses", courses);

        if (courseIdStr != null && !courseIdStr.isEmpty() && !"All".equals(courseIdStr)) {
            int courseId = Integer.parseInt(courseIdStr);
            List<AttendanceDAO.AttendanceRecordSummary> reports = attendanceDAO.getAttendanceSummaryByCourse(courseId);
            request.setAttribute("selectedCourseId", courseId);
            request.setAttribute("attendanceReports", reports);
        }
        
        request.getRequestDispatcher("/views/admin/attendance-report.jsp").forward(request, response);
    }

    // TEACHER VIEW: Select course and date to record attendance
    private void handleTeacherAttendanceGet(HttpServletRequest request, HttpServletResponse response, User teacherUser)
            throws ServletException, IOException {
        
        String courseIdStr = request.getParameter("courseId");
        String dateStr = request.getParameter("date");
        Date dateVal = (dateStr == null || dateStr.isEmpty()) 
            ? new Date(System.currentTimeMillis()) 
            : Date.valueOf(dateStr);
            
        List<Course> assignedCourses = courseDAO.getCoursesByTeacher(teacherUser.getId());
        request.setAttribute("assignedCourses", assignedCourses);
        request.setAttribute("selectedDate", dateVal.toString());

        if (courseIdStr != null && !courseIdStr.isEmpty()) {
            int courseId = Integer.parseInt(courseIdStr);
            Course course = courseDAO.getCourseById(courseId);
            
            // Security Check: Verify teacher owns the course
            Teacher teacher = teacherDAO.getTeacherByUserId(teacherUser.getId());
            if (course != null && teacher != null && course.getTeacherId() != null && course.getTeacherId().intValue() == teacher.getId()) {
                request.setAttribute("selectedCourse", course);
                
                // Get enrolled students
                List<Student> enrolledStudents = courseDAO.getEnrolledStudentsForCourse(courseId);
                request.setAttribute("enrolledStudents", enrolledStudents);
                
                // Get existing attendance logs for this course and date
                List<Attendance> existingLogs = attendanceDAO.getAttendanceByCourseAndDate(courseId, dateVal);
                Map<Integer, String> attendanceMap = new HashMap<>();
                for (Attendance att : existingLogs) {
                    attendanceMap.put(att.getStudentId(), att.getStatus());
                }
                request.setAttribute("attendanceMap", attendanceMap);
            }
        }

        request.getRequestDispatcher("/views/teacher/attendance.jsp").forward(request, response);
    }

    private void handleTeacherAttendancePost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int courseId = Integer.parseInt(request.getParameter("courseId"));
        Date dateVal = Date.valueOf(request.getParameter("date"));
        
        // Find enrolled students to record status
        List<Student> enrolledStudents = courseDAO.getEnrolledStudentsForCourse(courseId);
        
        boolean allSuccess = true;
        for (Student student : enrolledStudents) {
            String status = request.getParameter("status_" + student.getId());
            if (status != null) {
                Attendance record = new Attendance();
                record.setStudentId(student.getId());
                record.setCourseId(courseId);
                record.setDate(dateVal);
                record.setStatus(status);
                
                boolean success = attendanceDAO.saveAttendance(record);
                if (!success) {
                    allSuccess = false;
                }
            }
        }
        
        if (allSuccess) {
            response.sendRedirect(request.getContextPath() + "/teacher/attendance?courseId=" + courseId + "&date=" + dateVal + "&msg=success");
        } else {
            response.sendRedirect(request.getContextPath() + "/teacher/attendance?courseId=" + courseId + "&date=" + dateVal + "&msg=error");
        }
    }

    // STUDENT VIEW: View personal attendance summary & date logs
    private void handleStudentAttendance(HttpServletRequest request, HttpServletResponse response, User studentUser)
            throws ServletException, IOException {
        
        Student student = studentDAO.getStudentByUserId(studentUser.getId());
        if (student != null) {
            List<Course> enrolledCourses = courseDAO.getCoursesForStudent(student.getId());
            List<Attendance> logs = attendanceDAO.getAttendanceByStudent(student.getId());
            
            // Calculate rates per course
            Map<Integer, Double> rateMap = new HashMap<>();
            for (Course course : enrolledCourses) {
                double rate = attendanceDAO.getAttendancePercentageForStudentAndCourse(student.getId(), course.getId());
                rateMap.put(course.getId(), rate);
            }
            
            request.setAttribute("enrolledCourses", enrolledCourses);
            request.setAttribute("attendanceLogs", logs);
            request.setAttribute("rateMap", rateMap);
        }
        
        request.getRequestDispatcher("/views/student/attendance.jsp").forward(request, response);
    }
}
