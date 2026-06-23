package com.sms.dao;

import com.sms.model.Fee;
import com.sms.util.DBConnection;

import java.sql.*;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for handling Database operations on student fees invoices.
 */
public class FeeDAO {

    public List<Fee> getAllFees() {
        List<Fee> list = new ArrayList<>();
        // Auto update overdue status in the database first
        autoUpdateOverdueFees();

        String query = "SELECT f.*, u.name as student_name, s.roll_number FROM fees f " +
                       "JOIN students s ON f.student_id = s.id " +
                       "JOIN users u ON s.user_id = u.id " +
                       "ORDER BY f.due_date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(extractFeeFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Fee> getFeesByStudent(int studentId) {
        // Auto update overdue status in the database first
        autoUpdateOverdueFees();

        List<Fee> list = new ArrayList<>();
        String query = "SELECT f.*, u.name as student_name, s.roll_number FROM fees f " +
                       "JOIN students s ON f.student_id = s.id " +
                       "JOIN users u ON s.user_id = u.id " +
                       "WHERE f.student_id = ? " +
                       "ORDER BY f.semester ASC, f.due_date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(extractFeeFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean saveFee(Fee fee) {
        String query = "INSERT INTO fees (student_id, semester, amount, due_date, status) VALUES (?, ?, ?, ?, 'UNPAID')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, fee.getStudentId());
            ps.setInt(2, fee.getSemester());
            ps.setDouble(3, fee.getAmount());
            ps.setDate(4, fee.getDueDate());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean markAsPaid(int feeId) {
        String query = "UPDATE fees SET status = 'PAID', paid_date = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setDate(1, new Date(System.currentTimeMillis()));
            ps.setInt(2, feeId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Business Logic: Automatically marks any UNPAID fees whose due date has passed as OVERDUE.
     */
    public boolean autoUpdateOverdueFees() {
        String query = "UPDATE fees SET status = 'OVERDUE' WHERE status = 'UNPAID' AND due_date < ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setDate(1, new Date(System.currentTimeMillis()));
            ps.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public double getTotalUnpaidFees() {
        autoUpdateOverdueFees();
        String query = "SELECT SUM(amount) FROM fees WHERE status = 'UNPAID' OR status = 'OVERDUE'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    private Fee extractFeeFromResultSet(ResultSet rs) throws SQLException {
        Fee f = new Fee();
        f.setId(rs.getInt("id"));
        f.setStudentId(rs.getInt("student_id"));
        f.setSemester(rs.getInt("semester"));
        f.setAmount(rs.getDouble("amount"));
        f.setDueDate(rs.getDate("due_date"));
        f.setPaidDate(rs.getDate("paid_date"));
        f.setStatus(rs.getString("status"));
        f.setStudentName(rs.getString("student_name"));
        f.setRollNumber(rs.getString("roll_number"));
        return f;
    }
}
