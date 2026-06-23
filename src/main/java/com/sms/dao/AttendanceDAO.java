package com.sms.dao;

import com.sms.model.Attendance;
import com.sms.util.DBConnection;

import java.sql.*;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for handling Database operations on student attendance.
 */
public class AttendanceDAO {

    public List<Attendance> getAttendanceByCourseAndDate(int courseId, Date date) {
        List<Attendance> list = new ArrayList<>();
        String query = "SELECT a.*, u.name as student_name, s.roll_number, c.name as course_name, c.code as course_code " +
                       "FROM attendance a " +
                       "JOIN students s ON a.student_id = s.id " +
                       "JOIN users u ON s.user_id = u.id " +
                       "JOIN courses c ON a.course_id = c.id " +
                       "WHERE a.course_id = ? AND a.date = ? " +
                       "ORDER BY u.name ASC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setInt(1, courseId);
            ps.setDate(2, date);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(extractAttendanceFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Attendance> getAttendanceByStudent(int studentId) {
        List<Attendance> list = new ArrayList<>();
        String query = "SELECT a.*, u.name as student_name, s.roll_number, c.name as course_name, c.code as course_code " +
                       "FROM attendance a " +
                       "JOIN students s ON a.student_id = s.id " +
                       "JOIN users u ON s.user_id = u.id " +
                       "JOIN courses c ON a.course_id = c.id " +
                       "WHERE a.student_id = ? " +
                       "ORDER BY a.date DESC, c.code ASC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(extractAttendanceFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean saveAttendance(Attendance record) {
        String query = "INSERT INTO attendance (student_id, course_id, date, status) VALUES (?, ?, ?, ?) " +
                       "ON DUPLICATE KEY UPDATE status = VALUES(status)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setInt(1, record.getStudentId());
            ps.setInt(2, record.getCourseId());
            ps.setDate(3, record.getDate());
            ps.setString(4, record.getStatus());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public double getAttendancePercentageForStudentAndCourse(int studentId, int courseId) {
        String query = "SELECT status, COUNT(*) as count FROM attendance WHERE student_id = ? AND course_id = ? GROUP BY status";
        int presentCount = 0;
        int lateCount = 0;
        int totalCount = 0;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setInt(1, studentId);
            ps.setInt(2, courseId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String status = rs.getString("status");
                    int count = rs.getInt("count");
                    totalCount += count;
                    if ("PRESENT".equalsIgnoreCase(status)) {
                        presentCount += count;
                    } else if ("LATE".equalsIgnoreCase(status)) {
                        lateCount += count;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        if (totalCount == 0) return 100.0;
        // Formula: (Present + 0.5 * Late) / Total * 100
        double percentage = ((presentCount + 0.5 * lateCount) / totalCount) * 100.0;
        return Math.round(percentage * 100.0) / 100.0;
    }

    /**
     * Aggregated report structure for Course Attendance Report view.
     * Contains counts and calculated percentage fields.
     */
    public static class AttendanceRecordSummary {
        private String studentName;
        private String rollNumber;
        private int presentCount;
        private int absentCount;
        private int lateCount;
        private int totalCount;
        private double percentage;

        public String getStudentName() { return studentName; }
        public void setStudentName(String studentName) { this.studentName = studentName; }
        public String getRollNumber() { return rollNumber; }
        public void setRollNumber(String rollNumber) { this.rollNumber = rollNumber; }
        public int getPresentCount() { return presentCount; }
        public void setPresentCount(int presentCount) { this.presentCount = presentCount; }
        public int getAbsentCount() { return absentCount; }
        public void setAbsentCount(int absentCount) { this.absentCount = absentCount; }
        public int getLateCount() { return lateCount; }
        public void setLateCount(int lateCount) { this.lateCount = lateCount; }
        public int getTotalCount() { return totalCount; }
        public void setTotalCount(int totalCount) { this.totalCount = totalCount; }
        public double getPercentage() { return percentage; }
        public void setPercentage(double percentage) { this.percentage = percentage; }
    }

    public List<AttendanceRecordSummary> getAttendanceSummaryByCourse(int courseId) {
        List<AttendanceRecordSummary> list = new ArrayList<>();
        String query = 
            "SELECT u.name AS student_name, s.roll_number, " +
            "SUM(CASE WHEN a.status = 'PRESENT' THEN 1 ELSE 0 END) AS present_count, " +
            "SUM(CASE WHEN a.status = 'ABSENT' THEN 1 ELSE 0 END) AS absent_count, " +
            "SUM(CASE WHEN a.status = 'LATE' THEN 1 ELSE 0 END) AS late_count, " +
            "COUNT(a.id) AS total_count " +
            "FROM enrollments e " +
            "JOIN students s ON e.student_id = s.id " +
            "JOIN users u ON s.user_id = u.id " +
            "LEFT JOIN attendance a ON s.id = a.student_id AND e.course_id = a.course_id " +
            "WHERE e.course_id = ? " +
            "GROUP BY s.id " +
            "ORDER BY u.name ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setInt(1, courseId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    AttendanceRecordSummary rec = new AttendanceRecordSummary();
                    rec.setStudentName(rs.getString("student_name"));
                    rec.setRollNumber(rs.getString("roll_number"));
                    
                    int present = rs.getInt("present_count");
                    int absent = rs.getInt("absent_count");
                    int late = rs.getInt("late_count");
                    int total = rs.getInt("total_count");

                    rec.setPresentCount(present);
                    rec.setAbsentCount(absent);
                    rec.setLateCount(late);
                    rec.setTotalCount(total);

                    double percentage = 100.0;
                    if (total > 0) {
                        percentage = ((present + 0.5 * late) / (double) total) * 100.0;
                    }
                    rec.setPercentage(Math.round(percentage * 100.0) / 100.0);
                    list.add(rec);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private Attendance extractAttendanceFromResultSet(ResultSet rs) throws SQLException {
        Attendance att = new Attendance();
        att.setId(rs.getInt("id"));
        att.setStudentId(rs.getInt("student_id"));
        att.setCourseId(rs.getInt("course_id"));
        att.setDate(rs.getDate("date"));
        att.setStatus(rs.getString("status"));
        att.setStudentName(rs.getString("student_name"));
        att.setRollNumber(rs.getString("roll_number"));
        att.setCourseName(rs.getString("course_name"));
        att.setCourseCode(rs.getString("course_code"));
        return att;
    }
}
