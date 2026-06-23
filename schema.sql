-- schema.sql - Student Management System Database Schema & Seeding
-- Designed for Tomcat JNDI context database initialization

DROP DATABASE IF EXISTS sms_db;
CREATE DATABASE sms_db;
USE sms_db;

-- 1. Users Table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(64) NOT NULL, -- SHA-256 hex length is 64 characters
    role ENUM('ADMIN', 'TEACHER', 'STUDENT') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 2. Students Table
CREATE TABLE IF NOT EXISTS students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    roll_number VARCHAR(50) NOT NULL UNIQUE,
    department VARCHAR(100) NOT NULL,
    year INT NOT NULL,
    phone VARCHAR(20) NOT NULL,
    address TEXT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 3. Teachers Table
CREATE TABLE IF NOT EXISTS teachers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    department VARCHAR(100) NOT NULL,
    qualification VARCHAR(100) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 4. Courses Table
CREATE TABLE IF NOT EXISTS courses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    code VARCHAR(20) NOT NULL UNIQUE,
    department VARCHAR(100) NOT NULL,
    credits INT NOT NULL,
    teacher_id INT, -- References teachers(id)
    FOREIGN KEY (teacher_id) REFERENCES teachers(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- 5. Enrollments Table
CREATE TABLE IF NOT EXISTS enrollments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrolled_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
    UNIQUE KEY unique_enrollment (student_id, course_id)
) ENGINE=InnoDB;

-- 6. Attendance Table
CREATE TABLE IF NOT EXISTS attendance (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    date DATE NOT NULL,
    status ENUM('PRESENT', 'ABSENT', 'LATE') NOT NULL,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
    UNIQUE KEY unique_attendance (student_id, course_id, date)
) ENGINE=InnoDB;

-- 7. Marks Table
CREATE TABLE IF NOT EXISTS marks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    exam_type VARCHAR(50) NOT NULL, -- e.g. Internal, Midterm, Final
    marks_obtained DECIMAL(5,2) NOT NULL,
    max_marks DECIMAL(5,2) NOT NULL,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
    UNIQUE KEY unique_student_course_exam (student_id, course_id, exam_type)
) ENGINE=InnoDB;

-- 8. Fees Table
CREATE TABLE IF NOT EXISTS fees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    semester INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    due_date DATE NOT NULL,
    paid_date DATE DEFAULT NULL,
    status ENUM('PAID', 'UNPAID', 'OVERDUE') NOT NULL DEFAULT 'UNPAID',
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ========================================================
-- SEED DATA (Password hashes computed as standard SHA-256)
-- ========================================================

-- Seed Users
-- admin@sms.com       / admin123   -> 240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9
-- grace.hopper@sms.com / teacher123 -> cde383eee8ee7a4400adf7a15f716f179a2eb97646b37e089eb8d6d04e663416
-- alan.turing@sms.com  / teacher123 -> cde383eee8ee7a4400adf7a15f716f179a2eb97646b37e089eb8d6d04e663416
-- alice@sms.com       / student123 -> 703b0a3d6ad75b649a28adde7d83c6251da457549263bc7ff45ec709b0a8448b
-- bob@sms.com         / student123 -> 703b0a3d6ad75b649a28adde7d83c6251da457549263bc7ff45ec709b0a8448b

INSERT INTO users (id, name, email, password_hash, role) VALUES
(1, 'Super Admin', 'admin@sms.com', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', 'ADMIN'),
(2, 'Dr. Grace Hopper', 'grace.hopper@sms.com', 'cde383eee8ee7a4400adf7a15f716f179a2eb97646b37e089eb8d6d04e663416', 'TEACHER'),
(3, 'Prof. Alan Turing', 'alan.turing@sms.com', 'cde383eee8ee7a4400adf7a15f716f179a2eb97646b37e089eb8d6d04e663416', 'TEACHER'),
(4, 'Alice Vance', 'alice@sms.com', '703b0a3d6ad75b649a28adde7d83c6251da457549263bc7ff45ec709b0a8448b', 'STUDENT'),
(5, 'Bob Carter', 'bob@sms.com', '703b0a3d6ad75b649a28adde7d83c6251da457549263bc7ff45ec709b0a8448b', 'STUDENT')
ON DUPLICATE KEY UPDATE id=id;

-- Seed Teachers
INSERT INTO teachers (id, user_id, department, qualification) VALUES
(1, 2, 'Computer Science', 'Ph.D. in Computer Science'),
(2, 3, 'Data Science', 'Ph.D. in Mathematics')
ON DUPLICATE KEY UPDATE id=id;

-- Seed Students
INSERT INTO students (id, user_id, roll_number, department, year, phone, address) VALUES
(1, 4, 'CS2024-001', 'Computer Science', 2, '+15550192834', '123 Academic Way, Boston, MA'),
(2, 5, 'DS2024-002', 'Data Science', 2, '+15550149821', '456 Tech Drive, Boston, MA')
ON DUPLICATE KEY UPDATE id=id;

-- Seed Courses
INSERT INTO courses (id, name, code, department, credits, teacher_id) VALUES
(1, 'Introduction to Computer Science', 'CS-101', 'Computer Science', 4, 1),
(2, 'Data Structures & Algorithms', 'CS-202', 'Computer Science', 4, 2),
(3, 'Practical Machine Learning', 'DS-301', 'Data Science', 4, 1)
ON DUPLICATE KEY UPDATE id=id;

-- Seed Enrollments
INSERT INTO enrollments (id, student_id, course_id) VALUES
(1, 1, 1),
(2, 1, 2),
(3, 2, 3)
ON DUPLICATE KEY UPDATE id=id;

-- Seed Attendance logs
INSERT INTO attendance (id, student_id, course_id, date, status) VALUES
(1, 1, 1, '2026-06-15', 'PRESENT'),
(2, 1, 1, '2026-06-16', 'PRESENT'),
(3, 1, 2, '2026-06-15', 'LATE'),
(4, 2, 3, '2026-06-15', 'ABSENT')
ON DUPLICATE KEY UPDATE id=id;

-- Seed Marks
INSERT INTO marks (id, student_id, course_id, exam_type, marks_obtained, max_marks) VALUES
(1, 1, 1, 'Internal', 8.50, 10.00),
(2, 1, 1, 'Midterm', 36.00, 40.00),
(3, 1, 1, 'Final', 45.00, 50.00),
(4, 2, 3, 'Midterm', 30.00, 40.00)
ON DUPLICATE KEY UPDATE id=id;

-- Seed Fees
INSERT INTO fees (id, student_id, semester, amount, due_date, paid_date, status) VALUES
(1, 1, 3, 2500.00, '2026-08-30', NULL, 'UNPAID'),
(2, 2, 3, 2800.00, '2026-05-15', '2026-05-10', 'PAID')
ON DUPLICATE KEY UPDATE id=id;
