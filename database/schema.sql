-- ============================================
-- COMPLETE STUDENT MANAGEMENT SYSTEM
-- Database: Project
-- Version: 5.0 (ULTIMATE EDITION with 25+ Features)
-- ============================================

-- Step 1: Create Database
DROP DATABASE IF EXISTS Project;
CREATE DATABASE Project;
USE Project;

-- ============================================
-- CORE TABLES
-- ============================================

-- Students Table
CREATE TABLE Students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    student_roll_no VARCHAR(20) UNIQUE,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender ENUM('Male', 'Female', 'Other') NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    alternate_phone VARCHAR(15),
    address TEXT,
    city VARCHAR(50),
    state VARCHAR(50),
    pincode VARCHAR(10),
    nationality VARCHAR(50) DEFAULT 'Indian',
    aadhar_number VARCHAR(12) UNIQUE,
    blood_group ENUM('A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'),
    enrollment_date DATE DEFAULT (CURDATE()),
    status ENUM('Active', 'Inactive', 'Graduated', 'Suspended', 'Transfered') DEFAULT 'Active',
    profile_photo VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Courses Table
CREATE TABLE Courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_code VARCHAR(20) UNIQUE NOT NULL,
    course_name VARCHAR(100) NOT NULL,
    credits INT NOT NULL CHECK (credits > 0),
    department VARCHAR(50),
    semester INT,
    year INT,
    instructor VARCHAR(100),
    syllabus TEXT,
    prerequisites TEXT,
    max_seats INT DEFAULT 60,
    enrolled_seats INT DEFAULT 0,
    status ENUM('Active', 'Inactive') DEFAULT 'Active'
);

-- Enrollments Table
CREATE TABLE Enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_id INT,
    enrollment_date DATE DEFAULT (CURDATE()),
    status ENUM('Enrolled', 'Dropped', 'Completed', 'Failed') DEFAULT 'Enrolled',
    drop_date DATE,
    completion_date DATE,
    FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE,
    UNIQUE KEY unique_enrollment (student_id, course_id)
);

-- Departments Table
CREATE TABLE Departments (
    dept_id INT PRIMARY KEY AUTO_INCREMENT,
    dept_code VARCHAR(10) UNIQUE,
    dept_name VARCHAR(100) NOT NULL,
    head_of_dept VARCHAR(100),
    contact_number VARCHAR(15),
    email VARCHAR(100),
    established_year YEAR
);

-- ============================================
-- FEATURE 1: FEE MANAGEMENT SYSTEM
-- ============================================

CREATE TABLE FeeStructure (
    fee_structure_id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT,
    semester INT,
    tuition_fee DECIMAL(10,2),
    examination_fee DECIMAL(10,2),
    library_fee DECIMAL(10,2),
    sports_fee DECIMAL(10,2),
    hostel_fee DECIMAL(10,2),
    transport_fee DECIMAL(10,2),
    total_fees DECIMAL(10,2),
    academic_year VARCHAR(20),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

CREATE TABLE Fees (
    fee_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    semester VARCHAR(20),
    total_fees DECIMAL(10,2) NOT NULL,
    paid_amount DECIMAL(10,2) DEFAULT 0,
    due_date DATE,
    payment_date DATE,
    status ENUM('Paid', 'Partial', 'Pending', 'Overdue', 'Waived') DEFAULT 'Pending',
    payment_method ENUM('Cash', 'Card', 'Online', 'Cheque', 'Demand Draft'),
    late_fee DECIMAL(10,2) DEFAULT 0,
    discount_amount DECIMAL(10,2) DEFAULT 0,
    remarks TEXT,
    FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE
);

CREATE TABLE FeeTransactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    fee_id INT,
    amount DECIMAL(10,2),
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    receipt_no VARCHAR(50) UNIQUE,
    payment_mode VARCHAR(20),
    transaction_id_gateway VARCHAR(100),
    bank_name VARCHAR(50),
    cheque_no VARCHAR(50),
    card_last_four VARCHAR(4),
    remarks TEXT,
    created_by VARCHAR(100),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (fee_id) REFERENCES Fees(fee_id)
);

-- ============================================
-- FEATURE 2: LIBRARY MANAGEMENT SYSTEM
-- ============================================

CREATE TABLE BookCategories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50) UNIQUE,
    description TEXT,
    rack_no VARCHAR(10)
);

CREATE TABLE Books (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    isbn VARCHAR(20) UNIQUE,
    title VARCHAR(200) NOT NULL,
    author VARCHAR(100),
    publisher VARCHAR(100),
    edition VARCHAR(20),
    category_id INT,
    total_copies INT DEFAULT 1,
    available_copies INT DEFAULT 1,
    location VARCHAR(50),
    price DECIMAL(10,2),
    purchase_date DATE,
    language VARCHAR(50),
    pages INT,
    FOREIGN KEY (category_id) REFERENCES BookCategories(category_id)
);

CREATE TABLE BookIssues (
    issue_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    book_id INT,
    issue_date DATE DEFAULT (CURDATE()),
    due_date DATE,
    return_date DATE,
    fine_amount DECIMAL(10,2) DEFAULT 0,
    status ENUM('Issued', 'Returned', 'Lost', 'Renewed') DEFAULT 'Issued',
    renewed_count INT DEFAULT 0,
    remarks TEXT,
    issued_by VARCHAR(100),
    returned_by VARCHAR(100),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (book_id) REFERENCES Books(book_id)
);

CREATE TABLE BookReservations (
    reservation_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    book_id INT,
    reservation_date DATE DEFAULT (CURDATE()),
    status ENUM('Pending', 'Fulfilled', 'Cancelled', 'Expired') DEFAULT 'Pending',
    expiry_date DATE,
    notify_status BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (book_id) REFERENCES Books(book_id)
);

-- ============================================
-- FEATURE 3: FACULTY MANAGEMENT
-- ============================================

CREATE TABLE Faculty (
    faculty_id INT PRIMARY KEY AUTO_INCREMENT,
    faculty_code VARCHAR(20) UNIQUE,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    qualification VARCHAR(100),
    specialization VARCHAR(100),
    joining_date DATE,
    designation VARCHAR(50),
    department VARCHAR(50),
    salary DECIMAL(10,2),
    bank_account_no VARCHAR(20),
    pan_number VARCHAR(10),
    address TEXT,
    profile_photo VARCHAR(255),
    status ENUM('Active', 'On Leave', 'Retired', 'Resigned') DEFAULT 'Active'
);

CREATE TABLE FacultyAttendance (
    attendance_id INT PRIMARY KEY AUTO_INCREMENT,
    faculty_id INT,
    attendance_date DATE,
    check_in_time TIME,
    check_out_time TIME,
    status ENUM('Present', 'Absent', 'Late', 'Half Day', 'Holiday') DEFAULT 'Present',
    reason_for_absence TEXT,
    marked_by VARCHAR(100),
    FOREIGN KEY (faculty_id) REFERENCES Faculty(faculty_id),
    UNIQUE KEY unique_faculty_attendance (faculty_id, attendance_date)
);

CREATE TABLE FacultyCourses (
    assignment_id INT PRIMARY KEY AUTO_INCREMENT,
    faculty_id INT,
    course_id INT,
    semester VARCHAR(20),
    academic_year VARCHAR(20),
    is_primary BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (faculty_id) REFERENCES Faculty(faculty_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

-- ============================================
-- FEATURE 4: EXAM SCHEDULING
-- ============================================

CREATE TABLE ExamSchedule (
    schedule_id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT,
    exam_type ENUM('Midterm', 'Final', 'Quiz', 'Practical', 'Viva', 'Assignment'),
    exam_date DATE,
    start_time TIME,
    end_time TIME,
    room_no VARCHAR(20),
    max_marks INT DEFAULT 100,
    passing_marks INT DEFAULT 40,
    invigilator VARCHAR(100),
    total_seats INT,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

CREATE TABLE ExamResults (
    exam_result_id INT PRIMARY KEY AUTO_INCREMENT,
    exam_id INT,
    student_id INT,
    marks_obtained DECIMAL(5,2),
    percentage DECIMAL(5,2),
    grade VARCHAR(2),
    remarks TEXT,
    entered_by VARCHAR(100),
    verified_by VARCHAR(100),
    verification_date DATE,
    FOREIGN KEY (exam_id) REFERENCES ExamSchedule(schedule_id),
    FOREIGN KEY (student_id) REFERENCES Students(student_id)
);

-- ============================================
-- FEATURE 5: PARENT/GUARDIAN INFORMATION
-- ============================================

CREATE TABLE Parents (
    parent_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT UNIQUE,
    father_name VARCHAR(100),
    father_phone VARCHAR(15),
    father_email VARCHAR(100),
    father_occupation VARCHAR(50),
    father_annual_income DECIMAL(10,2),
    mother_name VARCHAR(100),
    mother_phone VARCHAR(15),
    mother_email VARCHAR(100),
    mother_occupation VARCHAR(50),
    mother_annual_income DECIMAL(10,2),
    guardian_name VARCHAR(100),
    guardian_phone VARCHAR(15),
    guardian_email VARCHAR(100),
    relationship VARCHAR(50),
    address TEXT,
    family_annual_income DECIMAL(10,2),
    FOREIGN KEY (student_id) REFERENCES Students(student_id)
);

-- ============================================
-- FEATURE 6: HOSTEL MANAGEMENT
-- ============================================

CREATE TABLE Hostels (
    hostel_id INT PRIMARY KEY AUTO_INCREMENT,
    hostel_name VARCHAR(50) UNIQUE,
    hostel_type ENUM('Boys', 'Girls', 'Co-ed'),
    total_rooms INT,
    warden_name VARCHAR(100),
    warden_phone VARCHAR(15),
    contact_number VARCHAR(15),
    address TEXT
);

CREATE TABLE HostelRooms (
    room_id INT PRIMARY KEY AUTO_INCREMENT,
    hostel_id INT,
    room_no VARCHAR(10) UNIQUE,
    room_type ENUM('Single', 'Double', 'Triple', 'Dormitory'),
    floor_no INT,
    capacity INT,
    current_occupancy INT DEFAULT 0,
    rent_per_month DECIMAL(10,2),
    facilities TEXT,
    is_ac BOOLEAN DEFAULT FALSE,
    status ENUM('Available', 'Full', 'Maintenance') DEFAULT 'Available',
    FOREIGN KEY (hostel_id) REFERENCES Hostels(hostel_id)
);

CREATE TABLE HostelAllocations (
    allocation_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    room_id INT,
    allocation_date DATE,
    vacate_date DATE,
    status ENUM('Active', 'Vacated', 'Transferred') DEFAULT 'Active',
    rent_paid_up_to DATE,
    security_deposit DECIMAL(10,2),
    remarks TEXT,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (room_id) REFERENCES HostelRooms(room_id)
);

-- ============================================
-- FEATURE 7: SCHOLARSHIP MANAGEMENT
-- ============================================

CREATE TABLE Scholarships (
    scholarship_id INT PRIMARY KEY AUTO_INCREMENT,
    scholarship_name VARCHAR(100),
    amount DECIMAL(10,2),
    eligibility_criteria TEXT,
    deadline DATE,
    provider VARCHAR(100),
    min_percentage DECIMAL(5,2),
    max_family_income DECIMAL(10,2),
    required_documents TEXT,
    total_slots INT,
    remaining_slots INT,
    status ENUM('Open', 'Closed', 'Coming Soon') DEFAULT 'Open'
);

CREATE TABLE StudentScholarships (
    application_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    scholarship_id INT,
    application_date DATE DEFAULT (CURDATE()),
    status ENUM('Applied', 'Under Review', 'Approved', 'Rejected', 'Disbursed') DEFAULT 'Applied',
    awarded_amount DECIMAL(10,2),
    approval_date DATE,
    disbursement_date DATE,
    rejection_reason TEXT,
    remarks TEXT,
    documents_verified BOOLEAN DEFAULT FALSE,
    verified_by VARCHAR(100),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (scholarship_id) REFERENCES Scholarships(scholarship_id)
);

-- ============================================
-- FEATURE 8: EVENT MANAGEMENT
-- ============================================

CREATE TABLE Events (
    event_id INT PRIMARY KEY AUTO_INCREMENT,
    event_name VARCHAR(100),
    event_type ENUM('Academic', 'Cultural', 'Sports', 'Workshop', 'Seminar', 'Conference', 'Placement'),
    event_date DATE,
    start_time TIME,
    end_time TIME,
    venue VARCHAR(100),
    organizer VARCHAR(100),
    description TEXT,
    registration_fee DECIMAL(10,2) DEFAULT 0,
    max_participants INT,
    current_participants INT DEFAULT 0,
    poster_url VARCHAR(255),
    status ENUM('Upcoming', 'Ongoing', 'Completed', 'Cancelled') DEFAULT 'Upcoming'
);

CREATE TABLE EventRegistrations (
    registration_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    event_id INT,
    registration_date DATE DEFAULT (CURDATE()),
    attendance_status ENUM('Registered', 'Attended', 'Absent', 'Cancelled') DEFAULT 'Registered',
    payment_status ENUM('Paid', 'Pending', 'Waived') DEFAULT 'Pending',
    payment_amount DECIMAL(10,2),
    certificate_issued BOOLEAN DEFAULT FALSE,
    feedback_submitted BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (event_id) REFERENCES Events(event_id)
);

-- ============================================
-- FEATURE 9: PLACEMENT/INTERNSHIP TRACKING
-- ============================================

CREATE TABLE Companies (
    company_id INT PRIMARY KEY AUTO_INCREMENT,
    company_name VARCHAR(100) UNIQUE,
    industry VARCHAR(50),
    location VARCHAR(100),
    contact_person VARCHAR(100),
    contact_email VARCHAR(100),
    contact_phone VARCHAR(15),
    website VARCHAR(100),
    company_logo VARCHAR(255),
    about TEXT
);

CREATE TABLE JobPostings (
    job_id INT PRIMARY KEY AUTO_INCREMENT,
    company_id INT,
    job_title VARCHAR(100),
    job_description TEXT,
    eligibility_criteria TEXT,
    package_min DECIMAL(10,2),
    package_max DECIMAL(10,2),
    job_location VARCHAR(100),
    job_type ENUM('Internship', 'Full-Time', 'Part-Time', 'Contract'),
    last_date DATE,
    openings INT,
    posted_date DATE,
    status ENUM('Open', 'Closed', 'Filled') DEFAULT 'Open',
    FOREIGN KEY (company_id) REFERENCES Companies(company_id)
);

CREATE TABLE Placements (
    placement_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    job_id INT,
    company_id INT,
    application_date DATE,
    job_role VARCHAR(100),
    package DECIMAL(10,2),
    placement_date DATE,
    placement_type ENUM('Internship', 'Full-Time', 'Part-Time', 'Contract'),
    status ENUM('Applied', 'Shortlisted', 'Selected', 'Rejected', 'Joined', 'Offered') DEFAULT 'Applied',
    interview_rounds INT,
    offer_letter_path VARCHAR(255),
    joining_date DATE,
    rejection_reason TEXT,
    remarks TEXT,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (job_id) REFERENCES JobPostings(job_id),
    FOREIGN KEY (company_id) REFERENCES Companies(company_id)
);

-- ============================================
-- FEATURE 10: FEEDBACK SYSTEM
-- ============================================

CREATE TABLE FeedbackTypes (
    type_id INT PRIMARY KEY AUTO_INCREMENT,
    type_name VARCHAR(50) UNIQUE,
    description TEXT
);

CREATE TABLE Feedback (
    feedback_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_id INT,
    faculty_id INT,
    type_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    teaching_quality INT CHECK (teaching_quality BETWEEN 1 AND 5),
    course_material INT CHECK (course_material BETWEEN 1 AND 5),
    punctuality INT CHECK (punctuality BETWEEN 1 AND 5),
    communication_skills INT CHECK (communication_skills BETWEEN 1 AND 5),
    lab_facilities INT CHECK (lab_facilities BETWEEN 1 AND 5),
    library_resources INT CHECK (library_resources BETWEEN 1 AND 5),
    overall_experience INT CHECK (overall_experience BETWEEN 1 AND 5),
    comments TEXT,
    suggestions TEXT,
    feedback_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_anonymous BOOLEAN DEFAULT FALSE,
    is_responded BOOLEAN DEFAULT FALSE,
    response_text TEXT,
    response_date TIMESTAMP,
    responded_by VARCHAR(100),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id),
    FOREIGN KEY (faculty_id) REFERENCES Faculty(faculty_id),
    FOREIGN KEY (type_id) REFERENCES FeedbackTypes(type_id)
);

-- ============================================
-- FEATURE 11: NOTICE BOARD / ANNOUNCEMENTS
-- ============================================

CREATE TABLE Announcements (
    announcement_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200) NOT NULL,
    content TEXT,
    posted_by VARCHAR(100),
    posted_by_type ENUM('Admin', 'Faculty', 'HOD', 'Principal'),
    post_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expiry_date DATE,
    target_audience ENUM('All', 'Students', 'Faculty', 'Parents', 'Staff', 'Alumni') DEFAULT 'All',
    priority ENUM('Low', 'Medium', 'High', 'Urgent') DEFAULT 'Medium',
    attachment_path VARCHAR(255),
    view_count INT DEFAULT 0,
    is_pinned BOOLEAN DEFAULT FALSE
);

CREATE TABLE NotificationReadStatus (
    status_id INT PRIMARY KEY AUTO_INCREMENT,
    announcement_id INT,
    student_id INT,
    is_read BOOLEAN DEFAULT FALSE,
    read_date TIMESTAMP,
    FOREIGN KEY (announcement_id) REFERENCES Announcements(announcement_id),
    FOREIGN KEY (student_id) REFERENCES Students(student_id)
);

-- ============================================
-- FEATURE 12: CERTIFICATE MANAGEMENT
-- ============================================

CREATE TABLE CertificateTemplates (
    template_id INT PRIMARY KEY AUTO_INCREMENT,
    template_name VARCHAR(100),
    certificate_type ENUM('Course Completion', 'Internship', 'Achievement', 'Participation', 'Merit', 'Scholarship'),
    template_file VARCHAR(255),
    fields JSON
);

CREATE TABLE Certificates (
    certificate_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    certificate_type ENUM('Course Completion', 'Internship', 'Achievement', 'Participation', 'Merit', 'Scholarship'),
    issue_date DATE,
    certificate_no VARCHAR(50) UNIQUE,
    description TEXT,
    file_path VARCHAR(255),
    verified_by VARCHAR(100),
    verification_code VARCHAR(50) UNIQUE,
    expiry_date DATE,
    template_id INT,
    qr_code VARCHAR(255),
    is_verified BOOLEAN DEFAULT FALSE,
    downloaded_count INT DEFAULT 0,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (template_id) REFERENCES CertificateTemplates(template_id)
);

-- ============================================
-- FEATURE 13: LEAVE APPLICATION SYSTEM
-- ============================================

CREATE TABLE LeaveTypes (
    leave_type_id INT PRIMARY KEY AUTO_INCREMENT,
    leave_type_name VARCHAR(50) UNIQUE,
    max_days_per_year INT,
    is_paid BOOLEAN DEFAULT TRUE,
    requires_document BOOLEAN DEFAULT FALSE
);

CREATE TABLE LeaveApplications (
    leave_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    leave_type INT,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
    total_days INT,
    reason TEXT,
    document_path VARCHAR(255),
    status ENUM('Pending', 'Approved', 'Rejected', 'Cancelled') DEFAULT 'Pending',
    approved_by INT,
    approval_date DATE,
    rejection_reason TEXT,
    remarks TEXT,
    application_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (approved_by) REFERENCES Faculty(faculty_id),
    FOREIGN KEY (leave_type) REFERENCES LeaveTypes(leave_type_id)
);

-- ============================================
-- FEATURE 14: TIMETABLE MANAGEMENT
-- ============================================

CREATE TABLE TimeSlots (
    slot_id INT PRIMARY KEY AUTO_INCREMENT,
    start_time TIME,
    end_time TIME,
    slot_name VARCHAR(20)
);

CREATE TABLE Timetable (
    timetable_id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT,
    faculty_id INT,
    day_of_week ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'),
    slot_id INT,
    room_no VARCHAR(20),
    semester VARCHAR(20),
    academic_year VARCHAR(20),
    batch VARCHAR(20),
    is_lab BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id),
    FOREIGN KEY (faculty_id) REFERENCES Faculty(faculty_id),
    FOREIGN KEY (slot_id) REFERENCES TimeSlots(slot_id),
    UNIQUE KEY unique_timetable_slot (day_of_week, slot_id, room_no, semester)
);

-- ============================================
-- FEATURE 15: STUDENT ID CARDS
-- ============================================

CREATE TABLE StudentIDCards (
    card_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT UNIQUE,
    card_number VARCHAR(50) UNIQUE,
    issue_date DATE DEFAULT (CURDATE()),
    expiry_date DATE,
    is_active BOOLEAN DEFAULT TRUE,
    qr_code TEXT,
    barcode VARCHAR(100),
    photo_path VARCHAR(255),
    access_level ENUM('Basic', 'Hostel', 'Library', 'Full') DEFAULT 'Basic',
    last_accessed TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES Students(student_id)
);

-- ============================================
-- FEATURE 16: NOTIFICATION SYSTEM
-- ============================================

CREATE TABLE NotificationTemplates (
    template_id INT PRIMARY KEY AUTO_INCREMENT,
    template_name VARCHAR(100),
    subject_template VARCHAR(200),
    body_template TEXT,
    type ENUM('SMS', 'Email', 'Push')
);

CREATE TABLE Notifications (
    notification_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    faculty_id INT,
    template_id INT,
    type ENUM('SMS', 'Email', 'Push'),
    subject VARCHAR(200),
    message TEXT,
    sent_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Pending', 'Sent', 'Failed', 'Delivered', 'Read') DEFAULT 'Pending',
    error_message TEXT,
    read_date TIMESTAMP,
    priority ENUM('Low', 'Medium', 'High') DEFAULT 'Medium',
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (faculty_id) REFERENCES Faculty(faculty_id),
    FOREIGN KEY (template_id) REFERENCES NotificationTemplates(template_id)
);

-- ============================================
-- FEATURE 17: AUDIT LOG
-- ============================================

CREATE TABLE AuditLog (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    table_name VARCHAR(50),
    action ENUM('INSERT', 'UPDATE', 'DELETE'),
    record_id INT,
    old_data JSON,
    new_data JSON,
    changed_by VARCHAR(100),
    changed_by_role VARCHAR(50),
    ip_address VARCHAR(45),
    user_agent TEXT,
    change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- FEATURE 18: USER ROLES & SECURITY
-- ============================================

CREATE TABLE UserRoles (
    role_id INT PRIMARY KEY AUTO_INCREMENT,
    role_name VARCHAR(50) UNIQUE NOT NULL,
    permissions JSON,
    description TEXT
);

CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE,
    role_id INT,
    student_id INT NULL,
    faculty_id INT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    is_locked BOOLEAN DEFAULT FALSE,
    login_attempts INT DEFAULT 0,
    last_login TIMESTAMP,
    last_password_change TIMESTAMP,
    account_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reset_token VARCHAR(255),
    reset_token_expiry TIMESTAMP,
    FOREIGN KEY (role_id) REFERENCES UserRoles(role_id),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (faculty_id) REFERENCES Faculty(faculty_id)
);

-- ============================================
-- FEATURE 19: ATTENDANCE MANAGEMENT
-- ============================================

CREATE TABLE Attendance (
    attendance_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_id INT,
    attendance_date DATE NOT NULL,
    status ENUM('Present', 'Absent', 'Late', 'Excused') NOT NULL,
    check_in_time TIME,
    check_out_time TIME,
    marked_by VARCHAR(100),
    remarks TEXT,
    FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE,
    UNIQUE KEY unique_attendance (student_id, course_id, attendance_date)
);

-- ============================================
-- FEATURE 20: RESULTS/GRADES MANAGEMENT
-- ============================================

CREATE TABLE Results (
    result_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_id INT,
    marks_obtained DECIMAL(5,2) CHECK (marks_obtained BETWEEN 0 AND 100),
    total_marks DECIMAL(5,2) DEFAULT 100,
    percentage DECIMAL(5,2),
    grade VARCHAR(2),
    grade_points DECIMAL(4,2),
    semester VARCHAR(20),
    is_passed BOOLEAN DEFAULT TRUE,
    remarks TEXT,
    published_date DATE,
    updated_by VARCHAR(100),
    FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE,
    UNIQUE KEY unique_result (student_id, course_id, semester)
);

-- ============================================
-- FEATURE 21: ALUMNI MANAGEMENT
-- ============================================

CREATE TABLE Alumni (
    alumni_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT UNIQUE,
    graduation_year YEAR,
    current_company VARCHAR(100),
    current_designation VARCHAR(100),
    current_location VARCHAR(100),
    linkedin_profile VARCHAR(255),
    personal_website VARCHAR(255),
    achievements TEXT,
    is_active_alumni BOOLEAN DEFAULT TRUE,
    last_interaction DATE,
    FOREIGN KEY (student_id) REFERENCES Students(student_id)
);

CREATE TABLE AlumniEvents (
    event_id INT PRIMARY KEY AUTO_INCREMENT,
    event_name VARCHAR(100),
    event_date DATE,
    venue VARCHAR(100),
    description TEXT,
    organizer VARCHAR(100),
    contact_email VARCHAR(100)
);

CREATE TABLE AlumniRegistrations (
    registration_id INT PRIMARY KEY AUTO_INCREMENT,
    alumni_id INT,
    event_id INT,
    registration_date DATE,
    attendance_status BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (alumni_id) REFERENCES Alumni(alumni_id),
    FOREIGN KEY (event_id) REFERENCES AlumniEvents(event_id)
);

-- ============================================
-- FEATURE 22: COMPLAINT MANAGEMENT
-- ============================================

CREATE TABLE ComplaintCategories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50) UNIQUE,
    assigned_to VARCHAR(100)
);

CREATE TABLE Complaints (
    complaint_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    category_id INT,
    subject VARCHAR(200),
    description TEXT,
    attachment_path VARCHAR(255),
    status ENUM('Pending', 'In Progress', 'Resolved', 'Rejected', 'Closed') DEFAULT 'Pending',
    priority ENUM('Low', 'Medium', 'High', 'Urgent') DEFAULT 'Medium',
    submitted_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resolved_date DATE,
    resolved_by VARCHAR(100),
    resolution_remarks TEXT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    feedback TEXT,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (category_id) REFERENCES ComplaintCategories(category_id)
);

-- ============================================
-- FEATURE 23: TRANSPORT MANAGEMENT
-- ============================================

CREATE TABLE TransportRoutes (
    route_id INT PRIMARY KEY AUTO_INCREMENT,
    route_name VARCHAR(100),
    route_description TEXT,
    total_distance DECIMAL(10,2),
    total_duration TIME
);

CREATE TABLE TransportVehicles (
    vehicle_id INT PRIMARY KEY AUTO_INCREMENT,
    vehicle_number VARCHAR(20) UNIQUE,
    vehicle_type ENUM('Bus', 'Van', 'Car', 'Mini Bus'),
    capacity INT,
    driver_name VARCHAR(100),
    driver_phone VARCHAR(15),
    route_id INT,
    FOREIGN KEY (route_id) REFERENCES TransportRoutes(route_id)
);

CREATE TABLE TransportAllocations (
    allocation_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    route_id INT,
    vehicle_id INT,
    pickup_point VARCHAR(100),
    drop_point VARCHAR(100),
    fee_per_month DECIMAL(10,2),
    status ENUM('Active', 'Inactive', 'Expired') DEFAULT 'Active',
    valid_from DATE,
    valid_until DATE,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (route_id) REFERENCES TransportRoutes(route_id),
    FOREIGN KEY (vehicle_id) REFERENCES TransportVehicles(vehicle_id)
);

-- ============================================
-- FEATURE 24: HOSTEL MESS MANAGEMENT
-- ============================================

CREATE TABLE MessMenu (
    menu_id INT PRIMARY KEY AUTO_INCREMENT,
    day_of_week ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'),
    meal_type ENUM('Breakfast', 'Lunch', 'Snacks', 'Dinner'),
    item_name VARCHAR(100),
    description TEXT,
    is_vegetarian BOOLEAN DEFAULT TRUE
);

CREATE TABLE MessFeedback (
    feedback_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    menu_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comments TEXT,
    feedback_date DATE DEFAULT (CURDATE()),
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (menu_id) REFERENCES MessMenu(menu_id)
);

-- ============================================
-- FEATURE 25: EXTRA-CURRICULAR ACTIVITIES
-- ============================================

CREATE TABLE Clubs (
    club_id INT PRIMARY KEY AUTO_INCREMENT,
    club_name VARCHAR(100) UNIQUE,
    club_type ENUM('Technical', 'Cultural', 'Sports', 'Social', 'Academic'),
    description TEXT,
    faculty_incharge INT,
    president_id INT,
    established_year YEAR,
    meeting_day VARCHAR(20),
    meeting_time TIME,
    FOREIGN KEY (faculty_incharge) REFERENCES Faculty(faculty_id),
    FOREIGN KEY (president_id) REFERENCES Students(student_id)
);

CREATE TABLE ClubMemberships (
    membership_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    club_id INT,
    role VARCHAR(50) DEFAULT 'Member',
    join_date DATE DEFAULT (CURDATE()),
    status ENUM('Active', 'Inactive', 'Graduated') DEFAULT 'Active',
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (club_id) REFERENCES Clubs(club_id)
);

CREATE TABLE Achievements (
    achievement_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    achievement_type ENUM('Academic', 'Sports', 'Cultural', 'Technical', 'Social'),
    title VARCHAR(200),
    description TEXT,
    level ENUM('Institute', 'University', 'State', 'National', 'International'),
    date_achieved DATE,
    certificate_path VARCHAR(255),
    verified_by VARCHAR(100),
    is_verified BOOLEAN DEFAULT FALSE,
    points INT DEFAULT 0,
    FOREIGN KEY (student_id) REFERENCES Students(student_id)
);

-- ============================================
-- PERFORMANCE INDEXES
-- ============================================

CREATE INDEX idx_student_status ON Students(status);
CREATE INDEX idx_student_roll ON Students(student_roll_no);
CREATE INDEX idx_student_email ON Students(email);
CREATE INDEX idx_enrollment_status ON Enrollments(status);
CREATE INDEX idx_attendance_date ON Attendance(attendance_date);
CREATE INDEX idx_fees_status ON Fees(status);
CREATE INDEX idx_fees_student ON Fees(student_id);
CREATE INDEX idx_book_issues_status ON BookIssues(status);
CREATE INDEX idx_book_issues_student ON BookIssues(student_id);
CREATE INDEX idx_results_semester ON Results(semester);
CREATE INDEX idx_results_student ON Results(student_id);
CREATE INDEX idx_placement_status ON Placements(status);
CREATE INDEX idx_placement_student ON Placements(student_id);
CREATE INDEX idx_feedback_rating ON Feedback(rating);
CREATE INDEX idx_feedback_faculty ON Feedback(faculty_id);
CREATE INDEX idx_leave_status ON LeaveApplications(status);
CREATE INDEX idx_leave_dates ON LeaveApplications(from_date, to_date);
CREATE INDEX idx_timetable_semester ON Timetable(semester);
CREATE INDEX idx_notification_status ON Notifications(status);
CREATE INDEX idx_complaint_status ON Complaints(status);
CREATE INDEX idx_alumni_graduation ON Alumni(graduation_year);

-- ============================================
-- TRIGGERS
-- ============================================

DELIMITER $$

-- Trigger 1: Auto-generate student roll number
CREATE TRIGGER generate_roll_number
BEFORE INSERT ON Students
FOR EACH ROW
BEGIN
    DECLARE next_num INT;
    SELECT COALESCE(MAX(CAST(SUBSTRING(student_roll_no, 5) AS UNSIGNED)), 0) + 1 INTO next_num FROM Students;
    SET NEW.student_roll_no = CONCAT('STU', LPAD(next_num, 6, '0'));
END$$

-- Trigger 2: Auto-assign grade based on marks (INSERT)
CREATE TRIGGER assign_grade_before_insert
BEFORE INSERT ON Results
FOR EACH ROW
BEGIN
    SET NEW.percentage = (NEW.marks_obtained / NEW.total_marks) * 100;
    
    IF NEW.percentage >= 90 THEN 
        SET NEW.grade = 'A+';
        SET NEW.grade_points = 10;
    ELSEIF NEW.percentage >= 80 THEN 
        SET NEW.grade = 'A';
        SET NEW.grade_points = 9;
    ELSEIF NEW.percentage >= 70 THEN 
        SET NEW.grade = 'B';
        SET NEW.grade_points = 8;
    ELSEIF NEW.percentage >= 60 THEN 
        SET NEW.grade = 'C';
        SET NEW.grade_points = 7;
    ELSEIF NEW.percentage >= 50 THEN 
        SET NEW.grade = 'D';
        SET NEW.grade_points = 6;
    ELSE 
        SET NEW.grade = 'F';
        SET NEW.grade_points = 0;
        SET NEW.is_passed = FALSE;
    END IF;
END$$

-- Trigger 3: Auto-assign grade based on marks (UPDATE)
CREATE TRIGGER assign_grade_before_update
BEFORE UPDATE ON Results
FOR EACH ROW
BEGIN
    SET NEW.percentage = (NEW.marks_obtained / NEW.total_marks) * 100;
    
    IF NEW.percentage >= 90 THEN 
        SET NEW.grade = 'A+';
        SET NEW.grade_points = 10;
    ELSEIF NEW.percentage >= 80 THEN 
        SET NEW.grade = 'A';
        SET NEW.grade_points = 9;
    ELSEIF NEW.percentage >= 70 THEN 
        SET NEW.grade = 'B';
        SET NEW.grade_points = 8;
    ELSEIF NEW.percentage >= 60 THEN 
        SET NEW.grade = 'C';
        SET NEW.grade_points = 7;
    ELSEIF NEW.percentage >= 50 THEN 
        SET NEW.grade = 'D';
        SET NEW.grade_points = 6;
    ELSE 
        SET NEW.grade = 'F';
        SET NEW.grade_points = 0;
        SET NEW.is_passed = FALSE;
    END IF;
END$$

-- Trigger 4: Update hostel occupancy when allocating room
CREATE TRIGGER update_hostel_occupancy_after_insert
AFTER INSERT ON HostelAllocations
FOR EACH ROW
BEGIN
    IF NEW.status = 'Active' THEN
        UPDATE HostelRooms 
        SET current_occupancy = current_occupancy + 1 
        WHERE room_id = NEW.room_id;
    END IF;
END$$

-- Trigger 5: Update course enrolled seats
CREATE TRIGGER update_course_seats_after_enroll
AFTER INSERT ON Enrollments
FOR EACH ROW
BEGIN
    UPDATE Courses 
    SET enrolled_seats = enrolled_seats + 1 
    WHERE course_id = NEW.course_id;
END$$

-- Trigger 6: Calculate total leave days
CREATE TRIGGER calculate_leave_days
BEFORE INSERT ON LeaveApplications
FOR EACH ROW
BEGIN
    SET NEW.total_days = DATEDIFF(NEW.to_date, NEW.from_date) + 1;
    
    IF NEW.from_date < CURDATE() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Leave start date cannot be in the past';
    END IF;
    
    IF NEW.total_days > 30 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Maximum 30 days leave allowed at a time';
    END IF;
END$$

-- Trigger 7: Auto-create student ID card
CREATE TRIGGER create_student_id_card
AFTER INSERT ON Students
FOR EACH ROW
BEGIN
    DECLARE card_num VARCHAR(50);
    SET card_num = CONCAT('STU-', LPAD(NEW.student_id, 8, '0'), '-', YEAR(CURDATE()));
    
    INSERT INTO StudentIDCards (student_id, card_number, issue_date, expiry_date, is_active)
    VALUES (NEW.student_id, card_num, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 4 YEAR), TRUE);
END$$

-- Trigger 8: Audit log for Students
CREATE TRIGGER audit_students_update
AFTER UPDATE ON Students
FOR EACH ROW
BEGIN
    INSERT INTO AuditLog (table_name, action, record_id, old_data, new_data, changed_by)
    VALUES ('Students', 'UPDATE', OLD.student_id, 
            JSON_OBJECT('status', OLD.status, 'email', OLD.email, 'phone', OLD.phone),
            JSON_OBJECT('status', NEW.status, 'email', NEW.email, 'phone', NEW.phone),
            USER());
END$$

-- Trigger 9: Auto-update fee status
CREATE TRIGGER update_fee_status_after_transaction
AFTER INSERT ON FeeTransactions
FOR EACH ROW
BEGIN
    DECLARE total_paid DECIMAL(10,2);
    DECLARE total_fee DECIMAL(10,2);
    DECLARE fee_record_id INT;
    
    SELECT fee_id, total_fees INTO fee_record_id, total_fee
    FROM Fees 
    WHERE student_id = NEW.student_id 
    AND status != 'Paid'
    ORDER BY fee_id DESC LIMIT 1;
    
    SELECT COALESCE(SUM(amount), 0) INTO total_paid
    FROM FeeTransactions 
    WHERE student_id = NEW.student_id;
    
    IF total_paid >= total_fee THEN
        UPDATE Fees SET status = 'Paid', payment_date = CURDATE() 
        WHERE fee_id = fee_record_id;
    ELSEIF total_paid > 0 THEN
        UPDATE Fees SET status = 'Partial' 
        WHERE fee_id = fee_record_id;
    END IF;
END$$

-- Trigger 10: Book availability update on issue
CREATE TRIGGER update_book_availability_on_issue
AFTER INSERT ON BookIssues
FOR EACH ROW
BEGIN
    UPDATE Books SET available_copies = available_copies - 1 
    WHERE book_id = NEW.book_id;
END$$

-- Trigger 11: Book availability update on return
CREATE TRIGGER update_book_availability_on_return
AFTER UPDATE ON BookIssues
FOR EACH ROW
BEGIN
    IF NEW.status = 'Returned' AND OLD.status != 'Returned' THEN
        UPDATE Books SET available_copies = available_copies + 1 
        WHERE book_id = NEW.book_id;
    END IF;
END$$

DELIMITER ;

-- ============================================
-- VIEWS FOR ANALYTICS
-- ============================================

-- View 1: Student Performance Summary
CREATE VIEW StudentPerformanceSummary AS
SELECT 
    s.student_id, 
    s.student_roll_no,
    s.first_name, 
    s.last_name, 
    s.email,
    s.phone,
    s.status,
    COUNT(DISTINCT r.course_id) AS courses_completed,
    ROUND(COALESCE(AVG(r.percentage), 0), 2) AS overall_percentage,
    ROUND(COALESCE(AVG(r.grade_points), 0), 2) AS cgpa,
    SUM(CASE WHEN r.is_passed = FALSE THEN 1 ELSE 0 END) AS total_backlogs,
    CASE 
        WHEN ROUND(COALESCE(AVG(r.percentage), 0), 2) >= 85 THEN 'Excellent'
        WHEN ROUND(COALESCE(AVG(r.percentage), 0), 2) >= 70 THEN 'Good'
        WHEN ROUND(COALESCE(AVG(r.percentage), 0), 2) >= 60 THEN 'Average'
        WHEN ROUND(COALESCE(AVG(r.percentage), 0), 2) >= 50 THEN 'Satisfactory'
        ELSE 'Need Improvement'
    END AS performance_category
FROM Students s 
LEFT JOIN Results r ON s.student_id = r.student_id
GROUP BY s.student_id;

-- View 2: Fee Collection Summary
CREATE VIEW FeeCollectionSummary AS
SELECT 
    s.student_id, 
    s.first_name, 
    s.last_name, 
    s.student_roll_no,
    f.semester,
    f.total_fees, 
    f.paid_amount, 
    (f.total_fees - f.paid_amount) AS due_amount, 
    f.status,
    f.due_date,
    DATEDIFF(CURDATE(), f.due_date) AS days_overdue,
    f.late_fee
FROM Students s 
JOIN Fees f ON s.student_id = f.student_id
WHERE f.status IN ('Pending', 'Partial', 'Overdue');

-- View 3: Library Usage Summary
CREATE VIEW LibraryUsageSummary AS
SELECT 
    s.student_id, 
    s.first_name, 
    s.last_name,
    s.student_roll_no,
    COUNT(bi.issue_id) AS total_books_issued, 
    COALESCE(SUM(bi.fine_amount), 0) AS total_fine,
    COUNT(CASE WHEN bi.status = 'Issued' THEN 1 END) AS currently_issued,
    COUNT(CASE WHEN bi.return_date > bi.due_date THEN 1 END) AS late_returns
FROM Students s 
LEFT JOIN BookIssues bi ON s.student_id = bi.student_id
GROUP BY s.student_id;

-- View 4: Placement Statistics Dashboard
CREATE VIEW PlacementStatistics AS
SELECT 
    c.company_name, 
    c.industry, 
    COUNT(p.placement_id) AS total_selected,
    COALESCE(AVG(p.package), 0) AS average_package,
    COALESCE(MAX(p.package), 0) AS highest_package,
    COALESCE(MIN(p.package), 0) AS lowest_package,
    YEAR(p.placement_date) AS placement_year
FROM Companies c 
LEFT JOIN Placements p ON c.company_id = p.company_id AND p.status = 'Selected'
GROUP BY c.company_id, YEAR(p.placement_date);

-- View 5: Faculty Performance Review
CREATE VIEW FacultyPerformance AS
SELECT 
    f.faculty_id, 
    f.faculty_code,
    f.first_name, 
    f.last_name, 
    f.department,
    f.designation,
    ROUND(COALESCE(AVG(fb.rating), 0), 2) AS avg_rating,
    ROUND(COALESCE(AVG(fb.teaching_quality), 0), 2) AS teaching_quality,
    ROUND(COALESCE(AVG(fb.communication_skills), 0), 2) AS communication_skills,
    COUNT(DISTINCT fb.student_id) AS feedback_count,
    CASE 
        WHEN ROUND(COALESCE(AVG(fb.rating), 0), 2) >= 4.5 THEN 'Outstanding'
        WHEN ROUND(COALESCE(AVG(fb.rating), 0), 2) >= 4.0 THEN 'Excellent'
        WHEN ROUND(COALESCE(AVG(fb.rating), 0), 2) >= 3.5 THEN 'Good'
        WHEN ROUND(COALESCE(AVG(fb.rating), 0), 2) >= 3.0 THEN 'Satisfactory'
        ELSE 'Need Improvement'
    END AS performance_rating
FROM Faculty f 
LEFT JOIN Feedback fb ON f.faculty_id = fb.faculty_id
GROUP BY f.faculty_id;

-- View 6: Course Analytics
CREATE VIEW CourseAnalytics AS
SELECT 
    c.course_id,
    c.course_code,
    c.course_name,
    c.department,
    c.semester,
    c.credits,
    COUNT(DISTINCT e.student_id) AS enrolled_students,
    c.max_seats,
    ROUND((c.enrolled_seats * 100.0 / c.max_seats), 2) AS seat_occupancy,
    ROUND(COALESCE(AVG(r.percentage), 0), 2) AS average_marks,
    COALESCE(MAX(r.percentage), 0) AS highest_marks,
    COALESCE(MIN(r.percentage), 0) AS lowest_marks,
    ROUND((SUM(CASE WHEN r.is_passed = TRUE THEN 1 ELSE 0 END) * 100.0 / NULLIF(COUNT(r.student_id), 0)), 2) AS pass_percentage
FROM Courses c
LEFT JOIN Enrollments e ON c.course_id = e.course_id AND e.status = 'Enrolled'
LEFT JOIN Results r ON c.course_id = r.course_id
GROUP BY c.course_id;

-- View 7: Dashboard Metrics
CREATE VIEW DashboardMetrics AS
SELECT 
    (SELECT COUNT(*) FROM Students WHERE status = 'Active') AS total_active_students,
    (SELECT COUNT(*) FROM Students) AS total_students,
    (SELECT COUNT(*) FROM Faculty WHERE status = 'Active') AS active_faculty,
    (SELECT COUNT(*) FROM Faculty) AS total_faculty,
    (SELECT COUNT(*) FROM Courses WHERE status = 'Active') AS active_courses,
    (SELECT COUNT(*) FROM Courses) AS total_courses,
    (SELECT COUNT(*) FROM Books WHERE available_copies > 0) AS available_books,
    (SELECT COUNT(*) FROM Books) AS total_books,
    (SELECT COUNT(*) FROM BookIssues WHERE status = 'Issued') AS books_issued,
    (SELECT COALESCE(SUM(paid_amount), 0) FROM Fees WHERE status IN ('Paid', 'Partial')) AS total_fees_collected,
    (SELECT COALESCE(SUM(amount), 0) FROM FeeTransactions WHERE MONTH(transaction_date) = MONTH(CURDATE()) AND YEAR(transaction_date) = YEAR(CURDATE())) AS monthly_collection,
    (SELECT COALESCE(SUM(due_amount), 0) FROM (SELECT (total_fees - paid_amount) AS due_amount FROM Fees WHERE status IN ('Pending', 'Partial')) AS due) AS total_due_fees,
    (SELECT COUNT(*) FROM Scholarships WHERE status = 'Open') AS open_scholarships,
    (SELECT COUNT(*) FROM StudentScholarships WHERE status = 'Approved') AS scholarships_awarded,
    (SELECT COUNT(*) FROM Placements WHERE YEAR(placement_date) = YEAR(CURDATE()) AND status = 'Selected') AS current_year_placements,
    (SELECT ROUND(COALESCE(AVG(rating), 0), 2) FROM Feedback) AS avg_feedback_rating,
    (SELECT COUNT(*) FROM Events WHERE event_date > CURDATE()) AS upcoming_events,
    (SELECT COUNT(*) FROM HostelAllocations WHERE status = 'Active') AS hostel_occupancy,
    (SELECT COUNT(*) FROM Certificates WHERE YEAR(issue_date) = YEAR(CURDATE())) AS certificates_issued,
    (SELECT COUNT(*) FROM LeaveApplications WHERE status = 'Pending') AS pending_leave_requests,
    (SELECT COUNT(*) FROM Notifications WHERE status = 'Pending') AS pending_notifications,
    (SELECT COUNT(*) FROM Complaints WHERE status IN ('Pending', 'In Progress')) AS pending_complaints,
    (SELECT COUNT(*) FROM Alumni WHERE is_active_alumni = TRUE) AS active_alumni,
    (SELECT COUNT(*) FROM ClubMemberships WHERE status = 'Active') AS active_club_members;

-- View 8: Student Attendance Report
CREATE VIEW StudentAttendanceReport AS
SELECT 
    s.student_id,
    s.first_name,
    s.last_name,
    s.student_roll_no,
    c.course_name,
    COUNT(a.attendance_id) AS total_classes,
    SUM(CASE WHEN a.status = 'Present' THEN 1 ELSE 0 END) AS present,
    SUM(CASE WHEN a.status = 'Absent' THEN 1 ELSE 0 END) AS absent,
    SUM(CASE WHEN a.status = 'Late' THEN 1 ELSE 0 END) AS late,
    SUM(CASE WHEN a.status = 'Excused' THEN 1 ELSE 0 END) AS excused,
    ROUND((SUM(CASE WHEN a.status IN ('Present', 'Late') THEN 1 ELSE 0 END) * 100.0 / NULLIF(COUNT(a.attendance_id), 0)), 2) AS attendance_percentage,
    CASE 
        WHEN ROUND((SUM(CASE WHEN a.status IN ('Present', 'Late') THEN 1 ELSE 0 END) * 100.0 / NULLIF(COUNT(a.attendance_id), 0)), 2) >= 75 THEN 'Eligible for Exams'
        ELSE 'Not Eligible for Exams'
    END AS exam_eligibility
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id
LEFT JOIN Attendance a ON s.student_id = a.student_id AND c.course_id = a.course_id
GROUP BY s.student_id, c.course_id;

-- View 9: Fee Defaulters
CREATE VIEW FeeDefaulters AS
SELECT 
    s.student_id,
    s.first_name,
    s.last_name,
    s.student_roll_no,
    s.email,
    s.phone,
    f.semester,
    f.total_fees,
    f.paid_amount,
    (f.total_fees - f.paid_amount) AS due_amount,
    f.due_date,
    DATEDIFF(CURDATE(), f.due_date) AS days_overdue,
    CASE 
        WHEN DATEDIFF(CURDATE(), f.due_date) > 90 THEN 'Legal Notice'
        WHEN DATEDIFF(CURDATE(), f.due_date) > 60 THEN 'Final Notice'
        WHEN DATEDIFF(CURDATE(), f.due_date) > 30 THEN 'Second Notice'
        WHEN DATEDIFF(CURDATE(), f.due_date) > 15 THEN 'First Notice'
        ELSE 'Reminder'
    END AS notice_level,
    f.late_fee
FROM Students s
JOIN Fees f ON s.student_id = f.student_id
WHERE f.status IN ('Pending', 'Partial') 
AND f.due_date < CURDATE()
ORDER BY days_overdue DESC;

-- View 10: Alumni Status Report
CREATE VIEW AlumniReport AS
SELECT 
    a.alumni_id,
    s.first_name,
    s.last_name,
    s.email,
    s.phone,
    a.graduation_year,
    a.current_company,
    a.current_designation,
    a.current_location,
    a.is_active_alumni,
    COUNT(DISTINCT ar.event_id) AS events_attended,
    COUNT(DISTINCT ach.achievement_id) AS achievements_count
FROM Alumni a
JOIN Students s ON a.student_id = s.student_id
LEFT JOIN AlumniRegistrations ar ON a.alumni_id = ar.alumni_id AND ar.attendance_status = TRUE
LEFT JOIN Achievements ach ON s.student_id = ach.student_id
GROUP BY a.alumni_id;

-- ============================================
-- STORED PROCEDURES
-- ============================================

DELIMITER $$

-- Procedure 1: Add New Student with Complete Details
CREATE PROCEDURE AddNewStudent(
    IN p_first_name VARCHAR(50),
    IN p_last_name VARCHAR(50),
    IN p_dob DATE,
    IN p_gender VARCHAR(10),
    IN p_email VARCHAR(100),
    IN p_phone VARCHAR(15),
    IN p_address TEXT,
    IN p_city VARCHAR(50),
    IN p_state VARCHAR(50),
    IN p_pincode VARCHAR(10),
    IN p_blood_group VARCHAR(5),
    IN p_aadhar VARCHAR(12)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    -- Check if email already exists
    IF EXISTS (SELECT 1 FROM Students WHERE email = p_email) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Email already exists';
    END IF;
    
    -- Check if aadhar already exists
    IF EXISTS (SELECT 1 FROM Students WHERE aadhar_number = p_aadhar) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Aadhar number already exists';
    END IF;
    
    -- Insert student
    INSERT INTO Students (first_name, last_name, date_of_birth, gender, email, phone, address, 
                         city, state, pincode, blood_group, aadhar_number)
    VALUES (p_first_name, p_last_name, p_dob, p_gender, p_email, p_phone, p_address,
            p_city, p_state, p_pincode, p_blood_group, p_aadhar);
    
    -- Create user account for student
    INSERT INTO Users (username, password_hash, email, role_id, student_id, is_active)
    VALUES (p_email, MD5(CONCAT('Student@', p_dob)), p_email, 
            (SELECT role_id FROM UserRoles WHERE role_name = 'Student'), LAST_INSERT_ID(), TRUE);
    
    COMMIT;
    
    SELECT 'Student added successfully with user account!' AS Message;
END$$

-- Procedure 2: Comprehensive Student Report
CREATE PROCEDURE GenerateComprehensiveReport(IN p_student_id INT)
BEGIN
    -- Personal Information
    SELECT '=== PERSONAL INFORMATION ===' AS Section;
    SELECT student_id, student_roll_no, first_name, last_name, email, phone, 
           address, city, state, blood_group, enrollment_date, status
    FROM Students WHERE student_id = p_student_id;
    
    -- Academic Performance
    SELECT '=== ACADEMIC PERFORMANCE ===' AS Section;
    SELECT c.course_code, c.course_name, r.semester, r.marks_obtained, 
           r.percentage, r.grade, r.grade_points
    FROM Results r 
    JOIN Courses c ON r.course_id = c.course_id
    WHERE r.student_id = p_student_id 
    ORDER BY r.semester DESC;
    
    -- CGPA and Summary
    SELECT '=== ACADEMIC SUMMARY ===' AS Section;
    SELECT 
        COUNT(DISTINCT r.course_id) AS courses_taken,
        ROUND(AVG(r.percentage), 2) AS overall_percentage,
        ROUND(SUM(r.grade_points * c.credits) / SUM(c.credits), 2) AS cgpa,
        SUM(CASE WHEN r.is_passed = FALSE THEN 1 ELSE 0 END) AS backlogs
    FROM Results r
    JOIN Courses c ON r.course_id = c.course_id
    WHERE r.student_id = p_student_id;
    
    -- Attendance Report
    SELECT '=== ATTENDANCE REPORT ===' AS Section;
    SELECT 
        c.course_name,
        COUNT(a.attendance_id) AS total_classes,
        SUM(CASE WHEN a.status = 'Present' THEN 1 ELSE 0 END) AS present,
        SUM(CASE WHEN a.status = 'Absent' THEN 1 ELSE 0 END) AS absent,
        ROUND((SUM(CASE WHEN a.status = 'Present' THEN 1 ELSE 0 END) * 100.0 / COUNT(a.attendance_id)), 2) AS attendance_pct
    FROM Attendance a
    JOIN Courses c ON a.course_id = c.course_id
    WHERE a.student_id = p_student_id
    GROUP BY c.course_id;
    
    -- Fee Status
    SELECT '=== FEE STATUS ===' AS Section;
    SELECT semester, total_fees, paid_amount, (total_fees - paid_amount) AS due, 
           status, due_date, late_fee
    FROM Fees WHERE student_id = p_student_id;
    
    -- Library Books
    SELECT '=== LIBRARY BOOKS ===' AS Section;
    SELECT b.title, b.author, bi.issue_date, bi.due_date, bi.status, bi.fine_amount
    FROM BookIssues bi 
    JOIN Books b ON bi.book_id = b.book_id
    WHERE bi.student_id = p_student_id;
    
    -- Hostel Information
    SELECT '=== HOSTEL INFORMATION ===' AS Section;
    SELECT h.hostel_name, hr.room_no, hr.room_type, ha.allocation_date, ha.rent_paid_up_to
    FROM HostelAllocations ha
    JOIN HostelRooms hr ON ha.room_id = hr.room_id
    JOIN Hostels h ON hr.hostel_id = h.hostel_id
    WHERE ha.student_id = p_student_id AND ha.status = 'Active';
    
    -- Placement Status
    SELECT '=== PLACEMENT STATUS ===' AS Section;
    SELECT c.company_name, p.job_role, p.package, p.placement_date, p.status
    FROM Placements p
    JOIN Companies c ON p.company_id = c.company_id
    WHERE p.student_id = p_student_id;
    
    -- Achievements
    SELECT '=== ACHIEVEMENTS ===' AS Section;
    SELECT achievement_type, title, level, date_achieved, description
    FROM Achievements
    WHERE student_id = p_student_id
    ORDER BY date_achieved DESC;
    
    -- Leave Summary
    SELECT '=== LEAVE SUMMARY ===' AS Section;
    SELECT lt.leave_type_name, COUNT(*) AS total_leaves, SUM(total_days) AS total_days
    FROM LeaveApplications l
    JOIN LeaveTypes lt ON l.leave_type = lt.leave_type_id
    WHERE l.student_id = p_student_id AND l.status = 'Approved'
    GROUP BY lt.leave_type_name;
END$$

-- Procedure 3: Bulk Enroll Students
CREATE PROCEDURE BulkEnrollStudentsInCourse(
    IN p_course_id INT,
    IN p_student_ids TEXT
)
BEGIN
    DECLARE v_done INT DEFAULT FALSE;
    DECLARE v_student_id INT;
    DECLARE v_enrolled INT DEFAULT 0;
    DECLARE v_failed INT DEFAULT 0;
    DECLARE v_cursor CURSOR FOR 
        SELECT DISTINCT CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(p_student_ids, ',', n), ',', -1) AS UNSIGNED) AS value
        FROM (
            SELECT 1 n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 
            UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10
        ) nums
        WHERE n <= 1 + (LENGTH(p_student_ids) - LENGTH(REPLACE(p_student_ids, ',', '')));
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = TRUE;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
        SET v_failed = v_failed + 1;
    END;
    
    OPEN v_cursor;
    read_loop: LOOP
        FETCH v_cursor INTO v_student_id;
        IF v_done THEN LEAVE read_loop; END IF;
        
        IF v_student_id IS NOT NULL AND NOT EXISTS (
            SELECT 1 FROM Enrollments WHERE student_id = v_student_id AND course_id = p_course_id
        ) THEN
            INSERT INTO Enrollments (student_id, course_id) VALUES (v_student_id, p_course_id);
            SET v_enrolled = v_enrolled + 1;
        END IF;
    END LOOP;
    CLOSE v_cursor;
    
    SELECT CONCAT('Enrolled ', v_enrolled, ' students successfully. Failed: ', v_failed) AS Result;
END$$

-- Procedure 4: Apply for Scholarship with Auto-Check
CREATE PROCEDURE ApplyForScholarship(
    IN p_student_id INT, 
    IN p_scholarship_id INT
)
BEGIN
    DECLARE student_cgpa DECIMAL(5,2);
    DECLARE student_percentage DECIMAL(5,2);
    DECLARE min_percent DECIMAL(5,2);
    DECLARE max_income DECIMAL(10,2);
    DECLARE family_income DECIMAL(10,2);
    DECLARE scholarship_name_val VARCHAR(100);
    
    -- Get student's academic performance
    SELECT ROUND(AVG(percentage), 2), ROUND((SUM(grade_points * c.credits) / SUM(c.credits)), 2)
    INTO student_percentage, student_cgpa
    FROM Results r
    JOIN Courses c ON r.course_id = c.course_id
    WHERE r.student_id = p_student_id;
    
    -- Get scholarship requirements
    SELECT min_percentage, max_family_income, scholarship_name 
    INTO min_percent, max_income, scholarship_name_val
    FROM Scholarships 
    WHERE scholarship_id = p_scholarship_id;
    
    -- Get family income
    SELECT family_annual_income INTO family_income
    FROM Parents WHERE student_id = p_student_id;
    
    -- Check eligibility
    IF student_percentage IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No grades recorded for this student';
    END IF;
    
    IF student_percentage < min_percent THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Not eligible: Does not meet minimum percentage requirement';
    END IF;
    
    IF max_income IS NOT NULL AND family_income > max_income THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Not eligible: Family income exceeds limit';
    END IF;
    
    -- Apply for scholarship
    INSERT INTO StudentScholarships (student_id, scholarship_id, application_date, status)
    VALUES (p_student_id, p_scholarship_id, CURDATE(), 'Applied');
    
    -- Create notification
    INSERT INTO Notifications (student_id, type, subject, message, status)
    VALUES (p_student_id, 'Email', 'Scholarship Application Submitted', 
            CONCAT('Your application for ', scholarship_name_val, ' has been submitted successfully.'), 'Pending');
    
    SELECT CONCAT('Applied for ', scholarship_name_val, ' successfully!') AS Message;
END$$

-- Procedure 5: Register Complaint
CREATE PROCEDURE RegisterComplaint(
    IN p_student_id INT,
    IN p_category_id INT,
    IN p_subject VARCHAR(200),
    IN p_description TEXT,
    IN p_priority VARCHAR(10)
)
BEGIN
    INSERT INTO Complaints (student_id, category_id, subject, description, priority, status)
    VALUES (p_student_id, p_category_id, p_subject, p_description, p_priority, 'Pending');
    
    SELECT CONCAT('Complaint #', LAST_INSERT_ID(), ' registered successfully. Tracking ID: CMP', LAST_INSERT_ID()) AS Message;
END$$

-- Procedure 6: Mark Student Attendance
CREATE PROCEDURE MarkAttendance(
    IN p_student_id INT,
    IN p_course_id INT,
    IN p_status VARCHAR(10),
    IN p_remarks TEXT
)
BEGIN
    DECLARE today DATE DEFAULT CURDATE();
    
    IF EXISTS (SELECT 1 FROM Attendance WHERE student_id = p_student_id AND course_id = p_course_id AND attendance_date = today) THEN
        UPDATE Attendance 
        SET status = p_status, remarks = p_remarks, marked_by = USER()
        WHERE student_id = p_student_id AND course_id = p_course_id AND attendance_date = today;
        SELECT 'Attendance updated successfully!' AS Message;
    ELSE
        INSERT INTO Attendance (student_id, course_id, attendance_date, status, remarks, marked_by)
        VALUES (p_student_id, p_course_id, today, p_status, p_remarks, USER());
        SELECT 'Attendance marked successfully!' AS Message;
    END IF;
END$$

-- Procedure 7: Record Placement Details
CREATE PROCEDURE RecordStudentPlacement(
    IN p_student_id INT,
    IN p_company_name VARCHAR(100),
    IN p_job_role VARCHAR(100),
    IN p_package DECIMAL(10,2),
    IN p_placement_type VARCHAR(20)
)
BEGIN
    DECLARE company_id_val INT;
    DECLARE job_id_val INT;
    
    -- Get or create company
    SELECT company_id INTO company_id_val FROM Companies WHERE company_name = p_company_name;
    IF company_id_val IS NULL THEN
        INSERT INTO Companies (company_name) VALUES (p_company_name);
        SET company_id_val = LAST_INSERT_ID();
    END IF;
    
    -- Create job posting
    INSERT INTO JobPostings (company_id, job_title, job_type, package_min, package_max, posted_date, status)
    VALUES (company_id_val, p_job_role, p_placement_type, p_package, p_package, CURDATE(), 'Filled');
    SET job_id_val = LAST_INSERT_ID();
    
    -- Record placement
    INSERT INTO Placements (student_id, company_id, job_id, job_role, package, placement_date, placement_type, status)
    VALUES (p_student_id, company_id_val, job_id_val, p_job_role, p_package, CURDATE(), p_placement_type, 'Selected');
    
    -- Update student status
    UPDATE Students SET status = 'Graduated' WHERE student_id = p_student_id;
    
    -- Create notification
    INSERT INTO Notifications (student_id, type, subject, message, status)
    VALUES (p_student_id, 'Email', 'Placement Confirmation', 
            CONCAT('Congratulations! You have been placed at ', p_company_name, ' as ', p_job_role, ' with package ₹', p_package), 'Pending');
    
    SELECT 'Placement recorded successfully! Student marked as graduated.' AS Message;
END$$

-- Procedure 8: Generate Student Certificate
CREATE PROCEDURE GenerateStudentCertificate(
    IN p_student_id INT,
    IN p_certificate_type VARCHAR(50),
    IN p_description TEXT
)
BEGIN
    DECLARE cert_no VARCHAR(50);
    DECLARE verify_code VARCHAR(50);
    DECLARE student_name VARCHAR(100);
    
    SELECT CONCAT(first_name, ' ', last_name) INTO student_name 
    FROM Students WHERE student_id = p_student_id;
    
    SET cert_no = CONCAT('CERT-', DATE_FORMAT(CURDATE(), '%Y'), '-', LPAD(p_student_id, 6, '0'), '-', FLOOR(RAND() * 1000));
    SET verify_code = UPPER(CONCAT(SUBSTRING(MD5(CONCAT(p_student_id, RAND(), NOW())), 1, 12)));
    
    INSERT INTO Certificates (student_id, certificate_type, issue_date, certificate_no, description, verification_code)
    VALUES (p_student_id, p_certificate_type, CURDATE(), cert_no, p_description, verify_code);
    
    SELECT cert_no AS Certificate_Number, verify_code AS Verification_Code, student_name AS Student_Name;
END$$

-- Procedure 9: Evaluate Student Performance
CREATE PROCEDURE EvaluateStudentPerformance(
    IN p_student_id INT
)
BEGIN
    DECLARE overall_grade VARCHAR(2);
    DECLARE remarks TEXT;
    
    SELECT 
        CASE 
            WHEN AVG(percentage) >= 90 THEN 'A+'
            WHEN AVG(percentage) >= 80 THEN 'A'
            WHEN AVG(percentage) >= 70 THEN 'B'
            WHEN AVG(percentage) >= 60 THEN 'C'
            WHEN AVG(percentage) >= 50 THEN 'D'
            ELSE 'F'
        END INTO overall_grade
    FROM Results
    WHERE student_id = p_student_id;
    
    SELECT 
        CONCAT('Overall Grade: ', overall_grade) AS Result;
    
    -- Performance Analysis
    WITH StudentGrades AS (
        SELECT 
            CASE 
                WHEN percentage >= 90 THEN 'A+ (90-100)'
                WHEN percentage >= 80 THEN 'A (80-89)'
                WHEN percentage >= 70 THEN 'B (70-79)'
                WHEN percentage >= 60 THEN 'C (60-69)'
                WHEN percentage >= 50 THEN 'D (50-59)'
                ELSE 'F (Below 50)'
            END AS grade_range,
            COUNT(*) AS count
        FROM Results
        WHERE student_id = p_student_id
        GROUP BY grade_range
    )
    SELECT * FROM StudentGrades ORDER BY grade_range;
    
    -- Recommendations
    SELECT 
        'Recommendations:' AS Section,
        CASE 
            WHEN AVG(percentage) >= 85 THEN 'Excellent performance! Eligible for scholarships.'
            WHEN AVG(percentage) >= 75 THEN 'Good performance. Maintain consistency.'
            WHEN AVG(percentage) >= 60 THEN 'Average performance. Need improvement.'
            WHEN AVG(percentage) >= 50 THEN 'Need significant improvement. Attend remedial classes.'
            ELSE 'Poor performance. Meet with academic advisor immediately.'
        END AS recommendation
    FROM Results
    WHERE student_id = p_student_id;
END$$

-- Procedure 10: Get Top Performing Students
CREATE PROCEDURE GetTopStudents(IN p_limit INT)
BEGIN
    SELECT 
        s.student_id,
        s.student_roll_no,
        s.first_name,
        s.last_name,
        ROUND(AVG(r.percentage), 2) AS avg_percentage,
        ROUND(SUM(r.grade_points * c.credits) / SUM(c.credits), 2) AS cgpa,
        COUNT(r.course_id) AS courses_completed,
        s.status
    FROM Students s
    JOIN Results r ON s.student_id = r.student_id
    JOIN Courses c ON r.course_id = c.course_id
    GROUP BY s.student_id
    ORDER BY cgpa DESC, avg_percentage DESC
    LIMIT p_limit;
END$$

-- Procedure 11: Download Fee Structure
CREATE PROCEDURE GenerateFeeReceipt(IN p_transaction_id INT)
BEGIN
    SELECT 
        ft.receipt_no,
        ft.transaction_date,
        s.first_name,
        s.last_name,
        s.student_roll_no,
        f.semester,
        ft.amount,
        ft.payment_mode,
        ft.bank_name,
        ft.cheque_no,
        ft.remarks,
        f.total_fees,
        f.paid_amount,
        (f.total_fees - f.paid_amount) AS balance_due
    FROM FeeTransactions ft
    JOIN Students s ON ft.student_id = s.student_id
    JOIN Fees f ON ft.fee_id = f.fee_id
    WHERE ft.transaction_id = p_transaction_id;
END$$

-- Procedure 12: Leave Balance Report
CREATE PROCEDURE GetLeaveBalanceForStudent(IN p_student_id INT)
BEGIN
    SELECT 
        lt.leave_type_name,
        lt.max_days_per_year,
        COALESCE(SUM(l.total_days), 0) AS days_used,
        lt.max_days_per_year - COALESCE(SUM(l.total_days), 0) AS days_remaining
    FROM LeaveTypes lt
    CROSS JOIN (SELECT DISTINCT YEAR(application_date) AS current_year FROM LeaveApplications WHERE student_id = p_student_id UNION SELECT YEAR(CURDATE())) years
    LEFT JOIN LeaveApplications l ON lt.leave_type_id = l.leave_type 
        AND l.student_id = p_student_id 
        AND l.status = 'Approved'
        AND YEAR(l.application_date) = YEAR(CURDATE())
    GROUP BY lt.leave_type_id;
END$$

-- Procedure 13: Send Bulk Notifications
CREATE PROCEDURE SendBulkNotifications(
    IN p_message TEXT,
    IN p_student_list TEXT,
    IN p_type VARCHAR(10)
)
BEGIN    DECLARE v_done INT DEFAULT FALSE;
    DECLARE v_student_id INT;
    DECLARE v_cursor CURSOR FOR 
        SELECT DISTINCT CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(p_student_list, ',', n), ',', -1) AS UNSIGNED) AS value
        FROM (
            SELECT 1 n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 
            UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10
            UNION SELECT 11 UNION SELECT 12 UNION SELECT 13 UNION SELECT 14 UNION SELECT 15
            UNION SELECT 16 UNION SELECT 17 UNION SELECT 18 UNION SELECT 19 UNION SELECT 20
        ) nums
        WHERE n <= 1 + (LENGTH(p_student_list) - LENGTH(REPLACE(p_student_list, ',', '')));
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = TRUE;
    
    OPEN v_cursor;
    send_loop: LOOP
        FETCH v_cursor INTO v_student_id;
        IF v_done THEN LEAVE send_loop; END IF;
        
        INSERT INTO Notifications (student_id, type, subject, message, status)
        VALUES (v_student_id, p_type, 'Bulk Notification', p_message, 'Pending');
    END LOOP;
    CLOSE v_cursor;
    
    SELECT CONCAT('Notifications sent to ', (SELECT COUNT(*) FROM (SELECT DISTINCT CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(p_student_list, ',', n), ',', -1) AS UNSIGNED) AS value FROM (SELECT 1 n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10 UNION SELECT 11 UNION SELECT 12 UNION SELECT 13 UNION SELECT 14 UNION SELECT 15 UNION SELECT 16 UNION SELECT 17 UNION SELECT 18 UNION SELECT 19 UNION SELECT 20) nums WHERE n <= 1 + (LENGTH(p_student_list) - LENGTH(REPLACE(p_student_list, ',', '')))) t), ' students') AS Result;
END$$

-- Procedure 14: Generate Academic Calendar
CREATE PROCEDURE GenerateAcademicCalendar(IN p_year INT, IN p_semester VARCHAR(10))
BEGIN
    SELECT 
        event_name,
        event_type,
        event_date,
        start_time,
        end_time,
        venue,
        description
    FROM Events
    WHERE YEAR(event_date) = p_year
        AND (p_semester = 'All' OR 
             (p_semester = 'Odd' AND MONTH(event_date) BETWEEN 7 AND 12) OR
             (p_semester = 'Even' AND MONTH(event_date) BETWEEN 1 AND 6))
    ORDER BY event_date;
END$$

-- Procedure 15: Student Progress Report
CREATE PROCEDURE StudentProgressReport(IN p_student_id INT)
BEGIN
    SELECT 
        'Semester-wise Progress' AS Report_Title;
    
    SELECT 
        r.semester,
        COUNT(r.course_id) AS courses_taken,
        ROUND(AVG(r.percentage), 2) AS semester_percentage,
        ROUND(AVG(r.grade_points), 2) AS semester_gpa,
        SUM(CASE WHEN r.is_passed = FALSE THEN 1 ELSE 0 END) AS backlogs_this_semester
    FROM Results r
    WHERE r.student_id = p_student_id
    GROUP BY r.semester
    ORDER BY r.semester;
    
    SELECT 
        'Performance Trend' AS Chart_Data;
    
    SELECT 
        r.semester,
        ROUND(AVG(r.percentage), 2) AS percentage,
        ROUND(AVG(r.grade_points), 2) AS gpa
    FROM Results r
    WHERE r.student_id = p_student_id
    GROUP BY r.semester
    ORDER BY r.semester;
END$$

DELIMITER ;

-- ============================================
-- INSERT SAMPLE DATA
-- ============================================

-- Insert User Roles
INSERT INTO UserRoles (role_id, role_name, permissions) VALUES
(1, 'Admin', '{"all": true}'),
(2, 'Registrar', '{"students": "rw", "courses": "rw"}'),
(3, 'Faculty', '{"attendance": "rw", "marks": "rw"}'),
(4, 'Student', '{"profile": "r", "results": "r"}'),
(5, 'Accountant', '{"fees": "rw"}'),
(6, 'Librarian', '{"books": "rw"}');

-- Insert Departments
INSERT INTO Departments (dept_code, dept_name, head_of_dept, contact_number, email, established_year) VALUES
('CS', 'Computer Science', 'Dr. Smith', '1111111111', 'cs@college.edu', 2000),
('EC', 'Electronics', 'Dr. Johnson', '2222222222', 'ec@college.edu', 2001),
('ME', 'Mechanical', 'Dr. Williams', '3333333333', 'me@college.edu', 1999);

-- Insert Courses
INSERT INTO Courses (course_code, course_name, credits, department, semester, year, max_seats, status) VALUES
('CS101', 'Database Systems', 4, 'CS', 3, 2024, 60, 'Active'),
('CS102', 'Data Structures', 4, 'CS', 3, 2024, 60, 'Active'),
('CS103', 'Operating Systems', 4, 'CS', 4, 2024, 60, 'Active'),
('CS104', 'Computer Networks', 3, 'CS', 4, 2024, 50, 'Active'),
('MA101', 'Calculus', 3, 'Math', 1, 2024, 80, 'Active'),
('MA102', 'Linear Algebra', 3, 'Math', 2, 2024, 80, 'Active');

-- Insert Students
INSERT INTO Students (first_name, last_name, date_of_birth, gender, email, phone, address, city, state, blood_group, status) VALUES
('John', 'Doe', '2002-05-15', 'Male', 'john@example.com', '9876543210', '123 Main St', 'New York', 'NY', 'O+', 'Active'),
('Priya', 'Sharma', '2001-08-22', 'Female', 'priya@example.com', '9988776655', '45 Park Street', 'Mumbai', 'MH', 'A+', 'Active'),
('Rahul', 'Verma', '2002-03-10', 'Male', 'rahul@example.com', '9876543211', '12 Lake View', 'Delhi', 'DL', 'B+', 'Active'),
('Sneha', 'Patel', '2001-11-05', 'Female', 'sneha@example.com', '9765432109', '78 Gandhi Nagar', 'Ahmedabad', 'GJ', 'AB+', 'Active'),
('Amit', 'Kumar', '2000-12-18', 'Male', 'amit@example.com', '9654321098', '234 Ring Road', 'Patna', 'BR', 'O-', 'Graduated'),
('Neha', 'Singh', '2002-07-30', 'Female', 'neha@example.com', '9543210987', '56 Civil Lines', 'Lucknow', 'UP', 'A-', 'Active');

-- Insert Faculty
INSERT INTO Faculty (faculty_code, first_name, last_name, email, phone, qualification, specialization, department, designation, status) VALUES
('FAC001', 'Dr.', 'Smith', 'smith@college.edu', '1111111111', 'PhD', 'Databases', 'CS', 'Professor', 'Active'),
('FAC002', 'Prof.', 'Johnson', 'johnson@college.edu', '2222222222', 'M.Tech', 'Algorithms', 'CS', 'Associate Professor', 'Active'),
('FAC003', 'Dr.', 'Williams', 'williams@college.edu', '3333333333', 'PhD', 'Calculus', 'Math', 'Professor', 'Active');

-- Insert Enrollments
INSERT INTO Enrollments (student_id, course_id, enrollment_date, status) VALUES
(1, 1, '2024-01-15', 'Enrolled'),
(1, 2, '2024-01-15', 'Enrolled'),
(2, 1, '2024-01-15', 'Enrolled'),
(2, 3, '2024-01-15', 'Enrolled'),
(3, 2, '2024-01-15', 'Enrolled'),
(3, 4, '2024-01-15', 'Enrolled'),
(4, 1, '2024-01-15', 'Enrolled'),
(5, 1, '2023-07-15', 'Completed');

-- Insert Results
INSERT INTO Results (student_id, course_id, marks_obtained, total_marks, semester) VALUES
(1, 1, 85, 100, 'Fall 2024'),
(1, 2, 78, 100, 'Fall 2024'),
(2, 1, 92, 100, 'Fall 2024'),
(2, 3, 88, 100, 'Fall 2024'),
(3, 2, 75, 100, 'Fall 2024'),
(3, 4, 82, 100, 'Fall 2024'),
(4, 1, 90, 100, 'Fall 2024'),
(5, 1, 78, 100, 'Spring 2024');

-- Insert Scholarships
INSERT INTO Scholarships (scholarship_name, amount, min_percentage, max_family_income, provider, deadline, status, total_slots, remaining_slots) VALUES
('Merit Scholarship', 50000, 85.00, NULL, 'Government', '2024-12-31', 'Open', 50, 45),
('Need Based Scholarship', 30000, 60.00, 500000, 'College', '2024-12-31', 'Open', 100, 80),
('CS Excellence Award', 40000, 80.00, NULL, 'CS Department', '2024-12-31', 'Open', 20, 18),
('Sports Scholarship', 25000, 50.00, 1000000, 'Sports Authority', '2024-12-20', 'Open', 30, 28);

-- Insert Parents Information
INSERT INTO Parents (student_id, father_name, father_phone, mother_name, mother_phone, family_annual_income) VALUES
(1, 'Robert Doe', '9876543210', 'Mary Doe', '9876543211', 800000),
(2, 'Raj Sharma', '9988776655', 'Neha Sharma', '9988776656', 600000),
(3, 'Ramesh Verma', '9876543212', 'Sunita Verma', '9876543213', 400000);

-- Insert Leave Types
INSERT INTO LeaveTypes (leave_type_name, max_days_per_year, is_paid, requires_document) VALUES
('Sick Leave', 12, TRUE, TRUE),
('Casual Leave', 15, TRUE, FALSE),
('Medical Leave', 30, TRUE, TRUE),
('Emergency Leave', 5, FALSE, FALSE);

-- Insert Complaint Categories
INSERT INTO ComplaintCategories (category_name, assigned_to) VALUES
('Academic', 'Academic Coordinator'),
('Library', 'Librarian'),
('Hostel', 'Hostel Warden'),
('Transport', 'Transport Officer'),
('Canteen', 'Canteen Manager');

-- Insert Clubs
INSERT INTO Clubs (club_name, club_type, description, established_year) VALUES
('Coding Club', 'Technical', 'Programming and development club', 2018),
('Drama Club', 'Cultural', 'Theatre and drama activities', 2015),
('Chess Club', 'Sports', 'Chess enthusiasts', 2016);

-- Insert Books
INSERT INTO BookCategories (category_name, description, rack_no) VALUES
('Computer Science', 'CS related books', 'A1'),
('Mathematics', 'Math books', 'B1'),
('Physics', 'Physics books', 'C1');

INSERT INTO Books (isbn, title, author, category_id, total_copies, available_copies) VALUES
('9780132350884', 'Database System Concepts', 'Silberschatz', 1, 5, 4),
('9780262033848', 'Introduction to Algorithms', 'Cormen', 1, 4, 3),
('9781491936364', 'Operating Systems', 'Tanenbaum', 1, 3, 2);

-- Insert Hostels
INSERT INTO Hostels (hostel_name, hostel_type, total_rooms, warden_name, warden_phone) VALUES
('Boys Hostel A', 'Boys', 50, 'Dr. Sharma', '9876543232'),
('Girls Hostel B', 'Girls', 45, 'Dr. Gupta', '9876543233');

INSERT INTO HostelRooms (hostel_id, room_no, room_type, floor_no, capacity, rent_per_month, is_ac) VALUES
(1, 'A-101', 'Single', 1, 1, 8000, TRUE),
(1, 'A-102', 'Double', 1, 2, 5000, FALSE),
(2, 'B-101', 'Single', 1, 1, 8500, TRUE);

-- Insert Fee Structure
INSERT INTO FeeStructure (course_id, semester, tuition_fee, examination_fee, library_fee, sports_fee, total_fees, academic_year) VALUES
(1, 3, 40000, 5000, 2000, 1000, 48000, '2024-2025'),
(2, 3, 40000, 5000, 2000, 1000, 48000, '2024-2025'),
(3, 4, 40000, 5000, 2000, 1000, 48000, '2024-2025');

-- Insert Fees
INSERT INTO Fees (student_id, semester, total_fees, paid_amount, due_date, status) VALUES
(1, 'Fall 2024', 48000, 48000, '2024-08-15', 'Paid'),
(2, 'Fall 2024', 48000, 30000, '2024-08-15', 'Partial'),
(3, 'Fall 2024', 48000, 20000, '2024-08-15', 'Partial'),
(4, 'Fall 2024', 48000, 0, '2024-08-15', 'Pending');

-- Insert Events
INSERT INTO Events (event_name, event_type, event_date, venue, organizer, registration_fee, max_participants) VALUES
('Tech Fest 2024', 'Cultural', '2024-12-15', 'Main Auditorium', 'Student Council', 500, 500),
('Hackathon 2024', 'Academic', '2024-11-20', 'CS Department', 'ACM Chapter', 200, 100),
('Annual Sports Meet', 'Sports', '2024-12-01', 'Sports Complex', 'Sports Club', 300, 300);

-- Insert Companies and Job Postings
INSERT INTO Companies (company_name, industry, location, contact_email) VALUES
('Google', 'Tech', 'Bangalore', 'hr@google.com'),
('Microsoft', 'Tech', 'Hyderabad', 'careers@microsoft.com'),
('Amazon', 'E-commerce', 'Chennai', 'hiring@amazon.com');

INSERT INTO JobPostings (company_id, job_title, job_type, package_min, package_max, last_date, status) VALUES
(1, 'Software Engineer', 'Full-Time', 2000000, 3000000, '2024-12-31', 'Open'),
(2, 'Data Scientist', 'Full-Time', 1800000, 2500000, '2024-12-31', 'Open'),
(3, 'SDE Intern', 'Internship', 300000, 500000, '2024-11-30', 'Open');

-- ============================================
-- DEMONSTRATION & TESTING
-- ============================================

SELECT '=========================================' AS '';
SELECT '🚀 STUDENT MANAGEMENT SYSTEM v5.0' AS '';
SELECT '=========================================' AS '';

-- Test 1: Add New Student
CALL AddNewStudent('Test', 'User', '2003-01-01', 'Male', 'test@example.com', '9999999999', 'Test Address', 'Test City', 'Test State', '123456', 'O+', '123456789012');

-- Test 2: View Dashboard Metrics
SELECT * FROM DashboardMetrics;

-- Test 3: Get Top Performing Students
CALL GetTopStudents(5);

-- Test 4: Apply for Scholarship
CALL ApplyForScholarship(1, 1);

-- Test 5: Mark Attendance
CALL MarkAttendance(1, 1, 'Present', 'On time');

-- Test 6: Register Complaint
CALL RegisterComplaint(1, 1, 'Library Issue', 'Book not available in library', 'Medium');

-- Test 7: View Student Performance Report
CALL StudentProgressReport(1);

-- Test 8: Generate Certificate
CALL GenerateStudentCertificate(1, 'Merit', 'Outstanding academic performance');

-- Test 9: Record Placement
CALL RecordStudentPlacement(5, 'Google', 'Software Engineer', 2500000, 'Full-Time');

-- Test 10: View Fee Defaulters
SELECT * FROM FeeDefaulters;

-- Test 11: View Attendance Report
SELECT * FROM StudentAttendanceReport WHERE student_id = 1;

-- Test 12: View Course Analytics
SELECT * FROM CourseAnalytics;

-- Test 13: View Faculty Performance
SELECT * FROM FacultyPerformance;

-- Test 14: Scholarship Applications
SELECT * FROM StudentScholarships;

-- Test 15: Check Alumni Status
SELECT * FROM AlumniReport;

-- ============================================
-- FINAL VERIFICATION
-- ============================================

SELECT '=========================================' AS '';
SELECT '📊 DATABASE STATISTICS' AS '';
SELECT '=========================================' AS '';

SELECT 'Total Tables' AS Metric, COUNT(*) AS Count 
FROM information_schema.tables 
WHERE table_schema = 'Project' AND table_type = 'BASE TABLE'
UNION ALL
SELECT 'Total Views', COUNT(*) 
FROM information_schema.views 
WHERE table_schema = 'Project'
UNION ALL
SELECT 'Total Procedures', COUNT(*) 
FROM information_schema.routines 
WHERE routine_schema = 'Project' AND routine_type = 'PROCEDURE'
UNION ALL
SELECT 'Total Triggers', COUNT(*) 
FROM information_schema.triggers 
WHERE trigger_schema = 'Project';

SELECT '=========================================' AS '';
SELECT '✅ SYSTEM READY - FEATURES INCLUDED:' AS '';
SELECT '1. Student Management' AS '';
SELECT '2. Course Management' AS '';
SELECT '3. Faculty Management' AS '';
SELECT '4. Fee Collection System' AS '';
SELECT '5. Library Management' AS '';
SELECT '6. Hostel Management' AS '';
SELECT '7. Scholarship Management' AS '';
SELECT '8. Placement Tracking' AS '';
SELECT '9. Event Management' AS '';
SELECT '10. Certificate Generation' AS '';
SELECT '11. Leave Management' AS '';
SELECT '12. Complaint System' AS '';
SELECT '13. Transport Management' AS '';
SELECT '14. Alumni Management' AS '';
SELECT '15. Club Activities' AS '';
SELECT '16. Mess Management' AS '';
SELECT '17. Time Table' AS '';
SELECT '18. Notification System' AS '';
SELECT '19. Audit Logs' AS '';
SELECT '20. User Role Management' AS '';
SELECT '=========================================' AS '';
SELECT '🎉 ULTIMATE STUDENT MANAGEMENT SYSTEM DEPLOYED SUCCESSFULLY!' AS '';
SELECT '=========================================' AS '';


INSERT INTO Students 
(student_roll_no, first_name, last_name, date_of_birth, gender, email, phone, alternate_phone, address, city, state, pincode, nationality, aadhar_number, blood_group, enrollment_date, status, profile_photo)
VALUES
('STU001', 'Rahul', 'Sharma', '2004-05-12', 'Male', 'rahul1@gmail.com', '9876543210', '9876500001', 'MG Road', 'Ahmedabad', 'Gujarat', '380001', 'Indian', '123456789101', 'A+', '2024-06-01', 'Active', 'rahul.jpg'),

('STU002', 'Priya', 'Patel', '2003-08-20', 'Female', 'priya2@gmail.com', '9876543211', '9876500002', 'Navrangpura', 'Ahmedabad', 'Gujarat', '380002', 'Indian', '123456789102', 'B+', '2024-06-02', 'Active', 'priya.jpg'),

('STU003', 'Amit', 'Verma', '2004-01-15', 'Male', 'amit3@gmail.com', '9876543212', '9876500003', 'Satellite', 'Ahmedabad', 'Gujarat', '380003', 'Indian', '123456789103', 'O+', '2024-06-03', 'Active', 'amit.jpg'),

('STU004', 'Sneha', 'Yadav', '2003-11-10', 'Female', 'sneha4@gmail.com', '9876543213', '9876500004', 'Vastrapur', 'Ahmedabad', 'Gujarat', '380004', 'Indian', '123456789104', 'AB+', '2024-06-04', 'Active', 'sneha.jpg'),

('STU005', 'Karan', 'Singh', '2004-03-22', 'Male', 'karan5@gmail.com', '9876543214', '9876500005', 'Maninagar', 'Ahmedabad', 'Gujarat', '380005', 'Indian', '123456789105', 'A-', '2024-06-05', 'Active', 'karan.jpg'),

('STU006', 'Neha', 'Gupta', '2003-07-18', 'Female', 'neha6@gmail.com', '9876543215', '9876500006', 'Paldi', 'Ahmedabad', 'Gujarat', '380006', 'Indian', '123456789106', 'B-', '2024-06-06', 'Active', 'neha.jpg'),

('STU007', 'Vikas', 'Mishra', '2004-09-14', 'Male', 'vikas7@gmail.com', '9876543216', '9876500007', 'CG Road', 'Ahmedabad', 'Gujarat', '380007', 'Indian', '123456789107', 'O-', '2024-06-07', 'Active', 'vikas.jpg'),

('STU008', 'Pooja', 'Joshi', '2003-12-25', 'Female', 'pooja8@gmail.com', '9876543217', '9876500008', 'Bopal', 'Ahmedabad', 'Gujarat', '380008', 'Indian', '123456789108', 'AB-', '2024-06-08', 'Active', 'pooja.jpg'),

('STU009', 'Arjun', 'Rao', '2004-02-05', 'Male', 'arjun9@gmail.com', '9876543218', '9876500009', 'Gota', 'Ahmedabad', 'Gujarat', '380009', 'Indian', '123456789109', 'A+', '2024-06-09', 'Active', 'arjun.jpg'),

('STU010', 'Riya', 'Mehta', '2003-06-30', 'Female', 'riya10@gmail.com', '9876543219', '9876500010', 'Naranpura', 'Ahmedabad', 'Gujarat', '380010', 'Indian', '123456789110', 'B+', '2024-06-10', 'Active', 'riya.jpg'),

('STU011', 'Sahil', 'Kumar', '2004-04-11', 'Male', 'sahil11@gmail.com', '9876543220', '9876500011', 'Chandkheda', 'Ahmedabad', 'Gujarat', '380011', 'Indian', '123456789111', 'O+', '2024-06-11', 'Active', 'sahil.jpg'),

('STU012', 'Anjali', 'Tiwari', '2003-10-19', 'Female', 'anjali12@gmail.com', '9876543221', '9876500012', 'Sabarmati', 'Ahmedabad', 'Gujarat', '380012', 'Indian', '123456789112', 'AB+', '2024-06-12', 'Active', 'anjali.jpg'),

('STU013', 'Deepak', 'Jain', '2004-07-07', 'Male', 'deepak13@gmail.com', '9876543222', '9876500013', 'Isanpur', 'Ahmedabad', 'Gujarat', '380013', 'Indian', '123456789113', 'A-', '2024-06-13', 'Active', 'deepak.jpg'),

('STU014', 'Kavya', 'Shah', '2003-09-28', 'Female', 'kavya14@gmail.com', '9876543223', '9876500014', 'Thaltej', 'Ahmedabad', 'Gujarat', '380014', 'Indian', '123456789114', 'B-', '2024-06-14', 'Active', 'kavya.jpg'),

('STU015', 'Rohit', 'Das', '2004-01-01', 'Male', 'rohit15@gmail.com', '9876543224', '9876500015', 'Naroda', 'Ahmedabad', 'Gujarat', '380015', 'Indian', '123456789115', 'O-', '2024-06-15', 'Active', 'rohit.jpg'),

('STU016', 'Simran', 'Kaur', '2003-05-16', 'Female', 'simran16@gmail.com', '9876543225', '9876500016', 'Memnagar', 'Ahmedabad', 'Gujarat', '380016', 'Indian', '123456789116', 'AB-', '2024-06-16', 'Active', 'simran.jpg'),

('STU017', 'Manoj', 'Roy', '2004-08-09', 'Male', 'manoj17@gmail.com', '9876543226', '9876500017', 'Ellisbridge', 'Ahmedabad', 'Gujarat', '380017', 'Indian', '123456789117', 'A+', '2024-06-17', 'Active', 'manoj.jpg'),

('STU018', 'Nikita', 'Saxena', '2003-03-12', 'Female', 'nikita18@gmail.com', '9876543227', '9876500018', 'Ranip', 'Ahmedabad', 'Gujarat', '380018', 'Indian', '123456789118', 'B+', '2024-06-18', 'Active', 'nikita.jpg'),

('STU019', 'Harsh', 'Pandey', '2004-11-23', 'Male', 'harsh19@gmail.com', '9876543228', '9876500019', 'Shahibaug', 'Ahmedabad', 'Gujarat', '380019', 'Indian', '123456789119', 'O+', '2024-06-19', 'Active', 'harsh.jpg'),

('STU020', 'Muskan', 'Agarwal', '2003-02-14', 'Female', 'muskan20@gmail.com', '9876543229', '9876500020', 'Prahladnagar', 'Ahmedabad', 'Gujarat', '380020', 'Indian', '123456789120', 'AB+', '2024-06-20', 'Active', 'muskan.jpg');
