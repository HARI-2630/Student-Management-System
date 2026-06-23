package com.sms.model;

/**
 * Model class representing academic evaluation Marks.
 */
public class Marks {
    private int id;
    private int studentId;
    private int courseId;
    private String examType; // e.g. Internal, Midterm, Final
    private double marksObtained;
    private double maxMarks;

    // Helper fields for UI rendering
    private String studentName;
    private String rollNumber;
    private String courseName;
    private String courseCode;

    public Marks() {}

    /**
     * Business Logic: Calculates GPA as (marksObtained / maxMarks) * 10.0
     * Rounded to 2 decimal places.
     * @return GPA value out of 10.0
     */
    public double getGpa() {
        if (maxMarks <= 0) {
            return 0.0;
        }
        double calculatedGpa = (marksObtained / maxMarks) * 10.0;
        return Math.round(calculatedGpa * 100.0) / 100.0;
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

    public int getCourseId() {
        return courseId;
    }

    public void setCourseId(int courseId) {
        this.courseId = courseId;
    }

    public String getExamType() {
        return examType;
    }

    public void setExamType(String examType) {
        this.examType = examType;
    }

    public double getMarksObtained() {
        return marksObtained;
    }

    public void setMarksObtained(double marksObtained) {
        this.marksObtained = marksObtained;
    }

    public double getMaxMarks() {
        return maxMarks;
    }

    public void setMaxMarks(double maxMarks) {
        this.maxMarks = maxMarks;
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

    public String getCourseName() {
        return courseName;
    }

    public void setCourseName(String courseName) {
        this.courseName = courseName;
    }

    public String getCourseCode() {
        return courseCode;
    }

    public void setCourseCode(String courseCode) {
        this.courseCode = courseCode;
    }
}
