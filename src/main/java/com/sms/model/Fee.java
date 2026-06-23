package com.sms.model;

import java.sql.Date;

/**
 * Model class representing Student Semester Fees.
 */
public class Fee {
    private int id;
    private int studentId;
    private int semester;
    private double amount;
    private Date dueDate;
    private Date paidDate;
    private String status; // 'PAID', 'UNPAID', 'OVERDUE'

    // Helper fields for UI rendering
    private String studentName;
    private String rollNumber;

    public Fee() {}

    /**
     * Business Logic: Auto-resolves status to OVERDUE if the due date has passed
     * and the status is still UNPAID.
     * @return current status
     */
    public String getStatus() {
        if ("UNPAID".equalsIgnoreCase(status) && dueDate != null) {
            java.util.Date today = new java.util.Date();
            // Compare dates ignoring times
            if (dueDate.before(today)) {
                return "OVERDUE";
            }
        }
        return status;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getStudentId() {
        return studentId;
    }

    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }

    public int getSemester() {
        return semester;
    }

    public void setSemester(int semester) {
        this.semester = semester;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public Date getDueDate() {
        return dueDate;
    }

    public void setDueDate(Date dueDate) {
        this.dueDate = dueDate;
    }

    public Date getPaidDate() {
        return paidDate;
    }

    public void setPaidDate(Date paidDate) {
        this.paidDate = paidDate;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getStudentName() {
        return studentName;
    }

    public void setStudentName(String studentName) {
        this.studentName = studentName;
    }

    public String getRollNumber() {
        return rollNumber;
    }

    public void setRollNumber(String rollNumber) {
        this.rollNumber = rollNumber;
    }
}
