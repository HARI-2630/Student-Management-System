package com.sms.dao;

import com.sms.model.Teacher;
import com.sms.model.User;
import com.sms.util.DBConnection;
import com.sms.util.PasswordUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for handling Database operations on teacher-related profiles.
 */
public class TeacherDAO {

    public List<Teacher> getAllTeachers() {
        List<Teacher> list = new ArrayList<>();
        String query = "SELECT t.*, u.name, u.email FROM teachers t JOIN users u ON t.user_id = u.id ORDER BY u.name ASC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(extractTeacherFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Teacher getTeacherById(int id) {
        String query = "SELECT t.*, u.name, u.email FROM teachers t JOIN users u ON t.user_id = u.id WHERE t.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractTeacherFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Teacher getTeacherByUserId(int userId) {
        String query = "SELECT t.*, u.name, u.email FROM teachers t JOIN users u ON t.user_id = u.id WHERE t.user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractTeacherFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Transactional method to save both the user authentication record and teacher profile record.
     */
    public boolean saveTeacher(Teacher teacher, User user) {
        String insertUserSql = "INSERT INTO users (name, email, password_hash, role) VALUES (?, ?, ?, 'TEACHER')";
        String insertTeacherSql = "INSERT INTO teachers (user_id, department, qualification) VALUES (?, ?, ?)";
        
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Begin Transaction

            // 1. Insert User
            try (PreparedStatement psUser = conn.prepareStatement(insertUserSql, Statement.RETURN_GENERATED_KEYS)) {
                psUser.setString(1, user.getName());
                psUser.setString(2, user.getEmail());
                psUser.setString(3, PasswordUtil.hash(user.getPasswordHash()));
                psUser.executeUpdate();

                try (ResultSet rsKeys = psUser.getGeneratedKeys()) {
                    if (rsKeys.next()) {
                        int userId = rsKeys.getInt(1);
                        teacher.setUserId(userId);
                    } else {
                        throw new SQLException("Failed to retrieve generated user ID.");
                    }
                }
            }

            // 2. Insert Teacher Profile
            try (PreparedStatement psTeacher = conn.prepareStatement(insertTeacherSql)) {
                psTeacher.setInt(1, teacher.getUserId());
                psTeacher.setString(2, teacher.getDepartment());
                psTeacher.setString(3, teacher.getQualification());
                psTeacher.executeUpdate();
            }

            conn.commit(); // Commit Transaction
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback(); // Rollback Transaction on error
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        }
    }

    /**
     * Transactional method to update teacher profile and authentication details.
     */
    public boolean updateTeacher(Teacher teacher, User user) {
        String updateUserSql = "UPDATE users SET name = ?, email = ? " + (user.getPasswordHash() != null && !user.getPasswordHash().trim().isEmpty() ? ", password_hash = ? " : "") + "WHERE id = ?";
        String updateTeacherSql = "UPDATE teachers SET department = ?, qualification = ? WHERE id = ?";

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Begin Transaction

            // 1. Update User
            try (PreparedStatement psUser = conn.prepareStatement(updateUserSql)) {
                psUser.setString(1, user.getName());
                psUser.setString(2, user.getEmail());
                int paramIdx = 3;
                if (user.getPasswordHash() != null && !user.getPasswordHash().trim().isEmpty()) {
                    psUser.setString(paramIdx++, PasswordUtil.hash(user.getPasswordHash()));
                }
                psUser.setInt(paramIdx, teacher.getUserId());
                psUser.executeUpdate();
            }

            // 2. Update Teacher Profile
            try (PreparedStatement psTeacher = conn.prepareStatement(updateTeacherSql)) {
                psTeacher.setString(1, teacher.getDepartment());
                psTeacher.setString(2, teacher.getQualification());
                psTeacher.setInt(3, teacher.getId());
                psTeacher.executeUpdate();
            }

            conn.commit(); // Commit Transaction
            return true;
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        }
    }

    /**
     * Deletes a teacher's user account, triggering a cascade deletion across the teachers table.
     */
    public boolean deleteTeacher(int id) {
        Teacher teacher = getTeacherById(id);
        if (teacher == null) {
            return false;
        }
        String query = "DELETE FROM users WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, teacher.getUserId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private Teacher extractTeacherFromResultSet(ResultSet rs) throws SQLException {
        Teacher t = new Teacher();
        t.setId(rs.getInt("id"));
        t.setUserId(rs.getInt("user_id"));
        t.setDepartment(rs.getString("department"));
        t.setQualification(rs.getString("qualification"));
        t.setName(rs.getString("name"));
        t.setEmail(rs.getString("email"));
        return t;
    }
}
