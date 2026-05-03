import { useState, useEffect } from 'react';
import axios from 'axios';

const Attendance = () => {
  const [courses, setCourses] = useState([]);
  const [selectedCourse, setSelectedCourse] = useState('');
  const [attendanceDate, setAttendanceDate] = useState(new Date().toISOString().split('T')[0]);
  const [students, setStudents] = useState([]);
  const [loading, setLoading] = useState(false);
  const [message, setMessage] = useState('');

  useEffect(() => {
    fetchCourses();
  }, []);

  const fetchCourses = async () => {
    try {
      const token = localStorage.getItem('token');
      const config = token ? { headers: { Authorization: `Bearer ${token}` } } : {};
      const res = await axios.get('http://localhost:5000/api/courses', config);
      if (res.data.status === 'success') {
        setCourses(res.data.data);
        if (res.data.data.length > 0) {
          setSelectedCourse(res.data.data[0].course_id);
        }
      }
    } catch (err) {
      console.error('Error fetching courses', err);
      // Dummy data for demo if DB empty or error
      setCourses([{ course_id: 1, course_name: 'Computer Science 101' }, { course_id: 2, course_name: 'Mathematics 202' }]);
      setSelectedCourse(1);
    }
  };

  const fetchAttendance = async () => {
    if (!selectedCourse) return;
    setLoading(true);
    setMessage('');
    try {
      const token = localStorage.getItem('token');
      const config = token ? { headers: { Authorization: `Bearer ${token}` } } : {};
      const res = await axios.get(`http://localhost:5000/api/attendance?course_id=${selectedCourse}&date=${attendanceDate}`, config);
      if (res.data.status === 'success') {
        setStudents(res.data.data);
      }
    } catch (err) {
      console.error('Error fetching attendance', err);
      // Fallback dummy data
      setStudents([
        { student_id: 1, student_roll_no: 'STU001', first_name: 'Rahul', last_name: 'Sharma', status: 'Not Marked' },
        { student_id: 2, student_roll_no: 'STU002', first_name: 'Priya', last_name: 'Patel', status: 'Present' }
      ]);
    } finally {
      setLoading(false);
    }
  };

  const markStatus = async (studentId, status) => {
    try {
      const token = localStorage.getItem('token');
      const config = token ? { headers: { Authorization: `Bearer ${token}` } } : {};
      const payload = {
        student_id: studentId,
        course_id: selectedCourse,
        attendance_date: attendanceDate,
        status: status,
        remarks: ''
      };
      await axios.post('http://localhost:5000/api/attendance/mark', payload, config);
      
      // Update local state
      setStudents(students.map(s => s.student_id === studentId ? { ...s, status } : s));
      setMessage('Attendance updated');
      setTimeout(() => setMessage(''), 3000);
    } catch (err) {
      console.error('Failed to mark attendance', err);
      setMessage('Failed to update attendance');
    }
  };

  return (
    <div>
      <div className="page-header">
        <h1 className="page-title">Mark Attendance</h1>
      </div>

      <div className="card">
        <div style={{ display: 'flex', gap: '1rem', marginBottom: '2rem', alignItems: 'flex-end' }}>
          <div className="form-group" style={{ marginBottom: 0, flex: 1 }}>
            <label className="form-label">Course</label>
            <select 
              className="form-control" 
              value={selectedCourse} 
              onChange={(e) => setSelectedCourse(e.target.value)}
            >
              {courses.map(c => (
                <option key={c.course_id} value={c.course_id}>{c.course_name}</option>
              ))}
            </select>
          </div>
          <div className="form-group" style={{ marginBottom: 0, flex: 1 }}>
            <label className="form-label">Date</label>
            <input 
              type="date" 
              className="form-control" 
              value={attendanceDate}
              onChange={(e) => setAttendanceDate(e.target.value)}
            />
          </div>
          <button className="btn btn-primary" onClick={fetchAttendance} disabled={loading}>
            {loading ? 'Loading...' : 'Fetch Students'}
          </button>
        </div>

        {message && <div style={{ marginBottom: '1rem', color: 'var(--success-color)', fontWeight: 'bold' }}>{message}</div>}

        <div className="table-container">
          <table className="data-table">
            <thead>
              <tr>
                <th>Roll No</th>
                <th>Name</th>
                <th>Current Status</th>
                <th>Mark Attendance</th>
              </tr>
            </thead>
            <tbody>
              {students.map(student => (
                <tr key={student.student_id}>
                  <td>{student.student_roll_no}</td>
                  <td>{student.first_name} {student.last_name}</td>
                  <td>
                    <span className={`status-badge ${student.status === 'Present' ? 'status-active' : student.status === 'Absent' ? 'status-inactive' : 'status-pending'}`}>
                      {student.status}
                    </span>
                  </td>
                  <td>
                    <button 
                      className="btn" 
                      style={{ padding: '0.25rem 0.5rem', marginRight: '0.5rem', backgroundColor: student.status === 'Present' ? 'var(--success-color)' : 'var(--gray-color)', color: student.status === 'Present' ? 'white' : 'black' }}
                      onClick={() => markStatus(student.student_id, 'Present')}
                    >
                      Present
                    </button>
                    <button 
                      className="btn" 
                      style={{ padding: '0.25rem 0.5rem', marginRight: '0.5rem', backgroundColor: student.status === 'Absent' ? 'var(--danger-color)' : 'var(--gray-color)', color: student.status === 'Absent' ? 'white' : 'black' }}
                      onClick={() => markStatus(student.student_id, 'Absent')}
                    >
                      Absent
                    </button>
                    <button 
                      className="btn" 
                      style={{ padding: '0.25rem 0.5rem', backgroundColor: student.status === 'Late' ? 'var(--warning-color)' : 'var(--gray-color)', color: student.status === 'Late' ? 'white' : 'black' }}
                      onClick={() => markStatus(student.student_id, 'Late')}
                    >
                      Late
                    </button>
                  </td>
                </tr>
              ))}
              {students.length === 0 && !loading && (
                <tr>
                  <td colSpan="4" className="text-center">Select a course and date to view students.</td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
};

export default Attendance;
