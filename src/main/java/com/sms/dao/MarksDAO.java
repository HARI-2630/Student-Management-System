package com.sms.dao;

import com.sms.model.Marks;
import com.sms.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for handling Database operations on student marks.
 */
public class MarksDAO {

    public List<Marks> getMarksByStudentAndCourse(int studentId, int courseId) {
        List<Marks> list = new ArrayList<>();
        String query = "SELECT m.*, u.name as student_name, s.roll_number, c.name as course_name, c.code as course_code " +
                       "FROM marks m " +
                       "JOIN students s ON m.student_id = s.id " +
                       "JOIN users u ON s.user_id = u.id " +
                       "JOIN courses c ON m.course_id = c.id " +
                       "WHERE m.student_id = ? AND m.course_id = ? " +
                       "ORDER BY m.exam_type ASC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setInt(1, studentId);
            ps.setInt(2, courseId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(extractMarksFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Marks> getMarksByStudent(int studentId) {
        List<Marks> list = new ArrayList<>();
        String query = "SELECT m.*, u.name as student_name, s.roll_number, c.name as course_name, c.code as course_code " +
                       "FROM marks m " +
                       "JOIN students s ON m.student_id = s.id " +
                       "JOIN users u ON s.user_id = u.id " +
                       "JOIN courses c ON m.course_id = c.id " +
                       "WHERE m.student_id = ? " +
                       "ORDER BY c.code ASC, m.exam_type ASC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(extractMarksFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean saveMarks(Marks marks) {
        String query = "INSERT INTO marks (student_id, course_id, exam_type, marks_obtained, max_marks) " +
                       "VALUES (?, ?, ?, ?, ?) " +
                       "ON DUPLICATE KEY UPDATE marks_obtained = VALUES(marks_obtained), max_marks = VALUES(max_marks)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setInt(1, marks.getStudentId());
            ps.setInt(2, marks.getCourseId());
            ps.setString(3, marks.getExamType());
            ps.setDouble(4, marks.getMarksObtained());
            ps.setDouble(5, marks.getMaxMarks());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * DTO representing course score metrics for reports.
     */
    public static class CourseMarksReportRecord {
        private String studentName;
        private String rollNumber;
        private Double internalMarks;
        private Double midtermMarks;
        private Double finalMarks;
        private double totalObtained;
        private double totalMax;
        private double gpa;

        public String getStudentName() { return studentName; }
        public void setStudentName(String studentName) { this.studentName = studentName; }
        public String getRollNumber() { return rollNumber; }
        public void setRollNumber(String rollNumber) { this.rollNumber = rollNumber; }
        public Double getInternalMarks() { return internalMarks; }
        public void setInternalMarks(Double internalMarks) { this.internalMarks = internalMarks; }
        public Double getMidtermMarks() { return midtermMarks; }
        public void setMidtermMarks(Double midtermMarks) { this.midtermMarks = midtermMarks; }
        public Double getFinalMarks() { return finalMarks; }
        public void setFinalMarks(Double finalMarks) { this.finalMarks = finalMarks; }
        public double getTotalObtained() { return totalObtained; }
        public void setTotalObtained(double totalObtained) { this.totalObtained = totalObtained; }
        public double getTotalMax() { return totalMax; }
        public void setTotalMax(double totalMax) { this.totalMax = totalMax; }
        public double getGpa() { return gpa; }
        public void setGpa(double gpa) { this.gpa = gpa; }
    }

    public List<CourseMarksReportRecord> getMarksReportByCourse(int courseId) {
        List<CourseMarksReportRecord> list = new ArrayList<>();
        String query = 
            "SELECT u.name AS student_name, s.roll_number, " +
            "MAX(CASE WHEN m.exam_type = 'Internal' THEN m.marks_obtained END) AS internal_obt, " +
            "MAX(CASE WHEN m.exam_type = 'Internal' THEN m.max_marks END) AS internal_max, " +
            "MAX(CASE WHEN m.exam_type = 'Midterm' THEN m.marks_obtained END) AS midterm_obt, " +
            "MAX(CASE WHEN m.exam_type = 'Midterm' THEN m.max_marks END) AS midterm_max, " +
            "MAX(CASE WHEN m.exam_type = 'Final' THEN m.marks_obtained END) AS final_obt, " +
            "MAX(CASE WHEN m.exam_type = 'Final' THEN m.max_marks END) AS final_max " +
            "FROM enrollments e " +
            "JOIN students s ON e.student_id = s.id " +
            "JOIN users u ON s.user_id = u.id " +
            "LEFT JOIN marks m ON s.id = m.student_id AND e.course_id = m.course_id " +
            "WHERE e.course_id = ? " +
            "GROUP BY s.id " +
            "ORDER BY u.name ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setInt(1, courseId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CourseMarksReportRecord rec = new CourseMarksReportRecord();
                    rec.setStudentName(rs.getString("student_name"));
                    rec.setRollNumber(rs.getString("roll_number"));

                    double obt = 0.0;
                    double max = 0.0;

                    double intObt = rs.getDouble("internal_obt");
                    boolean intObtNull = rs.wasNull();
                    double intMax = rs.getDouble("internal_max");
                    if (!intObtNull) {
                        rec.setInternalMarks(intObt);
                        obt += intObt;
                        max += intMax;
                    }

                    double midObt = rs.getDouble("midterm_obt");
                    boolean midObtNull = rs.wasNull();
                    double midMax = rs.getDouble("midterm_max");
                    if (!midObtNull) {
                        rec.setMidtermMarks(midObt);
                        obt += midObt;
                        max += midMax;
                    }

                    double finObt = rs.getDouble("final_obt");
                    boolean finObtNull = rs.wasNull();
                    double finMax = rs.getDouble("final_max");
                    if (!finObtNull) {
                        rec.setFinalMarks(finObt);
                        obt += finObt;
                        max += finMax;
                    }

                    rec.setTotalObtained(obt);
                    rec.setTotalMax(max);

                    double gpa = 0.0;
                    if (max > 0) {
                        gpa = (obt / max) * 10.0;
                    }
                    rec.setGpa(Math.round(gpa * 100.0) / 100.0);
                    
                    list.add(rec);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private Marks extractMarksFromResultSet(ResultSet rs) throws SQLException {
        Marks m = new Marks();
        m.setId(rs.getInt("id"));
        m.setStudentId(rs.getInt("student_id"));
        m.setCourseId(rs.getInt("course_id"));
        m.setExamType(rs.getString("exam_type"));
        m.setMarksObtained(rs.getDouble("marks_obtained"));
        m.setMaxMarks(rs.getDouble("max_marks"));
        m.setStudentName(rs.getString("student_name"));
        m.setRollNumber(rs.getString("roll_number"));
        m.setCourseName(rs.getString("course_name"));
        m.setCourseCode(rs.getString("course_code"));
        return m;
    }
}
