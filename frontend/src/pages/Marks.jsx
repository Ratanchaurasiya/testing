import { useState, useEffect } from 'react';
import axios from 'axios';

const Marks = () => {
  const [students, setStudents] = useState([]);
  const [selectedStudent, setSelectedStudent] = useState('');
  const [semester, setSemester] = useState('Fall 2024');
  const [courses, setCourses] = useState([]);
  const [marks, setMarks] = useState({}); // { course_id: marks }
  const [loading, setLoading] = useState(false);
  const [message, setMessage] = useState('');

  useEffect(() => {
    fetchInitialData();
  }, []);

  const fetchInitialData = async () => {
    try {
      const token = localStorage.getItem('token');
      const config = token ? { headers: { Authorization: `Bearer ${token}` } } : {};
      
      const [stuRes, courseRes] = await Promise.all([
        axios.get('https://testing-backend-8k3h.onrender.com', config),
        axios.get('https://testing-backend-8k3h.onrender.com/api/courses', config)
      ]);
      
      setStudents(stuRes.data.data);
      setCourses(courseRes.data.data);
    } catch (err) {
      console.error('Failed to fetch data', err);
    }
  };

  const handleSaveMarks = async () => {
    if (!selectedStudent) return alert('Please select a student');
    setLoading(true);
    try {
      const token = localStorage.getItem('token');
      const config = token ? { headers: { Authorization: `Bearer ${token}` } } : {};
      
      // Save each mark entry
      const promises = Object.entries(marks).map(([course_id, score]) => {
        return axios.post('https://testing-backend-8k3h.onrender.com/api/marks', {
          student_id: selectedStudent,
          course_id,
          marks_obtained: score,
          semester
        }, config);
      });
    
      await Promise.all(promises);
      setMessage('Marks saved successfully!');
      setTimeout(() => setMessage(''), 3000);
    } catch (err) {
      alert('Failed to save marks');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div>
      <div className="page-header">
        <h1 className="page-title">Manage Student Marks</h1>
      </div>

      <div className="card">
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: '1rem', marginBottom: '2rem' }}>
          <div className="form-group">
            <label className="form-label">Select Student</label>
            <select className="form-control" value={selectedStudent} onChange={(e) => setSelectedStudent(e.target.value)}>
              <option value="">-- Select Student --</option>
              {students.map(s => <option key={s.student_id} value={s.student_id}>{s.first_name} {s.last_name} ({s.student_roll_no})</option>)}
            </select>
          </div>
          <div className="form-group">
            <label className="form-label">Semester</label>
            <select className="form-control" value={semester} onChange={(e) => setSemester(e.target.value)}>
              <option value="Fall 2024">Fall 2024</option>
              <option value="Spring 2025">Spring 2025</option>
              <option value="Fall 2025">Fall 2025</option>
            </select>
          </div>
        </div>

        {selectedStudent && (
          <div className="table-container">
            <table className="data-table">
              <thead>
                <tr>
                  <th>Subject Code</th>
                  <th>Subject Name</th>
                  <th>Marks Obtained (Max 100)</th>
                </tr>
              </thead>
              <tbody>
                {courses.map(course => (
                  <tr key={course.course_id}>
                    <td>{course.course_code}</td>
                    <td>{course.course_name}</td>
                    <td>
                      <input 
                        type="number" 
                        className="form-control" 
                        style={{ width: '100px' }} 
                        max="100"
                        onChange={(e) => setMarks({...marks, [course.course_id]: e.target.value})}
                      />
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
            <div style={{ marginTop: '2rem' }}>
              <button className="btn btn-primary" onClick={handleSaveMarks} disabled={loading}>
                {loading ? 'Saving...' : 'Save All Marks'}
              </button>
              {message && <span style={{ marginLeft: '1rem', color: 'var(--success-color)' }}>{message}</span>}
            </div>
          </div>
        )}
      </div>
    </div>
  );
};

export default Marks;
