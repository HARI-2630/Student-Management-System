package com.sms.dao;

import com.sms.model.Course;
import com.sms.model.Student;
import com.sms.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for handling Database operations on courses and enrollments.
 */
public class CourseDAO {

    public List<Course> getAllCourses() {
        List<Course> list = new ArrayList<>();
        String query = "SELECT c.*, u.name as teacher_name FROM courses c " +
                       "LEFT JOIN teachers t ON c.teacher_id = t.id " +
                       "LEFT JOIN users u ON t.user_id = u.id " +
                       "ORDER BY c.code ASC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(extractCourseFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Course getCourseById(int id) {
        String query = "SELECT c.*, u.name as teacher_name FROM courses c " +
                       "LEFT JOIN teachers t ON c.teacher_id = t.id " +
                       "LEFT JOIN users u ON t.user_id = u.id " +
                       "WHERE c.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractCourseFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Course getCourseByCode(String code) {
        String query = "SELECT c.*, u.name as teacher_name FROM courses c " +
                       "LEFT JOIN teachers t ON c.teacher_id = t.id " +
                       "LEFT JOIN users u ON t.user_id = u.id " +
                       "WHERE c.code = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, code);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractCourseFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Course> getCoursesByTeacher(int teacherUserId) {
        List<Course> list = new ArrayList<>();
        String query = "SELECT c.*, u.name as teacher_name FROM courses c " +
                       "JOIN teachers t ON c.teacher_id = t.id " +
                       "JOIN users u ON t.user_id = u.id " +
                       "WHERE u.id = ? ORDER BY c.code ASC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, teacherUserId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(extractCourseFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean saveCourse(Course course) {
        String query = "INSERT INTO courses (name, code, department, credits, teacher_id) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, course.getName());
            ps.setString(2, course.getCode());
            ps.setString(3, course.getDepartment());
            ps.setInt(4, course.getCredits());
            if (course.getTeacherId() != null && course.getTeacherId() > 0) {
                ps.setInt(5, course.getTeacherId());
            } else {
                ps.setNull(5, Types.INTEGER);
            }
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateCourse(Course course) {
        String query = "UPDATE courses SET name = ?, code = ?, department = ?, credits = ?, teacher_id = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, course.getName());
            ps.setString(2, course.getCode());
            ps.setString(3, course.getDepartment());
            ps.setInt(4, course.getCredits());
            if (course.getTeacherId() != null && course.getTeacherId() > 0) {
                ps.setInt(5, course.getTeacherId());
            } else {
                ps.setNull(5, Types.INTEGER);
            }
            ps.setInt(6, course.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteCourse(int id) {
        String query = "DELETE FROM courses WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ========================================================
    // ENROLLMENT HELPER OPERATIONS
    // ========================================================

    public boolean enrollStudent(int studentId, int courseId) {
        String query = "INSERT INTO enrollments (student_id, course_id) VALUES (?, ?) " +
                       "ON DUPLICATE KEY UPDATE student_id = student_id";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, studentId);
            ps.setInt(2, courseId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean unenrollStudent(int studentId, int courseId) {
        String query = "DELETE FROM enrollments WHERE student_id = ? AND course_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, studentId);
            ps.setInt(2, courseId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Student> getEnrolledStudentsForCourse(int courseId) {
        List<Student> students = new ArrayList<>();
        String query = "SELECT s.*, u.name, u.email FROM students s " +
                       "JOIN users u ON s.user_id = u.id " +
                       "JOIN enrollments e ON s.id = e.student_id " +
                       "WHERE e.course_id = ? ORDER BY u.name ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, courseId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Student s = new Student();
                    s.setId(rs.getInt("id"));
                    s.setUserId(rs.getInt("user_id"));
                    s.setRollNumber(rs.getString("roll_number"));
                    s.setDepartment(rs.getString("department"));
                    s.setYear(rs.getInt("year"));
                    s.setPhone(rs.getString("phone"));
                    s.setAddress(rs.getString("address"));
                    s.setName(rs.getString("name"));
                    s.setEmail(rs.getString("email"));
                    students.add(s);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return students;
    }

    public List<Course> getCoursesForStudent(int studentId) {
        List<Course> courses = new ArrayList<>();
        String query = "SELECT c.*, u.name as teacher_name FROM courses c " +
                       "JOIN enrollments e ON c.id = e.course_id " +
                       "LEFT JOIN teachers t ON c.teacher_id = t.id " +
                       "LEFT JOIN users u ON t.user_id = u.id " +
                       "WHERE e.student_id = ? ORDER BY c.code ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    courses.add(extractCourseFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return courses;
    }

    private Course extractCourseFromResultSet(ResultSet rs) throws SQLException {
        Course c = new Course();
        c.setId(rs.getInt("id"));
        c.setName(rs.getString("name"));
        c.setCode(rs.getString("code"));
        c.setDepartment(rs.getString("department"));
        c.setCredits(rs.getInt("credits"));
        int tId = rs.getInt("teacher_id");
        if (rs.wasNull()) {
            c.setTeacherId(null);
        } else {
            c.setTeacherId(tId);
        }
        c.setTeacherName(rs.getString("teacher_name"));
        return c;
    }
}
