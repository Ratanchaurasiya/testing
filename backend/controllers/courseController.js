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


exports.createCourse = async (req, res) => {
  const { course_name, course_code, credits } = req.body;
  try {
    const [result] = await pool.query(
      'INSERT INTO Courses (course_name, course_code, credits) VALUES (?, ?, ?)',
      [course_name, course_code, credits || 3]
    );
    res.status(201).json({ 
      status: 'success', 
      message: 'Course added successfully',
      course_id: result.insertId 
    });
  } catch (error) {
    console.error('Error creating course:', error);
    res.status(500).json({ status: 'error', message: 'Failed to create course' });
  }
};
