import { useState, useEffect } from 'react';
import axios from 'axios';

const Students = () => {
  const [students, setStudents] = useState([]);
  const [loading, setLoading] = useState(true);
  const [showModal, setShowModal] = useState(false);
  const [formData, setFormData] = useState({
    first_name: '',
    last_name: '',
    email: '',
    phone: '',
    student_roll_no: '',
    dob: '',
    gender: 'Male',
    address: '',
    city: '',
    state: '',
    pincode: ''
  });

  useEffect(() => {
    fetchStudents();
  }, []);

  const fetchStudents = async () => {
    try {
      const token = localStorage.getItem('token');
      const config = token ? { headers: { Authorization: `Bearer ${token}` } } : {};
      const response = await axios.get('https://testing-backend-8k3h.onrender.com/api/students', config);
      if (response.data.status === 'success') {
        setStudents(response.data.data);
      }
    } catch (error) {
      console.error('Failed to fetch students', error);
    } finally {
      setLoading(false);
    }
  };

  const handleSave = async (e) => {
    e.preventDefault();
    try {
      const token = localStorage.getItem('token');
      const config = token ? { headers: { Authorization: `Bearer ${token}` } } : {};
      const res = await axios.post('https://testing-backend-8k3h.onrender.com/api/students', formData, config);
      if (res.data.status === 'success') {
        setShowModal(false);
        setFormData({ first_name: '', last_name: '', email: '', phone: '', student_roll_no: '', dob: '', gender: 'Male', address: '', city: '', state: '', pincode: '' });
        fetchStudents();
        alert('Student added with full details successfully!');
      }
    } catch (err) {
      alert('Failed to add student');
    }
  };

  return (
    <div>
      <div className="page-header">
        <h1 className="page-title">Students Management</h1>
        <button className="btn btn-primary" onClick={() => setShowModal(true)}>+ Add New Student</button>
      </div>

      <div className="card">
        <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '1.5rem' }}>
          <input type="text" className="form-control" placeholder="Search students..." style={{ width: '300px' }} />
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
                      <span className={`status-badge status-${student.status?.toLowerCase() || 'active'}`}>
                        {student.status || 'Active'}
                      </span>
                    </td>
                    <td>
                      <button className="btn" style={{ padding: '0.25rem 0.5rem', marginRight: '0.5rem', backgroundColor: 'var(--gray-color)' }}>✏️ View/Edit</button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
        </div>
      </div>

      {showModal && (
        <div style={{ position: 'fixed', top: 0, left: 0, width: '100%', height: '100%', backgroundColor: 'rgba(0,0,0,0.5)', display: 'flex', justifyContent: 'center', alignItems: 'center', zIndex: 2000 }}>
          <div className="card" style={{ width: '700px', maxHeight: '90vh', overflowY: 'auto' }}>
            <h2 className="mb-2">Add New Student (Full Details)</h2>
            <form onSubmit={handleSave}>
              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '1rem' }}>
                <div className="form-group">
                  <label className="form-label">First Name</label>
                  <input type="text" className="form-control" required value={formData.first_name} onChange={(e) => setFormData({...formData, first_name: e.target.value})} />
                </div>
                <div className="form-group">
                  <label className="form-label">Last Name</label>
                  <input type="text" className="form-control" required value={formData.last_name} onChange={(e) => setFormData({...formData, last_name: e.target.value})} />
                </div>
                <div className="form-group">
                  <label className="form-label">Email</label>
                  <input type="email" className="form-control" required value={formData.email} onChange={(e) => setFormData({...formData, email: e.target.value})} />
                </div>
                <div className="form-group">
                  <label className="form-label">Phone</label>
                  <input type="text" className="form-control" value={formData.phone} onChange={(e) => setFormData({...formData, phone: e.target.value})} />
                </div>
                <div className="form-group">
                  <label className="form-label">Date of Birth</label>
                  <input type="date" className="form-control" value={formData.dob} onChange={(e) => setFormData({...formData, dob: e.target.value})} />
                </div>
                <div className="form-group">
                  <label className="form-label">Gender</label>
                  <select className="form-control" value={formData.gender} onChange={(e) => setFormData({...formData, gender: e.target.value})}>
                    <option value="Male">Male</option>
                    <option value="Female">Female</option>
                    <option value="Other">Other</option>
                  </select>
                </div>
                <div className="form-group" style={{ gridColumn: 'span 2' }}>
                  <label className="form-label">Address</label>
                  <input type="text" className="form-control" value={formData.address} onChange={(e) => setFormData({...formData, address: e.target.value})} />
                </div>
                <div className="form-group">
                  <label className="form-label">City</label>
                  <input type="text" className="form-control" value={formData.city} onChange={(e) => setFormData({...formData, city: e.target.value})} />
                </div>
                <div className="form-group">
                  <label className="form-label">Roll Number</label>
                  <input type="text" className="form-control" required value={formData.student_roll_no} onChange={(e) => setFormData({...formData, student_roll_no: e.target.value})} />
                </div>
              </div>
              <div style={{ display: 'flex', gap: '1rem', marginTop: '1.5rem' }}>
                <button type="submit" className="btn btn-primary" style={{ flex: 1 }}>Save Full Profile</button>
                <button type="button" className="btn" style={{ flex: 1, backgroundColor: 'var(--gray-color)' }} onClick={() => setShowModal(false)}>Cancel</button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};

export default Students;
