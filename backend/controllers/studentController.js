const pool = require('../config/database');

// Get all students
exports.getAllStudents = async (req, res) => {
  try {
    const [rows] = await pool.query(`
      SELECT student_id, student_roll_no, first_name, last_name, email, phone, status, enrollment_date 
      FROM Students 
      ORDER BY student_id DESC
    `);
    res.status(200).json({ status: 'success', data: rows });
  } catch (error) {
    console.error('Error fetching students:', error);
    res.status(500).json({ status: 'error', message: 'Failed to fetch students' });
  }
};

// Get student by ID
exports.getStudentById = async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT * FROM Students WHERE student_id = ?', [req.params.id]);
    if (rows.length === 0) {
      return res.status(404).json({ status: 'error', message: 'Student not found' });
    }
    res.status(200).json({ status: 'success', data: rows[0] });
  } catch (error) {
    console.error('Error fetching student:', error);
    res.status(500).json({ status: 'error', message: 'Failed to fetch student' });
  }
};

// Create a new student (using stored procedure)
exports.createStudent = async (req, res) => {
  try {
    const { first_name, last_name, dob, gender, email, phone, address, city, state, pincode, blood_group, aadhar } = req.body;
    
    // Using the AddNewStudent stored procedure created in the schema
    await pool.query(
      'CALL AddNewStudent(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
      [first_name, last_name, dob, gender, email, phone, address, city, state, pincode, blood_group, aadhar]
    );
    
    res.status(201).json({ status: 'success', message: 'Student created successfully' });
  } catch (error) {
    console.error('Error creating student:', error);
    // Handle specific SQL errors (like duplicate email)
    if (error.sqlState === '45000') {
      return res.status(400).json({ status: 'error', message: error.message });
    }
    res.status(500).json({ status: 'error', message: 'Failed to create student' });
  }
};

// Update student
exports.updateStudent = async (req, res) => {
  try {
    const studentId = req.params.id;
    const { first_name, last_name, gender, phone, address, city, state, pincode, status } = req.body;
    
    await pool.query(
      `UPDATE Students 
       SET first_name=?, last_name=?, gender=?, phone=?, address=?, city=?, state=?, pincode=?, status=? 
       WHERE student_id=?`,
      [first_name, last_name, gender, phone, address, city, state, pincode, status, studentId]
    );
    
    res.status(200).json({ status: 'success', message: 'Student updated successfully' });
  } catch (error) {
    console.error('Error updating student:', error);
    res.status(500).json({ status: 'error', message: 'Failed to update student' });
  }
};

// Delete student (Soft Delete)
exports.deleteStudent = async (req, res) => {
  try {
    await pool.query('UPDATE Students SET status = "Inactive" WHERE student_id = ?', [req.params.id]);
    res.status(200).json({ status: 'success', message: 'Student marked as inactive' });
  } catch (error) {
    console.error('Error deleting student:', error);
    res.status(500).json({ status: 'error', message: 'Failed to delete student' });
  }
};
