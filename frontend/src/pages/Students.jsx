import { useState, useEffect } from 'react';
import axios from 'axios';

const Students = () => {
  const [students, setStudents] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchStudents();
  }, []);

  const fetchStudents = async () => {
    try {
      // In a real app, we'd pass the token here
      const token = localStorage.getItem('token');
      const config = token ? { headers: { Authorization: `Bearer ${token}` } } : {};
      
      const response = await axios.get('http://localhost:5000/api/students', config);
      if (response.data.status === 'success') {
        setStudents(response.data.data);
      }
    } catch (error) {
      console.error('Failed to fetch students', error);
      // Fallback dummy data if backend is not running or DB is empty
      setStudents([
        { student_id: 1, student_roll_no: 'STU001', first_name: 'Rahul', last_name: 'Sharma', email: 'rahul@example.com', status: 'Active' },
        { student_id: 2, student_roll_no: 'STU002', first_name: 'Priya', last_name: 'Patel', email: 'priya@example.com', status: 'Active' }
      ]);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div>
      <div className="page-header">
        <h1 className="page-title">Students Management</h1>
        <button className="btn btn-primary">+ Add New Student</button>
      </div>

      <div className="card">
        <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '1.5rem' }}>
          <input type="text" className="form-control" placeholder="Search students..." style={{ width: '300px' }} />
          <div style={{ display: 'flex', gap: '1rem' }}>
            <button className="btn" style={{ border: '1px solid var(--gray-color)' }}>Filter</button>
            <button className="btn" style={{ border: '1px solid var(--gray-color)' }}>Export</button>
          </div>
        </div>

        <div className="table-container">
          {loading ? (
            <div className="text-center" style={{ padding: '2rem' }}>Loading students...</div>
          ) : (
            <table className="data-table">
              <thead>
                <tr>
                  <th>Roll No</th>
                  <th>Name</th>
                  <th>Email</th>
                  <th>Status</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                {students.map(student => (
                  <tr key={student.student_id}>
                    <td>{student.student_roll_no}</td>
                    <td>{student.first_name} {student.last_name}</td>
                    <td>{student.email}</td>
                    <td>
                      <span className={`status-badge status-${student.status.toLowerCase()}`}>
                        {student.status}
                      </span>
                    </td>
                    <td>
                      <button className="btn" style={{ padding: '0.25rem 0.5rem', marginRight: '0.5rem', backgroundColor: 'var(--gray-color)' }}>✏️</button>
                      <button className="btn" style={{ padding: '0.25rem 0.5rem', backgroundColor: 'var(--danger-color)', color: 'white' }}>🗑️</button>
                    </td>
                  </tr>
                ))}
                {students.length === 0 && (
                  <tr>
                    <td colSpan="5" className="text-center">No students found.</td>
                  </tr>
                )}
              </tbody>
            </table>
          )}
        </div>
      </div>
    </div>
  );
};

export default Students;
