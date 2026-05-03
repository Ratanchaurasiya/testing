const pool = require('../config/database');

exports.getAllFees = async (req, res) => {
  try {
    const [rows] = await pool.query(`
      SELECT f.fee_id, s.first_name, s.last_name, s.student_roll_no, f.amount_paid, f.total_amount, f.payment_status, f.due_date 
      FROM Fees f 
      JOIN Students s ON f.student_id = s.student_id
      ORDER BY f.due_date DESC
    `);
    res.status(200).json({ status: 'success', data: rows });
  } catch (error) {
    console.error('Error fetching fees:', error);
    res.status(500).json({ status: 'error', message: 'Failed to fetch fees' });
  }
};


exports.updateFee = async (req, res) => {
  const { id } = req.params;
  const { amount_paid, payment_status, remarks } = req.body;
  try {
    await pool.query(
      'UPDATE Fees SET amount_paid = ?, payment_status = ?, remarks = ? WHERE fee_id = ?',
      [amount_paid, payment_status, remarks, id]
    );
    res.status(200).json({ status: 'success', message: 'Fee record updated' });
  } catch (error) {
    console.error('Error updating fee:', error);
    res.status(500).json({ status: 'error', message: 'Failed to update fee' });
  }
};
