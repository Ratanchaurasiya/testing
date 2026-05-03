import { useState, useEffect } from 'react';
import axios from 'axios';
import { downloadCSV } from '../utils/downloadHelper';

const Fees = () => {
  const [fees, setFees] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchFees();
  }, []);

  const fetchFees = async () => {
    try {
      const token = localStorage.getItem('token');
      const config = token ? { headers: { Authorization: `Bearer ${token}` } } : {};
      const res = await axios.get('http://localhost:5000/api/fees', config);
      if (res.data.status === 'success') {
        setFees(res.data.data);
      }
    } catch (err) {
      console.error('Error fetching fees', err);
      // Fallback dummy data
      setFees([
        { fee_id: 1, first_name: 'John', last_name: 'Doe', student_roll_no: 'STU001', total_amount: 5000, amount_paid: 3500, payment_status: 'Partial', due_date: '2024-12-01' },
        { fee_id: 2, first_name: 'Rahul', last_name: 'Verma', student_roll_no: 'STU003', total_amount: 5000, amount_paid: 5000, payment_status: 'Paid', due_date: '2024-11-15' }
      ]);
    } finally {
      setLoading(false);
    }
  };

  const downloadReceipt = (fee) => {
    const receiptData = [{
       Receipt_No: `REC-${fee.fee_id}`,
       Student: `${fee.first_name} ${fee.last_name}`,
       Roll_No: fee.student_roll_no,
       Total_Fee: fee.total_amount,
       Amount_Paid: fee.amount_paid,
       Status: fee.payment_status,
       Date: new Date().toLocaleDateString()
    }];
    downloadCSV(receiptData, `Receipt_${fee.student_roll_no}`);
  };

  const handleEdit = async (feeId, currentPaid) => {
    const newAmount = prompt("Enter new amount paid:", currentPaid);
    if (newAmount === null) return;
    
    try {
      const token = localStorage.getItem('token');
      const config = token ? { headers: { Authorization: `Bearer ${token}` } } : {};
      await axios.put(`http://localhost:5000/api/fees/${feeId}`, {
        amount_paid: newAmount,
        payment_status: Number(newAmount) >= 5000 ? 'Paid' : 'Partial'
      }, config);
      fetchFees();
      alert("Payment updated!");
    } catch (err) {
      alert("Failed to update payment");
    }
  };

  return (
    <div>
      <div className="page-header">
        <h1 className="page-title">Fee Management</h1>
        <div style={{ display: 'flex', gap: '1rem' }}>
          <button className="btn" style={{ backgroundColor: 'var(--white)', border: '1px solid var(--gray-color)' }} onClick={() => downloadCSV(fees, 'Fees_Summary')}>Download Summary</button>
          <button className="btn btn-primary">+ Collect Fee</button>
        </div>
      </div>

      <div className="stats-grid">
        <div className="stat-card success">
          <div className="stat-icon">💰</div>
          <div className="stat-details">
            <h3>Total Collected</h3>
            <p>$125,400</p>
          </div>
        </div>
        <div className="stat-card danger">
          <div className="stat-icon">⚠️</div>
          <div className="stat-details">
            <h3>Pending Dues</h3>
            <p>$12,450</p>
          </div>
        </div>
      </div>

      <div className="card">
        <h2 className="chart-title">Payment History</h2>
        <div className="table-container">
          {loading ? (
            <p>Loading fees...</p>
          ) : (
            <table className="data-table">
              <thead>
                <tr>
                  <th>Roll No</th>
                  <th>Student Name</th>
                  <th>Total</th>
                  <th>Paid</th>
                  <th>Status</th>
                  <th>Due Date</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                {fees.map(fee => (
                  <tr key={fee.fee_id}>
                    <td>{fee.student_roll_no}</td>
                    <td>{fee.first_name} {fee.last_name}</td>
                    <td>${fee.total_amount}</td>
                    <td>${fee.amount_paid}</td>
                    <td>
                      <span className={`status-badge status-${fee.payment_status.toLowerCase() === 'paid' ? 'active' : fee.payment_status.toLowerCase() === 'partial' ? 'pending' : 'inactive'}`}>
                        {fee.payment_status}
                      </span>
                    </td>
                    <td>{new Date(fee.due_date).toLocaleDateString()}</td>
                    <td>
                      <button className="btn" style={{ padding: '0.25rem 0.5rem', marginRight: '0.5rem', backgroundColor: 'var(--primary-color)', color: 'white' }} onClick={() => downloadReceipt(fee)}>Receipt</button>
                      <button className="btn" style={{ padding: '0.25rem 0.5rem', border: '1px solid var(--gray-color)' }} onClick={() => handleEdit(fee.fee_id, fee.amount_paid)}>✏️</button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
        </div>
      </div>
    </div>
  );
};

export default Fees;
