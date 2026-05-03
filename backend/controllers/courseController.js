const pool = require('../config/database');

exports.getAllCourses = async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT course_id, course_name, course_code FROM Courses WHERE status = "Active"');
    res.status(200).json({ status: 'success', data: rows });
  } catch (error) {
    console.error('Error fetching courses:', error);
    res.status(500).json({ status: 'error', message: 'Failed to fetch courses' });
  }
};
