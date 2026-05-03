import { useState, useEffect } from 'react';
import axios from 'axios';

const Courses = () => {
  const [courses, setCourses] = useState([]);
  const [loading, setLoading] = useState(true);
  const [showModal, setShowModal] = useState(false);

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
      }
    } catch (err) {
      console.error('Error fetching courses', err);
      // Fallback
      setCourses([
        { course_id: 1, course_code: 'CS101', course_name: 'Computer Science', credits: 4, status: 'Active' },
        { course_id: 2, course_code: 'MATH202', course_name: 'Mathematics', credits: 3, status: 'Active' }
      ]);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div>
      <div className="page-header">
        <h1 className="page-title">Course Management</h1>
        <button className="btn btn-primary" onClick={() => setShowModal(true)}>+ Add New Course</button>
      </div>

      <div className="card">
        <div className="table-container">
          {loading ? (
            <p>Loading courses...</p>
          ) : (
            <table className="data-table">
              <thead>
                <tr>
                  <th>Code</th>
                  <th>Course Name</th>
                  <th>Credits</th>
                  <th>Status</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                {courses.map(course => (
                  <tr key={course.course_id}>
                    <td><strong>{course.course_code}</strong></td>
                    <td>{course.course_name}</td>
                    <td>{course.credits || 4}</td>
                    <td>
                      <span className={`status-badge status-${course.status?.toLowerCase() || 'active'}`}>
                        {course.status || 'Active'}
                      </span>
                    </td>
                    <td>
                      <button className="btn" style={{ padding: '0.25rem 0.5rem', marginRight: '0.5rem' }}>✏️</button>
                      <button className="btn btn-danger" style={{ padding: '0.25rem 0.5rem', color: 'white' }}>🗑️</button>
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
          <div className="card" style={{ width: '400px' }}>
            <h2 className="mb-2">Add New Course</h2>
            <div className="form-group">
              <label className="form-label">Course Name</label>
              <input type="text" className="form-control" placeholder="e.g. Data Structures" />
            </div>
            <div className="form-group">
              <label className="form-label">Course Code</label>
              <input type="text" className="form-control" placeholder="e.g. CS202" />
            </div>
            <div style={{ display: 'flex', gap: '1rem', marginTop: '1rem' }}>
              <button className="btn btn-primary" style={{ flex: 1 }}>Save Course</button>
              <button className="btn" style={{ flex: 1, backgroundColor: 'var(--gray-color)' }} onClick={() => setShowModal(false)}>Cancel</button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default Courses;
