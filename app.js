// app.js - Main logic for AuraSMS Student Management System SPA
// Handles state management, local storage, routing, charts, modals, and CRUD operations

// STATE MANAGEMENT
const STATE = {
  students: [],
  courses: [],
  enrollments: [],
  grades: [],
  attendance: [],
  activities: []
};

// INITIALIZE STATE
function initApp() {
  loadData();
  setupEventListeners();
  initTheme();
  
  // Set default date for attendance
  const dateInput = document.getElementById("attendance-date-input");
  if (dateInput) {
    const today = new Date().toISOString().split('T')[0];
    dateInput.value = today;
  }
  
  // Populate first dropdowns & render dashboard
  populateDropdowns();
  navigateToView("dashboard");
  showToast("Welcome to AuraSMS! System initialized.", "success");
}

// LOCAL STORAGE PERSISTENCE
function loadData() {
  const localStudents = localStorage.getItem("aura_students");
  const localCourses = localStorage.getItem("aura_courses");
  const localEnrollments = localStorage.getItem("aura_enrollments");
  const localGrades = localStorage.getItem("aura_grades");
  const localAttendance = localStorage.getItem("aura_attendance");
  const localActivities = localStorage.getItem("aura_activities");

  if (localStudents && localCourses) {
    STATE.students = JSON.parse(localStudents);
    STATE.courses = JSON.parse(localCourses);
    STATE.enrollments = JSON.parse(localEnrollments) || [];
    STATE.grades = JSON.parse(localGrades) || [];
    STATE.attendance = JSON.parse(localAttendance) || [];
    STATE.activities = JSON.parse(localActivities) || [];
  } else {
    // Seed database
    if (window.StudentManagementSeedData) {
      STATE.students = window.StudentManagementSeedData.students;
      STATE.courses = window.StudentManagementSeedData.courses;
      STATE.enrollments = window.StudentManagementSeedData.enrollments;
      STATE.grades = window.StudentManagementSeedData.grades;
      STATE.attendance = window.StudentManagementSeedData.attendance;
      
      STATE.activities = [
        { id: "act_1", type: "success", text: "Database seeded with initial university records.", time: new Date(Date.now() - 3600000).toLocaleString() },
        { id: "act_2", type: "primary", text: "Student directory loaded.", time: new Date().toLocaleString() }
      ];
      
      saveData();
    } else {
      console.error("Seed data not found!");
    }
  }
}

function saveData() {
  localStorage.setItem("aura_students", JSON.stringify(STATE.students));
  localStorage.setItem("aura_courses", JSON.stringify(STATE.courses));
  localStorage.setItem("aura_enrollments", JSON.stringify(STATE.enrollments));
  localStorage.setItem("aura_grades", JSON.stringify(STATE.grades));
  localStorage.setItem("aura_attendance", JSON.stringify(STATE.attendance));
  localStorage.setItem("aura_activities", JSON.stringify(STATE.activities));
}

function logActivity(text, type = "primary") {
  const newActivity = {
    id: "act_" + Date.now(),
    type: type,
    text: text,
    time: new Date().toLocaleString()
  };
  STATE.activities.unshift(newActivity);
  // Keep only last 50 activities
  if (STATE.activities.length > 50) {
    STATE.activities.pop();
  }
  saveData();
  
  // Re-render recent activity if dashboard is visible
  if (document.getElementById("dashboard-view").classList.contains("active")) {
    renderRecentActivities();
  }
}

// UTILITIES
function showToast(message, type = "primary") {
  const container = document.getElementById("toast-container");
  if (!container) return;
  
  const toast = document.createElement("div");
  toast.className = `toast ${type}`;
  
  // Custom icons based on type
  let icon = `
    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
      <circle cx="12" cy="12" r="10"/><line x1="12" y1="16" x2="12" y2="12"/><line x1="12" y1="8" x2="12.01" y2="8"/>
    </svg>
  `;
  if (type === "success") {
    icon = `
      <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
        <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/>
      </svg>
    `;
  } else if (type === "danger") {
    icon = `
      <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
        <circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/>
      </svg>
    `;
  } else if (type === "warning") {
    icon = `
      <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
        <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/>
      </svg>
    `;
  }
  
  toast.innerHTML = `${icon}<span>${message}</span>`;
  container.appendChild(toast);
  
  // Fade and remove
  setTimeout(() => {
    toast.style.transform = "translateX(100%)";
    toast.style.opacity = "0";
    setTimeout(() => {
      toast.remove();
    }, 300);
  }, 3500);
}

// VIEW NAVIGATION
function navigateToView(viewId) {
  // Hide all views, activate menu links
  document.querySelectorAll(".content-view").forEach(view => {
    view.classList.remove("active");
  });
  document.querySelectorAll(".sidebar-menu .menu-item").forEach(item => {
    item.classList.remove("active");
  });
  
  // Show target view
  const targetView = document.getElementById(`${viewId}-view`);
  if (targetView) {
    targetView.classList.add("active");
  }
  
  const menuItem = document.querySelector(`.sidebar-menu [data-view="${viewId}"]`);
  if (menuItem) {
    menuItem.classList.add("active");
  }
  
  // Update Title / Subtitle
  const viewTitle = document.getElementById("current-view-title");
  const viewSubtitle = document.getElementById("current-view-subtitle");
  
  switch(viewId) {
    case "dashboard":
      viewTitle.textContent = "Dashboard Overview";
      viewSubtitle.textContent = "Welcome back! Here is the latest university summary.";
      renderDashboard();
      break;
    case "students":
      viewTitle.textContent = "Student Directory";
      viewSubtitle.textContent = "Search, filter, view details, or add new students to the platform.";
      renderStudents();
      break;
    case "courses":
      viewTitle.textContent = "Course Offerings";
      viewSubtitle.textContent = "Explore active curriculum modules, capacities, and syllabus details.";
      renderCourses();
      break;
    case "grades":
      viewTitle.textContent = "Performance Ledger";
      viewSubtitle.textContent = "Log course assignment scores and inspect student grade averages.";
      renderGrades();
      break;
    case "attendance":
      viewTitle.textContent = "Attendance Tracker";
      viewSubtitle.textContent = "Mark daily classroom logs and audit student attendance stats.";
      renderAttendance();
      break;
  }
}

// THEME SYSTEM
function initTheme() {
  const savedTheme = localStorage.getItem("aura_theme") || "dark";
  document.documentElement.setAttribute("data-theme", savedTheme);
}

function toggleTheme() {
  const currentTheme = document.documentElement.getAttribute("data-theme");
  const newTheme = currentTheme === "dark" ? "light" : "dark";
  document.documentElement.setAttribute("data-theme", newTheme);
  localStorage.setItem("aura_theme", newTheme);
  showToast(`Switched to ${newTheme.toUpperCase()} theme mode.`, "primary");
}

// DROPDOWN POPULATOR
function populateDropdowns() {
  // Populate Grades view selects
  const courseSel = document.getElementById("grades-course-select");
  const studentSel = document.getElementById("grades-student-select");
  const modalStudentSel = document.getElementById("grade-student-select-modal");
  const modalCourseSel = document.getElementById("grade-course-select-modal");
  const attCourseSel = document.getElementById("attendance-course-select");
  
  if (courseSel) {
    courseSel.innerHTML = '<option value="All">All Courses</option>' + 
      STATE.courses.map(c => `<option value="${c.id}">${c.code} - ${c.name}</option>`).join('');
  }
  
  if (studentSel) {
    studentSel.innerHTML = '<option value="All">All Students</option>' +
      STATE.students.map(s => `<option value="${s.id}">${s.name} (${s.id})</option>`).join('');
  }
  
  if (modalStudentSel) {
    modalStudentSel.innerHTML = STATE.students.map(s => `<option value="${s.id}">${s.name} (${s.id})</option>`).join('');
  }
  
  if (modalCourseSel) {
    modalCourseSel.innerHTML = STATE.courses.map(c => `<option value="${c.id}">${c.code} - ${c.name}</option>`).join('');
  }
  
  if (attCourseSel) {
    attCourseSel.innerHTML = STATE.courses.map(c => `<option value="${c.id}">${c.code} - ${c.name}</option>`).join('');
  }
}

// MODAL CONTROLLERS
window.openModal = function(modalId) {
  const modal = document.getElementById(modalId);
  if (modal) {
    modal.classList.add("active");
  }
};

window.closeModal = function(modalId) {
  const modal = document.getElementById(modalId);
  if (modal) {
    modal.classList.remove("active");
  }
};

// CALCULATE SINGLE STUDENT GPA
function calculateStudentGPA(studentId) {
  const studentGrades = STATE.grades.filter(g => g.studentId === studentId);
  if (studentGrades.length === 0) return 0;
  
  // Group grades by course
  const courseGroups = {};
  studentGrades.forEach(g => {
    if (!courseGroups[g.courseId]) {
      courseGroups[g.courseId] = [];
    }
    courseGroups[g.courseId].push(g);
  });
  
  let totalGradePoints = 0;
  let totalCourses = 0;
  
  for (const courseId in courseGroups) {
    const grades = courseGroups[courseId];
    const avgScore = grades.reduce((acc, g) => acc + (g.score / g.maxScore), 0) / grades.length * 100;
    
    // Convert percentage to standard GPA points
    let gp = 0;
    if (avgScore >= 90) gp = 4.0;
    else if (avgScore >= 80) gp = 3.0;
    else if (avgScore >= 70) gp = 2.0;
    else if (avgScore >= 60) gp = 1.0;
    else gp = 0.0;
    
    totalGradePoints += gp;
    totalCourses++;
  }
  
  return totalCourses === 0 ? 0 : parseFloat((totalGradePoints / totalCourses).toFixed(2));
}

// CALCULATE SINGLE STUDENT ATTENDANCE RATE
function calculateStudentAttendanceRate(studentId) {
  const studentLogs = STATE.attendance.filter(a => a.studentId === studentId);
  if (studentLogs.length === 0) return 100; // Perfect attendance if no records
  
  let score = 0;
  studentLogs.forEach(l => {
    if (l.status === "Present") score += 1;
    else if (l.status === "Late") score += 0.5;
  });
  
  return Math.round((score / studentLogs.length) * 100);
}

// ==========================================
// RENDERING CONTROLLERS
// ==========================================

// 1. DASHBOARD VIEW
function renderDashboard() {
  // Update stats
  document.getElementById("dash-total-students").textContent = STATE.students.length;
  document.getElementById("dash-active-courses").textContent = STATE.courses.length;
  
  // Overall Avg Attendance
  if (STATE.attendance.length > 0) {
    let score = 0;
    STATE.attendance.forEach(a => {
      if (a.status === "Present") score += 1;
      else if (a.status === "Late") score += 0.5;
    });
    const avgAtt = Math.round((score / STATE.attendance.length) * 100);
    document.getElementById("dash-avg-attendance").textContent = `${avgAtt}%`;
  } else {
    document.getElementById("dash-avg-attendance").textContent = "100%";
  }
  
  // Overall Avg GPA
  let totalGPAs = 0;
  let activeStudentCount = 0;
  STATE.students.forEach(s => {
    if (s.status !== "Graduated") {
      const gpa = calculateStudentGPA(s.id);
      totalGPAs += gpa;
      activeStudentCount++;
    }
  });
  const avgGPA = activeStudentCount === 0 ? 0.00 : (totalGPAs / activeStudentCount).toFixed(2);
  document.getElementById("dash-avg-gpa").textContent = avgGPA;
  
  // Render GPA Distribution Chart (pure bars)
  renderGPADistributionChart();
  
  // Render Department Donut Chart
  renderDepartmentDonutChart();
  
  // Render Activity Log
  renderRecentActivities();
}

function renderGPADistributionChart() {
  const container = document.getElementById("gpa-bar-chart");
  if (!container) return;
  
  // Count grade categories
  const gradeCounts = { A: 0, B: 0, C: 0, D: 0, F: 0 };
  
  STATE.students.forEach(s => {
    const gpa = calculateStudentGPA(s.id);
    if (gpa >= 3.5) gradeCounts.A++;
    else if (gpa >= 2.5) gradeCounts.B++;
    else if (gpa >= 1.5) gradeCounts.C++;
    else if (gpa >= 0.5) gradeCounts.D++;
    else gradeCounts.F++;
  });
  
  const categories = [
    { label: "A (3.5 - 4.0)", val: gradeCounts.A },
    { label: "B (2.5 - 3.4)", val: gradeCounts.B },
    { label: "C (1.5 - 2.4)", val: gradeCounts.C },
    { label: "D (0.5 - 1.4)", val: gradeCounts.D },
    { label: "F (0.0 - 0.4)", val: gradeCounts.F }
  ];
  
  const maxVal = Math.max(...categories.map(c => c.val), 1);
  
  container.innerHTML = categories.map(cat => {
    const pct = (cat.val / maxVal) * 90; // scale up to 90% for visual aesthetics
    return `
      <div class="bar-column">
        <div class="bar-wrapper">
          <div class="bar-fill" style="height: ${pct}%;"></div>
          <div class="bar-tooltip">${cat.val} Student${cat.val !== 1 ? 's' : ''}</div>
        </div>
        <div class="bar-label">${cat.label}</div>
      </div>
    `;
  }).join('');
}

function renderDepartmentDonutChart() {
  const deptCounts = {};
  let total = 0;
  
  STATE.students.forEach(s => {
    if (s.status === "Active") {
      deptCounts[s.department] = (deptCounts[s.department] || 0) + 1;
      total++;
    }
  });
  
  document.getElementById("donut-center-total").textContent = total;
  
  // We'll distribute segments dynamically
  // CS, DS, EE, Other
  const csCount = deptCounts["Computer Science"] || 0;
  const dsCount = deptCounts["Data Science"] || 0;
  const eeCount = deptCounts["Electrical Engineering"] || 0;
  const otherCount = total - (csCount + dsCount + eeCount);
  
  const csPct = total === 0 ? 0 : (csCount / total) * 100;
  const dsPct = total === 0 ? 0 : (dsCount / total) * 100;
  const eePct = total === 0 ? 0 : (eeCount / total) * 100;
  const otherPct = total === 0 ? 0 : (otherCount / total) * 100;
  
  // Set stroke dash arrays
  const csSeg = document.getElementById("donut-seg-cs");
  const dsSeg = document.getElementById("donut-seg-ds");
  const eeSeg = document.getElementById("donut-seg-ee");
  const otherSeg = document.getElementById("donut-seg-other");
  
  let offset = 0;
  
  if (csSeg) {
    csSeg.setAttribute("stroke-dasharray", `${csPct} ${100 - csPct}`);
    csSeg.setAttribute("stroke-dashoffset", `${100 - offset}`);
    offset += csPct;
  }
  
  if (dsSeg) {
    dsSeg.setAttribute("stroke-dasharray", `${dsPct} ${100 - dsPct}`);
    dsSeg.setAttribute("stroke-dashoffset", `${100 - offset}`);
    offset += dsPct;
  }
  
  if (eeSeg) {
    eeSeg.setAttribute("stroke-dasharray", `${eePct} ${100 - eePct}`);
    eeSeg.setAttribute("stroke-dashoffset", `${100 - offset}`);
    offset += eePct;
  }
  
  if (otherSeg) {
    otherSeg.setAttribute("stroke-dasharray", `${otherPct} ${100 - otherPct}`);
    otherSeg.setAttribute("stroke-dashoffset", `${100 - offset}`);
  }
  
  // Render legend
  const legendContainer = document.getElementById("dept-legend");
  if (legendContainer) {
    const list = [
      { name: "Computer Science", count: csCount, color: "var(--primary)" },
      { name: "Data Science", count: dsCount, color: "var(--secondary)" },
      { name: "Electrical Eng.", count: eeCount, color: "var(--accent)" },
      { name: "Other Depts", count: otherCount, color: "var(--warning)" }
    ];
    
    legendContainer.innerHTML = list.map(item => `
      <li class="legend-item">
        <div class="legend-color-label">
          <span class="legend-dot" style="background-color: ${item.color};"></span>
          <span>${item.name}</span>
        </div>
        <span class="legend-count">${item.count}</span>
      </li>
    `).join('');
  }
}

function renderRecentActivities() {
  const container = document.getElementById("recent-activities");
  if (!container) return;
  
  if (STATE.activities.length === 0) {
    container.innerHTML = `<li class="activity-text" style="color: var(--text-muted); text-align: center; padding: 40px 0;">No system logs available.</li>`;
    return;
  }
  
  container.innerHTML = STATE.activities.slice(0, 5).map(act => `
    <li class="activity-item">
      <span class="activity-dot ${act.type}"></span>
      <div class="activity-info">
        <span class="activity-text">${act.text}</span>
        <span class="activity-time">${act.time}</span>
      </div>
    </li>
  `).join('');
}

// 2. STUDENTS VIEW
function renderStudents() {
  const tableBody = document.getElementById("students-table-body");
  if (!tableBody) return;
  
  const searchVal = document.getElementById("search-student").value.toLowerCase();
  const deptFilter = document.getElementById("filter-department").value;
  const statusFilter = document.getElementById("filter-status").value;
  
  // Filter students list
  const filtered = STATE.students.filter(student => {
    const matchesSearch = student.name.toLowerCase().includes(searchVal) || 
                          student.email.toLowerCase().includes(searchVal) || 
                          student.id.toLowerCase().includes(searchVal);
                          
    const matchesDept = deptFilter === "All" || student.department === deptFilter;
    const matchesStatus = statusFilter === "All" || student.status === statusFilter;
    
    return matchesSearch && matchesDept && matchesStatus;
  });
  
  if (filtered.length === 0) {
    tableBody.innerHTML = `<tr><td colspan="6" style="text-align: center; color: var(--text-muted); padding: 40px 0;">No students match the criteria.</td></tr>`;
    return;
  }
  
  tableBody.innerHTML = filtered.map(student => {
    const badgeClass = `badge badge-${student.status.toLowerCase()}`;
    const initials = student.name.split(' ').map(n => n[0]).join('').slice(0, 2).toUpperCase();
    
    return `
      <tr>
        <td style="font-weight: 700; font-family: var(--font-display);">${student.id}</td>
        <td>
          <div class="table-profile">
            <div class="table-avatar">${initials}</div>
            <div class="table-profile-info">
              <span class="table-profile-name">${student.name}</span>
              <span class="table-profile-sub">${student.email}</span>
            </div>
          </div>
        </td>
        <td><span class="badge badge-dept">${student.department}</span></td>
        <td>${student.enrollmentDate}</td>
        <td><span class="${badgeClass}">${student.status}</span></td>
        <td>
          <div class="action-buttons" style="justify-content: flex-end;">
            <button class="action-btn" title="View Profile Detail" onclick="viewStudentDetails('${student.id}')">
              <svg viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
            </button>
            <button class="action-btn edit" title="Edit Student Info" onclick="editStudent('${student.id}')">
              <svg viewBox="0 0 24 24"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 1 1 3 3L12 15l-4 1 1-4z"/></svg>
            </button>
            <button class="action-btn delete" title="Delete Student" onclick="deleteStudent('${student.id}')">
              <svg viewBox="0 0 24 24"><polyline points="3 6 5 6 21 6"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/><line x1="10" y1="11" x2="10" y2="17"/><line x1="14" y1="11" x2="14" y2="17"/></svg>
            </button>
          </div>
        </td>
      </tr>
    `;
  }).join('');
}

// 3. COURSES VIEW
function renderCourses() {
  const container = document.getElementById("courses-grid-container");
  if (!container) return;
  
  if (STATE.courses.length === 0) {
    container.innerHTML = `<div style="grid-column: span 3; text-align: center; color: var(--text-muted); padding: 50px 0;">No active courses configured. Create one to begin.</div>`;
    return;
  }
  
  container.innerHTML = STATE.courses.map(c => {
    // Count enrolled students
    const enCount = STATE.enrollments.filter(e => e.courseId === c.id).length;
    const capacityPct = Math.min(Math.round((enCount / c.capacity) * 100), 100);
    
    return `
      <div class="course-card glass-panel">
        <div class="course-header">
          <span class="course-code">${c.code}</span>
          <span class="badge badge-dept" style="margin: 0;">${c.credits} Credits</span>
        </div>
        <div style="flex-grow: 1;">
          <h4 class="course-name">${c.name}</h4>
          <span class="course-instructor">Instructor: <strong>${c.instructor}</strong></span>
        </div>
        
        <div style="display: flex; flex-direction: column; gap: 8px;">
          <div style="display: flex; justify-content: space-between; font-size: 0.75rem;">
            <span style="color: var(--text-muted);">Enrollment</span>
            <span style="font-weight: 600;">${enCount} / ${c.capacity} (${capacityPct}%)</span>
          </div>
          <div class="course-progress-bar">
            <div class="course-progress-fill" style="width: ${capacityPct}%;"></div>
          </div>
        </div>
        
        <div class="course-stats">
          <div class="course-stat-item">
            <span class="course-stat-label">Department</span>
            <span class="course-stat-value">${c.department}</span>
          </div>
          <div class="course-stat-item" style="text-align: right;">
            <span class="course-stat-label">Actions</span>
            <a href="#" onclick="quickEnrollStudent('${c.id}')" style="color: var(--primary); font-weight: 600; text-decoration: none; font-size: 0.8rem;">Enroll Student</a>
          </div>
        </div>
      </div>
    `;
  }).join('');
}

// 4. GRADES VIEW
function renderGrades() {
  const tableBody = document.getElementById("grades-table-body");
  if (!tableBody) return;
  
  const courseSel = document.getElementById("grades-course-select").value;
  const studentSel = document.getElementById("grades-student-select").value;
  
  const filtered = STATE.grades.filter(g => {
    const matchesCourse = courseSel === "All" || g.courseId === courseSel;
    const matchesStudent = studentSel === "All" || g.studentId === studentSel;
    return matchesCourse && matchesStudent;
  });
  
  if (filtered.length === 0) {
    tableBody.innerHTML = `<tr><td colspan="6" style="text-align: center; color: var(--text-muted); padding: 40px 0;">No grade records found. Add record to see evaluations.</td></tr>`;
    return;
  }
  
  tableBody.innerHTML = filtered.map((g, idx) => {
    const student = STATE.students.find(s => s.id === g.studentId) || { name: "Unknown" };
    const course = STATE.courses.find(c => c.id === g.courseId) || { code: "N/A" };
    const percentage = Math.round((g.score / g.maxScore) * 100);
    
    // Percentage color
    let colorClass = "var(--success)";
    if (percentage < 60) colorClass = "var(--danger)";
    else if (percentage < 80) colorClass = "var(--warning)";
    
    return `
      <tr>
        <td style="font-weight: 600; color: var(--text-primary);">${student.name} <span style="font-size: 0.75rem; color: var(--text-muted);">(${g.studentId})</span></td>
        <td><span class="course-code">${course.code}</span></td>
        <td>${g.assignment}</td>
        <td><strong>${g.score}</strong> / ${g.maxScore}</td>
        <td style="font-weight: 700; color: ${colorClass}">${percentage}%</td>
        <td>
          <div class="action-buttons" style="justify-content: flex-end;">
            <button class="action-btn delete" title="Delete Grade Record" onclick="deleteGrade(${idx})">
              <svg viewBox="0 0 24 24"><polyline points="3 6 5 6 21 6"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg>
            </button>
          </div>
        </td>
      </tr>
    `;
  }).join('');
}

// 5. ATTENDANCE VIEW
function renderAttendance() {
  const tableBody = document.getElementById("attendance-table-body");
  const countBadge = document.getElementById("attendance-count-badge");
  if (!tableBody) return;
  
  const courseId = document.getElementById("attendance-course-select").value;
  const dateVal = document.getElementById("attendance-date-input").value;
  
  if (!courseId) {
    tableBody.innerHTML = `<tr><td colspan="4" style="text-align: center; color: var(--text-muted); padding: 40px 0;">Configure courses to proceed.</td></tr>`;
    return;
  }
  
  // Find enrolled students
  const enrolledStudentIds = STATE.enrollments.filter(e => e.courseId === courseId).map(e => e.studentId);
  const enrolledStudents = STATE.students.filter(s => enrolledStudentIds.includes(s.id));
  
  countBadge.textContent = `${enrolledStudents.length} Enrolled`;
  
  if (enrolledStudents.length === 0) {
    tableBody.innerHTML = `<tr><td colspan="4" style="text-align: center; color: var(--text-muted); padding: 40px 0;">No students enrolled in this course.</td></tr>`;
    return;
  }
  
  tableBody.innerHTML = enrolledStudents.map(student => {
    // Current general attendance rate
    const totalRate = calculateStudentAttendanceRate(student.id);
    
    // Check if attendance record exists for this date/course/student
    const record = STATE.attendance.find(a => a.studentId === student.id && a.courseId === courseId && a.date === dateVal);
    const selectedStatus = record ? record.status : "Present";
    
    return `
      <tr>
        <td style="font-weight: 700; font-family: var(--font-display);">${student.id}</td>
        <td style="font-weight: 600; color: var(--text-primary);">${student.name}</td>
        <td><span class="badge badge-dept">Overall Rate: ${totalRate}%</span></td>
        <td>
          <div class="action-buttons" style="justify-content: flex-end;">
            <div class="attendance-radio-group">
              <input type="radio" id="att_${student.id}_p" name="att_${student.id}" value="Present" class="attendance-radio" ${selectedStatus === 'Present' ? 'checked' : ''}>
              <label for="att_${student.id}_p" class="attendance-label">Present</label>

              <input type="radio" id="att_${student.id}_l" name="att_${student.id}" value="Late" class="attendance-radio" ${selectedStatus === 'Late' ? 'checked' : ''}>
              <label for="att_${student.id}_l" class="attendance-label">Late</label>

              <input type="radio" id="att_${student.id}_a" name="att_${student.id}" value="Absent" class="attendance-radio" ${selectedStatus === 'Absent' ? 'checked' : ''}>
              <label for="att_${student.id}_a" class="attendance-label">Absent</label>
            </div>
          </div>
        </td>
      </tr>
    `;
  }).join('');
}


// ==========================================
// FORM SUBMISSIONS & CRUD CONTROLLERS
// ==========================================

// 1. ADD / EDIT STUDENT
window.handleStudentFormSubmit = function(e) {
  e.preventDefault();
  
  const action = document.getElementById("student-form-action").value;
  const studentId = document.getElementById("student-form-id").value;
  const name = document.getElementById("student-name").value.trim();
  const email = document.getElementById("student-email").value.trim();
  const phone = document.getElementById("student-phone").value.trim();
  const department = document.getElementById("student-dept").value;
  const status = document.getElementById("student-status").value;
  const bio = document.getElementById("student-bio").value.trim();
  
  if (action === "create") {
    // Generate new ID STUxxx
    const nextNum = STATE.students.length > 0 
      ? Math.max(...STATE.students.map(s => parseInt(s.id.replace("STU", "")))) + 1 
      : 1;
    const newId = "STU" + String(nextNum).padStart(3, '0');
    
    const newStudent = {
      id: newId,
      name,
      email,
      phone,
      enrollmentDate: new Date().toISOString().split('T')[0],
      department,
      status,
      bio
    };
    
    STATE.students.push(newStudent);
    logActivity(`Added new student ${name} (${newId}) in ${department}.`, "success");
    showToast(`Student ${name} successfully enrolled!`, "success");
  } else {
    // Update student
    const studentIdx = STATE.students.findIndex(s => s.id === studentId);
    if (studentIdx !== -1) {
      STATE.students[studentIdx].name = name;
      STATE.students[studentIdx].email = email;
      STATE.students[studentIdx].phone = phone;
      STATE.students[studentIdx].department = department;
      STATE.students[studentIdx].status = status;
      STATE.students[studentIdx].bio = bio;
      
      logActivity(`Updated info for student ${name} (${studentId}).`, "primary");
      showToast(`Student info updated successfully.`, "success");
    }
  }
  
  saveData();
  populateDropdowns();
  renderStudents();
  closeModal("student-modal");
  document.getElementById("student-form").reset();
};

window.editStudent = function(studentId) {
  const student = STATE.students.find(s => s.id === studentId);
  if (!student) return;
  
  document.getElementById("student-modal-title").textContent = "Edit Student Info";
  document.getElementById("student-form-action").value = "update";
  document.getElementById("student-form-id").value = studentId;
  
  document.getElementById("student-name").value = student.name;
  document.getElementById("student-email").value = student.email;
  document.getElementById("student-phone").value = student.phone || "";
  document.getElementById("student-dept").value = student.department;
  document.getElementById("student-status").value = student.status;
  document.getElementById("student-bio").value = student.bio || "";
  
  openModal("student-modal");
};

window.deleteStudent = function(studentId) {
  const student = STATE.students.find(s => s.id === studentId);
  if (!student) return;
  
  if (confirm(`Are you sure you want to delete student ${student.name} (${studentId})? This will wipe their grades, enrollments, and attendance history.`)) {
    // Wipe student
    STATE.students = STATE.students.filter(s => s.id !== studentId);
    // Wipe grades
    STATE.grades = STATE.grades.filter(g => g.studentId !== studentId);
    // Wipe enrollments
    STATE.enrollments = STATE.enrollments.filter(e => e.studentId !== studentId);
    // Wipe attendance
    STATE.attendance = STATE.attendance.filter(a => a.studentId !== studentId);
    
    logActivity(`Deleted student records for ${student.name} (${studentId}).`, "danger");
    showToast(`Deleted student ${student.name}.`, "danger");
    
    saveData();
    populateDropdowns();
    renderStudents();
  }
};

window.viewStudentDetails = function(studentId) {
  const student = STATE.students.find(s => s.id === studentId);
  if (!student) return;
  
  const gpa = calculateStudentGPA(studentId);
  const attendanceRate = calculateStudentAttendanceRate(studentId);
  
  // Find enrolled courses codes
  const courseIds = STATE.enrollments.filter(e => e.studentId === studentId).map(e => e.courseId);
  const coursesEnrolled = STATE.courses.filter(c => courseIds.includes(c.id));
  const coursesStr = coursesEnrolled.length > 0 
    ? coursesEnrolled.map(c => `<span class="course-code">${c.code}</span>`).join(' ')
    : `<span style="color: var(--text-muted); font-size: 0.8rem;">No active enrollments</span>`;
    
  const detailContainer = document.getElementById("student-detail-content");
  
  detailContainer.innerHTML = `
    <div class="student-profile-header">
      <div class="student-profile-avatar">
        ${student.name.split(' ').map(n => n[0]).join('').slice(0,2).toUpperCase()}
      </div>
      <div class="student-profile-summary">
        <h4 class="student-profile-name">${student.name}</h4>
        <span class="badge badge-dept" style="margin:0; width: fit-content;">${student.department}</span>
      </div>
    </div>
    
    <div class="student-profile-grid">
      <div class="student-profile-item">
        <span class="student-profile-label">Student ID</span>
        <span class="student-profile-value" style="font-weight:700;">${student.id}</span>
      </div>
      <div class="student-profile-item">
        <span class="student-profile-label">Current Status</span>
        <span class="student-profile-value">
          <span class="badge badge-${student.status.toLowerCase()}">${student.status}</span>
        </span>
      </div>
      <div class="student-profile-item">
        <span class="student-profile-label">Email Address</span>
        <span class="student-profile-value">${student.email}</span>
      </div>
      <div class="student-profile-item">
        <span class="student-profile-label">Phone Number</span>
        <span class="student-profile-value">${student.phone || 'N/A'}</span>
      </div>
      <div class="student-profile-item">
        <span class="student-profile-label">Academic GPA</span>
        <span class="student-profile-value" style="font-weight:700; color:var(--primary);">${gpa.toFixed(2)} / 4.00</span>
      </div>
      <div class="student-profile-item">
        <span class="student-profile-label">Attendance Rate</span>
        <span class="student-profile-value" style="font-weight:700; color:var(--accent);">${attendanceRate}%</span>
      </div>
      <div class="student-profile-item" style="grid-column: span 2;">
        <span class="student-profile-label">Enrolled Modules</span>
        <span class="student-profile-value" style="margin-top:6px;">${coursesStr}</span>
      </div>
    </div>
    
    <div class="student-profile-bio">
      <span class="student-profile-label">About Student</span>
      <p style="margin-top: 6px;">${student.bio || 'No details provided.'}</p>
    </div>
  `;
  
  openModal("student-detail-modal");
};

// 2. CREATE COURSE
window.handleCourseFormSubmit = function(e) {
  e.preventDefault();
  
  const code = document.getElementById("course-code").value.trim().toUpperCase();
  const name = document.getElementById("course-name").value.trim();
  const department = document.getElementById("course-dept").value;
  const instructor = document.getElementById("course-instructor").value.trim();
  const credits = parseInt(document.getElementById("course-credits").value);
  const capacity = parseInt(document.getElementById("course-capacity").value);
  
  // Check if course code already exists
  if (STATE.courses.some(c => c.code === code)) {
    showToast(`Course code ${code} already exists!`, "danger");
    return;
  }
  
  const nextNum = STATE.courses.length > 0 
    ? Math.max(...STATE.courses.map(c => parseInt(c.id.replace("CRS", "")))) + 1 
    : 1;
  const newId = "CRS" + String(nextNum).padStart(3, '0');
  
  const newCourse = {
    id: newId,
    code,
    name,
    department,
    instructor,
    credits,
    capacity
  };
  
  STATE.courses.push(newCourse);
  logActivity(`Created course ${code}: ${name} with ${instructor}.`, "success");
  showToast(`Course ${code} created successfully!`, "success");
  
  saveData();
  populateDropdowns();
  renderCourses();
  closeModal("course-modal");
  document.getElementById("course-form").reset();
};

window.quickEnrollStudent = function(courseId) {
  const course = STATE.courses.find(c => c.id === courseId);
  if (!course) return;
  
  const enrolledCount = STATE.enrollments.filter(e => e.courseId === courseId).length;
  if (enrolledCount >= course.capacity) {
    showToast(`Course ${course.code} has reached its maximum capacity.`, "warning");
    return;
  }
  
  // Find students NOT enrolled in this course
  const enrolledStudentIds = STATE.enrollments.filter(e => e.courseId === courseId).map(e => e.studentId);
  const nonEnrolled = STATE.students.filter(s => s.status === "Active" && !enrolledStudentIds.includes(s.id));
  
  if (nonEnrolled.length === 0) {
    showToast(`All active students are already enrolled in ${course.code}.`, "warning");
    return;
  }
  
  // Prompt user to select a student
  const studentOptions = nonEnrolled.map(s => `${s.id}: ${s.name}`).join('\n');
  const promptId = prompt(`Enroll student into ${course.code} (${course.name}).\nActive students eligible:\n\n${studentOptions}\n\nEnter Student ID:`);
  
  if (!promptId) return;
  
  const cleanedId = promptId.trim().toUpperCase();
  const selectedStudent = nonEnrolled.find(s => s.id.toUpperCase() === cleanedId);
  
  if (!selectedStudent) {
    alert("Invalid Student ID selected or student is already enrolled/inactive.");
    return;
  }
  
  // Add enrollment
  STATE.enrollments.push({
    studentId: selectedStudent.id,
    courseId: courseId,
    dateEnrolled: new Date().toISOString().split('T')[0]
  });
  
  logActivity(`Enrolled student ${selectedStudent.name} (${selectedStudent.id}) in ${course.code}.`, "success");
  showToast(`${selectedStudent.name} enrolled in ${course.code}!`, "success");
  
  saveData();
  renderCourses();
};

// 3. ADD GRADE RECORD
window.handleGradeFormSubmit = function(e) {
  e.preventDefault();
  
  const studentId = document.getElementById("grade-student-select-modal").value;
  const courseId = document.getElementById("grade-course-select-modal").value;
  const assignment = document.getElementById("grade-assignment").value.trim();
  const score = parseInt(document.getElementById("grade-score").value);
  const maxScore = parseInt(document.getElementById("grade-max").value);
  
  // Check if student is enrolled in this course
  const isEnrolled = STATE.enrollments.some(e => e.studentId === studentId && e.courseId === courseId);
  if (!isEnrolled) {
    if (!confirm("This student is not officially enrolled in this course. Do you want to enroll them and save the grade anyway?")) {
      return;
    }
    // Auto-enroll
    STATE.enrollments.push({
      studentId,
      courseId,
      dateEnrolled: new Date().toISOString().split('T')[0]
    });
  }
  
  const newGrade = {
    studentId,
    courseId,
    assignment,
    score,
    maxScore
  };
  
  STATE.grades.push(newGrade);
  
  const student = STATE.students.find(s => s.id === studentId) || { name: "Student" };
  const course = STATE.courses.find(c => c.id === courseId) || { code: "Course" };
  
  logActivity(`Logged grade for ${student.name} in ${course.code} (${assignment}: ${score}/${maxScore}).`, "success");
  showToast(`Grade recorded for ${student.name}.`, "success");
  
  saveData();
  renderGrades();
  closeModal("grade-modal");
  document.getElementById("grade-form").reset();
};

window.deleteGrade = function(index) {
  if (index < 0 || index >= STATE.grades.length) return;
  
  const record = STATE.grades[index];
  const student = STATE.students.find(s => s.id === record.studentId) || { name: "Student" };
  
  if (confirm(`Delete the grade record for ${student.name} (${record.assignment})?`)) {
    STATE.grades.splice(index, 1);
    logActivity(`Removed grade record for ${student.name}.`, "warning");
    showToast("Grade record deleted.", "warning");
    saveData();
    renderGrades();
  }
};

// 4. SAVE ATTENDANCE SHEET
window.saveAttendanceSheet = function() {
  const courseId = document.getElementById("attendance-course-select").value;
  const dateVal = document.getElementById("attendance-date-input").value;
  
  if (!courseId || !dateVal) return;
  
  // Find enrolled student IDs
  const enrolledStudentIds = STATE.enrollments.filter(e => e.courseId === courseId).map(e => e.studentId);
  
  if (enrolledStudentIds.length === 0) {
    showToast("No students enrolled to record attendance.", "warning");
    return;
  }
  
  let recordsLogged = 0;
  
  enrolledStudentIds.forEach(studentId => {
    // Get checked radio value
    const radioName = `att_${studentId}`;
    const selectedRadio = document.querySelector(`input[name="${radioName}"]:checked`);
    
    if (selectedRadio) {
      const status = selectedRadio.value;
      
      // Update or Insert
      const existingIdx = STATE.attendance.findIndex(a => a.studentId === studentId && a.courseId === courseId && a.date === dateVal);
      
      if (existingIdx !== -1) {
        STATE.attendance[existingIdx].status = status;
      } else {
        STATE.attendance.push({
          studentId,
          courseId,
          date: dateVal,
          status
        });
      }
      recordsLogged++;
    }
  });
  
  const course = STATE.courses.find(c => c.id === courseId) || { code: "Course" };
  logActivity(`Recorded attendance for ${recordsLogged} student(s) in ${course.code} on ${dateVal}.`, "success");
  showToast(`Attendance sheet saved for ${course.code}!`, "success");
  
  saveData();
  renderAttendance();
};


// ==========================================
// EVENT LISTENERS & SETUP
// ==========================================
function setupEventListeners() {
  // Sidebar router navigation
  document.querySelectorAll(".sidebar-menu .menu-item").forEach(item => {
    item.addEventListener("click", (e) => {
      e.preventDefault();
      const viewId = item.getAttribute("data-view");
      navigateToView(viewId);
    });
  });
  
  // Theme toggle button
  const themeBtn = document.getElementById("theme-toggle-btn");
  if (themeBtn) {
    themeBtn.addEventListener("click", toggleTheme);
  }
  
  // Student view search & filters
  const searchStudInput = document.getElementById("search-student");
  if (searchStudInput) {
    searchStudInput.addEventListener("input", renderStudents);
  }
  const filterDeptSelect = document.getElementById("filter-department");
  if (filterDeptSelect) {
    filterDeptSelect.addEventListener("change", renderStudents);
  }
  const filterStatusSelect = document.getElementById("filter-status");
  if (filterStatusSelect) {
    filterStatusSelect.addEventListener("change", renderStudents);
  }
  
  // Student modal open
  const addStudentBtn = document.getElementById("add-student-btn");
  if (addStudentBtn) {
    addStudentBtn.addEventListener("click", () => {
      document.getElementById("student-modal-title").textContent = "Add New Student";
      document.getElementById("student-form-action").value = "create";
      document.getElementById("student-form-id").value = "";
      document.getElementById("student-form").reset();
      openModal("student-modal");
    });
  }
  
  // Course modal open
  const addCourseBtn = document.getElementById("add-course-btn");
  if (addCourseBtn) {
    addCourseBtn.addEventListener("click", () => {
      openModal("course-modal");
    });
  }
  
  // Grade modal open
  const addGradeBtn = document.getElementById("add-grade-btn");
  if (addGradeBtn) {
    addGradeBtn.addEventListener("click", () => {
      openModal("grade-modal");
    });
  }
  
  // Grades filtering
  const gradesCourseFilter = document.getElementById("grades-course-select");
  if (gradesCourseFilter) {
    gradesCourseFilter.addEventListener("change", renderGrades);
  }
  const gradesStudentFilter = document.getElementById("grades-student-select");
  if (gradesStudentFilter) {
    gradesStudentFilter.addEventListener("change", renderGrades);
  }
  
  // Attendance course & date filtering
  const attCourseSelect = document.getElementById("attendance-course-select");
  if (attCourseSelect) {
    attCourseSelect.addEventListener("change", renderAttendance);
  }
  const attDateInput = document.getElementById("attendance-date-input");
  if (attDateInput) {
    attDateInput.addEventListener("change", renderAttendance);
  }
  
  // Save attendance sheet
  const saveAttBtn = document.getElementById("save-attendance-btn");
  if (saveAttBtn) {
    saveAttBtn.addEventListener("click", saveAttendanceSheet);
  }
}

// ON DOM CONTENT LOADED
document.addEventListener("DOMContentLoaded", initApp);
