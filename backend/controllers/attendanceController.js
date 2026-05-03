const pool = require('../config/database');

// Mark attendance for a student or update if exists
exports.markAttendance = async (req, res) => {
  try {
    const { student_id, course_id, attendance_date, status, remarks } = req.body;
    
    // The marked_by would ideally come from the logged-in user (req.user.username)
    const marked_by = req.user ? req.user.email : 'Admin';

    // Insert or update on duplicate key
    const query = `
      INSERT INTO Attendance (student_id, course_id, attendance_date, status, marked_by, remarks)
      VALUES (?, ?, ?, ?, ?, ?)
      ON DUPLICATE KEY UPDATE 
      status = VALUES(status), 
      remarks = VALUES(remarks),
      marked_by = VALUES(marked_by)
    `;

    await pool.query(query, [student_id, course_id, attendance_date, status, marked_by, remarks]);

    res.status(200).json({ status: 'success', message: 'Attendance marked successfully' });
  } catch (error) {
    console.error('Error marking attendance:', error);
    res.status(500).json({ status: 'error', message: 'Failed to mark attendance' });
  }
};

// Get attendance for a specific course and date
exports.getAttendanceByDate = async (req, res) => {
  try {
    const { course_id, date } = req.query;

    if (!course_id || !date) {
      return res.status(400).json({ status: 'error', message: 'course_id and date are required' });
    }

    const query = `
      SELECT 
        s.student_id, 
        s.student_roll_no, 
        s.first_name, 
        s.last_name,
        COALESCE(a.status, 'Not Marked') as status,
        a.remarks
      FROM Students s
      JOIN Enrollments e ON s.student_id = e.student_id
      LEFT JOIN Attendance a ON s.student_id = a.student_id AND a.course_id = ? AND a.attendance_date = ?
      WHERE e.course_id = ? AND s.status = 'Active'
      ORDER BY s.student_roll_no
    `;

    const [rows] = await pool.query(query, [course_id, date, course_id]);
    res.status(200).json({ status: 'success', data: rows });
  } catch (error) {
    console.error('Error fetching attendance:', error);
    res.status(500).json({ status: 'error', message: 'Failed to fetch attendance' });
  }
};

// Get student's attendance history (for student view)
exports.getStudentAttendance = async (req, res) => {
  try {
    const { student_id } = req.params;
    
    const query = `
      SELECT a.attendance_date, a.status, c.course_name 
      FROM Attendance a
      JOIN Courses c ON a.course_id = c.course_id
      WHERE a.student_id = ?
      ORDER BY a.attendance_date DESC
    `;
    
    const [rows] = await pool.query(query, [student_id]);
    res.status(200).json({ status: 'success', data: rows });
  } catch (error) {
    console.error('Error fetching student attendance:', error);
    res.status(500).json({ status: 'error', message: 'Failed to fetch attendance history' });
  }
};
