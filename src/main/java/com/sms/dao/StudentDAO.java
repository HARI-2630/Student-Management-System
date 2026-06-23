package com.sms.dao;

import com.sms.model.Student;
import com.sms.model.User;
import com.sms.util.DBConnection;
import com.sms.util.PasswordUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for handling Database operations on student-related profiles.
 */
public class StudentDAO {

    public List<Student> getAllStudents() {
        List<Student> list = new ArrayList<>();
        String query = "SELECT s.*, u.name, u.email FROM students s JOIN users u ON s.user_id = u.id ORDER BY u.name ASC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(extractStudentFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Student> getStudentsPaginated(int page, int size, String search, String department, Integer year) {
        List<Student> list = new ArrayList<>();
        StringBuilder query = new StringBuilder(
            "SELECT s.*, u.name, u.email FROM students s " +
            "JOIN users u ON s.user_id = u.id " +
            "WHERE 1=1"
        );

        if (search != null && !search.trim().isEmpty()) {
            query.append(" AND (u.name LIKE ? OR s.roll_number LIKE ?)");
        }
        if (department != null && !department.trim().isEmpty() && !"All".equalsIgnoreCase(department)) {
            query.append(" AND s.department = ?");
        }
        if (year != null && year > 0) {
            query.append(" AND s.year = ?");
        }

        query.append(" ORDER BY u.name ASC LIMIT ? OFFSET ?");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query.toString())) {
            
            int index = 1;
            if (search != null && !search.trim().isEmpty()) {
                String searchPattern = "%" + search.trim() + "%";
                ps.setString(index++, searchPattern);
                ps.setString(index++, searchPattern);
            }
            if (department != null && !department.trim().isEmpty() && !"All".equalsIgnoreCase(department)) {
                ps.setString(index++, department);
            }
            if (year != null && year > 0) {
                ps.setInt(index++, year);
            }
            
            ps.setInt(index++, size);
            ps.setInt(index++, (page - 1) * size);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(extractStudentFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getStudentCountFiltered(String search, String department, Integer year) {
        StringBuilder query = new StringBuilder(
            "SELECT COUNT(*) FROM students s " +
            "JOIN users u ON s.user_id = u.id " +
            "WHERE 1=1"
        );

        if (search != null && !search.trim().isEmpty()) {
            query.append(" AND (u.name LIKE ? OR s.roll_number LIKE ?)");
        }
        if (department != null && !department.trim().isEmpty() && !"All".equalsIgnoreCase(department)) {
            query.append(" AND s.department = ?");
        }
        if (year != null && year > 0) {
            query.append(" AND s.year = ?");
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query.toString())) {
            
            int index = 1;
            if (search != null && !search.trim().isEmpty()) {
                String searchPattern = "%" + search.trim() + "%";
                ps.setString(index++, searchPattern);
                ps.setString(index++, searchPattern);
            }
            if (department != null && !department.trim().isEmpty() && !"All".equalsIgnoreCase(department)) {
                ps.setString(index++, department);
            }
            if (year != null && year > 0) {
                ps.setInt(index++, year);
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public Student getStudentById(int id) {
        String query = "SELECT s.*, u.name, u.email FROM students s JOIN users u ON s.user_id = u.id WHERE s.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractStudentFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Student getStudentByUserId(int userId) {
        String query = "SELECT s.*, u.name, u.email FROM students s JOIN users u ON s.user_id = u.id WHERE s.user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractStudentFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Transactional method to save both the user authentication record and student profile record.
     */
    public boolean saveStudent(Student student, User user) {
        String insertUserSql = "INSERT INTO users (name, email, password_hash, role) VALUES (?, ?, ?, 'STUDENT')";
        String insertStudentSql = "INSERT INTO students (user_id, roll_number, department, year, phone, address) VALUES (?, ?, ?, ?, ?, ?)";
        
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
                        student.setUserId(userId);
                    } else {
                        throw new SQLException("Failed to retrieve generated user ID.");
                    }
                }
            }

            // 2. Insert Student Profile
            try (PreparedStatement psStudent = conn.prepareStatement(insertStudentSql)) {
                psStudent.setInt(1, student.getUserId());
                psStudent.setString(2, student.getRollNumber());
                psStudent.setString(3, student.getDepartment());
                psStudent.setInt(4, student.getYear());
                psStudent.setString(5, student.getPhone());
                psStudent.setString(6, student.getAddress());
                psStudent.executeUpdate();
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
     * Transactional method to update student profile and authentication details.
     */
    public boolean updateStudent(Student student, User user) {
        String updateUserSql = "UPDATE users SET name = ?, email = ? " + (user.getPasswordHash() != null && !user.getPasswordHash().trim().isEmpty() ? ", password_hash = ? " : "") + "WHERE id = ?";
        String updateStudentSql = "UPDATE students SET roll_number = ?, department = ?, year = ?, phone = ?, address = ? WHERE id = ?";

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
                psUser.setInt(paramIdx, student.getUserId());
                psUser.executeUpdate();
            }

            // 2. Update Student Profile
            try (PreparedStatement psStudent = conn.prepareStatement(updateStudentSql)) {
                psStudent.setString(1, student.getRollNumber());
                psStudent.setString(2, student.getDepartment());
                psStudent.setInt(3, student.getYear());
                psStudent.setString(4, student.getPhone());
                psStudent.setString(5, student.getAddress());
                psStudent.setInt(6, student.getId());
                psStudent.executeUpdate();
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
     * Deletes a student's user account, triggering a cascade deletion across students, enrollments, marks, fees, and attendance logs.
     */
    public boolean deleteStudent(int id) {
        Student student = getStudentById(id);
        if (student == null) {
            return false;
        }
        String query = "DELETE FROM users WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, student.getUserId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private Student extractStudentFromResultSet(ResultSet rs) throws SQLException {
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
        return s;
    }
}
