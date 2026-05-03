const pool = require('../config/database');

exports.saveMarks = async (req, res) => {
  const { student_id, course_id, marks_obtained, semester } = req.body;
  try {
    // Insert or update result
    const query = `
      INSERT INTO Results (student_id, course_id, marks_obtained, semester, percentage, grade)
      VALUES (?, ?, ?, ?, ?, ?)
      ON DUPLICATE KEY UPDATE 
      marks_obtained = VALUES(marks_obtained),
      percentage = VALUES(percentage),
      grade = VALUES(grade)
    `;
    
    // Simple calculation for grade/percentage
    const percentage = marks_obtained;
    const grade = percentage >= 90 ? 'O' : percentage >= 80 ? 'A' : percentage >= 70 ? 'B' : 'C';

    await pool.query(query, [student_id, course_id, marks_obtained, semester, percentage, grade]);
    
    res.status(200).json({ status: 'success', message: 'Marks updated successfully' });
  } catch (error) {
    console.error('Error saving marks:', error);
    res.status(500).json({ status: 'error', message: 'Failed to save marks' });
  }
};

exports.getStudentResults = async (req, res) => {
  try {
    const { student_id } = req.query;
    const [rows] = await pool.query(`
      SELECT r.*, c.course_name, c.course_code 
      FROM Results r
      JOIN Courses c ON r.course_id = c.course_id
      WHERE r.student_id = ?
      ORDER BY r.semester DESC
    `, [student_id]);
    res.status(200).json({ status: 'success', data: rows });
  } catch (error) {
    console.error('Error fetching results:', error);
    res.status(500).json({ status: 'error', message: 'Failed to fetch results' });
  }
};
