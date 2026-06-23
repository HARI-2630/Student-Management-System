// seedData.js - Default mockup data for Student Management System
// Bound to window global for easy access without requiring ES modules over file:// protocol

window.StudentManagementSeedData = {
  courses: [
    {
      id: "CRS001",
      code: "CS-101",
      name: "Introduction to Computer Science",
      department: "Computer Science",
      instructor: "Dr. Evelyn Harris",
      credits: 4,
      capacity: 35
    },
    {
      id: "CRS002",
      code: "DS-301",
      name: "Practical Machine Learning",
      department: "Data Science",
      instructor: "Dr. Grace Hopper",
      credits: 4,
      capacity: 25
    },
    {
      id: "CRS003",
      code: "CS-202",
      name: "Data Structures & Algorithms",
      department: "Computer Science",
      instructor: "Prof. Alan Turing",
      credits: 4,
      capacity: 30
    },
    {
      id: "CRS004",
      code: "EE-110",
      name: "Basic Electronics & Circuits",
      department: "Electrical Engineering",
      instructor: "Dr. Nikola Tesla",
      credits: 3,
      capacity: 20
    },
    {
      id: "CRS005",
      code: "MATH-150",
      name: "Calculus & Linear Algebra",
      department: "Mathematics",
      instructor: "Prof. Isaac Newton",
      credits: 4,
      capacity: 40
    },
    {
      id: "CRS006",
      code: "BUS-210",
      name: "Principles of Management",
      department: "Business Administration",
      instructor: "Prof. Peter Drucker",
      credits: 3,
      capacity: 45
    }
  ],

  students: [
    {
      id: "STU001",
      name: "Alice Vance",
      email: "alice.vance@university.edu",
      phone: "+1 (555) 019-2834",
      enrollmentDate: "2024-09-01",
      department: "Computer Science",
      status: "Active",
      bio: "Aspiring software engineer interested in full-stack web applications and UI design."
    },
    {
      id: "STU002",
      name: "Benjamin Carter",
      email: "b.carter@university.edu",
      phone: "+1 (555) 014-9821",
      enrollmentDate: "2024-09-01",
      department: "Data Science",
      status: "Active",
      bio: "Enthusiastic about neural networks, deep learning, and predictive modeling."
    },
    {
      id: "STU003",
      name: "Chloe Thompson",
      email: "chloe.t@university.edu",
      phone: "+1 (555) 012-7645",
      enrollmentDate: "2023-09-01",
      department: "Electrical Engineering",
      status: "Active",
      bio: "Focusing on embedded systems, IoT design, and renewable energy grids."
    },
    {
      id: "STU004",
      name: "David Kim",
      email: "david.kim@university.edu",
      phone: "+1 (555) 018-3562",
      enrollmentDate: "2025-01-15",
      department: "Computer Science",
      status: "Active",
      bio: "Freshman exploring algorithms and competitive programming."
    },
    {
      id: "STU005",
      name: "Elena Rostova",
      email: "e.rostova@university.edu",
      phone: "+1 (555) 011-4928",
      enrollmentDate: "2023-09-01",
      department: "Mathematics",
      status: "Active",
      bio: "Fascinated by number theory and cryptographic algorithms."
    },
    {
      id: "STU006",
      name: "Felix Martinez",
      email: "felix.m@university.edu",
      phone: "+1 (555) 015-8293",
      enrollmentDate: "2024-09-01",
      department: "Business Administration",
      status: "Active",
      bio: "Focusing on tech-startup management and venture capital."
    },
    {
      id: "STU007",
      name: "Grace Patel",
      email: "g.patel@university.edu",
      phone: "+1 (555) 017-9102",
      enrollmentDate: "2022-09-01",
      department: "Computer Science",
      status: "Graduated",
      bio: "Recently graduated CS major who worked on high-performance computing systems."
    },
    {
      id: "STU008",
      name: "Henry Zhao",
      email: "henry.zhao@university.edu",
      phone: "+1 (555) 013-4456",
      enrollmentDate: "2024-01-10",
      department: "Data Science",
      status: "Suspended",
      bio: "On temporary medical leave. Returning next semester."
    },
    {
      id: "STU009",
      name: "Isabella Martinez",
      email: "isabella.m@university.edu",
      phone: "+1 (555) 016-5578",
      enrollmentDate: "2024-09-01",
      department: "Business Administration",
      status: "Active",
      bio: "Interested in marketing analytics and consumer behavior."
    },
    {
      id: "STU010",
      name: "Jack Harrison",
      email: "jack.h@university.edu",
      phone: "+1 (555) 010-8823",
      enrollmentDate: "2025-01-15",
      department: "Electrical Engineering",
      status: "Active",
      bio: "Hobbyist roboticist and hardware designer."
    }
  ],

  enrollments: [
    // STU001: Alice Vance (CS)
    { studentId: "STU001", courseId: "CRS001", dateEnrolled: "2024-09-05" },
    { studentId: "STU001", courseId: "CRS003", dateEnrolled: "2024-09-05" },
    { studentId: "STU001", courseId: "CRS005", dateEnrolled: "2024-09-05" },
    
    // STU002: Benjamin Carter (DS)
    { studentId: "STU002", courseId: "CRS002", dateEnrolled: "2024-09-06" },
    { studentId: "STU002", courseId: "CRS003", dateEnrolled: "2024-09-06" },
    { studentId: "STU002", courseId: "CRS005", dateEnrolled: "2024-09-06" },

    // STU003: Chloe Thompson (EE)
    { studentId: "STU003", courseId: "CRS004", dateEnrolled: "2023-09-04" },
    { studentId: "STU003", courseId: "CRS005", dateEnrolled: "2023-09-04" },

    // STU004: David Kim (CS)
    { studentId: "STU004", courseId: "CRS001", dateEnrolled: "2025-01-18" },
    { studentId: "STU004", courseId: "CRS005", dateEnrolled: "2025-01-18" },

    // STU005: Elena Rostova (Math)
    { studentId: "STU005", courseId: "CRS003", dateEnrolled: "2023-09-05" },
    { studentId: "STU005", courseId: "CRS005", dateEnrolled: "2023-09-05" },

    // STU006: Felix Martinez (Business)
    { studentId: "STU006", courseId: "CRS006", dateEnrolled: "2024-09-07" },
    { studentId: "STU006", courseId: "CRS005", dateEnrolled: "2024-09-07" },

    // STU007: Grace Patel (CS - Graduated)
    { studentId: "STU007", courseId: "CRS001", dateEnrolled: "2022-09-05" },
    { studentId: "STU007", courseId: "CRS003", dateEnrolled: "2022-09-05" },

    // STU008: Henry Zhao (DS - Suspended)
    { studentId: "STU008", courseId: "CRS002", dateEnrolled: "2024-01-12" },

    // STU009: Isabella Martinez (Business)
    { studentId: "STU009", courseId: "CRS006", dateEnrolled: "2024-09-07" },

    // STU010: Jack Harrison (EE)
    { studentId: "STU010", courseId: "CRS004", dateEnrolled: "2025-01-19" },
    { studentId: "STU010", courseId: "CRS005", dateEnrolled: "2025-01-19" }
  ],

  grades: [
    // Alice Vance CS-101
    { studentId: "STU001", courseId: "CRS001", assignment: "Midterm Exam", score: 92, maxScore: 100 },
    { studentId: "STU001", courseId: "CRS001", assignment: "Final Project", score: 96, maxScore: 100 },
    { studentId: "STU001", courseId: "CRS001", assignment: "Quizzes Average", score: 88, maxScore: 100 },
    // Alice Vance CS-202
    { studentId: "STU001", courseId: "CRS003", assignment: "Midterm Exam", score: 85, maxScore: 100 },
    { studentId: "STU001", courseId: "CRS003", assignment: "Programming Assignment 1", score: 90, maxScore: 100 },
    // Alice Vance MATH-150
    { studentId: "STU001", courseId: "CRS005", assignment: "Midterm Exam", score: 78, maxScore: 100 },

    // Benjamin Carter DS-301
    { studentId: "STU002", courseId: "CRS002", assignment: "Kaggle Competition", score: 94, maxScore: 100 },
    { studentId: "STU002", courseId: "CRS002", assignment: "Term Paper", score: 89, maxScore: 100 },
    // Benjamin Carter CS-202
    { studentId: "STU002", courseId: "CRS003", assignment: "Midterm Exam", score: 88, maxScore: 100 },

    // Chloe Thompson EE-110
    { studentId: "STU003", courseId: "CRS004", assignment: "Circuit Design Lab", score: 95, maxScore: 100 },
    { studentId: "STU003", courseId: "CRS004", assignment: "Final Exam", score: 87, maxScore: 100 },

    // David Kim CS-101
    { studentId: "STU004", courseId: "CRS001", assignment: "Quiz 1", score: 75, maxScore: 100 },

    // Elena Rostova MATH-150
    { studentId: "STU005", courseId: "CRS005", assignment: "Midterm Exam", score: 98, maxScore: 100 },
    { studentId: "STU005", courseId: "CRS005", assignment: "Proof Homework", score: 100, maxScore: 100 },

    // Felix Martinez BUS-210
    { studentId: "STU006", courseId: "CRS006", assignment: "Case Study 1", score: 82, maxScore: 100 },
    { studentId: "STU006", courseId: "CRS006", assignment: "Group Presentation", score: 90, maxScore: 100 },

    // Grace Patel CS-101 (Graduated)
    { studentId: "STU007", courseId: "CRS001", assignment: "Final Grade", score: 95, maxScore: 100 },
    // Grace Patel CS-202
    { studentId: "STU007", courseId: "CRS003", assignment: "Final Grade", score: 93, maxScore: 100 },

    // Henry Zhao DS-301 (Suspended)
    { studentId: "STU008", courseId: "CRS002", assignment: "Quiz 1", score: 60, maxScore: 100 }
  ],

  attendance: [
    // STU001: Alice Vance (CRS001)
    { studentId: "STU001", courseId: "CRS001", date: "2026-06-15", status: "Present" },
    { studentId: "STU001", courseId: "CRS001", date: "2026-06-17", status: "Present" },
    { studentId: "STU001", courseId: "CRS001", date: "2026-06-19", status: "Late" },
    { studentId: "STU001", courseId: "CRS001", date: "2026-06-22", status: "Present" },
    
    // STU001: Alice Vance (CRS003)
    { studentId: "STU001", courseId: "CRS003", date: "2026-06-16", status: "Present" },
    { studentId: "STU001", courseId: "CRS003", date: "2026-06-18", status: "Absent" },
    { studentId: "STU001", courseId: "CRS003", date: "2026-06-23", status: "Present" },

    // STU002: Benjamin Carter (CRS002)
    { studentId: "STU002", courseId: "CRS002", date: "2026-06-15", status: "Present" },
    { studentId: "STU002", courseId: "CRS002", date: "2026-06-17", status: "Present" },
    { studentId: "STU002", courseId: "CRS002", date: "2026-06-19", status: "Present" },
    { studentId: "STU002", courseId: "CRS002", date: "2026-06-22", status: "Present" },

    // STU003: Chloe Thompson (CRS004)
    { studentId: "STU003", courseId: "CRS004", date: "2026-06-15", status: "Present" },
    { studentId: "STU003", courseId: "CRS004", date: "2026-06-18", status: "Present" },
    { studentId: "STU003", courseId: "CRS004", date: "2026-06-22", status: "Late" },

    // STU004: David Kim (CRS001)
    { studentId: "STU004", courseId: "CRS001", date: "2026-06-15", status: "Absent" },
    { studentId: "STU004", courseId: "CRS001", date: "2026-06-17", status: "Present" },
    { studentId: "STU004", courseId: "CRS001", date: "2026-06-19", status: "Present" },
    { studentId: "STU004", courseId: "CRS001", date: "2026-06-22", status: "Present" }
  ]
};
